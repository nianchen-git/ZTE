<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.web.VodContentInfoValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodQueryDataSource" %>
<epg:PageController/>
<%!
    public String getVodConInf(String columnId, String contentId, PageContext pageContext) {
        VoDContentInfo vodConInf = null;
        try {
            UserInfo userInfoForFav = (UserInfo) pageContext.getSession().getAttribute(EpgConstants.USERINFO);
            VodQueryDataSource vodDs = new VodQueryDataSource();
            VodContentInfoValueIn vodValueIn = (VodContentInfoValueIn) vodDs.getValueIn();
            vodValueIn.setSubjectCode(columnId);
            vodValueIn.setUserInfo(userInfoForFav);
            vodValueIn.setContentCode(contentId);
            EpgResult result = vodDs.getData();
            vodConInf = (VoDContentInfo) result.getData();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return vodConInf.getProgramName();
    }
 public String formatName(Object oldName) {
        String newName = String.valueOf(oldName);
        if (!"null".equals(newName)) {
//            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\\\\", "\\\\\\\\");
            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\'", "\\\\\'");
        } else {
            newName = "";
        }
        return newName;
    }
%>
<%
    String columnid = request.getParameter("columnid");
    String contentid = request.getParameter("contentid");
    String programname = getVodConInf(columnid, contentid, pageContext);
	programname = formatName(programname);
%>
<html>
<head>
    <title>osd</title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script language="javascript" type="">
         var $$ = {};
         var timer=-1;
         function $(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        function changeImage(flag, id) {
            if (flag == 1) {
                document.getElementById(id).style.visibility = "visible";
                document.getElementById(id + "0").style.visibility = "hidden";
            } else {
                document.getElementById(id).style.visibility = "hidden";
                document.getElementById(id + "0").style.visibility = "visible";
            }
        }
        function delayStop() {
            top.vodBackTimer = top.setTimeout("top.switchToStopOSDUrl(0)", 600);
        }
        //play end
        function pageDoVodStop() {
            var currentChannel = top.channelInfo.currentChannel;
            if (currentChannel == -1) {
                currentChannel = top.channelInfo.lastChannel;
            }
            // 判断将要播放的频道是否在童锁列表里，在的话在童锁输入密码页面请求弹出前一个页面
            delayStop();
            top.jsHideOSD();
            top.doStop();
            top.setBwAlpha(0);
            if (top.channelInfoArr[currentChannel] != undefined && top.channelInfoArr[currentChannel] != null) {
                if (top.channelInfoArr[currentChannel].channelType != 3) {
                    top.jsRedirectChannel(currentChannel);
                }
            }
 //加载频道结束后，显示上一页，防止重复
            delayStop();
        }
        function favoritedo() {
            var favUrl = "action/favorite_add.jsp?SubjectID=<%=columnid%>"
                    + "&ContentID=<%=contentid%>"
                    + "&FavoriteTitle=<%=programname%>";
            var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showMsg);
        }
        function showMsg() {
            var results = this.req.responseText;
            var tempData = eval("(" + results + ")");
            var dellflag = tempData.requestflag;
            if (dellflag == 0) {
                $("text").innerText = "收藏成功";
                $("msg").style.visibility = "visible";
                timer = window.setTimeout(closeMessage, 1000);
            } else if (dellflag == 2) {
                $("text").innerText = "节目已收藏";
                $("msg").style.visibility = "visible";
                timer = window.setTimeout(closeMessage, 1000);
            } else if (dellflag == 3) {
                $("text").innerText = "您的收藏已达上限";
                $("msg").style.visibility = "visible";
                timer = window.setTimeout(closeMessage, 1000);
            } else {
                $("text").innerText = "收藏失败";
                $("msg").style.visibility = "visible";
                timer = window.setTimeout(closeMessage, 1000);
            }
        }
        function closeMessage() {
            window.clearTimeout(timer);
            pageDoVodStop();
        }

    </script>
</head>
<body bgcolor="transparent">
<div style="left:440px; top:250px;width:400px;height:200px; position:absolute;">
    <img src="images/vod/btv_promptbg.png" border="0" alt="" width="400" height="200">
</div>


<div style="position:absolute;width:400;height:30;left:440;top:300;font-size:24px;color:#FFFFFF;" align="center" id="text">
    您是否需要收藏此节目
</div>
<!--stop-->
<div style="left:450; top:10;width:90;height:30px; position:absolute;">
    <a href="javascript:favoritedo();" name="llinkerplay"
       onFocus="changeImage('1','divtrail');"
       onBlur="changeImage('0','divtrail')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div style="left:450; top:400px;width:176;height:38px; position:absolute;">
    <div id="divtrail0" style="left:0; top:0px;width:176;height:38px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquit.png" width="176" height="38" border="0" alt=""/>
    </div>
    <div id="divtrail" style="left:0; top:0px;width:176;height:38px; position:absolute;visibility:hidden">
        <img src="images/vod/btv-02-add-bookmarkc.png" width="176" height="38" border="0" alt=""/>
    </div>
</div>
<div style="position:absolute; left:450px; top:405px ;width:176;font-weight:bold" align="center">
    <font size="5" color="#FFFFFF">确定</font>
</div>


<!--cancle-->
<div style="left:650; top:10px;width:94px;height:30px; position:absolute;">
    <a href="javascript:pageDoVodStop();" name="llinkerplay2"
       onFocus="changeImage('1','canclediv');"
       onBlur="changeImage('0','canclediv')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div style="left:650; top:400px;width:176px;height:38px; position:absolute;">
    <div id="canclediv0" style="left:0; top:0;width:176px;height:38px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquit.png" width="176" height="38" border="0" alt=""/>
    </div>
    <div id="canclediv" style="left:0; top:0px;width:176px;height:38px; position:absolute;visibility:hidden">
        <img src="images/vod/btv-02-add-bookmarkc.png" width="176" height="38" border="0" alt=""/>
    </div>
</div>
<div style="position:absolute; left:640; top:405px; width:176px" align="center">
    <font size="5" color="#FFFFFF">返回</font></div>
</div>

 <!--收藏提示信息-->
    <div style="left:420px; top:229px;width:568px;height:215px; position:absolute;z-index:2000">
        <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
            <div style="left:21px;top:140px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
                 2秒自动返回
            </div>
        </div>
    </div>


<%@ include file="inc/lastfocus.jsp" %>
<script language="javascript" type="">
    function doMyKeyPress(evt){
        var keycode = evt.which;
        if (keycode == 0x0008  || keycode == 24){
            pageDoVodStop();
        }else{
            commonKeyPress(evt);
        }
    }

    document.onkeypress = doMyKeyPress;
</script>
</body>
</html>
