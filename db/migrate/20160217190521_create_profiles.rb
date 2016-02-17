class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.date :birthday
      t.string :profession
      t.string :country
      t.string :education
      t.string :about_you
      t.string :access_to
      t.boolean :email_notification
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
