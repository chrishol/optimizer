class CreateProjections < ActiveRecord::Migration[6.0]
  def change
    create_table :projections do |t|
      t.references :projection_set, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.numeric :projection, precision: 5, scale: 2, default: 0
      t.numeric :projected_value, precision: 5, scale: 2, default: 0
      t.numeric :projected_ownership, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end
