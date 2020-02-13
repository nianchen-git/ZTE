<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="java.util.concurrent.Exchanger" %>
<meta name="page-view-size" content="1280*720"/>
<epg:PageController/>
<%!
    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }
%>

<%
    String pushtype = String.valueOf(session.getAttribute("pushportal"));
    if ("1".equals(pushtype)) {
        session.setAttribute("pushportal", "0");
%>
<epg:PageController name="portal_frame.jsp"/>
<%
    }
    try {
        String path = getPath(request.getRequestURI());
        String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
        String columnId = request.getParameter(EpgConstants.COLUMN_ID);
        String preview = "";
	session.setAttribute(EpgConstants.CHANNEL_ID,channelId);//在session中新增channelID
        if (request.getParameter("preview") != null) {
            preview = request.getParameter("preview");
        }
        boolean showChannelInfo = false;
        if (session.getAttribute("channelInfo") != null) {
            showChannelInfo = true;
            session.removeAttribute("channelInfo");
        }

//    System.out.println("+++++++++++++++columnId="+columnId);
//    System.out.println("+++++++++++++++channelId="+channelId);
//    System.out.println("+++++++++++++++control_transit_play="+request.getQueryString());

%>


<html>
<head>
    <title>channel_play.jsp</title>
</head>
<body>
<epg:script/>
        <script type="text/javascript">
top.jsClearVideoKeyFunction();
top.columnid_tv = "<%=columnId%>";
top.channelid_tv = "<%=channelId%>";
var timer = -1;
function doNothing() {
    return false;
}
top.jsSetControl("preMillisecond",60000);
top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.RmotePlayPause%>);
top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastForword%>);
top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastRewind%>);
top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteStop%>);
function pauseFunction() {
    top.jsSetVideoKeyFunction("top.extrWin.showPauseInfo", <%=STBKeysNew.RmotePlayPause%>);
    top.jsSetVideoKeyFunction("top.extrWin.remoteFastForword", <%=STBKeysNew.remoteFastForword%>);
    top.jsSetVideoKeyFunction("top.extrWin.remoteFastRewind", <%=STBKeysNew.remoteFastRewind%>);
    top.jsSetVideoKeyFunction("top.extrWin.channelPlayStop", <%=STBKeysNew.remoteStop%>);
//add wy
    top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.onKeyLeft%>);
    top.jsSetVideoKeyFunction("top.extrWin.showvolumeRight", <%=STBKeysNew.onKeyRight%>);
	
	/*top.jsSetVideoKeyFunction("top.extrWin.showvolumeRight", 0x0103);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", 0x0104);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", 0x0106);*/
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeRight", <%=STBKeysNew.remoteVolumePlus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteVolumeMinus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeMute", <%=STBKeysNew.remoteVolumeMute%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteAudioTrack%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", 286);//九州声道键
}

function showInfo() {
    var reg = /refreshOSD/;
    if (reg.test(top.mainWin.document.location.href)) {
        top.mainWin.document.location = "<%=path%>channel_show_info.jsp?<%=EpgConstants.CHANNEL_ID%>=<%=channelId%>&<%=EpgConstants.COLUMN_ID%>=<%=columnId%>";
        setTimeout(pauseFunction, 200);
    }
}
try {
    top.clearTimeout(top.timerChannel);
} catch (e) {
    // alert("SSSSSSSSSSSSSSSSerror!!!!????");
}

var isFromChannel = top.jsGetControl("isFromChannel");
if (isFromChannel == 1) {
    setTimeout(pauseFunction, 200);
    top.jsSetControl("isFromChannel", "0");
} else {
    top.timerChannel = top.setTimeout("top.extrWin.showInfo();", 200);
}

//top.jsClearVideoKeyFunction();
if (top.OSDInfo.state != 0) {
    top.OSDInfo.state = 0;
}

function showChannelInfo() {
    top.mainWin.document.location = "<%=path%>channel_play_info.jsp?channelid=<%=channelId%>&mixno=" + top.channelInfo.currentChannel;
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}

function showvolumeMute() {
	var muteState = top.doGetMuteState();
	if(muteState == 0){
		top.doSetMuteState(1);
        top.showMuteOSD();
	}else{
		top.doSetMuteState(0);
    	top.mainWin.document.location = "<%=path%>volumeosd.jsp";
    	top.showOSD(2, 0, 0);
     	top.setBwAlpha(0);
	}
}

