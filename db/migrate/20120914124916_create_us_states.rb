class CreateUsStates < ActiveRecord::Migration
  def change
    create_table :us_states ,:id => false, :primary_key => :state_code do |t|
      t.string :state
      t.string :state_code

      t.timestamps
    end
  
  end
end
