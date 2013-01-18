class AddFlagToAds < ActiveRecord::Migration
  def change
    add_column :ads, :flag, :boolean, :default => 0
  end
end
