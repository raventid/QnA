Rails.application.routes.draw do

  use_doorkeeper
  root to: "questions#index"

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  resources :questions, concerns: :votable do
    resources :subscriptions, only: [:create]
    resources :comments, only: [:create]
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: [:create]
    end
  end

  resources :subscriptions, only: [:destroy]

  resources :verifications, only: [:new, :create, :show] do
    get 'confirm/:token', on: :member, action: :confirm, as: :confirm
  end

  post 'answers/:id/best' => 'answers#best', as: :best

  resources :attachments, only: [:destroy]


  # API routing
  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  # Background jobs monitoring for administration
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'search', to: 'search#index'

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
end
