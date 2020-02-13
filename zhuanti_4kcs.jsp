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
<epg:PageController name="zhuanti_4kcs.jsp"/>
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
	<script type="text/javascript" src="js/zhuanti_4kcs.js"></script>
	<title></title>
	<style  type="text/css">
	#favDialog{

		background:url(images/favdialogbj.png) no-repeat;
		position: absolute;
		width: 393px;
		height: 214px;
		/*left: 431px;
	
		top: 230px;*/
		
		font-size: 26px;
		color: #FFFFFF;
		z-index: 991;
		left: 4px;
		top: 36px;	

	}
	.focus{
		position: absolute;
		width:80px;
		height:61px;
	}

.message{position:absolute; left:13px; top:60px; width:371px; height:33px;text-align:center;}
	</style>
</head>
<body background="images/special/vas_4k.jpg" style="position:absolute; width:1280px; height:720px; left: 0px; top: 0px;" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  scroll="no" onLoad="custom_load_page()">

<!--left-->
<%--<div id="left_bg_0" style="position:absolute; width:289px; height:127px; left: 265px; top: 466px; visibility: hidden;"><img src="images/special/4k_vod.png" width="289" height="127" border="0"></div>--%>
<!--4K点播-->

<%--<div id="right_bg_0" style="position:absolute; width:289px; height:127px; left: 746px; top: 467px; visibility: hidden;"><img src="images/special/4k_live.png" width="289" height="127" border="0"></div>--%>
<!--4K直播-->

<!-- 左侧3个区域 -->
<div class="focus" id="list_0_0" style="left: 910px; top: 251px; visibility:hidden;" border="0">
	<img src="images/special/4K_foucs.png"></div>
<div class="focus" id="list_0_1" style="left: 756px; top: 373px; visibility:hidden;" border="0">
	<img src="images/special/4K_foucs.png"></div>
<div class="focus" id="list_0_2" style="left: 600px; top: 490px; visibility:hidden;" border="0">
	<img src="images/special/4K_foucs.png"></div>

<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/goback.jsp" %>

<div id="dialogue_div" style="position: absolute; display: none; z-index: 10; left: 432px; top: 214px; width: 450px; height: 250px; font-size: 26px;">
  <div id="favDialog" >
	<div id="message0" class="message"></div>
	<div id="message1" class="message" style="top:43px;"></div>
	<div id="message2" class="message"  style="top:82px;"></div>
    <div id="aotomeg" class="message" style="top:163px; ">2s 自动消失</div>
</div>
</div>
<%--4K提示--%>
<!-- <div id="alert_text" style="position:absolute; left: 424px; top: 242px; visibility:hidden; width: 432px; height:234px"><img src="images/4kjump.png" width="432" height="234" style="position:absolute;"/></div>
<div id="alert_focus_0" style="position: absolute; left: 575px; top: 424px; height: 45px; width:130px; visibility: hidden;"><img src="images/4kfoucs.png" width="130" height="38"/></div> -->
</body>
</html>
