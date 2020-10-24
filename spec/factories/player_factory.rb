FactoryBot.define do
  factory :player do
    gameweek
    name { 'Davante Adams' }
    team  { 'gb' }
    opponent { 'hou' }
    price { 8_000 }
    position { 'wr' }
  end
end
