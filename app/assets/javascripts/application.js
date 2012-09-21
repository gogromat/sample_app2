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
//= require bootstrap
//= require_tree .

$(document).ready(function(){

    $('textarea#micropost_content').keyup(function(){
        var span = $('span#micropost_length');
        if (span.length > 0) {
            var self   = $(this);
            var length = self.val().length;
            var text   = (140 - self.val().length)+" characters left";

            span.html(text);

            if (length > 140) {
                span.css('color','red');
            }
            else {
                span.css('color','green');
            }
        }
    }).trigger('keyup');

});