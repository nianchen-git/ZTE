<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.Vector" %>
<%@ page import="sun.security.pkcs.ContentInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.*" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ include file="inc/getFitString.jsp" %>
<epg:PageController name="zhuanti_dapianreju.jsp"/>
<html>
<head>
	<script type="text/javascript">
 		var _window = window;
 			if(window.opener){
           		_window = window.opener;
 		}
	</script>
	<script type="text/javascript" src="js/contentloader.js"></script>
	<script type="text/javascript" src="js/debugjs.js"></script>
	<script type="text/javascript" src="js/zhuanti_dapianreju.js"></script>
	<title>≥©œÌ¥Û∆¨»»æÁ</title>
	
</head>
<body background="images/special/zhuanti_dapianreju.jpg" style="position:absolute; width:1280px; height:720px; left: 0px; top: 0px;" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  scroll="no" onLoad="custom_load_page()"> 

<!--left-->
<div id="left_bg_0" style="position:absolute; width:158px; height:94px; left: 642px; top: 85px; border: 4px solid red;visibility: hidden;"></div>
<!--right-->
<div id="right_bg_0" style="position:absolute; width:158px; height:94px; left: 815px; top: 85px; border: 4px solid red;visibility: hidden;"></div>


<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/goback.jsp" %>

</body>
</html>
