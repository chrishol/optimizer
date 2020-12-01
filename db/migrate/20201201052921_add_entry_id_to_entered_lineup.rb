class AddEntryIdToEnteredLineup < ActiveRecord::Migration[6.0]
  def change
    add_column :entered_lineups, :entry_id, :string, null: false
  end
end
