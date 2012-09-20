SampleApp2::Application.routes.draw do
  resources :users
                          # no need to show or edit
  resources :sessions,  only: [:new, :create, :destroy]
  resources :microposts,only: [:create, :destroy]
  # /signin        signin_path    GET     new
  # /sessions      sessions_path  POST    create
  # /signout       signout_path   DELETE  destroy

  #get "users/new"
  # Fully RESTful resource:
  # /users        index     GET       users_path
  # /users/1      show      GET       user_path(user)
  # /users/new    new       GET       new_user_path
  # /users        create    POST      users_path
  # /users/1/edit edit      GET       edit_user_path(user)
  # /users/1      update    PUT       user_path(user)
  # /users/1      destroy   DELETE    user_path(user)

  root              to: 'static_pages#home'
  #match '/',        to: 'static_page#home'


  #get "static_pages/home"   #get is the GET request to the static_pages/home action
  #get "static_pages/help"
  #get "static_pages/about"
  #get "static_pages/contact"

                        #controller   action
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
                                            #via HTTP DELETE Request
  match '/signout', to: 'sessions#destroy', via: :delete



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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
