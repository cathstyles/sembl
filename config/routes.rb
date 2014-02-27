Sembl::Application.routes.draw do
  namespace :api, module: :api do
    resources :games, only: [:show, :create, :update] do 
      member do 
        post 'join'
      end
    end

    resources :moves, only: [:create, :index]
  end

  namespace :admin, module: :admin, constraints: AdminConstraint do
    resources :things, except: [:show]
    resources :boards, except: [:show]
    resources :users, except: [:show]

    root to: "home#show"
  end

  devise_for :users

  resources :games, only: [:index, :show, :new, :edit] do
    resources :things, only: [:index]
    resources :players, only: [:index]
  end

  get 'things/random', to: 'things#random' 
  resources :things, only: [:index, :show]

  get 'search', to: 'search#index' 

  get 'transloadit_signatures/:template_id' => 'transloadit_signatures#template'

  root to: "games#index"

  resources :contributions
end
