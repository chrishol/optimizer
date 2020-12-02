require "rails_helper"

describe GameweekDataImporter do
  describe "import_csv" do
    let(:tmp_filepath) { './tmp/dk_test.csv' }
    let(:gameweek) { create(:gameweek) }

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "Position,Name + ID,Name,ID,Roster Position,Salary,Game Info,TeamAbbrev,AvgPointsPerGame\n"
        f << "RB,Christian McCaffrey (15642242) (LOCKED),Christian McCaffrey,15642242,RB/FLEX,8300,Final,CAR,26.65\n"
        f << "WR,DeAndre Hopkins (15642450) (LOCKED),DeAndre Hopkins,15642450,WR/FLEX,8200,In Progress,ARI,21.35\n"
      end
    end

    it 'creates rows for each player' do
      expect {
        described_class.new(gameweek).import_csv(tmp_filepath)
      }.to change(Player, :count).from(0).to(2)
    end

    describe 'imported fields' do
      let(:opponent_finder) { instance_double(OpponentFinder) }
      let(:game_venue) { 'home' }
      let(:opponent) { 'pit' }

      before do
        allow(OpponentFinder).to receive(:new).with(gameweek).and_return(opponent_finder)
        allow(opponent_finder).to receive(:opponent).and_return(opponent)
        allow(opponent_finder).to receive(:game_venue).and_return(game_venue)
      end

      describe 'first row' do
        subject(:player) do
          described_class.new(gameweek).import_csv(tmp_filepath)
          Player.find_by_dk_id(15642242)
        end

        it { expect(player.name).to eq 'Christian McCaffrey' }
        it { expect(player.position).to eq 'rb' }
        it { expect(player.team).to eq 'car' }
        it { expect(player.opponent).to eq opponent }
        it { expect(player.game_venue).to eq game_venue }
        it { expect(player.price).to eq 8_300 }
        it { expect(player.gameweek).to eq gameweek }
      end

      describe 'second row' do
        subject(:player) do
          described_class.new(gameweek).import_csv(tmp_filepath)
          Player.find_by_dk_id(15642450)
        end

        let(:game_venue) { 'road' }
        let(:opponent) { 'buf' }

        it { expect(player.name).to eq 'DeAndre Hopkins' }
        it { expect(player.position).to eq 'wr' }
        it { expect(player.team).to eq 'ari' }
        it { expect(player.opponent).to eq opponent }
        it { expect(player.game_venue).to eq game_venue }
        it { expect(player.price).to eq 8_200 }
        it { expect(player.gameweek).to eq gameweek }
      end

      describe 'price changes' do
        subject(:new_player) do
          described_class.new(gameweek).import_csv(tmp_filepath)
          Player.find_by_dk_id(15642242)
        end

        context 'when there is a previous gameweek' do
          let(:gameweek) { create(:gameweek, season: 2020, week_number: 5) }
          let!(:previous_gameweek) { create(:gameweek, season: 2020, week_number: 4) }

          context 'when there is a previous player entry' do
            before do
              create(
                :player,
                gameweek: previous_gameweek,
                dk_id: 15000000,
                name: 'Christian McCaffrey',
                position: 'rb',
                team: 'car',
                price: 9_800
              )
            end

            it 'sets the previous_price' do
              expect(new_player.previous_price).to eq(9_800)
            end
          end

          context 'when there is not a previous player entry' do
            it 'does not set the previous_price' do
              expect(new_player.previous_price).to be_nil
            end
          end
        end

        context 'when there is not a previous gameweek' do
          let(:gameweek) { create(:gameweek, season: 2020, week_number: 1) }

          it 'does not set the previous_price' do
            expect(new_player.previous_price).to be_nil
          end
        end
      end
    end
  end
end
