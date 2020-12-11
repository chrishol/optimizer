require 'rails_helper'

RSpec.describe GameLine, type: :model do
  it 'has a valid factory' do
    expect(build(:game_line)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a scheduled game' do
      expect(build(:game_line, scheduled_game: nil)).not_to be_valid
    end

    it 'is invalid without a home total' do
      expect(build(:game_line, home_total: nil)).not_to be_valid
    end

    it 'is invalid without a road total' do
      expect(build(:game_line, road_total: nil)).not_to be_valid
    end

    it 'is invalid without a game total' do
      expect(build(:game_line, game_total: nil)).not_to be_valid
    end

    it 'is invalid without a home spread' do
      expect(build(:game_line, home_spread: nil)).not_to be_valid
    end
  end
end
