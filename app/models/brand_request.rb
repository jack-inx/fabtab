class BrandRequest < ActiveRecord::Base
  belongs_to :ad
  belongs_to :user
end
