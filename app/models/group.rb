class Group < ActiveRecord::Base
  has_many :ads, :dependent => :destroy
  belongs_to :user
  belongs_to :category
  belongs_to :brand
  
  def self.sort_by_keyword(user, keyword)
    if keyword == "alphabetical"
      user.groups.sort_by { |group| group.name if !group.nil?}
    elsif keyword == "date"
      user.groups.sort { |group_a, group_b| group_b.created_at <=> group_a.created_at }
    else
      Group.where('user_id = ?', user.id).order('updated_at DESC')
    end
  end
  
  def permanent?
    if category.nil?
      return true
    end
    category.name.downcase == "my saved fabtabs"
  end

  def brand_folder?
    user_id != nil && brand_id != nil && category_id == nil
  end
  
  def name
    logger.info "=== group self id #{ self.id} ==="
    ( self.category.name ) || ( self.brand.title)
  end
end
