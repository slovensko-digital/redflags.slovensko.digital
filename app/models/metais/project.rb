# == Schema Information
#
# Table name: metais.projects
#
#  id                    :integer          not null, primary key
#  code                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::Project < ApplicationRecord
  self.table_name = "metais.projects"

  has_many :combined_projects, class_name: 'CombinedProject', foreign_key: 'metais_project_id'
  has_many :project_origins, :class_name => 'Metais::ProjectOrigin'

  def get_project_origin_info
    fields = %w[title status description guarantor project_manager start_date end_date
                finance_source investment operation approved_investment approved_operation
                supplier targets_text events_text documents_text links_text]

    origins = self.project_origins.sort_by { |origin| -origin.origin_type_id }

    project_info = OpenStruct.new
    fields.each do |field|
      origin = origins.detect { |origin| !origin.send(field).nil? }
      value = origin&.send(field)
      if value
        project_info.send("#{field}=", Metais::ValueWithOrigin.new(value, origin.origin_type_id))
      end
    end

    project_info
  end
end
