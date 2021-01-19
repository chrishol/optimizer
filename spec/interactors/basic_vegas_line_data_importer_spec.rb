require "rails_helper"

describe BasicVegasLineDataImporter do

  describe "import_csv" do
    let(:tmp_filepath) { './tmp/basic_vegas_data.csv' }
    let(:gameweek) { create(:gameweek) }

    let!(:det_tb_game) do
      create(
        :scheduled_game,
        gameweek: gameweek,
        home_team: 'det',
        road_team: 'tb',
        start_time: "2020-12-11 01:20:00 UTC"
      )
    end
    let!(:sf_ari_game) do
      create(
        :scheduled_game,
        gameweek: gameweek,
        home_team: 'sf',
        road_team: 'ari',
        start_time: "2020-12-11 01:20:00 UTC"
      )
    end

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "\"Long Team\",\"team_total\",\"spread\",\"game_total\",\"team_name\"\n"
        f << "\"Buccaneers\",31.75,-9.5,54,\"tb\"\n"
        f << "\"Lions\",22.25,9.5, 54,\"det\"\n"
        f << "\"Cardinals\",27,-5.5,48.5,\"ari\"\n"
        f << "\"49ers\",21.5,5.5,48.5,\"sf\"\n"
      end
    end

    it 'creates game line rows for each team' do
      expect {
        described_class.new(gameweek).import_csv(tmp_filepath)
      }.to change(GameLine, :count).from(0).to(2)
    end

    describe 'imported fields' do
      before do
        described_class.new(gameweek).import_csv(tmp_filepath)
      end

      describe 'first row' do
        subject(:game_line) do
          det_tb_game.reload
          det_tb_game.game_lines.first
        end

        it { expect(game_line.site_name).to eq('Reddit') }
        it { expect(game_line.game_total).to eq(54) }
        it { expect(game_line.home_spread).to eq(9.5) }
        it { expect(game_line.home_total).to eq(22.25) }
        it { expect(game_line.road_total).to eq(31.75) }
      end

      describe 'second row' do
        subject(:game_line) do
          sf_ari_game.reload
          sf_ari_game.game_lines.first
        end

        it { expect(game_line.site_name).to eq('Reddit') }
        it { expect(game_line.game_total).to eq(48.5) }
        it { expect(game_line.home_spread).to eq(5.5) }
        it { expect(game_line.home_total).to eq(21.5) }
        it { expect(game_line.road_total).to eq(27) }
      end
    end
  end
end
