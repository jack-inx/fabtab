require 'Ad'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location

  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "xdevise/sessions"
  end
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
  
  def authenticate_admin
    unless current_user.admin?
      render 'public/401.html', :layout => false, :status => 401
    end
  end
  
  def about_active
    @about = 'active'
  end
  
  def user_active
    @settings = 'active'
  end
  
  def admin_active
    @admin = 'active'
  end
  
  def invite_active
    @invite = 'active'
  end
  
end
