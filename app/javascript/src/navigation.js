import $ from 'jquery';

function toggleGameweekOptionsPanel() {
  $('#gameweek-options-panel').toggleClass('hidden');
};

$(document).on('turbolinks:load', function() {
  $('button#gameweek-options-menu').on('click', function() {
    toggleGameweekOptionsPanel();
  });
});
