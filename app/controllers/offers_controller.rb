	class OffersController < ApplicationController
  before_filter :authenticate_user!
  
  def new_offer
    @brand = Brand.find(params[:id])
    @offer = Offer.new
    @ad_id = params[:ad_id]
    @city = City.find_all_by_state_code("AK")  
    respond_to do |format|
      format.html {}
    end
  end

  def edit_coupan
    @brand = Brand.find(params[:id])
    @brand_id = @brand.id
    @coupan = Offer.find(params[:coupan_id])
	@name = @coupan.city
   @city = City.find_all_by_state_code(@name.state_code)
    respond_to do |format|
      format.html {}
    end
  end

  def update_coupan
    @brand = Brand.find(params[:brand_id])
    @offer = Offer.find(params[:id])
    @city = City.find(params[:city_id])
    @offer.city_id = params[:city_id]
    @offer.address = @city.name + ',' + @city.state_code
    location = Geocoder.search(@offer.address)
    @offer.latitude = location[0].latitude
    @offer.longitude = location[0].longitude
	@offer.image_url = @offer.image.to_s
    @offer.update_attributes(params[:offer])
    @offer.save!
    redirect_to edit_brand_path(@brand)
  end

  def create
    @brand = Brand.find(params[:brand][:id])
    @offer = @brand.offers.new(params[:offer])
    @offer.image_url = params[:offer][:image].to_s
    @city = City.find(params[:city_id])
    @offer.city_id = params[:city_id]
    @offer.address = @city.name + ',' + @city.state_code
    location = Geocoder.search(@offer.address)
    @offer.latitude = location[0].latitude
    @offer.longitude = location[0].longitude
    respond_to do |format|
      if @offer.save
	@offer.image_url = @offer.image.to_s
	@offer.save(:validate => false)
        format.html { redirect_to edit_brand_path(@brand) }
        format.json { render :json => @offer.to_json }
      else
        format.html { redirect_to '/' }
      end
    end
  end



  def state_city_list
    @city = City.find_all_by_state_code(params[:state_code])
    render :partial => "offers/city_list", :locals =>  {:city => @city} 
  end

  def index

  end

  def search_offer_by_brand
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @brand_radius = params[:name]
    if @brand_radius.to_i == 0
      @brand_list = Brand.where('UPPER(name) LIKE UPPER(?)',"%#{params[:name]}%")
      @brand_ids = @brand_list.map {|bl| bl.id }
      @offers = Ad.where("brand_id in (?) and user_id in (?)", @brand_ids, @user.id)
    else
      @offers = Offer.where("radius = ?", @brand_radius)
    end
    render :json => @offers.as_json
  end


end
