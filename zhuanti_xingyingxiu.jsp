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
<epg:PageController name="zhuanti_xingyingxiu.jsp"/>
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
	<script type="text/javascript" src="js/zhuanti_xingyingxiu.js"></script>
</head>
<body background="images/special/zhuanti_xingyingxiu.jpg" style="position:absolute; width:1280px; height:720px; left: 0px; top: 0px;" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  scroll="no" onLoad="custom_load_page()"> 

<!--½¹µã-->
<div id="left_bg_0" style="position: absolute; width: 277px; height: 130px; left: 196px; top: 430px;"><img src="images/special/zhuanti_xingyingxiu_focus.png" width="277" height="130" border="0"></div>



<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/goback.jsp" %>

</body>
</html>
