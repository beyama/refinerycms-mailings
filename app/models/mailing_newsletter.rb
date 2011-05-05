class MailingNewsletter < ActiveRecord::Base

  acts_as_indexed :fields => [:name, :description]

  validates :name, :presence => true, :uniqueness => true
  
  has_and_belongs_to_many :mailings
  
  has_many :newsletter_subscriber, :class_name => 'MailingNewsletterSubscriber', :foreign_key => :newsletter_id, :dependent => :delete_all
  has_many :subscribers, :through => :newsletter_subscriber, :class_name => 'MailingSubscriber'
  
  scope :frontend, where(:public => true)
end
