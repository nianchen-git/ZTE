function custom_load_page(){
	init_focus();
	clearBackParam();
}

var menu_left_urls = new Array();
var menu_right_urls = new Array();
var stbType= Authentication.CTCGetConfig("STBType");

menu_left_urls = [
"./vod_portal.jsp?columnid=16&topicindex=00&columnname=HIFI影院",//链接到点播--HIFI影院--4K体验（第一个）

];

menu_right_urls =["",];//弹出提示


document.onkeypress = doKeyPress;

function commonKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0101) {                      
        //_window.top.remoteChannelPlus();
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

function cateKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown       
	  	//cateKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        //cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        //cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        //cateKeyRight();
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
        //cateKeyLeft();
    } else if (keycode == 0x0027) {
        //cateKeyRight();
    } else if (keycode == 0x000D) {
		
		cateKeyOK();

    } else if (keycode == 0x0026) {
        //cateKeyUp();
    } else if (keycode == 0x0028) {
         //cateKeyDown();
    } else {
        commonKeyPress(evt);
    }
    return false;
}

var left_length=1;
var right_length=1;

//var focus_left=0;
var focus_left=_window.top.mainWin.top.jsGetControl("focus_left");
if(focus_left=="undefined"|| focus_left=="" || focus_left==null ||focus_left=="null" ){
	focus_left=0;
}

//var focus_left_flag=0;
var focus_left_flag=_window.top.mainWin.top.jsGetControl("focus_left_flag");
if(focus_left_flag=="undefined"|| focus_left_flag=="" || focus_left_flag==null ||focus_left_flag=="null" ){
	focus_left_flag=0;
}


focus_left=parseInt(focus_left,10);
focus_left_flag=parseInt(focus_left_flag,10);

function init_focus(){
	if(focus_left_flag==0)focus_left_flag=1;
	if(focus_left_flag==1){
		change_focus_left();
	}
}

function change_blur_left(){
	focus_left_flag=0;
	document.getElementById("left_bg_"+focus_left).style.visibility="hidden";
}
function change_focus_left(){
	focus_left_flag=1;
	document.getElementById("left_bg_"+focus_left).style.visibility="visible";
}
/*function change_blur_right(){
document.getElementById("right_bg_"+focus_left).style.visibility="hidden";
}

function change_focus_right(){
 document.getElementById("right_bg_"+focus_left).style.visibility="visible";
}*/


function cateKeyLeft(){
	if(document.getElementById("alert_focus_0").style.visibility == "visible"){
		return;
	}
 if(focus_right_flag==1){
  focus_right_flag=0;
  focus_left_flag=1;
  change_blur_right();
//  focus_left=focus_right;
  change_focus_left();
 }
}

function cateKeyRight(){
	if(document.getElementById("alert_focus_0").style.visibility == "visible"){
		return;
	}
 if(focus_left_flag==1){
  focus_left_flag=0;
  focus_right_flag=1;
  change_blur_left();
//  focus_right=focus_left;
  change_focus_right();
 }
}

function cateKeyOK(){
	setBackParam();
	if(focus_left_flag==1){	
		if(isZTEBW == true){
			 _window.top.mainWin.document.location = "./vod_portal_pre.jsp?columnid=1C&topicindex=02&columnname=付费高清";
		}else{
			_window.top.mainWin.document.location = "./vod_portal.jsp?columnid=1C&topicindex=02&columnname=付费高清";
		}
	}

}

function setBackParam() {
	if(focus_left_flag==1){
	    _window.top.mainWin.top.jsSetControl("focus_left",focus_left);
	    _window.top.mainWin.top.jsSetControl("focus_left_flag",focus_left_flag);
	}	
 	//alert("setBackParam====="+ _window.top.mainWin.top.jsGetControl("focus_left",focus_left));
}

function clearBackParam(){
	 _window.top.mainWin.top.jsSetControl("focus_left",null);
	 _window.top.mainWin.top.jsSetControl("focus_left_flag",null);	
	// alert("clearBackParam====="+ _window.top.mainWin.top.jsGetControl("focus_left",focus_left));
}