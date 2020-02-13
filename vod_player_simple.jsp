<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.text.*" %>

<%
String inverse_time = request.getParameter("inverse_time");
//String contentCode = "00000000000000020130708135007740";
String contentCode =request.getParameter("global_code");
String playUrl =request.getParameter("playUrl");
String programTypea = "";
String columnCodea="";
String programCode="";
String terminalflag = "1";
String definition = "1";
String authidsession="";
String mediaUrl="";
JSONObject obj = new JSONObject();
int flag =0; 
String results = "";
StringBuffer sb = new StringBuffer();
%>
<ex:params var="input">
<ex:param name="telecomcodeavailable" value="<%=contentCode%>"/>
</ex:params>
<ex:search tablename="user_vod_detail" fields="*" inputparams="${input}" pagecount="100"  var="detaillist">
    <%
	List<Map> slist = (List<Map>)pageContext.getAttribute("detaillist");
	if(slist.size()>0){
										for (Map VODS : slist){
										obj.put("programCode",VODS.get("programcode"));
										obj.put("programName",VODS.get("programname"));
										obj.put("columnCode",VODS.get("columncode"));
										obj.put("programType",VODS.get("programtype"));
										programTypea =  (String)VODS.get("programtype");
										columnCodea = (String)VODS.get("columncode");
										programCode = (String)VODS.get("programcode");
										}
	}else{
		flag=1;
		results ="1";//未找到节目数据
	}																
    %>
</ex:search>
<%
if(flag==0){
%>
	<ex:params var="authParams">
	   <ex:param name="contenttype"    value="<%=programTypea%>"/>
	   <ex:param name="columncode"   value="<%=columnCodea%>"/>
	   <ex:param name="programcode"  value="<%=programCode%>"/>
	   <ex:param name="terminalflag"   value="<%=terminalflag%>"/>
	   <ex:param name="definition"     value="<%=definition%>"/>
	</ex:params>
	<ex:action name="auth"  inputparams="${authParams}"  var="authMap">
	
	<%
	 JSONArray authArr = new JSONArray();
	 Map authResult = (Map) pageContext.getAttribute("authMap");
    flag = Integer.parseInt(authResult.get("_flag").toString());
				if(flag == 0){//auth success
					JSONObject authObj = new JSONObject();
					Vector vodData = (Vector) authResult.get("data");
					Map productInfo = (HashMap) vodData.get(0);
					authidsession = (String)productInfo.get("AuthorizationID");
				}else{
				 flag = 1;
				 results =  String.valueOf (flag);
				}
					%>
	</ex:action>
	<%
}
		if(0==flag){
	%>
		 <ex:params var="inputPlayParams">
					<ex:param name="authidsession"  value="<%=authidsession%>"/>
				  <ex:param name="programcode"  value="<%=programCode%>"/>
				</ex:params>
				<ex:action name="vod_play" inputparams="${inputPlayParams}" var="playMap">
						<%
				Map result = (Map) pageContext.getAttribute ("playMap");
				String playurl = String.valueOf (result.get("playurl"));
				obj.put("mediaUrl",playurl);
				results = playurl;
						%>
				</ex:action>
<%	
		}
%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312"/>
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="expires" content="0"/>
    <title>test player</title>
<script language="javascript">
var obj_stb= new MediaPlayer();
var play_url="<%=playUrl%>";
play_url=decodeURI(decodeURI(play_url));
play_url=play_url.replace(/@/g,"&");
var resulta= "<%=results%>";
var contentcodea ="<%=contentCode%>";
var inverse_time ="<%=inverse_time%>";
var volume = 0;
var volumeBarCount = 0;
var disableWithTimer = "";
volume = obj_stb.getVolume();
volumeBarCount = parseInt(volume / 5);

//window.onunload=exit_page();

 function doNothing(){
            return false;
        }
