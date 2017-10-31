# == Schema Information
#
# Table name: project_revisions
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  revision_id :integer          not null
#  title       :string           not null
#  full_name   :string
#  guarantor   :string
#  description :string
#  budget      :string
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  body_html   :string
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

      case type
      when 'Názov:'
        self.full_name = p.text.gsub(type, '').strip
      when 'Garant:'
        self.guarantor = p.text.gsub(type, '').strip
      when 'Stručný opis:'
        self.description = p.text.gsub(type, '').strip
      when 'Náklady na projekt:'
        self.budget = p.text.gsub(type, '').strip
      when 'Aktuálny stav projektu:'
        self.status = p.text.gsub(type, '').strip
      end
    end
  end

  def load_ratings(body)
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
          rating = self.ratings.find_or_initialize_by(rating_type: rating_type)
          rating.score = score
        end
      end
    end
  end
end
