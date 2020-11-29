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
        if (data.reset_results) {
          $('#lineups').html('');
        }

        if (data.player_id) {
          var selector = 'tr[data-player-id="player-pool-entry-form-'.concat(data.player_id).concat('"');
          $(selector).html(data.player_row);
        } else if (data.lineup) {
          $('#lineups').append(data.lineup);
        } else if (data.status_message) {
          $('#status-message').html(data.status_message);
        }
      }
    })
  }
});
