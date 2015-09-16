// This is a manifest file that"ll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin"s vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It"s not advisable to add code directly here, but if you do, it"ll appear at the bottom of the
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

function checkTranslation() {
  startTimer();
  $("#review_form").submit(function(e) {
    e.preventDefault();
    var sendRequest = $.post("/reviews", $("#review_form").serialize(), null, "json");
    return sendRequest.done(function(data) {
      if (data.state == "wrong") {
        $("#notice_panel").empty().append($("<div />").
          attr("class", "alert alert-info").append(data.message));
      } else {
        $("#notice_panel").empty().append($("<div />").
          attr("class", "alert alert-info").append(data.message));
        $.getScript("/reviews/new.js");
      }
    });
  });
}

$(function(){
  checkTranslation();
});
$(document).ajaxComplete(function (){
  $("#review_form").off("submit");
  checkTranslation();
});
