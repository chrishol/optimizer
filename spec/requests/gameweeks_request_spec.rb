require 'rails_helper'

RSpec.describe "Gameweeks", type: :request do
  describe "GET /index" do
    before do
      create(:player)
    end

    it "redirects" do
      get "/gameweeks"
      expect(response).to have_http_status(302)
    end
  end
end
