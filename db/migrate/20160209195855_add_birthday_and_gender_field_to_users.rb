class AddBirthdayAndGenderFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :gender, :boolean
  end
end
