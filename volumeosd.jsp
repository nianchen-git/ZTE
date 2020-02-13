<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<html>
<head>
    <script language="javascript">
        var $$=[];
        function $(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        var volume = 0;
        var volumeBarCount = 0;
        var disableWithTimer = "";

        function pageDisableWithTimer() {
            top.jsClearKeyFunction();
            top.jsHideOSD();
        }

        function pageVolumeOnKeyPressed() {
            pageDisableWithTimer();
        }

        function showAudioChannelName() {
            var track = top.jsGetCurrentAudioChannel();
           // alert("SSSSSSSSSSSSSSSSSSSSSSshowAudioChannelName_track11="+track);
            if (track == "Left") {
                $("trackL").style.visibility = "visible";
                $("trackR").style.visibility = "hidden";
                $("trackS").style.visibility = "hidden";
            } else if (track == "Right") {
                $("trackR").style.visibility = "visible";
                $("trackL").style.visibility = "hidden";
                $("trackS").style.visibility = "hidden";
            } else if (track == "Stereo") {
                $("trackR").style.visibility = "hidden";
                $("trackL").style.visibility = "hidden";
                $("trackS").style.visibility = "visible";
            }  else if (track == "JointStereo") {
               // alert("SSSSSSSSSSSSSSSSSSSSSSyingcang!!");
                $("trackR").style.visibility = "hidden";
                $("trackL").style.visibility = "hidden";
                $("trackS").style.visibility = "hidden";
            }
//            else {
//                top.jsDoChangeTrack();
//                alert("SSSSSSSSSSSSSSSSSSSSSSshowAudioChannelName_track1="+top.jsGetCurrentAudioChannel());
//                alert("SSSSSSSSSSSSSSSSSSSSSSshowAudioChannelName_trackR_trackS="+$("trackR").style.visibility+"_"+$("trackS").style.visibility);
//                if ($("trackR").style.visibility == "visible") {
//                    $("trackR").style.visibility = "hidden";
//                    $("trackL").style.visibility = "hidden";
//                    $("trackS").style.visibility = "visible";
//                } else if ($("trackS").style.visibility == "visible") {
//                    if(window.navigator.appName.indexOf("ztebw")>=0){
//                        alert("SSSSSSSSSSSSSSSSSright");
//                        $("trackR").style.visibility = "visible";
//                        $("trackL").style.visibility = "hidden";
//                        $("trackS").style.visibility = "hidden";
//                    }else{
//                        alert("SSSSSSSSSSSSSSSSSleft");
//                        $("trackR").style.visibility = "hidden";
//                        $("trackL").style.visibility = "visible";
//                        $("trackS").style.visibility = "hidden";
//                    }
//                }
//            }
        }

        function pageAudioChannel() {
          //  alert("SSSSSSSSSSSSSSSSSSSSSSpageAudioChannel");
            top.resetOSDInfoTimer();
            top.jsDoChangeTrack();
            showAudioChannelName();
        }

        function vitur() {
            top.virtualEvent();
        }

        function pageInitAudioChannel() {
            top.resetOSDInfoTimer();
            showAudioChannelName();
        }

/*
        function pageVolumePlus() {
            pageRight();
        }

        function pageVolumeMinus() {
            pageLeft();
        }
*/
        function pageLeft() {
            top.resetOSDInfoTimer();
            if (volume > 0) {
                volume = volume - 5;
                volumeBarCount = parseInt(volume / 5);
                top.jsSetVolume(volume);
				$("tem").innerHTML=volumeBarCount;
                $("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
                $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
            }
            var vol = parseInt(top.jsGetVolume());
            if (vol == 0) {
                top.doSetMuteState(1);
                top.jsHideOSD();
                top.showMuteOSD();
            }
            if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 6000);
        }

        function pageRight() {
            top.resetOSDInfoTimer();
            if (volume < 100) {
                volume = volume + 5;
                volumeBarCount = parseInt(volume / 5);
                top.jsSetVolume(volume);
                var tem = volumeBarCount - 1;
				$("tem").innerHTML=volumeBarCount;
                $("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
                $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
            }
             if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 6000);
        }

        function refreshVolumeBar() {
			volumeBarCount = parseInt(volume / 5);
			$("tem").innerHTML=volumeBarCount;
            $("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
            $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
        }

        function pageMute() {
            top.jsHideOSD();
            var muteState = top.doGetMuteState();
            var vol = parseInt(top.jsGetVolume());
            if (muteState == 0) {
                top.doSetMuteState(1);
                top.showMuteOSD();
            } else if (vol != 0) {
                top.doSetMuteState(0);
                top.showVolumeOSD();
            }
            if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 6000);
        }
		
		function doOK(){
			doJump();
		}

		function pageResume() {
          _window.top.mainWin.document.location = "portal.jsp";
        }
        function pageInit() {
            volume = top.jsGetVolume();
            volumeBarCount = parseInt(volume / 5);
            
            top.jsSetupKeyFunction("top.mainWin.pageVolumePlus", 0x0103);
            top.jsSetupKeyFunction("top.mainWin.pageVolumeMinus", 0x0104);
            top.jsSetupKeyFunction("top.mainWin.pageLeft", 0x0025);
            top.jsSetupKeyFunction("top.mainWin.pageRight", 0x0027);
            top.jsSetupKeyFunction("top.mainWin.pageVolumeOnKeyPressed", "onKeyPressed");
            top.jsSetupKeyFunction("top.mainWin.pageAudioChannel", 0x0106);
			top.jsSetupKeyFunction("top.mainWin.pageAudioChannel", 286);
            top.jsSetupKeyFunction("top.mainWin.pageMute", 0x0105);
            top.jsSetupKeyFunction("top.mainWin.vitur", 0x0300);
			top.jsSetupKeyFunction("top.mainWin.doOK",0x000D);//OK键
            refreshVolumeBar();
            pageInitAudioChannel();
	    
	    	top.jsSetupKeyFunction("top.mainWin.pageResume",0x0110);
            top.jsSetupKeyFunction("top.mainWin.pageResume", 36);
			
			
           
        }
		function downKeyPress(evt){
			var keyCode = parseInt(evt.which);
			if(keyCode == 0x0025 || keyCode == 0x0104)//pageLeft
			{       
				pageLeft();
			} 
			else if(keyCode == 0x0027 || keyCode == 0x0103)//pageRight
			{  
				pageRight();
			}else  if (keyCode ==  0x0110  || keyCode == 36) {  
	        		pageResume();
          		} else{
				top.doKeyPress(evt);
				return true;  
			}
			return false;
		}
		
		 disableWithTimer = setTimeout("pageDisableWithTimer();", 6000);
               //document.onkeypress = top.doKeyPress;
		document.onkeypress = downKeyPress;
        focus();
    </script>
</head>

<body bgcolor="transparent" onLoad="pageInit()">
<div style="left:30px;top:540px;position:absolute">
    <img src="images/sounds/soundBg3.png" alt="" width="1220" height="130"/>
</div>
<div style="left:330px; top:589px; visibility:hidden; position:absolute;" id="trackR">
    <img src="images/sounds/soundRight_all3.png" alt="" />
</div>

<div style="left:330px; top:589px; visibility:hidden; position:absolute;" id="trackL">
    <img src="images/sounds/soundLeft_all3.png" alt="" />
</div>

<div style="left:330px; top:589px; visibility:hidden; position:absolute;" id="trackS">
    <img src="images/sounds/soundStereo_all3.png" alt="" />
</div>
<div style="left:399px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF" id="tem"></div>
<div style="left:927px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF">20</div>
<!--?§????§?é??§??-->
<div style="left:460px; top:604px;width:0px;height:3px; position:absolute;">
    <img id="speedBarDiv" src="images/sounds/soundwhite9.png" width="0" height="3" alt="">
</div>
<div id="icon" style="left:460px; top:599px;width:20px;height:12px; position:absolute; ">
    <img src="images/sounds/soundwhite1.png" alt="" width="20" height="12" border="0">
</div>
<!--1???-->
<div  style="position:absolute; width:220px; height:110px; left:40px; top: 546px;border:4px solid red;"> <%--音量广告位图片边框--%>
    <img src="" id="advert_pic0" alt="" width="220" height="110" border="0">
</div>
<div  style="position:absolute; width:220px; height:110px; left:1020px; top: 550px;">
    <img src="" id="advert_pic1" alt="" width="220" height="110" border="0">
</div>
</body>
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
				top.doStop();     //音量条广告图片点击的跳转
				top.mainWin.document.location = advert_pic_jump[j].url;
				return;
			}
		}
	}
</script>
</html>
