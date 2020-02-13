<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@	page contentType="text/html; charset=GBK" %>

<%
     String queryString = request.getQueryString();
%>
<html>
<head>
     <epg:PageController name="channel_all_pre.jsp"/>
    <title>portal</title>
    <script language="javascript" type="">
        var _windowframe = window.getWindowByName("channelall");
        function _showWindow(){
			if(typeof(_windowframe) != "object"){
                _windowframe = window.open('channel_all.jsp?isnewopen=1&<%=queryString%>','channelall','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
                _windowframe.setWindowFocus();
                top.showOSD(2,0,0);
                top.setBwAlpha(0);
			}else{
                _windowframe.show();
                _windowframe.setWindowFocus();
                _windowframe._window = top;
                _windowframe.initFocus();
				top.showOSD(2,0,0);
                top.setBwAlpha(0);
                clearChannelNumber();
			}
		}
    </script>
</head>

<body bgcolor="transparent" onunload="hidePortal();">
<%@include file="inc/lastfocus_window.jsp" %>
</body>
</html>