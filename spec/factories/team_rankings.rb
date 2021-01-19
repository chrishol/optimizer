FactoryBot.define do
  factory :team_ranking do
    gameweek
    team_name { 'hou' }
    off_dvoa_rank { 1 }
    off_pass_dvoa_rank { 1 }
    off_rush_dvoa_rank { 1 }
    def_dvoa_rank { 1 }
    def_pass_dvoa_rank { 1 }
    def_rush_dvoa_rank { 1 }
    etr_ol_rank { 1 }
    etr_dl_rank { 1 }
  end
end
