class AddAdTypeToAds < ActiveRecord::Migration
  def change
    add_column :ads, :ad_type, :string
  end
end
