class Template < ActiveRecord::Base
   belongs_to :purpose
   validates :purpose_id, presence: true
   validates :name, presence: true

end
