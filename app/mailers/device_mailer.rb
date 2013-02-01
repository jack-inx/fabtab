class DeviceMailer < Devise::Mailer
  helper :application
  default from:"FabTab<mail@myfabtab.com>"

  def confirmation_instructions(record, opts={})
    #headers["Custom-header"] = "Bar"
    #super
    purpose = Purpose.arel_table
    purpose_id = Purpose.where(purpose[:name].matches("%confirmation instruction%")).first.id
    template = Template.find_by_purpose_id(purpose_id)

    @token = SecureRandom.urlsafe_base64
    unsubscribe_link = unsubscribe_me_url(:token => @token,:id=>record.id)
    ##http://u140350.sendgrid.org/wf/click?upn=Z4wbwmvAOhlsfGjZq4Wqo9RFFZ2KxjDiFZtDNYfrZlz-2BKt-2BA0vTSYYsYSYts4XSt8uq9x3uaMveabSTzyHPs96NEln-2B2LdUjPpQAWUBqzQT8hHdrRUZ0u8vBu1yxuxf1nI9K4LGtUzsFGRqq9AIhrknprmEaiVjyppITxVjenjI-3D_DbMNUV5uty2vNl3tqFeGZEyri9FWqX7EhKSk-2FLgtNCuZ6wI-2BMYwtBa8jeBYwbH9jTw6zXUX8USIOK7EkKGqbe-2FnelPUxi4Nm6ZfXx276qTbPieJcbZh8RB3-2F66QlfzZyjZ2m-2F3eABJIdIaTdnWRB2A78GLVG-2BNIpc9QHXgAMIls-3D
    confirmation_link = "#{users_confirmation_url(record, :confirmation_token => record.confirmation_token)}"
    if template
      @var = template.content
      @var = @var.gsub("{{user_name}}",record.username)
      @var = @var.gsub("{{user_email}}",record.email)
      @var = @var.gsub('{{user_ema<font size="2">il}}',record.email)
      @var = @var.gsub("{{confirm_my_account}}",confirmation_link)
      mail(:to => record.email, :subject => "Confirmation instructions") do |format|
        format.html { render :text => @var.html_safe}
      end
    else
      mail(:to => record.email, :subject => "Confirmation instructions")
    end
  end

  def reset_password_instructions(record, opts={})
    purpose = Purpose.arel_table
    purpose_id = Purpose.where(purpose[:name].matches("%password%")).first.id
    template = Template.find_by_purpose_id(purpose_id)

    @token = SecureRandom.urlsafe_base64
    unsubscribe_link = unsubscribe_me_url(:token => @token,:id=>record.id)
    edit_password = edit_user_password_url(record, :reset_password_token => record.reset_password_token)
    if template
      @var = template.content
      @var = @var.gsub("{{user_name}}",record.username)
      @var = @var.gsub("{{user_email}}",record.email)
      @var = @var.gsub('{{user_ema<font size="2">il}}',record.email)
      @var = @var.gsub("{{unsubscribe}}",unsubscribe_link)
      @var = @var.gsub("{{lost_password}}",edit_password)
      mail(:to=>record.email, :subject=>"Reset password instructions") do |format|
        format.html { render :text => @var.html_safe }
      end
    else
      mail(:to=>record.email, :subject=>"Reset password instructions")
    end
  end


end
