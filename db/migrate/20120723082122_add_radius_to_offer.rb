class AddRadiusToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :radius, :integer
  end
end
