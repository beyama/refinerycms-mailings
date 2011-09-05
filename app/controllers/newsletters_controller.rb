require 'guid'

class NewslettersController < ApplicationController

  before_filter :find_all_newsletters, :only => [:show, :create] 
  before_filter :find_page, :only => :show
  before_filter :find_approve_page, :only => :approve

  def show
    @subscriber = MailingSubscriber.new(:email => params[:email])
    present(@page)
  end
  
  def create
    if params[:newsletter].blank?
      flash[:error] = t('newsletters.show.no_selection')
      redirect_to newsletter_url(:email => params[:email])
      return
    end
    
    @subscriber = MailingSubscriber.where(:email => params[:email]).includes(:subscriptions).first || 
                  MailingSubscriber.new(:email => params[:email])

    updated = false
    token   = nil
    public_ids = @newsletters.map(&:id)

    if params[:unsubscribe]
      redirect_to newsletter_url and return if @subscriber.new_record?
      
      params[:newsletter].each do |id|
        id = id.to_i
        if public_ids.include?(id) && (subscription = @subscriber.subscriptions.find_by_newsletter_id(id))
          subscription.destroy
          updated = true
        end
      end
    else      
      token = Guid.new.to_s
      
      params[:newsletter].each do |id|
        id = id.to_i
        if public_ids.include?(id)
          unless @subscriber.subscriptions.find_by_id(id)
            @subscriber.subscriptions.build(:newsletter_id => id, :token => token)
            updated = true
          end
        end
      end
    end
    
    if updated
      if @subscriber.save
        if token
          host = MailingsMailer.host_from_request(request)
          MailingsMailer.confirm(@subscriber, token, host).deliver
          flash[:notice] = t('newsletters.show.confirmation_mail_send', :to => @subscriber.email)
        else
          flash[:notice] = t('newsletters.show.successfully_unsubscribed')
        end
        redirect_to newsletter_url
      else
        present(find_page)
        render :action => :show
      end
    else
      redirect_to newsletter_url(:email => params[:email])
    end
    
  end
  
  def approve
    @subscriptions = MailingNewsletterSubscriber.where(:token => params[:id].strip, :verified_at => nil).all
    
    redirect_to newsletter_url and return if @subscriptions.empty?
    
    if request.post?
      time = Time.now
      @subscriptions.each do |sub|
        sub.verified_at = time
        sub.save!
      end
    end
  end

protected

  def find_all_newsletters
    @newsletters = MailingNewsletter.frontend.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/newsletter").first
  end
  
  def find_approve_page
    @page = Page.where(:link_url => "/newsletter/approve").first
  end

end
