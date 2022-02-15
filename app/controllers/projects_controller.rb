class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id]).published_revision
    @rating_types_by_phase = RatingType.all.group_by(&:rating_phase)
    @ratings_by_type = @project.ratings.index_by(&:rating_type)
    @metadata.og.title = @project.title
    @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'
  end

  def index
    @rating_types_by_phase = RatingType.all.group_by(&:rating_phase)
    @selected_tag = params[:tag]

    if ProjectsHelper::ALLOWED_TAGS.map { |tag, translated| tag }.include? params[:tag]
      @projects = Project.published.select {|p| p.published_revision.tags.include? params[:tag]}
        .map { |p| p.published_revision }.sort_by(&:aggregated_rating)
    
    else
      @projects = Project.published.map { |p| p.published_revision }.sort_by(&:aggregated_rating)
    
    end
  end
end
