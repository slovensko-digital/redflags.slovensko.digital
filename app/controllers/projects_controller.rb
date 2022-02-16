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

    @projects = Project.published
    @projects = @projects.with_tag(params[:tag]) if ProjectsHelper::ALLOWED_TAGS.keys.include?(params[:tag])
    @projects = @projects.map { |p| p.published_revision }.sort_by(&:aggregated_rating)
  end
end
