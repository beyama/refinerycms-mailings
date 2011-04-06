class NewsletterMailing < ActiveRecord::Base
  belongs_to :newsletter, :class_name => 'MailingNewsletter'
  belongs_to :mailing
end