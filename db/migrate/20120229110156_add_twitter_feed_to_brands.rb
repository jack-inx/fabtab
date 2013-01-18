class AddTwitterFeedToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :twitter_handle, :string
  end
end
