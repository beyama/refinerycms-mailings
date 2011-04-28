class Mailing < ActiveRecord::Base  
  acts_as_indexed :fields => [:subject, :body, :html_body]

  validates :subject, :presence => true
  
  has_many :recipients, :class_name => 'MailingRecipient'
  
  has_many :newsletter_mailings
  has_many :newsletters, :through => :newsletter_mailings, :class_name => 'MailingNewsletter'
  
  def newsletter_mailings_attributes=(attrs)
    ids = attrs.values.inject([]) {|a, attr| a << attr[:newsletter_id].to_i}.reject(&:zero?)
    self.newsletter_mailings -= self.newsletter_mailings.reject {|n| ids.include?(n.newsletter_id) }
    associated = self.newsletter_mailings.map(&:newsletter_id)
    
    (ids - associated).each do |id|
      self.newsletter_mailings.build :newsletter_id => id
    end
  end
  
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
