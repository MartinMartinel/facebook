class IndexCommentsOnCommenterId < ActiveRecord::Migration
  add_index :comments, :commenter_id
end
