class BrandRequestsController < ApplicationController
  before_filter :authenticate_admin
  
  def index
    @brand_requests = BrandRequest.all
    @brands = Brand.all
  end
  
  def destroy
    @brand_request = BrandRequest.find(params[:id])
    @ad = @brand_request.ad
    #    @ad_keep = @brand_request.ad
    #    user_keep = @ad_keep.user_id
    #    group_keep = @ad_keep.group_id
    @ad.brand_id = params[:brand].to_i
    @user = User.find(@brand_request.user)
    #@category = Category.find_or_create_by_user_id_and_brand_id(@user.id,params[:brand].to_i)
    @super_folder = Group.find_or_create_by_user_id_and_brand_id(@user.id, params[:brand].to_i)
    @category = Category.find_or_create_by_name_and_user_id('my saved fabtabs', @user.id)
    #   @brand_user_folder = Group.find_or_create_by_category_id_and_brand_id_and_user_id(@category.id, params[:brand].to_i,@user.id)
    @ad.group_id = @super_folder.id
    @ad.save!
    @super_folder.ads << @ad
    @super_folder.save!


    purpose = Purpose.arel_table
    purpose_id = Purpose.where(purpose[:name].matches("%brand set%")).first.id
    template = Template.find_by_purpose_id(purpose_id)

    if template
      @var = template.content
    
      if @ad.url.nil?
        @ad.url = @ad.image_url
      end

      @token = SecureRandom.urlsafe_base64
      
      unsubscribe_link = unsubscribe_me_url(:token => @token,:id=>@user.id)
      @var = @var.gsub("{{unsubscribe}}", "<a href=#{unsubscribe_link}>Click here</a>")


      registration_link = new_registration_url
      @var = @var.gsub("{{subscribe}}", "<a href=#{registration_link}>Click here</a>")
      @var = @var.gsub("{{user_name}}", @user.nickname.capitalize)
      @var = @var.gsub("{{user_email}}", @user.email)
      @var = @var.gsub('{{user_ema<font size="2">il}}', @user.email)


      @var = @var.gsub("{{ad_image_url}}",@ad.url)
      @var = @var.gsub("{{brand_name}}", @ad.brand.name )
      # UserMailer.brand_folder_set_up(@user,@ad.url,@ad.image_url,@ad.brand.name).deliver
      UserMailer.brand_folder_set_up(@user,@ad.url,@ad.brand.name, @var).deliver
    end
    @brand_request.destroy



    respond_to do |format|
      format.html { redirect_to brand_requests_path }
      format.json { render :json => @brand_request }
    end
  end

end
