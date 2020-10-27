require 'rails_helper'

RSpec.describe "LineupGenerations", type: :request do
  describe "POST /create" do
    subject(:create_request) do
      post "/lineup_generations", params: {
        player_pool_id: 123
      }
    end

    xit "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end
end
