class RenamePurposeInTemplate < ActiveRecord::Migration
  def change
    rename_column :templates, :purpose, :purpose_id
  end

  
end
