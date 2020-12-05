class EnteredLineup < ApplicationRecord
  include DraftKingsLineupMethods

  belongs_to :results_set
  has_and_belongs_to_many :players

  validates_presence_of :slate_rank, :entry_name
end
