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
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

// get the id of the product
var href = window.location.href;
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
        var amount =document.getElementById("cart_product_quantity");
        if(amount.value > amount.max) {
            alert("the purchased number cannot exceed the stock!")
        }
        else {
            window.location.href='../orders/new?product='+getHrefId(href)+'&amount='+amount.value;
        }

    });

    // put the product in the cart
    $('#putcart').click( function(){
        var amount = document.getElementById("amount");
        if(amount.value > amount.max){
            alert("the purchased number cannot exceed the stock!")
        }
        else {
            window.location.href = '../cart_products/new?product='+getHrefId(href)+'&amount='+amount.value;
        }
    });
});