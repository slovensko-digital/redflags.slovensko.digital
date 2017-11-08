module ProjectHelper
  def help_icon_if_blank(property)
    if property.blank?
      content_tag :i, nil, class: 'fa fa-question-circle text-muted', title: 'Tento údaj ešte nebol vyplnený.'
    end
  end

  def rating_stars(rating)
    capture do
      if rating
        s = content_tag :span, class: 'rating-known' do
          rating.score.times do
            concat fa_icon 'star'
          end
          (4 - rating.score).times do
            concat fa_icon 'star-o'
          end
        end
        concat s
      else
        concat help_icon_if_blank(rating)
      end
    end
  end

  def category_like(category)
    case category.to_sym
    when :good then fa_icon('thumbs-o-up', class: 'text-success')
    when :bad then fa_icon('thumbs-o-down', class: 'text-danger')
    else
      # nothing
    end
  end
end
