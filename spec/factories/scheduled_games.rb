FactoryBot.define do
  factory :scheduled_game do
    gameweek
    start_time { "2020-11-04 21:16:25 UTC" }
    home_team { "hou" }
    road_team { "gb" }
  end
end
