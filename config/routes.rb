Rails.application.routes.draw do
  resources :moons
  resources :favorites
  resources :users
  resources :planets

  delete '/users/:id/planets/:planet_id', to: 'users#destroyFav'
  get '/planets/:id/moons' , to: 'planets#moons'
  get '/constellations' , to: 'planets#constellations'
  post '/users/:id/favorites' , to: 'users#favorites'

  post '/login', to: 'sessions#login'

  get '/autologin', to: 'sessions#autologin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
