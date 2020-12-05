Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'

  root to: "marketing_pages#index"

  resources :gameweeks, only: %w(index) do
    resources :players, only: %w(index)
    resources :projection_charts, only: %w(index)
    resources :optimizer_tools, only: %w(index)
    resources :results_sets, only: %w(index show)
    resources :stacks, only: %w(index)
  end

  resources :players, only: %w(show)

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
