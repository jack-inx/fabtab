class AddNameToOptinAd < ActiveRecord::Migration
  def change
    add_column :optin_ads, :name, :string
  end
end
