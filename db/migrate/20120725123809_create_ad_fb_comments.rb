class CreateAdFbComments < ActiveRecord::Migration
  def change
    create_table :ad_fb_comments do |t|
      t.string :fb_comment_id
      t.integer :ad_id

      t.timestamps
    end
  end
end
