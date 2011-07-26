ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.resource :user_session
  map.resources :workflows
  map.connect 'list', :controller => "workflows", :action => "list"
  map.connect 'tree_control', :controller => "workflows", :action => "tree_control"
  map.connect 'search_control', :controller => "workflows", :action => "search_control"

  map.connect 'getSpeciesKML/:id', :controller => "workflows", :action => "getSpeciesKML"
  map.connect 'getKML/:id', :controller => "workflows", :action => "getKML"
  map.connect 'getOrder/:id', :controller => "workflows", :action => "getOrder"
  map.connect 'getFamily/:id', :controller => "workflows", :action => "getFamily"
  map.connect 'getGenus/:id', :controller => "workflows", :action => "getGenus"
  map.connect 'getSpecies/:id', :controller => "workflows", :action => "getSpecies"



  map.resources :workflows, :controller => "workflows"


  map.resources :depthmaps, :controller => "pointmaps"
  map.resource :account, :controller => "users"
  map.resources :pointmaps #This is just in case I forgot to change a route.  Should be taken out later though.
  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "home"
end
