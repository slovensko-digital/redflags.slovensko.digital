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
    elsif element.table
      parse_table(element.table)
    else
      ""
    end
  end

  def parse_paragraph(paragraph)
    text_content = ""
    paragraph.elements.each do |el|
      if el.text_run
        text_content += el.text_run.content
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
        "<h1>#{text_content}</h1>"
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

  def extract_dropdown_value(dropdown_text)
    dropdown_text = dropdown_text.gsub("", "\n")

    selected_option = nil
    options = dropdown_text.split("\n")

    options.each do |option|
      if option.include?("**") || option.include?("**")
        selected_option = option.gsub("**", "").strip
        break
      end
    end

    selected_option || "No option selected"
  end

  def parse_inline_object(inline_object)
    if inline_object.inline_object_properties
      embedded_object = inline_object.inline_object_properties.embedded_object
      if embedded_object&.image_properties
        "<img src='#{embedded_object.image_properties.content_uri}' alt='Inline Object' />"
      else
        ""
      end
    else
      ""
    end
  end

  def parse_table(table)
    html_table = "<table>"
    table.table_rows.each do |row|
      html_table += "<tr>"
      row.table_cells.each do |cell|
        html_table += "<td>#{parse_cell(cell)}</td>"
      end
      html_table += "</tr>"
    end
    html_table += "</table>"
    html_table
  end

  def parse_list_item(bullet, text_content)
    nesting_level = bullet.nesting_level || 0
    list_tag = nesting_level.even? ? "ul" : "ol"
    "<#{list_tag}><li>#{text_content}</li></#{list_tag}>"
  end

  def parse_cell(cell)
    cell.content.map { |element| parse_element(element) }.join
  end


  def parse_image(image_properties)
    "<img src='#{image_properties.content_uri}' alt='Image' />"
  end

  def extract_title(html_content)
    doc = Nokogiri::HTML(html_content)

    doc.at('h3').next_element.text.strip
  end
end
