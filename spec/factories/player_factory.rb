FactoryBot.define do
  factory :player do
    gameweek
    dk_id { 15642452 }
    name { 'Davante Adams' }
    team  { 'gb' }
    opponent { 'hou' }
    price { 7_900 }
    position { 'wr' }
  end
end
