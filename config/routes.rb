Refinery::Application.routes.draw do
  resource :newsletter, :only => [:show, :create] do
    match 'approve/:id' => :approve, :as => :approve
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :mailings, :except => :show
    
    scope(:path => 'mailing', :as => 'mailing') do
      root :to => 'mailings#index'
    end
    
    scope(:path => 'mailing', :as => 'mailing', :module => 'mailing') do
      resources :templates, :except => :show
      
      resources :subscribers, :except => [:new, :show, :edit]
      
      resources :newsletters, :except => :show do
        collection do
          post :update_positions
        end
      end
      
    end
  end
  
end
