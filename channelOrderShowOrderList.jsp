<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.log.Logger" %>
<%@ page import="com.zte.iptv.epg.log.LoggerFactory" %>
<%@ page import="com.zte.iptv.epg.log.LoggerModel" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgDataSource" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@page import="java.util.*" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils"%>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@ page import="com.zte.iptv.epg.util.PropertyUtil" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ include file="inc/words.jsp" %>
<meta http-equiv="pragma"   content="no-cache" />  
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate" />  
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT" />
<epg:PageController name="channelOrderShowOrderList.jsp" pagetype="1"/>
<%!
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
<%  
	//String message="";
	//String strcpnum="0";
	//int cpnum=0;
	//String cpmessage = "";	
	//String tipType = "";    
	//String telno="";
    //String tmpcpname="";
	//System.out.println("=======5555555=8888=========" + request.getQueryString());
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
	String channelCode = (String)session.getAttribute(EpgConstants.CHANNEL_ID);//从session中获取channelID
	UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
	String userId = userInfo.getUserId();
	//String cpimg = (String)session.getAttribute("CP_ICONURL");
	//String cpcode = (String)session.getAttribute("CPCODE");
    //String cpname = (String)session.getAttribute("CP_NAME");
	//String num = "1";
	List result = new Vector();
    //String imagesPath = "images";
    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();


	//String channelCode = "ch00000000000000001121";
	//out.print("channelCode888="+channelCode);
	String global_contentID="";
%>

	
<ex:params var="inputparam">
	<ex:param name="channelcode" value="<%=channelCode%>"/>
</ex:params>
<ex:search tablename="user_channel_detail" fields="*" inputparams="${inputparam}" pagecount="100"  var="detaillist">
	<%
	List<Map> slist = (List<Map>)pageContext.getAttribute("detaillist");
	
	if(slist.size()>0){
		for (Map VODS : slist){
			global_contentID =  (String)VODS.get("telecomcode");
			//out.print("global_contentIDddd"+global_contentID);
		}
	}else{
		int codeflag=1;
		String coderesults ="1";//未找到节目数据
	}                                           
											
	%>
</ex:search>

<html>
<head>
<epg:script/>
<title></title>
<style>

.font_36{
    color:#ffffff;
    font-size:28px;
}
.center{
	text-align:center;
}
.line_height{
	line-height:22px;
}
.font_22{
    color:#ffffff;
    font-size:22px;
	font-family:"黑体";
}

.font_26{

        color:#ffffff;
        
        font-size:26px;
}
</style>  
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript" src="js/advertisement_manager.js"></script>
</head>

<body onLoad="load()" bgcolor="transparent"; onUnload="top.productList=[];">
	<epg:script/>
	<div style="left:0px; top:0px; position:absolute; ">
		<img src="" id="chanorder_bg" width="1280" height="720" alt="" border="0"/>
	</div>
<!--
	<div id="timeDiv" style="color:#ffffff; left:1165px; font-size:24px; top:39px;width:80px;height:20px; position:absolute;" align="center" class="BigStyle"></div>
-->  

	<%   	
		 //String strDestPage = request.getParameter("destpage");	
	     //strDestPage = strDestPage == null ? "1" : strDestPage;	pageContext.setAttribute(EpgConstants.CHANNEL_OPERATION,EpgConstants.CHANNEL_ORDER,PageContext.REQUEST_SCOPE);	
		 //int iDestPage = 0;
		 int iNumInPage = 6 ;//hand control the productList.length!
		 //int scrollBarLength = 340;
		 //int sumNum = 1;		
		 //int barHeight = scrollBarLength/sumNum;
		 //System.out.println("======strDestPage==============" + strDestPage);
		 //if (null != strDestPage && !strDestPage.equals(""))
		//	 iDestPage = Integer.parseInt(strDestPage); 
		for (int i = 0; i < iNumInPage; i++) {
	%>	    	
		<div id="<%="ProductListSize"+i%>" style="position: absolute; width: 316px; height: 64px; left: 81px; top:<%=50+i*80%>px; visibility: hidden;">
			<img src="" id="<%="left_select_button_"+i%>" width="316" height="64">
		</div>
		<div id="<%="ProListFocus"+i%>" style="position: absolute; width: 319px; height: 65px; left: 81px; top:<%=50+i*80%>px; visibility: hidden;">
			<img src="images/order/order_select_left_focus.png" width="319" height="65">
		</div>
		<div id="<%="ProListBlur"+i%>" style="position: absolute; width: 319px; height: 65px; left: 81px; top:<%=50+i*80%>px; visibility: hidden;">
			<img src="images/order/order_select_left_blur.png" width="319" height="65">
		</div>
	<%
		}
	%>   
<div id="ProductEndTime" class="font_22" style="position:absolute;width:360px;height:41px;left:926px;top:527px;color:black;line-height:41px;"></div>		
<!-- 第三行 
	<div id="Product_2_0" style="position: absolute; color: #a3a3a3; width: 300px; height: 26px; left: 144px; top: 447px; visibility: hidden;" class="font_24">淘电影-纯享包月</div>   
    <div id="Product_2_1" style="position: absolute; color: #a3a3a3; width: 300px; height: 26px; left: 144px; top: 447px; visibility: hidden;" class="font_24">淘剧场-纯享包月</div>  
	<div id="ProductPrice_2" style="position: absolute; color: #a3a3a3; width: 136px; height: 26px; left: 383px; top: 447px; visibility: hidden;" class="font_24">3.99元</div>
	<div id="ProductEndTime_2" style="position: absolute; color: #a3a3a3; width: 165px; height: 26px; left: 556px; top: 447px; visibility: hidden;" class="font_24">自然月</div>
	<div id="ProContent_2_0" style="position: absolute; color: #a3a3a3; width: 520px; height: 26px; left: 663px; top: 447px; visibility: hidden;" class="font_24">一听啤酒钱，全家看大片！</div>   
    <div id="ProContent_2_1" style="position: absolute; color: #a3a3a3; width: 520px; height: 26px; left: 663px; top: 447px; visibility: hidden;" class="font_24">一根冰棍儿钱，好剧天天看！</div>	
<div id="Page" align="left" style="left: 11px; top: 615px; width: 114px; height: 30px; position: absolute; visibility: hidden;" class="BigStyle">	</div>
--> 

<!--
<div style="position: absolute; width: 141px; height: 63px; left: 761px; top: 570px;"><img src="images/order/wxpay_button.png" width="141" height="63"></div>
<div style="position: absolute; width: 141px; height: 63px; left: 916px; top: 570px;"><img src="images/order/kdpay_button.png" width="141" height="63"></div>
<div style="position: absolute; width: 141px; height: 63px; left: 1071px; top: 570px;"><img src="images/order/exit_button.png" width="141" height="63"></div>
-->
<%
	int rightFocusSize = 3;
	for(int i=0;i<rightFocusSize;i++){
%>	
<div id="<%="select_right_btn_"+i%>" style="position: absolute; width: 141px; height: 65px; left: <%=763+i*155%>px; top: 571px;"><img width="141" height="65"></div>	
<div id="<%="select_right_"+i%>" style="position: absolute; width: 141px; height: 65px; left: <%=763+i*155%>px; top: 571px; visibility: hidden;"><img src="images/order/order_select_right_focus.png" width="141" height="65"></div>
<%
	}
%>
<!--订购-->
<div id="button_up" style="position:absolute; width:53px; height:37px; left:212px; top:10px; visibility:hidden">
	<img src="images/vod/arrow_up.png" width="53" height="37">
