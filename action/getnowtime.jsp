<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Date" %>


<%--<epg:PageController/>--%>
<%
    Date nowtime = new Date();
    StringBuffer sb = new StringBuffer();
    sb.append("{year:\"").append(nowtime.getYear())
    .append("\",month:\"").append(nowtime.getMonth())
    .append("\",date:\"").append(nowtime.getDate())
    .append("\",hour:\"").append(nowtime.getHours())
    .append("\",minute:\"").append(nowtime.getMinutes())
    .append("\"}");

//    System.out.println("============sb="+sb);

    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