function load_page()
{
	//var mediaStr="{mediaUrl:\"rtsp://202.106.212.246:554/vod/00000050280000209582.mpg?userid=10-00000000019-01&stbip=10.186.130.193&clienttype=1&mediaid=0000000030010000158478&ifcharge=1&time=20140527160243+08&life=172800&usersessionid=1215&vcdnid=001&boid=001&srcboid=001&columnid=0A02&backupagent=202.106.212.246:554&ctype=1&playtype=0&Drm=0&EpgId=null&programid=00000050280000209582&contname=&fathercont=&bp=0&authid=25504687&tscnt=0&tstm=0&tsflow=0&ifpricereqsnd=1&stbid=6F00010000131510000030F31D97C3F3&nodelevel=3&terminalflag=1&usercharge=FC37AABF6727E7A3001F6F285BC3341A\",mediaCode:\"00000001000000010000000015584053\",mediaType:2,audioType:1,videoType:1,streamType:1,drmType:1,fingerPrint:0,copyProtection:1,allowTrickmode:1,startTime:0,endTime:100.3,entryID:\"entry1\"}";
	var mediaStr= "{mediaUrl:\""+resulta+"\",mediaCode:\""+contentcodea+"\",mediaType:2,audioType:1,videoType:1,streamType:1,drmType:1,fingerPrint:0,copyProtection:1,allowTrickmode:1,startTime:0,endTime:100.3,entryID:\"entry1\"}";	
    
	obj_stb.stop();
	obj_stb.leaveChannel();
    var media_instance_id = obj_stb.getNativePlayerInstanceID();
    obj_stb.setSingleOrPlaylistMode(0);
    obj_stb.setSingleMedia(mediaStr);
    obj_stb.setVideoDisplayMode(1);       
    obj_stb.setAllowTrickmodeFlag(0);
    //obj_stb.setProgressBarUIFlag(1);
	//document.getElementById("TEST").innerHTML = "W3444444444444ss4444";
    obj_stb.playFromStart();
	setInterval("show_inverse_time()",1000);
    //obj_stb.playByTime(1, 3, 2);
    obj_stb.refreshVideoDisplay();
	//document.getElementById("TEST").innerHTML =document.location.href ;
	//play_url = document.location.href ;
    document.onkeydown = on_key_down;

	//refreshVolumeBar();
    //pageInitAudioChannel();
	//setTimeout('go_next_page()',15000);
}

function go_next_page(){

//if (play_url.indexOf("=") != -1){
	//var m = play_url.indexOf("=")+1;
	//var str = play_url.substr(m);
	//document.getElementById("TEST").innerHTML =str;
	
	exit_page();
	document.location =play_url;
//}
}

function show_inverse_time(){
	document.getElementById("inversetime").innerHTML=inverse_time;
    if(inverse_time==0){
        document.getElementById("inversetime").innerHTML="";
    }else{
        inverse_time--;
    }
}
function on_key_down(evt)
{
  var obj_event = evt?evt:event;
  var key_code = obj_event.keyCode ? obj_event.keyCode : obj_event.which;
  if(key_code == 768)
  {
    goUtility();
  }else if(key_code== 0x0103)
  {
	  pageVolumePlus();
  }else if(key_code== 0x0104)
  {
	  pageVolumeMinus();
  }else if(key_code== 0x0025)
  {
	  pageLeft();
  }else if(key_code== 0x0027)
  {
	  pageRight();
  }else if(key_code== 0x0106)
  {
	  pageAudioChannel();
  }else if(key_code== 0x0105)
  {
	  pageMute();
  }else if (key_code == 0x0008) {
	  if($("volumeosd").style.visibility=="visible"){
				pageDisableWithTimer();  
	}

  }else if(key_code == 0x0110 || key_code==272){
  	/*if("CTCSetConfig" in Authentication)
        {
            //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
            Authentication.CTCSetConfig("KeyValue","0x110");
        }else{
            //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
            Authentication.CUSetConfig("KeyValue","0x110");
        }
	*/
  }
   return false;
}
// 接收机顶盒下发的事件
function goUtility() {
        eval("eventJson = " + Utility.getEvent());
       // document.getElementById("TEST").innerHTML =eventJson;
        var typeStr = eventJson.type;
        switch (typeStr) {
                case "EVENT_MEDIA_ERROR":
                        var type = eventJson.error_code;
                        if (101 == type || 10 == type) {
                        }
                        return 0;
                case "EVENT_PLAYMODE_CHANGE":
                        return 0;
                case "EVENT_MEDIA_END":
                        finishedPlay();
                        return 0;
                case "EVENT_MEDIA_BEGINING":
                        return 0;
                case "EVENT_TVMS":
                        return 0;
                case "EVENT_TVMS_ERROR":
                        return 0;
                default:
                        return 0;
        }
        return true;
}
function finishedPlay() {
        
        go_next_page();
}

