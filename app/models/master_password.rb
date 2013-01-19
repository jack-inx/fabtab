class MasterPassword < ActiveRecord::Base
	validates :mpassword, :presence => true
  before_save :encryption



  def encryption
    key =  ActiveSupport::MessageEncryptor.new(algo)
    return  self.mpassword = key.encrypt(self.mpassword)
  end

  def self.decrypt
    key =  ActiveSupport::MessageEncryptor.new(Digest::SHA1.hexdigest("fabtab"))
    return self.first.mpassword = key.decrypt(self.first.mpassword)
  end

  private

  def algo
    return  secret = Digest::SHA1.hexdigest("fabtab")
  end
end
