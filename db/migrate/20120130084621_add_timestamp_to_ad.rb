class AddTimestampToAd < ActiveRecord::Migration
  def change
    change_table :ads do |t|
      t.timestamps
    end
  end
end
