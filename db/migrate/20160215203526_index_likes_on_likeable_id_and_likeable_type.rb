class IndexLikesOnLikeableIdAndLikeableType < ActiveRecord::Migration
  add_index :likes, [:likeable_id, :likeable_type]
end
