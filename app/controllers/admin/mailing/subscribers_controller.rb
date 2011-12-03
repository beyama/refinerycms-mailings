class Admin::Mailing::SubscribersController < Admin::BaseController
  before_filter :find_all_newsletters, :only => [:index, :update]
  
  respond_to :js, :only => :update

  CONDITION = "mailing_newsletter_subscribers.verified_at is not null"

  crudify :mailing_subscriber,
          :include => [:newsletters],
          :conditions => CONDITION,
          :search_conditions => CONDITION,
          :title_attribute => 'email', 
          :order => 'email ASC',
          :xhr_paging => true

  def update
    current    = @mailing_subscriber.newsletters
    requested  = MailingNewsletter.find(params[:newsletter])
    to_destroy = current   - requested
    to_create  = requested - current
    verified   = Time.now
    
    to_create.each do |newsletter|
      @mailing_subscriber.subscriptions.build(:newsletter => newsletter, :verified_at => verified)
    end
    
    to_destroy.each do |newsletter|
      sub = @mailing_subscriber.subscriptions.find_by_newsletter_id(newsletter.id)
      sub.destroy if sub
    end
    
    @mailing_subscriber.save!
    @mailing_subscriber.reload
  end

  protected
  
  def find_mailing_subscriber
    @mailing_subscriber = MailingSubscriber.find(params[:id])
  end
  
  def find_all_newsletters
    @newsletters = MailingNewsletter.all
  end

end
