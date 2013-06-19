Pecuniary::Application.routes.draw do
  resources :financial_assets, path: 'financial-assets'

  root to: 'financial_assets#index'
end
