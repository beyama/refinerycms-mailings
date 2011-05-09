require 'liquid'

class MailingsMailer < ActionMailer::Base
  
  def confirm(subscriber, token)
    @subscriber = subscriber
    @token = token
    @subscriptions = @subscriber.subscriptions.unsended.where(:token => @token).all
    
    form_address = Refinery::Mailings.confirm_from
    
    mail(:from => form_address, :to => @subscriber.email)
  end

  def send_mail(mailing, options)
    options.symbolize_keys!
    
    options = options.merge(:subject => mailing.subject, :from => mailing.from, :data => {})
    
    data = options.delete(:data)
    
    unsubscribe_url =  url_for(:controller => :pages, :action => :show, :path => "newsletter")
    
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
            render :text => liquid.render('mailing' => mailing, 'data' => data, 'unsubscribe_url' => unsubscribe_url)
          end
          
        end
      end
      
    end
  end
end