//volumeosd.jsp add wy
function showvolumeLeft() {
    top.mainWin.document.location = "<%=path%>volumeosd.jsp?type=leftVolume";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}

function showvolumeRight() {
    top.mainWin.document.location = "<%=path%>volumeosd.jsp?type=rightVolume";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}
//volumeosd.jsp add wy

function channelPlayStop() {
    top.jsHideOSD();
//                top.switchToStopOSDUrl(0);
    top.mainWin.document.location = "<%=path%>back.jsp";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
    return false;
}

function gotoPortal() {
    top.jsHideOSD();
    top.mainWin.document.location = "<%=path%>portal.jsp?leefocus=fromchannel";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
    return false;
}

//vod ??频道 通用快退
function remoteFastRewind() {
    var state = top.getStatus();
    var currState = top.currState;
    var speed = 0;
    if (currState == 1 || currState == 7 || currState == 8 || currState == 10 || currState == 3 || currState == 5) {
        if (state == "Normal Play") {
            top.doFastRewind(-2);
        }
    } else if (currState == 2 || currState == 4) {
        var currCh = parseInt(top.channelInfo.currentChannel, 10);
        if (top.channelInfoArr[currCh]) {
            if (top.channelInfoArr[currCh].timeShift == 1 && <%=!"1".equals(preview)%>) {
                speed = -2;
                if (window.navigator.appName == "ztebw") {
                    speed = -speed;
                }
                top.getTSTVTime();
                var TSTVCurrentTimeM = parseInt(top.TSTVCurrentTime.getTime() / 1000);
                var TSTVBeginTimeM = parseInt(top.TSTVBeginTime.getTime() / 1000);
                if (TSTVCurrentTimeM > TSTVBeginTimeM) {
                    top.doFastRewind(speed);
                    top.mainWin.document.location = "<%=path%>livespeedosd.jsp?fast=RR";
                    top.showOSD(2, 0, 0);
                    top.setBwAlpha(0);
                }
            }
        }
    }
}

//vod ??频道 通用快进
function remoteFastForword() {
    var state = top.getStatus();
    var currState = top.currState;
    if (currState == 1 || currState == 7 || currState == 8 || currState == 10 || currState == 3 || currState == 5) {
        if (state == "Normal Play") {
            top.doFastForward(2);
        }
    } else if (currState == 2 || currState == 4) {
        var currCh = parseInt(top.channelInfo.currentChannel, 10);
        if (top.channelInfoArr[currCh]) {
            if (top.channelInfoArr[currCh].timeShift == 1 && <%=!"1".equals(preview)%>) {
                top.getTSTVTime();
                var TSTVCurrentTimeM = parseInt(top.TSTVCurrentTime.getTime() / 1000);
                var TSTVEndTimeM = parseInt(top.TSTVEndTime.getTime() / 1000);
                if (TSTVCurrentTimeM < TSTVEndTimeM) {
                    top.doFastForward(2);
                    top.mainWin.document.location = "<%=path%>livespeedosd.jsp?fast=FF";
                    top.showOSD(2, 0, 0);
                    top.setBwAlpha(0);
                }
            }
        }
    }
}

function showPauseInfo() {
    if ("Normal Play" == top.getStatus()) {
        var currCh = parseInt(top.channelInfo.currentChannel, 10);
        if (top.channelInfoArr[currCh]) {
            if (top.channelInfoArr[currCh].timeShift == 1 && <%=!"1".equals(preview)%>) {
                top.getTSTVTime();
                top.doPause();
                top.mainWin.document.location = "<%=path%>livespeedosd.jsp?fast=pause&channelid=<%=channelId%>";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
            } else {
                return false;
            }
        }

    }
}

<%--var showred = function(){--%>
<%--top.mainWin.document.location = "<%=path%>portal.jsp?onlyred=1";--%>
<%--top.showOSD(2, 0, 0);--%>
<%--}--%>

function onKeyOK() {
	var currCh = parseInt(top.channelInfo.currentChannel, 10);
	/*var del_tv_pro_num = [37,38,39];//屏蔽频道
	var isdel=0;
		 for(var i=0;i<del_tv_pro_num.length;i++){
				if(parseInt(del_tv_pro_num[i],10) == parseInt(currCh,10)){
					isdel =1;
					break;
				}	 
		 }
		 if(isdel == 0){*/	
			top.mainWin.document.location = "<%=path%>channel_mini.jsp";
			top.showOSD(2, 0, 0);
			top.setBwAlpha(0);
		//}	
}
function doNathing() {
}

