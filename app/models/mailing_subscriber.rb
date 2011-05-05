class MailingSubscriber < ActiveRecord::Base
  acts_as_indexed :fields => [:email]

  has_many :subscriptions, :class_name => 'MailingNewsletterSubscriber', :foreign_key => :subscriber_id, :dependent => :delete_all
  has_many :newsletters, :through => :subscriptions, :class_name => 'MailingNewsletter', 
    :conditions => 'mailing_newsletter_subscribers.verified_at is not null'
    
  has_and_belongs_to_many :mailings

  # Regexp stolen from https://github.com/radiant/radiant/blob/master/app/models/user.rb
  validates :email, :presence => true, :uniqueness => true, :format => { :with => /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  
  scope :by_mailing, lambda {|id| joins(:subscriptions => {:newsletter => :mailings}).where(:mailings => {:id => id.is_a?(Mailing) ? id.id : id.to_i}) }
end
