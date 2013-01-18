class AddBrandIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :brand_id, :integer
  end
end
