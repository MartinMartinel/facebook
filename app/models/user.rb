class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :birthday,  presence: true
  validates :gender,  presence: true
end
