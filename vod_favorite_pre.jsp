<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@	page contentType="text/html; charset=GBK" %>

<%
    String leftstate = String.valueOf(request.getParameter("leftstate"));
    if(leftstate.equals("null") || leftstate.equals("")){
        leftstate="0";
    }
    String lastfocus = request.getParameter("lastfocus");
    String queryString = request.getQueryString();
    System.out.println("ssssssssvod_favorite_pre_getQueryString="+queryString);
%>
<html>
<head>
     <epg:PageController name="vod_favorite_pre.jsp"/>
    <title>portal</title>
    <script language="javascript" type="">
        var _windowframe = window.getWindowByName("favorite");
        function _showWindow(){
			if(typeof(_windowframe) != "object"){
                _windowframe = window.open('vod_favorite.jsp?isnewopen=1&<%=queryString%>','favorite','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
                _windowframe.setWindowFocus();
                top.showOSD(2,0,0);
                top.setBwAlpha(0);
			}else{
                _windowframe.show();
                _windowframe.setWindowFocus();
                _windowframe._window = top;
                <%
                if(lastfocus!=null && !lastfocus.equals("")){
                %>
                <%--_windowframe.leftindex = parseInt("<%=leftstate%>");--%>
                _windowframe.lastfocus = "<%=lastfocus%>";
                <%
                }else{
                %>
                _windowframe.clearSomeDiv();
                _windowframe.leftindex = parseInt("<%=leftstate%>");
                _windowframe.lastfocus = "";
                _windowframe.init();
                <%
                }
                %>
				top.showOSD(2,0,0);
                top.setBwAlpha(0);
                clearChannelNumber();
			}
		}
        function clearDiv(){
//            _windowframe.clearAllDiv();
        }
    </script>
</head>

<body bgcolor="transparent" onUnload="hidePortal();clearDiv();">
<%@include file="inc/lastfocus_window.jsp" %>
</body>
</html>