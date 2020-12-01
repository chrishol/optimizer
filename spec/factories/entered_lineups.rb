FactoryBot.define do
  factory :entered_lineup do
    results_set
    slate_rank { 1 }
    entry_name { 'clhol' }
    points { 150.01 }
  end
end
