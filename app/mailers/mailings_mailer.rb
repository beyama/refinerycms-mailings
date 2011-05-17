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
    
    templates = mailing.template.blank? ? nil : MailingTemplate.basename(mailing.template)
    
    if templates.blank?
      mail(options) do |format|
        format.text { render :text => mailing.body }
      end
    else
      mail(options)  do |format|
        %w[text html].each do |ext|
          next unless template = templates.find{|t| t.extname == ext }

          content = ext == 'text' ? mailing.body : mailing.html_body
          next if content.blank?
          
          format.send(ext) do
            liquid = Liquid::Template.parse(template.body)
            render :text => liquid.render('mailing' => mailing, 'data' => data, 'content' => content, 'unsubscribe_url' => unsubscribe_url)
          end
          
        end
      end
      
    end
  end
end
