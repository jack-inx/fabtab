class AddAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :name
    end
  end
end
