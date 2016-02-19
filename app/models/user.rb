class User < ActiveRecord::Base

  scope :alphabetize, -> { order(:first_name, :last_name) }

  has_one :profile, dependent: :destroy

  has_many :notifications, dependent: :destroy

  has_many :created_posts, class_name: "Post", foreign_key: :creator_id, dependent: :destroy
  has_many :received_posts, class_name: "Post", foreign_key: :receiver_id, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

  has_many :comments, foreign_key: :commenter_id, dependent: :destroy

  has_many :friendships, dependent: :destroy, foreign_key: :friender_id
  has_many :reverse_friendships, class_name: "Friendship",
  dependent: :destroy,
  foreign_key: :friended_id

  has_many :friended_users, through: :friendships, source: :friended
  has_many :frienders, through: :reverse_friendships, source: :friender

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  before_create :build_default_profile


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
    !self.reverse_friendships.where(friender_id: friender.id, accepted: false).empty?
  end

  def sent_friend_request_to? friended
    !self.friendships.where(friended_id: friended.id).empty?
  end

  def friends_with? user
    friended_friends_ids.include?(user.id) || friender_friends_ids.include?(user.id)
  end

  def get_friendship_with user
    self.reverse_friendships.find_by(friender_id: user.id) || self.friendships.find_by(friended_id: user.id)
  end

  def friender_friends_ids
    self.friendships.where(accepted: true).pluck(:friended_id)
  end

  def friended_friends_ids
    self.reverse_friendships.where(accepted: true).pluck(:friender_id)
  end

  def all_friend_ids
    friender_friends_ids.push(*friended_friends_ids)
  end

  def friends
    User.select { |u| all_friend_ids.include?(u.id) }
  end

  def requests_from
    User.select { |u| self.has_friend_request_from?(u) }
  end

  def no_friendship
    User.where.not(id: all_friend_ids)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def update_new_notifications
    increment!(:new_notifications)
  end

  def reset_new_notifications
    update_attributes(new_notifications: 0)
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20], :first_name => data["fi"])
    end
  end

  def build_default_profile
    self.build_profile({ access_to: "All Users", email_notification: true })
    true
  end

  def full_name
    "#{first_name} #{last_name}"
  end


end
