# To change this template, choose Tools | Templates
# and open the template in the editor.

#IMGKit.configure do |config|
#  config.wkhtmltoimage = '/path/to/wkhtmltoimage'
#  config.default_options = {
#    :quality => 60
#  }
#  config.default_format = :png
#end

IMGKit.configure do |config|
  config.wkhtmltoimage = Rails.root.join('bin', 'wkhtmltoimage-amd64').to_s if ENV['RACK_ENV'] == 'production'
end