</div>
<div id="button_down" style="position:absolute; width:53px; height:37px; left:212px; top:520px; visibility:hidden">
	<img src="images/vod/arrow_down.png" width="53" height="37">
</div>

<div id="dialog_order" style="position:absolute; width:837px; height:306px; left:226px; top:193px; visibility:hidden">

<div style="position:absolute; width:837px; height:306px; left:0px; top:0px; "><img id="order_img" src="" width="837" height="306"></div>

<div id="dialog_order_button" style="position:absolute;  width:158px; height:45px; left:156px; top:237px; visibility:hidden"><img src="images/order/price_onfocus.png" width="158" height="45"></div>

<div id="dialog_remove_button" style="position:absolute; width:158px; height:45px; left:512px; top:237px; visibility:hidden"><img src="images/order/price_onfocus.png" width="158" height="45"></div>
</div>
<!--订购二维码显示-->
<div id="dialog_erweima" style="position:absolute; width:912px; height:585px; left:184px; top:66px; visibility:hidden">
	<div id="Product_wx" class="font_26" style="position:absolute; width:365px; height:32px; left:140px; top:20px;z-index:99;"></div>
	<div id="ProductPrice_wx" class="font_26" style="position:absolute; width:300px; height:32px; left:140px; top:60px;z-index:99;"></div>
	<div id="ProductEndTime_wx"  class="font_26" style="position:absolute; width:495px; height:64px; left:55px; top:103px;text-indent:4em;z-index:99;line-height:32px;"></div>
	<div style="position:absolute; width:912px; height:585px; left:0px; top:0px; "><img id="erweima_img" src=""></div>
    <div id="dialog_order_button_wx" style="position:absolute; width:181px; height:50px; left:275px; top:440px; visibility:hidden"><img src="images/order/price_onfocus_wx.png" width="181" height="50"></div>
	<div id="dialog_remove_button_wx" style="position:absolute; width:181px; height:50px; left:478px; top:440px; visibility:hidden"><img src="images/order/price_onfocus_wx.png" width="181" height="50"></div>
</div>
<div id="qrcode" style="position:absolute; width:200px; height:200px; top:166px;left:809px; z-index:99;visibility:hidden"></div>

<!--微信订购成功单次-->
<div id="weix_dialog_ordered" style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img src="images/order/weix_ordered.png" width="551" height="235"></div>
<!--微信订购成功包月-->
<div id="weix_dialog_ordered_all" style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img src="images/order/weix_ordered.png" width="551" height="235"></div>

<!--微信订购失败-->
<div id="weix_dialog_ordered_failed" style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img src="images/order/weix_ordered_failed.png" width="551" height="235"></div>

<!--微信订购未支付提示-->
<div id="weix_dialog_ordered_notice" style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img src="images/order/weix_ordered_notice.png" width="551" height="235"></div>

<!--订购成功单次-->
<div id="dialog_ordered" style="position: absolute; width: 609px; height: 250px;  left:344px; top:223px; visibility:hidden; "><img src="images/order/dialog_ordered.png" width="609" height="250" ></div>
<!--订购成功包月-->
<div id="dialog_ordered_all" style="position: absolute; width: 623px; height: 254px;left:344px; top:223px;visibility:hidden;"><img src="images/order/dialog_ordered_all.png" width="623" height="254"></div>

<!--订购失败-->
<div id="dialog_ordered_failed" style="position: absolute; width: 609px; height: 250px; left:344px; top:223px; visibility: hidden;"><img src="images/order/order_failed.png" width="609" height="250"></div>
<!--右下角推荐
<div id="recommend_img" style="position: absolute; width: 192px; height: 75px; left: 917px; top: 576px;visibility:hidden;">
     <img src="" id="recommend_icon" alt="" width="192" height="75" border="0">
</div>
<div id="recommend_img_focus" style="position: absolute; width: 202px; height: 84px; left: 912px; top: 571px; visibility: hidden"><img src="images/order/recommend_icon_focus.png" width="202" height="84"></div>
-->
<!--海报图片
<div id="channelorder_poster" style="position:absolute; width:1280px; height:720px; left:0px; top:0px;z-index:200;visibility:hidden;">
     <img src="" id="channelorder_pcon" alt="" width="1280" height="720" border="0">
</div>-->

<!--二维码请求失败的提示-->
<div id="wx_req_failed_tips" style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img src="images/order/order_failed.png" width="609" height="250"/></div>

<!--请求超时的提示-->
<div id="timeout_msg" style="position:absolute; width:553px; height:237px; left:344px; top:223px; visibility:hidden;"><img src="images/order/timeout_msg.png"   width="553" height="237"></div>

<!--已订购提示-->
<div id="dialog_ordered_second" style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img src="images/order/ordered_second_tips.png" width="609" height="250">	
</div>
<!--已订购提示倒计时-->
<div id="ordered_sec_time" style="position:absolute; width:609px; height:250px; left:540px; top:363px; visibility:hidden; color:#ffffff;font-size:28px;"></div>
<%--宽带支付关闭--%>
<div id="broadband_error" style="position: absolute; width: 554px; height: 299px; left: 363px; top: 210px; visibility:
hidden;">
	<img src="images/order/broadband_error.png" width="554" height="299">
</div>
<%--宽带支付关闭，去微信--%>
<div id="broadband_error_gowx" style="position: absolute; width: 554px; height: 299px; left: 363px; top: 210px;
visibility:
hidden;">
	<img src="images/order/broadband_error_gowx.png" width="554" height="299">
</div>
<script language="javascript" type="">
top.jsSetControl("showinfoflag","NO");//跳转频道时不显示info信息
var NUMINPAGE = parseInt(<%=iNumInPage%>);
var destPage = 0;
var start = 0;
var end =0;
//var pageNum="page";
//var currFocusItem;
var productList = top.productList;  //获得可供订购的产品列表
var left_focus_index=0;//左侧焦点
var right_focus_index=0;//右侧焦点
var left_focus_flag=0;//0表示焦点位于左侧产品列表上  1位于右侧
var pageCount=0;//总页数
var currentPage=1;//当前页
var channelnum=top.jsGetCurrentChannelNum();//获取当前频道号
//var channelname=top.channelInfoArr[channelnum].channelName;//根据当前频道号获取当前频道名
var total_right_btn = 0;//右侧按钮数量控制
var playUrl;	//订购后播放地址
function $(id) {
	if (!$$[id]) {
		 $$[id]=document.getElementById(id);
	}
	return $$[id];
}
var UserId = "<%=userId%>";
var strcontentId = "<%=global_contentID%>";
var curchannelCode = "<%=channelCode%>";


//根据产品id屏蔽相应产品包
Array.prototype.Add = function (avalue) {
	this[this.length] = avalue;
}
var productListNew = new Array();
for(var i=0;i<productList.length;i++){
	if(productList[i].productId != 100321 && productList[i].productId != 100322 && productList[i].productId != 100323 && productList[i].productId != 100345  && productList[i].productId != 100332 && productList[i].productId != 100360 && productList[i].productId != 100359 && productList[i].productId != 100421 && productList[i].productId != 100424 && productList[i].productId != 100427 && productList[i].productId != 100430 && productList[i].productId != 100433 && productList[i].productId != 100439 && productList[i].productId != 100442 && productList[i].productId != 100448 && productList[i].productId != 100451 && productList[i].productId != 100454 && productList[i].productId != 100418 && productList[i].productId != 100381 && productList[i].productId != 100384 && productList[i].productId != 100356 && productList[i].productId != 100355 && productList[i].productId != 100364 && productList[i].productId != 100363 && productList[i].productId != 100371 && productList[i].productId != 100373 && productList[i].productId != 100457){//屏蔽淘影视、淘电影、淘剧场、直播点播混合包月、电竞世界、4K-2小时尝鲜
		productListNew.Add(productList[i]);
	}
}

