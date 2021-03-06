Rails.application.routes.draw do
  #post "cart_products/update_quantity" => "cart_products#update_quantity"
  resources :products do
    collection do 
      get :choose_new_type
      get :new_books
      get :new_cloth
      get :new_snacks
      get :category_products
      post :create_books
      post :create_snacks
      post :create_cloth
    end

    member do
      get :buy
      get :put_in_cart
    end
  end

  resources :cart_products do
    collection do
      get :show_cart
      get :update_quantity
    end
    member do
      get :destory
    end
  end

  resources :orders do
    collection do
      get :show_order
      post :new_cart_orders
      post :create_cart_orders
      get :pay_for_orders
      get :request_manager
    end

    member do
      get :purchase
      get :check_out
      get :pay
      delete :destroy
      get :approval
      get :update_reject_status
      patch :reject
      get :refund
      get :confirm
      get :ship
    end
  end

  devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root to: 'homepage#home'
  match '/help',    to: 'homepage#help',    via: 'get'
  match '/about',   to: 'homepage#about',   via: 'get'
  match '/contact', to: 'homepage#contact', via: 'get'
end
