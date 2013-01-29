LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
source 'http://rubygems.org'

gem 'rails', '3.1.10'
group :production do
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
group :development do
  gem 'sqlite3'
end
gem 'mysql2'
gem 'awesome_print', :require => 'ap'
gem 'kaminari'
gem 'geocoder'
gem 'imgkit'
gem 'devise'
#gem 'backup'

#gem 'fog', '~> 1.1.0'
 gem 'yaml_db'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'httparty'
# for image upload
gem "paperclip", "~> 2.0"
gem 'aws-sdk', '~> 1.3.4'
gem "aws-s3", "~> 0.6.2"

#for less stylesheets
gem 'less-rails-bootstrap', '~> 1.3.0'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

group :test do
end

# for heroku
#gem 'pg'
gem 'tlsmail'

#for ads rating
gem 'ajaxful_rating', '>= 3.0.0.beta8'