productList = [];

var zhbStr = JSON.stringify(productListNew[0]);
var zhb = JSON.parse(zhbStr);
productList.Add(zhb);

for(var i=0;i<productListNew.length;i++){
	productList.Add(productListNew[i]);
}
productList[0].productId = "666666";


function order_product(contentid, serviceid, productid,starttime,endtime) {
    var	requestUrl = "channelOrder.jsp" +
					"?ContentID=" + contentid+ 
					"&ServiceID=" + serviceid +
					"&ProductID=" + productid +
					"&puchaseType=" + productList[left_focus_index].purchaseType +
					"&Action=1&ContentType=2";
	var tmp = top.doCheckIPPV(starttime,endtime);
	//top.myDebug("tmp===="+tmp);
	if(tmp!=0)
	{
		requestUrl+="&OrderTime="+ tmp;
	}
	var t = top.configPara["ChannelOrderUrl"];
	var loaderSearch = new net.ContentLoader(requestUrl, show_order_result);
}	
function show_order_result(){
	var results = this.req.responseText;
    catedata = eval("(" + results + ")");	
	playUrl = catedata.playUrl;
	var orderFlag = parseInt(catedata.orderFlag,10);
	if(0==orderFlag){//订购成功
		document.getElementById("dialog_ordered_all").style.visibility="visible";
		/*if(productList[left_focus_index].purchaseType==0){
			document.getElementById("dialog_ordered_all").style.visibility="visible";
			
		}else{
			document.getElementById("dialog_ordered").style.visibility="visible";
		}*/
		set_play_time();
	}else{//订购失败
		if(catedata.returncode == 9301){
			document.getElementById("dialog_ordered_second").style.visibility="visible";
			ordered_back_time();
		}else{
			document.getElementById("dialog_ordered_failed").style.visibility="visible";
			set_back_time();
		}
	}
}
function set_play_time(){
	setTimeout("play_url()",2000);
}
function play_url(){
	top.mainWin.document.location=playUrl;
}
function set_back(){
	document.getElementById("dialog_ordered_failed").style.visibility="hidden";
}
function set_back_time(){
	setTimeout("set_back()",2000);
}
function set_play_time_wx(){
	setTimeout("play_url_wx()",2000);
}
function play_url_wx(){
	top.mainWin.document.location="channelOrderSuccess.jsp";
}
var sec_time = 3;
var sec_order_timer;
function ordered_back_time(){	
	document.getElementById("ordered_sec_time").style.visibility="visible";
	document.getElementById("ordered_sec_time").innerHTML = sec_time;
	sec_order_timer = setInterval("ordered_timer()",1000);
}
function ordered_timer(){	
	sec_time --;
	if(sec_time == 0){
		clearInterval(sec_order_timer);
		document.getElementById("ordered_sec_time").style.visibility="hidden";
		document.getElementById("dialog_ordered_second").style.visibility="hidden";
		play_url_wx();
	}else{
		document.getElementById("ordered_sec_time").innerHTML = sec_time;
	}
}
function format(price){
	var priceInt = parseInt(price);
	var fmPrice = "0";
	//alert("===============" + priceInt/100);
	if(priceInt < 100){
		fmPrice = priceInt/100; 
	}else if(priceInt % 100 < 10){
		fmPrice = parseInt(priceInt/100) + ".0" + priceInt%100;
	}else if(priceInt/100 >= 1){
		//alert("==========523423=====");
		fmPrice = parseInt(priceInt/100) + "."+ priceInt%100;
	}else{
		fmPrice = parseInt(priceInt/100) + "." + priceInt%100; 
	}
	return fmPrice;
}
function showName(obj)
{
	var name = "";
	if(obj==null || obj==undefined)
	{
		return name;
	}
name = obj.productName.substr(0,25);
 //  name = obj.showName.substr(0,25);
	return name; 
}
function showlistname(obj){
	var listname="";
	if(obj==null || obj==undefined)
	{
		return listname;
	}
	if(obj.productName.length>6){
		listname=obj.productName.substr(0,5)+"..";
		//listname=obj.showName.substr(0,5)+"..";		
	}else{
		listname=obj.productName;	
		//listname=obj.showName;
	}
	return listname;		
}
function showPrice(obj)
{	
	var showPrice = "";
	/*if (obj.purchaseType == "1") {          // time
		showPrice = "租金" + format(obj.priceNormal) + "元" + ", " + format(obj.pricePPV) 
					 + "元" + "/" + "次";*/
	//} else if 
	if( obj.purchaseType == "3") {    //           //ppv
		showPrice = format(obj.pricePPV) + "元" + "/" + "次";
	} /*else if("3"==obj.purchaseType){
		showPrice = format(obj.pricePPV) + "元";
	}*/else{
		showPrice = format(obj.priceNormal) + "元";
	}
	return showPrice;
}	
function showEndtime(obj){	
	var showendtime="";
	if(obj.purchaseType == "1" || "3"==obj.purchaseType || "2"==obj.purchaseType){
		var data_time = new Date();
		var time_now = data_time.getTime();
		var time_db =obj.rentalTem*1000;//化为毫秒
		data_time.setTime(time_db + time_now);
		showendtime=data_time.getFullYear()+"-"+checkTime(data_time.getMonth()+1)+"-"+checkTime(data_time.getDate())+"  "+checkTime(data_time.getHours())+":"+checkTime(data_time.getMinutes())+":"+checkTime(data_time.getSeconds());//转换时间格式 2016-5-31 11:03:20		
	}else{
		showendtime="自然月";//包月			
	}
	return showendtime;	
}
function checkTime(i){
	if(i<10){
		i="0"+i;
	}
	return i;
}	

function load_right_btn(){
	for(var i=0;i<channel_product_arr.length;i++){
		for(var j=0;j<channel_product_arr[i].productid.length;j++){
			if(productList[(currentPage-1)*NUMINPAGE+left_focus_index].productId == channel_product_arr[i].productid[j]){
				total_right_btn = channel_product_arr[i].btn_pic.length;
				if(total_right_btn == 3){
					right_focus_index = 0;
					for(var k=0;k<total_right_btn;k++){
						document.getElementById("select_right_btn_"+k).getElementsByTagName("img")[0].src = "images/order/"+channel_product_arr[i].btn_pic[k];
					}
				}else{
					right_focus_index = 1;
					for(var k=0;k<total_right_btn;k++){
						var m = k+1;
						document.getElementById("select_right_btn_"+m).getElementsByTagName("img")[0].src = "images/order/"+channel_product_arr[i].btn_pic[k];
					}
				}
			}
		}
	}
}
function clear_btn(){
	for(var k=0;k<3;k++){
		document.getElementById("select_right_btn_"+k).getElementsByTagName("img")[0].src = "images/btn_trans.gif";	
	}
}

