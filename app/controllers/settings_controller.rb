class SettingsController < ApplicationController
  skip_before_filter :store_location
  before_filter :authenticate_user!, :except => [:omniauth_fb, :omniauth_tw]
  before_filter :admin_active, :only => [:edit]
  before_filter :authenticate_admin, :only => [:update,:edit]

  def omniauth_tw
    @auth_uid = Authentication.find_by_uid(params[:uid])
    unless @auth_uid.nil?
      @user = @auth_uid.user
      sign_in(@user)
      render :json => {:response => 'ok', :auth_token => @user.authentication_token}
    else
      render :json => {:error => 'No such user exists'}
    end
  end

  def omniauth_fb
    @auth_uid = Authentication.find_by_uid(params[:uid])
    
    unless @auth_uid.nil?
      @user = @auth_uid.user
      sign_in(@user)
      render :json => {:response => 'ok', :auth_token => @user.authentication_token}
    else
      render :json => {:error => 'No such user exists'}
    end
  end

  def parameters
    @setting = Setting.first
    respond_to do |format|
      format.json { render :json => @setting }
    end
  end
  
  def edit
    @setting = Setting.first
    if @setting.nil?
      @setting = Setting.new
    end      
    render 'edit', :layout => 'application'
  end
  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to admin_edit_path
    end
  end
  
  def update
    @setting = Setting.first
    if params[:setting][:carousel_refresh].to_i >= 5 && @setting.update_attributes(params[:setting])
      flash[:notice] = 'Successfully update the settings'
      redirect_to admin_edit_path
    else
      flash[:notice] =  'Error while updating the settings, time interval cannot be less than 5 seconds'
      redirect_to admin_edit_path
    end
  end
 
 
  def users_list
    @user = User.all
    
    @users = User.search(params[:query])
    @u = User.all
    respond_to do |format|
      format.html { render 'users_list', :layout => 'admin' }
      format.xls
      format.js
    end
    
  end

  def new_users
    @user = User.new
    render 'new_users', :layout => 'admin'
  end
  
  def create_users 
    @user = User.new(params[:user])
    if params[:user][:admin] == "1"
      @user.admin = true
    else
      @user.admin = false
    end
    
    @user.skip_confirmation!

    if @user.save
      flash[:notice] = "User successfully created "
      #@user.confirm!
      redirect_to setting_users_list_path
    else
      flash[:notice] = "#{@user.errors.full_messages.join(', ')}"
      #render setting_new_users_path
      render :action=>'new_users', :message => @user , :layout => 'admin'
    end
  end
  
  def edit_users
    @user = User.find(params[:id])
    render 'edit_users', :layout => 'admin'
  end

  def show_users
    @user = User.find(params[:id])
    render 'show_users', :layout => 'admin'
  end

  def update_users
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.save(validate: false)
    redirect_to setting_users_list_path
    flash[:notice] = "User successfully updated! "
  end

  def destroy_users
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      flash[:notice] = "User successfully deleted!"
      format.html { redirect_to(setting_users_list_path) }
    end
  end
  def multipleuser
    @user = User.find(params[:ids])
    @user.each { |u| u.destroy }
    flash[:notice] = "User successfully deleted!"
    redirect_to setting_users_list_path
  end
  def destroy_fbtw
    @authentication = Authentication.where("user_id = ?",params[:id].to_i)
    @authentication.destroy_all
    flash[:notice] = "Link removed"
    redirect_to setting_users_list_path
  end
  def sort_username
    @user = User.order("username ASC")#.page(params[:page]).per(7)
  end


  def allusersads
    if params[:grid_list] == 'list_clz'
      @listview = 'list_clz'
    elsif params[:grid_list] == 'grid_clz'
      @gridview = 'grid_clz'
    else
      @listview = 'list_clz'
    end
    @user = User.page(params[:page]).per(7)
    @ads = Ad.order("created_at desc").all
    respond_to do |format|
      format.html{ render :layout => "application"}
    end
  end	


  def destroy_ads
    @ad = Ad.find(params[:id])
    @ad.destroy
    respond_to do |format|
      flash[:notice] = "Offer successfully deleted!"
      format.html { redirect_to(setting_allusersads_path) }
    end
  end

  def destroy_userscategories
    @category = Category.find(params[:id])
    @category.destroy
    @group = Group.where("category_id = ?",@category.id)
    @group.each do|group|
      @ad = Ad.where("group_id = ?",group.id)
      group.destroy
      @ad.destroy_all
    end
    respond_to do |format|
      flash[:notice] = "Category successfully deleted!"
      format.html { redirect_to(setting_category_list_path) }
    end
  end

  def flag_ads
    @ads = Ad.where("flag = ?",true).page(params[:page]).per(7)
  end
  
  def multipleads
    @ad = Ad.find(params[:ids])
    @ad.each { |a| a.destroy }
    flash[:notice] = "Offer successfully deleted!"
    redirect_to setting_allusersads_path
  end
  
  def ignore_notification
    @ad = Ad.find(params[:id])
    @ad.update_attributes(:flag => false)
    @currentuser = current_user
    @user = User.admins
    @user.each do|user|
      UserMailer.ignore_status(@ad,@currentuser,user).deliver
    end
    flash[:notice] = "Offer successfully ignored!"
    redirect_to setting_allusersads_path
  end


  def category_list
    @category = Category.where('user_id IS NOT NULL and name not like ?','my saved fabtabs').page(params[:page]).per(7)
    respond_to do |format|
      format.html{render :layout => "admin"}
    end
  end
  
  def category_ads
    @category = Category.find(params[:id])
    @group =  Group.where("category_id = ?",@category.id)
    @group.each do|group|
      @ad = Ad.where("group_id = ?",group.id)
    end
    respond_to do |format|
      format.js
    end
  end
  def master_password
    @mpasswords = MasterPassword.first
    if @mpasswords.nil?
      @mpassword = MasterPassword.new
    else
      @mpasswords.mpassword = MasterPassword.decrypt
      @mpassword = @mpasswords
    end
    respond_to do |format|
      format.html { render :layout =>'admin'}
    end
  end


  def new_mpassword
    @mpassword = MasterPassword.first
    respond_to do |format|
      if @mpassword.nil?
        @mpassword = MasterPassword.new(params[:master_password])
        if @mpassword.save
          format.html { redirect_to admin_edit_path, notice: 'Master Password was successfully created.' }
          format.json { render json: admin_edit_path, status: :created, location: admin_edit_path }
        else
          format.html { render action: "master_password",:layout =>'admin' }
          format.json { render json: @mpassword.errors, status: :unprocessable_entity }
        end
      elsif @mpassword.update_attributes(params[:master_password])
        format.html { redirect_to admin_edit_path, notice: 'Master Password was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "master_password",:layout =>'admin' }
        format.json { render json: @mpassword.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
