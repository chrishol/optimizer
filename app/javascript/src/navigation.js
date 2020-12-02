import $ from 'jquery';

// Gameweek Navigation Menu

function toggleGameweekOptionsPanel() {
  $('#gameweek-options-panel').toggleClass('hidden');
};

$(document).on('turbolinks:load', function() {
  $('button#gameweek-options-menu').on('click', function() {
    toggleGameweekOptionsPanel();
  });
});

// Results Set Navigation Menu

function toggleResultsSetOptionsPanel() {
  $('#results-set-options-panel').toggleClass('hidden');
};

$(document).on('turbolinks:load', function() {
  $('button#results-set-options-menu').on('click', function() {
    toggleResultsSetOptionsPanel();
  });
});