function loadingPage(){
    end = NUMINPAGE;
    if(end > productList.length)
        end = productList.length;
    if(currentPage == pageCount){
        if(productList.length%NUMINPAGE != 0){
            end = productList.length%NUMINPAGE;
		}
	}
    var tmp;

    for(var m = 0; m < NUMINPAGE; m++){
		document.getElementById("left_select_button_"+m).src ="images/btn_trans.gif";
	}

    for(var i=0; i<end; i++){
        tmp= document.getElementById("ProductListSize"+i);
        if(tmp!=null && tmp !=undefined){
            for(var k=0;k<select_bg_by_proid.length;k++){
                if(select_bg_by_proid[k].productid == productList[(currentPage-1)*NUMINPAGE+i].productId){
                    document.getElementById("left_select_button_"+i).src = "images/order/"+select_bg_by_proid[k].focus_pic;
                    break;
                }
                //else{
                //	document.getElementById("left_select_button_"+i).src = "images/order/"+select_bg_by_proid[0].focus_pic;
                //}
            }
            tmp.style.visibility="visible";
        }
    }
    tmp=document.getElementById("ProductEndTime");
    if(tmp!=null && tmp !=undefined){
    	if(productList[(currentPage-1)*NUMINPAGE+left_focus_index].productId != "666666"){
			tmp.innerHTML="有效期："+showEndtime(productList[(currentPage-1)*NUMINPAGE+left_focus_index]);
		}else{
			tmp.innerHTML="";
		}
    }
    document.getElementById("ProListFocus"+left_focus_index).style.visibility="visible";

    load_right_btn();

	if(currentPage>1){
		document.getElementById("button_up").style.visibility ="visible";
	}else{
		document.getElementById("button_up").style.visibility ="hidden";
	}
	if(currentPage<pageCount){
		document.getElementById("button_down").style.visibility ="visible";
	}else{
		document.getElementById("button_down").style.visibility ="hidden";
	}

}
 	
function load(){
	document.onkeypress = mykeypress;
    if(productList.length%NUMINPAGE == 0){
        pageCount = (parseInt(productList.length/NUMINPAGE));
    }else{
        pageCount = (parseInt(productList.length/NUMINPAGE+1));
    }

	/*
	tmp=document.getElementById("ProductPrice");
	if(tmp!=null && tmp !=undefined){
		tmp.innerHTML="";
	}
	tmp=document.getElementById("ProductEndTime");
	if(tmp!=null && tmp !=undefined){
		tmp.innerHTML="";
	}*/
	for(var m=0;m<channel_order_bg.length;m++){
		if(channel_order_bg[m].channel_id==channelnum){
			document.getElementById("chanorder_bg").src = "images/order/"+channel_order_bg[m].info_pic;
			break;
		}
		//else{
		//	document.getElementById("chanorder_bg").src = "images/order/"+channel_order_bg[0].info_pic;
		//}
	}

	document.getElementById("chanorder_bg").onload= loadingPage();
	
	

	/*for(var j=0;j<chanorder_l_t_button.length;j++){
		if(chanorder_l_t_button[j].channel_id == channelnum){
			document.getElementById("left_top_button").src = "images/order/"+chanorder_l_t_button[j].info_pic;
			break;
		}else{
			document.getElementById("left_top_button").src = "images/order/"+chanorder_l_t_button[0].info_pic;
		}
	}*/
	//show_product_list();
	//order_pro_list();
	/*
	if(channelnum == "37" || channelnum == "38"){
		//alert("=====************channelno=="+channelnum);
		show_third_list();
	}
	for(var i=0;i<end;i++)
	{	
		//changeDetail(left_focus_index,true);
		var fun =" <a href=\"#\" "+"name=\"llinker30"+i+"\" >"+
				"<img src=\"images/btn_trans.gif\" width=\"1\" height=\"1\" alt=\"\" border=\"0\"/></a>";

		tmp=document.getElementById("ProductUrl"+i);
		if(tmp!=null && tmp !=undefined){
			tmp.innerHTML=fun;
		}	
	}
	*/
	//left_focus_flag=1;
	//left_focus_index=end;
	//focusbackbtn();
	//document.getElementById("order_button").style.visibility="visible";
	//if(left_focus_index == -1){
	//	document.getElementById("left_top_focus_0").style.visibility="visible";
	//}
}
/*	
//展示左侧列表		
function show_product_list(){
	for(var i=0; i<end; i++){
		tmp= document.getElementById("ProductName"+i);
			if(tmp!=null && tmp !=undefined){
			tmp.innerHTML="<font color=\"#ffffff\">"+showlistname(productList[start+i])+"</font>";
		}
	}
}*/	
/*
//展示右侧列表
function order_pro_list(){
	for(var i=0; i<end; i++){
		tmp=document.getElementById("Product"+i);
		if(tmp!=null && tmp!=undefined){
			if(channel_no == 36){//taobaby
				tmp.innerHTML="";
			}else{
				tmp.innerHTML="<font color=\"#ffffff\">"+showName(productList[start+i])+"</font>";
			}
		}
		//展示产品价格
		tmp=document.getElementById("ProductPrice"+i);
		if(tmp!=null && tmp !=undefined){
			if(channel_no == 36){//taobaby
				tmp.innerHTML="";
			}else{
				tmp.innerHTML="<font color=\"#ffffff\">"+showPrice(productList[start+i])+"</font>";	
			}
		}
		if(channel_no != 36){//taobaby
			for(var k=0;k<order_id.length;k++){
				if(order_id[k].productid==productList[start+i].productId){
					var ctmp=document.getElementById("CurrentPrice"+i);
					if(ctmp!=null && ctmp !=undefined){
						tmp.style.textDecoration = "line-through";
						ctmp.innerHTML="<font color=\"#f2f104\">"+order_id[k].truepri+"</font>";	
					}
				}
			}
		}
		
		tmp=document.getElementById("ProductEndTime"+i);
		if(tmp!=null && tmp !=undefined){
			if(channel_no == 36){//taobaby
				tmp.innerHTML="";
			}else{
				tmp.innerHTML="<font color=\"#ffffff\">"+showEndtime(productList[start+i])+"</font>";
			}
		}
		tmp=document.getElementById("OrderBtnImg"+i);
		if(tmp!=null && tmp !=undefined){
			if(channel_no == 36){//taobaby
				tmp.innerHTML="";
			}else{
				tmp.innerHTML="<img src=\"images/order/orderbutton_bg_spring.png\" width=\"102\" height=\"36\" border=\"0\">";
			}
		}
		
		//显示备注--产品内容
		//tmp=document.getElementById("ProContent"+i);
		//if(tmp!=null && tmp !=undefined){
		//	tmp.innerHTML="<font color=\"#ffffff\">"+productList[start+i].productId+"</font>";
		//}
		var jk = {};
		jk.GetLength = function(str){
			return str.replace(/[\u0391-\uFFE5]/g,"aa").length;//先把中文替换成两个字节的英文，在计算长度
		};
		if(channel_no != 36){
			for(var j=0;j<remark_id.length;j++){
				if(remark_id[j].productid==productList[start+i].productId){
					tmp=document.getElementById("ProContent"+i);
					if(tmp!=null && tmp !=undefined){
						if(remark_id[j].productid=="100320" || remark_id[j].productid=="100326" || remark_id[j].productid=="100331" || remark_id[j].productid=="100333"){
						  tmp.style.color = "#f2f104";//设置字体颜色
						}else{
						  tmp.innerHTML="<font color=\"#ffffff\">"+remark_id[j].productremark+"</font>";
						}
						if(jk.GetLength(remark_id[j].productremark) > 30){
							tmp.innerHTML="<marquee direction=\"left\" behavior=\"scroll\" scrollamount=\"6\" loop=\"-1\">"+remark_id[j].productremark+"</marquee>";
						}
					}
					break;
				}else{
					//显示原有备注
					tmp=document.getElementById("ProContent"+i);
					if(tmp!=null && tmp !=undefined){
						tmp.innerHTML="<font color=\"#ffffff\">"+showName(productList[start+i])+"</font>";
					}
				}
			}
		}
	}
}
	

	
	function show_third_list(){
		//alert("222222222*channelno=="+channelnum);
		document.getElementById("ProductPrice_2").style.visibility = "visible";
		document.getElementById("ProductEndTime_2").style.visibility = "visible";
		if(channelnum == "38"){
			document.getElementById("Product_2_1").style.visibility = "visible";//淘剧场
			document.getElementById("ProContent_2_1").style.visibility = "visible";
		}else if(channelnum == "37"){
			document.getElementById("Product_2_0").style.visibility = "visible";//淘电影
			document.getElementById("ProContent_2_0").style.visibility = "visible";
		}
	}
	
	 //滚动效果
	function textScroll(doi,index) {
  
        if (doi == 1) {
     
		   scrollString("ProductName"+index, productList[start+index].productName, 32, 200);
	
        }
        if (doi == -1) {
      
		  stopscrollString("ProductName"+index, productList[start+index].productName, 32, 200);
		 
        }

}
 function scrollString(divid, text, px, divwidth) {
		text = text.replace(new RegExp("<","gm"),"&lt;");
		text = text.replace(new RegExp(">","gm"),"&gt;");
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            var scrolltext = "<marquee version='3' scrolldelay='250' width='"+divwidth+"'>" + text + "</marquee>";
            document.getElementById(divid).innerHTML = scrolltext;
        }
    }

    // 字符串停止滚动
    function stopscrollString(divid, text, px, divwidth) {
		text = text.replace(new RegExp("<","gm"),"&lt;");
		text = text.replace(new RegExp(">","gm"),"&gt;");
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            text = writeFitString(text, px, divwidth);
        }
        document.getElementById(divid).innerText = text ;
    }
*/
function pagingkeydown() {
    /*if(document.getElementById("recommend_img_focus").style.visibility=="visible" || document.getElementById("channelorder_poster").style.visibility=="visible"){
		return;
	}	
	blur_left_index(left_focus_index);
	left_focus_index++;
	if(left_focus_index<productList.length){		
		focus_left_index();		
	}else{
		left_focus_flag =1;
		left_focus_index=end;
		if(document.getElementById("remove_button").style.visibility=="hidden"){
			blur_left_index(left_focus_index-1);
			focusbackbtn();
		}else{
			blurbackbtn();
			document.getElementById("recommend_img_focus").style.visibility="visible";
		}
	}*/
    if (left_focus_flag == 0 && left_focus_index < end - 1) {
        //if(left_focus_index == 0){
        //document.getElementById("left_top_focus_0").style.visibility="hidden";
        //left_focus_index = 0;
        //}else if(left_focus_index > -1 && left_focus_index < end-1){
        blur_left_index(left_focus_index);
        left_focus_index++;
        var flag_down = false;
        for (var i = 0; i < select_bg_by_proid.length; i++) {
            if (select_bg_by_proid[i].productid == productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId) {
                document.getElementById("chanorder_bg").src = "images/order/" + select_bg_by_proid[i].info_pic;
                //document.getElementById("left_select_button_"+left_focus_index).src = "images/order/"+select_bg_by_proid[i].focus_pic;
                flag_down = true;
                break;
            }
            //else{
            //	document.getElementById("chanorder_bg").src = "images/order/"+select_bg_by_proid[0].info_pic;
            //document.getElementById("left_select_button_"+left_focus_index).src = "images/order/"+select_bg_by_proid[i].focus_pic;
            //}
        }
        //}
        if (flag_down) {
            clear_btn();
            load_right_btn();
            focus_left_index();
        } else {

            left_focus_index--;
            focus_left_index();
        }
        var tmp;
        tmp = document.getElementById("ProductEndTime");
        if (tmp != null && tmp != undefined) {
			if(productList[(currentPage-1)*NUMINPAGE+left_focus_index].productId != "666666"){
				tmp.innerHTML="有效期："+showEndtime(productList[(currentPage-1)*NUMINPAGE+left_focus_index]);
			}else{
				tmp.innerHTML="";
			}
        }
    } else if(left_focus_flag == 0){

        if (pageCount > currentPage) {
			blur_left_index(left_focus_index);
			for(var i = 0; i < NUMINPAGE; i++){
				document.getElementById("left_select_button_"+i).src ="images/btn_trans.gif";
			}
            left_focus_index = 0;
            currentPage++;
            loadingPage();
			for (var i = 0; i < select_bg_by_proid.length; i++) {
				if (select_bg_by_proid[i].productid == productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId) {
					document.getElementById("chanorder_bg").src = "images/order/" + select_bg_by_proid[i].info_pic;
					break;
				}
			}
        }
    }
}
function blur_left_index(focusid){
	document.getElementById("ProListFocus"+focusid).style.visibility="hidden";
}
function focus_left_index(){
	document.getElementById("ProListFocus"+left_focus_index).style.visibility="visible";
}

