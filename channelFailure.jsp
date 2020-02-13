<%@page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo"%>
<%@ page import="com.zte.iptv.epg.util.PropertyUtil"%>
<%@ page import="com.zte.iptv.epg.util.MsgUtil"%>

<%
	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
	 String playUrl = "";
	  playUrl="channelOrderFailure.jsp";
%>

<%
 StringBuffer sb = new StringBuffer();
    sb.append("{playUrl:\""+playUrl+"\",");
    sb.append("orderFlag:0");
	sb.append("}");
JspWriter ot = pageContext.getOut();
  ot.write(sb.toString());
%>