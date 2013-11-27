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
  end

  root to: "games#index"
end