function blur_right_index(focusid){
	document.getElementById("select_right_"+focusid).style.visibility="hidden";
}
function focus_right_index(){
	document.getElementById("select_right_"+right_focus_index).style.visibility="visible";
}

function focusbackbtn(){
	document.getElementById("remove_button").style.visibility="visible";	
}
function blurbackbtn(){
	document.getElementById("remove_button").style.visibility="hidden";	
}

function focusforwardpicbtn(){
	document.getElementById("channelorder_jump_pic").style.visibility="visible";	
}
function blurforwardpicbtn(){
	document.getElementById("channelorder_jump_pic").style.visibility="hidden";	
}
function pagingkeyup() {
	/*if(document.getElementById("channelorder_poster").style.visibility=="visible"){
		return;
	}
	
	if(left_focus_flag == 0){
		blur_left_index(left_focus_index);
		left_focus_index--;
		if(left_focus_index>=0 ){
			focus_left_index();
			
		}else{
			left_focus_index=0;	
			focus_left_index();
		}
	}else if(left_focus_flag == 1){//焦点不在订购上
		if(document.getElementById("recommend_img_focus").style.visibility=="visible"){
			document.getElementById("recommend_img_focus").style.visibility="hidden";
			focusbackbtn();
		}else if(document.getElementById("remove_button").style.visibility=="visible"){
			if(left_focus_index == end){
					left_focus_index--;
			}
			left_focus_flag = 0;
			focus_left_index();	
			blurbackbtn();
		}
	}*/

	if(left_focus_flag == 0 && left_focus_index > 0){
		blur_left_index(left_focus_index);
		left_focus_index --;
		for(var i=0;i< select_bg_by_proid.length;i++){
			if(select_bg_by_proid[i].productid==productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId){
				document.getElementById("chanorder_bg").src = "images/order/"+select_bg_by_proid[i].info_pic;
				//document.getElementById("left_select_button_"+left_focus_index).src = "images/order/"+select_bg_by_proid[i].focus_pic;
				break;
			}
			//else{
			//	document.getElementById("chanorder_bg").src = "images/order/"+select_bg_by_proid[0].info_pic;
				//document.getElementById("left_select_button_"+left_focus_index).src = "images/order/"+select_bg_by_proid[i].focus_pic;
			//}
		}
		clear_btn();
		load_right_btn();
		//if(left_focus_index == -1){
			//document.getElementById("chanorder_bg").src = "images/order/order_select_0.jpg";
			//document.getElementById("left_top_focus_0").style.visibility="visible";
		//}else{
		focus_left_index();
		//}
		var tmp;
		tmp=document.getElementById("ProductEndTime");
		if(tmp!=null && tmp !=undefined){
			if(productList[(currentPage-1)*NUMINPAGE+left_focus_index].productId != "666666"){
				tmp.innerHTML="有效期："+showEndtime(productList[(currentPage-1)*NUMINPAGE+left_focus_index]);
			}else{
				tmp.innerHTML="";
			}
		}
	}else if(left_focus_flag == 0){
        if (currentPage > 1) {
			blur_left_index(left_focus_index);
			for(var i = 0; i < NUMINPAGE; i++){
				document.getElementById("left_select_button_"+i).src ="images/btn_trans.gif";
			}
            left_focus_index = 0;
            currentPage--;
            loadingPage();
			for (var i = 0; i < select_bg_by_proid.length; i++) {
				if (select_bg_by_proid[i].productid == productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId) {
					document.getElementById("chanorder_bg").src = "images/order/" + select_bg_by_proid[i].info_pic;
					break;
				}
			}
        }
	}
	/*else if(left_focus_flag == 0 && end > 1){
		if(left_focus_index == -1){
			left_focus_index = end-1;
			document.getElementById("left_top_focus_0").style.visibility="hidden";
			for(var i=0;i< channel_order_bg.length;i++){
				if(channel_order_bg[i].channel_id==channelnum){
					document.getElementById("chanorder_bg").src = "images/order/"+channel_order_bg[i].info_pic;
					break;
				}else{
					document.getElementById("chanorder_bg").src = "images/order/"+channel_order_bg[0].info_pic;
				}
			}
			focus_left_index();
		}
	}*/
}

