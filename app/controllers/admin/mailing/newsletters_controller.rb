class Admin::Mailing::NewslettersController < Admin::BaseController

  crudify :mailing_newsletter,
          :title_attribute => 'name', :xhr_paging => true

end
