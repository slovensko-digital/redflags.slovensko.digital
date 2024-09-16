# == Schema Information
#
# Table name: metais.projects
#
#  id                    :integer          not null, primary key
#  code                  :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null

class Metais::Project < ApplicationRecord
  has_many :project_origins, :class_name => 'Metais::ProjectOrigin'
  has_and_belongs_to_many :projects, class_name: 'Project',
                                     join_table: 'public.projects_metais_projects',
                                     foreign_key: 'metais_project_id',
                                     association_foreign_key: 'project_id'

  def evaluations
    ::Project.joins('''
    INNER JOIN "public"."projects_metais_projects" ON "public"."projects_metais_projects"."project_id" = "projects"."id"
    INNER JOIN "metais"."projects" AS "metais_projects" ON "metais_projects"."id" = "public"."projects_metais_projects"."metais_project_id"
    ''').where('projects_metais_projects.metais_project_id = ?', self.id)
  end

  def get_project_origin_info
    fields = %w[title status phase description guarantor project_manager start_date end_date
                finance_source investment operation approved_investment approved_operation
                supplier supplier_cin targets_text events_text documents_text links_text]

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
  
  def self.evaluation_counts
    total_count = Metais::Project.count
    yes_count = Metais::Project
      .joins('INNER JOIN public.projects_metais_projects ON public.projects_metais_projects.metais_project_id = metais.projects.id')
      .distinct
      .count('metais.projects.id')
    no_count = total_count - yes_count
  
    { yes: yes_count, no: no_count }
  end
end
