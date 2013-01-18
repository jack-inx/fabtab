class CreateOptinAds < ActiveRecord::Migration
  def change
    create_table :optin_ads do |t|
      t.text :fields
      t.integer :user_id
      
      t.timestamps
    end
  end
end
