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
<epg:PageController name="selfcare_record_ppv.jsp"/>
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
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String columnCode = String.valueOf(param.get("Fathercolumnlist"));

    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();//获取用户账号
%>

<html>
<head>
    <title>我的自服务</title>
    <style>
        /*机顶盒账号*/
        * {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .font_24 {
            color: #ffffff;
            font-size: 24px;
        }

        /*标题*/

        #tab {
            width: 1280px;
            height: 720px;
            position: relative;
            background: url(images/myrecord/bg.png) no-repeat;
            overflow: hidden;
        }

        /*  area0 左侧菜单栏 */
        #area0 {
            width: 218px;
            height: 268px;
            position: absolute;
            top: 97px;
            left: 57px;
            background: url(images/myrecord/left_bg.png) no-repeat;
        }

        /*左侧菜单每行样式*/
        #area0 .item {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
        }

        /*左侧菜单每行焦点*/
        #area0 .item_focus {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
            background: url(images/myrecord/focus_product.png);
        }

        /*左侧菜单每行焦点*/
        #area0 .item_selected_focus {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
            background: url(images/myrecord/blur_product.png);
        }

        /*当前有效产品样式*/
        .content {
            width: 1009px;
            height: 546px;
            position: absolute;
            top: 87px;
            left: 269px;
        }

        /* area1本月有效+area2包月退订背景图*/
        #area1, #area2 {
            width: 100%;
            height: 100%;
            background: url(images/myrecord/Thismonth_product.png);
        }

        /*本月有效每行样式*/
        #area1 .item {
            position: absolute;
            left: 13px;
            height: 86px;

            background: none;
        }

        /*本月有效焦点框*/
        #area1 .item_focus {
            position: absolute;
            left: 13px;
            width: 950px;
            height: 86px;
            background-image: url(images/myrecord/selectfocus.png);
        }

        /*本月有效上边栏样式*/
        #area1 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 16px;
        }

        /*本月有效上边栏字体样式*/
        #area1 .topTitle li {
            width: 183px;
            height: 40px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        /*本月有效内容样式*/
        #area1 .general {
            width: 152px;
            height: 60px;
            padding: 13px 16px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 30px;
            word-wrap: break-word;
        }

        /*本月有效内容样式*/
        #area1 .general span {
            float: none;
            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
        }

        /*包月退订每行样式*/

        #area2 .item {
            position: absolute;
            left: 13px;
        }

        /*包月退订焦点框*/
        #area2 .item_focus {
            position: absolute;
            left: 13px;
        }

        /*包月退订上边栏样式*/
        #area2 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 13px;
        }

        /*包月退订上边栏字体样式*/
        #area2 .topTitle li {
            width: 152px;
            height: 40px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        /*包月退订内容样式*/
        #area2 .general {
            width: 152px;
            height: 60px;
            padding: 13px 0px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 30px;
        }

        /*包月退订内容样式*/
        #area2 .general span {
            float: none;
            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
        }

        /*包月退订按钮背景图*/
        #area2 .item .returnbtn, #area2 .item_focus .returnbtn {
            width: 77px;
            height: 37px;
            position: absolute;
            top: 23px;
            left: 645px;
            background: url(images/myrecord/return.png);
        }

        /*包月退订每行样式背景为空*/
        #area2 .item img {
            display: none;
        }

        /*包月退订退订图片设置为块元素*/
        #area2 .item_focus img {
            display: block;
        }

        /*包月产品说明*/
        #area2 .product_descrip {
            position: absolute;
            top: 460px;
            height: 66px;
            color: #FFF;
            font-size: 18px;
            line-height: 22px;
        }

        /* area3 历史订购详情*/
        #area3 {
            width: 100%;
            height: 100%;
            background: url(images/myrecord/history_details.png);
        }

        #area3 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 16px;
        }

        #area3 .topTitle .item {
            width: 185px;
            height: 46px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
            background: none;
        }

        #area3 .topTitle .item_focus {
            width: 185px;
            height: 46px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
            background: url(images/myrecord/historyFocus.png);
        }

        #area3 .general span {
            float: none;

            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
        }

        #area4 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 16px;
        }

        #area4 .topTitle li {
            width: 183px;
            height: 40px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        #area4 .item {
            position: absolute;
            left: 13px;
            height: 86px;
            background: none;
        }

        /*数字键盘焦点*/
        #area4 .item_focus {
            position: absolute;
            left: 13px;
            width: 950px;
            height: 86px;
            background-image: url(images/myrecord/selectfocus.png);
        }

        /*红色警告提示文字*/
        #area4 .general {
            width: 165px;
            height: 60px;
            padding: 13px 10px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 30px;
            word-wrap: break-word;
        }

        #area4 .general span {
            float: none;
            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
            white-space: nowrap;
        }

        /* area5  产品退订二次提示页*/
        #area5 {
            position: absolute;
            width: 609px;
            height: 250px;
            left: 345px;
            top: 221px;
            background-image: url(images/myrecord/dialog_subscribe.png);
            display: none;
        }

        #area5 .item {
            position: absolute;
            width: 158px;
            height: 44px;
            top: 186px;
            display: none;
        }

        #area5 .item_focus {
            position: absolute;
            width: 158px;
            height: 44px;
            top: 186px;
            display: block;
        }

        /*滚动条显示*/
        #scrollbar1, #scrollbar2, #scrollbar3 {
            display: block;
        }

        /*上一页、下一页*/
        #area1 .pageico, #area2 .pageico, #area3 .pageico {
            position: absolute;
            top: 584px;
            left: 194px;
        }

        /* area6 兑换码背景图*/
        #area6 {
            position: absolute;
            top: -87px;
            left: -268px;
            width: 1280px;
            height: 720px;
            background: url(images/myrecord/redeembg.png);
        }

        #area6 .numtop {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 158px;
        }

        #area6 .numtop .item {
            width: 356px;
            height: 44px;
            position: absolute;
            top: 160px;
            font-size: 22px;
            line-height: 73px;
        }

        #area6 .numtop .item_focus {
            width: 412px;
            height: 78px;
            position: absolute;
            top: 158px;
            font-size: 22px;
        }

        /*激活码输入框内文字*/
        #area6 .numtop #area6_0 {
            left: 206px;
            vertical-align: middle;
            font-size: 26px;
            font-style: normal;
            font-weight: normal;
            outline: none;
            line-height: 73px;
            color: #fff;
            text-shadow: none;
            text-indent: 0.5em;

        }


        /*数字*/
        #area7 .numbutton {
            width: 76px;
            height: 54px;
            position: absolute;
            left: 180px;
        }

        #area7 .numbutton li {
            width: 76px;
            height: 54px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        #area7 .item {
            position: absolute;
            left: 181px;
            background: none;
        }

        /*数字键盘焦点*/
        #area7 .item_focus {
            position: absolute;
            left: 181px;
            background-image: url(images/myrecord/numfocus.png);
        }

        /*红色警告提示文字*/
        #alert_text {
            position: absolute;
            width: 269px;
            height: 37px;
            left: 367px;
            top: 249px;
            font-size: 20px;
            font-family: 方正黑体;
            font-style: normal;
            font-weight: bold;
            line-height: 37px;
            visibility: hidden;
        }
    </style>
