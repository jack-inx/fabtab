class AddAdditionDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zipcode, :string
    add_column :users, :username, :string
    add_column :users, :notifications, :string
  end
end
