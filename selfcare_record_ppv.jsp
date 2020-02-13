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
    String userId = userInfo.getUserId();//��ȡ�û��˺�
%>

<html>
<head>
    <title>�ҵ��Է���</title>
    <style>
        /*�������˺�*/
        * {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .font_24 {
            color: #ffffff;
            font-size: 24px;
        }

        /*����*/

        #tab {
            width: 1280px;
            height: 720px;
            position: relative;
            background: url(images/myrecord/bg.png) no-repeat;
            overflow: hidden;
        }

        /*  area0 ���˵��� */
        #area0 {
            width: 218px;
            height: 268px;
            position: absolute;
            top: 97px;
            left: 57px;
            background: url(images/myrecord/left_bg.png) no-repeat;
        }

        /*���˵�ÿ����ʽ*/
        #area0 .item {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
        }

        /*���˵�ÿ�н���*/
        #area0 .item_focus {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
            background: url(images/myrecord/focus_product.png);
        }

        /*���˵�ÿ�н���*/
        #area0 .item_selected_focus {
            width: 213px;
            height: 52px;
            text-align: center;
            line-height: 52px;
            font-size: 24px;
            color: #fff;
            background: url(images/myrecord/blur_product.png);
        }

        /*��ǰ��Ч��Ʒ��ʽ*/
        .content {
            width: 1009px;
            height: 546px;
            position: absolute;
            top: 87px;
            left: 269px;
        }

        /* area1������Ч+area2�����˶�����ͼ*/
        #area1, #area2 {
            width: 100%;
            height: 100%;
            background: url(images/myrecord/Thismonth_product.png);
        }

        /*������Чÿ����ʽ*/
        #area1 .item {
            position: absolute;
            left: 13px;
            height: 86px;

            background: none;
        }

        /*������Ч�����*/
        #area1 .item_focus {
            position: absolute;
            left: 13px;
            width: 950px;
            height: 86px;
            background-image: url(images/myrecord/selectfocus.png);
        }

        /*������Ч�ϱ�����ʽ*/
        #area1 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 16px;
        }

        /*������Ч�ϱ���������ʽ*/
        #area1 .topTitle li {
            width: 183px;
            height: 40px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        /*������Ч������ʽ*/
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

        /*������Ч������ʽ*/
        #area1 .general span {
            float: none;
            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
        }

        /*�����˶�ÿ����ʽ*/

        #area2 .item {
            position: absolute;
            left: 13px;
        }

        /*�����˶������*/
        #area2 .item_focus {
            position: absolute;
            left: 13px;
        }

        /*�����˶��ϱ�����ʽ*/
        #area2 .topTitle {
            width: 950px;
            height: 40px;
            position: absolute;
            top: 13px;
            left: 13px;
        }

        /*�����˶��ϱ���������ʽ*/
        #area2 .topTitle li {
            width: 152px;
            height: 40px;
            float: left;
            font-size: 24px;
            color: #fff;
            text-align: center;
            line-height: 40px;
        }

        /*�����˶�������ʽ*/
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

        /*�����˶�������ʽ*/
        #area2 .general span {
            float: none;
            width: 152px;
            height: 30px;
            font-size: 24px;
            color: #fff;
            text-align: center;
            display: block;
        }

        /*�����˶���ť����ͼ*/
        #area2 .item .returnbtn, #area2 .item_focus .returnbtn {
            width: 77px;
            height: 37px;
            position: absolute;
            top: 23px;
            left: 645px;
            background: url(images/myrecord/return.png);
        }

        /*�����˶�ÿ����ʽ����Ϊ��*/
        #area2 .item img {
            display: none;
        }

        /*�����˶��˶�ͼƬ����Ϊ��Ԫ��*/
        #area2 .item_focus img {
            display: block;
        }

        /*���²�Ʒ˵��*/
        #area2 .product_descrip {
            position: absolute;
            top: 460px;
            height: 66px;
            color: #FFF;
            font-size: 18px;
            line-height: 22px;
        }

        /* area3 ��ʷ��������*/
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

        /*���ּ��̽���*/
        #area4 .item_focus {
            position: absolute;
            left: 13px;
            width: 950px;
            height: 86px;
            background-image: url(images/myrecord/selectfocus.png);
        }

        /*��ɫ������ʾ����*/
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

        /* area5  ��Ʒ�˶�������ʾҳ*/
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

        /*��������ʾ*/
        #scrollbar1, #scrollbar2, #scrollbar3 {
            display: block;
        }

        /*��һҳ����һҳ*/
        #area1 .pageico, #area2 .pageico, #area3 .pageico {
            position: absolute;
            top: 584px;
            left: 194px;
        }

        /* area6 �һ��뱳��ͼ*/
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

        /*�����������������*/
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


        /*����*/
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

        /*���ּ��̽���*/
        #area7 .item_focus {
            position: absolute;
            left: 181px;
            background-image: url(images/myrecord/numfocus.png);
        }

        /*��ɫ������ʾ����*/
        #alert_text {
            position: absolute;
            width: 269px;
            height: 37px;
            left: 367px;
            top: 249px;
            font-size: 20px;
            font-family: ��������;
            font-style: normal;
            font-weight: bold;
            line-height: 37px;
            visibility: hidden;
        }
    </style>
