require 'rails_helper'

RSpec.describe "MarketingPages", type: :request do
  describe "GET /index" do
    subject(:get_request) do
      get "/"
    end

    it "returns http success" do
      get_request
      expect(response).to have_http_status(:success)
    end
  end
end
