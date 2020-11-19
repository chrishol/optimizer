FactoryBot.define do
  factory :projection do
    projection_set
    player
    projection { 22.6 }
    projected_value { 6.5 }
    projected_ownership { 11 }
  end
end
