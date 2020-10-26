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
      ).valid_lineups(players)
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

    it "can solve an easy problem" do
      expect(valid_lineups.count).to eq(2)
    end

    it "returns an array of lineup classes" do
      expect(valid_lineups).to all be_a(DraftKingsLineup)
    end
  end
end
