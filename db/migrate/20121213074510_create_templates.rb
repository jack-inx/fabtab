class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name, :default=>""
      t.string :purpose, :default => ""
      t.text :content
      t.string :type

      t.timestamps
    end
  end
end
