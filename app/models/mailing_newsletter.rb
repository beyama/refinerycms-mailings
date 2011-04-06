class MailingNewsletter < ActiveRecord::Base

  acts_as_indexed :fields => [:name, :description]

  validates :name, :presence => true, :uniqueness => true
  
  has_many :newsletter_subscriber, :class_name => 'MailingNewsletterSubscriber', :foreign_key => :newsletter_id, :dependent => :delete_all
  has_many :subscriber, :through => :newsletter_subscriber, :class_name => 'MailingSubscriber'
  
  has_many :newsletter_mailings, :foreign_key => :newsletter_id, :dependent => :delete_all
  has_many :mailings, :through => :newsletter_mailings
  
  scope :frontend, where(:public => true)
end
