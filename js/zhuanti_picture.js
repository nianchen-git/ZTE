function custom_load_page(){
	init_focus();
	clearBackParam();
}


document.onkeypress = doKeyPress;

function commonKeyPress(evt) {
	alert("123");
    var keycode = evt.which;
    if (keycode == 0x0101) {                      
       // _window.top.remoteChannelPlus();
	   return false;
    } else if (keycode == 0x0102) {
        // _window.top.remoteChannelMinus();
	   return false;
    } else if (keycode == 0x0110) {
         Authentication.CTCSetConfig("KeyValue", "0x110");
         _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008) {
		clearBackParam();
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        _window.top.doKeyPress(evt);
    }
}


//TV°´¼ü·½·¨
/*function doKeyPress(evt) {
    var keycode = evt.which;
	//g_o.debug.print_log("keycode:"+keycode);
    if (keycode == 0x0025) {// onKeyLeft
        
    } else if (keycode == 0x0027) {// onKeyRight
        
    } else if (keycode == 0x000D) {//onKeyOK
       
    } else if (keycode == 0x0026) {//onKeyUp
      
    } else if (keycode == 0x0028) {//onKeyDown
      
    } else if(keycode == 265) {// remoteFastRewind
            return true;
    } else if(keycode == 264) {// remoteFastForword
            return true;
    } else if(keycode == 263) {// RmotePlayPause
            return true;
    } else if(keycode == 270) {// remoteStop
           return true;
    } else if(keycode == 0x0022) {// remotePlayNext
           return true;
    } else if(keycode == 0x0021) {// remotePlayLast
            return true;
    }else if (keycode == 0x0110) {
         Authentication.CTCSetConfig("KeyValue", "0x110");
         _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008) {
		clearBackParam();
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        _window.top.doKeyPress(evt);
    }
    return false;
}
*/

function doKeyPress(evt) {
    var keycode = evt.which;
	//g_o.debug.print_log("keycode:"+keycode);
   
   if (keycode == 0x0110) {
         Authentication.CTCSetConfig("KeyValue", "0x110");
         _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008) {
		clearBackParam();
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        return true;
    }
    return false;
}



function init_focus(){
	
}

function setBackParam() {
	 	
}

function clearBackParam(){
	 
}