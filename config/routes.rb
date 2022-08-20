Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures, only: %i[index show new create destroy] do
    resources :equipments, only: %i[new create]
    resources :battles, only: %i[new create] do
      resources :creatures, only: [:update, :edit]
    end
  end
  resources :equipments, only: [:destroy]
end
