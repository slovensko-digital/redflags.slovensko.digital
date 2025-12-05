require 'nokogiri'
require 'net/http'
require 'base64'

class DocumentParserService
  def initialize(document)
    @document = document
  end

  def to_html
    html_content = ""
    @document.body.content.each do |element|
      html_content += parse_element(element)
    end
    html_content
  end

  def to_hash(html_content)
    {
      title: extract_title(html_content),
      category_id: 43,
      post_stream: {
        posts: [
          { cooked: html_content },
        ]
      }
    }
  end

  private

  def parse_element(element)
    if element.paragraph
      parse_paragraph(element.paragraph)
    else
      ""
    end
  end

  def parse_paragraph(paragraph)
    text_content = ""
    paragraph.elements.each do |el|
      if el.text_run
        if el.text_run.text_style.link
          link = el.text_run.text_style.link.url
          text = el.text_run.content

          text_style = el.text_run.text_style
          text = "<b>#{text}</b>" if text_style.bold?
          text = "<i>#{text}</i>" if text_style.italic?
          text = "<u>#{text}</u>" if text_style.underline?

          if link =~ /drive\.google\.com/
            id = link.split('/d/').last.split('/').first
            link = "https://drive.google.com/uc?export=download&id=#{id}"
          end
          text_content += "<a href='#{link}' target='_blank'>#{text}</a>"
        else
          text = el.text_run.content

          # Apply styles if present.
          text_style = el.text_run.text_style
          text = "<b>#{text}</b>" if text_style.bold?
          text = "<i>#{text}</i>" if text_style.italic?
          text = "<u>#{text}</u>" if text_style.underline?

          text_content += text
        end
      elsif el.inline_object_element
        inline_object_id = el.inline_object_element.inline_object_id
        text_content += parse_inline_object(@document.inline_objects[inline_object_id])
      end
    end
    if paragraph.bullet
      parse_list_item(paragraph.bullet, text_content)
    else
      case paragraph.paragraph_style&.named_style_type
      when "HEADING_1"
        icon = ''
        if text_content.downcase.include?('dokumenty')
          icon = "<img src='https://platforma.slovensko.digital/images/emoji/twitter/file_folder.png?v=12' title=':file_folder:' class='emoji' alt=':file_folder:' loading='lazy' width='20' height='20'>"
        elsif text_content.downcase.include?('aktivity')
          icon = "<img src='https://platforma.slovensko.digital/images/emoji/twitter/clock2.png?v=12' title=':clock2:' class='emoji' alt=':clock2:' loading='lazy' width='20' height='20'>"
        end
        "<h1>#{icon} #{text_content}</h1>"
      when "HEADING_2"
        "<h2>#{text_content}</h2>"
      when "HEADING_3"
        stars = text_content.scan(/★|☆/)
        if stars.any?
          text_content.gsub!(/★|☆/, '')
          text_content += parse_stars(stars.join)
        end
        "<h3>#{text_content}</h3>"
      else
        "<p>#{text_content}</p>"
      end
    end
  end

  def parse_stars(stars_str)
    star_img = %(<img src="#{ActionController::Base.helpers.image_path('emoji/star.png')}" title=":star:" class="emoji" alt=":star:">)
    grey_img = %(<img src="#{ActionController::Base.helpers.image_path('emoji/grey_star.png')}" title=":grey_star:" class="emoji emoji-custom" alt=":grey_star:">)
    star_img * stars_str.count('★') + grey_img * stars_str.count('☆')
  end

  def parse_inline_object(inline_object)
    image_properties = inline_object&.inline_object_properties&.embedded_object&.image_properties
    return "" unless image_properties

    image_src = inline_image_src(image_properties.content_uri)
    "<div class='d-flex justify-content-center'><img src='#{image_src}' alt='Inline Object' /></div>"
  end

  def parse_list_item(bullet, text_content)
    nesting_level = bullet.nesting_level || 0
    list_tag = nesting_level.even? ? "ul" : "ol"
    "<#{list_tag}><li>#{text_content}</li></#{list_tag}>"
  end

  def extract_title(html_content)
    doc = Nokogiri::HTML(html_content)

    doc.at('h3').next_element.text.strip
  end

  def inline_image_src(content_uri)
    return content_uri unless (token = google_access_token)

    uri = URI.parse(content_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Bearer #{token}"
      http.request(request)
    end

    return content_uri unless response.is_a?(Net::HTTPSuccess)

    "data:#{response['content-type'] || 'image/png'};base64,#{Base64.strict_encode64(response.body)}"
  end

  def google_access_token
    @google_access_token ||= GoogleApiService.authorize.tap { |auth| auth.fetch_access_token! if auth.access_token.nil? }.access_token
  end
end
