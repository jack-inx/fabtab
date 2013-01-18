class Twitter
  def self.description_for(brand)
    begin
      brand.twitter_account_information
    rescue Brand::NoTwitterInformation
      response = HTTParty.get("https://api.twitter.com/1/users/lookup.json?screen_name=#{brand.twitter_handle}&include_entities=true")
      brand.twitter_info = response.to_json
      brand.save!
      response.parsed_response[0]
    end
  end
end