require 'rails_helper'

RSpec.describe ResultsSet, type: :model do
  it 'has a valid factory' do
    expect(build(:results_set)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a slate_name' do
      expect(build(:results_set, slate_name: nil)).not_to be_valid
    end

    it 'is invalid without a slate_type' do
      expect(build(:results_set, slate_type: nil)).not_to be_valid
    end

    it 'is invalid without a valid slate_type' do
      expect(build(:results_set, slate_type: 'cage-match')).not_to be_valid
    end

    it 'is invalid without a gameweek' do
      expect(build(:results_set, gameweek: nil)).not_to be_valid
    end
  end
end
