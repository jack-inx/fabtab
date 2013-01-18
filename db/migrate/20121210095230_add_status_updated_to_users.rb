class AddStatusUpdatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :statusupdated, :datetime
  end
end
