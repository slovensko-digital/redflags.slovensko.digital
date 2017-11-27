module ProjectsHelper
  def help_icon_if_blank(property)
    if property.blank?
      content_tag :i, nil, class: 'fa fa-question-circle text-muted', title: 'Tento údaj ešte nebol vyplnený.'
    end
  end

  def rating_stars(rating)
    capture do
      if rating
        if rating.score > 0
          str = content_tag :span, class: 'rating-known' do
            rating.score.times do
              concat fa_icon 'star'
            end
            (4 - rating.score).times do
              concat fa_icon 'star-o'
            end
          end
          concat str
        else
          concat fa_icon('flag', class: 'text-danger')
        end
      else
        concat help_icon_if_blank(rating)
      end
    end
  end
end
