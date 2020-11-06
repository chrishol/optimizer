require "rails_helper"

describe OpponentFinder do
  describe "opponent" do
    subject(:find_opponent) do
      described_class.new(gameweek).opponent(team)
    end

    let(:gameweek) { create(:gameweek) }
    let(:team) { 'lar' }
    let(:opponent) { 'sea' }

    context 'when team is at home' do
      before do
        create(
          :scheduled_game,
          gameweek: gameweek,
          home_team: team,
          road_team: opponent
        )
      end

      it 'returns the correct opponent' do
        expect(find_opponent).to eq opponent
      end
    end

    context 'when team is on the road' do
      before do
        create(
          :scheduled_game,
          gameweek: gameweek,
          home_team: opponent,
          road_team: team
        )
      end

      it 'returns the correct opponent' do
        expect(find_opponent).to eq opponent
      end
    end
  end
end
