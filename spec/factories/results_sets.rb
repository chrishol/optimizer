FactoryBot.define do
  factory :results_set do
    gameweek
    slate_name { 'DraftKings $50 Red Zone' }
    slate_type { 'gpp' }
  end
end
