require 'aws/s3'

class TemplatesController < ApplicationController
  before_filter :check_admin
  layout 'admin'
  
  def index
    @templates = Template.all
  end

  def new
    @template = Template.new
    @templates = Template.all
  end

  def create
    @template = Template.new(params[:template])
    if @template.save
      redirect_to @template
      flash[:notice] = "One template create successfully."
    else
      render :action => "new", :message => @template
    end
  end

  def show
    @template = Template.find(params[:id])
    @var = @template.content
    @user = User.first
  end

  def edit
    @template = Template.find(params[:id])
    @templates = Template.all
  end

  def update
    @template = Template.find(params[:id])
    if @template.update_attributes(params[:template])
      flash[:notice] = "Updated successfully"
      redirect_to templates_path
    else
      render "edit"
    end
  end


  def delete_at_index
    if !params[:delete].nil?
      params[:delete][:selected].collect!{ |i|
        if(i!='all')
          @template = Template.find(i.to_i)
          @template.delete
        end
      }
    end
    redirect_to templates_path
  end

  def destroy
    @template = Template.find(params[:id])
    @template.delete
    flash[:notice]= "One template deleted successfully."
    redirect_to templates_path
  end
	
  def before_db
    @s3=AWS::S3.new(
      :access_key_id     => 'AKIAJ5EANDODFQNLOVRA',
      :secret_access_key => '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'
    )
  end

  def download_db
    before_db
    @bucket = @s3.buckets['dbdumpfiles']
  end

  def delete_file
    before_db
    key = params[:obj]
    @file = @s3.buckets['dbdumpfiles'].objects[key]
    @file.delete
    flash[:notice] = "Dump file successfully deleted."
    redirect_to admin_edit_path
  end

def upload(options = {})
    p options[:key]
    o = $bucket.objects[options[:key]]
    o.write(:file => options[:path], :acl => :public_read)
  end

  def run
    before_db
      config = YAML.load(File.read("#{Rails.root}/config/database.yml"))
    environment = config[Rails.env]
    
    filename ="Download_"+ Time.now.strftime('dump_%Y-%m-%d_%H:%M:%S') + '.sql'
    path = File.join(Rails.root, filename)

    command = ["mysqldump -u #{environment['username']}"]
    command << "--password=#{environment['password']}" unless environment['password'].nil?
    command << "#{environment['database']} > " + path

    $bucket =  @s3.buckets['dbdumpfiles']#.objects
    system command.join(' ')

    key = "admin/#{current_user.id}/"
    upload({:key => key + filename, :path => path})
    system 'rm ' + filename
    flash[:notice]="Database dump file have been taken successfully ."

    redirect_to admin_edit_path

  end

  private

  def check_admin
    if current_user.admin == false
      render 'public/401.html', :layout => false, :status => 401
    end
  end
end 
