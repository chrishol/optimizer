require "rails_helper"

describe GameOddsDataImporter do
  describe "import" do
    let(:gameweek) { create(:gameweek) }

    let(:home_team1) { 'lar' }
    let(:road_team1) { 'ne' }
    let(:home_team2) { 'buf' }
    let(:road_team2) { 'pit' }

    let!(:game1) do
      create(
        :scheduled_game,
        gameweek: gameweek,
        home_team: home_team1,
        road_team: road_team1,
        start_time: "2020-12-11 01:20:00 UTC"
      )
    end
    let!(:game2) do
      create(
        :scheduled_game,
        gameweek: gameweek,
        home_team: home_team2,
        road_team: road_team2,
        start_time: "2020-12-13 18:00:00 UTC"
      )
    end

    let(:adapter_instance) { instance_double(OddsApiAdapter) }

    let(:lar_ne_start_time) { 1607649600 }
    let(:buf_pit_start_time) { 1607908800 }

    let(:adapted_response) do
      [{
        home_team: 'Los Angeles Rams',
        road_team: 'New England Patriots',
        start_time: lar_ne_start_time,
        lines: [
          {
            site_name: 'DraftKings',
            game_total: 44.5,
            home_spread: -5.0,
            home_total: 24.75,
            road_total: 19.75
          }, {
            site_name: 'BetOnline.ag',
            game_total: 45.0,
            home_spread: -5.0,
            home_total: 25.0,
            road_total: 20.0
          }
        ]
      }, {
        home_team: 'Buffalo Bills',
        road_team: 'Pittsburgh Steelers',
        start_time: buf_pit_start_time,
        lines: [
          {
            site_name: 'William Hill (US)',
            game_total: 46.5,
            home_spread: -2.5,
            home_total: 24.5,
            road_total: 22.0
          }, {
            site_name: 'FanDuel',
            game_total: 47.0,
            home_spread: -2.5,
            home_total: 24.75,
            road_total: 22.25
          }
        ]
      }]
    end

    before do
      allow(OddsApiAdapter).to receive(:new).and_return(adapter_instance)
      allow(adapter_instance).to receive(:get_totals_and_spreads).and_return(
        adapted_response
      )
    end

    context 'when all game details match' do
      it 'creates game line rows for each line' do
        expect {
          described_class.new.import
        }.to change(GameLine, :count).from(0).to(4)
      end

      describe 'imported fields' do
        describe 'first row' do
          subject(:game_line) do
            described_class.new.import
            game1.game_lines.find_by_site_name('DraftKings')
          end

          it { expect(game_line.game_total).to eq(44.5) }
          it { expect(game_line.home_spread).to eq(-5.0) }
          it { expect(game_line.home_total).to eq(24.75) }
          it { expect(game_line.road_total).to eq(19.75) }
        end

        describe 'second row' do
          subject(:game_line) do
            described_class.new.import
            game1.game_lines.find_by_site_name('BetOnline.ag')
          end

          it { expect(game_line.game_total).to eq(45.0) }
          it { expect(game_line.home_spread).to eq(-5.0) }
          it { expect(game_line.home_total).to eq(25.0) }
          it { expect(game_line.road_total).to eq(20.0) }
        end

        describe 'third row' do
          subject(:game_line) do
            described_class.new.import
            game2.game_lines.find_by_site_name('William Hill (US)')
          end

          it { expect(game_line.game_total).to eq(46.5) }
          it { expect(game_line.home_spread).to eq(-2.5) }
          it { expect(game_line.home_total).to eq(24.5) }
          it { expect(game_line.road_total).to eq(22.0) }
        end

        describe 'fourth row' do
          subject(:game_line) do
            described_class.new.import
            game2.game_lines.find_by_site_name('FanDuel')
          end

          it { expect(game_line.game_total).to eq(47.0) }
          it { expect(game_line.home_spread).to eq(-2.5) }
          it { expect(game_line.home_total).to eq(24.75) }
          it { expect(game_line.road_total).to eq(22.25) }
        end
      end

      describe 'idempotency' do
        context 'when values stay the same' do
          before do
            described_class.new.import
          end

          it 'is idempotent' do
            expect {
              described_class.new.import
            }.not_to change(GameLine, :count).from(4)
          end
        end

        context 'when values have changed' do
          let(:updated_adapted_response) do
            [{
              home_team: 'Los Angeles Rams',
              road_team: 'New England Patriots',
              start_time: lar_ne_start_time,
              lines: [
                {
                  site_name: 'DraftKings',
                  game_total: 54.5,
                  home_spread: -5.0,
                  home_total: 29.75,
                  road_total: 24.75
                }
              ]
            }]
          end

          before do
            allow(adapter_instance).to receive(:get_totals_and_spreads).and_return(
              adapted_response, updated_adapted_response
            )
            described_class.new.import
          end

          it 'is idempotent' do
            expect {
              described_class.new.import
            }.not_to change(GameLine, :count).from(4)
          end

          describe 'updated values' do
            subject(:game_line) do
              described_class.new.import
              game1.game_lines.find_by_site_name('DraftKings')
            end

            it { expect(game_line.game_total).to eq(54.5) }
            it { expect(game_line.home_spread).to eq(-5.0) }
            it { expect(game_line.home_total).to eq(29.75) }
            it { expect(game_line.road_total).to eq(24.75) }
          end
        end
      end
    end

    context 'when the game time does not match' do
      let(:lar_ne_start_time) { 1607649600 + 604800 }
      let(:buf_pit_start_time) { 1607908800 - 604800 }

      it 'does not create game lines' do
        expect {
          described_class.new.import
        }.not_to change(GameLine, :count).from(0)
      end
    end

    context 'when the game participants do not match' do
      let(:road_team1) { 'ari' }
      let(:home_team2) { 'kc' }

      it 'does not create game lines' do
        expect {
          described_class.new.import
        }.not_to change(GameLine, :count).from(0)
      end
    end
  end
end
