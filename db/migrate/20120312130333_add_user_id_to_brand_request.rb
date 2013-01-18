class AddUserIdToBrandRequest < ActiveRecord::Migration
  def change
    add_column :brand_requests, :user_id, :integer
  end
end
