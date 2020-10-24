FactoryBot.define do
  factory :player do
    gameweek
    name { 'Davante Adams' }
    team  { 'GB' }
    opponent { 'HOU' }
    price { 8_000 }
    position { 'WR' }
  end
end
