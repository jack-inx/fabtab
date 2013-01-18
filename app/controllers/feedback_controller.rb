class FeedbackController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @feedback = Feedback.new
    @email = current_user.email
    @email_to = 'info@fabtab.com'
    respond_to  do|format|
      format.html {}
    end
  end

  def create

    @feedback = current_user.feedback.new(params[:feedback])
    @email =  @feedback.user.email
    if @feedback.save!
      NotificationsMailer.new_message(@email, @feedback.content).deliver
      redirect_to(about_path)
      flash[:notice] = "Email successfully sent"
    else
      render :new
    end
  end
def promo_create
    @feedback = Feedback.new(params[:feedback])
    @email = params[:email]
    if @feedback.save!
      NotificationsMailer.new_message(@email, @feedback.content).deliver
      redirect_to(about_path)
      flash[:notice] = "Mail was successfully sent."
    end
  end

end
