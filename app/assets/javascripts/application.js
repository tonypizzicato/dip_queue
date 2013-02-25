// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .

(function ($) {
    console.log(10 + '20');
    setInterval(tempStats, 3000);
    chart();
})(jQuery);


/* ---------- Chart ---------- */

function chart() {
    if ($('.verticalChart')) {
        $('.singleBar').each(function () {
            var percent = $(this).find('.value span').html();
            $(this).find('.value').animate({height: percent}, 2000, function () {
                $(this).find('span').fadeIn();
            });
        });
    }
}

function tempStats() {
    var stat = $('.tempStat');
    if (stat) {
        stat.each(function () {
            var temp = Math.floor(Math.random() * (1 + 120));
            $(this).html(temp + '°');
            if (temp < 20) {
                $(this).animate({
                    borderColor: "#67c2ef"
                }, 'fast');
            } else if (temp > 19 && temp < 40) {
                $(this).animate({
                    borderColor: "#CBE968"
                }, 'slow');
            } else if (temp > 39 && temp < 60) {
                $(this).animate({
                    borderColor: "#eae874"
                }, 'slow');
            } else if (temp > 59 && temp < 80) {
                $(this).animate({
                    borderColor: "#fabb3d"
                }, 'slow');
            } else if (temp > 79 && temp < 100) {
                $(this).animate({
                    borderColor: "#fa603d"
                }, 'slow');
            } else {
                $(this).animate({
                    borderColor: "#ff5454"
                }, 'slow');
            }
        });
    }
}