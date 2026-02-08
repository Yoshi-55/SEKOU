# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'pages#home'

  # プロフィール
  resource :profile, only: %i[show edit update], controller: 'users'

  # グループ（Groups）
  resources :groups do
    member do
      post :add_member
      delete :remove_member
    end
  end

  # 案件（Jobs）
  resources :jobs do
    resources :applies, only: %i[new create]
    collection do
      get :posted
    end
  end

  # 応募（Applies）
  resources :applies, only: %i[index show] do
    member do
      patch :accept
      patch :reject
      patch :cancel
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
