class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :notification_type
      t.string :sender
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
