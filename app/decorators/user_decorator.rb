class UserDecorator < SimpleDelegator
  def full_name
    "#{first_name} #{last_name}"
  end

  def status_badge
    case status
    when 'active'
      '<span class="badge badge-success">Active</span>'
    when 'inactive'
      '<span class="badge badge-danger">Inactive</span>'
    else
      '<span class="badge badge-secondary">Unknown</span>'
    end.html_safe
  end

  def member_since
    created_at.strftime("%B %d, %Y")
  end
end