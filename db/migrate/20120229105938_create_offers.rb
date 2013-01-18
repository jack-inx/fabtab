class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :url
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
