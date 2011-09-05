class Refinery::Mailings::NewsletterJob < Struct.new :mailing_id, :host, :options
  
  def mailing
    @mailing ||= Mailing.find(self.mailing_id)
  end
  
  def perform
    mailing.subscribers.readonly(false).find_each do |subscriber|
      # TODO: Use query to exclude already sended mails
      next if subscriber.mailings.include?(mailing)
      
      opts = self.options || {}
      opts[:to] = subscriber.email
      
      MailingsMailer.send_mail(@mailing, opts, host).deliver
      
      subscriber.mailings << mailing
      subscriber.save
    end
  end
  
  def after
    mailing.update_attribute :finished_at, Time.now
  end
  
end
