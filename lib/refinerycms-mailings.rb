require 'refinerycms-base'

module Refinery
  module Mailings
    class Engine < Rails::Engine
      initializer "static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.after_initialize do
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
