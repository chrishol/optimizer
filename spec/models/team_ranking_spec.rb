require 'rails_helper'

RSpec.describe TeamRanking, type: :model do
  it 'has a valid factory' do
    expect(build(:team_ranking)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a gameweek' do
      expect(build(:team_ranking, gameweek: nil)).not_to be_valid
    end
  end
end
