<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false" %>
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="net.sf.json.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/words.jsp" %>
<%@ include file="inc/ad_utils.jsp" %>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="expires" content="0"/>
<epg:PageController name="poster_auth_orderlist.jsp"/>
<%!
    public String getDetailPrice(String price) {
        String temp = price + "";
        int index = temp.indexOf(".");
        if (index < 0) {
            temp += ".00";
        } else if (index == temp.length() - 1) {
            temp += "00";
        } else if (index == 0) {
            temp = "0" + temp;
        } else if (index == temp.length() - 2) {
            temp += "0";
        } else if (index < temp.length() - 2) {
            temp = temp.substring(0, index + 3);
        }
        return temp;
    }

    public String format(String price, String rate) {
        double priceInt = Double.valueOf(price);
        double rateInt = Double.valueOf(rate);
        double pricedb = (double) (priceInt / rateInt);
        String priceStr = String.valueOf(pricedb);
        if (priceStr.endsWith(".0")) {
            priceStr = priceStr.substring(0, priceStr.length() - 2);
        }
        return priceStr;
    }
%>
<%
    String from = request.getParameter("from");
    String timeFrameUrl = request.getParameter("timeFrameUrl");
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String columnCode = String.valueOf(param.get("Fathercolumnlist"));
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();//获取用户账号
%>
<html>
<head>
    <title>海报订购</title>
    <style>
        /*机顶盒账号*/
        * {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        body {
            width: 1280px;
            height: 720px;
        }

        .font_24 {
            color: #ffffff;
            font-size: 24px;
        }

        .order_bg {
            width: 1280px;
            height: 720px;
            position: absolute;
            top: 0px;
            left: 0px;
        }

        .area0 {
            width: 1280px;
            position: absolute;
            top: 349px;
            left: 20px;
        }

        .area0_0 {
            position: absolute;
            width: 35px;
            height: 50px;
            top: 15px;
            left: 20px;
        }

        .area0_1 {
            position: absolute;
            left: 1185px;
            top: 15px;
            width: 35px;
            height: 50px;
        }

        .area1 {
            height: 80px;
            position: absolute;
            top: 341px;
            left: -10px;
            box-sizing: border-box;
        }

        #selectdImg1_1 {
            visibility: hidden;
        }

        .area1_0, .area1_1, .area1_2, .area1_3, .area1_4 {
            width: 257px;
            height: 98px;
            position: absolute;
            top: 0px;
            left: 95px;
        }

        .area1_1 {
            left: 378px;
        }

        .area1 img{
            position: absolute;
            width: 257px;
            height: 98px;
            top: 0px;
            left: 0px;
        }
        .hide{
            visibility: hidden;
        }
        .show{
            visibility: visible;
        }

        .area1_2 {
            left: 664px;
        }

        #selectdImg1_2 {
            visibility: hidden;
            width: 257px;
            height: 98px;
            position: absolute;
            top: 0px;
            left: 0px;
        }

        .area1_3 {
            left: 950px;
        }

        #selectdImg1_3 {
            visibility: hidden;
            width: 257px;
            height: 98px;
            position: absolute;
            top: 0px;
            left: 0px;
        }

        .area1_4 {
            left: 982px;
        }

        .order_product_00 {
            width: 183px;
            height: 70px;
            /* border:2px sodivd red; */
            position: absolute;
        }

        .remark {
            color: #fff;
            font-size: 24px;
            position: absolute;
            top: 25px;
            left: 20px;
            font-weight: 600;
            z-index: 11;
        }

        .remark > b {
            color: #000;
        }


        .navFocus {
            visibility: visible;
        }

        .navBlur {
            visibility: hidden;
        }

        .area2 {
            position: absolute;
            top: 453px;
            left: 245px;
            width: 930px;
            /* border:2px solid red; */
            height: 30px;
        }

        #area2_0 {
            position: absolute;
            top: -10px;
            left: 880px;
            width: 61px;
            height: 53px;
        }

        .twoItemFocus {
            background: url('images/posterorder/selectdDown.png');
        }

        .twoItem {
            background: none;
        }

        #ordered {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 880px;
            font-size: 27px;
            color: #fff;
        }

        .downPoint {
            position: absolute;
            top: 17px;
            left: 12px;
        }

        #area3 {
            position: absolute;
            top: 522px;
            left: 60px;
            height: 53px;
        }

        #area3_0, #area3_1, #area3_2 {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 182px;
            height: 62px;
        }

        #area3_1 {
            left: 211px;
            width: 182px;
            height: 62px;
        }

        #area3_2 {
            left: 395px;
            width: 182px;
            height: 62px;
        }

        .threeItemFocus {
            background: url('images/posterorder/payFocus.png') no-repeat;
            width: 182px;
            height: 62px;
        }

        .threeItem {
            background: none;
        }

        .wechatPayment {
            position: absolute;
            top: 60px;
            left: 184px;
            z-index: 11;
            width: 912px;
            height: 585px;
            color: #fff;
            font-size: 26px;
            visibility: hidden;
        }

        .dialog_erweima {
            position: absolute;
            top: 0px;
            left: 0px;
            z-index: 11;
            width: 912px;
            height: 585px;
            visibility: hidden;
        }

        p {
            margin: 0px;
            padding: 0px;
        }

        .qrcode {
            position: absolute;
            top: 100px;
            left: 600px;
            width: 260px;
            height: 260px;

        }

        .wechatProductName {
            position: absolute;
            top: 20px;
            left: 125px;
            width: 365px;
            height: 32px;
        }

        .wechatProductPrice {
            position: absolute;
            top: 63px;
            left: 130px;
            width: 300px;
            height: 32px;
            line-height: 32px;
        }

        .wechatProductEndtime {
            position: absolute;
            top: 105px;
            left: 132px;
            width: 450px;
            height: 110px;
            line-height: 32px;
            font-size: 25px;
        }

        .area4 {
            position: absolute;
            top: 442px;
            height: 50px;
            width: 181px;
            left: 275px;
        }

        .area4_0 {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 181px;
            height: 50px;
        }

        .area4_1 {
            position: absolute;
            top: 0px;
            left: 204px;
            width: 181px;
            height: 50px;
        }

        #area4_1 {
            position: absolute;
            top: 0px;
            left: 204px;
            width: 181px;
            height: 50px;
        }

        .fourItemFocus {
            visibility: visible;
        }

        .fourItem {
            visibility: hidden;
        }

        .weix_dialog_ordered {
            width: 551px;
            height: 235px;
            position: absolute;
            top: 183px;
            left: 191px;
            z-index: 12;
            visibility: hidden;
        }

        .weix_dialog_ordered_all {
            width: 551px;
            height: 235px;
            position: absolute;
            top: 183px;
            left: 191px;
            z-index: 12;
            visibility: hidden;
        }

        .weix_dialog_ordered_failed {
            width: 551px;
            height: 235px;
            position: absolute;
            top: 183px;
            left: 191px;
            z-index: 12;
            visibility: hidden;
        }

        .weix_dialog_noordered {
            width: 551px;
            height: 235px;
            position: absolute;
            top: 183px;
            left: 191px;
            z-index: 12;
            visibility: hidden;
            box-shadow: 0px 0px 10px red;
        }

        /* 宽带支付 */
        .broadbandPayment {
            position: absolute;
            top: 207px;
            left: 222px;
            z-index: 11;
            width: 837px;
            height: 306px;
            color: #fff;
            font-size: 26px;
            /* visibility: hidden; */
        }

        .dialog_order {
            position: absolute;
            top: 0px;
            left: 0px;
            z-index: 11;
            width: 837px;
            height: 306px;
            visibility: hidden;
        }

        .broadbandProductName {
            position: absolute;
            top: 10px;
            left: 125px;
            width: 365px;
            height: 32px;
        }

        .broadbandProductPrice {
            position: absolute;
            top: 58px;
            left: 130px;
            width: 300px;
            height: 32px;
            line-height: 32px;
        }

        .broadbandProductEndtime {
            position: absolute;
            top: 100px;
            left: 132px;
            width: 455px;
            height: 64px;
            line-height: 32px;
        }

        .area5 {
            position: absolute;
            top: 234px;
            height: 50px;
            width: 181px;
            left: 146px;
        }

        .area5_0 {
            position: absolute;
            top: 0px;
            left: 0px;
            width: 181px;
            height: 50px;
        }

        .area5_1 {
            position: absolute;
            top: 0px;
            left: 352px;
            width: 181px;
            height: 50px;
        }

        #area5_1 {
            position: absolute;
            top: 0px;
            left: 352px;
            width: 181px;
            height: 50px;
        }

        .fiveItemFocus {
            visibility: visible;
        }

        .fiveItem {
            visibility: hidden;
        }

        /* <!--订购成功单次--> */
        .dialog_ordered {
            position: absolute;
            top: 165px;
            left: 152px;
            width: 623px;
            height: 254px;
            z-index: 12;
            visibility: hidden;
            /* border:1px solid red; */

        }

        .dialog_ordered_all {
            position: absolute;
            top: 26px;
            left: 107px;
            width: 623px;
            height: 254px;
            z-index: 12;
            visibility: hidden;
        }

        .dialog_ordered_failed {
            position: absolute;
            top: 28px;
            left: 114px;
            width: 609px;
            height: 205px;
            z-index: 12;
            visibility: hidden;
        }
    </style>
