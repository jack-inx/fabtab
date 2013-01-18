class Offer < ActiveRecord::Base
  
  geocoded_by :address
  after_validation :geocode
  belongs_to :brand
  belongs_to :ad
  belongs_to :city
  
  has_attached_file :image, :style=>{:thumb=> '300x250>', :small=>'100x100>'},
    :storage => :s3,
    :bucket  => 'brand_logos',
    :s3_credentials => {
    :access_key_id => 'AKIAJ5EANDODFQNLOVRA',
    :secret_access_key => '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'},
    :url => "/system/:attachment/:rails_env/offers/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:rails_env/offers/:attachment/:id/:style/:basename.:extension"
  
  attr_accessible :address, :longitude, :latitude, :url, :name, :radius, :expiry_date, :image , :ad_id, :city_id

  def self.search
    self.near([latitude,longitude], radius).where("UPPER(url) like UPPER(?)","%#{query}%").flatten.select { |ad| ad.group.user_id == user.id }.map { |ad| URI.decode(ad.url) }.compact.map { |ad| ad.match(/\/{2}((\w*\.*)*)\//)[1] }.uniq.select { |ad| ad.index(query) }.take(10)
  end
end
