require "rails_helper"

describe DraftKingsSwapFinder do
  describe "valid_lineups" do
    subject(:swaps) do
      described_class.new(player_pool).swaps(swap_size: swap_size)
    end

    let(:player_pool) { create(:player_pool) }
    let(:players) { [] }

    before do
      players.each do |player|
        create(:player_pool_entry, player_pool: player_pool, player: player)
      end
    end

    context 'when swap size < 2' do
      let(:swap_size) { 1 }

      it 'raises an error' do
        expect { swaps }.to raise_error
      end
    end

    context 'when swap size >= 2' do
      let(:swap_size) { 2 }

      context 'when there are no possible swaps' do
        let(:players) do
          [
            create(:player, position: "qb", price: "1_000"),
            create(:player, position: "qb", price: "2_000"),
            create(:player, position: "wr", price: "3_000"),
            create(:player, position: "wr", price: "5_000"),
          ]
        end

        it "returns an empty array" do
          expect(swaps).to eq []
        end
      end

      context 'when there are 1-for-1 swaps' do
        let(:players) do
          [
            create(:player, position: "qb", price: "1_000"),
            create(:player, position: "qb", price: "2_000"),
            create(:player, position: "wr", price: "3_000"),
            create(:player, position: "wr", price: "5_000"),
            create(:player, position: "te", price: "2_500"),
            create(:player, position: "te", price: "2_500"),
          ]
        end

        it "returns an empty array" do
          expect(swaps).to eq []
        end
      end

      context 'when there are 2-for-2 swaps with different positions' do
        let(:players) do
          [
            create(:player, position: "qb", price: "1_000"),
            create(:player, position: "rb", price: "2_000"),
            create(:player, position: "wr", price: "4_000"),
            create(:player, position: "te", price: "3_000"),
          ]
        end

        it "returns an empty array" do
          expect(swaps).to eq []
        end
      end

      context 'when there are 2-for-2 swaps' do
        let(:players) do
          [
            create(:player, position: "qb", price: "1_000"),
            create(:player, position: "qb", price: "2_000"),
            create(:player, position: "wr", price: "4_000"),
            create(:player, position: "wr", price: "3_000"),
          ]
        end

        it "returns the possible swaps" do
          expect(swaps.count).to eq 1
        end

        it "returns an array of swap classes" do
          expect(swaps).to all be_a(DraftKingsSwap)
        end
      end

      context 'when swap size == 3' do
        let(:swap_size) { 3 }

        context 'when there are 3-for-3 swaps' do
          let(:players) do
            [
              create(:player, position: "qb", price: "1_000"),
              create(:player, position: "qb", price: "2_000"),
              create(:player, position: "rb", price: "2_000"),
              create(:player, position: "rb", price: "3_000"),
              create(:player, position: "wr", price: "6_000"),
              create(:player, position: "wr", price: "4_000"),
            ]
          end

          it "returns the possible swaps" do
            expect(swaps.count).to eq 1
          end

          it "returns an array of swap classes" do
            expect(swaps).to all be_a(DraftKingsSwap)
          end
        end
      end
    end

    # describe 'broadcaster' do
    #   subject(:valid_lineups) do
    #     described_class.new(
    #       min_price: 50_000, max_price: 50_000
    #     ).valid_lineups(player_pool, broadcast: broadcast)
    #   end
    #
    #   let(:broadcaster_instance) { instance_double('LineupBroadcaster') }
    #
    #   before do
    #     allow(LineupBroadcaster).to receive(:new).with(player_pool).and_return(broadcaster_instance)
    #     allow(broadcaster_instance).to receive(:broadcast_start)
    #     allow(broadcaster_instance).to receive(:broadcast_lineup)
    #     allow(broadcaster_instance).to receive(:broadcast_end)
    #   end
    #
    #   context 'when broadcasting is on' do
    #     let(:broadcast) { true }
    #
    #     it 'calls the LineupBroadcaster at the start' do
    #       valid_lineups
    #       expect(broadcaster_instance).to have_received(:broadcast_start).once
    #     end
    #
    #     it 'calls the LineupBroadcaster per lineup' do
    #       valid_lineups
    #       expect(broadcaster_instance).to have_received(:broadcast_lineup).twice.with(be_a(DraftKingsLineup))
    #     end
    #
    #     it 'calls the LineupBroadcaster per lineup' do
    #       valid_lineups
    #       expect(broadcaster_instance).to have_received(:broadcast_end).once.with(2)
    #     end
    #   end
    #
    #   context 'when broadcasting is off' do
    #     let(:broadcast) { false }
    #
    #     it 'does not call the LineupBroadcaster' do
    #       valid_lineups
    #       expect(broadcaster_instance).not_to have_received(:broadcast_lineup)
    #     end
    #   end
    # end
    #
    # describe 'max lineups' do
    #   subject(:valid_lineups) do
    #     described_class.new(
    #       min_price: 50_000, max_price: 50_000
    #     ).valid_lineups(player_pool, broadcast: broadcast, max_lineups: max_limit)
    #   end
    #
    #   let(:max_limit) { 1 }
    #   let(:broadcast) { false }
    #   let(:broadcaster_instance) { instance_double('LineupBroadcaster') }
    #
    #   before do
    #     allow(LineupBroadcaster).to receive(:new).with(player_pool).and_return(broadcaster_instance)
    #     allow(broadcaster_instance).to receive(:broadcast_start)
    #     allow(broadcaster_instance).to receive(:broadcast_lineup)
    #     allow(broadcaster_instance).to receive(:broadcast_end)
    #     allow(broadcaster_instance).to receive(:broadcast_max_reached)
    #   end
    #
    #   context 'when the max limit is reached' do
    #     it 'only returns the max amount' do
    #       expect(valid_lineups.count).to eq(max_limit)
    #     end
    #
    #     context 'when broadcasting is on' do
    #       let(:broadcast) { true }
    #
    #       it 'calls the LineupBroadcaster for the maximum being reached' do
    #         valid_lineups
    #         expect(broadcaster_instance).to have_received(:broadcast_max_reached).once.with(max_limit)
    #       end
    #
    #       it 'does not call the LineupBroadcaster for the usual end message' do
    #         valid_lineups
    #         expect(broadcaster_instance).not_to have_received(:broadcast_end)
    #       end
    #     end
    #
    #     context 'when broadcasting is off' do
    #       let(:broadcast) { false }
    #
    #       it 'does not call the LineupBroadcaster for the maximum being reached' do
    #         valid_lineups
    #         expect(broadcaster_instance).not_to have_received(:broadcast_max_reached)
    #       end
    #     end
    #   end
    # end
  end
end
