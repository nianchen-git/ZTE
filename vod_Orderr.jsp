<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%
    String playUrl = "";
    String columnid = request.getParameter("CategoryID");
    String programid = request.getParameter("programid");
    String contentid=request.getParameter("ContentID");
    String fathercontent=request.getParameter("FatherContent");
    String programtype=request.getParameter("programtype");
     if(programtype.equals("10")){
        playUrl=  "vod_order_success.jsp?columnid=" + columnid + "&programid=" + programid +"&"
                +EpgConstants.CONTENT_ID+"="+contentid+ "&FatherContent="+ fathercontent
                +"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" +CodeBook.VOD_TYPE_SERIES_Single;
     } else{
         playUrl = "vod_order_success.jsp?columnid=" + columnid + "&programid=" + programid +"&"
                 +EpgConstants.CONTENT_ID+"="+contentid+ "&FatherContent="+ fathercontent
                 +"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" + CodeBook.PLAY_TYPE_VOD;
   
     }
%>
<epg:PageController  checkusertoken="false"/>
<epg:operate datasource="com.zte.iptv.functionepg.datasource.SubscribeDataSource" operator="DefaultOperator"
             success="<%=playUrl%>" redirected="false" failure="message.jsp?type=1"/>
<html>
<head>
    <title>check page</title>
</head>
<body bgcolor="transparent">
</body>
</html>
