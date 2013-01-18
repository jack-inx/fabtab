class AddImageUrlToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :image_url, :string
  end
end
