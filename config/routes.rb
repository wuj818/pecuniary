Pecuniary::Application.routes.draw do
  resources :asset_snapshots, path: 'asset-snapshots', only: [:show, :edit, :update, :destroy]

  resources :financial_assets, path: 'financial-assets' do
    resources :asset_snapshots, path: 'snapshots', as: 'snapshots', only: [:new, :create]
  end

  root to: 'financial_assets#index'
end