</head>

<%--����ֱ�ӳ�ʼ��--%>
<body bgcolor="transparent" onLoad="init()">

<div id="tab">
    <!--������Ϣ-->
    <div style="position:absolute; width:53; height:36; left:55px; top:16px;">
        <img src="images/search/icon_5.png" border="0">
    </div>
    <div id="path"
         style="position:absolute; width:760px; height:30px; left:110px; top:25px;font-size:24px;color:#FFFFFF">
        Ӧ�� > �ҵ��Է���
    </div>
    <div id="userID" style="position: absolute; width: 392px; height: 30px; left: 875px; top: 25px;"
         class="font_24"></div>
    <%--���˵�--%>
    <ul id="area0">
        <li class="item_focus" id="area0_0">��ǰ��Ч��Ʒ</li>
        <li class="item" id="area0_1">���²�Ʒ�˶�</li>
        <li class="item" id="area0_2">��ʷ��������</li>
        <li class="item" id="area0_3">�һ���</li>
    </ul>
    <%--�Ҳ�˵�--%>
    <div class="content">
        <%--������Ч��Ʒ--%>
        <div id="area1" style="display: block;">
            <%--������Ч��Ʒչʾѡ�--%>
            <ul class="topTitle">
                <li>��Ʒ����</li>
                <li>��Ʒ�۸�</li>
                <li>����ʱ��</li>
                <li>֧������</li>
                <li>��Ч����</li>
            </ul>
            <%--��Ʒչʾ--%>
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
            <!--��һҳ����һҳͼƬ-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <%--���²�Ʒ�˶�--%>
        <div id="area2" style="display: none;">
            <%--���²�Ʒѡ�--%>
            <ul class="topTitle">
                <li>��Ʒ����</li>
                <li>��Ʒ�۸�</li>
                <li>����ʱ��</li>
                <li>��Ч����</li>
                <li>�˶���ť</li>
                <li>��Ʒ��ע</li>
            </ul>
            <%--���²�Ʒչʾ--%>
            <ul class="item" id="area2_0" style="top: 54px;">
                <li class="general"><span id="name2_0"></span><span id="content2_0"></span></li>
                <li class="general"><span id="price2_0"></span><span id="saleprice2_0"></span></li>
                <li class="general" id="beginTime2_0"></li>
                <li class="general" id="endTime2_0"></li>
                <%--�˶������--%>
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
            <!-- ��Ʒ˵��-->
            <div class="product_descrip" style="width:90px;left:20px;">��Ʒ˵����</div>
            <div class="product_descrip" style="width:845px;left:110px;">
                ���²�Ʒ��������Ч���ڿ������տ����������°���Ʒѡ������˶�����������Ʒ���½��Զ��������˶�������ɺ󣬵��»��ɼ���ʹ�øð��²�Ʒ�������˶���Ч���÷��ý������Ŀ��������һͬ��ȡ���������û��������µ�ǰ��ʱ���ѳ�ֵ���������Ƿ��ͣ����
            </div>
            <!--��һҳ����һҳͼƬ-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <%--��ʷ��������--%>
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
                    <li>��Ʒ����</li>
                    <li>��Ʒ�۸�</li>
                    <li>����ʱ��</li>
                    <li>֧������</li>
                    <li>��Ч����</li>
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
            <!--��һҳ����һҳͼƬ-->
            <div class="pageico">
                <img src="images/myrecord/pageimg.png">
            </div>
        </div>
        <!-- area6 �һ��� -->
        <div id="area6" style="display: none;">
            <ul class="numtop">
                <!--�����-->
                <li class="item" id="area6_0"></li>
                <!--ɾ��-->
                <li class="item" id="area6_1" style="left:667px;width: 76px;"></li>
                <!--�һ�-->
                <li class="item" id="area6_2" style="left:761px;top: 162px;width: 195px;"></li>
            </ul>
            <%--���ְ�ť--%>
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

    <!--�һ��ɹ�-->
    <div id="act_success" style="position:absolute; width:392px; height:262px; left:444px; top:248px; display:none;">
        <div style="position:absolute; width:392px; height:262px; left:0px; top:0px;"><img id="alertbox" src=""
                                                                                           width="392" height="262">
        </div>
    </div>
    <!--�˶�-->
    <div id="area5">
        <div class="item" id="area5_0" style="left:76px;"><img src="images/myrecord/price_onfocus.png" width="158"
                                                               height="44"></div>
        <div class="item" id="area5_1" style="left:372px;"><img src="images/myrecord/price_onfocus.png" width="158"
                                                                height="44"></div>
    </div>
    <%--�˶�����--%>
    <iframe id="unorderIframe" name="unorderIframe" width="623" height="254"
            style="position:absolute; left: 321px; top: 284px; display:none; background-color:transparent;"
            allowtransparency="true"></iframe>
    <!--�˶��ɹ�-->
    <div id="dialog_subscribe_success"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; display:none;">
        <div style="position:absolute; width:609px; height:250px; left:0px; top:0px;"><img
                src="images/myrecord/Unsubscribe_ok.png" width="609" height="250"></div>
    </div>
    <!--������--->
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
    //������Ч�����²�Ʒ�˶�
    var data, orderdata;
    //��ʷ��������
    var strLength = 6;//��ȡ����
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

    //��ʼ��
    function init() {
        /*�������򽹵��߼�*/
        area0 = focus_logic.loadElements(4, 1, "area0_", "item_focus", "item", [-1, -1, -1, 1]);
        area1 = focus_logic.loadElements(6, 1, "area1_", "item_focus", "item", [-1, [0, 0], -1, -1]);
        area2 = focus_logic.loadElements(5, 1, "area2_", "item_focus", "item", [-1, [0, 1], -1, -1]);
        area3 = focus_logic.loadElements(1, 5, "area3_", "item_focus", "item", [-1, [0, 2], 4, -1]);
        area4 = focus_logic.loadElements(5, 1, "area4_", "item_focus", "item", [3, [0, 2], -1, -1]);
        area5 = focus_logic.loadElements(1, 2, "area5_", "item_focus", "item", [-1, -1, -1, -1]);
        area6 = focus_logic.loadElements(1, 3, "area6_", "item_focus", "item", [-1, [0, 3], 7, -1]);
        area7 = focus_logic.loadElements(2, 5, "area7_", "item_focus", "item", [6, -1, -1, -1]);
        /*moveRule���������dom���ƶ����� [1, 0]:1�����0��λ��,dom�����ý����¼�*/
        area0.doms[0].moveRule = [-1, -1, -1, [1, 0]];
        area0.doms[1].moveRule = [-1, -1, -1, [2, 0]];
        area0.doms[2].moveRule = [-1, -1, -1, [3, 0]];
        area0.doms[3].moveRule = [-1, -1, -1, [6, 0]];
        //area3.childAreaIndex = 4;
        //focus_logic.page.setCurrentFocus(0, 0);
        /******area0*******/
        area0.focusEvent = function (_type) {
            //�Ҳ������
            if (area0.curDomIndex == 3) {
                $('scrollbar').style.display = 'none';
            } else {
                $('scrollbar').style.display = 'block';
            }
            //ѡ��л�
            showArea(area0.curDomIndex + 1);//��ʾѡ�
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
        /*childAreaIndex��ǰ�����������Ŀ,���ֵ��ʾ��ǰ��Ŀ�µ��������ڵ�����,area4�����ϵ�area3�����ʱ�����area3�Ľ���λ��,4���򵥶��������ƶ�*/
        area3.childAreaIndex = 4;
        area6.childAreaIndex = 7;
        area3.setDataCount(5);
        //��ʷ���鶩��ÿ���·�
        area3.focusEvent = function (_type) {
            area4.pageNumber = 1;
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                //�����Ʒ���Ƴ���6λ������..ƴ��
                area4.setAttrForDomsTxt(orderdata[area3.curDomIndex]["data"], "productName", "curProductName", 1, "name4_");
                getDates(4, orderdata[area3.curDomIndex]["data"]);
            } else {
                //���������û��ֵ����ô�ı�����ĸ���Ϊ0��
                area4.setDataCount(0);
                getDates(4);
            }
            showScrollBar(4);
        }
        /******area4*******/
        /*��ʷ��������*/
        area4.pageTurnEvent = function () {
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                getDates(4, orderdata[area3.curDomIndex]["data"]);
            } else {
                //���������û��ֵ����ô�ı�����ĸ���Ϊ0��
                area4.setDataCount(0);
                getDates(4);
            }
            showScrollBar(4);
        }
        /******area5*******/
        area5.doms[0].okEvent = function () {//������ʾ--�˶���ť
            $("area5").style.display = "none";
            unorderIframe.location.href = "datajsp/cancel_product.jsp?prod_code=" + curProductId + "&prod_begintime=" + effectime;
        }
        area5.doms[1].okEvent = function () {
            $("area5").style.display = "none";
            focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
        }
        //ɾ���һ���
        area6.doms[1].okEvent = function () {
            del_input_num();
        }
        //���϶һ��¼�
        area6.doms[2].okEvent = function (response) {

            $("act_success").style.display = "block";
            focus_logic.getDataByAjax("httpPost.jsp?activation=" + inputStr, getRandomResult);
            //focus_logic.getDataByAjax("httpPost.jsp?seqno=1&ditch=4&usercode=" + top.user_id + "&activation=" + inputStr + "&usertoken=1", getRandomResult);


            if (return_code == 0) {//�һ��ɹ�
                $("alertbox").src = "images/myrecord/success0.png";
            } else if (return_code == 96002) {//�������
                $("alertbox").src = "images/myrecord/error96002.png";
            } else if (return_code == 96003) {//������Ч��
                $("alertbox").src = "images/myrecord/error96003.png";
            } else if (return_code == 96005) {//�ѱ�ʹ��
                $("alertbox").src = "images/myrecord/error96005.png";
            } else if (return_code == 96006) {//��Ʒ�Ѷ���
                $("alertbox").src = "images/myrecord/error96006.png";
            } else if (return_code == 96001 || return_code == 96007) {//���δ���
                $("alertbox").src = "images/myrecord/error96001_7.png";
            }
            set_actsuccess_time();//��ʾ��3����ʧ����ʱ����

        }
        //ͨ��ң������������
        area6.numInputEvent = function (num) {
            if (area6.curDomIndex == 0) {
                input_num(num);
            }
        }
        //�õ�������ӽ��㵽�����
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
        //���ok�¼���������䵽����� var butArr=["1","2","3","4","5","6","7","8","9","0"];
        area7.okEvent = function (num) {
            for (var i = 0; i < 1; i++) {
                if (inputStr.length <= 15) {
                    inputStr += butArr[area7.curDomIndex];
                    $("area6_0").innerHTML = inputStr;
                }
            }
        }

