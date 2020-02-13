function custom_load_page(){
   	//g_o.debug=new _Debug();
 	//g_o.debug.show_debug();
	//g_o.debug.print_log("init_tv_player_paramsssss");	
	init_focus();
	clearBackParam();
}

var menu_left_urls = new Array();
var menu_right_urls = new Array();

menu_left_urls = [
//声明数组
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234920&programtype=0&programname=xx&vodtype=0&leefocus=href5",
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234918&programtype=0&programname=xx&vodtype=0&leefocus=href5",
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234919&programtype=0&programname=xx&vodtype=0&leefocus=href5",
];
menu_right_urls=[
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234917&programtype=0&programname=xx&vodtype=0&leefocus=href5",		
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234916&programtype=0&programname=xx&vodtype=0&leefocus=href5",
"vod_Playy.jsp?columnid=130C26&programid=0000000030010000234921&programtype=0&programname=xx&vodtype=0&leefocus=href5",
];


document.onkeypress = doKeyPress;

function commonKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0101) {                      
        _window.top.remoteChannelPlus();
    } else if (keycode == 0x0102) {
        _window.top.remoteChannelMinus();
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
	  	cateKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        cateKeyRight();
    } else if (keyCode == 0x000D) {  //OK	
        cateKeyOK();
    } else {
		clearBackParam();
        _window.top.mainWin.commonKeyPress(evt);
        return true;
    }
    return false;
}

//测试用按键方法
/*function doKeyPress(evt) {
   var keycode = evt.which;
	//alert("keycode:"+keycode);
	//g_o.debug.print_log("*******keycode:"+keycode);
   if (keycode == 97) {//左
        cateKeyLeft();
  	} else if (keycode == 115) {//右
        cateKeyRight();
   } else if (keycode == 0) {//确认
        cateKeyOK();
   } else if (keycode == 113) {//上
        cateKeyUp();
   } else if (keycode == 119) {//下
        cateKeyDown();
   } else {
        commonKeyPress(evt);
   }
   return false;
}*/
 
//function doKeyPress(evt) {
//    var keycode = evt.which;
//	//g_o.debug.print_log("keycode:"+keycode);
//    if (keycode == 37) {
//        cateKeyLeft();
//    } else if (keycode == 39) {
//        cateKeyRight();
//    } else if (keycode == 13) {
//        cateKeyOK();
//    } else if (keycode == 38) {
//        cateKeyUp();
//    } else if (keycode == 40) {
//         cateKeyDown();
//    } else {
//        commonKeyPress(evt);
//    }
//    return false;
//}

//TV按键方法
function doKeyPress(evt) {
    var keycode = evt.which;
	//g_o.debug.print_log("keycode:"+keycode);
    if (keycode == 0x0025) {
        cateKeyLeft();
    } else if (keycode == 0x0027) {
        cateKeyRight();
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

var left_length=3;
var right_length=3;

//var focus_left=0;
var focus_left=_window.top.mainWin.top.jsGetControl("focus_left");
if(focus_left=="undefined"|| focus_left=="" || focus_left==null ||focus_left=="null" ){
	focus_left=0;
}


//var focus_right=0;
var focus_right=_window.top.mainWin.top.jsGetControl("focus_right");
if(focus_right=="undefined"|| focus_right=="" || focus_right==null ||focus_right=="null" ){
	focus_right=0;
}

//var focus_left_flag=0;
var focus_left_flag=_window.top.mainWin.top.jsGetControl("focus_left_flag");
if(focus_left_flag=="undefined"|| focus_left_flag=="" || focus_left_flag==null ||focus_left_flag=="null" ){
	focus_left_flag=0;
}


//var focus_right_flag=0;
var focus_right_flag=_window.top.mainWin.top.jsGetControl("focus_right_flag");
if(focus_right_flag=="undefined"|| focus_right_flag=="" || focus_right_flag==null ||focus_right_flag=="null" ){
	focus_right_flag=0;
}


focus_left=parseInt(focus_left,10);
focus_left_flag=parseInt(focus_left_flag,10);
focus_right=parseInt(focus_right,10);
focus_right_flag=parseInt(focus_right_flag,10);

function init_focus(){
	if(focus_left_flag==0 && focus_right_flag==0)focus_left_flag=1;
	if(focus_left_flag==1){
		change_focus_left();
	}else if(focus_right_flag==1){
		change_focus_right();
}
}

function change_blur_left(){
	focus_left_flag=0;
	document.getElementById("left_bg_"+focus_left).style.border="0px solid red";
	//document.getElementById("left_bg_"+focus_left).style.visibility="hidden";
}
function change_blur_right(){
	focus_right_flag=0;
	document.getElementById("right_bg_"+focus_right).style.border="0px solid red";
	//document.getElementById("right_bg_"+focus_right).style.visibility="hidden";
}
function change_focus_left(){
	focus_left_flag=1;
	document.getElementById("left_bg_"+focus_left).style.border="4px solid red";
	//document.getElementById("left_bg_"+focus_left).style.visibility="visible";
}
function change_focus_right(){
	focus_right_flag=1;
	document.getElementById("right_bg_"+focus_right).style.border="4px solid red";
    //document.getElementById("right_bg_"+focus_right).style.visibility="visible";
}

//上
function cateKeyUp(){
 	if(focus_left_flag==1){
		change_blur_left();	
		focus_left--;
		if(focus_left<0){
			focus_left=left_length-1;
		}
		change_focus_left();
	}else if(focus_right_flag==1){
		change_blur_right();	
		focus_right--;
		if(focus_right<0){
			focus_right=right_length-1;
		}
		change_focus_right();
	}
}

function cateKeyDown(){
	if(focus_left_flag==1){
		change_blur_left();
		focus_left++;
		if(focus_left>=left_length){
			focus_left=0;
		}
		change_focus_left();
	}else if(focus_right_flag==1){
		change_blur_right();
		focus_right++;
		if(focus_right>=right_length){
			focus_right=0;
		}
		change_focus_right();
	}	
}
function cateKeyLeft(){
	if(focus_right_flag==1){
		change_blur_right();
		focus_left=focus_right;
		change_focus_left();
	}else{
	}
}
function cateKeyRight(){
	if(focus_left_flag==1){
		change_blur_left();
		focus_right=focus_left;
	   change_focus_right();
	}else{
	}
}

/*function cateKeyOK(){
	setBackParam();
	if(focus_left_flag==1){
   		document.location =menu_left_urls[focus_left] ;
	}
	if(focus_right_flag==1){
		_window.top.mainWin.document.location = encodeURI(encodeURI(menu_right_urls[focus_right]));
	}
}*/

function setBackParam() {
	if(focus_left_flag==1){
		_window.top.mainWin.top.jsSetControl("focus_left",focus_left);
		_window.top.mainWin.top.jsSetControl("focus_left_flag",focus_left_flag);
	}else if(focus_right_flag==1){
		_window.top.mainWin.top.jsSetControl("focus_right",focus_right);
		_window.top.mainWin.top.jsSetControl("focus_right_flag",focus_right_flag);
	}
 	//alert("setBackParam====="+ _window.top.mainWin.top.jsGetControl("focus_left",focus_left));
}

function clearBackParam(){
	 _window.top.mainWin.top.jsSetControl("focus_left",null);
	 _window.top.mainWin.top.jsSetControl("focus_right",null);
	 _window.top.mainWin.top.jsSetControl("focus_left_flag",null);
	 _window.top.mainWin.top.jsSetControl("focus_right_flag",null);	 	
	// alert("clearBackParam====="+ _window.top.mainWin.top.jsGetControl("focus_left",focus_left));
}