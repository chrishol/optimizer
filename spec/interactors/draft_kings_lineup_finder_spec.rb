require "rails_helper"

describe DraftKingsLineupFinder do
  describe "initialization" do
    it "can be initialized with a min price" do
      expect(
        described_class.new(min_price: 47_500)
      ).to be_a described_class
    end

    it "can be initialized with a max price" do
      expect(
        described_class.new(min_price: 47_500, max_price: 52_500)
      ).to be_a described_class
    end
  end

  describe "valid_lineups" do
    subject(:valid_lineups) do
      described_class.new(
        min_price: 50_000, max_price: 50_000
      ).valid_lineups(player_pool)
    end

    let(:player_pool) { create(:player_pool) }

    let(:players) do
      [
        create(:player, position: "qb", price: "5_000"),
        create(:player, position: "qb", price: "5_000"),
        create(:player, position: "rb", price: "5_000"),
        create(:player, position: "rb", price: "5_000"),
        create(:player, position: "rb", price: "5_000"),
        create(:player, position: "wr", price: "5_000"),
        create(:player, position: "wr", price: "5_000"),
        create(:player, position: "wr", price: "5_000"),
        create(:player, position: "te", price: "10_000"),
        create(:player, position: "dst", price: "5_000")
      ]
    end

    before do
      players.each do |player|
        create(:player_pool_entry, player_pool: player_pool, player: player)
      end
    end

    it "can solve an easy problem" do
      expect(valid_lineups.count).to eq(2)
    end

    it "returns an array of lineup classes" do
      expect(valid_lineups).to all be_a(DraftKingsLineup)
    end

    describe 'broadcaster' do
      subject(:valid_lineups) do
        described_class.new(
          min_price: 50_000, max_price: 50_000
        ).valid_lineups(player_pool, broadcast: broadcast)
      end

      let(:broadcaster_instance) { instance_double('LineupBroadcaster') }

      before do
        allow(LineupBroadcaster).to receive(:new).with(player_pool).and_return(broadcaster_instance)
        allow(broadcaster_instance).to receive(:broadcast_start)
        allow(broadcaster_instance).to receive(:broadcast_lineup)
        allow(broadcaster_instance).to receive(:broadcast_end)
      end

      context 'when broadcasting is on' do
        let(:broadcast) { true }

        it 'calls the LineupBroadcaster at the start' do
          valid_lineups
          expect(broadcaster_instance).to have_received(:broadcast_start).once
        end

        it 'calls the LineupBroadcaster per lineup' do
          valid_lineups
          expect(broadcaster_instance).to have_received(:broadcast_lineup).twice.with(be_a(DraftKingsLineup))
        end

        it 'calls the LineupBroadcaster per lineup' do
          valid_lineups
          expect(broadcaster_instance).to have_received(:broadcast_end).once.with(2)
        end
      end

      context 'when broadcasting is off' do
        let(:broadcast) { false }

        it 'does not call the LineupBroadcaster' do
          valid_lineups
          expect(broadcaster_instance).not_to have_received(:broadcast_lineup)
        end
      end
    end

    describe 'max lineups' do
      subject(:valid_lineups) do
        described_class.new(
          min_price: 50_000, max_price: 50_000
        ).valid_lineups(player_pool, broadcast: broadcast, max_lineups: max_limit)
      end

      let(:max_limit) { 1 }
      let(:broadcast) { false }
      let(:broadcaster_instance) { instance_double('LineupBroadcaster') }

      before do
        allow(LineupBroadcaster).to receive(:new).with(player_pool).and_return(broadcaster_instance)
        allow(broadcaster_instance).to receive(:broadcast_start)
        allow(broadcaster_instance).to receive(:broadcast_lineup)
        allow(broadcaster_instance).to receive(:broadcast_end)
        allow(broadcaster_instance).to receive(:broadcast_max_reached)
      end

      context 'when the max limit is reached' do
        it 'only returns the max amount' do
          expect(valid_lineups.count).to eq(max_limit)
        end

        context 'when broadcasting is on' do
          let(:broadcast) { true }

          it 'calls the LineupBroadcaster for the maximum being reached' do
            valid_lineups
            expect(broadcaster_instance).to have_received(:broadcast_max_reached).once.with(max_limit)
          end

          it 'does not call the LineupBroadcaster for the usual end message' do
            valid_lineups
            expect(broadcaster_instance).not_to have_received(:broadcast_end)
          end
        end

        context 'when broadcasting is off' do
          let(:broadcast) { false }

          it 'does not call the LineupBroadcaster for the maximum being reached' do
            valid_lineups
            expect(broadcaster_instance).not_to have_received(:broadcast_max_reached)
          end
        end
      end
    end
  end
end
