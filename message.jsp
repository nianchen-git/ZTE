<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<epg:PageController/>
<%
    String type = request.getParameter("type");

%>
<html>
<body>
<script language="javascript" type="">
    top.mainWin.showError("<%=type%>");
</script>
</body>
</html>