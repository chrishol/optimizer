require 'rails_helper'

RSpec.describe Projection, type: :model do
  it 'has a valid factory' do
    expect(build(:projection)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without a projection_set' do
      expect(build(:projection, projection_set: nil)).not_to be_valid
    end

    it 'is invalid without a player' do
      expect(build(:projection, player: nil)).not_to be_valid
    end
  end
end
