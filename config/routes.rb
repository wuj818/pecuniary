Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :snapshots, only: %i[show edit destroy]

  resources :contributions, only: %i[index show edit destroy]

  resources :financial_assets, path: 'financial-assets' do
    resources :snapshots, only: %i[new create update]

    resources :contributions, only: %i[new create update]
  end

  resources :milestones

  get '/investments', to: 'investments#history'

  resources :sessions, only: %i[new create destroy]
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'

  root to: 'pages#main'
end
