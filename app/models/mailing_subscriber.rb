class MailingSubscriber < ActiveRecord::Base
  acts_as_indexed :fields => [:email]

  has_many :subscriptions, :class_name => 'MailingNewsletterSubscriber', :foreign_key => :subscriber_id, :dependent => :delete_all
  has_many :newsletters, :through => :subscriptions, :class_name => 'MailingNewsletter'

  # Regexp stolen from https://github.com/radiant/radiant/blob/master/app/models/user.rb
  validates :email, :presence => true, :uniqueness => true, :format => { :with => /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
end
