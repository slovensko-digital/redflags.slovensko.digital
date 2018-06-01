module ProjectsHelper
  def help_icon_if_blank(property)
    if property.blank?
      content_tag :i, nil, class: 'fa fa-question-circle text-muted', title: 'Tento údaj ešte nebol vyplnený.'
    end
  end

  def formatted_body_html(body_html)
    html = Nokogiri::HTML.parse(body_html)
    red_flag = Nokogiri::HTML.parse('<i class="fa fa-flag text-danger"></i>').root

    html.search('img.emoji[title=":triangular_flag_on_post:"]').each do |discourse_red_flag|
      discourse_red_flag.replace(red_flag)
    end

    html.inner_html
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
