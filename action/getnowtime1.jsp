<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>


<%--<epg:PageController/>--%>
<%
    Date nowtime = new Date();
    StringBuffer sb = new StringBuffer();
    DateFormat df = new SimpleDateFormat("yyyy.MM.dd");
    DateFormat df1 = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
    sb.append("{year:\"").append(df.format(nowtime))
            .append("\",hour:\"").append(nowtime.getHours())
            .append("\",minute:\"").append(nowtime.getMinutes())
            .append("\",time:\"").append(df1.format(nowtime))
            .append("\"}");
//    System.out.println("===sml===frame===getnowtime.jsp===sb.toString()--->"+sb.toString());
//    System.out.println("============sb="+sb);

    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

