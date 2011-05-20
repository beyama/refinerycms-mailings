require 'nokogiri'

class Mailing < ActiveRecord::Base  
  acts_as_indexed :fields => [:subject, :body, :html_body]

  validates :from, :subject, :presence => true
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  has_and_belongs_to_many :newsletters, :class_name => 'MailingNewsletter', :uniq => true
  has_and_belongs_to_many :newsletter_recipients, :class_name => 'MailingSubscriber',:join_table => :mailing_subscribers_mailings, :uniq => true
  
  belongs_to :job, :class_name => 'Delayed::Backend::ActiveRecord::Job'
  
  before_save :make_urls_absoulute
  
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
  
  def sent?
    !self.sent_at.nil?
  end
  
  def finished?
    !self.finished_at.nil?
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
  
  def make_urls_absoulute
    if !self.html_body.blank? && self.html_body_changed?
      doc = Nokogiri::HTML(self.html_body)
      doc.xpath("//a").each {|n| n['href'] = fix_url(n['href']) }
      doc.xpath("//img").each {|n| n['src'] = fix_url(n['src']) }
      self.html_body = doc.root.children.first.children.to_s # /html/body/...
    end
  end
  
  protected
  def fix_url(url)
    return url if url.blank?
    @asset_url ||= Refinery::Mailings.asset_url
    url !~ /^https?:\/\// ? File.join(@asset_url, url) : url
  end
  
end
