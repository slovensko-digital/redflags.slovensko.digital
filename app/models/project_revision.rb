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

class ProjectRevision < ApplicationRecord
  belongs_to :project
  belongs_to :revision
  belongs_to :stage, class_name: 'ProjectStage', optional: true

  delegate :version, :tags, to: :revision

  scope :once_published, -> { where(was_published: true, published: false) }

  # TODO move elsewhere?
  def load_from_data(raw)
    self.title = raw['title'].gsub('Red Flags:', '').strip

    body = raw['post_stream']['posts'].first['cooked']
    summary, rest = body.split(/<h1>.+?<\/h1>/m, 2)

    self.body_html = rest

    load_metadata(summary)
  end

  def outdated?
    tags.include?('rf-outdated')
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

    doc.search('h3, p, ul, li').each do |element|
      if element.name == 'h3'
        current_label = element.text.strip.chomp(':').strip
      elsif element.name == 'p'
        strong_element = element.at('strong')
        if strong_element

          # Handling the <p><strong>...</strong> ... </p> format
          type = strong_element.text.strip.chomp(':')
          value = element.text.gsub(strong_element.text, '').strip
          if metadata_mapping.key?(type + ":")
            assign_value(metadata_mapping[type + ":"], value, element)
          end
        elsif current_label

          # Handling the <h3>...</h3> <p>...</p> format
            value = element.text.strip
            if metadata_mapping.key?(current_label + ":")
              assign_value(metadata_mapping[current_label + ":"], value, element)
            end
            current_label = nil
        end
=begin
      else
        puts "Here4"

        puts "Revision2 value:", element.text.strip
        value = element.text.strip
        if metadata_mapping.key?(current_label + ":")
          puts "Revision1 value:", metadata_mapping[current_label + ":"], value, element
          assign_value(metadata_mapping[current_label + ":"], value, element)
        end
        current_label = nil
=end
      end
    end
  end

  def assign_value(attribute, value, element)
    if attribute == :stage
      self.stage = ProjectStage.find_by(name: value)
    elsif attribute == :current_status
      # Initialize current_status_content with the provided value
      current_status_content = "<p>#{value}</p>"
      next_element = element.next_element

      # Keep appending the content of next elements while they are either <p> or <ul>
      while next_element && %w[ul p].include?(next_element.name)
        current_status_content += next_element.to_html
        next_element = next_element.next_element
      end

      # Strip and assign the final current_status_content
      self.current_status = current_status_content.strip
    else
      self.send("#{attribute}=", value)
    end
  end
end
