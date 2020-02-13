<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>

<html>
<body bgcolor = "transparent" onload = "pageInit()">
<div style="left:30px;top:540px;position:absolute">
    <img src="images/sounds/soundBg3.png" alt="" width="1220" height="130"/>
</div>
<div style="left:399px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF">0</div>
<div style="left:927px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF">20</div>
<div style="left:330px; top:589px;position:absolute;" id="trackJ">
    <img src="images/sounds/soundStereo_all4.png" alt="" />
</div>
    <!--1???-->
    <div  style="position:absolute; width:220px; height:110px; left:40px; top: 546px; border:4px solid red;">
        <%--静音页的广告图片--%>
        <img src="" id="advert_pic0" alt="" width="220" height="110" border="0">
    </div>
    <div  style="position:absolute; width:220px; height:110px; left:1020px; top: 550px;">
        <img src="" id="advert_pic1" alt="" width="220" height="110" border="0">
    </div>
</body>
<script language="javascript">

function pageDisableWithTimer()
{
	  top.jsClearKeyFunction();
		top.jsHideOSD();
}

function pageVolumeOnKeyPressed()
{
	  pageDisableWithTimer();
}

function vitur()
{
	top.virtualEvent();
}

function doOK(){
		doJump();
	}
function showVolume() {
		top.doSetMuteState(0);
		top.mainWin.document.location = "volumeosd.jsp";
		top.showOSD(2, 0, 0);
		top.setBwAlpha(0);
	}	
function onkeypress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode ==  0x0110  || keyCode == 36) {  
		pageResume();
    } else {
        top.doKeyPress(evt);
        return true;
    }
    return false;
}
function pageInit()
{
	top.jsSetupKeyFunction("top.mainWin.pageMute", 0x0105);
	top.jsSetupKeyFunction("top.mainWin.showVolume", 261);
	top.jsSetupKeyFunction("top.mainWin.pageVolumePlus", 0x0103);
  	top.jsSetupKeyFunction("top.mainWin.pageVolumeMinus", 0x0104);
	top.jsSetupKeyFunction("top.mainWin.pageVolumeMinus", 0x0025);//left
    top.jsSetupKeyFunction("top.mainWin.pageVolumePlus", 0x0027);//right
  	top.jsSetupKeyFunction("top.mainWin.pageVolumeOnKeyPressed", "onKeyPressed");
  	top.jsSetupKeyFunction("top.mainWin.vitur", 0x0300);
  	top.jsSetupKeyFunction("top.mainWin.doOK", 0x000D);//OK?ü
	top.jsSetupKeyFunction("top.mainWin.pageResume", 0x0110);
    top.jsSetupKeyFunction("top.mainWin.pageResume", 36);
	 document.onkeypress = onkeypress;
}
  
   function pageResume() {
        top.mainWin.document.location = "portal.jsp?onlymenu=1";
    }
		
function pageVolumePlus()
{
	top.jsHideOSD();
  top.remoteVolumePlus();
}

function pageVolumeMinus()
{
  //var muteFlag = top.mp.getMuteFlag();
  var muteFlag = top.doGetMuteState();
  //var volume = top.mp.getVolume();
  var volume = top.jsGetVolume();
  if(muteFlag == 1 && volume == 0)
  {
  	return;
  }
  top.jsHideOSD();
  top.remoteVolumeMinus();
}

function pageMute()
{
  //var muteFlag = top.mp.getMuteFlag();
  var muteFlag = top.doGetMuteState();
  if(muteFlag == 1)
  {
  	   //var vol = parseInt(top.mp.getVolume());
  	   var vol = top.jsGetVolume();
  	   if(vol == 0)
  	   {
  	   	  top.jsHideOSD();
  	   }
  	   else
  	   {
       //top.mp.setMuteFlag(0);
       top.doSetMuteState(0);
       top.jsHideOSD();
       top.showVolumeOSD();

      }
  }
  else if(muteFlag == 0)
  {
       top.jsHideOSD();
  }
}
document.onkeypress = top.doKeyPress;

function pageDisableWithTimer() {
    top.jsClearKeyFunction();
    top.jsHideOSD();
}

disableWithTimer = setTimeout("pageDisableWithTimer();", 6000);
focus();
</script>
<script type="text/javascript" src="js/advertisement_manager.js"></script>
<script type="text/javascript" >
function $(id){
    return document.getElementById(id);
}
if(play_flag_pic==0){
    for(var i=0;i<advert_pic.length;i++){
        if(advert_pic[i].areaName=="volume"){
        $("advert_pic0").src = "images/advert/"+ advert_pic[i].picName;
        $("advert_pic1").src = "images/advert/"+ advert_pic[i].picName1;
        break;
        }
    }
}
function doJump(){
		for(var j=0;j<advert_pic_jump.length;j++){
			if(advert_pic_jump[j].name=="live6"){
				top.doStop();     //静音页点击广告图片OK的跳转
				top.mainWin.document.location = advert_pic_jump[j].url;
				return;
			}
		}
	}
</script>
</html>
