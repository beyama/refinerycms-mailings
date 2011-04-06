module Admin::MailingsHelper
  
  def mailing_templates
    MailingTemplate.order('slug ASC').all(:select => :slug).map {|t| t.slug.gsub(/\.\w+$/, '') }.uniq
  end
  
end