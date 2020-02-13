<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<epg:PageController name="back.jsp"/>
<%!
  public String getPath(String uri){
    String path = "";
    int begin = 0;
    int end = uri.lastIndexOf('/');
    if(end > 0){
      path = uri.substring(begin, end + 1) + path;
    }
    return path;
  }
%>

<%
  String path=getPath(request.getRequestURI());
  String paras = request.getQueryString();
%>
<html>
<head>
</head>
<body bgcolor="transparent"  >
<epg:script lasturl="false"/>
<epg:out datasource="TvodUrlDecorator">
<script language="javascript" type="">
   top.doStop();
   top.extrWin.document.location = "<%=path%>control_transit_tovd_play.jsp?<%=paras%>";
   top.clearOSDInfo();
   top.jsPlayTVOD("{url}");
</script>
</epg:out>
</body>
</html>