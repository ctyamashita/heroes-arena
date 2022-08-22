Rails.application.routes.draw do
  root to: 'creatures#index'
  resources :creatures, only: %i[index show new create destroy] do
    # resources :equipments, only: %i[new create]
    resources :battles, only: :create
  end
  resources :battles, only: %i[show update]
  # resources :equipments, only: [:destroy]

  # get '/guild', to: 'creatures#index', as: :guild
  # get '/hero/:id', to: 'creatures#show', as: :hero
  # get '/summon', to: 'creatures#new', as: :summon
  # post '/hero', to: 'creatures#create'
  # delete '/hero', to: 'creatures#destroy'
  # post '/battle/:id', to: 'battles#create'
  # get '/battle/:battle_id/:hero_id/:enemy_id/fight', to: 'creatures#edit', as: :fight
  # patch '/battle/:battle_id/:hero_id/:enemy_id', to: 'creatures#update'
end
