module ProjectHelper
  def help_icon_if_blank(property)
    if property.blank?
      content_tag :i, nil, class: 'fa fa-question-circle text-muted', title: 'Tento údaj ešte nebol vyplnený.'
    end
  end
end
