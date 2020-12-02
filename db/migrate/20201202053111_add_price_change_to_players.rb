class AddPriceChangeToPlayers < ActiveRecord::Migration[6.0]
  def change
    add_column :players, :previous_price, :integer, null: true
  end
end
