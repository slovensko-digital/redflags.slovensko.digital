class StaticController < ApplicationController
  def index
    @best_ranked_projects = Project.published.joins(:published_revision).order('total_score::float / maximum_score DESC').limit(5).map(&:published_revision)
    @worst_ranked_projects = Project.published.joins(:published_revision).order('total_score::float / maximum_score ASC').limit(5).map(&:published_revision)
  end

  def kitchen_sink
  end
end
