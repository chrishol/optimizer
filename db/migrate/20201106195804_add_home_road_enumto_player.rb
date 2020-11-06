class AddHomeRoadEnumtoPlayer < ActiveRecord::Migration[6.0]
  def up
    create_enum :game_venue, %w(home road neutral)
    add_column :players, :game_venue, :game_venue, null: false, default: :neutral
  end

  def down
    remove_column :players, :game_venue
    drop_enum :game_venue
  end
end
