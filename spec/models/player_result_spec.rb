require 'rails_helper'

RSpec.describe PlayerResult, type: :model do
  it 'has a valid factory' do
    expect(build(:player_result)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a results_set' do
      expect(build(:player_result, results_set: nil)).not_to be_valid
    end

    it 'is invalid without a player' do
      expect(build(:player_result, player: nil)).not_to be_valid
    end
  end
end
