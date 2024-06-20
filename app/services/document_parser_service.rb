require 'nokogiri'

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
    filled_stars = stars_str.count('★')
    grey_stars = stars_str.count('☆')
    '<img src="//platforma.slovensko.digital/images/emoji/twitter/star.png?v=5" title=":star:" class="emoji" alt=":star:">' * filled_stars + '<img src="//platforma-slovensko-digital-uploads.s3-eu-central-1.amazonaws.com/original/2X/b/bdd2e11053ea53c9b119412c78ec0994497635b3.png?v=5" title=":grey_star:" class="emoji emoji-custom" alt=":grey_star:">' * grey_stars
  end

  def parse_inline_object(inline_object)
    if inline_object.inline_object_properties
      embedded_object = inline_object.inline_object_properties.embedded_object
      if embedded_object&.image_properties
        "
        <div class='d-flex justify-content-center'>
          <img src='#{embedded_object.image_properties.content_uri}' alt='Inline Object' />
         </div>
        "
      else
        ""
      end
    else
      ""
    end
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
end
