class Mailing < ActiveRecord::Base  
  acts_as_indexed :fields => [:subject, :body, :html_body]

  validates :from, :subject, :presence => true
  
  has_and_belongs_to_many :newsletters, :class_name => 'MailingNewsletter', :uniq => true
  has_and_belongs_to_many :newsletter_recipients, :class_name => 'MailingSubscriber',:join_table => :mailing_subscribers_mailings, :uniq => true
  
  belongs_to :job, :class_name => 'Delayed::Backend::ActiveRecord::Job'
  
  def subscribers
    MailingSubscriber.
      joins(:subscriptions => {:newsletter => :mailings}).
      where('mailing_newsletter_subscribers.verified_at is not null').
      where(:mailings => {:id => self.id})
  end
  
  def newsletters_attributes=(attrs)
    ids = Hash[ attrs.select {|k,v| v[:checked] != '0' } ].keys.map(&:to_i) # ruby 1.8 Hash#select returns Array instead of Hash
    selected = ids.empty? ? ids : MailingNewsletter.find(ids)
    
    self.newsletters -= self.newsletters.reject {|n| selected.include?(n) }
    
    (selected - self.newsletters).each {|letter| self.newsletters << letter }
  end
  
  def sended?
    # delayed_job defined Object#send_at (!)
    !self.read_attribute(:send_at).nil?
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