function exit_page()
{
    obj_stb.stop();
}
function $(str)
{
    return document.getElementById(""+str);
}
        function $(id) {
            if (id!=null) {
                
                return document.getElementById(id);
            }
        }


        function infoTimer(){
			$("volumeosd").style.visibility="visible";
			$("speedBarDiv").style.visibility = 'visible';
				$("icon").style.visibility = 'visible';
		}
		function pageDisableWithTimer() {
            $("volumeosd").style.visibility="hidden";
			$("speedBarDiv").style.visibility = 'hidden';
				$("icon").style.visibility = 'hidden';
				 $("trackL").style.visibility = "hidden";
                $("trackR").style.visibility = "hidden";
                $("trackS").style.visibility = "hidden";
				$("trackM").style.visibility = "hidden";
        }

        function showAudioChannelName() {
            //var track = top.jsGetCurrentAudioChannel();
			var track = obj_stb.getCurrentAudioChannel();
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
                $("trackR").style.visibility = "hidden";
                $("trackL").style.visibility = "hidden";
                $("trackS").style.visibility = "hidden";
            }
        }

        function pageAudioChannel() {
            infoTimer();
            //top.jsDoChangeTrack();
			obj_stb.switchAudioChannel();
            showAudioChannelName();
			refreshVolumeBar();
			 if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 3000);
        }

        function pageInitAudioChannel() {
            //infoTimer();
            showAudioChannelName();
        }


        function pageVolumePlus() {
            pageRight();
        }

        function pageVolumeMinus() {
            pageLeft();
        }

        function pageLeft() {
            infoTimer();
			showAudioChannelName();
			var muteState = obj_stb.getMuteFlag();
            if (muteState == 1) {
				refreshVolumeBar();
				showAudioChannelName();
            }
			
            if (volume > 0) {
                volume = volume - 5;
                volumeBarCount = parseInt(volume / 5);
                obj_stb.setVolume(volume);
				$("tem").innerHTML=volumeBarCount;
                //$("volumeDiv"+volumeBarCount).style.visibility = 'hidden';
				$("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
                $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
            }
            var vol = parseInt(obj_stb.getVolume());
            if (vol == 0) {
                obj_stb.setMuteFlag(1);
				clearVolumeBar();
            }
            if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 3000);
        }

        function pageRight() {
            infoTimer();
			showAudioChannelName();
			var muteState = obj_stb.getMuteFlag();
            if (muteState == 1) {
				refreshVolumeBar();
				showAudioChannelName();
            }
            if (volume < 100) {
                volume = volume + 5;
                volumeBarCount = parseInt(volume / 5);
                obj_stb.setVolume(volume);
				$("tem").innerHTML=volumeBarCount;
				//var tem = volumeBarCount - 1;
                //$("volumeDiv"+tem).style.visibility = 'visible';
				$("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
                $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
            }
             if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 3000);
        }

        function clearVolumeBar() {
			volumeBarCount = parseInt(volume / 5);
			if(volumeBarCount>0){
				volumeBarCount=0;
				$("tem").innerHTML=volumeBarCount;
			}
          //  for (var i = 0; i < 19; i++) {
                //$("volumeDiv"+i).style.visibility = 'hidden';
				$("speedBarDiv").style.visibility = 'hidden';
				$("icon").style.visibility = 'hidden';
            //}
			$("trackR").style.visibility = "hidden";
            $("trackL").style.visibility = "hidden";
            $("trackS").style.visibility = "hidden";
			$("trackM").style.visibility = "visible";
        }
		function refreshVolumeBar() {
			volume = obj_stb.getVolume()
			volumeBarCount = parseInt(volume / 5);
			$("tem").innerHTML=volumeBarCount;
			$("speedBarDiv").style.width=parseInt(413/20*volumeBarCount,10);
            $("icon").style.left=parseInt(460+413/20*volumeBarCount,10);
          //  for (var i = 0; i <= volumeBarCount; i++) {
                //$("volumeDiv"+i).style.visibility = 'visible';
				$("speedBarDiv").style.visibility = 'visible';
				$("icon").style.visibility = 'visible';
           // }
			$("trackM").style.visibility = "hidden";
        }

        function pageMute() {
			infoTimer();
            var muteState = obj_stb.getMuteFlag();
            var vol = parseInt(obj_stb.getVolume());
            if (muteState == 0) {
                obj_stb.setMuteFlag(1);
                clearVolumeBar();
            } else if (muteState == 1) {
                obj_stb.setMuteFlag(0);                
				refreshVolumeBar();
				showAudioChannelName();
            }
            if (disableWithTimer) {
                clearTimeout(disableWithTimer);
            }
            disableWithTimer = setTimeout("pageDisableWithTimer();", 3000);
        }
		
    </script>
