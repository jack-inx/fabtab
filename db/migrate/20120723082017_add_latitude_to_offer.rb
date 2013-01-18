class AddLatitudeToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :latitude, :float
  end
end
