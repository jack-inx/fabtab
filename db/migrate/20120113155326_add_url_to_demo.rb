class AddUrlToDemo < ActiveRecord::Migration
  def change
    add_column :demos, :url, :string
  end
end
