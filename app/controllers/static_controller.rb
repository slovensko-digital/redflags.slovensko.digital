class StaticController < ApplicationController
  def index
    @best_ranked_projects = Project.published.joins(:published_revision).order('total_score::float / maximum_score DESC').limit(5).map(&:published_revision)
    @worst_ranked_projects = Project.published.joins(:published_revision).order('total_score::float / maximum_score ASC').limit(5).map(&:published_revision)
  end

  # TODO rm
  def kitchen_sink
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
