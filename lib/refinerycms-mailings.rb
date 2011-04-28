require 'refinerycms-base'
require 'liquid'

module Refinery
  module Mailings
    
    autoload :LiquidFileSystem, 'refinery/mailings/liquid_file_system'
    
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