function playShowInfo() {
    top.mainWin.document.location = "<%=path%>channel_show_info.jsp?<%=EpgConstants.CHANNEL_ID%>=<%=channelId%>&<%=EpgConstants.COLUMN_ID%>=<%=columnId%>&fromplay=1";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}

function showLiveBar() {
    // alert("SSSSSSSSSSSSSSSSSSSSshowLiveBar="+top.getStatus());
    if ("Normal Play" == top.getStatus()) {
        var currCh = parseInt(top.channelInfo.currentChannel, 10);
        if (top.channelInfoArr[currCh] == undefined || top.channelInfoArr[currCh] == null) {
            return false;
        }
        // alert("SSSSSSSSSSSSSSSSSSSStimeShift="+top.channelInfoArr[currCh].timeShift);
        if (top.channelInfoArr[currCh].timeShift == 1 && "<%=preview%>" != "1") {
            top.getTSTVTime();
            var TSTVCurrentTimeM = parseInt(top.TSTVCurrentTime.getTime() / 1000);
            var TSTVBeginTimeM = parseInt(top.TSTVBeginTime.getTime() / 1000);
            //if (TSTVCurrentTimeM > TSTVBeginTimeM)
            //{
            top.mainWin.document.location = "<%=path%>locationbytimeosd.jsp";
            top.showOSD(2, 0, 0);
            //}
        }
    }
    return false;
}

function playLast() {
    if (top.currState == 2) {
        top.getTSTVTime();
        var TSTVCurrentTimeM = parseInt(top.TSTVCurrentTime.getTime() / 1000);
        var TSTVBeginTimeM = parseInt(top.TSTVBeginTime.getTime() / 1000);
        if (TSTVCurrentTimeM > TSTVBeginTimeM) {
            top.doGoToStart();
            if (top.ippvObject.isIPPVChannel(top.channelInfo.currentChannel)) {
                top.jsIPPVLocatePlay(channelInfo.currentChannel);
            }
        }
    } else {
        top.remotePlayLast();
    }
    return false;
}

function playNext() {
    if (top.currState == 2 || top.currState == 5) {
        top.doGoToEnd();
        if (top.ippvObject.isIPPVChannel(top.channelInfo.currentChannel)) {
            top.jsIPPVLocatePlay(top.channelInfo.currentChannel);
        }
    } else {
        top.remotePlayNext();
    }
    return false;
}
<%--top.jsSetVideoKeyFunction("top.extrWin.showred",<%=STBKeysNew.onKeyRed%>);  // onKeyRed    remotePlayLast--%>
top.jsSetVideoKeyFunction("top.extrWin.playLast", <%=STBKeysNew.remotePlayLast%>);
top.jsSetVideoKeyFunction("top.extrWin.playNext", <%=STBKeysNew.remotePlayNext%>);

top.jsSetVideoKeyFunction("top.extrWin.doNathing", <%=STBKeysNew.onKeyLeft%>);
top.jsSetVideoKeyFunction("top.extrWin.doNathing", <%=STBKeysNew.onKeyRight%>);

top.jsSetVideoKeyFunction("top.extrWin.onKeyOK", <%=STBKeysNew.onKeyOK%>);

top.jsSetVideoKeyFunction("top.extrWin.channelPlayStop", <%=STBKeysNew.remoteBack%>);
top.jsSetVideoKeyFunction("top.extrWin.channelPlayStop", 24);
top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", <%=STBKeysNew.remoteMenu%>);
top.jsSetVideoKeyFunction("top.extrWin.showLiveBar", <%=STBKeysNew.remoteLocation%>);
top.jsSetVideoKeyFunction("top.extrWin.playShowInfo", <%=STBKeysNew.remoteInfo%>);
//add wy ???????? 0x458
top.jsSetVideoKeyFunction("top.extrWin.playShowInfo", 0x458);
top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", 36);

</script>

</body>
<%@include file="inc/public_control_play.jsp" %>
</html>
<%
} catch (Exception e) {
    System.out.println("==channel_show_info==error!!");
    e.printStackTrace();
%>
<script type="text/javascript">
    top.jsHideOSD();
</script>
<%
    }
%>
