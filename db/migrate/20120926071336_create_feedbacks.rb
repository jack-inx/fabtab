class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :content
      t.boolean :deliverd , :default => false

      t.timestamps
    end
  end
end
