class AddBrandIdToOffer < ActiveRecord::Migration
  def change
    add_column :offers , :brand_id, :integer
  end
end
