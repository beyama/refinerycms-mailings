class Admin::MailingsController < Admin::BaseController

  crudify :mailing,
          :title_attribute => 'subject', 
          :sortable => false,
          :order => 'created_at DESC'
          
  before_filter :find_all_newsletters, :only => [:new, :edit, :create, :update]
  before_filter :change_only_unsent_mailings, :only => :update
  
  def create
    save ? continue_or_redirect : render(:action => 'new')
  end

  def update
    save ? continue_or_redirect : render(:action => 'edit')
  end

  protected
  def save
    @mailing ||= Mailing.new
    @mailing.attributes = params[:mailing]
    
    new_record = @mailing.new_record?
    
    @mailing.created_by = current_user if new_record
    @mailing.updated_by = current_user
    
    if @mailing.save
      if params[:test]
        MailingsMailer.send_mail(@mailing, :to => params[:test_email]).deliver
        flash.notice = t('mailings.mailing.test_mail_sended', :what => "'#{@mailing.subject}'")
      elsif params[:send]
        job = Delayed::Job.enqueue Refinery::Mailings::NewsletterJob.new(@mailing.id)
        @mailing.update_attributes :job_id => job.id, :sent_at => Time.now
      else
        msg = new_record ? 'refinery.crudify.created' : 'refinery.crudify.updated'
        flash.notice = t(msg, :what => "'#{@mailing.subject}'")
      end
      return true
    end
    
    false
  end
  
  def continue_or_redirect
    params[:continue] || params[:test] ? render(:action => 'edit') : redirect_to(admin_mailings_url)
  end
  
  def find_all_newsletters
    @newsletters = MailingNewsletter.all
  end
  
  def change_only_unsent_mailings
    if @mailing.sent?
      redirect_to admin_mailings_url
    end
  end

end
