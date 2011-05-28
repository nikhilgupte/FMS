module ApplicationHelper

  def reqd
    raw '<span class="reqd">*</span>'
  end

  def inside_layout layout = 'application', &block
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}"
  end

  def cancel_link(url)
    link_to "Cancel", url_for(url), :class => "cancel"
  end
end
