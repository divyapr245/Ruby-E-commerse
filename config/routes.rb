Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount ActionCable.server => '/cable'


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :categories do 
    get '/products', to: 'categories#products'
  end
  resources :products 
  resources :orders, only: [:create, :index]
  resources :reviews, only: [:create]
  resources :chat_rooms, only: [:create, :index] do 
    get :presence, on: :collection
    member do 
      put :accept_request
    end
  end
  resources :chat_request_notifications, only: [:index]
  get '/recommended_products', to: 'products#show_recommended_products'
  get 'cart', to: 'cart#index'
  post 'cart/sync', to: 'cart#sync' 
  delete 'cart/clear_all', to: 'cart#clear_all_cart'
  delete 'cart/:product_id', to: 'cart#destroy'
  post 'user/sign_up', to: 'accounts#create'
  get 'countries', to: 'accounts#get_countries'
  get 'states', to: 'accounts#get_state'
  get 'cities', to: 'accounts#get_cities'
  post '/auth/login', to: 'authentication#login'
  post '/auth/google_login', to: 'authentication#google_login'
  get '/scrape', to: 'scrape#get_data'
  get "live_logins", to: "live_counts#live_logins"
  post "/create_payment_intent", to: "payments#create_payment_intent"
  get "/reviews/:product_id", to: "reviews#get_product_reviews"
  get "/current_user_details", to: "accounts#show_current_user_details"

  #_________________________________________Notifications_______________________

  get '/get_unread_notifications', to: "notifications#get_unread_notifications"
  put '/update_notification', to: "notifications#update_notification"

  #------------------------------------------------Chat-------------------------------------
  post '/create_message', to: "messages#create_message"
  get '/chat_room/:id', to: "messages#show"
  put '/update_message/:id', to: "messages#update"
  patch '/update_all_messages/:chat_room_id', to: "messages#update_all_messages"
end
