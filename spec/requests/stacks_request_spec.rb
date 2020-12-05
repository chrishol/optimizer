require 'rails_helper'

RSpec.describe "Stacks", type: :request do
  describe "GET /index" do
    subject(:get_request) do
      get "/gameweeks/#{gameweek.id}/stacks"
    end

    let(:gameweek) { create(:gameweek) }

    it "returns http success" do
      get_request
      expect(response).to have_http_status(:success)
    end
  end
end
