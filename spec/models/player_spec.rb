require 'rails_helper'

RSpec.describe Player, type: :model do
  it 'has a valid factory' do
    expect(build(:player)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a name' do
      expect(build(:player, name: nil)).not_to be_valid
    end

    it 'is invalid without a team' do
      expect(build(:player, team: nil)).not_to be_valid
    end

    it 'is invalid without a opponent' do
      expect(build(:player, opponent: nil)).not_to be_valid
    end

    it 'is invalid without a position' do
      expect(build(:player, position: nil)).not_to be_valid
    end

    it 'is invalid without a price' do
      expect(build(:player, price: nil)).not_to be_valid
    end

    it 'is invalid without a gameweek' do
      expect(build(:player, gameweek: nil)).not_to be_valid
    end
  end
end
