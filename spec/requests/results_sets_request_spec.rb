require 'rails_helper'

RSpec.describe "ResultsSets", type: :request do
  describe "GET /index" do
    subject(:get_request) do
      get "/gameweeks/#{gameweek.id}/results_sets"
    end

    let(:gameweek) { create(:gameweek) }

    it "returns http success" do
      get_request
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    subject(:get_request) do
      get "/gameweeks/#{gameweek.id}/results_sets/#{results_set.id}"
    end

    let(:results_set) { create(:results_set) }
    let(:gameweek) { results_set.gameweek }

    it "returns http success" do
      get_request
      expect(response).to have_http_status(:success)
    end
  end
end
