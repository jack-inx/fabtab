class BrandsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin, :only => [:new,:create,:edit,:index]
  before_filter :admin_active, :except => [:show]
  
  def index
    @brands = Brand.all
  end
  
  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(params[:brand])
    if !params[:brand][:name].blank? && @brand.save
      flash[:notice] = "Brand Folder successfully created!"
      redirect_to brands_path
    else
      flash[:notice] = "Brand name can't be blank"
      render 'new'
    end
  end
  
  def edit
    @brand = Brand.find(params[:id])
    @additional_offers = @brand.offers.select { |offer| offer.expiry_date > Time.now }
    @brand_folders = @brand.groups.reject {|group| group.brand_folder? }
    @category = Category.find_all_for_user(current_user)
  end
  
  def update
    @brand = Brand.find(params[:id])
    @brand.update_attributes(params[:brand])
    @brand.twitter_info = nil
    @brand.save!
    flash[:notice] = "Successfully updated brand folder!"
    redirect_to edit_brand_path(@brand)
  end
  
  def show
    @brand = Brand.find(params[:id])
    if !params[:auth_token].nil?
      @user = User.find_by_authentication_token(params[:auth_token])
    else
      @user = current_user
    end
    @brand_folders = Group.where("brand_id = ?",@brand)
    @category = Category.find_all_for_user(@user)
    @brand_extra_offers = @brand.offers.select { |offer| offer.expiry_date > Time.now }
    @twitter_information = Twitter.description_for(@brand)
    @coupan_list = []
    #if @user.admin?
    #  @category = Category.all
    #  @category.each do |i|
    #    if i.user_id == @user.id
    #      @ad = Category.find_offers(i.id)
    #      @ad.each do |j|
    #        @coupan_list << j
    #      end
    #    end
    #  end
    #  @brand_ads_list = @coupan_list.as_json(:include => [ :ad_fb_comments, :offers ])
    #else
    @brand_list =  @brand.ads
    @brand_ads_list = @brand_list.as_json(:include => [ :ad_fb_comments, :offers ])
    #end
    respond_to do |format|
      format.html { }
      format.json { render :json => {:response => "ok", :brands => @brand_ads_list.as_json}}
    end
  end

  def ads
    @brand = Brand.find(params[:id])
    @brand_ads = @brand.advertisements
    @brand_extra_offers = @brand.extra_offers
    @twitter_response = HTTParty.get('https://api.twitter.com/1/statuses/oembed.json?id=149282431562821633&lang=en').parsed_response['html']
  end
  
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    redirect_to brands_path
  end
  
end
