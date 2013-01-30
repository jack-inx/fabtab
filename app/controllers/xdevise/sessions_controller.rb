class Xdevise::SessionsController < Devise::SessionsController
  
  skip_before_filter :verify_authenticity, :only => [:omniauth]

  def new
    render 'xdevise/sessions/new', :layout => 'signin'
  end  

  def create

    @user = User.find_by_email(params[:user][:email])
    unless @user.nil?
      if @user.confirmation_token.nil?
        if @user.status == true

          if warden.authenticate(:scope => :user)
            sign_in(@user)
            respond_to do |format|
              format.html { respond_with @user, :location => after_sign_in_path_for(@user) }
              format.json { render :json => {:response => "ok", :auth_token => @user.authentication_token, :user_id => @user.id, :status => 200 } }
            end
          else
            flash[:notice] = 'Invalid credentials'
            redirect_to '/signin'
          end
        else
          flash[:notice] = 'User is deactivate'
          redirect_to '/signin'
        end
      else
        flash[:notice] = "You have been sent an email to complete your FabTab registration!'"
        respond_to do |format|
          
          format.html { redirect_to '/signin' }
          format.json { render :json => {:response => "You have been sent an email to complete your FabTab registration!" } }
        end
      end
    else
      flash[:notice] = 'Invalid credentials'
      respond_to do |format|
        format.html { redirect_to '/signin'  }
        format.json { render :json => {:response => "User with this email does not exist." } }
      end
    end
  end

  def omniauth
    omniauth = request.env["omniauth.auth"]
    user = User.find_by_email(omniauth['info']['email'])
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication && !user.nil?
      if user.status == true
        respond_to do |format|
          format.html {
            flash[:notice] = "Signed in successfully."
            sign_in_and_redirect(:user, authentication.user)
          }
          format.json { render :json => {:response => "ok", :auth_token => user.authentication_token}.to_json, :status => 200 }
        end
      else
        flash[:notice] = "User is deactivate"
        redirect_to '/signin'
      end
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      respond_to do |format|
        format.html {
          flash[:notice] = "Authentication successful."
          redirect_to user_settings_path
        }
        format.json { render :json => {:response => "ok", :auth_token => user.authentication_token}.to_json, :status => 200 }
      end
    elsif user
      user.authentications.build(:provider => omniauth ['provider'], :uid => omniauth['uid'])
      user.username = omniauth['info']['nickname']
      user.save(:validate => false)
      sign_in(user)
      respond_to do |format|
        format.html {
          flash[:notice] = "Signed in successfully."
          redirect_to root_url
        }
        format.json { render :json => {:response => "ok", :auth_token => user.authentication_token}.to_json, :status => 200 }
      end
    else
      user = User.new(:email => omniauth['info']['email'],:full_name => omniauth['info']['name'],:nickname => omniauth['info']['nickname'])
      user.authentications.build(:provider => omniauth ['provider'], :uid => omniauth['uid'])
      if user.save
        user.skip_confirmation!
        sign_in(user)
        respond_to do |format|
          format.html {
            #            redirect_to(:user)
            flash[:notice] = "Signed in successfully."
            redirect_to root_url
          }
          format.json {
            render :json => {:response => "ok", :auth_token => user.authentication_token}.to_json, :status => 200
          }
        end
      else
        respond_to do |format|
          format.html {
            session[:omniauth] = omniauth.except('extra')
            redirect_to new_registration_url
          }
          format.json {
            render :json => {:response => "fail"}.to_json, :status => 401
          }
        end
      end
    end
  end

  def fb_twitter
    if params[:provider] == "facebook"
      @user_auth = Authentication.find_by_provider_and_uid(params[:provider], params[:uid])
      if @user_auth.nil?
        @user = User.find_by_email(params[:email])
        if @user.nil?
          @user = User.new(:email => params[:email], :full_name => params[:name], :username => params[:nickname])
          @user.save(:validate => false)
          @user.authentications.build(:uid => params[:uid], :provider => params[:provider])
        else
          @user.authentications.build(:uid => params[:uid], :provider => params[:provider])
        end
      else
        @user = @user_auth.user
      end
      @user.skip_confirmation!
      sign_in(@user)
      render :json => { :auth_token => @user.authentication_token, :user_id => @user.id, :response => "ok"}
    elsif params[:provider] == "twitter"
      @user_auth = Authentication.find_by_provider_and_uid(params[:provider], params[:uid])
      if @user_auth.nil?
        if params[:email].nil?
          render :json => { :response => "Please enter email to complete signup."}
        else
          @user = User.find_by_email(params[:email])
          if @user.nil?
            @user = User.new(:email => params[:email], :full_name => params[:name], :username => params[:nickname])
            @user.save(:validate => false)
            @user.authentications.build(:uid => params[:uid], :provider => params[:provider])
          else
            @user.authentications.build(:uid => params[:uid], :provider => params[:provider])
          end
          @user.skip_confirmation!
          sign_in(@user)
          render :json => { :auth_token => @user.authentication_token, :user_id => @user.id, :response => "ok"}
        end
      else
        @user = @user_auth.user
        @user.skip_confirmation!
        sign_in(@user)
        render :json => { :auth_token => @user.authentication_token, :user_id => @user.id, :response => "ok"}
      end
    else
      render :json => { :response => "This provider is not allowed."}
    end
  end
  
end
