Rails.application.routes.draw do
  get 'gameweeks/index'
  resources :gameweeks, only: :index do
    resources :players, only: :index
  end
end
