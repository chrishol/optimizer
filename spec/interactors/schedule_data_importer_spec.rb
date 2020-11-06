require "rails_helper"

describe ScheduleDataImporter do
  describe "import_csv" do
    let(:tmp_filepath) { './tmp/schedule_test.csv' }
    let(:season_year) { 2020 }
    let!(:gameweek6) { create(:gameweek, season: season_year, week_number: 6) }
    let!(:gameweek17) { create(:gameweek, season: season_year, week_number: 17) }

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "Week,Day,Date,Time,Winner/tie,Home/Road,Loser/tie,,PtsW,PtsL,YdsW,TOW,YdsL,TOL\n"
        f << "6,Sun,October 18,4:05PM,Miami Dolphins,,New York Jets,boxscore,24,0,302,2,263,1\n"
        f << "17,Sun,January 3,1:00PM,Jacksonville Jaguars,@,Indianapolis Colts,preview,,,,,,\n"
      end
    end

    it 'creates rows for each game' do
      expect {
        described_class.new(season_year).import_csv(tmp_filepath)
      }.to change(ScheduledGame, :count).from(0).to(2)
    end

    context "when a gameweek does not exist" do
      before do
        File.open(tmp_filepath, 'a') do |f|
          f << "12,Sun,November 29,1:00PM,New York Giants,@,Cincinnati Bengals,preview,,,,,,\n"
        end
      end

      it 'creates the relevant gameweek' do
        expect {
          described_class.new(season_year).import_csv(tmp_filepath)
        }.to change(Gameweek, :count).from(2).to(3)
      end

      describe 'created gameweek' do
        subject(:gameweek) { Gameweek.find_by(week_number: 12) }

        before do
          described_class.new(season_year).import_csv(tmp_filepath)
        end

        it { expect(gameweek.season).to eq season_year }
      end
    end

    describe 'imported fields' do
      describe 'first row' do
        subject(:game) { ScheduledGame.find_by_gameweek_id(gameweek6.id) }

        let(:start_time) do
          Time.find_zone("America/New_York").local(2020, 10, 18, 16, 5)
        end

        before do
          described_class.new(season_year).import_csv(tmp_filepath)
        end

        it { expect(game.home_team).to eq 'mia' }
        it { expect(game.road_team).to eq 'nyj' }
        it { expect(game.start_time).to eq start_time }
      end

      describe 'second row' do
        subject(:game) { ScheduledGame.find_by_gameweek_id(gameweek17.id) }

        let(:start_time) do
          Time.find_zone("America/New_York").local(2021, 1, 3, 13)
        end

        before do
          described_class.new(season_year).import_csv(tmp_filepath)
        end

        it { expect(game.home_team).to eq 'ind' }
        it { expect(game.road_team).to eq 'jax' }
        it { expect(game.start_time).to eq start_time }
      end
    end
  end
end
