class AddImageUrlToAds < ActiveRecord::Migration
  def change
    add_column :ads, :image_url, :string
  end
end
