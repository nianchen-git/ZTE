<%@ page contentType="text/html; charset=GBK" %>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants"%>
<%@page import="com.zte.iptv.platformepg.content.PlatformepgCacheManager"%>
<%@page import="java.util.*"%>
<%--<%@page import="com.zte.iptv.platformepg.account.CriteriaChannelInfo"%>--%>
<%@page import="com.zte.iptv.epg.util.*"%>
<%@page import="com.zte.iptv.newepg.tag.PageReturnStack" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.net.URL" %>
<%@ page import="org.jdom.input.SAXBuilder" %>
<%@ page import="org.jdom.Document" %>
<%@ page import="org.jdom.Element" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="org.jdom.JDOMException" %>
<%!
   public String getFrameCode(String uri) {
        String result = "";
		int begin = uri.indexOf("frame");
		int end = uri.lastIndexOf("/");

        if (begin > 0) {
            result = uri.substring(begin, end);
        }

        return result;
    }

    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }

%>
<html>
<head>
    <meta name="page-view-size" content="1280*720"/>
<%
    session.setAttribute("pushportal","1");
	String thisFrame = getFrameCode(request.getRequestURI());
	UserInfo userInfo = (UserInfo) pageContext.getSession().getAttribute(EpgConstants.USERINFO);
	String userFrame = userInfo.getUserMainUrl();
     String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
     HashMap param = PortalUtils.getParams(path, "GBK");
	 //获取首页地址
	 String pageURI = request.getRequestURI();
     int loc = pageURI.lastIndexOf("/");
	 pageURI = pageURI.substring(0,loc+1);
	 String portalUrl = pageURI+"portal.jsp";
    //开机频道取一次天气预报
//    UserInfo timeUserInfo = (UserInfo)request.getSession().getAttribute(EpgConstants.USERINFO);
    //天气预报结束
    String path1 = getPath(request.getRequestURI());
	if (!userFrame.equals(thisFrame)) {
		userInfo.setUserMainUrl(thisFrame);
%>
<script language="javascript" type="">
	top.jsSetControl("UserModel", "<%=thisFrame%>");
//注册频道鉴权页面
   //top.jsSetControl("ChannelAuthUrl ","<

//%=path1%>/channelOrderAuth.jsp");
   //注册频道订购页面
   //top.jsSetControl("ShowOrderListUrl ","<

//%=path1%>/channelOrderShowOrderList.jsp");
</script>
<%
	}
%>

<%--<script type="text/javascript" src="js/channel_bytime.js"></script>--%>
<script type="text/javascript" src="js/contentloader.js"></script>
<script language="javascript" type="">
top.writeConfig("show_pageloadingbar","no");
function keyEPGPortal(serviceUrl)
{
var xml = '';
xml += "<?xml version='1.0' encoding='UTF-8'?>";
xml += '<global_keytable>';
xml += '<response_define>';
xml += '<key_code>KEY_PORTAL</key_code>';
xml += '<response_type>1</response_type>';
xml += '<service_url>'+serviceUrl+'</service_url>';
xml += '</response_define>';
xml += '</global_keytable>';
Authentication.CUSetConfig("GlobalKeyTable", xml);
}

var ua = window.navigator.userAgent;
 //alert("===channel start==ua===="+ua);
if(ua.indexOf("Ranger/3.0.0")>-1){
     //alert("this is hw get key to epg");
     keyEPGPortal("<%=portalUrl%>");
}
if(isReallyZTE == true){
    if("CTCSetConfig" in Authentication)
    {
      //  alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CTC");
        Authentication.CTCSetConfig('EPGEdition', 'osd');
    }else{
        //alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CU");
        Authentication.CUSetConfig('EPGEdition', 'osd');
    }

    Utility.setBrowserWindowTransColor(0x00ff00ff);
}

//Authentication.CTCSetConfig('SetEpgMode', '720P');
//Utility.setBrowserWindowTransColor(0x00ff00ff);
//Utility.setBrowserWindowAlpha(0);
  top.setBwAlpha(0);

	//top.writeConfig("show_pageloadingbar", "no");
</script>
<%@ include file="inc/chan_addjsset.jsp" %>

