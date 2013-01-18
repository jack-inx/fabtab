class AddOptinFieldsToAd < ActiveRecord::Migration
  def change
    add_column :ads, :optin_fields, :text
  end
end
