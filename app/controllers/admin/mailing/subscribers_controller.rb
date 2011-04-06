class Admin::Mailing::SubscribersController < Admin::BaseController

  crudify :mailing_subscriber,
          :title_attribute => 'email', :xhr_paging => true

end
