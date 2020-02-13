<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<script language="javascript">
<%
System.out.println("=================authFailure.jsp===================");
String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
String errorCode = (String)request.getAttribute(EpgConstants.ERROR_CODE);
%>
top.jsAuthFailure('<%=startTime%>','<%=endTime%>','<%=errorCode%>');
</script>