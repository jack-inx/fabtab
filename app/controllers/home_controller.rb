class HomeController < ApplicationController
  before_filter :authenticate_admin, :only => [:admin]
  before_filter :about_active, :only => [:about]
  before_filter :user_active, :only => [:index,:tabit,:help,:team,:terms]
  def index
    if current_user
      @user_folders = Group.where("user_id = ?",current_user.id)
      @category = Category.find_all_for_user(current_user)
      @ad = Ad.new
      respond_to do |format|
        format.html { render 'home/welcome'}
        format.json { render :json => {:response => "ok", :auth_token => current_user.authentication_token}.to_json, :status => 200 }
      end
    else
      redirect_to new_user_session_url
    end
  end
    
  def about
    render 'about', :layout => 'new_about'
  end
  
  def tabit
    render 'tabit', :layout => 'header'
  end
  
  def help
    render 'help', :layout => 'header'
  end

  def render_div
    @category = Category.find_all_for_user(current_user)
    @group = Group.find(params[:user_folder])
    respond_to do |format|
      format.js
    end
  end
  
  def team
    @feedback = Feedback.new
    @email = current_user.email
    @email_to = 'info@fabtab.com'
    render 'team', :layout => 'header'
  end
  
  def terms
    render 'terms', :layout => 'header'
  end

  def promo_help
    render 'promo_help', :layout => 'header'
  end

  def promo_tabit
    render 'promo_tabit', :layout => 'header'
  end

  def promo_team
    @feedback = Feedback.new
    #@email =
    @email_to = 'info@fabtab.com'
    render 'promo_team', :layout => 'header'
  end
  
  def promo_terms
    render 'promo_term', :layout => 'header'
  end

  def promo_invite
    @email_info= params[:format]
    if !@email_info.nil?
      flash[:notice] = "Please confirming the invite has been sent"
    end
    render 'promo_invite', :layout => 'header'
  end    
end
