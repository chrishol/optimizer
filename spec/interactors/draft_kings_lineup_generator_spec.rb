require "rails_helper"

describe DraftKingsLineupGenerator do
  let(:player_pool) { create(:player_pool) }

  describe "lineup_iterator" do
    subject(:lineup_iterator) do
      proc { |block| described_class.new(player_pool).lineup_iterator(&block) }
    end

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

    context 'when no players are locked' do
      before do
        players.each do |player|
          create(:player_pool_entry, player_pool: player_pool, player: player)
        end
      end

      it "can solve an easy problem and yields the results" do
        expect(lineup_iterator).to yield_control.exactly(2).times
      end

      it "yields a lineup class for each result" do
        expect(lineup_iterator).to yield_successive_args(
          be_a(DraftKingsLineup), be_a(DraftKingsLineup)
        )
      end
    end

    context 'when players are locked' do
      before do
        players.each_with_index do |player, index|
          create(
            :player_pool_entry,
            player_pool: player_pool,
            player: player,
            is_locked: (index == 0)
          )
        end
      end

      it "yields the results that include all the locked players" do
        expect(lineup_iterator).to yield_control.exactly(1).times
      end

      it "yields a lineup class for each result" do
        expect(lineup_iterator).to yield_with_args(
          be_a(DraftKingsLineup)
        )
      end
    end

    context 'when too many players are locked to create a valid lineup' do
      before do
        players.each_with_index do |player, index|
          create(
            :player_pool_entry,
            player_pool: player_pool,
            player: player,
            is_locked: (player.position == 'qb')
          )
        end
      end

      it "does not yield any results" do
        expect(lineup_iterator).not_to yield_control
      end
    end
  end
end
