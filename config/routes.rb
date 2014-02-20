Sembl::Application.routes.draw do
  namespace :api, module: :api do
    resources :games, only: [:show, :create, :update]
  end

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

  get 'things/random', to: 'things#random' 
  resources :things, only: [:index, :show]

  get 'search', to: 'search#index' 

  get 'transloadit_signatures/:template_id' => 'transloadit_signatures#template'

  root to: "games#index"

  resources :contributions
end
