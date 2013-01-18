class AddNameToDemo < ActiveRecord::Migration
  def change
    add_column :demos, :name, :string
  end
end
