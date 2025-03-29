Rails.application.routes.draw do
  resources :app_users
  
  # Login/logout routes
  post '/login', to: 'app_users#login'
  delete '/logout', to: 'app_users#logout'
  
  # Profile routes
  get '/profile', to: 'profiles#show', as: 'profile'
  patch '/profile', to: 'profiles#update'
  
  root "profiles#show"
end
