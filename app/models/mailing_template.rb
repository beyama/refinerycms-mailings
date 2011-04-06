class MailingTemplate < ActiveRecord::Base
  attr_accessible :slug, :body
  
  acts_as_indexed :fields => [:slug, :body]

  validates :slug, :presence => true, :format => { :with => /^\w+.(text|html)$/ }

  validates_uniqueness_of :slug
  
  scope :basename, lambda {|name| where("slug like ?", "#{name}.%") }
  
  def extname
    (self.slug || "") =~ /^\w+\.(\w+)$/
    $1
  end
  
end
