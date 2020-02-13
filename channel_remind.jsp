<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    String successUrl = "channel_remind_result.jsp?result=1";
    String failureUrl = "channel_remind_result.jsp?result=0";
%>
<epg:operate   datasource="DoPrecontractDataSource" success="<%=successUrl%>" failure="<%=failureUrl%>"/>