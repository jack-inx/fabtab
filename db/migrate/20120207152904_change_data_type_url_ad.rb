class ChangeDataTypeUrlAd < ActiveRecord::Migration
  def change
    remove_column :ads, :url
    add_column :ads, :url, :text
  end

end
