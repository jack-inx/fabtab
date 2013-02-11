class OptinAdsController < ApplicationController
  before_filter :authenticate_user!
  
  def save
    advertisement = Ad.find(params[:ad][:id])
    properties = params.select { |element| element == 'optin_ad' }.to_json
    @optin_ad = current_user.optin_ads.new(:fields => properties, :url => advertisement.url, :image_url => advertisement.image_url)
    if @optin_ad.save
      advertisement.destroy
      render :text =>  'Successfully opted in to the ad'
    else
      render :text => 'Optin Ad failed'
    end
  end
  
  def refer
# template = Template.find_by_purpose "Sharing an ad"
    purpose = Purpose.arel_table
    purpose_id = Purpose.where(purpose[:name].matches("%an ad%")).first.id
    template = Template.find_by_purpose_id(purpose_id)
 
   if template
      @var = template.content
    
      AdsMailer.refer(params[:optin_ad],@var).deliver
    end
    redirect_to index_path
  end
  
end