</head>
<!--进入直接初始化-->
<body bgcolor="transparent" onLoad="init()">
<!--背景图信息-->
<div id="order_bg" class='order_bg'>
    <img id = "bg" src="images/posterorder/orderPoster.jpg" width="1280" height="720">
</div>
<!--翻页箭头-->
<div id="area0" class='area0'>
    <div class='area0_0  navBlur'>
        <img id="area0_0" src="images/posterorder/leftPoint.png" alt="0">
    </div>
    <div class='area0_1 navBlur'>
        <img id="area0_1" src="images/posterorder/rightPoint.png" alt="1">
    </div>
</div>
<!--可订购产品显示-->
<div class="area1" id='area1'>
    <div class='area1_0 item'>
        <img id='img1_0' src="images/posterorder/orderProductBg0.png" alt="0">
        <img id='selectdImg1_0' src="images/posterorder/selectdFocus0.png"  alt="0">
        <img class="hide" id='area1_0' src="images/posterorder/movedFocus.png"  alt="0">
    </div>
    <div class='area1_1 item'>
        <img id='img1_1' src="images/posterorder/orderProductBg1.png" alt="0">
        <img id='selectdImg1_1' src="images/posterorder/selectdFocus1.png"  alt="0">
        <img class="hide" id='area1_1' src="images/posterorder/movedFocus.png"  alt="0">
    </div>
    <%--<div class='area1_2 item'>
        <img id='area1_2' src="images/posterorder/orderProductBg.png" alt="0">
        <img src="images/posterorder/selectdFocus.png" id='selectdImg1_2' alt="0">
        <p class='remark'>

            <b></b>
        </p>
    </div>--%>
    <%--<div class='area1_3 item'>
        <img id='area1_3' src="images/posterorder/orderProductBg.png" alt="0">
        <img src="images/posterorder/selectdFocus.png" id='selectdImg1_3' alt="0">
        <p class='remark'>
            半年
            <b>199元</b>
        </p>
    </div>--%>
