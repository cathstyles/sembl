Sembl::Application.routes.draw do
  namespace :admin, module: :admin, constraints: AdminConstraint do
    root to: "home#show"
  end

  devise_for :users

  root to: "home#show"
end
