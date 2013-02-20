require "open-uri"
require "fileutils"
class Ad < ActiveRecord::Base
  geocoded_by :address
  belongs_to :brand, :touch => true
  belongs_to :group, :touch => true
  has_one :brand_request, :dependent => :destroy
  has_many :offers
  accepts_nested_attributes_for :image, :allow_destroy => false
  has_attached_file :image, :style=>{:thumb=> '300x250>', :small=>'100x100>'},
    :storage => :s3,
    :bucket  => 'brand_logos',
    :s3_credentials => {
    :access_key_id => 'AKIAJ5EANDODFQNLOVRA',
    :secret_access_key => '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'},
    :url => "/system/:attachment/:rails_env/ads/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:rails_env/ads/:attachment/:id/:style/:basename.:extension"
  has_many :ad_fb_comments
  has_many :users, :through => :ad_fb_comments
  ajaxful_rateable :stars => 5, :allow_update => true, :dimensions => [:promotions]  
  attr_accessor :category_id


  def self.sort_by_keyword(group,keyword)
    if keyword == "date"
      group.ads.sort {|ad_a, ad_b| ad_b.created_at <=> ad_a.created_at }
    elsif keyword == "rating"
      group.ads.sort { |ad_a, ad_b| Rate.stars_for(ad_b.id) <=> Rate.stars_for(ad_a.id) }
    elsif keyword == "alphabetical"
      group.ads.sort_by { |ad| URI.parse(URI.encode(ad.image_url)).host }
    else
      Ad.where('group_id = ?',group.id).order('created_at DESC')
    end
  end
  
  def self.search(query,  user)
    where("UPPER(url) like UPPER(?)","%#{query}%").flatten.select { |ad| ad.group.user_id == user.id }.map { |ad| URI.decode(ad.url) }.compact.map { |ad| ad.match(/\/{2}((\w*\.*)*)\//)[1] }.uniq.select { |ad| ad.index(query) }.take(10)
  end

  def self.url_search(query, user)
    where("UPPER(url) like UPPER(?)","%#{query}%").flatten.select { |ad| ad.group.user_id == user.id }.map { |ad| URI.decode(ad.url) }.compact.map { |ad| ad.match(/\/{2}((\w*\.*)*)\//)[1] }.uniq.select { |ad| ad.index(query) }.take(10)
  end
  
  def site_url_hostname
    URI.parse(URI.encode(self.url)).host
  end
  
  def image_name
    Pathname.new(URI.parse(URI.encode(self.image_url)).path).basename
  end

  def user_ad?
    brand_id == nil
  end

  def picture_from_url(url) # Nishit
    self.image = open(url)
  end

end
