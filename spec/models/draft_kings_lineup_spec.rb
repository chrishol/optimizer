require 'rails_helper'

RSpec.describe DraftKingsLineup do
  describe 'valid?' do
    subject(:lineup) { described_class.new(players) }

    let(:players) do
      [qb, rb1, rb2, wr1, wr2, wr3, te, flex, dst]
    end

    let(:qb) { build(:player, position: 'qb', price: average_price) }
    let(:rb1) { build(:player, position: 'rb', price: average_price) }
    let(:rb2) { build(:player, position: 'rb', price: average_price) }
    let(:wr1) { build(:player, position: 'wr', price: average_price) }
    let(:wr2) { build(:player, position: 'wr', price: average_price) }
    let(:wr3) { build(:player, position: 'wr', price: average_price) }
    let(:te) { build(:player, position: 'te', price: average_price) }
    let(:dst) { build(:player, position: 'dst', price: average_price) }
    let(:flex) { build(:player, position: flex_position, price: average_price) }

    context 'when under the salary cap' do
      let(:average_price) { 5_000 }

      context 'when qb in the flex' do
        let(:flex_position) { 'qb' }

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when rb in the flex' do
        let(:flex_position) { 'rb' }

        it 'is valid' do
          expect(lineup.valid?).to eq true
        end
      end

      context 'when wr in the flex' do
        let(:flex_position) { 'wr' }

        it 'is valid' do
          expect(lineup.valid?).to eq true
        end
      end

      context 'when te in the flex' do
        let(:flex_position) { 'te' }

        it 'is valid' do
          expect(lineup.valid?).to eq true
        end
      end

      context 'when dst in the flex' do
        let(:flex_position) { 'dst' }

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when too many players' do
        let(:rb3) { build(:player, position: 'rb', price: average_price) }
        let(:rb4) { build(:player, position: 'rb', price: average_price) }

        let(:players) do
          [qb, rb1, rb2, rb3, rb4, wr1, wr2, wr3, te, dst]
        end

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when not enough players' do
        let(:players) do
          [qb, rb1, rb2, wr1, wr2, wr3, te, dst]
        end

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when lineup has duplicate players' do
        let(:rb3) { build(:player, position: 'rb', price: average_price) }

        let(:players) do
          [qb, rb1, rb2, rb3, rb3, wr1, wr2, wr3, te, dst]
        end

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end
    end

    context 'when over the salary cap' do
      let(:average_price) { 6_000 }

      context 'when rb in the flex' do
        let(:flex_position) { 'rb' }

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when wr in the flex' do
        let(:flex_position) { 'wr' }

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end

      context 'when te in the flex' do
        let(:flex_position) { 'te' }

        it 'is invalid' do
          expect(lineup.valid?).to eq false
        end
      end
    end
  end
end
