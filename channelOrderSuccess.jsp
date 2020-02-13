<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%
	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
%>
<html><head><title></title>
    </head>
        <script language="javascript">
            top.jsOrderSuccess('<%=startTime%>','<%=endTime %>');
            top.doOpenSound();
        </script>
    <body bgcolor="transparent"></body>
</html>