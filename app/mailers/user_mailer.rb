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

end
