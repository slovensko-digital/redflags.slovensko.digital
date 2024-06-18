class StaticController < ApplicationController
  def index
    top_project_revisions = ProjectRevision.where(published: true).joins(:revision).limit(5)

    @good_projects = top_project_revisions.where('revisions.redflags_count = ?', 0).order('revisions.total_score::float / revisions.maximum_score DESC')
    @bad_projects = top_project_revisions.order('revisions.redflags_count DESC, revisions.total_score::float / revisions.maximum_score ASC')
  end

  def about
    render_page :about
  end

  def about_rating
    render_page :about_rating
  end

  def contribute
    render_page :contribute
  end

  def faq
    render_page :faq
  end

  def stats
    render_page :stats
  end

  private

  def render_page(name)
    @page = Page.find(ENV.fetch("REDFLAGS_#{name.upcase}_PAGE_ID")).published_revision
    render 'page'
  end
end
