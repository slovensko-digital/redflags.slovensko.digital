class StaticController < ApplicationController
  def index
    @worst_ranked_projects = [
        OpenStruct.new(
            title: 'Pamiatkový informačný systém',
        ),
        OpenStruct.new(
            title: 'Elektronické služby Národného bezpečnostného úradu',
        ),
        OpenStruct.new(
            title: 'Digitálne pracovné prostredie zamestnanca Ministerstva vnútra Slovenskej republiky',
        ),
    ]
    @best_ranked_projects = @worst_ranked_projects
  end

  def kitchen_sink
  end
end
