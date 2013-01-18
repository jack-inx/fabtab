class RegistrationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:index,:show,:destroy]
  
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
      @user = User.find_by_email(params[:user][:email])
      if session[:omniauth]
        unless @user
          @user = User.create(:email => params[:user][:email])
          @user.skip_confirmation!
        end
        @user.username = session[:omniauth]['info']['nickname']
        @user.apply_omniauth(session[:omniauth])
        @user.save!
        sign_in(@user)
        respond_to do |format|
          format.html { redirect_to root_url }
          format.json { render :json => {:response => "ok", :auth_token => @user.authentication_token}.to_json, :status => 200 }
        end
      else
        if @user
          flash[:notice] = "You have already signed up. Please log in"
        else
@uname = params[:user][:email].split('@')[0]
          @user = User.create(:email => params[:user][:email],:username => @uname )
          flash[:notice] = "You are now registered! Check your email for confirmation."
        end
        respond_to do |format|
          format.html { redirect_to "/signin" }
          format.json { render :json => {:response => "ok"}.to_json, :status => 200 }
        end
      end
    else
      @user = User.find_by_email(params[:user_email])
      if @user
        @user_status = "You have already signed up. Please log in."
      else
        @user = User.create(:email => params[:user_email])
        @user_status = "You are now registered! Check your email for confirmation."
        flash[:notice] = "You are now registered! Check your email for confirmation."
      end
      respond_to do |format|
        format.html { redirect_to '/signin'}
        format.json { render :json => {:response => @user_status} }
      end      
    end
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
