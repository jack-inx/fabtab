class AddInfoToDemo < ActiveRecord::Migration
  def change
    add_column :demos, :info, :text
  end
end
