Rails.application.routes.draw do
  devise_for :users

  root "pages#home"

  # 案件（Jobs）
  resources :jobs do
    resources :applies, only: [:create]
  end

  # 応募（Applies）
  resources :applies, only: [:index, :show] do
    member do
      patch :accept
      patch :reject
      patch :cancel
    end
  end

  # 決済（Payments）
  resources :payments, only: [:new, :create, :show]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
