class NotificationsMailer < ActionMailer::Base
  
  default :to => "info@fabtab.com"

  def new_message(email,message)
    @email = email
    @message = message
    mail(:from => @email , :subject => 'Feedback', :body => @message )
  end

end
