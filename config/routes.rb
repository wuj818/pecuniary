Pecuniary::Application.routes.draw do
  resources :asset_snapshots, path: 'asset-snapshots', only: [:show, :edit, :update, :destroy]

  resources :contributions, only: [:index, :show, :edit, :update, :destroy]

  resources :financial_assets, path: 'financial-assets' do
    resources :asset_snapshots, path: 'snapshots', as: 'snapshots', only: [:new, :create]

    resources :contributions, only: [:new, :create]
  end

  resources :milestones

  resources :sessions, only: [:new, :create, :destroy]
  get '/login' => 'sessions#new'
  delete '/logout' => 'sessions#destroy'

  root to: 'pages#main'
end
