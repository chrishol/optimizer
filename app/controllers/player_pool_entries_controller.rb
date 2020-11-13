class PlayerPoolEntriesController < ApplicationController
  def create
    @entry = PlayerPoolEntry.where(
      player_pool_id: player_pool_entry_params[:player_pool_id],
      player_id: player_pool_entry_params[:player_id]
    ).first_or_create

    respond_to do |format|
      format.html { redirect_back(fallback_location: gameweeks_path) }
      format.js {
        PlayerPoolChannel.broadcast_to(
          @entry.player_pool,
          player_id: @entry.player_id,
          entry: render_created_entry(@entry)
        )
        head :ok
      }
    end
  end

  def update
    @entry = PlayerPoolEntry.find(params[:id])
    @entry.update_attributes(player_pool_entry_params)

    respond_to do |format|
      format.html { redirect_back(fallback_location: gameweeks_path) }
      format.js {
        PlayerPoolChannel.broadcast_to(
          @entry.player_pool,
          player_id: @entry.player_id,
          entry: render_created_entry(@entry)
        )
        head :ok
      }
    end
  end

  def destroy
    @entry = PlayerPoolEntry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_back(fallback_location: gameweeks_path) }
      format.js {
        PlayerPoolChannel.broadcast_to(
          @entry.player_pool,
          player_id: @entry.player_id,
          entry: render_deleted_entry(@entry)
        )
        head :ok
      }
    end
  end

  def destroy_all
    @player_pool = PlayerPool.find(params[:player_pool_id])
    @player_pool.player_pool_entries.destroy_all
    redirect_back(fallback_location: gameweeks_path)
  end

  private

  def player_pool_entry_params
    params.require(:player_pool_entry).permit(:player_pool_id, :player_id, :is_locked)
  end

  def render_created_entry(entry)
    render(partial: 'players/remove_from_pool', locals: { entry: entry })
  end

  def render_deleted_entry(entry)
    render(partial: 'players/add_to_pool', locals: { entry: entry })
  end
end
