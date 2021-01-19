class TeamRanking < ApplicationRecord
  RANKING_COLUMNS = %i(
    off_dvoa_rank
    off_pass_dvoa_rank
    off_rush_dvoa_rank
    def_dvoa_rank
    def_pass_dvoa_rank
    def_rush_dvoa_rank
    etr_ol_rank
    etr_dl_rank
  )

  belongs_to :gameweek

  RANKING_COLUMNS.each do |column|
    validates column, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 32
    }, allow_nil: true
  end
end
