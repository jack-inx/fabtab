class GroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :sort_by_parameter, :only => [:index,:show]
  before_filter :user_active, :only => [:index,:show]

  def index
    @groups = Group.sort_by_keyword(current_user,params[:sort_by])
    @category = Category.find_all_for_user(current_user)
    respond_to do |format|
      format.html
      format.json { render :json => @groups.to_json(:include => { :category => {:methods =>  :name } }) }
    end
  end
  
  def show
    @group = Group.find(params[:id])
    @category = Category.find_all_for_user(current_user).reject { |category|  @group.category == category }
    @group_ads = Ad.sort_by_keyword(@group,params[:sort_by])
    respond_to do |format|
      format.html
      format.json { render :json => { :group => @group, :group_ads => @group_ads } }
    end
  end
  
  def create
    @brand = Brand.find(params[:brand][:id])
    @category = Category.create_by_name(params[:tabcategory],current_user)
    @group = Group.new(:brand_id => @brand.id, :category_id => @category.id)
    @ad = Ad.new(params[:ad],:brand_id => @brand.id)
    @group.ads << @ad
    @group.save!
    respond_to do |format|
      format.json { render :json => @ad.to_json }
    end
  end
  
  def update
    @new_group = Group.find_by_user_id_and_category_id(current_user.id, params[:category].to_i)
    @old_group = Group.find(params[:id])
    if @new_group
      if @new_group.category == @old_group.category
        category = @old_group.category.name
        new_group = false
      else
        @new_group.ads << @old_group.ads
        @new_group.save!
        @old_group.reload.destroy
        category = @new_group.category.name
        new_group = true
      end
    else
      @old_group.category_id
      @old_group.category_id = params[:category]
      @old_group.save!
      category = @old_group.category.name
      new_group = false
    end
    respond_to do |format|
      format.json {render :json =>  { :category => category, :new_group => new_group } }
    end
    
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    respond_to do |format|
      format.json { render :json => @group }
    end
  end
  
  def sort_by_parameter
    @sort_by = params[:sort_by]
  end
  
end