</head>

<%--进入直接初始化--%>
<body bgcolor="transparent" onLoad="init()">

<div id="tab">
    <!--顶部信息-->
    <div style="position:absolute; width:53; height:36; left:55px; top:16px;">
        <img src="images/search/icon_5.png" border="0">
    </div>
    <div id="path"
         style="position:absolute; width:760px; height:30px; left:110px; top:25px;font-size:24px;color:#FFFFFF">
        应用 > 我的自服务
    </div>
    <div id="userID" style="position: absolute; width: 392px; height: 30px; left: 875px; top: 25px;"
         class="font_24"></div>
    <%--左侧菜单--%>
    <ul id="area0">
        <li class="item_focus" id="area0_0">当前有效产品</li>
        <li class="item" id="area0_1">包月产品退订</li>
        <li class="item" id="area0_2">历史订购详情</li>
        <li class="item" id="area0_3">兑换码</li>
    </ul>
    <%--右侧菜单--%>
    <div class="content">
        <%--本月有效产品--%>
        <div id="area1" style="display: block;">
            <%--本月有效产品展示选项卡--%>
            <ul class="topTitle">
                <li>产品名称</li>
                <li>产品价格</li>
                <li>订购时间</li>
                <li>支付类型</li>
                <li>有效期至</li>
            </ul>
            <%--产品展示--%>
            <ul class="item" id="area1_0" style="top: 56px;">
                <li class="general"><span id="name1_0"></span><span id="content1_0"></span></li>
                <li class="general"><span id="price1_0"></span><span id="saleprice1_0"></span></li>
                <li class="general" id="beginTime1_0"></li>
                <li class="general" id="payType1_0"></li>
                <li class="general" id="endTime1_0"></li>
            </ul>
            <ul class="item" id="area1_1" style="top: 135px;">
                <li class="general"><span id="name1_1"></span><span id="content1_1"></span></li>
                <li class="general"><span id="price1_1"></span><span id="saleprice1_1"></span></li>
                <li class="general" id="beginTime1_1"></li>
                <li class="general" id="payType1_1"></li>
                <li class="general" id="endTime1_1"></li>
            </ul>
            <ul class="item" id="area1_2" style="top: 215px;">
                <li class="general"><span id="name1_2"></span><span id="content1_2"></span></li>
                <li class="general"><span id="price1_2"></span><span id="saleprice1_2"></span></li>
                <li class="general" id="beginTime1_2"></li>
                <li class="general" id="payType1_2"></li>
                <li class="general" id="endTime1_2"></li>
            </ul>
            <ul class="item" id="area1_3" style="top: 295px;">
                <li class="general"><span id="name1_3"></span><span id="content1_3"></span></li>
                <li class="general"><span id="price1_3"></span><span id="saleprice1_3"></span></li>
                <li class="general" id="beginTime1_3"></li>
                <li class="general" id="payType1_3"></li>
                <li class="general" id="endTime1_3"></li>
            </ul>
            <ul class="item" id="area1_4" style="top: 375px;">
                <li class="general"><span id="name1_4"></span><span id="content1_4"></span></li>
                <li class="general"><span id="price1_4"></span><span id="saleprice1_4"></span></li>
                <li class="general" id="beginTime1_4"></li>
                <li class="general" id="payType1_4"></li>
                <li class="general" id="endTime1_4"></li>
            </ul>
            <ul class="item" id="area1_5" style="top: 453px;">
                <li class="general"><span id="name1_5"></span><span id="content1_5"></span></li>
                <li class="general"><span id="price1_5"></span><span id="saleprice1_5"></span></li>
                <li class="general" id="beginTime1_5"></li>
                <li class="general" id="payType1_5"></li>
                <li class="general" id="endTime1_5"></li>
            </ul>
            <!--上一页、下一页图片-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <%--包月产品退订--%>
        <div id="area2" style="display: none;">
            <%--包月产品选项卡--%>
            <ul class="topTitle">
                <li>产品名称</li>
                <li>产品价格</li>
                <li>订购时间</li>
                <li>有效期至</li>
                <li>退订按钮</li>
                <li>产品备注</li>
            </ul>
            <%--包月产品展示--%>
            <ul class="item" id="area2_0" style="top: 54px;">
                <li class="general"><span id="name2_0"></span><span id="content2_0"></span></li>
                <li class="general"><span id="price2_0"></span><span id="saleprice2_0"></span></li>
                <li class="general" id="beginTime2_0"></li>
                <li class="general" id="endTime2_0"></li>
                <%--退订焦点框--%>
                <li class="returnbtn">
                    <img src="images/myrecord/returnfoce.png" width="77" height="37"/>
                </li>
                <li class="general" id="remark2_0"
                    style="left:745px;position:absolute; line-height:30px; width:200px;"></li>
            </ul>
            <ul class="item" id="area2_1" style="top: 135px;">
                <li class="general"><span id="name2_1"></span><span id="content2_1"></span></li>
                <li class="general"><span id="price2_1"></span><span id="saleprice2_1"></span></li>
                <li class="general" id="beginTime2_1"></li>
                <li class="general" id="endTime2_1"></li>
                <li class="returnbtn">
                    <img src="images/myrecord/returnfoce.png" width="77" height="37"/>
                </li>
                <li class="general" id="remark2_1"
                    style="left:745px;position:absolute; line-height:30px; width:200px;"></li>
            </ul>
            <ul class="item" id="area2_2" style="top: 217px;">
                <li class="general"><span id="name2_2"></span><span id="content2_2"></span></li>
                <li class="general"><span id="price2_2"></span><span id="saleprice2_2"></span></li>
                <li class="general" id="beginTime2_2"></li>
                <li class="general" id="endTime2_2"></li>
                <li class="returnbtn">
                    <img src="images/myrecord/returnfoce.png" width="77" height="37"/>
                </li>
                <li class="general" id="remark2_2"
                    style="left:745px;position:absolute; line-height:30px; width:200px; padding:13px 0px;"></li>
            </ul>
            <ul class="item" id="area2_3" style="top: 295px;">
                <li class="general"><span id="name2_3"></span><span id="content2_3"></span></li>
                <li class="general"><span id="price2_3"></span><span id="saleprice2_3"></span></li>
                <li class="general" id="beginTime2_3"></li>
                <li class="general" id="endTime2_3"></li>
                <li class="returnbtn">
                    <img src="images/myrecord/returnfoce.png" width="77" height="37"/>
                </li>
                <li class="general" id="remark2_3"
                    style="left:745px;position:absolute; line-height:30px; width:200px; padding:13px 0px;"></li>
            </ul>
            <ul class="item" id="area2_4" style="top: 373px;">
                <li class="general"><span id="name2_4"></span><span id="content2_4"></span></li>
                <li class="general"><span id="price2_4"></span><span id="saleprice2_4"></span></li>
                <li class="general" id="beginTime2_4"></li>
                <li class="general" id="endTime2_4"></li>
                <li class="returnbtn">
                    <img src="images/myrecord/returnfoce.png" width="77" height="37"/>
                </li>
                <li class="general" id="remark2_4"
                    style="left:745px;position:absolute; line-height:30px; width:200px; padding:13px 0px;"></li>
            </ul>
            <!-- 产品说明-->
            <div class="product_descrip" style="width:90px;left:20px;">产品说明：</div>
            <div class="product_descrip" style="width:845px;left:110px;">
                包月产品内容在有效期内可无限收看，订购首月按天计费。若无退订操作，本产品次月将自动续订。退订操作完成后，当月还可继续使用该包月产品，次月退订生效。该费用将随您的宽带上网费一同收取，包年宽带用户请于下月底前及时交费充值，以免造成欠费停机。
            </div>
            <!--上一页、下一页图片-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <%--历史订购详情--%>
        <div id="area3" style="display: none;">
            <ul class="topTitle">
                <li class="item" id="area3_0"></li>
                <li class="item" id="area3_1"></li>
                <li class="item" id="area3_2"></li>
                <li class="item" id="area3_3"></li>
                <li class="item" id="area3_4"></li>
            </ul>
            <div id="area4">
                <ul class="topTitle" style="top: 65px;">
                    <li>产品名称</li>
                    <li>产品价格</li>
                    <li>订购时间</li>
                    <li>支付类型</li>
                    <li>有效期至</li>
                </ul>
                <ul class="item" id="area4_0" style="top: 105px;">
                    <li class="general"><span id="name4_0"></span><span id="content4_0"></span></li>
                    <li class="general" id="price4_0"></li>
                    <li class="general" id="beginTime4_0"></li>
                    <li class="general" id="payType4_0"></li>
                    <li class="general" id="endTime4_0"></li>
                </ul>
                <ul class="item" id="area4_1" style="top: 190px;">
                    <li class="general"><span id="name4_1"></span><span id="content4_1"></span></li>
                    <li class="general" id="price4_1"></li>
                    <li class="general" id="beginTime4_1"></li>
                    <li class="general" id="payType4_1"></li>
                    <li class="general" id="endTime4_1"></li>
                </ul>
                <ul class="item" id="area4_2" style="top: 277px;">
                    <li class="general"><span id="name4_2"></span><span id="content4_2"></span></li>
                    <li class="general" id="price4_2"></li>
                    <li class="general" id="beginTime4_2"></li>
                    <li class="general" id="payType4_2"></li>
                    <li class="general" id="endTime4_2"></li>
                </ul>
                <ul class="item" id="area4_3" style="top: 360px;">
                    <li class="general"><span id="name4_3"></span><span id="content4_3"></span></li>
                    <li class="general" id="price4_3"></li>
                    <li class="general" id="beginTime4_3"></li>
                    <li class="general" id="payType4_3"></li>
                    <li class="general" id="endTime4_3"></li>
                </ul>
                <ul class="item" id="area4_4" style="top: 447px;">
                    <li class="general"><span id="name4_4"></span><span id="content4_4"></span></li>
                    <li class="general" id="price4_4"></li>
                    <li class="general" id="beginTime4_4"></li>
                    <li class="general" id="payType4_4"></li>
                    <li class="general" id="endTime4_4"></li>
                </ul>
            </div>
            <!--上一页、下一页图片-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <!-- area6 兑换码 -->
        <div id="area6" style="display: none;">
            <ul class="numtop">
                <!--输入框-->
                <li class="item" id="area6_0"></li>
                <!--删除-->
                <li class="item" id="area6_1" style="left:667px;width: 76px;"></li>
                <!--兑换-->
                <li class="item" id="area6_2" style="left:761px;top: 162px;width: 195px;"></li>
            </ul>
            <%--数字按钮--%>
            <div id="area7">
                <ul class="numbutton" style="top: 277px;">
                    <li class="item" id="area7_0"></li>
                    <li class="item" id="area7_1" style="left:285px"></li>
                    <li class="item" id="area7_2" style="left:388px"></li>
                    <li class="item" id="area7_3" style="left:497px"></li>
                    <li class="item" id="area7_4" style="left:601px"></li>
                </ul>
                <ul class="numbutton" style="top: 356px;">
                    <li class="item" id="area7_5"></li>
                    <li class="item" id="area7_6" style="left:285px"></li>
                    <li class="item" id="area7_7" style="left:388px"></li>
                    <li class="item" id="area7_8" style="left:497px"></li>
                    <li class="item" id="area7_9" style="left:601px"></li>
                </ul>
            </div>
        </div>
    </div>
    <!--Test
    <div id="area1_test"
         style="position:absolute;top:120px; left:10px; width:1000px; height:500px; color:red; font-size:32px; border:2px solid green; visibility:hidden;"></div>-->

    <!--兑换成功-->
    <div id="act_success" style="position:absolute; width:392px; height:262px; left:444px; top:248px; display:none;">
        <div style="position:absolute; width:392px; height:262px; left:0px; top:0px;"><img id="alertbox" src=""
                                                                                           width="392" height="262">
        </div>
    </div>
    <!--退订-->
    <div id="area5">
        <div class="item" id="area5_0" style="left:76px;"><img src="images/myrecord/price_onfocus.png" width="158"
                                                               height="44"></div>
        <div class="item" id="area5_1" style="left:372px;"><img src="images/myrecord/price_onfocus.png" width="158"
                                                                height="44"></div>
    </div>
    <%--退订功能--%>
    <iframe id="unorderIframe" name="unorderIframe" width="623" height="254"
            style="position:absolute; left: 321px; top: 284px; display:none; background-color:transparent;"
            allowtransparency="true"></iframe>
    <!--退订成功-->
    <div id="dialog_subscribe_success"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; display:none;">
        <div style="position:absolute; width:609px; height:250px; left:0px; top:0px;"><img
                src="images/myrecord/Unsubscribe_ok.png" width="609" height="250"></div>
    </div>
    <!--滚动条--->
    <div id="scrollbar" style="position:absolute; width:20px; height:404px; left:1240px; top:206px;">
        <div id="pageBar" style="position:absolute; width:20px; height:404px; left:0px; top:0px;visibility:hidden">
            <div style="position:absolute; width:20px; height:404px; left:0px; top:0px;">
                <img src="images/vod/btv-02-scrollbar.png" border="0" alt="" width="20" height="404">
            </div>
            <div id="scroll" style="position:absolute; width:13px; height:404px; left:3px; top:3px;">
                <img id="scrollbar1" src="images/vod/btv-02-scrollbar01.png" border="0" width="13" height="10">
                <img id="scrollbar2" src="images/vod/btv-02-scrollbar02.png" border="0" width="13" height="10">
                <img id="scrollbar3" src="images/vod/btv-02-scrollbar03.png" border="0" width="13" height="10">
            </div>
        </div>
    </div>
