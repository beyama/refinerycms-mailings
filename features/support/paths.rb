module NavigationHelpers
  module Refinery
    module Mailings
      def path_to(page_name)
        case page_name
        when /the list of mailings/
          admin_mailings_path
        when /the new mailing form/
          new_admin_mailing_path
        when /the list of newsletters/
          admin_mailing_newsletters_path
        when /the new newsletter form/
          new_admin_mailing_newsletter_path
        when /the frontend list of newsletter/
          newsletter_path
        when /the list of mailing_templates/
          admin_mailing_templates_path
        when /the new mailing_template form/
          new_admin_mailing_template_path
        when /the list of subscribers/
          admin_mailing_subscribers_path
        when /the new subscriber form/
          new_admin_mailing_subscriber_path
        else
          nil
        end
      end
    end
  end
end
