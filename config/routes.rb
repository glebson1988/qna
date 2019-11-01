Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  concern :commented do
    resources :comments, only: :create, shallow: true
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers, concerns: [:voted, :commented], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
