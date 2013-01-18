class Category < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_length_of :name , :minimum => 1
  
  def by_name(name)
    where('name like?',name)
  end
  
  def permanent?
    name.downcase == "my saved fabtabs"
  end
  
  def self.find_permanent
    find_by_name('my saved fabtabs')
  end
  
  def name
    read_attribute(:name).split.map { |names| names.capitalize }.join(' ')
  end
  
  def self.create_by_name(tabcategory,user)
    category = Category.find_by_name_and_user_id(tabcategory.downcase,nil)
    unless category
      category = Category.find_or_create_by_name_and_user_id(tabcategory.downcase,user.id)
    end
    
    category
  end
  
  def self.find_all_for_user(user)
    find(:all).select {|category| category.user_id.nil? ||  category.user == user }.reject { |category| category.permanent? }.sort_by { |category| category.name }.uniq { |category| category.name }
  end

  def self.find_all_for_user_by_name(user,name)
    find(:all).select {|category| (category.user_id.nil? || category.user == user) && category.name==name  }.reject { |category| category.permanent? }.sort_by { |category| category.name }.uniq { |category| category.name }
  end

  def self.find_offers id
    return Ad.joins([{:group=>:category}]).where(:categories=>{:id => id})
  end


  def self.my_local_offers latitude , longitude , id 
    Ad.near([latitude,longitude],10).joins([{:group=>:category}]).where(:categories=>{:id=>id})
  end

  def self.my_local_offers_without_category latitude , longitude , radius
    Ad.near([latitude,longitude],radius).joins([{:group=>:category}])
  end

  # defined for only web service
#
#  def self.find_for_user(user)
#    find(:all).select {|category| category.user == user }.reject { |category| category.permanent? }.sort_by { |category| category.name }.uniq { |category| category.name }
#  end

  def self.find_for_user_by_name(user,name)
    find(:all).select {|category| (category.user == user) && category.name==name }.reject { |category| category.permanent? }.sort_by { |category| category.name }.uniq { |category| category.name }
  end

  def self.find_fb_comment_id(adid, userid)
    AdFbComment.where("ad_id IN (?) AND user_id = ?", adid, userid)
  end

  
end
