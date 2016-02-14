module ApplicationHelper
  def notification_alert
    html = <<-HTML
    Notifications <span id="new-notifications">#{current_user.new_notifications}</span>
    HTML
    current_user.new_notifications? ? html.html_safe : "Notifications"
  end
end
