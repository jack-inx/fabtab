class UserMailer < ActionMailer::Base
  default from:"FabTab<mail@myfabtab.com>"
  
  def invite(user,emails,content)
    @user = user
    contents=content.html_safe
    mail(:bcc => emails , :subject => 'Invitation To Join Myfabtab') do |format|
      format.html { render :text => contents }
    end
  end
 
  def brand_request_confirmation(user,content)
    @user = user
    mail(:to => @user.email, :subject => 'Brand Request Confirmation' ) do |format|
      format.html { render :text => content.html_safe }
    end
  end  

  def brand_folder_set_up(user,ad_url, brand_name, content)
    @user = user

    mail(:to => @user.email, :subject => 'Brand Set up for your request' ) do |format|
      format.html { render :text => content.html_safe }
    end
  end

	def template_mail(email,content)
    @email = email
    @content = content
    mail(:to => @email, :subject => "Testing" ) do |format|
      format.html { render :text => content.html_safe }
    end
  end

  def flag_status(user,ads,currentuser)
    @user = user
    @ads = ads
    @current_user = currentuser
    mail(:to => @user.email, :subject => 'Flag status' )
  end
  
  def ignore_status(ad,currentuser,admin)
    @ad= ad
    @current_user=currentuser
    @admin = admin
    mail(:to => @admin.email, :subject => 'Ignoring Flag request for Adlink' )
  end

  def user_registration(user)
    purpose = Purpose.arel_table
    purpose_id = Purpose.where(purpose[:name].matches("%registration%")).first.id
    template = Template.find_by_purpose_id(purpose_id)
    if template
      @var = template.content
      @var = @var.gsub("{{user_name}}",user.username)
      @var = @var.gsub("{{user_email}}",user.email)
      @var = @var.gsub('{{user_ema<font size="2">il}}',user.email)
      unsubscribe_link = unsubscribe_me_url(:token => @token,:id=>user.id)
      @var = @var.gsub("{{unsubscribe}}", "<a href=#{unsubscribe_link}>Click here</a>")


      registration_link = new_registration_url
      @var = @var.gsub("{{subscribe}}", "<a href=#{registration_link}>Click here</a>")
      mail(:to => user.email, :Subject => "Registration") do |format|
        format.html { render :text => @var.html_safe }
      end
    end
    
  end


end
