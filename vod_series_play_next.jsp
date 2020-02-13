<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ include file="inc/words.jsp" %>
<epg:PageController/>
<html>
<head>
    <title>osd</title>
    <script language="javascript" type="">
        var curNextUrl = top.jsGetControl("sitcom_nexturl");
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
            var lockChannelList = top.lockChannelList;
            lockChannelList = "," + lockChannelList + ",";
            if (lockChannelList.indexOf("," + currentChannel + ",") < 0) {
                delayStop();
            } else {
                top.jsSetControl("CHANNEL_ISINLOCK", "1");
            }
            top.jsHideOSD();
            top.doStop();
            top.setBwAlpha(0);
            if (top.channelInfoArr[currentChannel] != undefined && top.channelInfoArr[currentChannel] != null) {
                if (top.channelInfoArr[currentChannel].channelType != 3) {
                    top.jsRedirectChannel(currentChannel);
                }
            }
        }
        function playnext() {
            top.setBwAlpha(0);
            top.doStop();
          //  alert("=================curNextUrl================" + curNextUrl);
            document.location = curNextUrl;
        }


    </script>
</head>
<body bgcolor="transparent">
<div style="left:440px; top:250px;width:400px;height:200px; position:absolute;">
    <img src="images/vod/btv_promptbg.png" border="0" alt="" width="400" height="200">
</div>


<div style="position:absolute;width:400;height:30;left:440;top:300;font-size:24px;color:#FFFFFF;" align="center">
    您是否需要播放下一集
</div>
<!--stop-->
<div style="left:450; top:10;width:90;height:30px; position:absolute;">
    <a href="javascript:playnext();" name="llinkerplay"
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
