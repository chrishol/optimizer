class AddDkCeilingToProjections < ActiveRecord::Migration[6.0]
  def change
    add_column :projections, :projected_ceiling, :decimal, precision: 5, scale: 2, default: 0
  end
end
