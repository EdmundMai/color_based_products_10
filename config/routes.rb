Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions'}
  
  resource :account, only: [:show] 
  
  resources :orders, only: [:index, :show] do
    resources :returns, only: [:new, :create, :show]
  end
  
  
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  resources :collections, only: [:index, :show]
  
  resources :products, only: [:index, :show]
  
  resources :cart_items, only: [:destroy]
  
  resource :checkout, only: [:show] do
    post 'add_to_cart'
    get 'billing'
    put 'update_billing'
    get 'review'
    post 'submit_order'
    post 'signup_user'
    post 'login_user'
  end
  
  match "/admin" => "admin/site#index", via: [:get], :as => "admin"

  # You can have the root of your site routed with "root"
  root to: "site#index"
  
  namespace :admin do
    
    resources :returns
    
    resources :discounts, only: [:index] do
      collection do
        patch 'apply'
      end
    end
    
    resources :colors do
      member do
        delete 'delete_image'
      end
    end
    resources :vendors
    resources :materials
    resources :shapes
    
    resources :coupons
    
    resources :collections do
      member do
        post 'add_products'
        delete 'remove_products'
        get 'search_products'
        get 'reset_search'
      end
    end
    
    resources :orders, only: [:index, :show, :update] do
      collection do
        get 'export'
      end
    end
    
    resources :file_uploads, only: [:index] do
      collection do
        post 'update_taxes'
      end
    end
    
    resources :variants, only: [] do
      collection do
        delete 'remove'
      end
    end
    
    resources :products do
      collection do
        get 'generate_variants'
        get 'add_color'
        get 'add_size'
        get 'add_image'
        get 'add_variant'
      end
    end
    
    resources :products_colors, only: [] do
      collection do
        put 'update_mens_sort_order'
        put 'update_womens_sort_order'
        delete 'remove'
      end
    end
    
    resources :product_images, only: [:destroy] do
      collection do
        put 'update_sort_order'
      end
    end
    
    resources :categories
  end

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
end
