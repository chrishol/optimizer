class AddDkIdToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :dk_id, :integer, null: false
  end
end