<script language="javascript" type="">
var del_tvod_pro_num = [3, 5, 6, 8, 13, 16, 19, 20, 23, 25, 27, 28, 31, 32, 33, 34, 49, 54, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 103, 105, 106, 108, 118, 119, 120, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 322, 323, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600];//删除频道的频道号xiaojun,379,30,35,39
//var del_tvod_pro_num = [];
//for(var i=0; i<100; i++ ){
//   del_tvod_pro_num[i] = 300+i;
//}


var tem_tvodList = [];//xiaojun
var k = 0;//xiaojun
function update_data()//更新直播频道由+、-控制的数组的数据xiaojun
{
		tem_tvodList = top.channelList;
		top.channelList = [];
		for(var i = 0; i < tem_tvodList.length; i++)
         {
		 	 var isDel = 0;
             for(var j = 0; j < del_tvod_pro_num.length; j++)
             {
                 if(parseInt(tem_tvodList[i],10) == del_tvod_pro_num[j]) {
					isDel = 1;
					break; 
                 }
             }
			 if(isDel == 0) {
			         top.channelList[k] = tem_tvodList[i];
					 k++;
			 } 
         }//用来过滤所有的频道
		 update_data_all();
}
function update_data_all()//更新直播频道由+、-控制的数组的数据xiaojun
{
		tem_tvodList = [];
		tem_tvodList = top.allChannelList;
		top.allChannelList = [];
		k = 0;
		for(var i = 0; i < tem_tvodList.length; i++)
         {
		 	 var isDel = 0;
             for(var j = 0; j < del_tvod_pro_num.length; j++)
             {
                 if(parseInt(tem_tvodList[i],10) == del_tvod_pro_num[j]) {
					isDel = 1;
					break; 
                 }
             }
			 if(isDel == 0) {
			         top.allChannelList[k] = tem_tvodList[i];
					 k++;
			 } 
         }//用来过滤所有的频道
}
update_data();
    function start_channel(){
       // top.remindWin.document.location = "<%=path1%>loadRemindList.jsp?isReminderProgramPlay=1";
<%
	if (userInfo == null) {
		pageContext.setAttribute(EpgConstants.TIPS, "EPGPgE0013", PageContext.REQUEST_SCOPE);
		pageContext.forward("/errorHandler.jsp");
		return;
	}

	String isMenu = (String)session.getAttribute("is_menu");
	String framecode = userInfo.getUserModel();
	String frameMainUrl = "";

	frameMainUrl = "/iptvepg/"+ userInfo.getUserModel() + "/portal.jsp";

	if (null != isMenu) {
		PageReturnStack stack = (PageReturnStack)pageContext.getAttribute(EpgConstants.STACK, PageContext.SESSION_SCOPE);
  
		if (null != stack) {
			pageContext.setAttribute(EpgConstants.STACK, null, PageContext.SESSION_SCOPE);
		}

		int tempno = -1;
  
		try{
		    tempno = Integer.parseInt(request.getParameter("tempno"));
		  // tempno=3;
		}catch (Exception e){
		    System.out.println("ssssssssssssssssskaiji bu cun zai!!");
		}

        System.out.println("SSSSSSSSSSSSSSSSSSSStempno="+tempno);
		if(tempno > -1){
%>
            top.jsRedirectChannel("<%=tempno%>");
<%
        } else {
%>
            document.location = "<%=frameMainUrl%>";
<%
		}
	} else {
%>
            document.location = "<%=frameMainUrl%>";
<%
	}
%>
}

<%--<%--%>
  <%--if(isMultiWindow!=null && isMultiWindow.equals("1")){--%>
<%--%>--%>
<%--var isZTEBW = true;--%>
<%--<%--%>
  <%--}else{--%>
<%--%>--%>
<%--var isZTEBW = false;--%>
<%--<%--%>
  <%--}--%>
