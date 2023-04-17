module PagesHelper
  def substitue_iframes(body)
    doc = Nokogiri::HTML.parse(body)
    doc.css('iframe[src*="bi.ekosystem.slovensko.digital"]').each_with_index do |iframe, index|
      iframe['id'] = "iframe_#{index}"
      iframe.add_previous_sibling('<script src="https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.3.6/iframeResizer.min.js"></script>')
      iframe.add_next_sibling("<script>iFrameResize({}, '#iframe_#{index}')</script>")
    end
    doc.to_html
  end
end