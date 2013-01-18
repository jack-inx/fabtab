class CreateMasterPasswords < ActiveRecord::Migration
  def change
    create_table :master_passwords do |t|
      t.string :mpassword

      t.timestamps
    end
  end
end
