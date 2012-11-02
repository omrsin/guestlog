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
//= require jquery.webcam
//= require_tree .

var pos = 0;
var ctx = null;
var cam = null;
var image = null;

var filter_on = false;
var filter_id = 0;

function changeFilter() {
    if (filter_on) {
        filter_id = (filter_id + 1) & 7;
    }
}

function capture_image(){
    webcam.capture();
    changeFilter();
    void(0);
    var canvas = document.getElementById('canvas');
    var context = canvas.getContext("2d");
    var img     = canvas.toDataURL("image/png");
    var item_image = img.replace(/^data:image\/(png|jpg);base64,/, "") ;
    $('#visit_image_code').val(item_image);
}

function toggleFilter(obj) {
    if (filter_on =!filter_on) {
        obj.parentNode.style.borderColor = "#c00";
    } else {
        obj.parentNode.style.borderColor = "#333";
    }
}

$(document).ready(function(){
	$("#webcam").webcam({

    width: 320,
    height: 240,
    mode: "callback",
    swffile: "/assets/jscam_canvas_only.swf",

    onTick: function(remain) {

        if (0 == remain) {
            jQuery("#status").text("Cheese!");
        } else {
            jQuery("#status").text(remain + " seconds remaining...");
        }
    },

    onSave: function(data) {

        var col = data.split(";");
        var img = image;

				for(var i = 0; i < 320; i++) {
            var tmp = parseInt(col[i]);
            img.data[pos + 0] = (tmp >> 16) & 0xff;
            img.data[pos + 1] = (tmp >> 8) & 0xff;
            img.data[pos + 2] = tmp & 0xff;
            img.data[pos + 3] = 0xff;
            pos+= 4;
        }
        
        if (pos >= 0x4B000) {
            ctx.putImageData(img, 0, 0);
            pos = 0;
        }

    },

    onCapture: function () {
        webcam.save('/product_capture');

        jQuery("#flash").css("display", "block");
        jQuery("#flash").fadeOut(100, function () {
            jQuery("#flash").css("opacity", 1);
        });

    },

    debug: function (type, string) {
        jQuery("#status").html(type + ": " + string);
    },

    onLoad: function () {

        var cams = webcam.getCameraList();
        for(var i in cams) {
            jQuery("#cams").append("<li>" + cams[i] + "</li>");
        }
    }
	});
	
	$("#capture").on("click", function(e) {
		capture_image();
	});
		
});

function getPageSize() {

    var xScroll, yScroll;

    if (window.innerHeight && window.scrollMaxY) {
        xScroll = window.innerWidth + window.scrollMaxX;
        yScroll = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
        xScroll = document.body.scrollWidth;
        yScroll = document.body.scrollHeight;
    } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
        xScroll = document.body.offsetWidth;
        yScroll = document.body.offsetHeight;
    }

    var windowWidth, windowHeight;

    if (self.innerHeight) { // all except Explorer
        if(document.documentElement.clientWidth){
            windowWidth = document.documentElement.clientWidth;
        } else {
            windowWidth = self.innerWidth;
        }
        windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
        windowWidth = document.documentElement.clientWidth;
        windowHeight = document.documentElement.clientHeight;
    } else if (document.body) { // other Explorers
        windowWidth = document.body.clientWidth;
        windowHeight = document.body.clientHeight;
    }

    // for small pages with total height less then height of the viewport
    if(yScroll < windowHeight){
        pageHeight = windowHeight;
    } else {
        pageHeight = yScroll;
    }

    // for small pages with total width less then width of the viewport
    if(xScroll < windowWidth){
        pageWidth = xScroll;
    } else {
        pageWidth = windowWidth;
    }

    return [pageWidth, pageHeight];
}

window.addEventListener("load", function() {

    var canvas = document.getElementById("canvas");

    if (canvas.getContext) {
        ctx = document.getElementById("canvas").getContext("2d");
        ctx.clearRect(0, 0, 320, 240);

        var img = new Image();
        img.src = "/assets/webcam.png";
        img.onload = function() {
            ctx.drawImage(img, 129, 89);
        }
        image = ctx.getImageData(0, 0, 320, 240);
    }

}, false);