</div>
<!--已经订购产品显示-->
<div id="area2" class='area2'>
    <div class="area2_0 twoItem" id='area2_0'>
        <img class='downPoint' src="images/posterorder/downPoint.png" alt="0">
    </div>
    <div id="ordered">
    </div>
</div>
<!--订购方式按钮-->
<div id="area3" class='area3'>
    <div class="area3_0 threeItem">
        <img id="area3_0" src="images/posterorder/allPay_wx.png" alt="0">
    </div>
    <div class="area3_1 threeItem">
        <img id="area3_1" src="images/posterorder/allGoBack.png" alt="0">
    </div>
</div>
<!--微信支付订购二维码显示-->
<div id="wechatPayment" class="wechatPayment">
    <!--订购二维码显示-->
    <div id="dialog_erweima" class='dialog_erweima'>
        <img src="images/posterorder/dialog_ordered.png" id='erweima_img' alt="0">
        <p id='qrcode' class='qrcode'></p>
        <p id='wechatProductName' class='wechatProductName'></p>
        <p id="wechatProductPrice" class='wechatProductPrice'></p>
        <p id="wechatProductEndtime" class="wechatProductEndtime"></p>
        <div id="area4" class="area4">
            <div id="area4_0" class="area4_0 fourItem">
                <img src="images/posterorder/weix_dialog_focus.png" alt="">
            </div>
            <div id="area4_1" class="area4_1 fourItem">
                <img src="images/posterorder/weix_dialog_focus.png" alt="">
            </div>
        </div>
    </div>
    <!--微信订购成功单次-->
    <div id="weix_dialog_ordered" class='weix_dialog_ordered success'>
        <img src="images/posterorder/weix_ordered.png" alt="0">
    </div>
    <!--微信订购成功包月-->
    <div id="weix_dialog_ordered_all" class='weix_dialog_ordered_all success'>
        <img src="images/posterorder/weix_ordered.png" alt="0">
    </div>
    <!--微信订购失败-->
    <div id="weix_dialog_ordered_failed" class='weix_dialog_ordered_failed success'>
        <img src="images/posterorder/weix_ordered_failed.png" alt="0">
    </div>
    <!--微信订购未支付提示-->
    <div id="weix_dialog_noordered" class='weix_dialog_noordered success'>
        <img src="images/posterorder/weix_ordered_notice.png" alt="0">
    </div>
