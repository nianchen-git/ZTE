<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>

<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>

<%
    String playUrl = "";
    String columnid = request.getParameter("CategoryID");
    String strADid = request.getParameter("strADid");
    String strADid2 = request.getParameter("strADid2");
    String programid = request.getParameter("programid");
    String contentid=request.getParameter("ContentID");
    String fathercontent=request.getParameter("FatherContent");
    String programtype=request.getParameter("programtype");
     if(programtype.equals("10")){
        playUrl=  "vod_order_success.jsp?columnid=" + columnid + "&programid=" + programid +"&"
                +EpgConstants.CONTENT_ID+"="+contentid+ "&FatherContent="+ fathercontent
                +"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" +CodeBook.VOD_TYPE_SERIES_Single+"&strADid="+strADid+"&strADid2="+strADid2;
     } else{
         playUrl = "vod_order_success.jsp?columnid=" + columnid + "&programid=" + programid +"&"
                 +EpgConstants.CONTENT_ID+"="+contentid+ "&FatherContent="+ fathercontent
                 +"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" + CodeBook.PLAY_TYPE_VOD+"&strADid="+strADid+"&strADid2="+strADid2;
   
     }
%>

<%
 StringBuffer sb = new StringBuffer();
    sb.append("{playUrl:\""+playUrl+"\",");
    sb.append("orderFlag:1");
	sb.append("}");
JspWriter ot = pageContext.getOut();
  ot.write(sb.toString());
%>

