Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'

  resources :gameweeks, only: %w(index) do
    resources :players, only: %w(index)
    resources :optimizer_tools, only: %w(index)
  end

  resources :player_pool_entries, only: %w(create update destroy)

  resources :lineup_generations, only: %w(create)
  resources :player_pool_optimizations, only: %w(create)
  resources :gameweek_optimizations, only: %w(create)

  resources :player_pools, only: [] do
    resources :player_pool_entries, only: [] do
      delete :destroy_all, on: :collection
    end
  end
end
