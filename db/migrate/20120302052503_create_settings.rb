class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :carousel_refresh

      t.timestamps
    end
  end
end
