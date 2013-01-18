class AddUrlToAd < ActiveRecord::Migration
  def change
    add_column :ads, :url, :string
    add_column :ads, :microsite_url, :string
  end
end
