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

  describe 'stack_description' do
    subject(:stack_description) { described_class.new(players).stack_description }

    let(:players) do
      [qb, rb1, rb2, wr1, wr2, wr3, te, flex, dst]
    end

    let(:qb) { build(:player, position: 'qb', team: 'ari', opponent: 'was') }
    let(:rb1) { build(:player, position: 'rb', team: 'atl', opponent: 'ten') }
    let(:rb2) { build(:player, position: 'rb', team: 'bal', opponent: 'tb') }
    let(:wr1) { build(:player, position: 'wr', team: 'buf', opponent: 'sf') }
    let(:wr2) { build(:player, position: 'wr', team: 'car', opponent: 'sea') }
    let(:wr3) { build(:player, position: 'wr', team: 'chi', opponent: 'pit') }
    let(:te) { build(:player, position: 'te', team: 'cin', opponent: 'phi') }
    let(:dst) { build(:player, position: 'dst', team: 'cle', opponent: 'nyj') }
    let(:flex) { build(:player, position: 'wr', team: 'dal', opponent: 'nyg') }

    context 'when not a stack' do
      it { expect(stack_description).to be_nil }
    end

    context 'when a stack without the qb' do
      let(:wr1) { build(:player, position: 'wr', team: 'atl', opponent: 'ten') }
      let(:te) { build(:player, position: 'te', team: 'ten', opponent: 'atl') }

      it { expect(stack_description).to be_nil }
    end

    context 'when a stack with an rb' do
      let(:rb1) { build(:player, position: 'rb', team: 'ari', opponent: 'was') }
      let(:te) { build(:player, position: 'te', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to be_nil }
    end

    context 'when a stack with dst' do
      let(:dst) { build(:player, position: 'dst', team: 'ari', opponent: 'was') }
      let(:te) { build(:player, position: 'te', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to be_nil }
    end

    context 'when a simple stack with the qb' do
      let(:wr1) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:te) { build(:player, position: 'te', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to eq '2x1' }
    end

    context 'when a larger stack with the qb' do
      let(:wr1) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:wr2) { build(:player, position: 'wr', team: 'was', opponent: 'ari') }
      let(:wr3) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:te) { build(:player, position: 'te', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to eq '3x2' }
    end

    context 'when a simple stack with the qb and flex' do
      let(:wr1) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:flex) { build(:player, position: 'wr', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to eq '2x1' }
    end

    context 'when a stack plus another mini-stack' do
      let(:wr1) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:wr2) { build(:player, position: 'wr', team: 'atl', opponent: 'ten') }
      let(:wr3) { build(:player, position: 'wr', team: 'was', opponent: 'ari') }
      let(:te) { build(:player, position: 'te', team: 'ten', opponent: 'atl') }

      it { expect(stack_description).to eq '2x1++' }
    end

    context 'when the other mini-stack are rbs' do
      let(:rb1) { build(:player, position: 'rb', team: 'atl', opponent: 'ten') }
      let(:rb2) { build(:player, position: 'rb', team: 'ten', opponent: 'atl') }
      let(:wr1) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:wr2) { build(:player, position: 'wr', team: 'ari', opponent: 'was') }
      let(:wr3) { build(:player, position: 'wr', team: 'was', opponent: 'ari') }
      let(:te) { build(:player, position: 'te', team: 'was', opponent: 'ari') }

      it { expect(stack_description).to eq '3x2++' }
    end
  end
end
