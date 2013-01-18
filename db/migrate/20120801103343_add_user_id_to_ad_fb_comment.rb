class AddUserIdToAdFbComment < ActiveRecord::Migration
  def change
    add_column :ad_fb_comments, :user_id, :integer
  end
end
