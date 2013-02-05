require 'active_support/secure_random'
require 'base64'
require 'tempfile'
require 'stringio'

class AdsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new,:show,:index,:save]
  skip_before_filter :verify_authenticity_token, :only => [:update,:save]
  
  def index
    if params[:modified_since]
      @user_ads = Ad.where('created_at > ? ', DateTime.parse(params[:modified_since])).order('created_at DESC').reject { |ad| ad.image_url.nil? }
    else
      @user_ads = Ad.order('created_at ASC').reject { |ad| ad.image_url.nil?}
    end
    respond_to do |format|
      format.json { render :json => @user_ads.to_json(:include=> {:group => {:include => {:user => {:methods=> :nickname }}}}) }
    end
  end
  
  def new
    @category = Category.find_all_for_user(current_user)
    @ad_type = params[:type]
    @brand = Brand.all
    @ad = Ad.new(:url => params[:url], :image_url => params[:image_url])
    render 'new', :layout => 'tabit'
    
  end
  
  def test
    @ad = Ad.find(params[:id])
    render 'ads/show'
  end

  def show
    @category = Category.find_all_for_user(current_user)
    ad = Ad.find(params[:id])
    @new_ad = Ad.new(:url => ad.url, :image_url => ad.image_url)
    respond_to do |format|
      format.html { render 'ads/show' }
      format.json { render :json => ad }
    end
  end

  def save
    # logger.info "=== #{params[:email].blank?} && #{params[:category].blank?} && #{params[:tabcategory].blank?} && #{params[:brandname].blank?}"
    #logger.info "=== #{params[:email].nil?} && #{params[:category].nil?} && #{params[:tabcategory].nil?} && #{params[:brandname].nil?}"
    @user = User.find_by_email(params[:email])
    @ad = Ad.new(params[:ad])
    @ad.ad_type = "url"
    @ad.user_id = current_user.id
    #    logger.info "==== step 1 #{@user.email}"
    if @user.nil?
      #      logger.info "==== step 2 #{@user.email}"
      @user = User.new(:email=> params[:email])
      if @user.save
        render :text => 'Check your email and activate your account'
      end
    elsif @user == current_user
      #      logger.info "==== step 3 #{params[:category]} && #{params[:tabcategory]}"
      if params[:category].nil? && params[:tabcategory].nil?
        #        logger.info "===== step 4===="
        @group = current_user.groups.find_or_create_by_category_id(Category.find_permanent.id)
        @group.ads << @ad
        @group.save!
        redirect_to root_url
      else
        #        logger.info "=== step 5====#{params[:tabcategory]}"
        if !params[:tabcategory].blank?
          #          logger.info "=========step 6 #{params[:brandname]}"
          if params[:brandname].to_i == 0 
            @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
            #            logger.info "=== step 7 #{@category.nil?}"
            if !@category.nil?
              #              logger.info "========= step 8======="
              @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
            else
              #              logger.info "========= step 9======="
              @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase,current_user.id)
            end

          else
            #            logger.info "========= step 10 ======="
            @category = Category.find_or_create_by_name_and_brand_id_and_user_id(params[:tabcategory].downcase,params[:brandname].to_i,current_user.id)
          end
        else
          #          logger.info "========= step 11 ======= #{params[:category]} "
          @category_new = Category.find_by_id(params[:category])
          @category = Category.find_by_name_and_user_id(@category_new.name,@user.id)
          if !@category.nil?
            #            logger.info "==== step 12 =="
            @category = Category.find_by_name_and_user_id(@category_new.name,@user.id)
          else
            #            logger.info "==== step 13 =="
            @category = Category.find_or_create_by_name_and_user_id(@category_new.name,current_user.id)
          end

        end
        #        logger.info "==== step 14 == #{params[:brandname]}"
        if params[:brandname].to_i == 0
          #          logger.info "=== step 15 ==="
          @group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
          if !@group.nil?
            #            logger.info "=== step 16==="
            @group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
          else
            #            logger.info "=== step 17==="
            @group = current_user.groups.find_or_create_by_category_id(@category.id)
          end
        else
          #          logger.info "=== step 18=== #{params[:brandname]}"
          @brand = Brand.find(params[:brandname].to_i)
          @group = @brand.groups.find_or_create_by_category_id(@category.id)
          @ad.brand_id = @brand.id
        end
        #        logger.info "=== step 19 ==="
        @group.ads << @ad
        @group.save!
        respond_to do |format|
          #          logger.info "=== step 20 ==="
          format.json {render :json => @group.category.name.to_json }
        end        
      end
    elsif @user.confirmed?
      render 'users/authenticate', :layout=>false
    else
      render :text => "You have not activated your account. Check your email and activate your account"
    end
  end
  
  def wrapper
    render 'ads/wrapper', :layout=>false
  end
  
  def optin
    @optin_fields = current_user.ads.find(params[:ad_id]).optin_fields
    respond_to do |format|
      format.json { render :json => @optin_fields.to_json }
    end
  end
  

  def destroy
    @ad = Ad.find(params[:id])
    brand = @ad.brand_id
    if @ad.destroy
      respond_to do |format|
        format.json{ render :json => { :response => "success" }}
        flash[:notice]="Offer successfully deleted!"
        format.html { redirect_to setting_allusersads_path }
      end    
    else
      respond_to do |format|
        format.json{ render :json => { :response => "failure" }}
        format.html { redirect_to edit_brand_path(brand)}
      end
    end
  end

  def update
    @ad = Ad.find(params[:id])
    if params[:tabcategory]
      @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase,current_user)
    else
      @category = Category.find(params[:category].to_i)
    end
    @group = current_user.groups.find_or_create_by_category_id(@category.id)
    @group.ads << @ad
    @group.save!
    respond_to do |format|
      format.html { render :text => 'Successfully changed the category' }
      format.json { render :json => @ad.to_json(:include => :group) }
    end
  end
  
  def rate
    @ad = Ad.find(params[:id])
    respond_to do |format|
      if @ad.rate(params[:stars], current_user, params[:promotions])
        format.js { render :partial => "groups/rating" }
      else
        format.js { render :partial => "groups/rating" }
      end
    end
  end
  
  def test
    render :text => 'Success'
  end

  def search_ads
    @user = User.find_by_authentication_token(params[:auth_token])
    @query = params[:name]
    ads= Ad.findad(@query, @user)
    render :json => ads.to_json
  end


  def search_offers
    @query = params[:name]
    @user = User.find_by_authentication_token(params[:auth_token])
    offers= Ad.search(@query, @user)
    render :json=> offers.to_json
  end

  def snapit
    @user = User.find_by_authentication_token(params[:auth_token])

    if !params[:thumbnail_url].nil?
      @sio = StringIO.new(Base64.decode64(params[:encode_img]))
      @sio.original_filename = "#{@user.id + (Time.now).to_i}.png"
      @sio.content_type = "image/png"
      new_url = params[:weburl].to_s
      new_url.gsub!(/~/,'&')
      @ad = Ad.create(:ad_type => params[:type], :longitude => params[:longitude], :latitude => params[:latitude], :image => @sio, :user_id => @user.id, :url => new_url)
      @ad.image_url = params[:thumbnail_url]
      @ad.save(:validate => false)
    else
      @sio = StringIO.new(Base64.decode64(params[:encode_img]))
      @sio.original_filename = "#{@user.id + (Time.now).to_i}.png"
      @sio.content_type = "image/png"
      @ad = Ad.create(:ad_type => params[:type], :longitude => params[:longitude], :latitude => params[:latitude], :image => @sio, :user_id => @user.id)
      @ad = Ad.find_by_id(@ad.id)
      @ad.image_url = @ad.image.to_s
      @ad.save(:validate => false)
      @ad.url = @ad.image_url
      @ad.save(:validate => false)
    end
    if params[:tabcategory]
      if params[:brandname].to_i == 0
        #        @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase, @user.id)
        @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
        if !@category.nil?
          @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
        else
          @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase,current_user.id)
       	end
      else
        @category = Category.find_or_create_by_name_and_brand_id(params[:tabcategory].downcase, params[:brandname].to_i)
      end
    else
      if params[:category_id] == "0"
        @category = Category.find_by_name_and_user_id(params[:name].downcase,@user.id)
        if @category.nil?
          @category = Category.create(:name => params[:name])
          @category.user = @user
          @category.save!
        end
      else
        @category = Category.find(params[:category_id].to_i)
      end
    end
    if params[:brandname].to_i == 0
      @group = @user.groups.find_or_create_by_category_id(@category.id)
      #		@group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
      #   if !@group.nil?
      #	  @group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
      # else
      #	@group = current_user.groups.find_or_create_by_category_id(@category.id)
      # end
    else
      @brand = Brand.find(params[:brandname].to_i)
      @group = @brand.groups.find_or_create_by_category_id(@category.id)
      @ad.brand_id = @brand.id
    end
    @group.ads << @ad
    @group.save!
    render :json => {:response => "ok", :ad_id => @ad.id, :category_id => @category.id, :category_name => @category.name}
  end

  def scanit            
    @user = User.find_by_authentication_token(params[:auth_token])
    #@image = IMGKit.new(params[:weburl],:quality => 50 ,:width => 300 ,:height => 250)
    if !params[:thumbnail_url].nil?

      @ad = Ad.new()
      new_url = params[:weburl].to_s
      new_url.gsub!(/~/,'&')
      @ad.url = new_url
      @ad.ad_type = params[:type]
      @ad.longitude = params[:longitude]
      @ad.latitude = params[:latitude]
      @ad.user_id = @user.id
      @ad.image_url = params[:thumbnail_url]
      @ad.save!
    else
      @image_url = "#{Rails.root}"+"/public/#{@user.id + (Time.now).to_i}.jpg"
      #@image.to_file("#{@image_url}")
      `xvfb-run wkhtmltoimage-amd64 --crop-h 800 --crop-w 900 --crop-x 0 --crop-y 0  --use-xserver "#{params[:weburl]}" "#{@image_url}"`
      @ad = Ad.new()
      @ad.url = params[:weburl]
      @ad.ad_type = params[:type]
      @ad.longitude = params[:longitude]
      @ad.latitude = params[:latitude]
      @ad.user_id = @user.id
      #    @ad.image = @image_url
      @ad.image = @ad.picture_from_url(@image_url)
      @ad.save!
      @ad.image_url = @ad.image.to_s
      @ad.save!
      `rm "#{@image_url}"`
    end
    #@image_name = Time.now.to_i
    #%x[cutycapt --url=#{params[:weburl]} --out="#{@image_name}.jpg" --min-width=600 --min-height=10]

    #@image.original_filename = "#{@user.id + (Time.now).to_i}.jpg"
    #@image.content_type = "image/png"
    #@ad = Ad.create(:url => params[:weburl], :ad_type => params[:type], :longitude => params[:longitude], :latitude => params[:latitude], :user_id => @user.id, :image => @add_image.picture_from_url(@image_url))
    #@ad.url = @ad.image.to_s

    if params[:tabcategory]
      if params[:brandname].to_i == 0
        # @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase, @user.id)
        @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
        if !@category.nil?
          @category = Category.find_by_name_and_user_id(params[:tabcategory],@user.id)
        else
          @category = Category.find_or_create_by_name_and_user_id(params[:tabcategory].downcase,current_user.id)
        end
      else
        @category = Category.find_or_create_by_name_and_brand_id(params[:tabcategory].downcase, params[:brandname].to_i)
      end
    else
      if params[:category_id] == "0"
        @category = Category.find_by_name_and_user_id(params[:name].downcase,@user.id)
        if @category.nil?
          @category = Category.create(:name => params[:name])
          @category.user = @user
          @category.save!
        end
      else
        @category = Category.find(params[:category_id].to_i)
      end
    end
    if params[:brandname].to_i == 0
      @group = @user.groups.find_or_create_by_category_id(@category.id)
      #	@group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
 
      #   if !@group.nil?
      #	  @group = Group.find_by_category_id_and_user_id(@category.id,current_user.id)
      # else
      #	@group = current_user.groups.find_or_create_by_category_id(@category.id)
      # end
    else
      @brand = Brand.find(params[:brandname].to_i)
      @group = @brand.groups.find_or_create_by_category_id(@category.id)
      @ad.brand_id = @brand.id
    end
    @group.ads << @ad
    @group.save!
    render :json => {:response => "ok", :ad_id => @ad.id,:ad_imageurl => @ad.image_url, :category_id => @category.id, :category_name => @category.name}
  end

  def ad_fb_comment
    @user=User.find_by_authentication_token(params[:auth_token])
    @ad_id = params[:ad_id]
    @fb_comment_id = params[:fb_comment_id]
    @ad_fb_comment = AdFbComment.create(:ad_id => params[:ad_id], :fb_comment_id => params[:fb_comment_id], :user_id => @user.id)
    render :json => {:response => "ok", :fb_comment_id => @ad_fb_comment.fb_comment_id, :ad_id => @ad_fb_comment.ad_id }
  end
  

  def ads_show
    @user=User.find_by_authentication_token(params[:auth_token])
    sign_in(@user)
    @adl = Ad.find(params[:ad_id])
    render :json => @adl.to_json
  end

  def tabit_category_list
    @brand = Brand.all
    render :partial => "tabit_category_list" , :object => @brand
  end
  def ads_statuschange
    @ads = Ad.find(params[:id])
    @ads.update_attributes(:status => false)
  end
  def ads_statusunchange
    @ads = Ad.find(params[:id])
    @ads.update_attributes(:status => true)
  end

  def flags_ad
    @ads = Ad.find(params[:id])
    @email =  User.where("id = ?",@ads.user_id)
    @currentuser = current_user
    @user = User.admins
    @ads.flag = 1
    @ads.flagupdate = Time.now
    @ads.save!
    @user.each do|user|
      UserMailer.flag_status(user,@ads,@currentuser).deliver
    end
    respond_to do |format|
      format.html { render :text => 'Successfully changed the category' }
    end
  end
  
  def remove_ad
    @ads = Ad.find(params[:id])
    @ads.destroy
    respond_to do |format|
      format.js
    end
  end
end

