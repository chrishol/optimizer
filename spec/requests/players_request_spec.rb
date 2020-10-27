require 'rails_helper'

RSpec.describe "Players", type: :request do
  describe "GET /index" do
    subject(:get_request) do
      get "/gameweeks/#{gameweek.id}/players"
    end

    let(:gameweek) { create(:gameweek) }

    it "returns http success" do
      get_request
      expect(response).to have_http_status(:success)
    end

    context "when a player pool already exists" do
      before do
        create(:player_pool, gameweek: gameweek)
      end

      it "does not create a new one" do
        expect {
          get_request
        }.not_to change(PlayerPool, :count).from(1)
      end
    end

    context "when a player pool does not already exist" do
      it "creates a new one" do
        expect {
          get_request
        }.to change(PlayerPool, :count).from(0).to(1)
      end

      it "links the new player pool to the right gameweek" do
        get_request
        expect(PlayerPool.last.gameweek).to eq gameweek
      end
    end
  end
end
