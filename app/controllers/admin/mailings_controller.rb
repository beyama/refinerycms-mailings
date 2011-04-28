class Admin::MailingsController < Admin::BaseController

  crudify :mailing,
          :title_attribute => 'subject', 
          :sortable => false,
          :order => 'created_at DESC'
          
  before_filter :find_all_newsletters

  protected
  def find_all_newsletters
    @newsletters = MailingNewsletter.all
  end

end
