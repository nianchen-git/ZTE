<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
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
    String path = getPath(request.getRequestURI());
    String columnid=request.getParameter("columnid");
    String programid=request.getParameter("programid");
    String para = request.getQueryString();
%>
<html>
<head>
    <title>control_transit_vodplay.jsp</title>
    <script type="text/javascript">
        top.jsClearVideoKeyFunction();
        if(top.channelInfo.currentChannel != -1) {
            top.setDefaulchannelNo();
        }
        function doNothing(){
            return false;
        }
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.RmotePlayPause%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastForword%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastRewind%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteStop%>);
        function pauseFunction(){
            top.jsSetVideoKeyFunction("top.extrWin.pause", <%=STBKeysNew.RmotePlayPause%>);
            top.jsSetVideoKeyFunction("top.extrWin.FastForword", <%=STBKeysNew.remoteFastForword%>);
            top.jsSetVideoKeyFunction("top.extrWin.FastRewind", <%=STBKeysNew.remoteFastRewind%>);
            top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", <%=STBKeysNew.remoteStop%>);
			
			top.jsSetVideoKeyFunction("top.extrWin.showvolumeRight", <%=STBKeysNew.remoteVolumePlus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteVolumeMinus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeMute", <%=STBKeysNew.remoteVolumeMute%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteAudioTrack%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", 286);//九州声道键
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
		
        function showInfo(){
            var reg = /refreshOSD/;
            if(reg.test(top.mainWin.document.location.href)){
                goInfo();
                setTimeout(pauseFunction,200);
            }
        }

        function delayStop() {
            //top.vodBackTimer = top.setTimeout("top.switchToStopOSDUrl(0)",600);
            top.mainWin.document.location = "<%=path%>back.jsp";
        }

        //play end
        function showThank() {
            var currentChannel = top.channelInfo.currentChannel;
            if(currentChannel ==-1){
                currentChannel =  top.channelInfo.lastChannel;
            }
            delayStop();
            top.jsHideOSD();
            top.doStop();
            top.setBwAlpha(0);
            if(top.channelInfoArr[currentChannel]){
                if(top.channelInfoArr[currentChannel].channelType != 3){
                    top.jsRedirectChannel(currentChannel);
                }
            }
        }

        function FastRewind() {
            top.doFastRewind(-2);
            top.mainWin.document.location =  "<%=path%>speedosd_tvod_position.jsp?fast=RR&programid=<%=programid%>&columnid=<%=columnid%>";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
        }

        function FastForword() {
            top.doFastForward(2);
            top.mainWin.document.location = "<%=path%>speedosd_tvod_position.jsp?fast=FF&programid=<%=programid%>&columnid=<%=columnid%>";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
        }

        function pause() {
            top.doPause();
            top.mainWin.document.location = "<%=path%>speedosd_tvod_position.jsp?fast=pause&programid=<%=programid%>&columnid=<%=columnid%>";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
        }

        function red(){
            return false;
        }

        function VODPlayStop() {
            top.mainWin.document.location = "<%=path%>tvod_play_stop.jsp";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
            return false;
        }

        function gotoPortal() {
            top.jsSetControl("currentColumnIndex", 0);
            top.jsHideOSD();
            top.mainWin.document.location = "<%=path%>portal.jsp";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
            return false;
        }

        function playLast(){
//                top.remotePlayLast();
//                alert("SSSSSSSSSSSSSSSSSSplayLast!!!!");
            top.seek(1);
            return false;
        }

        function playNext(){
//                alert("SSSSSSSSSSSSSSSSSSplayNext!!!!");
            var duration = top.getMediaDuration();
            top.seek(duration);
            return false;
        }

        function postion() {
            top.mainWin.document.location = "<%=path%>vod_play_bytime.jsp";
            top.showOSD(2, 0, 0);
        }

        function goInfo(){
            top.mainWin.document.location = "<%=path%>channel_tvod_show_info.jsp?<%=para%>&curdate="+top.jsGetControl("tvodcurdate");
            top.showOSD(2, 0, 0);
        }


        setTimeout("showInfo();",200);

        //            function doNothing(){
        //                return false;
        //            }

        function doNathing(){

        }


        top.jsSetVideoKeyFunction("top.extrWin.FastRewind", <%=STBKeysNew.onKeyLeft%>);
        top.jsSetVideoKeyFunction("top.extrWin.FastForword", <%=STBKeysNew.onKeyRight%>);



        top.jsSetVideoKeyFunction("top.extrWin.goInfo", <%=STBKeysNew.remoteInfo%>);
	//add wy 华为上方的信息键 0x458
        top.jsSetVideoKeyFunction("top.extrWin.goInfo", 0x458);

        top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", <%=STBKeysNew.remoteBack%>);
        top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", 24);
        top.jsSetVideoKeyFunction("top.extrWin.showThank", "mediaEnd");
        top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", <%=STBKeysNew.remoteMenu%>);
        top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", 36);

        top.jsSetVideoKeyFunction("top.remoteChannelPlus", <%=STBKeysNew.remoteChannelPlus%>);
        top.jsSetVideoKeyFunction("top.remoteChannelMinus", <%=STBKeysNew.remoteChannelMinus%>);

        top.jsSetVideoKeyFunction("top.extrWin.playLast", <%=STBKeysNew.remotePlayLast%>);
        top.jsSetVideoKeyFunction("top.extrWin.playNext", <%=STBKeysNew.remotePlayNext%>);
        top.jsSetVideoKeyFunction("top.extrWin.postion", <%=STBKeysNew.remoteLocation%>);
    </script>
</head>
<body bgcolor="transparent" ></body>
<%@include file="inc/public_control_play.jsp" %>
</html>

