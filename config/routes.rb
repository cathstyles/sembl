Sembl::Application.routes.draw do
  ActiveAdmin.routes(self)
  namespace :api, module: :api do
    resources :games, only: [:show, :create, :update, :destroy] do
      member do
        post 'join'
        post 'end_turn'
        post 'end_rating'
      end
      # Need a show route for the create route _url method to work when calling respond_with.
      resources :ratings, only: [:create, :index, :show]
      resources :moves, only: [:create]
      resources :results, only: [:show] do
        collection { get 'awards' }
      end
      resources :players, only: [:create, :destroy, :index, :show]

      get 'moves/round', to: 'moves#round'

    end

    # TODO: this probably should be scoped under a game resource

    resources :things, only: [:index, :show, :create] do
      collection do
        get 'random'
      end
    end

    get 'search', to: 'search#index'
  end

  devise_for :users, :controllers => { :registrations => "registrations",  :sessions => "sessions"  }

  resources :games, only: [:index, :show, :new, :edit] do
    resources :things, only: [:index]
  end

  resource :profile

  get  'transloadit_signatures/:template_id' => 'transloadit_signatures#template'
  post 'transloadit_signatures/:template_id' => 'transloadit_signatures#template'

  root to: "games#index"

  resources :contributions
end
