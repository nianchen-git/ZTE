<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<html>
<head>
<title></title>
<%
	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
//    if(request.getParameter("startTime")!=null){
//        startTime=request.getParameter("startTime");
//    }
//    if(request.getParameter("endTime")!=null){
//         endTime=request.getParameter("endTime");
//    }
    System.out.println(endTime+"=================authSuccess.jsp==================="+endTime);
%>
<script language="javascript">
	top.jsAuthSuccess('<%=startTime%>','<%=endTime %>');
</script>
   
</head>
<body bgcolor="transparent">
</body>
</html>