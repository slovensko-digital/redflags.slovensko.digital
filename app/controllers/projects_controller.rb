class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id]).revisions.last # TODO published revision
    @rating_types_by_phase = RatingType.all.group_by(&:rating_phase)
    @ratings_by_type = @project.ratings.index_by(&:rating_type)
  end
end