</div>
<script src="js/focus_logic.js"></script>
<script>
    function $(id) {
        return document.getElementById(id);
    }

    var _window = window;
    if (window.opener) {
        _window = window.opener;
    }
    var area0, area1, area2, area3, area4, area5, area6, area7;
    var areaxCurx, areaX;
    //本月有效、包月产品退订
    var data, orderdata;
    //历史订购详情
    var strLength = 6;//截取长度
    var curProductId, effectime;
    var phoneNum;
    //var myNumid = "area3_0";
    var butArr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
    var inputStr = "";

    var url = [
        "http://210.13.0.139:8080/iptv_tpp/order/getVisibleOrder?userID=",
        "http://210.13.0.139:8080/iptv_tpp/order/getCancelOrder?userID=",
        "http://210.13.0.139:8080/iptv_tpp/order/getHistoryOrder?userID="

    ];

    //初始化
    function init() {
        /*定义区域焦点逻辑*/
        area0 = focus_logic.loadElements(4, 1, "area0_", "item_focus", "item", [-1, -1, -1, 1]);
        area1 = focus_logic.loadElements(6, 1, "area1_", "item_focus", "item", [-1, [0, 0], -1, -1]);
        area2 = focus_logic.loadElements(5, 1, "area2_", "item_focus", "item", [-1, [0, 1], -1, -1]);
        area3 = focus_logic.loadElements(1, 5, "area3_", "item_focus", "item", [-1, [0, 2], 4, -1]);
        area4 = focus_logic.loadElements(5, 1, "area4_", "item_focus", "item", [3, [0, 2], -1, -1]);
        area5 = focus_logic.loadElements(1, 2, "area5_", "item_focus", "item", [-1, -1, -1, -1]);
        area6 = focus_logic.loadElements(1, 3, "area6_", "item_focus", "item", [-1, [0, 3], 7, -1]);
        area7 = focus_logic.loadElements(2, 5, "area7_", "item_focus", "item", [6, -1, -1, -1]);
        /*moveRule单独定义此dom的移动规则 [1, 0]:1区域第0个位置,dom对象获得焦点事件*/
        area0.doms[0].moveRule = [-1, -1, -1, [1, 0]];
        area0.doms[1].moveRule = [-1, -1, -1, [2, 0]];
        area0.doms[2].moveRule = [-1, -1, -1, [3, 0]];
        area0.doms[3].moveRule = [-1, -1, -1, [6, 0]];
        //area3.childAreaIndex = 4;
        //focus_logic.page.setCurrentFocus(0, 0);
        /******area0*******/
        area0.focusEvent = function (_type) {
            //右侧滚动条
            if (area0.curDomIndex == 3) {
                $('scrollbar').style.display = 'none';
            } else {
                $('scrollbar').style.display = 'block';
            }
            //选项卡切换
            showArea(area0.curDomIndex + 1);//显示选项卡
            if (area0.curDomIndex == 0 || area0.curDomIndex == 1 || area0.curDomIndex == 2) {
                focus_logic.getDataByAjax("httpClient.jsp?url=" + encodeURIComponent(url[area0.curDomIndex] + userID), getDate);
            }
            showScrollBar(area0.curDomIndex + 1);
        }
        area0.focusEvent();
        area0.areaOutEvent = function () {
            setClassName(area0.doms[area0.curDomIndex].element, "item_selected_focus");
        }
        /******area1*******/
        area1.pageTurnEvent = function () {
            showAreaData(areaxCurx);
            showScrollBar(area0.curDomIndex + 1);
        }
        /******area2*******/
        area2.pageTurnEvent = function () {
            showAreaData(areaxCurx);
            showScrollBar(area0.curDomIndex + 1);
        }
        area2.okEvent = function () {
            var m = area2.curDomIndex + (area2.pageNumber - 1) * (area2.domsMaxLength);
            if (data['orderList'][m].isCancel == "2") {
                return;
            } else {
                curProductId = data['orderList'][m].productID;
                effectime = data['orderList'][m].effectTime;
                $("area5").style.display = "block";
                focus_logic.page.setCurrentFocus(5, 0);
            }
        }
        /******area3*******/
        /*childAreaIndex当前区域如果是栏目,则此值表示当前栏目下的内容所在的区域,area4区域上到area3区域的时候记忆area3的焦点位置,4区域单独定义左移动*/
        area3.childAreaIndex = 4;
        area6.childAreaIndex = 7;
        area3.setDataCount(5);
        //历史详情订购每个月份
        area3.focusEvent = function (_type) {
            area4.pageNumber = 1;
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                //如果产品名称超过6位，则以..拼接
                area4.setAttrForDomsTxt(orderdata[area3.curDomIndex]["data"], "productName", "curProductName", 1, "name4_");
                getDates(4, orderdata[area3.curDomIndex]["data"]);
            } else {
                //如果区域内没有值，那么改变区域的个数为0。
                area4.setDataCount(0);
                getDates(4);
            }
            showScrollBar(4);
        }
        /******area4*******/
        /*历史订购数据*/
        area4.pageTurnEvent = function () {
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                getDates(4, orderdata[area3.curDomIndex]["data"]);
            } else {
                //如果区域内没有值，那么改变区域的个数为0。
                area4.setDataCount(0);
                getDates(4);
            }
            showScrollBar(4);
        }
        /******area5*******/
        area5.doms[0].okEvent = function () {//二次提示--退订按钮
            $("area5").style.display = "none";
            unorderIframe.location.href = "datajsp/cancel_product.jsp?prod_code=" + curProductId + "&prod_begintime=" + effectime;
        }
        area5.doms[1].okEvent = function () {
            $("area5").style.display = "none";
            focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
        }
        //删除兑换码
        area6.doms[1].okEvent = function () {
            del_input_num();
        }
        //马上兑换事件
        area6.doms[2].okEvent = function (response) {

            $("act_success").style.display = "block";
            focus_logic.getDataByAjax("httpPost.jsp?activation=" + inputStr, getRandomResult);
            //focus_logic.getDataByAjax("httpPost.jsp?seqno=1&ditch=4&usercode=" + top.user_id + "&activation=" + inputStr + "&usertoken=1", getRandomResult);


            if (return_code == 0) {//兑换成功
                $("alertbox").src = "images/myrecord/success0.png";
            } else if (return_code == 96002) {//输入错误
                $("alertbox").src = "images/myrecord/error96002.png";
            } else if (return_code == 96003) {//超过有效期
                $("alertbox").src = "images/myrecord/error96003.png";
            } else if (return_code == 96005) {//已被使用
                $("alertbox").src = "images/myrecord/error96005.png";
            } else if (return_code == 96006) {//产品已订购
                $("alertbox").src = "images/myrecord/error96006.png";
            } else if (return_code == 96001 || return_code == 96007) {//传参错误
                $("alertbox").src = "images/myrecord/error96001_7.png";
            }
            set_actsuccess_time();//提示框3秒消失（定时器）

        }
        //通过遥控器输入数字
        area6.numInputEvent = function (num) {
            if (area6.curDomIndex == 0) {
                input_num(num);
            }
        }
        //得到焦点添加焦点到输入框
        area6.doms[0].focusEvent = function () {
            $("area6_1").style.background = "none";
            $("area6_2").style.background = "none";
            $("area6_0").style.background = "url(images/myrecord/inputfocus01.png) no-repeat center center";
        }

        area6.doms[1].focusEvent = function () {
            $("area6_0").style.background = "none";
            $("area6_2").style.background = "none";
            $("area6_1").style.background = "url(images/myrecord/inputfocus02.png) no-repeat center center";
        }
        area6.doms[2].focusEvent = function () {
            $("area6_0").style.background = "none";
            $("area6_1").style.background = "none";
            $("area6_2").style.background = "url(images/myrecord/inputfocus03.png) no-repeat center center";
        }
        area6.areaOutEvent = function () {
            $("area6_0").style.background = "none";
            $("area6_1").style.background = "none";
            $("area6_2").style.background = "none";
        }
        /******area7*******/
        //点击ok事件，数字填充到输入框 var butArr=["1","2","3","4","5","6","7","8","9","0"];
        area7.okEvent = function (num) {
            for (var i = 0; i < 1; i++) {
                if (inputStr.length <= 15) {
                    inputStr += butArr[area7.curDomIndex];
                    $("area6_0").innerHTML = inputStr;
                }
            }
        }

