class CreateProjectionSets < ActiveRecord::Migration[6.0]
  def change
    create_table :projection_sets do |t|
      t.references :gameweek, null: false, foreign_key: true
      t.string :source, null: false

      t.timestamps
    end
  end
end
