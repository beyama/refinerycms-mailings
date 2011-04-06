class Admin::MailingsController < Admin::BaseController

  crudify :mailing,
          :title_attribute => 'subject', 
          :sortable => false,
          :order => 'created_at DESC'

end
