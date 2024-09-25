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

    @assumption_events = []
    @real_events = []
    @project_origins.each do |project_origin|
      @assumption_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Predpoklad')))
      @real_events.concat(project_origin.events.where(event_type: Metais::ProjectEventType.find_by(name: 'Realita')))
    end
    @assumption_events.sort_by! { |event| event.date }
    @real_events.sort_by! { |event| event.date }

    @all_suppliers = []
    @project_origins.each do |project_origin|
      @all_suppliers.concat(project_origin.suppliers)
    end
    @all_suppliers.sort_by! { |event| event.date || Time.zone.parse('2999-12-31')}

    @all_links = []
    @project_origins.each do |project_origin|
      @all_links.concat(project_origin.links)
    end

    @all_documents = @project_origins.flat_map(&:documents)
    @grouped_documents = @all_documents.group_by(&:description)
    @grouped_documents = @grouped_documents.sort_by { |description, docs| docs.first.group_order || Float::INFINITY }

    @project_origin = @project.project_origins.first
    @project_origin = Metais::ProjectOrigin.includes(:documents, :suppliers).find(@project_origin.id)
  end
end
