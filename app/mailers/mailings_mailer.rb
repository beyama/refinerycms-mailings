require 'liquid'

class MailingsMailer < ActionMailer::Base
  
  HTML_DEFAULT_TEMPLATE = <<-END
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <body bgcolor="#ffffff" link="#00A1E4" vlink="#00A1E4">
    <font face="Helvetica Neue, Arial, Helvetica, sans-serif">%s</font>
  </body>
</html>
END

  class << self
    def host_from_request(request)
      subdomain = request.subdomain + '.' if request.subdomain.present? && request.subdomain != "www"
      [(subdomain || ''), request.domain, request.port_string].join
    end
  end

  def confirm(subscriber, token, host)
    @subscriber = subscriber
    @token = token
    @subscriptions = @subscriber.subscriptions.unsended.where(:token => @token).all
    @host = host
    
    form_address = Refinery::Mailings.confirm_from
    
    mail(:from => form_address, :to => @subscriber.email)
  end

  def send_mail(mailing, options, host)
    options.symbolize_keys!
    
    options = options.merge(:subject => mailing.subject, :from => mailing.from, :data => {})
    
    data = options.delete(:data)
    
    unsubscribe_url =  url_for(:controller => :pages, :action => :show, :path => "newsletter", :host => host)
    
    templates = mailing.template.blank? ? nil : MailingTemplate.basename(mailing.template)
    
    if templates.blank?
      mail(options) do |format|
        if mailing.body.present?
          format.text { render :text => mailing.body }
        end
        if mailing.html_body.present?
          format.html { render :text => (HTML_DEFAULT_TEMPLATE % mailing.html_body) }
        end
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
