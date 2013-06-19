Pecuniary::Application.routes.draw do
  resources :financial_assets

  root to: 'financial_assets#index'
end