//��ȡ��������
        function getRandomResult(response) {
            var actresult = eval("(" + response + ")");
            return_code = actresult['return_code'];

        }

        //������ʽ �������λ��16λ
        function iphoneCheck(id) {

            var temp = document.getElementById(id);

            var re = /^(\d){15}$/;//�һ�����֤������ʽ

            if (re.test(temp.innerHTML)) {

                phoneNum = temp.innerHTML;

                return true;

            } else {

                return false;

            }

        }

        //input_num������16λ
        function input_num(num) {
            if ($("area6_0").innerHTML.length <= 15) {
                inputStr += num;
                $("area6_0").innerHTML = inputStr;
            }
        }

        //�һ���ɾ��

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

        area5.doms[0].okEvent = function () {//������ʾ--�˶���ť
            $("area5").style.display = "none";
            focus_logic.getDataByAjax("selfcare_subscribe_third.jsp?ProductID=" + curProductId + "&Action=2&PurchaseType=0", recall);
        }
        area5.doms[1].okEvent = function () {
            $("area5").style.display = "none";
            focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
        }


        //�����¼�
        focus_logic.page.backEvent = function () {
            _window.top.mainWin.document.location = "back.jsp";
        }


        show_product();
    }

    function recall(flag) {
        var cateData = eval("(" + flag + ")");
        var subFlag = cateData.subscribe_flag;
        if (subFlag == 1) {//�˶��ɹ�
            $("dialog_subscribe_success").style.display = "block";
            set_refresh_time();
            //return;
        } else {//���˶����˶�ʧ��
            //$("area1_test").innerHTML="�˶�ʧ��!"
            //$("area1_test").style.visibility = "visible";
            $("area5").style.display = "none";
            //focus_logic.page.setCurrentFocus(2, area2.curDomIndex);
            _window.top.mainWin.document.location = "selfcare_record_ppv.jsp";
        }
    }

    //ѡ�
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
            // ��ʷ�·���װ
            orderdata = ordermonthnow(data["orderList"]);
            //��ʷ�·ݶ�̬��ȡ����ȡ���£�
            innerOrdermonth(orderdata);
            //��ʷ��������
            if (orderdata[area3.curDomIndex]["data"] != null) {
                area4.pageNumber = 1;
                area4.setDataCount(orderdata[area3.curDomIndex]["data"].length);
                //�����Ʒ���Ƴ���6λ������..ƴ��
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
                //���û���
                curPayDitch = data['orderList'][s].payDitch;
                data['orderList'][s]["addName"] = stopscrollString("name" + curDomIndex + "_" + i, data['orderList'][s].productName, 24, 152);
                if (parseInt(data['orderList'][s].productType) == 1) {//����֧��
                    //data['orderList'][s]["addCont"] = stopscrollString("content"+curDomIndex+"_"+i,data['orderList'][s].contentName,24,152);
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : $("content" + curDomIndex + "_" + i).innerHTML = stopscrollString("content" + curDomIndex + "_" + i, data['orderList'][s].contentName, 24, 152);
                } else {
                    //data['orderList'][s]["addCont"] = "";
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : data['orderList'][s].contentName = "";
                    ($("content" + curDomIndex + "_" + i) == null) ? "" : $("content" + curDomIndex + "_" + i).innerHTML = "";
                }

                //���ݲ�ƷID�����β�Ʒ��������
                if (curProductId == "100413" && curPayDitch != '4') {////��ƷID����������
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
                //���ݲ�ƷID��ʾ��Ʒ�Żݺ�ļ۸�
                if (curProductId == "100320" && curPayDitch != '4') {////���û���
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "39.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100325" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100326" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100327" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100328" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.99Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100356" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "11.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100360" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100359" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "125.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100361" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "365Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100355" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "62.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100357" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100365" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100431" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100434" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100437" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100440" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100443" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100446" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "60.00Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100449" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100450" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100451" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "93.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100452" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100453" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100454" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "93.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100455" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100458" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100461" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100464" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100465" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100466" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100467" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100468" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "190.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100472" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100399" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100398" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "19.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100476" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100354" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "22.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100327" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100453" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100455" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100490" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "262.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100485" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "29.9Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100486" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "33.88Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else if (curProductId == "100487" && curPayDitch != '4') {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "line-through";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "199Ԫ";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).style.color = "red";
                } else {
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).innerHTML = data['orderList'][s].fee / 100 + "Ԫ";
                    ($("price" + curDomIndex + "_" + i) == null) ? "" : $("price" + curDomIndex + "_" + i).style.textDecoration = "none";
                    ($("saleprice" + curDomIndex + "_" + i) == null) ? "" : $("saleprice" + curDomIndex + "_" + i).innerHTML = "";
                }
                //���ݲ�ƷID��ʾ��Ʒ��ע
                if (curProductId == "100327") {//BABY�����-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100453") {//BABY�����-30��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100455") {//BABY�����-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100476") {//���Ӿ�-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100398") {//��Ƶ��-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100399") {//���ִ���-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100472") {//TVѧ��-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100320") {//4K����-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100325") {//��Ӱ��-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100360") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100356") {//��Baby-15��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100326") {//��Baby-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100327") {//Baby�����-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100328") {//������-����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100358") {//4K����-30��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100359") {//4K����-90��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100361") {//4K����-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100354") {//��Baby-30��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100355") {//��Baby-90��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100357") {//��Baby-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100365") {//DOGTV-365��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100431") {//â��TV
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100434") {//���TV
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100437") {//��������
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100440") {//�һ���Ʒ
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100443") {//�羺����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100446") {//QQ����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100449") {//������ר��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100450") {//��Ӱ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100451") {//��Ӱ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100452") {//��Ӱ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100453") {//Baby�����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100454") {//Baby�����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100455") {//Baby�����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100458") {//����ͨר��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100461") {//����ͨ����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100464") {//����ͨ����
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100465") {//���ִ���
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100466") {//���ִ���
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100467") {//��Ƶ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100468") {//��Ƶ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2019��12��31��";
                } else if (curProductId == "100490") {//��Ƶ��
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2020��12��31��";
                } else if (curProductId == "100485") {//֪ʶ
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2020��12��31��";
                } else if (curProductId == "100486") {//֪ʶ
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2020��12��31��";
                } else if (curProductId == "100487") {//֪ʶ
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�Żݽ�ֹ���ڣ�<br>2020��12��31��";
                } else if (curProductId == "100322") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�ò�Ʒ����2017��5��1���������۸��ϵ������˶�����������ԭ�Żݼ۸񲻱䣬���¶��������¼۸�Ʒѡ�";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.fontSize = "14px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.lineHeight = "15px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.textAlign = "left";
                } else if (curProductId == "100321") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�ò�Ʒ����2017��5��1���������۸��ϵ������˶�����������ԭ�Żݼ۸񲻱䣬���¶��������¼۸�Ʒѡ�";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.fontSize = "14px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.lineHeight = "15px";
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).style.textAlign = "left";
                } else if (curProductId == "100323") {
                    ($("remark" + curDomIndex + "_" + i) == null) ? "" : $("remark" + curDomIndex + "_" + i).innerHTML = "�ò�Ʒ����2017��5��1���������۸��ϵ������˶�����������ԭ�Żݼ۸񲻱䣬���¶��������¼۸�Ʒѡ�";
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

    //��ʷ��������������ݣ�
    function getDates(curDomIndex, data) {
        //������Ԫ�ظ���   area0.domsCount  :5
        var areaObj = focus_logic.page.areas[curDomIndex];
        //ÿҳ���ݸ���
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
            $("price" + curDomIndex + "_" + i).innerHTML = data != undefined ? data[ss].fee / 100 + "Ԫ" : "";
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
                showendtime = "�Զ�����";//����
            }
        }
        return showendtime;
    }

    function showPayType(obj) {
        var result;
        var type = obj.payDitch;
        switch (type) {
            case '1':
                result = '΢��';
                break;
            case '2':
                result = '֧����';
                break;
            case '4':
                result = '�һ���';
                break;
            case '9':
                result = '���';
                break;
            default:
                result = '���';
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

    //�һ��ɹ�ʱ��ʾ��3����ʧ����ʱ����
    function set_actsuccess_time() {
        setTimeout("actsucess_page()", 3000);
    }

    //�һ���_������ʧ
    function actsucess_page() {
        $("act_success").style.display = "none";
        focus_logic.page.setCurrentFocus(0, 3);
        //����λ��
        $("area6_0").innerHTML = "";
        inputStr = "";
    }


    //������
    function showScrollBar(curDomIndex) {
        if (curDomIndex == 3) {
            curDomIndex = 4;
        }
        var areaNum = eval('(' + 'area' + curDomIndex + ')');
        if (data['orderList'].length > 0 || orderdata[area3.curDomIndex]["data"].length > 0) {
            var heightX = parseInt(374 / areaNum.pageTotal);//ÿҳ�ĸ߶�
            var topX = 3 + heightX * (areaNum.pageNumber - 1);
            $("scrollbar2").style.height = heightX + "px";
            $("scroll").style.top = topX + "px";
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
    }

    //���·�װ��ʷ��������
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
            obj.monthName = year + '��' + month + '��';
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

    //�Բ�Ʒ���ơ��������ƽ�ȡ������6λʱ��..�滻
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

    //��ȡ��Ӧ���·�
    function getMonthData(value, data) {
        for (var i = 0; i < data.length; i++) {
            if (value == data[i][0].orderMonth) {
                return data[i];
            }
        }
        return null;
    }

    // �ַ���ֹͣ����
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

    //�ַ�����ȡ��С���ض����ȷ���ԭ�ַ��������򷵻��ַ�����ȡ���֣�
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

    //  ��ȡ�ַ����ĳ��ȣ���������ģ���ÿ�������ַ���Ϊ2λ
    function strlen(str) {
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            if (str.charCodeAt(i) > 255) len += 2; else len++;
        }
        return len;
    }

    /*��Ʒ���ƽ�ȡ*/
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
        $("userID").innerHTML = "�û��˺ţ�" + userID;

    }

    /*��ʷ�·ݶ�̬��ȡ*/
    function innerOrdermonth(data) {
        for (var i = 0; i < data.length; i++) {
            $('area3_' + i).innerHTML = data[i]["monthName"];
        }
    }
</script>
</body>

</html>