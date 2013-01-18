class DropExtraOffer < ActiveRecord::Migration
  def up
    drop_table :extra_offers
  end

  def down
    create_table :extra_offers do |t|
      t.integer :brand_id
      t.string :url
      t.text :metadata

      t.timestamps
    end
  end
end
