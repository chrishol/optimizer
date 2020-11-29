require 'rails_helper'

RSpec.describe PlayerPoolEntry, type: :model do
  it 'has a valid factory' do
    expect(build(:player_pool_entry)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a player pool' do
      expect(build(:player_pool_entry, player_pool: nil)).not_to be_valid
    end

    it 'is invalid without a player' do
      expect(build(:player_pool_entry, player: nil)).not_to be_valid
    end

    describe 'locked and excluded' do
      it { expect(build(:player_pool_entry, is_locked: true)).to be_valid }
      it { expect(build(:player_pool_entry, is_excluded: true)).to be_valid }
      it { expect(build(:player_pool_entry, is_locked: true, is_excluded: true)).not_to be_valid }
    end
  end
end
