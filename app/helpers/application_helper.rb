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

  def display_audit_action(change)
    case change.action
    when 'create' then "Added"
    when 'update' then
      begin
        change.auditable.revision(change.version).deleted? ? "Deleted" : "Updated"
      rescue
        "Updated"
      end
    when 'destroyed' then "Deleted"
    end
  end
end
