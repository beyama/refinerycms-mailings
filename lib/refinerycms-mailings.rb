require 'refinerycms-base'
require 'liquid'

module Refinery
  module Mailings
    
    autoload :LiquidFileSystem, 'refinery/mailings/liquid_file_system'
    autoload :NewsletterJob, 'refinery/mailings/newsletter_job'
    
    class << self
      def confirm_from
        RefinerySetting.find_or_set(:mailings_confirm_from, 'noreply@example.org')
      end
      
      def from_addresses
        RefinerySetting.find_or_set(:mailings_from_addresses, ['noreply@example.org'])
      end
      
      def test_addresses
        RefinerySetting.find_or_set(:mailings_test_addresses, ['test@example.org'])
      end
      
      def asset_url
        RefinerySetting.find_or_set(:mailings_asset_url, 'http://example.org')
      end
      
    end
    
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
        
        
        Liquid::Template.file_system = Refinery::Mailings::LiquidFileSystem.new
        
        Refinery::Plugin.register do |plugin|
          plugin.name = "mailings"
          plugin.url = {:controller => '/admin/mailings', :action => 'index'}
          plugin.menu_match = /^\/?(admin|refinery)\/mailing\/?(mailings|templates|subscribers|newsletters)?/
          plugin.activity = {
            :class => Mailing,
            :title => 'subject'
          }
        end
      end
    end
  end
end
