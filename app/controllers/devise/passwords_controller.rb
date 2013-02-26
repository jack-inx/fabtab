class Devise::PasswordsController < ApplicationController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers
 layout "signin"


  # GET /resource/password/new
  def new
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    if successfully_sent?(resource)
      flash[:notice] = "Check your email to create a new password"
      respond_to do |format|
        format.html { redirect_to "/signin" } #after_sending_reset_password_instructions_path_for(resource_name)
        format.json { render :json => { :response => "New Password link has been sent to your email-address" } }
      end
    else
      respond_to do |format|
        format.html { render_with_scope :new }
        format.json { render :json => { :response => "Email does not exist" } }
      end
      #respond_with_navigational(resource){ render_with_scope :new }
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render_with_scope :edit
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      redirect_to index_path
      #respond_with resource, :location => after_sign_in_path_for(resource)
    else
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

  protected

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name)
  end

end
