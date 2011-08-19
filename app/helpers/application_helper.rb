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

  def display_audit_change(change)
    change.audited_changes.keys.join(", ")
  end

  def display_audit_action(change)
    case change.action
    when 'create' then 
      change.association.present? ? "Added" : "Created"
    when 'update' then
      begin
        if change.auditable.soft_deletable?
          change.auditable.revision(change.version).deleted? ? "Deleted" : "Updated"
        end
      rescue
        "Updated"
      end
    when 'destroyed' then "Deleted"
    end
  end

  def formulation_version_path(formulation_version)
    formulation_path(formulation_version.formulation, :version => formulation_version.version_number)
  end

  def formulation_path(formulation, opts = {})
    if formulation.is_a?(Fragrance)
      formulation_path = :fragrance_path
    else
      formulation_path = :accord_path
    end
    send(formulation_path, formulation, opts)
  end

  def current_tab?(tab)
    @tab.to_sym == tab.to_sym
  end
end
