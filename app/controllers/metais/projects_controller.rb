class Metais::ProjectsController < ApplicationController
  
  def index
    @guarantor_counts = Metais::ProjectOrigin.guarantor_counts
    @unique_guarantors = Metais::ProjectOrigin.unique_guarantors
    @status_counts = Metais::ProjectOrigin.status_counts
    @unique_statuses = Metais::ProjectOrigin.unique_statuses
    @evaluation_counts = Metais::Project.evaluation_counts
    
    @projects = Metais::Project.filtered_and_sorted_projects(params)
  end

  def show
    @project = Metais::Project.find(params[:id])
    @project_info = @project.get_project_origin_info
    @project_origins = @project.project_origins

    @assumption_events = @project_origins.flat_map { |project_origin| project_origin.events.assumpted }
    @real_events = @project_origins.flat_map { |project_origin| project_origin.events.real }

    @combined_suppliers = @project_origins.flat_map(&:suppliers).sort_by { |supplier| supplier.date || Time.zone.parse('2999-12-31') }
    @combined_links = @project_origins.flat_map(&:links)
    @combined_documents = @project_origins.flat_map(&:documents)

    @grouped_documents = @combined_documents.group_by(&:description).sort_by { |description, docs| docs.first.group_order || Float::INFINITY }
  end
end
