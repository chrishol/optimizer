require 'rails_helper'

RSpec.describe ScheduledGame, type: :model do
  it 'has a valid factory' do
    expect(build(:scheduled_game)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a gameweek' do
      expect(build(:scheduled_game, gameweek: nil)).not_to be_valid
    end

    it 'is invalid without a start time' do
      expect(build(:scheduled_game, start_time: nil)).not_to be_valid
    end

    it 'is invalid without a home team' do
      expect(build(:scheduled_game, home_team: nil)).not_to be_valid
    end

    it 'is invalid without a valid home team' do
      expect(build(:scheduled_game, home_team: 'oak')).not_to be_valid
    end

    it 'is invalid without a road team' do
      expect(build(:scheduled_game, road_team: nil)).not_to be_valid
    end

    it 'is invalid without a valid road team' do
      expect(build(:scheduled_game, road_team: 'oak')).not_to be_valid
    end
  end
end
