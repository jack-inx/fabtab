class MasterPassword < ActiveRecord::Base
	validates :mpassword, :presence => true
end