//获取激活码结果
        function getRandomResult(response) {
            var actresult = eval("(" + response + ")");
            return_code = actresult['return_code'];

        }

        //正则表达式 检查输入位数16位
        function iphoneCheck(id) {

            var temp = document.getElementById(id);

            var re = /^(\d){15}$/;//兑换码验证正则表达式

            if (re.test(temp.innerHTML)) {

                phoneNum = temp.innerHTML;

                return true;

            } else {

                return false;

            }

        }

        //input_num不超过16位
        function input_num(num) {
            if ($("area6_0").innerHTML.length <= 15) {
                inputStr += num;
                $("area6_0").innerHTML = inputStr;
            }
        }

        //兑换码删除

        function del_input_num() {
            var len = inputStr.length;
            if (len > 0) {
                inputStr = inputStr.substr(0, len - 1);

            } else {
                return -1;
            }
            $("area6_0").innerHTML = inputStr;
            return inputStr.length;
        }

        area5.doms[0].okEvent = function () {//二次提示--退订按钮
            $("area5").style.display = "none";
            focus_logic.getDataByAjax("selfcare_subscribe_third.jsp?ProductID=" + curProductId + "&Action=2&PurchaseType=0", recall);
        }
        area5.doms[1].okEvent = function () {
            $("area5").style.display = "none";
            focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
        }


        //返回事件
        focus_logic.page.backEvent = function () {
            _window.top.mainWin.document.location = "back.jsp";
        }


        show_product();
    }

    function recall(flag) {
        var cateData = eval("(" + flag + ")");
        var subFlag = cateData.subscribe_flag;
        if (subFlag == 1) {//退订成功
            $("dialog_subscribe_success").style.display = "block";
            set_refresh_time();
            //return;
        } else {//已退订，退订失败
            //$("area1_test").innerHTML="退订失败!"
            //$("area1_test").style.visibility = "visible";
            $("area5").style.display = "none";
            //focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
            _window.top.mainWin.document.location = "selfcare_record_ppv.jsp";
        }
    }

    //选项卡
    function showArea(curDomIndex) {
        for (var i = 1; i < 5; i++) {
            if (i < 4 && ($("area6").style.display = "block")) {
                $("area" + i).style.display = i == curDomIndex ? "block" : "none";
            } else if (curDomIndex == 4 && ($("area6").style.display = "none")) {
                $("area6").style.display = "block";
            } else {
                $("area6").style.display = "none";
            }
        }
    }

    var userID = "<%=userId%>";
    var list;

    function getDate(result) {
        data = eval("(" + result + ")");
        list = data['orderList'];
        for (var i = 0; i < list.length; i++) {
            for (var j = i + 1; j < list.length; j++) {
                if (list[i].productID === list[j].productID) {
                    if (parseInt(list[i].expiredTime) < parseInt(list[j].expiredTime)) {
                        list.splice(i, 1);

                    } else {
                        list.splice(j, 1);
                    }
                }
            }
        }
        data.orderList = list;

        area1.setDataCount(data['orderList'].length);
        area1.pageTurn("1");
        area2.setDataCount(data['orderList'].length);
        area2.pageTurn("1");
        areaxCurx = area0.curDomIndex + 1;
        areaX = eval('(' + 'area' + areaxCurx + ')');
        if (area0.curDomIndex == 2) {
            // 历史月份重装
            orderdata = ordermonthnow(data["orderList"]);
            //历史月份动态获取（获取年月）
            innerOrdermonth(orderdata);
            //历史订购详情
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.pageNumber = 1;
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                //如果产品名称超过6位，则以..拼接
                area4.setAttrForDomsTxt(orderdata[area3.curDomIndex]["data"], "productName", "curProductName", 1, "name4_");
                getDates(4, orderdata[area3.curDomIndex]["data"]);
            } else {
                area4.setDataCount(0);
                getDates(4);
                // $("log").innerHTML= getDates(4);
            }

        } else {
            showAreaData(areaxCurx);
        }

        showScrollBar(area0.curDomIndex + 1);
    }

    function showAreaData(areaIndex) {
        addData(areaIndex);
        areaX.setAttrForDomsTxt(data['orderList'], "productName", "addName", 1, "name" + areaIndex + "_");

    }

    function addData(curDomIndex) {
        if (curDomIndex == 3) {
            curDomIndex = 4;
        }
        if (curDomIndex < 3) {
            var areaNum = eval('(' + 'area' + curDomIndex + ')');
            for (var i = 0; i < areaNum.domsCount; i++) {
                var s = i + (areaNum.pageNumber - 1) * (areaNum.domsMaxLength);
                curProductId = data['orderList'][s].productID;
                //配置划价
                curPayDitch = data['orderList'][s].payDitch;
                data['orderList'][s]["addName"] = stopscrollString("name" + curDomIndex + "_" + i, data['orderList'][s].productName, 24, 152);
                if (parseInt(data['orderList'][s].productType) == 1) {//按次支付
                    //data['orderList'][s]["addCont"] = stopscrollString("content"+curDomIndex+"_"+i,data['orderList'][s].contentName,24,152);
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : $("content" + curDomIndex + "_" + i).innerHTML = stopscrollString("content" + curDomIndex + "_" + i, data['orderList'][s].contentName, 24, 152);
                } else {
                    //data['orderList'][s]["addCont"] = "";
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : data['orderList'][s].contentName = "";
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : $("content" + curDomIndex + "_" + i).innerHTML = "";
                }

                //根据产品ID来屏蔽产品订购内容
                if (curProductId == "100413" && curPayDitch != '4') {////产品ID来屏蔽内容
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else if (curProductId == "100414" && curPayDitch != '4') {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else if (curProductId == "100416" && curPayDitch != '4') {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else if (curProductId == "100469" && curPayDitch != '4') {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else if (curProductId == "100470" && curPayDitch != '4') {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else if (curProductId == "100472" && curPayDitch != '4') {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                }
                //根据产品ID显示产品优惠后的价格
                if (curProductId == "100320" && curPayDitch != '4') {////配置划价
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "39.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100325" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100326" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100327" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100328" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.99元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100356" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "11.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100360" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100359" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "125.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100361" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "365元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100355" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "62.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100357" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100365" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100431" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100434" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100437" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100440" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100443" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100446" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "60.00元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100449" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100450" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100451" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "93.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100452" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100453" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100454" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "93.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100455" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100458" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100461" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100464" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100465" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100466" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100467" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100468" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100472" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100399" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100398" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100476" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100354" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100327" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100453" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100455" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100490" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100485" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100486" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100487" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "199元";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "元";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "none";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "";
                }
                //根据产品ID显示产品备注
                if (curProductId == "100327") {//BABY淘奇包-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100453") {//BABY淘奇包-30天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100455") {//BABY淘奇包-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100476") {//电视剧-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100398") {//茶频道-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100399") {//快乐垂钓-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100472") {//TV学堂-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100320") {//4K超清-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100325") {//星影秀-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100360") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100356") {//淘Baby-15天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100326") {//淘Baby-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100327") {//Baby淘奇包-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100328") {//嗨体育-包月
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100358") {//4K超清-30天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100359") {//4K超清-90天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100361") {//4K超清-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100354") {//淘Baby-30天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100355") {//淘Baby-90天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100357") {//淘Baby-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100365") {//DOGTV-365天
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100431") {//芒果TV
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100434") {//企鹅TV
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100437") {//天天美剧
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100440") {//岩华精品
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100443") {//电竞世界
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100446") {//QQ音乐
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100449") {//爱奇艺专区
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100450") {//星影秀
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100451") {//星影秀
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100452") {//星影秀
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100453") {//Baby淘奇包
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100454") {//Baby淘奇包
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100455") {//Baby淘奇包
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100458") {//百视通专区
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100461") {//百视通体育
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100464") {//百视通教育
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100465") {//快乐垂钓
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100466") {//快乐垂钓
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100467") {//茶频道
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100468") {//茶频道
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2019年12月31日";
                } else if (curProductId == "100490") {//茶频道
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2020年12月31日";
                } else if (curProductId == "100485") {//知识
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2020年12月31日";
                } else if (curProductId == "100486") {//知识
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2020年12月31日";
                } else if (curProductId == "100487") {//知识
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "优惠截止日期：<br>2020年12月31日";
                } else if (curProductId == "100322") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "该产品已于2017年5月1日升级，价格上调，不退订将继续享受原优惠价格不变，重新订购将按新价格计费。";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.fontSize = "14px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.lineHeight = "15px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.textAlign = "left";
                } else if (curProductId == "100321") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "该产品已于2017年5月1日升级，价格上调，不退订将继续享受原优惠价格不变，重新订购将按新价格计费。";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.fontSize = "14px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.lineHeight = "15px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.textAlign = "left";
                } else if (curProductId == "100323") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "该产品已于2017年5月1日升级，价格上调，不退订将继续享受原优惠价格不变，重新订购将按新价格计费。";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.fontSize = "14px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.lineHeight = "15px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.textAlign = "left";
                } else {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "";
                }


                if ($("content" + curDomIndex + "_" + i).innerHTML == "undefined") {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                }
                if (data['orderList'][s].isCancel == "2") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].unCancelReason;
                }

                ($("beginTime" + curDomIndex + "_" + i) == null) ? "" : $("beginTime" + curDomIndex + "_" + i).innerHTML = showOrderTime(data['orderList'][s]);
                ($("payType" + curDomIndex + "_" + i) == null) ? "" : $("payType" + curDomIndex + "_" + i).innerHTML = showPayType(data['orderList'][s]);
                ($("endTime" + curDomIndex + "_" + i) == null) ? "" : $("endTime" + curDomIndex + "_" + i).innerHTML = showEndTime(data['orderList'][s]);
            }
        }
    }

    //历史订购详情填充数据：
    function getDates(curDomIndex, data) {
        //区域内元素个数   area0.domsCount  :5
        var areaObj = focus_logic.page.areas[curDomIndex];
        //每页数据个数
        for (var i = 0; i < areaObj.domsCount; i++) {
            var ss = i + (areaObj.pageNumber - 1) * areaObj.domsMaxLength;
            if (data == undefined) {
                $("name" + curDomIndex + "_" + i).innerHTML = "";
            } else if (data != null) {

                if (data[ss].contentName == "" || data[ss].contentName == null) {
                    $("content" + curDomIndex + "_" + i).innerHTML = "";
                } else {
                    $("content" + curDomIndex + "_" + i).innerHTML = data != undefined ? data[ss].contentName : "";


                }


            }
            $("price" + curDomIndex + "_" + i).innerHTML = data != undefined ? data[ss].fee / 100 + "元" : "";
            $("beginTime" + curDomIndex + "_" + i).innerHTML = data != undefined ? showOrderTime(data[ss]) : "";
            $("payType" + curDomIndex + "_" + i).innerHTML = data != undefined ? showPayType(data[ss]) : "";
            $("endTime" + curDomIndex + "_" + i).innerHTML = data != undefined ? showEndTime(data[ss]) : "";
        }
    }

    function showOrderTime(obj) {
        var showordertime = "";
        var dataTime = obj.orderTime;
        showordertime = dataTime.substring(0, 4) + "." + dataTime.substring(4, 6) + "." + dataTime.substring(6, 8) + " " + dataTime.substring(8, 10) + ":" + dataTime.substring(10, 12) + ":" + dataTime.substring(12, 15);
        return showordertime;
    }

    function showEndTime(obj) {
        var showendtime = "";
        if (obj.productType == "1") {
            var dataTime = obj.expiredTime;
            showendtime = dataTime.substring(0, 4) + "." + dataTime.substring(4, 6) + "." + dataTime.substring(6, 8) + " " + dataTime.substring(8, 10) + ":" + dataTime.substring(10, 12) + ":" + dataTime.substring(12, 15);
        } else {
            var dataTime = obj.expiredTime;
            showendtime = dataTime.substring(0, 4);
            if (showendtime != "2099") {
                showendtime = dataTime.substring(0, 4) + "." + dataTime.substring(4, 6) + "." + dataTime.substring(6, 8) + " " + dataTime.substring(8, 10) + ":" + dataTime.substring(10, 12) + ":" + dataTime.substring(12, 15);
            } else {
                showendtime = "自动续订";//包月
            }
        }
        return showendtime;
    }

    function showPayType(obj) {
        var result;
        var type = obj.payDitch;
        switch (type) {
            case '1':
                result = '微信';
                break;
            case '2':
                result = '支付宝';
                break;
            case '4':
                result = '兑换码';
                break;
            case '9':
                result = '宽带';
                break;
            default:
                result = '宽带';
                break;
        }
        return result;
    }

    function set_refresh_time() {
        setTimeout("refresh_page()", 2000);
    }

    function refresh_page() {
        $("dialog_subscribe_success").style.display = "none";
        _window.top.mainWin.document.location = "selfcare_record_ppv.jsp";
        //focus_logic.page.setCurrentFocus(2, 0);
    }

    //兑换成功时提示框3秒消失（定时器）
    function set_actsuccess_time() {
        setTimeout("actsucess_page()", 3000);
    }

    //兑换码_弹框消失
    function actsucess_page() {
        $("act_success").style.display = "none";
        focus_logic.page.setCurrentFocus(0, 3);
        //焦点位置
        $("area6_0").innerHTML = "";
        inputStr = "";
    }


    //滚动条
    function showScrollBar(curDomIndex) {
        if (curDomIndex == 3) {
            curDomIndex = 4;
        }
        var areaNum = eval('(' + 'area' + curDomIndex + ')');
        if (data['orderList'].length > 0 || orderdata[area3.curDomIndex]["data"].length > 0) {
            var heightX = parseInt(374 / areaNum.pageTotal);//每页的高度
            var topX = 3 + heightX * (areaNum.pageNumber - 1);
            $("scrollbar2").style.height = heightX + "px";
            $("scroll").style.top = topX + "px";
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
    }

    //重新封装历史订购数据
    function ordermonthnow(data) {
        var orderdata = [];
        var now = new Date();
        var month = now.getMonth() + 1;
        month--;
        var year = now.getFullYear();
        for (var i = 0; i < 5; i++) {
            var obj = {};
            if (month == 0) {
                month = 12;
                year--;
            }
            obj.monthName = year + '年' + month + '月';
            if (month < 10) {
                month = '0' + month;
            }
            obj.value = year + "" + month;
            obj.data = strGroup(getMonthData(obj.value, data));
            orderdata.push(obj);
            month--;
        }
        return orderdata;
    }

    //对产品名称、内容名称截取，超过6位时以..替换
    function strGroup(data) {
        if (data == null) return null;
        for (var i = 0; i < data.length; i++) {
            var productName = data[i]["productName"];
            var contentName = data[i]["contentName"];
            //data[i]["curProductName"] = stopscrollString("name" + curDomIndex + "_" + i, data[i]["productName"], 24, 152);
            //data[i]["contentName"] = stopscrollString("content" + curDomIndex + "_" + i, data[i]["contentName"], 24, 152);
            data[i]["curProductName"] = stopscrollString("", data[i]["productName"], 24, 152);
            data[i]["contentName"] = stopscrollString("", data[i]["contentName"], 24, 152);
        }
        return data;
    }

    //获取对应的月份
    function getMonthData(value, data) {
        for (var i = 0; i < data.length; i++) {
            if (value == data[i][0].orderMonth) {
                return data[i];
            }
        }
        return null;
    }

    // 字符串停止滚动
    function stopscrollString(divid, text, px, divwidth) {
        text = text.replace(new RegExp("<", "gm"), "&lt;");
        text = text.replace(new RegExp(">", "gm"), "&gt;");
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            text = writeFitString(text, px, divwidth);
        }
        return text;
    }

    //字符串截取（小于特定长度返回原字符串，否则返回字符串截取部分）
    function writeFitString(text, px, divwidth, type) {
        if (type != 0) {
            text = text.replace(new RegExp("<", "gm"), "&lt;");
            text = text.replace(new RegExp(">", "gm"), "&gt;");
        }
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var curwidth = 0;
        var distext = "";
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (var i = 0; i < text.length; i++) {
                if (text.charCodeAt(i) > 255) {
                    curwidth = curwidth + px;
                } else if (text.charCodeAt(i) >= 65 && text.charCodeAt(i) <= 90) {
                    curwidth = curwidth + (2 / 3) * px;
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + text.substring(i, i + 1);
            }
            distext = distext + "..";
        }
        return distext;
    }

    //  获取字符串的长度，如果有中文，则每个中文字符计为2位
    function strlen(str) {
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            if (str.charCodeAt(i) > 255) len += 2; else len++;
        }
        return len;
    }

    /*产品名称截取*/
    function show_product() {
        clear_list_prod();
        if (pageFlag == 1) {
            start_list_prod = (list_prod_index - 1) * list_prod_length;
            for (var i = 0; i < list_prod_length && (start_list_prod + i < prod_arr.length); i++) {
                if (prod_arr[i + start_list_prod].productType == 0) {
                    if (prod_arr[i + start_list_prod].productName.length > 6) {
                        document.getElementById("package_name_" + i).innerHTML = prod_arr[i + start_list_prod].productName.substring(0, 6) + "...";
                    } else {
                        document.getElementById("package_name_" + i).innerHTML = prod_arr[i + start_list_prod].productName;
                    }
                } else if (prod_arr[i + start_list_prod].productType == 1) {
                    if (prod_arr[i + start_list_prod].contentName.length > 6) {
                        document.getElementById("package_name_" + i).innerHTML = prod_arr[i + start_list_prod].contentName.substring(0, 6) + "...";
                    } else {
                        document.getElementById("package_name_" + i).innerHTML = prod_arr[i + start_list_prod].contentName;
                    }
                }
            }
            init_focus();
            arrow_direction();
        }
        $("userID").innerHTML = "用户账号：" + userID;

    }

    /*历史月份动态获取*/
    function innerOrdermonth(data) {
        for (var i = 0; i < data.length; i++) {
            $('area3_' + i).innerHTML = data[i]["monthName"];
        }
    }
</script>
</body>

</html>