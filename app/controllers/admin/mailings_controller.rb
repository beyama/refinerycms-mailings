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
  
  def preview
    @mailing = params[:id] ? find_mailing : Mailing.new
    
    html = params[:format] == 'html'
    
    @mailing.attributes = params[:mailing]
    @mailing.make_urls_absoulute if html
    
    host = MailingsMailer.host_from_request(request)
    mail = MailingsMailer.send_mail(@mailing, { :to => 'preview@example.org' }, host)
    
    content = if html
      if mail.multipart?
        part = mail.parts.find{|part| part.content_type =~ /^text\/html/ }
        part ? part.body : nil
      elsif mail.content_type =~ /^text\/html/
        mail.body.decoded
      end
    else
      body = if mail.multipart?
        part = mail.parts.find{|part| part.content_type =~ /^text\/plain/ }
        part ? part.body : nil
      elsif mail.content_type =~ /^text\/plain/
        mail.body.decoded
      end
      !body.blank? ? "<html><body><pre>#{body}</pre></body></html>" : nil
    end
    content = content.blank? ? "<html><body><h1>#{t('admin.mailing.preview.no_text')}</h1></body></html>" : content
    render :text => content, :layout => false
  end

  protected
  def save
    @mailing ||= Mailing.new
    @mailing.attributes = params[:mailing]
    
    new_record = @mailing.new_record?
    
    @mailing.created_by = current_user if new_record
    @mailing.updated_by = current_user
    
    host = MailingsMailer.host_from_request(request)
    
    if @mailing.save
      if params[:test]
        MailingsMailer.send_mail(@mailing, {:to => params[:test_email]}, host).deliver
        flash.notice = t('admin.mailings.mailing.test_mail_sent', :what => "'#{@mailing.subject}'")
      elsif params[:send]
        job = Delayed::Job.enqueue Refinery::Mailings::NewsletterJob.new(@mailing.id, host)
        @mailing.update_attributes :job_id => job.id, :sent_at => Time.now
        flash.notice = t('admin.mailings.mailing.mail_sent', :what => "'#{@mailing.subject}'")
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
