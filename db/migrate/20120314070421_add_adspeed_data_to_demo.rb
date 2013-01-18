class AddAdspeedDataToDemo < ActiveRecord::Migration
  def change
    add_column :demos, :adspeed_data, :text
  end
end
