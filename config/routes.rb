Gs3::Application.routes.draw do |map|
  resources :menu

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
#  root :to => 'user_sessions#new' unless current_user
	#root :to => 'user_sessions#new' 
  
	map.home '', :controller => "user_sessions", :action => 'new'
 # map 'login', :controller => "user_sessions", :action => 'create'
  map.logout 'logout', :controller => "user_sessions", :action => 'destroy' 
  # See how all your routes lay out with "rake routes"

  #REDMINE
  resources :segnalazioni do
      collection do
        post :index
      end
  end
#  scope '/signup' do
#    match '/signup' => "users#landing", :as => :signup
#    get '/:level' => 'users#new', :as => :signup_new
#    post '/:level' => 'users#create', :as => :signup_create
#end
#    map.with_options :controller => 'issues' do |issues_routes|
#    issues_routes.with_options :conditions => {:method => :get} do |issues_views|
#      issues_views.connect 'issues', :action => 'index'
#      issues_views.connect 'issues.:format', :action => 'index'
#      issues_views.connect 'projects/:project_id/issues', :action => 'index'
#      issues_views.connect 'projects/:project_id/issues.:format', :action => 'index'
#      issues_views.connect 'projects/:project_id/issues/new', :action => 'new'
#      issues_views.connect 'projects/:project_id/issues/gantt', :controller => 'gantts', :action => 'show'
#      issues_views.connect 'projects/:project_id/issues/calendar', :controller => 'calendars', :action => 'show'
#      issues_views.connect 'projects/:project_id/issues/:copy_from/copy', :action => 'new'
#      issues_views.connect 'issues/:id', :action => 'show', :id => /\d+/
#      issues_views.connect 'issues/:id.:format', :action => 'show', :id => /\d+/
#      issues_views.connect 'issues/:id/edit', :action => 'edit', :id => /\d+/
#    end
#    issues_routes.with_options :conditions => {:method => :post} do |issues_actions|
#      issues_actions.connect 'issues', :action => 'index'
#      issues_actions.connect 'projects/:project_id/issues', :action => 'create'
#      issues_actions.connect 'projects/:project_id/issues/gantt', :controller => 'gantts', :action => 'show'
#      issues_actions.connect 'projects/:project_id/issues/calendar', :controller => 'calendars', :action => 'show'
#      issues_actions.connect 'issues/:id/quoted', :controller => 'journals', :action => 'new', :id => /\d+/
#      issues_actions.connect 'issues/:id/:action', :action => /edit|destroy/, :id => /\d+/
#      issues_actions.connect 'issues.:format', :action => 'create', :format => /xml/
#      issues_actions.connect 'issues/bulk_edit', :action => 'bulk_update'
#    end
#    issues_routes.with_options :conditions => {:method => :put} do |issues_actions|
#      issues_actions.connect 'issues/:id/edit', :action => 'update', :id => /\d+/
#      issues_actions.connect 'issues/:id.:format', :action => 'update', :id => /\d+/, :format => /xml/
#    end
#    issues_routes.with_options :conditions => {:method => :delete} do |issues_actions|
#      issues_actions.connect 'issues/:id.:format', :action => 'destroy', :id => /\d+/, :format => /xml/
#    end
#    issues_routes.connect 'issues/gantt', :controller => 'gantts', :action => 'show'
#    issues_routes.connect 'issues/calendar', :controller => 'calendars', :action => 'show'
#    issues_routes.connect 'issues/:action'
#  end
  ## REDMINE ##

  match 'prodotti/data' => 'prodotti#data'
  match 'prodotti/dbaction' => 'prodotti#dbaction'
  match 'recapiti/data' => 'recapiti#data'
  match 'recapiti/dbaction' => 'recapiti#dbaction'
  match 'statistiche' => 'statistiche#index'
  match 'todo' => 'todo#index'
  match 'gsprg' => 'segnalazioni#gsprg'

  resource :account, :controller => "utenti"
  resources :funzioni
  resources :gruppi
  resources :prodotti
  resources :recapiti
  resources :segnalazioni
  resource :user_session
  resources :utenti
  resources :versioni
 
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'

end
