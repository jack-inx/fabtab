class Brand < ActiveRecord::Base
  class NoTwitterInformation < StandardError; end
  
  has_many :ads, :dependent => :destroy
  has_many :optin_ads
  has_many :offers, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_and_belongs_to_many :followers, :join_table => :brand_followers, :association_foreign_key => :user_id, :class_name => 'User'
  has_attached_file :logo,
    :storage => :s3,
    :bucket  => 'brand_logos',
    :s3_credentials => {
    :access_key_id => 'AKIAJ5EANDODFQNLOVRA',
    :secret_access_key => '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'
  },
    :styles => {
    :super_folder => '282x235>',
    :thumb => '100x100>',
    :all_folders => '210x175>'
  },
    :url => "/system/:attachment/:rails_env/brands/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:rails_env/brands/:attachment/:id/:style/:basename.:extension"
  
  def advertisements
    brand_ads = []
    brand_ads << self.optin_ads
    brand_ads << self.ads
    brand_ads.flatten
  end
  
  def self.search(query)
    offers = []
    brands = search ? where('name LIKE ?',"%#{query}%") : scoped
    brands.each do |brand|
      offers << brand.optin_ads
      offers << brand.ads
    end
    offers.flatten
  end


  def self.offers
    offers = []
    self.all.each do |brand|
      offers << brand.advertisements
    end
    
    offers.flatten
  end
  
  def twitter_account_information
    raise NoTwitterInformation if self.twitter_info.nil?
    JSON.parse(self.twitter_info)[0]
  end
end
