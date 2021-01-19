require "rails_helper"

describe TeamRankingImporter do
  describe "import_csv" do
    let(:tmp_filepath) { './tmp/team_ranking_data.csv' }
    let(:gameweek) { create(:gameweek) }

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "\"Long Team\",\"off_dvoa_rank\",\"off_pass_dvoa_rank\",\"off_rush_dvoa_rank\",\"def_dvoa_rank\",\"def_pass_dvoa_rank\",\"def_rush_dvoa_rank\",\"team_name\",\"etr_ol_rank\",\"etr_dl_rank\"\n"
        f << "\"Buccaneers\",14,14,23,5,7,1,\"tb\",4,10\n"
        f << "\"Lions\",5,6,10,32,31,28,\"det\",11,19\n"
      end
    end

    it 'creates ranking rows for each teams' do
      expect {
        described_class.new(gameweek).import_csv(tmp_filepath)
      }.to change(TeamRanking, :count).from(0).to(2)
    end

    describe 'imported fields' do
      describe 'first row' do
        subject(:ranking) { TeamRanking.find_by_team_name('tb') }

        before do
          described_class.new(gameweek).import_csv(tmp_filepath)
        end

        it { expect(ranking.off_dvoa_rank).to eq 14 }
        it { expect(ranking.off_pass_dvoa_rank).to eq 14 }
        it { expect(ranking.off_rush_dvoa_rank).to eq 23 }
        it { expect(ranking.def_dvoa_rank).to eq 5 }
        it { expect(ranking.def_pass_dvoa_rank).to eq 7 }
        it { expect(ranking.def_rush_dvoa_rank).to eq 1 }
        it { expect(ranking.etr_ol_rank).to eq 4 }
        it { expect(ranking.etr_dl_rank).to eq 10 }
      end

      describe 'second row' do
        subject(:ranking) { TeamRanking.find_by_team_name('det') }

        before do
          described_class.new(gameweek).import_csv(tmp_filepath)
        end

        it { expect(ranking.off_dvoa_rank).to eq 5 }
        it { expect(ranking.off_pass_dvoa_rank).to eq 6 }
        it { expect(ranking.off_rush_dvoa_rank).to eq 10 }
        it { expect(ranking.def_dvoa_rank).to eq 32 }
        it { expect(ranking.def_pass_dvoa_rank).to eq 31 }
        it { expect(ranking.def_rush_dvoa_rank).to eq 28 }
        it { expect(ranking.etr_ol_rank).to eq 11 }
        it { expect(ranking.etr_dl_rank).to eq 19 }
      end
    end
  end
end
