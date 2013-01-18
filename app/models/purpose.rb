class Purpose < ActiveRecord::Base
  has_one :template, dependent: :destroy
end
