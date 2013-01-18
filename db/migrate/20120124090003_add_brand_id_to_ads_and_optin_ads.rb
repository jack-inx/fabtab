class AddBrandIdToAdsAndOptinAds < ActiveRecord::Migration
  def change
    add_column :ads, :brand_id, :integer
    add_column :optin_ads, :brand_id, :integer
  end
end
