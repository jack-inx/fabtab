class Demo < ActiveRecord::Base
  has_attached_file :website,
        :storage => :s3,
        :bucket  => 'myfabtab',
        :s3_credentials => {
          :access_key_id => 'AKIAJ5EANDODFQNLOVRA',
          :secret_access_key => '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'
        }
end
