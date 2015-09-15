// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

function startTimer() {
  if (typeof interval !== "undefined") {
    clearInterval(interval);
  }
  seconds = 0;
  interval = setInterval(function() {
    seconds++;
    $("#timer").text(seconds);
    $("#review_answer_time").val(seconds);
  }, 1000);
  $("#timer").text(seconds);
}

$(document).ready(startTimer);
$(document).on('page:load',startTimer);
