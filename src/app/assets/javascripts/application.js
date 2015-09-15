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
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

// get the id of the product
function getHrefId(href) {
    var id = "";
    var start = 0;
    for (var i = href.length - 1; i >= 0; i--) {
        if (href.charAt(i) === "/") {
            start = i;
            break;
        }
    }
    start++;
    id = href.substring(start, href.length);
    return parseInt(id);
}

$(function() {
    // buy the product at once
    $('#buynow').click( function(){
        var href = window.location.href;
        product_id = getHrefId(href);
        var amount =document.getElementById("purchase_quantity");
        if(amount.value > amount.max) {
            alert("the purchased number cannot exceed the stock!")
        }
        else {
            window.location.href='/orders/new?productId='+product_id+'&amount='+amount.value;
        }

    });

    // put the product in the cart
    $('#putcart').click( function(){
        var href = window.location.href;
        product_id = getHrefId(href);
        var amount = document.getElementById("purchase_quantity");
        if(amount.value > amount.max){
            alert("the purchased number cannot exceed the stock!")
        }
        else {
            window.location.href = '/cart_products/new?productId='+product_id+'&amount='+amount.value;
        }
    });
});