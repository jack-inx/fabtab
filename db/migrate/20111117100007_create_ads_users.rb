class CreateAdsUsers < ActiveRecord::Migration
  def change
    create_table :ads_users do |t|
      t.integer :user_id
      t.integer :ad_id
    end
  end
end
