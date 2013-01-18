class AddGroupIdToAd < ActiveRecord::Migration
  def change
    add_column :ads, :group_id, :integer
  end
end
