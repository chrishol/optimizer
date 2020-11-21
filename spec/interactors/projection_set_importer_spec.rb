require "rails_helper"

describe ProjectionSetImporter do
  describe "import_csv" do
    let(:tmp_filepath) { './tmp/etr_projections.csv' }
    let(:gameweek) { create(:gameweek) }
    let!(:mike_davis) { create(:player, gameweek: gameweek, dk_id: 15751496) }
    let!(:aaron_jones) { create(:player, gameweek: gameweek, dk_id: 15751412) }

    before do
      File.open(tmp_filepath, 'w') do |f|
        f << "\"Player\",\"Team\",\"Opponent\",\"DK Position\",\"DK Salary\",\"DK Projection\",\"DK Value\",\"DK Ownership\",\"DKSlateID\"\n"
        f << "\"Mike Davis\",\"CAR\",\"TB\",\"RB\",\"$4000\",\"17.8\",\"6.8\",\"46%\",\"15751496\"\n"
        f << "\"Aaron Jones\",\"GB\",\"JAX\",\"RB\",\"$7100\",\"20.8\",\"3.7\",\"28%\",\"15751412\"\n"
      end
    end

    it 'creates a projection set' do
      expect {
        described_class.new(gameweek).import_csv(tmp_filepath)
      }.to change(ProjectionSet, :count).from(0).to(1)
    end

    it 'creates projection rows for each player' do
      expect {
        described_class.new(gameweek).import_csv(tmp_filepath)
      }.to change(Projection, :count).from(0).to(2)
    end

    describe 'imported fields' do
      let(:projection_set) { ProjectionSet.last }

      before do
        described_class.new(gameweek).import_csv(tmp_filepath)
      end

      describe 'projection set' do
        it { expect(projection_set.source).to eq 'Establish the Run' }
        it { expect(projection_set.gameweek).to eq gameweek }
      end

      describe 'first row' do
        subject(:projection) do
          Projection.find_by_player_id(mike_davis.id)
        end

        it { expect(projection.projection).to eq 17.8 }
        it { expect(projection.projected_value).to eq 6.8 }
        it { expect(projection.projected_ownership).to eq 46 }
        it { expect(projection.player).to eq mike_davis }
        it { expect(projection.projection_set).to eq projection_set }
      end

      describe 'second row' do
        subject(:projection) do
          Projection.find_by_player_id(aaron_jones.id)
        end

        it { expect(projection.projection).to eq 20.8 }
        it { expect(projection.projected_value).to eq 3.7 }
        it { expect(projection.projected_ownership).to eq 28 }
        it { expect(projection.player).to eq aaron_jones }
        it { expect(projection.projection_set).to eq projection_set }
      end
    end

    describe 'idempotency' do
      let(:tmp_filepath2) { './tmp/etr_projections_updated.csv' }

      before do
        described_class.new(gameweek).import_csv(tmp_filepath)

        File.open(tmp_filepath2, 'w') do |f|
          f << "\"Player\",\"Team\",\"Opponent\",\"DK Position\",\"DK Salary\",\"DK Projection\",\"DK Value\",\"DK Ownership\",\"DKSlateID\"\n"
          f << "\"Mike Davis\",\"CAR\",\"TB\",\"RB\",\"$4000\",\"21.5\",\"7.1\",\"53%\",\"15751496\"\n"
          f << "\"Aaron Jones\",\"GB\",\"JAX\",\"RB\",\"$7100\",\"20.1\",\"3.5\",\"22%\",\"15751412\"\n"
        end
      end

      it 'is idempotent wrt projection sets' do
        expect {
          described_class.new(gameweek).import_csv(tmp_filepath2)
        }.not_to change(ProjectionSet, :count).from(1)
      end

      it 'is idempotent wrt projections' do
        expect {
          described_class.new(gameweek).import_csv(tmp_filepath2)
        }.not_to change(Projection, :count).from(2)
      end

      describe 'updating existing records' do
        before do
          described_class.new(gameweek).import_csv(tmp_filepath2)
        end

        let(:projection_set) { ProjectionSet.last }

        describe 'first row' do
          subject(:projection) do
            Projection.find_by_player_id(mike_davis.id)
          end

          it { expect(projection.projection).to eq 21.5 }
          it { expect(projection.projected_value).to eq 7.1 }
          it { expect(projection.projected_ownership).to eq 53 }
          it { expect(projection.player).to eq mike_davis }
          it { expect(projection.projection_set).to eq projection_set }
        end

        describe 'second row' do
          subject(:projection) do
            Projection.find_by_player_id(aaron_jones.id)
          end

          it { expect(projection.projection).to eq 20.1 }
          it { expect(projection.projected_value).to eq 3.5 }
          it { expect(projection.projected_ownership).to eq 22 }
          it { expect(projection.player).to eq aaron_jones }
          it { expect(projection.projection_set).to eq projection_set }
        end
      end
    end
  end
end
