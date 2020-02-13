<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.util.Date" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@	page contentType="text/html; charset=GBK" %>

<%
     String queryString = request.getQueryString();
     String lastfocus = request.getParameter("lastfocus");
    Date nowDate = new Date();                         //取当前小时数做数据请求
    int nowHour = nowDate.getHours();
     System.out.println("SSSSSSSSSSSSSSSSSSSSqueryString="+queryString);
%>
<html>
<head>
     <epg:PageController name="channel_pre.jsp"/>
    <title>portal</title>
    <script language="javascript" type="">
        var _windowframe = window.getWindowByName("tvguide");
        function _showWindow(){
			if(typeof(_windowframe) != "object"){
                _windowframe = window.open('channel.jsp?isnewopen=1&<%=queryString%>','tvguide','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
                _windowframe.setWindowFocus();
                top.showOSD(2,0,0);
                top.setBwAlpha(0);
			}else{
                _windowframe.show();
                _windowframe.setWindowFocus();
                _windowframe._window = top;
				top.showOSD(2,0,0);
                top.setBwAlpha(0);
                <%
                if(lastfocus !=null && !lastfocus.equals("")){
                %>
                <%
                }else{
                %>
                    _windowframe.nowHour = <%=nowHour%>
                    _windowframe.comSecond();
                <%
                }
                %>
                clearChannelNumber();
			}
		}
    </script>
</head>

<body bgcolor="transparent" onunload="hidePortal();">
<%@include file="inc/lastfocus_window.jsp" %>
</body>
</html>