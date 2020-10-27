class PlayerPoolEntriesController < ApplicationController
  def create
    @entry = PlayerPoolEntry.where(
      player_pool_id: player_pool_entry_params[:player_pool_id],
      player_id: player_pool_entry_params[:player_id]
    ).first_or_create

    respond_to do |format|
      format.html { redirect_back(fallback_location: gameweeks_path) }
      format.js
    end
  end

  def destroy
    @entry = PlayerPoolEntry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: gameweeks_path) }
      format.js
    end
  end

  private

  def player_pool_entry_params
    params.require(:player_pool_entry).permit(:player_pool_id, :player_id)
  end
end
