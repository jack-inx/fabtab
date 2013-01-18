class AddLongitudeToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :longitude, :float
  end
end
