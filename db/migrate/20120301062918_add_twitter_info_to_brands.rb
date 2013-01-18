class AddTwitterInfoToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :twitter_info, :text
  end
end
