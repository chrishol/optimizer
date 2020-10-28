import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  var playerPoolId = $('#ac-player-pool').attr('data-player-pool-id');

  if (playerPoolId) {
    consumer.subscriptions.create({
      channel: "PlayerPoolChannel",
      player_pool_id: playerPoolId
    }, {
      connected() {
      },

      disconnected() {
      },

      received(data) {
        console.log(data);
        var selector = 'div[data-player-id="player-pool-entry-form-'.concat(data.player_id).concat('"');
        $(selector).html(data.entry);
      }
    })
  }
});
