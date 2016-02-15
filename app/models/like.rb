class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  validates :likeable_id,   presence: true
  validates :likeable_type, presence: true
  validates :user_id,       presence: true

  before_save :check_duplicate

  private


  def check_duplicate
    find_like.exists? ? false : true
  end

  def find_like
    Like.where(likeable_type: self.likeable_type,
               likeable_id: self.likeable_id,
               user_id: self.user_id )
  end
end
