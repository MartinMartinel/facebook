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

  def accept_friend_request_from friender
    self.reverse_friendships.find_by(friender_id: friender.id).update_column(:accepted, true) unless friends_with? friender
  end

  def reject_friend_request_from friender
    self.reverse_friendships.find_by(friender_id: friender.id).destroy unless !has_friend_request_from? friender
  end

  def unfriend user
    friendship = get_friendship_with(user) if self.friends_with? user
    friendship.destroy
  end

  def has_friend_request_from? friender
    !self.reverse_friendships.where("friender_id = ? AND accepted = ?", friender.id, false).empty?
  end

  def friends_with? user
    friended_friends_ids.include?(user.id) || friender_friends_ids.include?(user.id)
  end

  def get_friendship_with user
    self.reverse_friendships.find_by(friender_id: user.id) || self.friendships.find_by(friended_id: user.id)
  end

  def friender_friends_ids
    Friendship.where(friender_id: self.id, accepted: true).pluck(:friended_id)
  end

  def friended_friends_ids
    Friendship.where(friended_id: self.id, accepted: true).pluck(:friender_id)
  end

  def all_friend_ids
    friender_friends_ids.push(*friended_friends_ids)
  end

  def friends
    User.select { |u| all_friend_ids.include?(u.id) }
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
