class CreateBrandFollowers < ActiveRecord::Migration
  def change
    create_table(:brand_followers) do |t|
      t.integer :brand_id
      t.integer :user_id
      t.timestamps
    end
  end

end
