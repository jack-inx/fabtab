class CreateBrandRequests < ActiveRecord::Migration
  def change
    create_table :brand_requests do |t|
      t.integer :ad_id

      t.timestamps
    end
  end
end
