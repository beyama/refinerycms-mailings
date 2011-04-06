class Mailing < ActiveRecord::Base

  acts_as_indexed :fields => [:subject, :body, :html_body]

  validates :subject, :presence => true
  
  has_many :recipients, :class_name => 'MailingRecipient'
  
  has_many :mailing_newsletters
  has_many :newsletter, :through => :mailing_newsletters, :class_name => 'MailingNewsletter'
  
  def to_liquid
    { 
      'subject'    => self.subject,
      'body'       => self.body,
      'html_body'  => self.html_body,
      'created_at' => self.created_at,
      'updated_at' => self.updated_at
    }
  end
  
end
