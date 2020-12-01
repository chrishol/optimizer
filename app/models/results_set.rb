class ResultsSet < ApplicationRecord
  SLATE_TYPES = %w(cash gpp)

  belongs_to :gameweek
  has_many :player_results

  validates_presence_of :slate_name
  validates_inclusion_of :slate_type, in: SLATE_TYPES
end