function pagingkeyleft(){
	/*if(document.getElementById("recommend_img_focus").style.visibility=="visible" ||	document.getElementById("channelorder_poster").style.visibility=="visible"){
		return;
	}	
	if(left_focus_flag == 0 &&document.getElementById("dialog_order").style.visibility=="hidden" ){
		left_focus_flag =1; 
		blur_left_index(left_focus_index);
		focusbackbtn();
	}else {
		if(document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="visible";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
			}		
		 }
	}	*/
	if(left_focus_flag == 1){
		if(document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="visible";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
			}		
		}else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button_wx").style.visibility=="visible"){
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button_wx").style.visibility=="visible"){
				document.getElementById("dialog_order_button_wx").style.visibility="visible";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
			}
		}else{	
			if(total_right_btn == 3){
				if(right_focus_index > 0){
					blur_right_index(right_focus_index);
					right_focus_index --;
					focus_right_index();
				}else if(right_focus_index == 0){
					blur_right_index(right_focus_index);
					left_focus_flag = 0;
					document.getElementById("ProListBlur"+left_focus_index).style.visibility="hidden";
					focus_left_index();
				}
			}else{
				if(right_focus_index > 1){
					blur_right_index(right_focus_index);
					right_focus_index --;
					focus_right_index();
				}else{
					blur_right_index(right_focus_index);
					left_focus_flag = 0;
					document.getElementById("ProListBlur"+left_focus_index).style.visibility="hidden";
					focus_left_index();
				}
			}
		}
	}/*else if(left_focus_flag == 0){
		blur_left_index(left_focus_index);
		left_focus_flag = 1;
		right_focus_index = 2;
		focus_right_index();
	}*/
}

function pagingkeyright(){
	/*if(document.getElementById("recommend_img_focus").style.visibility=="visible" || document.getElementById("channelorder_poster").style.visibility=="visible"){
		return;
	}

	if(left_focus_flag==1){
		blurbackbtn();
		if(left_focus_index==end){
			left_focus_index=end-1;
		}
		focus_left_index();
		left_focus_flag=0;
	
	}else {
		  if(document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="visible";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
			}	
		  }
	}*/
	if(left_focus_flag == 0){
		//if(left_focus_index > -1){
			blur_left_index(left_focus_index);
			document.getElementById("ProListBlur"+left_focus_index).style.visibility="visible";
			left_focus_flag = 1;
			focus_right_index();
		//}
	}else if(left_focus_flag == 1){
		if(document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order_button").style.visibility="visible";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
			}
		}else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button_wx").style.visibility=="visible"){
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="visible";
			}else if(document.getElementById("dialog_remove_button_wx").style.visibility=="visible"){
				document.getElementById("dialog_order_button_wx").style.visibility="visible";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
			}
		}else{
			if(right_focus_index < 2){
				blur_right_index(right_focus_index);
				right_focus_index ++;
				focus_right_index();
			}
		}
	}
}                    
function pay_kd(){
	/*blur_right_index(right_focus_index);
	document.getElementById("dialog_order").style.visibility="visible";
	if(productList[left_focus_index].purchaseType==0){
		document.getElementById("order_img").src="images/order/dialog_order_all.png";
	}else{
		document.getElementById("order_img").src="images/order/dialog_order.png";
	}
	document.getElementById("dialog_remove_button").style.visibility="visible";*/
    if(productList[left_focus_index].purchaseType==0){
        document.getElementById("select_right_"+right_focus_index).style.visibility="hidden";
        document.getElementById("broadband_error").style.visibility="visible";
        setTimeout("select_error('broadband_error')",5000);
    }else{
        document.getElementById("select_right_"+right_focus_index).style.visibility="hidden";
        document.getElementById("broadband_error_gowx").style.visibility="visible";
        setTimeout("select_error('broadband_error_gowx')",5000);
    }

}

function pay_wx(){
	blur_right_index(right_focus_index);
	load_erweima_result();
}

function pay_hb() {
	top.mainWin.document.location='poster_auth_orderlist.jsp?from=channel&timeFrameUrl=<%=timeFrameUrl%>';
}

function select_ok_btn(){
	for(var i=0;i<channel_product_arr.length;i++){
		for(var j=0;j<channel_product_arr[i].productid.length;j++){
			if(productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId == channel_product_arr[i].productid[j]){
				if(total_right_btn == 3){
					var func_s = eval(channel_product_arr[i].func_ok[right_focus_index]);
				}else{
					var func_s = eval(channel_product_arr[i].func_ok[right_focus_index-1]);
				}
				break;
			}
		}
	}
}

function select_error(error_id) {
    document.getElementById("select_right_"+right_focus_index).style.visibility="visible";
    document.getElementById(error_id).style.visibility="hidden";
}

