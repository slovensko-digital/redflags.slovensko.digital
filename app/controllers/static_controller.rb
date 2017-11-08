class StaticController < ApplicationController
  def index
    top_projects = Project.published.joins(:published_revision).limit(5)

    @good_projects = top_projects.good.order('total_score::float / maximum_score DESC').map(&:published_revision)
    @bad_projects = top_projects.bad.order('total_score::float / maximum_score ASC').map(&:published_revision)
  end

  def about
    render_page :about
  end

  def committee
    render_page :committee
  end

  def contribute
    render_page :contribute
  end

  def faq
    render_page :faq
  end

  private

  def render_page(name)
    @page = Page.find(ENV.fetch("REDFLAGS_#{name.upcase}_PAGE_ID"))
    render 'page'
  end
end
