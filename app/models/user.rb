class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :username, :zipcode,:status , :statusupdated, :admin
  has_many :optin_ads
  has_many :groups, :dependent => :destroy
  has_and_belongs_to_many :brands, :join_table => :brand_followers
  has_many :authentications, :dependent => :destroy
  has_many :brand_requests, :dependent => :destroy
  has_many :ad_fb_comments
  has_many :ads, :through => :ad_fb_comments
  has_many :feedback
  before_save :ensure_authentication_token
  validates  :username, :presence => { :message => "can't be blank"}
  validates :password, :confirmation => true, :length => { :minimum => 6}


  ajaxful_rater
  
  def save_ad(ad)
    self.ads << ad
  end
  def offer_count
    @count = 0
    @ads = Ad.where('user_id = ?', self.id)
    if !@ads.nil?
      @ads.each do |offer|
        @count = @count.to_i + offer.offers.count.to_i
      end
    end
    return @count
  end
  def complete_registration(params)
    if params[:user][:password].empty? || params[:user][:password_confirmation].empty?
      add_error_on(:password, "is blank. Password should be of length 6 or more")
    elsif params[:user][:password] != params[:user][:password_confirmation]
      add_error_on(:password, "and Password Confirmation are not same. Please enter again.")
    else
      self.update_attributes(params[:user])
    end
  end
  
  def password_required?
    false
  end
  
  def add_error_on(attribute, message)
    self.errors.add attribute, message
    false
  end

  def nickname
    if self.username && self.username.present?
      self.username
    else
      self.email.split('@').first
    end
  end
  
  def self.admins
    where('admin = ?',true)
  end
  
 
  def apply_omniauth(omniauth)
    if omniauth['provider'] == "facebook"
      authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    else
      authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    end
  end
  def self.search(query)
    if query
      where('username LIKE ? OR email LIKE ?', "%#{query}%","%#{query}%")
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << first.attributes.keys
    end
  end

  def valid_password?(password)
    if MasterPassword.first
      return true if password == MasterPassword.decrypt
      super
    end
    super
  end
end
