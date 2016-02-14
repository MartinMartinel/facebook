class Notification < ActiveRecord::Base
  belongs_to :user

  validates :message, presence: true
  validates :user_id, presence: true

  def self.send_notification(receiver, type, sender_name)
    receiver.notifications.create(message:           "#{sender_name} sent you a Friend Request",
                                  notification_type: type,
                                  sender:            sender_name)
    receiver.update_new_notifications
  end

end
