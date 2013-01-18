class AddBrandUrlToOptinAd < ActiveRecord::Migration
  def change
    add_column :optin_ads, :url, :string
  end
end
