class StaticController < ApplicationController
  def index
    top_projects = Project.published.joins(:published_revision).limit(5)

    @good_projects = top_projects.good.order('redflags_count ASC, total_score::float / maximum_score DESC').map(&:published_revision)
    @bad_projects = top_projects.bad.order('redflags_count DESC, total_score::float / maximum_score ASC').map(&:published_revision)
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

  private

  def render_page(name)
    @page = Page.find(ENV.fetch("REDFLAGS_#{name.upcase}_PAGE_ID")).latest_revision
    render 'page'
  end
end
