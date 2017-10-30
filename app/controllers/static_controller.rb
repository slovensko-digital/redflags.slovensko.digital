class StaticController < ApplicationController
  # TODO rm
  def kitchen_sink
  end

  def about
    @page = Page.find(ENV.fetch('REDFLAGS_STATIC_ABOUT'))
  end

  def committee

  end

  def contribute

  end

  def faq

  end
end
