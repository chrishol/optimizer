require 'rails_helper'

RSpec.describe EnteredLineup, type: :model do
  it 'has a valid factory' do
    expect(build(:entered_lineup)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a results_set' do
      expect(build(:entered_lineup, results_set: nil)).not_to be_valid
    end

    it 'is invalid without a rank' do
      expect(build(:entered_lineup, slate_rank: nil)).not_to be_valid
    end

    it 'is invalid without an entry name' do
      expect(build(:entered_lineup, entry_name: nil)).not_to be_valid
    end
  end
end
