class DemoImage < ActiveRecord::Base
  has_attached_file :ad,
       :storage => :s3,
       :bucket  => 'demo_ad_images',
       :s3_credentials => {
         :access_key_id => 'AKIAJ5EANDODFQNLOVRA',
         :secret_access_key => '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'
       },
       :url => "/system/:attachment/:rails_env/demos/ads/:id/:style/:basename.:extension",
       :path => ":rails_root/public/system/:rails_env/demos/ads/:attachment/:id/:style/:basename.:extension",
       :styles => {
         :ad => '300x250>',
         :thumbnail => '180x150>'
       }
       
end
