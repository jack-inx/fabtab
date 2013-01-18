class AddAttachmentWebsiteToDemo < ActiveRecord::Migration
  def self.up
    add_column :demos, :website_file_name, :string
    add_column :demos, :website_content_type, :string
    add_column :demos, :website_file_size, :integer
    add_column :demos, :website_updated_at, :datetime
  end

  def self.down
    remove_column :demos, :website_file_name
    remove_column :demos, :website_content_type
    remove_column :demos, :website_file_size
    remove_column :demos, :website_updated_at
  end
end
