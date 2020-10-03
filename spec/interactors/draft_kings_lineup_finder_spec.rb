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
      ).valid_lineups(price_position_data)
    end

    let(:price_position_data) do
      [
        { key: 1, position: "QB", price: "25_000" },
        { key: 2, position: "QB", price: "35_000" },
        { key: 3, position: "RB", price: "10_000" },
        { key: 4, position: "RB", price: "25_000" },
        { key: 5, position: "RB", price: "35_000" }
      ]
    end

    it "can solve an easy problem" do
      expect(valid_lineups).to match_array([
        [1, 4]
      ])
    end
  end
end
