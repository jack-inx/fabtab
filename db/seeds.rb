# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
categories =['Accessories',
  'Articles',
  'Automotive',
  'Beauty',
  'Books/Media',
  'Business',
  'Classifieds',
  'Careers',
  'Clothing',
  'Computer & Electronics',
  'Department Stores',
  'Education',
  'Entertainment',
  'Environmental',
  'Family',
  'Financial Services',
  'Real Estate Services',
  'Tax Services',
  'Food & Drinks',
  'Games & Toys',
  'Gifts & Flowers',
  'Health and Wellness',
  'Home & Garden',
  'Insurance',
  'Marketing',
  'Online Services',
  'Design',
  'Recreation & Leisure',
  'Seasonal',
  'Sports & Fitness',
  'Telecommunications',
  'Tools and Equipment',
  'Travel',
  'My Saved FabTabs'
]

categories.map {|category| Category.find_or_create_by_name(category.downcase) }

Setting.create(:carousel_refresh=> 60)

state_file = "#{Rails.root}/db/state.csv"
city_file = "#{Rails.root}/db/city.csv"


begin
	p "Creating states"
  states = CSV.read(state_file, :headers => true, :header_converters => :symbol)
  states.each do |row|
    UsState.create!(:state => row[0], :state_code => row[1])
  end
  p "Successfully Created States"
end

begin
	p "Creating cities"
	city = CSV.read(city_file, :headers => true, :header_converters => :symbol)
	city.each do |row|

    City.create!(:name => row[0], :state_code => row[1])
  end
  p "Successfully Created Cities"
end
