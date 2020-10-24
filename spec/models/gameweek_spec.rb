require 'rails_helper'

RSpec.describe Gameweek, type: :model do
  it 'has a valid factory' do
    expect(build(:gameweek)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a season' do
      expect(build(:gameweek, season: nil)).not_to be_valid
    end

    it 'is invalid without a week number' do
      expect(build(:gameweek, week_number: nil)).not_to be_valid
    end
  end
end
