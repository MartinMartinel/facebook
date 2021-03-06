class Post < ActiveRecord::Base

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  belongs_to :creator,  class_name: "User"
  belongs_to :receiver, class_name: "User"

  validates :content,     presence: true
  validates :creator_id,  presence: true
  validates :receiver_id, presence: true
end
