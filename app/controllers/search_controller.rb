class SearchController < ApplicationController
  before_filter :authenticate_user!
  
  def search
    if !params[:auth_token].nil?
      @user = User.find_by_authentication_token(params[:auth_token])
    else
      @user = current_user
    end
    @category = Category.find_all_for_user(@user)
    @group_ads = Group.where('groups.user_id=?',@user.id).joins(:category).where('UPPER(categories.name) like UPPER(?)',"%#{params[:q]}%").map {|group| group.ads}
    brands = Brand.where('UPPER(name) LIKE UPPER(?)', "%#{params[:q]}%")
    @brand_ads = brands.map { |brand| brand.ads }
    @brand_group_ads = brands.map {|brand| brand.groups }.flatten.map {|group| group.ads }
    @coupan_list = []
    @ads = Ad.where("UPPER(ads.url) like UPPER(?)","%#{params[:q]}%").flatten.select { |ad| ad.group.user_id == current_user.id && URI.parse(URI.encode(ad.url)).host.index(params[:q]) }
    @group_ads << @ads
    @group_ads << @brand_ads
    @group_ads << @brand_group_ads
    @group_ads = @group_ads.flatten.uniq
    if @user.admin?
      @category = Category.all
      @category.each do |i|
        if i.user_id == @user.id
          @ad = Category.find_offers(i.id)
          @ad.each do |j|
            @coupan_list << j
          end
        end
      end
      @ads_list = @coupan_list.as_json(:include => [ :ad_fb_comments, :offers ])
    else
      @ads = Ad.where("UPPER(ads.url) like UPPER(?)","%#{params[:q]}%").flatten.select { |ad| ad.group.user_id == @user.id && URI.parse(URI.encode(ad.url)).host.index(params[:q]) }
      @ads_list = @ads.as_json(:include => [ :ad_fb_comments, :offers ])
    end
    respond_to do |format|
      format.html {render 'search_results'}
      format.json { render :json => {:response => "ok", :ads => @group_ads.as_json}}
    end
  end
  
  def predictive_search
    @search_term = params[:q]
    if !params[:auth_token].nil?
      @user = User.find_by_authentication_token(params[:auth_token])
    else
      @user = current_user
    end
    if request.xhr?
      if @search_term.present?
        @ads = Ad.search(params[:q], @user)
#        @brands = Brand.where('UPPER(name) LIKE UPPER(?)',"%#{@search_term}%")
@brands = Brand.includes(:ads).where("ads.user_id = ? AND UPPER(brands.name) LIKE UPPER(?)", @user.id, "%#{@search_term}%")
      end
      render 'predictive_search_results', :layout => false
    else
      if @search_term.present?
        @ads = Array.new
 #     @brands = Array.new
          @ads << Ad.search(params[:q],@user)
#          @brands << Brand.where('UPPER(name) LIKE UPPER(?)',"%#{@search_term}%")
@brands = Brand.includes(:ads).where("ads.user_id = ? AND UPPER(brands.name) LIKE UPPER(?)", @user.id, "%#{@search_term}%")
          @ads = @ads.flatten!
  #       @brands = @brands.flatten!
          respond_to do |format|
            format.json { render :json => {:response => "ok", :brands => @brands.as_json, :ads => @ads.as_json }}
          end
      else
        respond_to do |format|
          format.json { render :json => {:response => "failure"} }
        end
      end
    end
  end

end
