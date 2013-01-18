class DemosController < ApplicationController
  before_filter :authenticate_user!, :only => [:new,:edit,:create,:update,:demo,:index]
  before_filter :authenticate_admin, :only => [:new,:edit,:create,:update,:demo,:index]
  
  def demo
    view_name = params[:id]
    render "demos/#{params[:id]}"
  end  
  
  def index
    @demos = Demo.all
  end
  
  def new
    @demo = Demo.new
  end
  
  def edit
    @demo = Demo.find(params[:id])
    @ad_position = JSON.parse(@demo.info) unless @demo.info.nil?
    render 'edit', :layout => 'application'
  end
  
  def create
    @demo = Demo.create(params[:demo])
    redirect_to edit_demo_path(@demo.id)
  end
  
  def update
    @demo = Demo.find(params[:id])
    ad_position = {}
    ad_position[:left], ad_position[:top] = params[:demo][:position].split(',')
    @demo.info = ad_position.to_json
    if @demo.save
      flash[:notice] = "Ad saved at the position"
    end
    redirect_to demo_path(@demo.id)
  end
  
  def show
    @demo = Demo.find(params[:id])
    @ad_position = JSON.parse(@demo.info) unless @demo.info.nil?
    render 'demos/show', :layout=> false
  end
  
  def destroy
    @demo = Demo.find(params[:id])
    @demo.destroy
    render :text => "Successfully deleted the demo"
  end
  
  
end
