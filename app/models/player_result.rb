class PlayerResult < ApplicationRecord
  belongs_to :results_set
  belongs_to :player
end