function pagingkeyok(){
/*
	if(left_focus_flag == 0 && document.getElementById("dialog_order").style.visibility=="hidden" && document.getElementById("recommend_img_focus").style.visibility=="hidden"){

		blur_left_index(left_focus_index);
		document.getElementById("dialog_order").style.visibility="visible";
	if(productList[start+left_focus_index].purchaseType==0){
		document.getElementById("order_img").src="images/order/dialog_order_all.png";
	}else{
		document.getElementById("order_img").src="images/order/dialog_order.png";
	}
		document.getElementById("dialog_order_button").style.visibility="visible";
	}else if(document.getElementById("remove_button").style.visibility=="visible"){
			doback();
	
	}else if(document.getElementById("dialog_order").style.visibility=="visible"){
		if(document.getElementById("dialog_order_button").style.visibility=="visible"){
			document.getElementById("dialog_order").style.visibility="hidden";
			document.getElementById("dialog_order_button").style.visibility="hidden";
			order_product(
						productList[start+left_focus_index].contentId,
						productList[start+left_focus_index].serviceId,
						productList[start+left_focus_index].productId,
						productList[start+left_focus_index].startTime,
						productList[start+left_focus_index].endTime);
			
		}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
			//left_focus_flag=1;
			document.getElementById("dialog_order").style.visibility="hidden";
			document.getElementById("dialog_remove_button").style.visibility="hidden";
			focus_left_index();
			
		}
	}else if(document.getElementById("recommend_img_focus").style.visibility=="visible"){
		document.getElementById("channelorder_poster").style.visibility="visible";	
	}*/
	
	if(left_focus_flag == 1){
		
		/*if(right_focus_index == 0 && document.getElementById("dialog_erweima").style.visibility=="hidden"){
			blur_right_index(right_focus_index);
			load_erweima_result();
		}else if(right_focus_index == 0 && document.getElementById("dialog_erweima").style.visibility=="visible"){
			if(document.getElementById("qrcode").style.visibility=="visible"){
				getorderresult();
			}
		}else if(right_focus_index == 1 && document.getElementById("dialog_order").style.visibility=="hidden"){
			blur_right_index(right_focus_index);
			document.getElementById("dialog_order").style.visibility="visible";
			if(productList[left_focus_index].purchaseType==0){
				document.getElementById("order_img").src="images/order/dialog_order_all.png";
			}else{
				document.getElementById("order_img").src="images/order/dialog_order.png";
			}
			document.getElementById("dialog_order_button").style.visibility="visible";
		}else if(right_focus_index == 1 && document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order").style.visibility="hidden";
				document.getElementById("dialog_order_button").style.visibility="hidden";
				order_product(
							productList[left_focus_index].contentId,
							productList[left_focus_index].serviceId,
							productList[left_focus_index].productId,
							productList[left_focus_index].startTime,
							productList[left_focus_index].endTime);

			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
				focus_right_index();
			}
		}else if(right_focus_index == 2){
			doback();
		}*/
		if(document.getElementById("dialog_erweima").style.visibility=="hidden" && document.getElementById("dialog_order").style.visibility=="hidden"){
			select_ok_btn();
		}else if(document.getElementById("dialog_erweima").style.visibility=="visible"){
			if(document.getElementById("qrcode").style.visibility=="visible"){
				getorderresult();
			}
		}else if(document.getElementById("dialog_order").style.visibility=="visible"){
			if(document.getElementById("dialog_order_button").style.visibility=="visible"){
				document.getElementById("dialog_order").style.visibility="hidden";
				document.getElementById("dialog_order_button").style.visibility="hidden";
				order_product(
							productList[left_focus_index].contentId,
							productList[left_focus_index].serviceId,
							productList[left_focus_index].productId,
							productList[left_focus_index].startTime,
							productList[left_focus_index].endTime);


			}else if(document.getElementById("dialog_remove_button").style.visibility=="visible"){
				document.getElementById("dialog_order").style.visibility="hidden";
				document.getElementById("dialog_remove_button").style.visibility="hidden";
				focus_right_index();
			}
		}
		
	}
}
/*
function focus_left_index_blr(name){
	document.images[name].src ="images/vod/btv_column_focus.png";
}*/
function vitur()
{
	top.virtualEvent();
}
/*
function refreshTime()
{
	var stbtime=top.getPlayTime();

	var strTime=top.date2str(stbtime,"time");
	top.mainWin.document.getElementById("timeDiv").innerHTML=strTime;
	var t=setTimeout("refreshTime()",1000);
}
refreshTime();
*/
//第三方支付 获取二维码
function load_erweima_result(){
	//alert("22222222222");
	var requestUrl = "action/vod_third_erweima.jsp" +
							"?ContentID=" + strcontentId+ 
							"&ServiceID=" + productList[(currentPage - 1) * NUMINPAGE + left_focus_index].serviceId+
							"&ProductID=" + productList[(currentPage - 1) * NUMINPAGE + left_focus_index].productId;
    var loaderSearch = new net.ContentLoader(requestUrl, show_erweima_result);
}

var transactionID;
var productID;
var productPriceWx;
var backFlag = 1;//返回键标志位，1代表返回到详情页，0代表返回到订购页
function show_erweima_result(){
	var results = this.req.responseText;
	catedata = eval("(" + results + ")");
	//alert("code_url33"+results);	
	if(parseInt(catedata.return_code) == 0){
		if(typeof(catedata) != "undefined"){
			transactionID=catedata.transactionID;
			var imgurl=catedata.code_url;
			productID=catedata.productID;
			creatimg(imgurl);	
			productPriceWx=(catedata.payFee)/100;
			document.getElementById("ProductPrice_wx").innerHTML = productPriceWx+"元";		
			blur_right_index(right_focus_index)
			//if(productList[left_focus_index].purchaseType==0){
			//   document.getElementById("erweima_img").src="images/order/erweima_all.png";
			//  document.getElementById("ProductEndTime_wx").innerHTML="订购成功，立即生效，在订购成功的自然月内有效。";
			//}else{
			   document.getElementById("erweima_img").src="images/order/erweima.png";
			   var data_time = new Date();
			   var time_now = data_time.getTime();
			   var time_db = productList[(currentPage - 1) * NUMINPAGE + left_focus_index].rentalTem*1000;
			   data_time.setTime(time_db + time_now);
				document.getElementById("ProductEndTime_wx").innerHTML="自订购成功时间起至"+data_time.getFullYear()+"-"+checkTime(data_time.getMonth()+1)+"-"+checkTime(data_time.getDate())+"  "+checkTime(data_time.getHours())+":"+checkTime(data_time.getMinutes())+":"+checkTime(data_time.getSeconds())+"期间内有效。";
			//}
			document.getElementById("dialog_erweima").style.visibility="visible";
			document.getElementById("Product_wx").innerHTML = showName(productList[(currentPage - 1) * NUMINPAGE + left_focus_index]);
			document.getElementById("Product_wx").style.visibility="visible";
			document.getElementById("ProductPrice_wx").style.visibility="visible";
			document.getElementById("ProductEndTime_wx").style.visibility="visible";
			document.getElementById("dialog_order_button_wx").style.visibility="visible";		
		}
	}else{
		if(parseInt(catedata.return_code) == 96003){
			blur_right_index(right_focus_index)
			document.getElementById("timeout_msg").style.visibility="visible";
			setTimeout("hideouttime()",3000);
		}else{
			blur_right_index(right_focus_index)
			document.getElementById("dialog_ordered_failed").style.visibility="visible";
			set_back_time();
		}
	}
	
}