</head>
<body  onLoad="load_page();"    bgcolor="transparent">
<div id="TEST" style="position:absolute; width:200px; height:100px; left:200px; top:200px; color:#FF0000"></div>
<div id="inversetime" style="position: absolute; width: 50px; height: 50px; left: 1195px; top: 40px; color:#FFF; font-size:48px" ></div>
<div id="volumeosd" style="visibility:hidden; position:absolute" >
<div style="left:30px;top:540px;position:absolute">
    <img src="images/sounds/soundBg3.png" alt="" width="1220" height="130"/>
</div>

<div style="left:330px; top:589px; visibility:hidden; position:absolute" id="trackR">
    <img src="images/sounds/soundRight_all3.png" alt=""  />
</div>
<div style="left:330px; top:589px; visibility:hidden; position:absolute" id="trackL">
    <img src="images/sounds/soundLeft_all3.png" alt=""  />
</div>

<div style="left:330px; top:589px; visibility:hidden; position:absolute" id="trackS">
    <img src="images/sounds/soundStereo_all3.png" alt="" />
</div>
<div style="left:330px; top:589px; visibility:hidden; position:absolute" id="trackM">
    <img src="images/sounds/soundStereo_all4.png" alt="" />
</div>
<div style="left:399px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF" id="tem"></div>
<div style="left:927px; top:596px;width:40px;height:40px; position:absolute;font-size:25px; color:#FFFFFF">20</div>

<div style="left:460px; top:604px;width:0px;height:3px; position:absolute;">
    <img id="speedBarDiv" src="images/sounds/soundwhite9.png" width="0" height="3" alt="">
</div>
<div id="icon" style="left:460px; top:599px;width:20px;height:12px; position:absolute; ">
    <img src="images/sounds/soundwhite1.png" alt="" width="20" height="12" border="0">
</div>
<div  style="position:absolute; width:220px; height:110px; left:40px; top: 550px; visibility:hidden;">
    <img src="" id="advert_pic0" alt="" width="220" height="110" border="0">
</div>
<div  style="position:absolute; width:220px; height:110px; left:1020px; top: 550px;visibility:hidden;">
    <img src="" id="advert_pic1" alt="" width="220" height="110" border="0">
</div>
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
					$("advert_pic1").src = "images/advert/"+ advert_pic[i].picName;
					break;
				}
			}
		}
	</script>
</html>
