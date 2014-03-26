Sembl::Application.routes.draw do
  namespace :api, module: :api do
    resources :games, only: [:show, :create, :update] do 
      member do 
        post 'join'
        post 'end_turn'
        post 'end_rating'
      end
      # Need a show route for the create route _url method to work when calling respond_with. 
      resources :ratings, only: [:create, :index, :show] 
      resources :results, only: [:create, :index, :show] 

      get 'moves/round', to: 'moves#round'
    end

    # TODO: this probably should be scoped under a game resource
    resources :moves, only: [:create, :index]

    resources :things, only: [:index, :show] do 
      collection do 
        get 'random'
      end
    end

    get 'search', to: 'search#index' 
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
  end

  get  'transloadit_signatures/:template_id' => 'transloadit_signatures#template'
  post 'transloadit_signatures/:template_id' => 'transloadit_signatures#template'

  root to: "games#index"

  resources :contributions
end
