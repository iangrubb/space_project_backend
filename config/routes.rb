Rails.application.routes.draw do
  resources :moons
  resources :favorites
  resources :users
  resources :planets

  get '/planets/:id/moons' , to: 'planets#moons'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
