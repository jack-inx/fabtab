class AddStatusToAds < ActiveRecord::Migration
  def change
    add_column :ads, :status, :boolean, :default => 1
  end
end
