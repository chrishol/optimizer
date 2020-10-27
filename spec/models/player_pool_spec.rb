require 'rails_helper'

RSpec.describe PlayerPool, type: :model do
  it 'has a valid factory' do
    expect(build(:player_pool)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a gameweek' do
      expect(build(:player_pool, gameweek: nil)).not_to be_valid
    end
  end

  describe 'players' do
    subject(:players) { player_pool.players }

    let(:player_pool) { create(:player_pool) }
    let(:player1) { create(:player) }
    let(:player2) { create(:player) }

    before do
      create(:player_pool_entry, player_pool: player_pool, player: player1)
      create(:player_pool_entry, player_pool: player_pool, player: player2)
    end

    it 'returns the players from the entries association' do
      expect(players).to match_array([player1, player2])
    end
  end
end
