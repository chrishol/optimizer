class PlayerPoolChannel < ApplicationCable::Channel
  def subscribed
    return unless params[:player_pool_id].present?

    player_pool = PlayerPool.find(params[:player_pool_id])
    stream_for player_pool
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
