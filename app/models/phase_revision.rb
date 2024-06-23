# == Schema Information
#
# Table name: project_revisions
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  revision_id    :integer          not null
#  title          :string           not null
#  full_name      :string
#  guarantor      :string
#  description    :string
#  budget         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  body_html      :string
#  total_score    :integer
#  maximum_score  :integer
#  redflags_count :integer          default(0)
#  summary        :text
#  recommendation :text
#  stage_id       :integer
#  current_status :string
#  total_score    :integer
#  maximum_score  :integer
#  redflags_count :integer          default(0)
#  published      :boolean          default(false)
#  was_published  :boolean          default(false)
#  published_at   :datetime
#
# Indexes
#
#  index_project_revisions_on_project_id   (project_id)
#  index_project_revisions_on_revision_id  (revision_id)
#  index_project_revisions_on_stage_id     (stage_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (revision_id => revisions.id)
#  fk_rails_...  (stage_id => project_stages.id)
#

class PhaseRevision < ApplicationRecord
  belongs_to :phase
  belongs_to :revision
  belongs_to :stage, class_name: 'ProjectStage', optional: true

  has_many :ratings, class_name: 'PhaseRevisionRating'

  delegate :version, :tags, to: :revision

  scope :published, -> { where(published: true) }
  scope :once_published, -> { where(was_published: true, published: false) }

  ROUTE_MAP = {
    'Prípravná fáza' => 'hodnotenie-pripravy',
    'Fáza produkt' => 'hodnotenie-produktu'
  }.freeze

  def load_from_data(raw)
    self.title = raw['title'].gsub('Red Flags:', '').strip

    body = raw['post_stream']['posts'].first['cooked']
    summary, rest = body.split(/<h1>.+?<\/h1>/m, 2)

    self.body_html = rest

    load_metadata(summary)
    load_ratings(raw)
  end

  def outdated?
    tags.include?('rf-outdated')
  end

  def total_score_percentage
    100.0 * total_score / maximum_score
  end

  def aggregated_rating
    [redflags_count, -total_score_percentage]
  end

  private

  def load_metadata(summary)
    doc = Nokogiri::HTML.parse(summary)

    metadata_mapping = {
      "Názov:" => :full_name,
      "Garant:" => :guarantor,
      "Stručný opis:" => :description,
      "Náklady na projekt:" => :budget,
      "Aktuálny stav projektu:" => :stage,
      "Čo sa práve deje:" => :current_status,
      "Zhrnutie hodnotenia Red Flags:" => :summary,
      "Stanovisko Slovensko.Digital:" => :recommendation
    }

    current_label = nil
    current_status_content = ''
    collecting = false

    doc.search('h3, p, ul, li').each do |element|
      if element.name == 'h3'
        current_label = element.text.strip.chomp(':').strip

        if collecting
          assign_value(metadata_mapping["Čo sa práve deje:"], current_status_content)
          collecting = false
          current_status_content = ''
        end

        collecting = true if current_label == "Čo sa práve deje"
      end

      if collecting && %w[p ul].include?(element.name)
        current_status_content += element.to_html

      elsif element.name == 'p'
        strong_element = element.at('strong')
        if strong_element
          type = strong_element.text.strip.chomp(':')
          if type == "Čo sa práve deje"
            value = element.next_element.try(:to_html)
          else
            value = element.text.gsub(strong_element.text, '').strip
          end
          assign_value(metadata_mapping[type + ":"], value) if metadata_mapping.key?(type + ":")

        elsif current_label
          value = element.text.strip
          assign_value(metadata_mapping[current_label + ":"], value) if metadata_mapping.key?(current_label + ":")
          current_label = nil unless current_label == "Čo sa práve deje:"
        end
      end
    end

    if collecting && metadata_mapping.key?("Čo sa práve deje:")
      assign_value(metadata_mapping["Čo sa práve deje:"], current_status_content)
    end
  end

  def assign_value(attribute, value)
    if attribute == :stage
      self.stage = ProjectStage.find_by(name: value)
    else
      self.send("#{attribute}=", value)
    end
  end

  def load_ratings(raw)
    redflags_count = 0
    total_score = 0
    maximum_score = 0
    body = raw['post_stream']['posts'].first['cooked']
    summary, rest = body.split(/<h1>.+?<\/h1>/m, 2)

    doc = Nokogiri::HTML.parse(rest)
    doc.css('h3').each do |heading|
      value = heading.text.strip.gsub(/[^0-9A-Za-záäčďéíĺľňóôŕřšťúůýžÁÄČĎÉÍĹĽŇÓÔŔŘŠŤÚŮÝŽ(), ]/, '').strip
      rating_type = RatingType.find_by(name: value)
      if rating_type
        score = heading.css('img.emoji[title=":star:"]').count
        bad_score = heading.css('img.emoji[title=":grey_star:"]').count
        red_score = heading.css('img.emoji[title=":triangular_flag_on_post:"]').count
        if red_score > 0
          bad_score = 4
        end
        if score + bad_score > 0
          rating = self.ratings.find_or_initialize_by(rating_type: rating_type)
          rating.score = score
          redflags_count += 1 if bad_score == 4
          total_score += score
          maximum_score += 4
        end
      end
    end

    self.redflags_count = redflags_count
    self.total_score = total_score
    self.maximum_score = maximum_score
  end

  def self.map_phase_type_to_route(phase_type)
    ROUTE_MAP[phase_type] || phase_type
  end

  def self.find_published_revision(project_id, revision_type)
    phase_name = map_revision_type_to_phase_name(revision_type)
    joins(phase: { project: :phases })
      .where(projects: { id: project_id })
      .where(phases: { phase_type: PhaseType.find_by(name: phase_name) })
      .where(published: true)
      .first
  end

  def self.find_revision_history(project_id, revision_type, version)
    phase_name = map_revision_type_to_phase_name(revision_type)
    joins(phase: { project: :phases })
      .joins(:revision)
      .where(projects: { id: project_id })
      .where(phases: { phase_type: PhaseType.find_by(name: phase_name) })
      .where(revisions: { version: version })
      .first
  end

  private

  def self.map_revision_type_to_phase_name(revision_type)
    phase_type_map = {
      'hodnotenie-pripravy' => 'Prípravná fáza',
      'hodnotenie-produktu' => 'Fáza produkt'
    }
    phase_type_map[revision_type] || revision_type
  end
end
