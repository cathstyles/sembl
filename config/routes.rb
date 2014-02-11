Sembl::Application.routes.draw do
  namespace :admin, module: :admin, constraints: AdminConstraint do
    resources :things, except: [:show]
    resources :boards, except: [:show]
    resources :users, except: [:show]

    root to: "home#show"
  end

  devise_for :users

  resources :games do
    resources :things, only: [:index]
    resources :players, only: [:index, :create]
    member do 
      # post 'join'
      get 'summary'
    end
  end

  resources :things, only: [:index]
  get 'things/random', to: 'things#random' 

  get 'search', to: 'search#index' 

  root to: "games#index"

  resources :contributions
end
