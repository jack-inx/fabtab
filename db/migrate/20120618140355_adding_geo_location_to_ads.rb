class AddingGeoLocationToAds < ActiveRecord::Migration
  def up
    add_column :ads, :latitude, :float
    add_column :ads, :longitude, :float
    add_column :ads, :address, :string
  end

  def down
    remove_column :ads, :latitude
    remove_column :ads, :longitude
    remove_column :ads, :address
  end
end
