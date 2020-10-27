Rails.application.routes.draw do
  resources :gameweeks, only: %w(index) do
    resources :players, only: %w(index)
  end

  resources :player_pool_entries, only: %w(create destroy)
end
