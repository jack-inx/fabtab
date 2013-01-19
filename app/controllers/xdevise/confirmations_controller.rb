class Xdevise::ConfirmationsController < Devise::ConfirmationsController
  def show
    @user = User.find_by_confirmation_token(params[:confirmation_token].to_s)
    if !@user.present?
      render_with_scope :new
    else
      flash[:error] = @user.errors.full_messages
      render 'show', :layout => 'signin'
    end
    
    
  end

  def confirm_user
    @user = User.find_by_confirmation_token(params[:user][:confirmation_token].to_s)
    if @user.complete_registration(params)
      @user = User.confirm_by_token(@user.confirmation_token)
      set_flash_message :notice, :confirmed      
      sign_in(:user, @user)
      respond_to do |format| 
        format.json { render :json=>{:result=>true,:auth_token=>@user.authentication_token}.to_json}
        format.html{redirect_to root_url}
      end
    else
      respond_to do |format| 
        format.json { 
          render :json=>{:result=>false,:message=>@user.errors.full_messages}.to_json
        }
        format.html{
          flash[:error] = @user.errors.full_messages
          render :action => "show" , :layout => 'signin'
        }
      end
            
    end
  end

  protected
  
  def after_resending_confirmation_instructions_path_for(resource_name)
    new_user_session_path
  end
  
  
end
