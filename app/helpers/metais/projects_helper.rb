module Metais::ProjectsHelper
  def origin_type_logo(origin_type)
    if origin_type.is_a?(Integer)
      case origin_type
      when 3
        'icons/sd_logo.png'
      when 2
        'icons/ai_logo.png'
      else
        'icons/metais_logo.png'
      end
    else
      case origin_type.name
      when 'Human'
        'icons/sd_logo.png'
      when 'AI'
        'icons/ai_logo.png'
      else
        'icons/metais_logo.png'
      end
    end
  end

  def convert_to_list(text)
    items = text.split('\n')

    list_items = items.map do |item|
      ActionController::Base.helpers.sanitize("<li>#{item}</li>")
    end

    ActionController::Base.helpers.sanitize("<ul>#{list_items.join}</ul>")
  end
end
