class User < ActiveRecord::Base

  has_many :friendships, dependent: :destroy, foreign_key: :friender_id
  has_many :reverse_friendships, class_name: "Friendship",
  dependent: :destroy,
  foreign_key: :friended_id

  has_many :friended_users, through: :friendships, source: :friended
  has_many :frienders, through: :reverse_friendships, source: :friender

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def send_friend_request_to friended
    unless friends_with?(friended) || friended.has_friend_request_from?(self) || self.has_friend_request_from?(friended)
      self.friendships.create(friended_id: friended.id, accepted: false)
    end
  end

  def has_friend_request_from? friender
    !self.reverse_friendships.where("friender_id = ? AND accepted = ?", friender.id, false).empty?
  end

  def accept_friend_request_from friender
    unless friends_with? friender
      self.reverse_friendships.find_by(friender_id: friender.id).update_column(:accepted, true)
    end
  end

  def reject_friend_request_from friender
    unless self.reverse_friendships.where("friender_id = ? AND accepted = ?", friender.id, false).empty?
      self.reverse_friendships.find_by(friender_id: friender.id).destroy
    end
  end

  def friends_with? user
    !!self.friendships.find_by(friended_id: user.id, accepted: true) ||
    !!user.friendships.find_by(friended_id: self.id, accepted: true)
  end

  def unfriend user
    if self.friends_with? user
      friendship = self.reverse_friendships.find_by(friender_id: user.id) || self.friendships.find_by(friended_id: user.id)
      friendship.destroy
    end
  end

  def friends
    friender_friends_ids = "SELECT friender_id FROM friendships WHERE friended_id = :user_id AND accepted = true"
    friended_friends_ids = "SELECT friended_id FROM friendships WHERE friender_id = :user_id AND accepted = true"
    User.where("id IN (#{friender_friends_ids}) OR id IN (#{friended_friends_ids})", user_id: self.id)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
