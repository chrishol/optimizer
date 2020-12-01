class CreateResultsSets < ActiveRecord::Migration[6.0]
  def up
    create_enum :slate_type, %w(cash gpp)

    create_table :results_sets do |t|
      t.references :gameweek, null: false, foreign_key: true
      t.string :slate_name, null: false
      t.column :slate_type, :slate_type, null: false

      t.timestamps
    end
  end

  def down
    drop_table :results_sets
    drop_enum :slate_type
  end
end
