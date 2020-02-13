<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="max-age=7200" />
<%--<meta name="page-view-size" content="1280*720"> --%>
<link href="css/index.css" rel="stylesheet" type="text/css">
<link href="css/default_style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="js/base.js"></script>
<script type="text/javascript" src="js/game_webkit.js"></script>
<script> 
var url_return='';
var login__='0';
 
if(login__==1)
	_loginTotal();
var isevent=0;
function grabEvent(){
	var key_code=event.which;
   // alert("SSSSSSSSSSSSSSSkey_code="+key_code);
	if (isevent==0)
     switch(key_code){
	   case 8:
	   isevent=1;
	    exit_();
	   isevent=0;
	      break;
	 } 
}
function exit_() {
	/*window.location.href = "http://61.135.88.132:33200/EPG/jsp/defaultbjds/en/Category.jsp?vas_info=%3Cvas_action%3Eback%3C%2Fvas_action%3E"*/;
   // alert("SSSSSSSSSSSSSSSSSSexit_url_return="+url_return);
    url_return = Authentication.CTCGetConfig('EPGDomain');
	window.location.href = url_return;
}
document.onkeypress=function(){return grabEvent};
document.onsystemevent=function(){return grabEvent};
document.onirkeypress=function(){return grabEvent};
document.onkeypress=grabEvent;
document.onsystemevent=grabEvent;
document.onirkeypress=grabEvent;
 
</script>
<script type="text/javascript" src="js/base.js"></script>
</head>
<body  onload="ad_show();init('l1'); bgcolor='#FFFFFF' ">
<div class="header"></div>
 
<div class="divm1">
<!---�ϰ벿��-->
<div class="m1content_index" id="m1content">
 
   
   <table>
<tr ><td valign='top' id='main_left'> 
<a href='active_index.php'  id='board_a'  onFocus="fb('board_');"  onBlur="fb_('board_')" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_hot.png' id='board_' class="board"  border="0"/>
</a>
</td>
<td valign='top'  id='main_right'> 
<div>
<a href='games.php?act=getGametype&type=game'  id='l1' onFocus="ff(1);" onBlur="ff_(1);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_gamefolder.png' class='Type' style="border-style:none;" id='1' /></a>
<a href='gamesinfo.php?act=getNewonline&Name=newonline'  id='l2' onFocus="ff(2);" onBlur="ff_(2);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_newgame.png' class='Type' style="border-style:none;" id='2' /></a>
<a href='ranklist.php'  id='l3' onFocus="ff(3);" onBlur="ff_(3);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_gamerank.png' class='Type' style="border-style:none;" id='3' /></a>
<a href='userinfo.php'  id='l4' onFocus="ff(4);" onBlur="ff_(4);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_userinf.png' class='Type' style="border-style:none;" id='4' /></a>
<a href='help.php'  id='l5' onFocus="ff(5);" onBlur="ff_(5);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_help.png' class='Type' style="border-style:none;" id='5' /></a>
<a href=''  id='l6' onFocus="ff(6);" onBlur="ff_(6);" style="border-style:none;"><img src='http://61.135.89.201/gamemanager_webkit/upload/button_quit.png' class='Type' style="border-style:none;" id='6' /></a</div>
</td></tr></table>
 </div>
</div>
<!---�°벿��-->
<div class="divm2">
<div class="m2content" id="m2content"><img src='media_webkit/activities_hot/banner01.jpg' id="banner"/></div>
</div>
</body>
</html>
