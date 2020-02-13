var stbType= Authentication.CTCGetConfig("STBType");
var goIndexVal;
document.onkeypress = doKeyPress;

function custom_load_page(){
    init_focus();
    clearBackParam();
}
function hidVolumeBar(){
    document.getElementById("dialogue_div").style.display="none";
}

function commonKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0101) {                      
        //_window.top.remoteChannelPlus();
	   return false;
    } else if (keycode == 0x0102) {
       // _window.top.remoteChannelMinus();
	   return false;
    } else if (keycode == 0x0110) {
       // Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008) {
		clearBackParam();
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        _window.top.doKeyPress(evt);
    }
}

function cateKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown       
	  	cateKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        // cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        // cateKeyRight();
    } else if (keyCode == 0x000D) {  //OK	
		cateKeyOK();
    } else {
		clearBackParam();
        _window.top.mainWin.commonKeyPress(evt);
        return true;
    }
    return false;
}

//TV按键方法
function doKeyPress(evt) {
    var keycode = evt.which;
	//g_o.debug.print_log("keycode:"+keycode);
    if (keycode == 0x0025) {
        // cateKeyLeft();
    } else if (keycode == 0x0027) {
        // cateKeyRight();
    } else if (keycode == 0x000D) {
		cateKeyOK();
    } else if (keycode == 0x0026) {
        cateKeyUp();
    } else if (keycode == 0x0028) {
         cateKeyDown();
    } else {
        commonKeyPress(evt);
    }
    return false;
}

function init_focus(){
    goIndexVal = _window.top.mainWin.top.jsGetControl("index");
    if(goIndexVal==undefined||goIndexVal==""){
        goIndexVal = 0;
    }
    onFocus();
}

function cateKeyUp() {
    onBlur();
    goIndexVal--;
    if(goIndexVal<0){
        goIndexVal = 0;
    }
    onFocus();
}

function cateKeyDown() {
    onBlur();
    goIndexVal++;
    if(goIndexVal>2){
        goIndexVal = 2;
    }
    onFocus();
}

function onFocus() {
    if($("alert_focus_0").style.visibility == "visible"){
        return;
    }
    $("list_0_"+goIndexVal).style.visibility = "visible";
}

function onBlur() {
    if($("alert_focus_0").style.visibility == "visible"){
        return;
    }
    $("list_0_"+goIndexVal).style.visibility = "hidden";
}

function cateKeyOK(){
	setBackParam();
	switch (goIndexVal){
        case 0:
            if(isZTEBW == true){
                _window.top.mainWin.document.location = "./vod_portal_pre.jsp?columnid=16&topicindex=00&columnname=HIFI影院";
            }else{
                _window.top.mainWin.document.location = "./vod_portal.jsp?columnid=16&topicindex=00&columnname=HIFI影院";
            }
            break;
        case 1:
            top.mainWin.document.location = "channel_play.jsp?mixno=040";
            break;
        case 2:
            top.mainWin.document.location = "channel_play.jsp?mixno=401";
            break;
    }
}

function setBackParam() {
    _window.top.mainWin.top.jsSetControl("index",goIndexVal);
}

function clearBackParam(){
	 _window.top.mainWin.top.jsSetControl("index",null);
}

function $(id) {
    if(id!=undefined){
        return document.getElementById(id);
    }
}