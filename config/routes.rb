Dashboard::Application.routes.draw do

  get "enterprises/index"

  get "enterprises/show"

  get "pages/index"
  get "pages/new"
  get "pages/show"
  get "pages/users_quick_stats"
  get "pages/storage_quick_stats"

  resources :corps, :only=>[:index, :show] do
    member do
        get 'daily'
        get 'weekly'
        get 'monthly'
    end
  end
  resource :enterprises, :only=>[:index, :show] do
    member do 
      match ':id/daily' => 'enterprises#daily',:as => 'daily'
      match ':id/weekly' => 'enterprises#weekly',:as => 'weekly'
      match ':id/monthly' => 'enterprises#monthly',:as => 'monthly'
    end
  end
  match 'pages/change' => 'pages#change', :via=>'POST'

  match 'users/:id' => 'pages#users',:as => 'users'
  
  match 'storage/:id' => 'pages#storage', :as => 'storage'

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
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
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
  #       get 'recent', :on => :collection
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
  root :to => 'pages#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
