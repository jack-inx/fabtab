class AddAdAttributesToDemoImage < ActiveRecord::Migration
  def self.up
    add_column :demo_images, :ad_file_name, :string
    add_column :demo_images, :ad_content_type, :string
    add_column :demo_images, :ad_file_size, :integer
    add_column :demo_images, :ad_updated_at, :datetime
  end

  def self.down
    remove_column :demo_images, :ad_file_name
    remove_column :demo_images, :ad_content_type
    remove_column :demo_images, :ad_file_size
    remove_column :demo_images, :ad_updated_at
  end
end
