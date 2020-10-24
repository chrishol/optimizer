class ChangePlayerColumnsToEnums < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    create_enum :nfl_team, %w(
      ari atl bal buf car chi cin cle dal den det gb hou ind jax kc lac lar
      lv mia min ne no nyg nyj phi pit sea sf tb ten was
    )
    create_enum :player_position, %w(qb rb wr te dst)

    remove_column :players, :team
    remove_column :players, :opponent
    remove_column :players, :position

    add_column :players, :team, :nfl_team
    add_column :players, :opponent, :nfl_team
    add_column :players, :position, :player_position
  end

  def down
    remove_column :players, :team
    remove_column :players, :opponent
    remove_column :players, :position

    drop_enum :nfl_team
    drop_enum :player_position

    add_column :players, :team, :string
    add_column :players, :opponent, :string
    add_column :players, :position, :string
  end
end
