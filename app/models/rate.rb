class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
  validates_numericality_of :stars, :minimum => 1
  
  attr_accessible :rate, :dimension
  
  def self.stars_for(ad)
    ad = Rate.find_by_rateable_id(ad)
    total_stars = ad ? ad.stars : 0
    puts "#{total_stars}"
    total_stars
  end
  
end
