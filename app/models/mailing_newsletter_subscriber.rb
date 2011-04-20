class MailingNewsletterSubscriber < ActiveRecord::Base
  belongs_to :newsletter, :class_name => 'MailingNewsletter'
  belongs_to :subscriber, :class_name => 'MailingSubscriber'
  
  scope :unsended, where(:invite_sended_at => nil)
  
  def approved?
    !!verified_at
  end
  
end
