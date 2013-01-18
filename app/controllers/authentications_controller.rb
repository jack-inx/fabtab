class AuthenticationsController < ApplicationController
  before_filter :authenticate_admin , :only=>[:index]
  
  def index
    @authentications = current_user.authentications if current_user
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to user_settings_path
  end
end