</div>
<!--宽带支付--->
<div id="broadbandPayment" class="broadbandPayment">
    <div id="dialog_order" class='dialog_order'>
        <img src="images/posterorder/dialog_order_all.png" alt="0" id='broadbandPanel'>
        <div id="area5" class="area5">
            <div id="area5_0" class="area5_0 fiveItem">
                <img src="images/posterorder/weix_dialog_focus.png" alt="0">
            </div>
            <div id="area5_1" class="area5_1 fiveItem">
                <img src="images/posterorder/weix_dialog_focus.png" alt="0">
            </div>
        </div>
    </div>
    <!--订购成功单次-->
    <div id="dialog_ordered" class="dialog_ordered success">
        <img src="images/posterorder/dialog_ordered_dc.png" alt="0">
    </div>
    <!--订购成功包月-->
    <div id="dialog_ordered_all" class="dialog_ordered_all success">
        <img src="images/posterorder/dialog_ordered_all.png" alt="0">
    </div>
    <!--订购失败-->
    <div id="dialog_ordered_failed" class="dialog_ordered_failed success">
        <img src="images/posterorder/order_failed.png" alt="0">
    </div>
</div>
<div id="area6_0">
    <img src="images/btn_trans.png">
</div>

</body>
<script type="text/javascript" src="js/qrcode.min.js"></script>
<script type="text/javascript" src="js/focus_logic.js"></script>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script>
    var from = "<%=from%>";
    var _window = window;
    if (window.opener) {
        _window = window.opener;
    }
    var area0, area1, area2, area3, area4, area5,area6;
    var userToken = "QTUKE5AEyoiIr!pfVpwPuSzM8Bdb$J3Y";
    var productList = ["100416","100414"];
    var powerResult,orderResult,erweimaResult,choice,ret,istart = 0;
    var ditch = 6;
    var wxtimeout,ordered,curDomIndex = 0;
    var pageCount,totalNumber,currentPage = 1,currentNumber = 3;//总页数，总个数,当前页，每页个数

    function init() {
        appraisePower();
        loadElements();
        setAreaEvent();

    }

    /*鉴权*/
    function appraisePower() {
        focus_logic.getDataByAjax("httpPosttest.jsp?userToken=" + userToken + "&ProductID=" +
            productList + "&timeStamp=" + timeStamp + "&falg=1", getPowerResult);

    }
    function getInter(){
        document.getElementById("area0").style.display="none";
        document.getElementById("area1").style.display="none";
        document.getElementById("area2").style.display="none";
        document.getElementById("area3").style.display="none";
        if(powerResult["ProductID"] == "100414"){
            document.getElementById("bg").src = "images/posterorder/orderPoster_success_30.jpg";
        }else if(powerResult["ProductID"] == "100416"){
            document.getElementById("bg").src = "images/posterorder/orderPoster_success_365.jpg";
        }else{
            document.getElementById("bg").src = "images/posterorder/orderPoster_success.jpg";
        }
        focus_logic.page.setCurrentFocus(6, 0);
    }
    /*已订购产品显示*/
    function onOrder() {
        choice = powerResult["ProductList"][curDomIndex+istart]; //当前选中产品
        totalNumber = choice["subProductList"].length;  //总个数赋值
        //总页数赋值
        if(totalNumber%currentNumber == 0){
            pageCount = (parseInt(totalNumber/currentNumber));
        }else{
            pageCount = (parseInt(totalNumber/currentNumber+1));
        }
        //已订购产品布数据
        document.getElementById("ordered").innerHTML = "";
        for (var pro = (currentPage-1)*currentNumber; pro < totalNumber && pro < currentPage*currentNumber; pro++){
            if(pro == (currentPage-1)*currentNumber){
                ordered = choice["subProductList"][pro].ProductName;
                document.getElementById("ordered").innerHTML = ordered;
            }else{
                ordered = ordered + "、" + choice["subProductList"][pro].ProductName;
                document.getElementById("ordered").innerHTML = ordered;
            }
        }
        //翻页箭头是否显示

        /*if((4 + istart) < powerResult["ProductList"].length){
            document.getElementById("area0_1").className = "navFocus";
        }else{
            document.getElementById("area0_1").className = "navBlur";
        }
        if(istart > 0){
            document.getElementById("area0_0").className = "navFocus";
        }else{
            document.getElementById("area0_0").className = "navBlur";
        }*/
    }
    /*鉴权回调*/
    function getPowerResult(response) {
        powerResult = eval("(" + response + ")");
        /*========================================*/
        if(powerResult["Result"] == 0){
            getInter();
        } else if(powerResult["Result"] == "9201"){
            onOrder();
        }else{
            getInter();
        }
    }
    /*焦点移动*/
    function loadElements() {
        /*定义区域焦点逻辑*/
        area0 = focus_logic.loadElements(1, 2, "area0_", "navFocus", "navBlur", [-1, -1, -1, -1]);
        if(totalNumber > 0){
            area1 = focus_logic.loadElements(1, 2, "area1_", "show", "hide", [-1, -1, 2, -1]);
            area2 = focus_logic.loadElements(1, 1, "area2_", "twoItemFocus", "twoItem", [1, -1, 3, -1]);
            area3 = focus_logic.loadElements(1, 2, "area3_", "threeItemFocus", "threeItem", [2, -1, -1, -1]);
            focus_logic.page.setAreaMembership(1,2);
        }else{
            area1 = focus_logic.loadElements(1, 2, "area1_", "show", "hide", [-1, -1, 3, -1]);
            area2 = focus_logic.loadElements(1, 1, "area2_", "twoItemFocus", "twoItem", [1, -1, 3, -1]);
            area3 = focus_logic.loadElements(1, 2, "area3_", "threeItemFocus", "threeItem", [1, -1, -1, -1]);
            focus_logic.page.setAreaMembership(1,3);
        }
        area4 = focus_logic.loadElements(1, 2, 'area4_', 'fourItenFocus', "fourItem", [-1, -1, -1, -1]);
        area5 = focus_logic.loadElements(1, 2, 'area5_', 'fiveItenFocus', "fiveItem", [-1, -1, -1, -1]);
        area6 = focus_logic.loadElements(1, 1, "area6_", "navFocus", "navBlur", [-1, -1, -1, -1]);
        /*moveRule单独定义此dom的移动规则 [1, 0]:1区域第0个位置,dom对象获得焦点事件*/

        /*area3.doms[0].moveRule = [2, [3, 2], -1, [3, 1]];
        area3.doms[2].moveRule = [2, [3, 1], -1, [3, 0]];*/
        //设置默认焦点
        focus_logic.page.setCurrentFocus(1, 0);
    }

    /*焦点事件*/
    function setAreaEvent() {
        //返回按钮
        focus_logic.page.backEvent = function () {
            if(from == "channel"){
                top.jsRedirectChannel(30);
                top.vodBackTimer = top.setTimeout("top.mainWin.document.location='<%=timeFrameUrl%>/portal.jsp';top.showOSD(2, 0, 25);top.setBwAlpha(0);",600);
            }else{
                _window.top.mainWin.document.location = "back.jsp";
            }
        }

        //产品翻页
       /* area0.focusEvent = function() {

            var curDom = area0.curDomIndex;

            if (curDom == 1 && (4 + istart) < powerResult["ProductList"].length && focus_logic.page.Adirection == 3) {
                istart++;
                var remark = document.getElementsByClassName('remark');
                for (var re = 0; re < remark.length; re++) {

                    var product = powerResult["ProductList"][re + istart];
                        remark[re].innerHTML = product.ProductName + "<b>" + product.Fee / 100 + "元</b>";
                }
            } else if (curDom == 0 && istart > 0 && focus_logic.page.Adirection == 1) {
                istart--;
                var remark = document.getElementsByClassName('remark');
                for (var re = 0; re < remark.length; re++) {

                    var product = powerResult["ProductList"][re + istart];
                    remark[re].innerHTML = product.ProductName + "<b>" + product.Fee / 100 + "元</b>";
                }
            }
            if(focus_logic.page.Adirection == 3){
                focus_logic.page.setCurrentFocus(1, 3);

            }else{
                focus_logic.page.setCurrentFocus(1, 0);

            }
            onOrder();
        }*/

        //选择产品
        area1.focusEvent = function(){
            //将选择的产品的信息放入choice中
            curDomIndex = area1.curDomIndex;
            currentPage = 1;
            onOrder();

            //改变选中区域的样式
            for(var i = 0; i < 2; i++){
                if(i == area1.curDomIndex){
                    document.getElementById("selectdImg1_"+i).style.visibility="visible";
                    document.getElementById("orderProductBg0"+i).style.visibility="hide";
                }else{
                    document.getElementById("selectdImg1_"+i).style.visibility="hidden";
                    document.getElementById("orderProductBg1"+i).style.visibility="visible";
                }
            }
        }

        //已订购产品展示翻页
        area2.okEvent = function (){
            if(currentPage < pageCount){
                currentPage++;
            }else{
                currentPage = 1;
            }
            onOrder();
        }
        //支付
        area3.okEvent = function () {
            //0、微信支付    1、宽带支付
            /*if(area3.curDomIndex == 1){
                broadband();
            }else */if(area3.curDomIndex == 0){
                weixin();
            }else{
                if(from == "channel"){
                    top.jsRedirectChannel(30);
                    top.vodBackTimer = top.setTimeout("top.mainWin.document.location='<%=timeFrameUrl%>/portal.jsp';top.showOSD(2, 0, 25);top.setBwAlpha(0);",600);
                }else{
                    _window.top.mainWin.document.location = "back.jsp";
                }
            }
        }
        //微信支付页按钮
        area4.okEvent = function(){
            if(area4.curDomIndex == 0){
                ret = 4;
                weixinchaxun();
            }else if(area4.curDomIndex == 1){
                document.getElementById("wechatPayment").style.visibility="hidden";
                document.getElementById("dialog_erweima").style.visibility="hidden";
                focus_logic.page.setCurrentFocus(3, 0);
            }
        }
        //返回
        area4.backEvent = function(){
            document.getElementById("wechatPayment").style.visibility="hidden";
            document.getElementById("dialog_erweima").style.visibility="hidden";
            focus_logic.page.setCurrentFocus(3, 0);
        }
        //宽带支付
        area5.okEvent = function () {
            if(area5.curDomIndex == 0){
                ret = 5;
                getOrder();

            }else if(area5.curDomIndex == 1){
                document.getElementById("dialog_order").style.visibility="hidden";
                focus_logic.page.setCurrentFocus(3, 1);
            }
        }
    }
    //发起宽带订购请求
    function getOrder() {
        focus_logic.getDataByAjax("httpPosttest.jsp?TransactionID=" + powerResult['TransactionID'] + "&ditch=" + ditch + "&OrderType=" + choice.subFlag + "&upgradeSeq=" + choice.upgradeSeq + "&falg=2&userToken=" + userToken + "&ProductID=" + choice.ProductID + "&Action=1&upgradeType=1", getOrderResult);
    }
    //宽带订购回调
    function getOrderResult(response) {
        orderResult = eval("(" + response + ")");
        if(orderResult["Result"] == 0){
            document.getElementById("dialog_order").style.visibility="hidden";
            document.getElementById("dialog_ordered_all").style.visibility="visible";
            setTimeout(function () {
                document.getElementById("dialog_ordered_all").style.visibility="hidden";
            },5000);
            setTimeout(function () {
                getInter();
            },5000);

        }else{
            document.getElementById("dialog_order").style.visibility="hidden";
            document.getElementById("dialog_ordered_failed").style.visibility="visible";
            setTimeout(function () {
                document.getElementById("dialog_order").style.visibility="visible";
            },5000);
            setTimeout(function () {
                document.getElementById("dialog_ordered_failed").style.visibility="hidden";
            },5000);
            //hideAlert("dialog_ordered_failed");

        }

    }
    //二维码获取返回操作
    function getErweimaResult(response) {
        erweimaResult = eval("(" + response + ")");
        var imgurl = erweimaResult.code_url;
        //将二维码路径转为图片
        creatimg(imgurl);

    }
    //二维码路径转为图片，并放到指定位置
    function creatimg(imgurl){
        document.getElementById("qrcode").innerHTML="";
        var qrcode = new QRCode(document.getElementById("qrcode"), {
            width : 262,
            height :262
        });
        qrcode.clear();
        qrcode.makeCode(imgurl);
    }
    //宽带支付，拉起宽带支付页面
    function broadband() {
        document.getElementById("dialog_order").style.visibility="visible";
        focus_logic.page.setCurrentFocus(5, 0);
    }
    //微信支付，拉起微信支付页面
    function weixin() {
        document.getElementById("wechatPayment").style.visibility="visible";
        document.getElementById("dialog_erweima").style.visibility="visible";

        document.getElementById("wechatProductName").innerHTML=choice.ProductName;
        document.getElementById("wechatProductPrice").innerHTML=choice.Fee/100+"元";
        var date = new Date();
        var term = date.getTime() + choice.RentalTerm * 1000;
        if(choice.upgradeTime != undefined){
            term += choice.upgradeTime * 3600 * 1000;
        }
        var newDate = new Date(term);
        var month = newDate.getMonth() +1;

        var lookDate = newDate.getFullYear() + "年" + checkTime(month) + "月" + checkTime(newDate.getDate()) + "日 " + checkTime(newDate.getHours()) + ":" + checkTime(newDate.getMinutes()) + ":" + checkTime(newDate.getSeconds());

        if(choice.upgradeTime > 0){
            var conDay = parseInt(choice.upgradeTime / 24);
            var conHou = parseInt(choice.upgradeTime % 24);
            document.getElementById("wechatProductEndtime").innerHTML="&nbsp;&nbsp;&nbsp;自订购成功起至"+lookDate+"期间内有效（含此前您已付费购买的产品自动折算的"+conDay+"日"+conHou+"小时使用权）";
        }else if(choice.RentalTerm < 0){
            document.getElementById("wechatProductEndtime").innerHTML="&nbsp;&nbsp;&nbsp;自然月";
        }else{
            document.getElementById("wechatProductEndtime").innerHTML="&nbsp;&nbsp;&nbsp;自订购成功起至"+lookDate+"期间内有效";
        }

        focus_logic.page.setCurrentFocus(4, 0);

        getErweima();

    }
    //发起请求获取二维码
    function getErweima() {
        focus_logic.getDataByAjax("httpPosttest.jsp?TransactionID=" + powerResult['TransactionID'] +
            "&ditch=" + ditch + "&OrderType=" + choice.subFlag + "&upgradeSeq=" + choice.upgradeSeq + "&falg=3&userToken=" + userToken + "&ProductID=" + choice.ProductID + "&Action=1&upgradeType=1", getErweimaResult);
    }

    //微信支付后的查询支付结果
    function weixinchaxun(){
        wxtimeout = $.ajax({
            url: "http://210.13.0.139:8080/iptv_tpp/order/checkEpayOrderState?ditch="+ ditch +"&transactionID=" +
                erweimaResult['transactionID'] + "&productID=" + choice.ProductID + "&userID=" + erweimaResult['userID'],
            timeout: 1000, //超时时间设置，单位毫秒
            type: 'get',  //请求方式，get或post
            dataType: 'json',//返回的数据格式
            success: function (data) { //请求成功的回调函数
                if(data['return_code'] == 2){
                    document.getElementById("dialog_erweima").style.visibility="hidden";
                    document.getElementById("weix_dialog_noordered").style.visibility="visible";
                    setTimeout(function () {
                      document.getElementById("dialog_erweima").style.visibility="visible";
                    },5000);
                    setTimeout(function () {
                      document.getElementById("weix_dialog_noordered").style.visibility="hidden";
                    },5000);
                }else if(data['return_code'] == 1){
                    document.getElementById("dialog_erweima").style.visibility="hidden";
                    document.getElementById("weix_dialog_ordered_failed").style.visibility="visible";
                    setTimeout(function () {
                        document.getElementById("dialog_erweima").style.visibility="visible";
                    },5000);
                    setTimeout(function () {
                        document.getElementById("weix_dialog_ordered_failed").style.visibility="hidden";
                    },5000);
                }else if(data['return_code'] == 0){
                    document.getElementById("dialog_erweima").style.visibility="hidden";
                    document.getElementById("weix_dialog_ordered_all").style.visibility="visible";
                    setTimeout(function () {
                        document.getElementById("weix_dialog_ordered_all").style.visibility="hidden";
                    },5000);
                    powerResult["ProductID"] = choice.ProductID;
                    setTimeout(function () {
                        getInter();
                    },5000);
                }else{
                    document.getElementById("dialog_erweima").style.visibility="hidden";
                    document.getElementById("weix_dialog_ordered_failed").style.visibility="visible";
                    setTimeout(function () {
                        document.getElementById("dialog_erweima").style.visibility="visible";
                    },5000);
                    setTimeout(function () {
                        document.getElementById("weix_dialog_ordered_failed").style.visibility="hidden";
                    },5000);
                }
            }
        })
    }

    function checkTime(i){
        if(i<10){
            i="0"+i;
        }
        return i;
    }

</script>
</html>