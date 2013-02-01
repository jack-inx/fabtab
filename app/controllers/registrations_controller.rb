class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index,:show,:destroy]
  layout "signin", :only=>[:create]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @user_ads = @user.ads.reject { |ad| ad.image_url.nil? }
  end
  
  def new
    @user = User.new
    render 'new', :layout => 'signin'
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to registrations_url
    end
  end
  
  def create
    if params[:user_email].nil?
      logger.info "======= step 1========"
      @user = User.find_by_email(params[:user][:email])
      if session[:omniauth]
        unless @user
          @user = User.create(:email => params[:user][:email])
          @user.skip_confirmation!
        end
        @user.username = session[:omniauth]['info']['nickname']
        @user.apply_omniauth(session[:omniauth])
        @user.save(:validate => false)
        sign_in(@user)
        respond_to do |format|
          format.html { redirect_to root_url }
          format.json { render :json => {:response => "ok", :auth_token => @user.authentication_token}.to_json, :status => 200 }
        end
      else
        logger.info "======= step 2========"
        if @user
          logger.info "======= step 3========"
          flash[:notice] = "You have already signed up. Please log in"
          respond_to do |format|
            logger.info "======= step 4========"
            format.html { redirect_to "/signin" }
            format.json { render :json => {:response => "ok"}.to_json, :status => 200 }
          end
        else
          logger.info "======= step 5========"
          @uname = params[:user][:email].split('@')[0]
          @user = User.new(:email => params[:user][:email],:username => @uname ,:password => "12345678", :password_confirmation => "12345678")
          respond_to do |format|
            logger.info "======= step 6========"
            if @user.save
              logger.info "======= step 7========"
              format.html { redirect_to  '/signin'}
              flash[:notice] = "You are now registered! Check your email for confirmation."
            else
              logger.info "======= step 8========"
              format.html { render :action=> "new" }
              format.json { render :json=> @user.errors, status=> :unprocessable_entity }
            end
            logger.info "======= step 9========"
          end
          logger.info "======= step 10========"
          #flash[:notice] = "You are now registered! Check your email for confirmation."
        end
#        respond_to do |format|
#          logger.info "======= step 11========"
#          # format.html { redirect_to "/signin" }
#          format.json { render :json => {:response => "ok"}.to_json, :status => 200 }
#        end
        logger.info "======= step 12========"
      end
    else
      logger.info "======= step 13========"
      @user = User.find_by_email(params[:user_email])
      @uname = params[:user_email].split('@')[0]
      respond_to do |format|
        logger.info "======= step 14========"
        if @user
          logger.info "======= step 15========"
          @user_status = "You have already signed up. Please log in."
        else
          logger.info "======= step 16========"
          @user = User.create(:email => params[:user_email],:username => @uname ,:password => "12345678", :password_confirmation => "12345678")
          @user_status = "You are now registered! Check your email for confirmation."
          flash[:notice] = "You are now registered! Check your email for confirmation."
        end
        logger.info "======= step 17========"
        format.html { redirect_to '/signin'}
        format.json { render :json => {:response => @user_status} }
      end
      logger.info "======= step 18========"
      # @user = User.find_by_email(params[:user_email])
      # @uname = params[:user_email].split('@')[0]
      # if @user
      #   @user_status = "You have already signed up. Please log in."
      # else
      #   @user = User.new(:email => params[:user_email],:username => @uname ,:password => "12345678", :password_confirmation => "12345678")
      #   respond_to do |format|
      #     if @user.save
      #       format.html { redirect_to  '/signin'}
      #       flash[:notice] = "You are now registered! Check your email for confirmation."
      #     else
      #       format.html { render :action=> "new" }
      #       format.json { render :json=> @user.errors, status=> :unprocessable_entity }
      #     end
      #   end
      #     @user_status = "You are now registered! Check your email for confirmation."
      #   # flash[:notice] = "You are now registered! Check your email for confirmation."
      # end
      # respond_to do |format|
      #   format.html { redirect_to '/signin'}
      #   format.json { render :json => {:response => @user_status} }
      # end
    end
    logger.info "======= step 19========"
  end

  def unsubscribe
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to registrations_url
    else
      flash[:notice] = "You do not have an account."
      redirect_to registrations_url
    end

  end
  
end
