FactoryBot.define do
  factory :game_line do
    scheduled_game
    site_name { 'DraftKings' }
    home_total { 28.5 }
    road_total { 21.5 }
    game_total { 50.0 }
    home_spread { 7.0 }
  end
end
