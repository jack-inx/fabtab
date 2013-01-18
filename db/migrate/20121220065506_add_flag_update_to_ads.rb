class AddFlagUpdateToAds < ActiveRecord::Migration
  def change
    add_column :ads, :flagupdate, :datetime
  end
end
