class Admin::Mailing::MailingTemplatesController < Admin::BaseController

  crudify :mailing_template,
          :title_attribute => 'slug', :xhr_paging => true
            
end
