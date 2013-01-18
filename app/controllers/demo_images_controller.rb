class DemoImagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin
  
  def index
    @demo_images = DemoImage.all.reverse
  end
  
  def new
    @demo_image = DemoImage.new
  end
  
  def create
    @demo_image = DemoImage.create(params[:demo_image])
    redirect_to demo_images_path
  end
  
  def destroy
    @demo_image = DemoImage.find(params[:id])
    @demo_image.destroy
    render :text => "Successfully Destroyed the Demo Image."
  end
    
end
