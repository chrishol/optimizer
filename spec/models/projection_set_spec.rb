require 'rails_helper'

RSpec.describe ProjectionSet, type: :model do
  it 'has a valid factory' do
    expect(build(:projection_set)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a source' do
      expect(build(:projection_set, source: nil)).not_to be_valid
    end

    it 'is invalid without a gameweek' do
      expect(build(:projection_set, gameweek: nil)).not_to be_valid
    end
  end
end
