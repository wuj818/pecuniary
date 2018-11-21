Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :asset_snapshots, path: 'asset-snapshots', only: [:show, :edit, :update, :destroy]

  resources :contributions, only: [:index, :show, :edit, :update, :destroy]

  resources :financial_assets, path: 'financial-assets' do
    resources :asset_snapshots, path: 'snapshots', as: 'snapshots', only: [:new, :create]

    resources :contributions, only: [:new, :create]
  end

  resources :milestones

  get '/investments', to: 'investments#history'

  resources :sessions, only: [:new, :create, :destroy]
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'

  root to: 'pages#main'
end
