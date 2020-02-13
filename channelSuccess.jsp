<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%
	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
	 String playUrl = "";
	  playUrl="channelOrderSuccess.jsp";
%>

<%
 StringBuffer sb = new StringBuffer();
    sb.append("{playUrl:\""+playUrl+"\",");
    sb.append("orderFlag:1");
	sb.append("}");
JspWriter ot = pageContext.getOut();
  ot.write(sb.toString());
%>