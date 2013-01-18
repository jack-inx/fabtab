class CreateExtraOffers < ActiveRecord::Migration
  def change
    create_table :extra_offers do |t|
      t.integer :brand_id
      t.string :url
      t.text :metadata

      t.timestamps
    end
  end
end
