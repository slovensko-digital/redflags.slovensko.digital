class PhaseRevisionController < ApplicationController
  def show
    @project = Project.find_by!(id: params[:project_id])
    @phase_revision = PhaseRevision.find_published_revision(@project.id, params[:revision_type])

    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      render :show
    end
  end

  def pdf
    @project = Project.find_by!(id: params[:project_id])
    @phase_revision = PhaseRevision.find_published_revision(@project.id, params[:revision_type])

    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      render layout: "no_header_footer"
    end
  end

  def show_history
    @project = Project.find_by!(id: params[:project_id])
    @phase_revision = PhaseRevision.find_revision_history(@project.id, params[:revision_type], params[:version])

    if @phase_revision
      @revision = @phase_revision.revision
      @ratings_by_type = @phase_revision.ratings.index_by(&:rating_type)
      @metadata.og.title = @revision.title
      @metadata.og.description = 'Kolaboratívne hodnotenie projektu metodikou Red Flags.'

      render :show
    end
  end
end
