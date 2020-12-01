FactoryBot.define do
  factory :player_result do
    results_set
    player
    ownership { 11.5 }
    points { 22.5 }
  end
end