var ajaxTimeoutTest = null;
function getorderresult(){
	ajaxTimeoutTest = $.ajax({
	　　url:"http://210.13.0.139:8080/iptv_tpp/order/checkEpayOrderState?ditch=1&transactionID="+transactionID+"&productID="+productID+"&userID="+UserId,
	　　timeout : 1000, //超时时间设置，单位毫秒
	　　type : 'get',  //请求方式，get或post
	　　dataType:'json',//返回的数据格式
	　　success:function(data){ //请求成功的回调函数
	　　　　//alert("成功"+data+"ddd"+data.return_code);
			if(data.return_code == 2){
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag == 1){
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						document.getElementById("weix_dialog_ordered_notice").style.visibility="visible";
						setTimeout("goonpay()",3000);
					}else{
						backFlag = 1;
						document.getElementById("qrcode").innerHTML="";
						document.getElementById("Product_wx").innerHTML="";
						document.getElementById("ProductPrice_wx").innerHTML="";
						document.getElementById("ProductEndTime_wx").innerHTML="";
						document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						focus_right_index();
					}
				}
			}else if(data.return_code == 0){
				//alert("成功");	
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag == 1){
						document.getElementById("dialog_order_button_wx").style.visibility="hidden";
						if(productList[left_focus_index].purchaseType==0){//baoyue weix_dialog_ordered_all
						  document.getElementById("weix_dialog_ordered_all").style.visibility="visible";
						}else{
						  document.getElementById("weix_dialog_ordered").style.visibility="visible";
						}
						set_play_time_wx();
					}else{
						backFlag = 1;
						doback();
					}
				}
			}else if(data.return_code == 1){
				//alert("失败");	
				if(document.getElementById("dialog_erweima").style.visibility=="visible"){
					document.getElementById("qrcode").innerHTML="";
					document.getElementById("Product_wx").innerHTML="";
					document.getElementById("ProductPrice_wx").innerHTML="";
					document.getElementById("ProductEndTime_wx").innerHTML="";
					if(document.getElementById("dialog_order_button_wx").style.visibility=="visible" && backFlag == 1){
						document.getElementById("weix_dialog_ordered_failed").style.visibility="visible";	
						setTimeout("doback()",3000);
					}else{
						backFlag = 1;
						doback();
					}
				}
			}else if(data.return_code == 96003){
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
				document.getElementById("timeout_msg").style.visibility="visible";
				setTimeout("hideouttime()",3000);
			}else{
				document.getElementById("dialog_order_button_wx").style.visibility="hidden";
				document.getElementById("dialog_remove_button_wx").style.visibility="hidden";
				document.getElementById("dialog_ordered_failed").style.visibility="visible";
				set_back_time();
			}
			if(document.getElementById("dialog_erweima").style.visibility=="visible"){
				document.getElementById("dialog_erweima").style.visibility="hidden";
				document.getElementById("qrcode").style.visibility="hidden";
				document.getElementById("Product_wx").style.visibility="hidden";
				document.getElementById("ProductPrice_wx").style.visibility="hidden";
				document.getElementById("ProductEndTime_wx").style.visibility="hidden";
			}
	　　},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			alert(XMLHttpRequest.status);
		},
	　　complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
	　　　　if(status=='timeout'){//超时,status还有success,error等值的情况
	　　　　　  alert("超时");
	　　　　}
	　　}
	});
}
function hideouttime(){
	document.getElementById("timeout_msg").style.visibility="hidden";
	focus_right_index();
}
function goonpay(){
	document.getElementById("weix_dialog_ordered_notice").style.visibility="hidden";
	document.getElementById("dialog_erweima").style.visibility="visible";
	document.getElementById("qrcode").style.visibility="visible";
	document.getElementById("dialog_order_button_wx").style.visibility="visible";
	document.getElementById("Product_wx").style.visibility="visible";
	document.getElementById("ProductPrice_wx").style.visibility="visible";
	document.getElementById("ProductEndTime_wx").style.visibility="visible";
}
function creatimg(imgurl){
	document.getElementById("qrcode").innerHTML="";
	document.getElementById("qrcode").style.visibility="visible";	  
	var qrcode = new QRCode(document.getElementById("qrcode"), {
		width : 200,
		height :200
	});
	qrcode.clear();
	qrcode.makeCode(imgurl);	
}	
function mykeypress(evt) { 
	var keyCode = parseInt(evt.which); 
	if (keyCode == 0x0028) { 
		pagingkeydown();
	}else if (keyCode == 0x000D) { 
		pagingkeyok();
	}else if(keyCode == 0x0027){ 
		pagingkeyright();
	}else if(keyCode == 0x0026){ 
		pagingkeyup();
	}else if(keyCode == 0x0025){ 
		pagingkeyleft();
	}else if(keyCode == 0x0300){ 
		vitur();
	}else if(keyCode ==<%=STBKeysNew.remoteMenu%>){ 
		showmainmenu();
	}else if(keyCode ==24 || keyCode == 0x0008){ 
			if(document.getElementById("dialog_erweima").style.visibility=="visible"){
				backFlag = 0;
				getorderresult();
			}else{
				doback();
			}
		}else { 
			top.doKeyPress(evt); 
		} 
		return false;
	} 
	//channel_product_arr
	
	

	</script>

	<script language="javascript" type="">
	  var mixNo =30; //目前从订购页返回后频道写死为21，北京电视台
	  //var mixNo =39; //从订购页返回39，大健康
	   function back()
		{
		 
			top.setDefaulchannelNo();
			var clist=top.allChannelList;
			var allChannell = new String(clist);
			top.channelInfo.lastChannel= mixNo;
			if(window.navigator.appName.indexOf("ztebw") >= 0){
				ztebw.setAttribute("curMixno", mixNo);
			}
			var lastChannelNum = top.channelInfo.lastChannel;
			if (lastChannelNum == null || lastChannelNum == "" || undefined == lastChannelNum || lastChannelNum < 0)
			{
				var list=null; 	
				var switchmode = parseInt(top.configPara["channelSwitchMode"]); 
				if(switchmode == 1) // in all channel list
				{
					list=top.allChannelList;
				}else { // in auth channel list
					list=top.channelList; 
				} 
				var allChannel = new String(list);
				var firstChannel = allChannel.split(",")[0]; 
			
				lastChannelNum = firstChannel;
			}
//	alert("top.channelInfo.lastChannel"+top.channelInfo.lastChannel);
			 //top.doStop();
              top.jsRedirectChannel(mixNo); 
		}

		function showmainmenu(){
            back();
            top.vodBackTimer = top.setTimeout("top.mainWin.document.location='<%=timeFrameUrl%>/portal.jsp';top.showOSD(2, 0, 25);top.setBwAlpha(0);",600);

		}

	function doback(){
			if(ajaxTimeoutTest){
				ajaxTimeoutTest.abort();
			}
		/*if(document.getElementById("channelorder_poster").style.visibility=="visible"){
			document.getElementById("channelorder_poster").style.visibility="hidden";
			return;
		}*/
		back();
		
		top.vodBackTimer = top.setTimeout("top.mainWin.document.location='<%=timeFrameUrl%>/back.jsp';top.showOSD(2, 0, 25);top.setBwAlpha(0);",600);
	
	}

	focus();
	
	//var channel_no= top.channelInfo.currentChannel;//获取当前频道号
	
	/*if(channel_order_rec==0){
		//订购页底图
		//document.getElementById("chanorder_bg").src = "images/order/"+ channel_order_bg[0].info_pic;
		for(var i=0;i<channel_order_bg.length;i++){
			if(channel_order_bg[i].channel_id==channel_no){
				document.getElementById("chanorder_bg").src = "images/order/"+ channel_order_bg[i].info_pic;
				break;
			}else{
				document.getElementById("chanorder_bg").src = "images/order/"+ channel_order_bg[0].info_pic;
			}
		}
		
		//右下角推荐小图
		document.getElementById("recommend_img").style.visibility = "visible";
		//document.getElementById("recommend_icon").src = "images/advert/"+ channel_order_icon[0].info_pic;
		for(var i=0;i<channel_order_icon.length;i++){
			if(channel_order_icon[i].channel_id==channel_no){
				document.getElementById("recommend_icon").src = "images/advert/"+ channel_order_icon[i].info_pic;
				break;
			}else{
				document.getElementById("recommend_icon").src = "images/advert/"+ channel_order_icon[0].info_pic;
			}
		}
		//推荐海报图片
		//document.getElementById("channelorder_pcon").src = "images/advert/"+ channel_order_poster[0].info_pic;
		for(var i=0;i<channel_order_poster.length;i++){
			if(channel_order_poster[i].channel_id==channel_no){
				document.getElementById("channelorder_pcon").src = "images/advert/"+ channel_order_poster[i].info_pic;
				break;
			}else{
				document.getElementById("channelorder_pcon").src = "images/advert/"+ channel_order_poster[0].info_pic;
			}
		}
	}*/
	
</script>

<%@include file="inc/lastfocus_order.jsp"%>

<%@include file="inc/time_order.jsp" %>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript" src="js/qrcode.min.js"></script>
<script type="text/javascript" src="js/jquery.min.js"></script>
</body>
</html>

