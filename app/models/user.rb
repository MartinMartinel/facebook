class User < ActiveRecord::Base

  has_many :friendships, dependent: :destroy, foreign_key: :friender_id
  has_many :reverse_friendships, class_name: "Friendship",
  dependent: :destroy,
  foreign_key: :friended_id

  has_many :friended_users, through: :friendships, source: :friended
  has_many :frienders, through: :reverse_friendships, source: :friender

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]


  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end
end
