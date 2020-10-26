require 'rails_helper'

RSpec.describe "Players", type: :request do

  describe "GET /index" do
    let(:gameweek) { create(:gameweek) }

    it "returns http success" do
      get "/gameweeks/#{gameweek.id}/players"
      expect(response).to have_http_status(:success)
    end
  end

end