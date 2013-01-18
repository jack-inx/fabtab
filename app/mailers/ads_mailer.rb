class AdsMailer < ActionMailer::Base
  default from:"FabTab<mail@myfabtab.com>"

def refer(details,content)
    @referred_name = details[:name]
    content = content.gsub("{{user_name}}",details[:name])
    mail(:to => details[:email] , :subject => 'This is a test email' ) do |format|
      format.html { render :text => content.html_safe }
    end
  end  
end
