require 'liquid'

class MailingsMailer < ActionMailer::Base
  default :from => RefinerySetting.find_or_set(:mailings_from_email, 'info@example.org')
  
  def confirm(subscriber, token)
    @subscriber = subscriber
    @token = token
    @subscriptions = @subscriber.subscriptions.unsended.where(:token => @token).all
    
    mail :to => @subscriber.email
  end

  def send_mail(mailing, recipient)
    options = { :to => recipient.to, :subject => mailing.subject }
    
    if mailing.template.blank?
      mail(options) do |format|
        format.text { render :text => mailing.body }
      end
    else
      templates = MailingTemplate.basename(mailing.template)

      mail(options)  do |format|
        templates.each do |t|
          
          format.send(t.extname) do
            liquid = Liquid::Template.parse(t.body)
            receivable = recipient.receivable
            receivable = {} if receivable.nil? || !receivable.respond_to?(:to_liquid)
            render :text => liquid.render('mailing' => mailing, 'recipient' => recipient, 'receivable' => receivable)
          end
          
        end
      end
      
    end
  end
end
