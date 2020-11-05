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
      describe 'first row' do
        subject(:player) { Player.find_by_dk_id(15642242) }

        before do
          described_class.new(gameweek).import_csv(tmp_filepath)
        end

        it { expect(player.name).to eq 'Christian McCaffrey' }
        it { expect(player.position).to eq 'rb' }
        it { expect(player.team).to eq 'car' }
        it { expect(player.opponent).to eq 'car' } # TODO - Fix opponents as DK doesn't provide them
        it { expect(player.price).to eq 8_300 }
        it { expect(player.gameweek).to eq gameweek }
      end

      describe 'second row' do
        subject(:player) { Player.find_by_dk_id(15642450) }

        before do
          described_class.new(gameweek).import_csv(tmp_filepath)
        end

        it { expect(player.name).to eq 'DeAndre Hopkins' }
        it { expect(player.position).to eq 'wr' }
        it { expect(player.team).to eq 'ari' }
        it { expect(player.opponent).to eq 'ari' } # TODO - Fix opponents as DK doesn't provide them
        it { expect(player.price).to eq 8_200 }
        it { expect(player.gameweek).to eq gameweek }
      end
    end
  end
end
