Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures, only: %i[index show new create destroy] do
    resources :equipments, only: %i[new create]
  end
  resources :equipments, only: [:destroy]
end
