class AddUrlToOptinAd < ActiveRecord::Migration
  def change
    add_column :optin_ads, :image_url, :string
  end
end