<%--%>--%>


    //alert("SSSSSSSSSSSnavigator.appName="+window.navigator.appName+"__isZTEBW="+isZTEBW);

    function preloadChannelAll(){
        var vportalframe = window.getWindowByName("channelall");
        if(typeof(vportalframe) != "object"){
            vportalframe = window.open('channel_all.jsp?isnewopen=2','channelall','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            vportalframe.setzindex(205);
            vportalframe.hide();
        }
    }

    function preloadVodPortal(){
        var vodportalframe = window.getWindowByName("vodPortal");
        if(typeof(vodportalframe) != "object"){
            vodportalframe = window.open('vod_portal.jsp?isnewopen=2','vodPortal','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            vodportalframe.setzindex(206);
            vodportalframe.hide();
        }
    }

    function preloadFavorite(){
        var vodfavoriteframe = window.getWindowByName("favorite");
        if(typeof(vodfavoriteframe) != "object"){
            vodfavoriteframe = window.open('vod_favorite.jsp?isnewopen=2','favorite','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            vodfavoriteframe.setzindex(207);
            vodfavoriteframe.hide();
        }
    }

    function preloadTvod(){
        var vodfavoriteframe = window.getWindowByName("tvod");
        if(typeof(vodfavoriteframe) != "object"){
            vodfavoriteframe = window.open('channel_onedetail_tvod.jsp?isnewopen=2','tvod','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            vodfavoriteframe.setzindex(208);
            vodfavoriteframe.hide();
        }
    }

    function preloadTvGuide(){
        var tvguideframe = window.getWindowByName("tvguide");
        if(typeof(tvguideframe) != "object"){
            tvguideframe = window.open('channel.jsp?isnewopen=2','tvguide','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            tvguideframe.setzindex(209);
            tvguideframe.hide();
        }
    }

    if(isZTEBW == true){
        setTimeout("preloadChannelAll()",10);
        setTimeout("preloadVodPortal()",100);
        setTimeout("preloadFavorite()",200);
        setTimeout("preloadTvod()",300);
        setTimeout("preloadTvGuide()",500);
        if(window.navigator.appName=="ztebw"){
            window.setTimeout("start_channel()",12000);
//            window.setTimeout("start_channel()",10);
        }else{
            window.setTimeout("start_channel()",5000);
//            window.setTimeout("start_channel()",10);
        }
    }else{
        window.setTimeout("start_channel()",10);
    }



//    function showWeatherInfo(){
//          var requestUrl = "action/weather_data.jsp";
//          var loaderSearch = new net.ContentLoader(requestUrl, showWeatherInfoResponse);
//    }
//
//    function showWeatherInfoResponse (){
//         var results = this.req.responseText;
//         var data = eval("(" + results + ")");
//    }
//
//    showWeatherInfo();
</script>
</head>
<body bgcolor="#000000">
<div style="left:0px;top:310px;width:1210px;position:absolute;" align="center">
    <img src="images/wait_big.gif" width="100" height="100" alt="" border="0"/>
</div>
<div  style="position:absolute; visibility:hidden; ">
    <%--倪瑞添加--%>
    <%--缓存图片--%>
    <img src="images/vod/btv_bg.png"/>
    <%--<img src="images/logo.png"/>--%>
    <%--<img src="images/bg_bottom.png"/>--%>
    <%--<img src="images/liveTV/channel_programinfo.png"/>--%>
    <%--<img src="images/vod/btv_page.png"/>--%>
    <%--<img src="images/vod/btv_Collection.png"/>--%>
    <%--<img src="images/vod/btv_Search.png"/>--%>

    <%--导视页面相关图片    --%>
    <img src="images/mytv/btv_bg_daoshi.png"/>
    <img src="images/mytv/TVprogram_redline.png"/>
    <img src="images/mytv/bg_black.png"/>
    <img src="images/mytv/tvguide-vertical_red.png"/>
    <img src="images/channel/btv-mytv-ico.png"/>
    <img src="images/liveTV/channelSelect_bg.png"/>

    <%--首页两张大图--%>
    <img src="images/portal/bg_portal_left.png"/>
    <img src="images/portal/bg_portal_down.png"/>

    <%--唐红成添加--%>
    
</div>
<%--<script type="text/javascript" src="js/vod_portal.js"></script>--%>

<%--<link rel="stylesheet" href="css/common.css" type="text/css" />--%>
</body>
</html>
