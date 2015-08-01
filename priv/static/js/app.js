var ws;
(function($) {
	$.sanitize = function(input) {
		var output = input.replace(/<script[^>]*?>.*?<\/script>/gi, '').
					 replace(/<[\/\!]*?[^<>]*?>/gi, '').
					 replace(/<style[^>]*?>.*?<\/style>/gi, '').
					 replace(/<![\s\S]*?--[ \t\n\r]*>/gi, '');
	    return output;
	};
})(jQuery);

$(document).ready(init);

function init() {
    $("#server").val(location.origin.replace('http','ws') + "/websocket")

    if(!("WebSocket" in window)){
        $('#status').append('<p><span style="color: red;">WebSocket is not supported.</span></p>');
        $("#ws_condition").hide();
    } else {
        $('#status').append('<p><span style="color: green;">WebSocket is supported.</span></p>');
        connect();
    }
    $("#connected").hide();
    $("#content").hide();
}

function connect()
{
    var wsHost = $("#server").val()

    ws = new WebSocket(wsHost);
    ws.onopen = function(evt) { onOpen(evt) };
    ws.onclose = function(evt) { onClose(evt) };
    ws.onmessage = function(evt) { onMessage(evt) };
    ws.onerror = function(evt) { onError(evt) };
    showScreen('<b>Connecting to: ' +  wsHost + '</b>');

    $("#connect_btn").text("Disconnect");
}

function disconnect() {
    ws.close();
    $("#connect_btn").text("Connect");
}

function toggle_connection(){
    if(ws.readyState == ws.OPEN){
        disconnect();
    } else {
        connect();
    }
}

function sendText() {
    if(ws.readyState == ws.OPEN){
        var msg = $("#send_text").val();
        ws.send(msg);
        showScreen('sending: ' + $.sanitize(msg));
    } else {
         showScreen('websocket is not connected');
    }
}

function onOpen(evt) {
    showScreen('<span style="color: green;">CONNECTED </span>');
    $("#connected").fadeIn('slow');
    $("#content").fadeIn('slow');
}

function onClose(evt) {
    $("#connect_btn").text("Connect");
    showScreen('<span style="color: red;">DISCONNECTED </span>');
}

function onMessage(evt) {
    showScreen('<span style="color: blue;">RESPONSE: ' + $.sanitize(evt.data) + '</span>');
}

function onError(evt){
  showScreen('<span style="color: red;">There is an error with your WebSocket.</span>');
}

function showScreen(txt) {
    $('#output').prepend('<p>' + txt + '</p>');
}

function clearScreen()
{
    $('#output').html("");
}
