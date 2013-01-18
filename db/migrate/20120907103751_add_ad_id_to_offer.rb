class AddAdIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :ad_id, :integer
  end
end
