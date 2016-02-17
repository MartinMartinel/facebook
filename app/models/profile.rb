class Profile < ActiveRecord::Base
  belongs_to :user

  validates :access_to, presence: true
end
