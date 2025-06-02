module MarkdownHelper
  def markdown_render(text)
    sanitize CommonMarker.render_html(text, :DEFAULT)
  end
end
