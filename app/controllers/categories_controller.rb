class CategoriesController < ApplicationController
  before_filter :authenticate_user! , :except => :destroy_category
  

  def index
    if(params[:category_name].nil?)
      all_user_categories = Category.find_all_for_user(current_user)
    else
      all_user_categories = Category.find_all_for_user_by_name(current_user.id,params[:category_name])
    end
    render :json=> all_user_categories.to_json
  end

  def create
    @category = Category.create(:name => params[:name])
    @category.user = current_user
    @category.save!
    respond_to do |format|
      format.json { render :json => @category.to_json }
    end
  end

  def show 
    category = Category.find(params[:id])
    render :json=>category.to_json
  end

  def destroy_category
    @cat = Category.find(params[:id])
    @category = Category.find_offers(@cat)
    @category.each do |category|
      category.destroy
    end
    if @cat.destroy
      render :json => { :response => "success" }
    else
      render :json => { :response => "failure" }
    end
  end
  
  def offers
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @coupan_list = Array.new
    if params[:offertype] == "category"
      @coupan_list << Category.find_offers(params[:id])
      @coupan_list.flatten!
      @coupans = @coupan_list.to_json(:include => [ :ad_fb_comments, :offers ])
    elsif params[:offertype] == "brand"
      @coupan_list << Ad.where("brand_id = ?", params[:id])
      @coupan_list.flatten!
      @coupans = @coupan_list.to_json(:include => [ :ad_fb_comments, :offers ])
    end
    render :json => @coupans.as_json
    #@coupan_list1.collect! { |i| if i == nil then [] else i end   }
  end

  def my_local_offers
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    offers = Category.my_local_offers(params[:latitude],params[:longitude], params[:id])
    @offerloc = offers.as_json(:include => :ad_fb_comments)
    render :json => {:offers => @offerloc}
  end

  def my_local_offers_without_category
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @admin_user = User.find_by_admin(true)
    @ads_list = Category.my_local_offers_without_category(params[:latitude],params[:longitude], params[:radius])
    
    #    @admin_user = User.find_by_admin(true)
    #     @category = Category.all
    #      @category.each do |i|
    #        if i.user_id == @admin_user.id
    #         # @ads_list = i.my_local_offers_without_category(params[:latitude],params[:longitude], params[:radius])
    #          @ad_list << Ad.near([params[:latitude],params[:longitude]],params[:radius]).joins([{:group=>:category}])
    #        end
    #      end
    
    unless @ads_list.blank?
      @offerloc = @ads_list.as_json(:include => [:ad_fb_comments, :offers] )
      render :json => {:offers => @offerloc, :user_id => @user.id , :admin_userid => @admin_user.id  }
    else
      render :json => {:error => 'No local offers exists'}
    end
  end

	def category_list
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @admin_user = User.find_by_admin(true)
    @brand = []
    if(params[:category_name].nil?)
      @user_folders = @user.groups.sort {|group_a,group_b| group_b.updated_at <=> group_a.updated_at }.reject { |group| (group.category.nil? && group.permanent? )}
      @category_ids = @user_folders.map {|i| i.category_id }
      @all_user_categories = Category.where("id in (?)", @category_ids)
      logger.info "========================#{@all_user_categories.count}================================================"
      @ad = Ad.where("user_id = ?",@user.id)
      @ad.each do |ad|
        @brand << ad.brand
      end
      @brand.delete_if { |brand| brand.nil? }
    else
      @all_user_categories = Category.find_for_user_by_name(@user.id, params[:category_name])
    end
      logger.info "========================#{@all_user_categories.count}================================================"
        logger.info "========================#{@brand.count}================================================"
    @brand.uniq!
            p "========================#{@brand.count}================================================"
    render :json=>  { :categories => @all_user_categories.as_json, :brand => @brand.as_json }
  end

  def local_storage_data
    @user = User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @admin_user = User.find_by_admin(true)
    @brand = []
    @coupan_list = Array.new
    @group = Array.new
    @user_folders = @user.groups.sort {|group_a,group_b| group_b.updated_at <=> group_a.updated_at }.reject { |group| (group.category.nil? && group.permanent? )}
    @category_ids = @user_folders.map {|i| i.category_id }
    @all_user_categories = Category.where("id in (?)", @category_ids)
    @ad = Ad.where("user_id = ?",@user.id)
    @ad.each do |ad|
      @brand << ad.brand
    end
    @brand.delete_if { |brand| brand.nil? }
   # @all_user_categories.each do |category|
   #   @group << Group.where("category_id = ?",category.id)
 #     @coupan_list << Category.find_offers(category.id)
  #  end
#    @brand.each do |brand|
      @group <<  Group.where("user_id = ?",@user.id)
#      @coupan_list << Ad.where("brand_id = ?", brand.id)
 #   end
@coupan_list << Ad.where("user_id = ?",@user.id)
    @coupan_list.flatten!
    @group.flatten!
    @coupan_list.uniq!
    @brand.uniq!
    @group.uniq!
    @coupans = @coupan_list.as_json(:include => [ :ad_fb_comments, :offers ])
    render :json=>  { :categories => @all_user_categories.as_json, :brand => @brand.as_json, :ads => @coupans.as_json, :groups => @group.as_json }
  end
  #  def local_storage_data
  #    @user = User.find_by_authentication_token(params[:auth_token])
  #    sign_in(@user)
  #    @admin_user = User.find_by_admin(true)
  #    @all_user_categories = Array.new
  #    @grp = []
  #    @brand = []
  #    @ads = Ad.all
  #    @ads.each do |ad|
  #      if !ad.brand_id.nil? && ad.user_id == @user.id
  #        @brand << ad.brand
  #        @grp << ad.group
  #        @grp.each do |grp|
  #          @all_user_categories << grp.category
  #        end
  #      end
  #    end
  #    @brand.flatten!
  #    @all_user_categories.compact!
  #
  #    #    @user_folders = @user.groups.sort {|group_a,group_b| group_b.updated_at <=> group_a.updated_at }.reject { |group| (group.category.nil? && group.permanent? )}
  #    #    @category_ids = @user_folders.map {|i| i.category_id }
  #    #    @all_user_categories = Category.where("id in (?)", @category_ids)
  #    #    if @user.id != @admin_user.id
  #    #      @category = Category.all
  #    #      @category.each do |i|
  #    #        if i.user_id == @admin_user.id
  #    #          @all_user_categories << i
  #    #        end
  #    #      end
  #    #    end
  #    @groups = Array.new
  #    @coupan_list = Array.new
  #    @all_user_categories.each do |category|
  #      @groups << Group.find_by_category_id(category.id)
  #      @coupan_list << Category.find_offers(category.id)
  #    end
  #    @groups.flatten!
  #    @coupan_list.flatten!
  #    @coupan_list.delete_if { |ad| ad == []  }
  #    @groups.delete_if { |group| group.nil? }
  #    @brand.delete_if { |brand| brand.nil? }
  #    @brand.uniq!
  #    @coupan_list.uniq!
  #    @coupans = @coupan_list.as_json(:include => [ :ad_fb_comments, :offers ])
  #    render :json=>  { :categories => @all_user_categories.as_json, :ads => @coupans.as_json ,:groups => @groups.as_json, :brand => @brand.as_json}
  #  end
  
end
