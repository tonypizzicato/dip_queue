module ApplicationHelper
  def title(page_title)
    content_for :title, page_title
  end

  def is_active?(page_name)
    "active" if params[:controller] == page_name
  end
end
