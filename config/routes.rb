Rails.application.routes.draw do
  resources :questions, only: %i[new create show] do
    resources :answers, only: %i[new create show], shallow: true
  end
end
