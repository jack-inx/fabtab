class CreateDemoImages < ActiveRecord::Migration
  def change
    create_table :demo_images do |t|
      
      t.timestamps
    end
  end
end
