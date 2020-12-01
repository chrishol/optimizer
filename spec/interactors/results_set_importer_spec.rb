require "rails_helper"

describe ResultsSetImporter do
  describe "import_csv" do
    let(:tmp_filepath) { './tmp/spec/contest_results.csv' }
    let(:gameweek) { create(:gameweek) }
    let!(:dalvin_cook) { create(:player, gameweek: gameweek, name: 'Dalvin Cook') }
    let!(:nyheim_hines) { create(:player, gameweek: gameweek, name: 'Nyheim Hines') }
    let!(:brian_hill) { create(:player, gameweek: gameweek, name: 'Brian Hill') }

    let!(:pat_mahomes) { create(:player, gameweek: gameweek, name: 'Patrick Mahomes') }
    let!(:the_big_dog) { create(:player, gameweek: gameweek, name: 'Derrick Henry') }
    let!(:tyreek_hill) { create(:player, gameweek: gameweek, name: 'Tyreek Hill') }
    let!(:devante_parker) { create(:player, gameweek: gameweek, name: 'DeVante Parker') }
    let!(:jarvis_landry) { create(:player, gameweek: gameweek, name: 'Jarvis Landry') }
    let!(:kyle_rudolph) { create(:player, gameweek: gameweek, name: 'Kyle Rudolph') }
    let!(:saints_dst) { create(:player, gameweek: gameweek, name: 'Saints') }

    let!(:fitz) { create(:player, gameweek: gameweek, name: 'Ryan Fitzpatrick') }
    let!(:nick_chubb) { create(:player, gameweek: gameweek, name: 'Nick Chubb') }
    let!(:keelan_cole) { create(:player, gameweek: gameweek, name: 'Keelan Cole Sr.') }
    let!(:evan_engram) { create(:player, gameweek: gameweek, name: 'Evan Engram') }

    let!(:kirk_cousins) { create(:player, gameweek: gameweek, name: 'Kirk Cousins') }
    let!(:kareem_hunt) { create(:player, gameweek: gameweek, name: 'Kareem Hunt') }
    let!(:justin_jefferson) { create(:player, gameweek: gameweek, name: 'Justin Jefferson') }
    let!(:robby_anderson) { create(:player, gameweek: gameweek, name: 'Robby Anderson') }
    let!(:curtis_samuel) { create(:player, gameweek: gameweek, name: 'Curtis Samuel') }
    let!(:falcons_dst) { create(:player, gameweek: gameweek, name: 'Falcons') }

    let(:slate_name) { 'DraftKings $25 Single Entry Double Up' }
    let(:slate_type) { 'cash' }

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "Rank,EntryId,EntryName,TimeRemaining,Points,Lineup,,Player,Roster Position,%Drafted,FPTS\n"
        f << "1,1234567890,abc12340,0,242.68,QB Patrick Mahomes RB Derrick Henry RB Nyheim Hines FLEX Brian Hill WR Tyreek Hill WR DeVante Parker WR Jarvis Landry TE Kyle Rudolph DST Saints ,,Dalvin Cook,RB,45.70%,11.2\n"
        f << "2,1234567891,abc12341,0,242.37999,QB Ryan Fitzpatrick RB Derrick Henry FLEX Nick Chubb RB Nyheim Hines WR Tyreek Hill WR Jarvis Landry WR Keelan Cole Sr. TE Evan Engram DST Saints ,,Nyheim Hines,RB,38.08%,17.5\n"
        f << "3,1234567892,abc12342,0,238.68,QB Kirk Cousins RB Derrick Henry RB Kareem Hunt FLEX Tyreek Hill WR Justin Jefferson WR Robby Anderson WR Curtis Samuel TE Kyle Rudolph DST Falcons ,,Brian Hill,RB,32.27%,5.5\n"
        # f << '4,1234567893,abc12343,0,238.48,QB Patrick Mahomes RB Derrick Henry RB Austin Ekeler FLEX Nyheim Hines WR Tyreek Hill WR Gabriel Davis WR Andy Isabella TE Travis Kelce DST Panthers ,,Travis Kelce,TE,29.42%,16.2'
        # f << '5,1234567894,abc12344,0,229.68,QB Ryan Fitzpatrick RB Derrick Henry RB Nyheim Hines WR Tyreek Hill FLEX Justin Jefferson WR DeVante Parker WR Sterling Shepard TE Kyle Rudolph DST Saints ,,Tyreek Hill,WR,28.28%,60.9'
        # f << '6,1234567895,abc12345,0,228.88,QB Patrick Mahomes RB Austin Ekeler RB Nyheim Hines WR Tyreek Hill WR Justin Jefferson WR Jarvis Landry TE Travis Kelce FLEX Kyle Rudolph DST Broncos ,,Saints ,DST,26.80%,14'
        # f << '7,1234567896,abc12346,0,227.27998,QB Ryan Fitzpatrick RB Nick Chubb RB James Robinson FLEX Nyheim Hines WR Tyreek Hill WR Robby Anderson WR DeVante Parker TE Kyle Rudolph DST Saints ,,Wayne Gallman Jr.,RB,24.38%,18.1'
        # f << '8,1234567897,abc12347,0,226.48001,QB Ryan Fitzpatrick RB Derrick Henry RB Nick Chubb FLEX Wayne Gallman Jr. WR Tyreek Hill WR Justin Jefferson WR Antonio Brown TE Jack Doyle DST Falcons ,,Patrick Mahomes,QB,23.14%,35.28'
        # f << '9,1234567898,abc12348,0,224.78,QB Kirk Cousins RB Derrick Henry RB Brian Hill FLEX Keenan Allen WR Tyreek Hill WR Justin Jefferson WR Gabriel Davis TE Kyle Rudolph DST Saints ,,Calvin Ridley,WR,22.02%,17'
        # f << '9,1234567899,abc12349,0,224.78,QB Patrick Mahomes RB Derrick Henry FLEX Austin Ekeler RB Nyheim Hines WR Tyreek Hill WR Jakobi Meyers WR Curtis Samuel TE Kyle Rudolph DST Jets ,,DeVante Parker,WR,21.96%,22.9'
        # f << '11,1234567800,abc12350,0,223.98,QB Ryan Fitzpatrick RB Derrick Henry RB Austin Ekeler FLEX Nyheim Hines WR Tyreek Hill WR DeVante Parker WR Jakobi Meyers TE Kyle Rudolph DST Saints ,,Justin Jefferson,WR,21.49%,26'
      end
    end

    it 'creates a results set' do
      expect {
        described_class.new(gameweek, slate_name, slate_type).import_csv(tmp_filepath)
      }.to change(ResultsSet, :count).from(0).to(1)
    end

    it 'creates player results rows for each player' do
      expect {
        described_class.new(gameweek, slate_name, slate_type).import_csv(tmp_filepath)
      }.to change(PlayerResult, :count).from(0).to(3)
    end

    # it 'creates result lineups rows for each player' do
    #   expect {
    #     described_class.new(gameweek, slate_name, slate_type).import_csv(tmp_filepath)
    #   }.to change(DraftKingsLineup, :count).from(0).to(3)
    # end

    describe 'imported result fields' do
      let(:results_set) { ResultsSet.last }

      before do
        described_class.new(gameweek, slate_name, slate_type).import_csv(tmp_filepath)
      end

      describe 'result set' do
        it { expect(results_set.slate_name).to eq slate_name }
        it { expect(results_set.slate_type).to eq slate_type }
      end

      describe 'first player result row' do
        subject(:player_result) do
          PlayerResult.find_by_player_id(dalvin_cook.id)
        end

        it { expect(player_result.ownership).to eq 45.7 }
        it { expect(player_result.points).to eq 11.2 }
      end

      describe 'second player result row' do
        subject(:player_result) do
          PlayerResult.find_by_player_id(nyheim_hines.id)
        end

        it { expect(player_result.ownership).to eq 38.08 }
        it { expect(player_result.points).to eq 17.5 }
      end

      describe 'third player result row' do
        subject(:player_result) do
          PlayerResult.find_by_player_id(brian_hill.id)
        end

        it { expect(player_result.ownership).to eq 32.27 }
        it { expect(player_result.points).to eq 5.5 }
      end
    end

    # describe 'idempotency' do
    #   let(:tmp_filepath2) { './tmp/etr_projections_updated.csv' }
    #
    #   before do
    #     described_class.new(gameweek).import_csv(tmp_filepath)
    #
    #     File.open(tmp_filepath2, 'w') do |f|
    #       f << "\"Player\",\"Team\",\"Opponent\",\"DK Position\",\"DK Salary\",\"DK Projection\",\"DK Value\",\"DK Ownership\",\"DKSlateID\"\n"
    #       f << "\"Mike Davis\",\"CAR\",\"TB\",\"RB\",\"$4000\",\"21.5\",\"7.1\",\"53%\",\"15751496\"\n"
    #       f << "\"Aaron Jones\",\"GB\",\"JAX\",\"RB\",\"$7100\",\"20.1\",\"3.5\",\"22%\",\"15751412\"\n"
    #     end
    #   end
    #
    #   it 'is idempotent wrt projection sets' do
    #     expect {
    #       described_class.new(gameweek).import_csv(tmp_filepath2)
    #     }.not_to change(ProjectionSet, :count).from(1)
    #   end
    #
    #   it 'is idempotent wrt projections' do
    #     expect {
    #       described_class.new(gameweek).import_csv(tmp_filepath2)
    #     }.not_to change(Projection, :count).from(2)
    #   end
    #
    #   describe 'updating existing records' do
    #     before do
    #       described_class.new(gameweek).import_csv(tmp_filepath2)
    #     end
    #
    #     let(:projection_set) { ProjectionSet.last }
    #
    #     describe 'first row' do
    #       subject(:projection) do
    #         Projection.find_by_player_id(mike_davis.id)
    #       end
    #
    #       it { expect(projection.projection).to eq 21.5 }
    #       it { expect(projection.projected_value).to eq 7.1 }
    #       it { expect(projection.projected_ownership).to eq 53 }
    #       it { expect(projection.player).to eq mike_davis }
    #       it { expect(projection.projection_set).to eq projection_set }
    #     end
    #
    #     describe 'second row' do
    #       subject(:projection) do
    #         Projection.find_by_player_id(aaron_jones.id)
    #       end
    #
    #       it { expect(projection.projection).to eq 20.1 }
    #       it { expect(projection.projected_value).to eq 3.5 }
    #       it { expect(projection.projected_ownership).to eq 22 }
    #       it { expect(projection.player).to eq aaron_jones }
    #       it { expect(projection.projection_set).to eq projection_set }
    #     end
    #   end
    # end
  end
end
