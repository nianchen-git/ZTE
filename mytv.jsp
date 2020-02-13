<%@	page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="mytv.jsp"/>
<html>
<head>
    <title>portal</title>
</head>

<body bgcolor="transparent">
    <div id="div0" style="position:absolute; width:186px; height:35px; left:51px; top:104px; font-size:22;color:#FFFFFF" align="center">
        <a href="channel_all_tv.jsp">直播</a>
    </div>
    <div id="div1" style="position:absolute; width:186px; height:35px; left:52px; top:160px; font-size:22;color:#FFFFFF" align="center">
        <a href="vod_portal.jsp">点播</a>
    </div>
    <div id="div2" style="position:absolute; width:186px; height:35px; left:53px; top:214px; font-size:22;color:#FFFFFF" align="center">
        <a href="#">回看</a>
    </div>
    <div id="div3" style="position:absolute; width:186px; height:35px; left:51px; top:272px; font-size:22;color:#FFFFFF" align="center">
        <a href="#">生活</a>
    </div>
    <div id="div4" style="position:absolute; width:186px; height:35px; left:51px; top:330px; font-size:22;color:#FFFFFF" align="center">
        <a href="#">社区</a>
    </div>
    <div id="div5" style="position:absolute; width:186px; height:35px; left:50px; top:382px; font-size:22;color:#FFFFFF" align="center">
        <a href="#">我的TV</a>
    </div>


<%@ include file="inc/lastfocus.jsp" %>
</body>
</html>