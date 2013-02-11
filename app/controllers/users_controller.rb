class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :user_active, :only => [:settings]
  before_filter :invite_active, :only => [:invite,:email]

  def index
    redirect_to index_path
  end
  
  def settings
    @user = current_user
    @facebook = current_user.authentications.select { |authentication| authentication.provider == 'facebook' }
    @twitter = current_user.authentications.select { |authentication| authentication.provider == "twitter" }
    render 'settings', :layout => 'about'
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    logger.info params[:user][:password]
    if @user.update_attributes(params[:user])
      sign_in(@user, :bypass => true)
    end
    respond_to do |format|
      format.json  { render :json => @user.to_json }
    end
  end
  

  def follow_brand
    @ad = Ad.find(params[:ad_id])
    if @ad.brand.nil?
      @brand_request = BrandRequest.find_by_ad_id(@ad.id)
      if @brand_request
        render :text => "You have already contacted this brand, they will get in touch with you soon" 
      else
        current_user.brand_requests.create(:ad_id => @ad.id)
        purpose = Purpose.arel_table
        purpose_id = Purpose.where(purpose[:name].matches("%follow req%")).first.id
        template = Template.find_by_purpose_id(purpose_id)

        if template
          @var = template.content
          User.admins.each do |admin|
            @var = @var.gsub("{{admin_email}}",admin.email)
            @var = @var.gsub("{{user_name}}", current_user.nickname.capitalize)
            @var = @var.gsub('{{user_ema<font size="2">il}}', current_user.email)

            registration_link = new_registration_url
            @var = @var.gsub("{{subscribe}}", "<a href=#{registration_link}>Click here</a>")
            @var = @var.gsub("{{user_email}}", current_user.email)
            @var = @var.gsub("{{ad_image_url}}",@ad.image_url)
            @var = @var.gsub("{{ad_token}}", @ad.id.to_s )
        
            AdminMailer.follow_request(admin,@ad,current_user,@var).deliver
          end
        end

        purpose = Purpose.arel_table
        purpose_id = Purpose.where(purpose[:name].matches("%brand req%")).first.id
        template = Template.find_by_purpose_id(purpose_id)       

        #	 template = Template.find_by_purpose("Brand Request Confirmation")
        if template
          @var = template.content
          @var = @var.gsub('{{user_ema<font size="2">il}}', current_user.email)

          @token = SecureRandom.urlsafe_base64

          unsubscribe_link = unsubscribe_me_url(:token => @token,:id=>current_user.id)
          @var = @var.gsub("{{unsubscribe}}", "<a href=#{unsubscribe_link}>Click here</a>")

          registration_link = new_registration_url
          @var = @var.gsub("{{subscribe}}", "<a href=#{registration_link}>Click here</a>")        
          @var = @var.gsub("{{user_email}}", "#{current_user.email}")
          UserMailer.brand_request_confirmation(current_user,@var).deliver
        end
        render :text => 'Thank you, this brand will be in touch with you soon!'
      end
    else
      unless @ad.brand.followers.include?(current_user)
        logger.info "adding user in list of brand followers"
        @ad.brand.followers << current_user
      end
      respond_to do |format|
        flash[:notice] = 'You have already contacted this brand'
        format.json { render :json => { :location => brand_path(@ad.brand) } }
      end
    end
  end  

  def invite
    #    @email_info= params[:format]
    #    if !@email_info.nil?
    #      flash[:notice] = "Email successfully sent"
    #    end
    render 'invite', :layout => 'settings'
  end


  def email

    email_list = []
    count = 0
    emails = params[:email].split(',')
    emails.each do |f|

      if f =~ /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i

        purpose = Purpose.arel_table
        purpose_id = Purpose.where(purpose[:name].matches("%invitation%")).first.id
        template = Template.find_by_purpose_id(purpose_id)

        if template
          count =count + 1
          @var = template.content
          @var = @var.gsub('{{user_ema<font size="2">il}}', current_user.email)
          registration_link = new_registration_url
          @var = @var.gsub("{{subscribe}}", "<a href=#{registration_link}>Click here</a>")
          @var = @var.gsub("{{user_email}}", current_user.email)
          @var = @var.gsub("{{user_name}}",current_user.nickname.capitalize)
          email_list << f
        end
      end
    end
    if count > 0
      UserMailer.invite(current_user,email_list,@var).deliver
    else
      flash[:notice] = "Please enter valid addresses separated by comma only"
    end
    if count > 0
      flash[:notice] = "Email successfully sent"
    end
    redirect_to promo_invite_path
  end


  def search_username
    @user = User.search(params[:query])#.page(params[:page]).per(7)
    respond_to do |format|
      format.js
    end
  end  
  def status_change
    @user = User.find params[:id]
    @user.update_attributes(:email => @user.email, :username => @user.username, :status => false, :statusupdated => Time.now )
  end
  
  def status_unchange
    @user = User.find params[:id]
    @user.update_attributes(:email => @user.email, :username => @user.username, :status => true, :statusupdated => Time.now )
  end
  def adminstatus_change
    @user = User.find params[:id]
    @user.update_attributes(:email => @user.email, :username => @user.username, :admin => true)
  end

  def adminstatus_unchange
    @user = User.find params[:id]
    @user.update_attributes(:email => @user.email, :username => @user.username, :admin => false)
  end
end
