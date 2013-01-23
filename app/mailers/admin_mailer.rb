class AdminMailer < ActionMailer::Base
  default from:"FabTab<mail@myfabtab.com>"

  def follow_request(admin,ad,user,content)
    @admin = admin
    @ad = ad
    @user = user
    mail(:to => @admin.email , :subject => 'This is a follow request email') do |format|
      format.html { render :text => content.html_safe }
    end
  end  
end
