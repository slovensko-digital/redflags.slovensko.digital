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
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  body_html      :string
#  total_score    :integer
#  maximum_score  :integer
#  redflags_count :integer          default(0)
#  summary        :text
#  recommendation :text
#
# Indexes
#
#  index_project_revisions_on_project_id   (project_id)
#  index_project_revisions_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (revision_id => revisions.id)
#

class ProjectRevision < ApplicationRecord
  belongs_to :project
  belongs_to :revision

  has_many :ratings, class_name: 'ProjectRevisionRating'

  delegate :category, to: :project
  delegate :version, to: :revision

  def total_score_percentage
    100.0 * total_score / maximum_score
  end

  def aggregated_rating
    [redflags_count, -total_score_percentage]
  end

  # TODO move elsewhere?
  def load_from_data(raw)
    self.title = raw['title'].gsub('Red Flags:', '').strip

    body = raw['post_stream']['posts'].first['cooked']
    summary, rest = body.split(/<h1>.+?<\/h1>/m, 2)

    self.body_html = rest

    load_metadata(summary)
    load_ratings(rest)
  end

  private

  def load_metadata(summary)
    doc = Nokogiri::HTML.parse(summary)
    doc.search('p').each do |p|
      type = p.search('strong').first.try(:text)
      value = p.text.gsub(type, '').strip if type
      case type
      when 'Názov:'
        self.full_name = value
      when 'Garant:'
        self.guarantor = value
      when 'Stručný opis:'
        self.description = value
      when 'Náklady na projekt:'
        self.budget = value
      when 'Aktuálny stav projektu:'
        self.status = value
      when 'Zhrnutie hodnotenia Red Flags:'
        self.summary = value
      when 'Stanovisko Slovensko.Digital:'
        self.recommendation = value
      end
    end
  end

  def load_ratings(body)
    redflags_count = 0
    total_score = 0
    maximum_score = 0
    current_phase = nil
    doc = Nokogiri::HTML.parse(body)
    doc.css('h2, h3').each do |heading|
      value = heading.text.strip
      case heading.name
      when 'h2'
        current_phase = RatingPhase.find_by(name: value)
      when 'h3'
        next unless current_phase
        rating_type = current_phase.rating_types.find_by(name: value)
        if rating_type
          score = heading.css('img.emoji[title=":star:"]').count
          bad_score = heading.css('img.emoji[title=":grey_star:"]').count
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
    self.maximum_score =  maximum_score
  end
end
