require 'rails_helper'

RSpec.describe "PlayerPoolEntries", type: :request do
  describe "POST /create" do
    let(:player_pool) { create(:player_pool) }
    let(:player) { create(:player) }

    describe "request" do
      subject(:create_request) do
        post "/player_pool_entries", params: {
          player_pool_entry: {
            player_pool_id: player_pool.id,
            player_id: player.id
          }
        }
      end

      it "returns 302 redirect" do
        create_request
        expect(response).to have_http_status(:found)
      end

      it "creates an entry record" do
        expect {
          create_request
        }.to change(PlayerPoolEntry, :count).from(0).to(1)
      end
    end

    describe "created attributes" do
      subject(:player_pool_entry) { PlayerPoolEntry.last }

      before do
        post "/player_pool_entries", params: {
          player_pool_entry: {
            player_pool_id: player_pool.id,
            player_id: player.id
          }
        }
      end

      it { expect(player_pool_entry.player_pool).to eq player_pool }
      it { expect(player_pool_entry.player).to eq player }
    end
  end

  describe "DELETE /destroy" do
    let!(:player_pool_entry) { create(:player_pool_entry) }

    describe "request" do
      subject(:delete_request) do
        delete "/player_pool_entries/#{player_pool_entry.id}"
      end

      it "returns 302 redirect" do
        delete_request
        expect(response).to have_http_status(:found)
      end

      it "deletes the entry record" do
        expect {
          delete_request
        }.to change(PlayerPoolEntry, :count).from(1).to(0)
      end
    end
  end
end
