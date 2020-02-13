<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.web.VodContentInfoValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodQueryDataSource" %>
<epg:PageController/>
<html>
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
%>
<%
    String type = request.getParameter("fast");
    String columnid = request.getParameter("columnid");
    String contentid = request.getParameter("contentid");
    String programname = getVodConInf(columnid, contentid, pageContext);

    String imgRR = "images/vod/btv-02-left.png";
    String imgPP = "images/vod/btv-02-pause.png";
    String imgFF = "images/vod/btv-02-right.png";
    int topRR = 20;
    int topPP = 15;
    int topFF = 20;

    if ("RR".equals(type)) {
        imgRR = "images/vod/btv-02-leftc.png";
        topRR = 15;
    } else if ("pause".equals(type)) {
        imgPP = "images/vod/btv-02-pausec.png";
        topPP = 10;
    } else if ("FF".equals(type)) {
        imgFF = "images/vod/btv-02-rightc.png";
        topFF = 15;
    }

%>

<body bgcolor="transparent" onload="pageInit();">

<%--下方进度条背景图片--%>


<div style="left:0; top:574;width:1280;height:146; position:absolute;">
    <div style="left:0; top:0;width:1200;height:146; position:absolute">
        <img src="images/vod/btv-02-progressbg.png" border="0" width="1280" height="146" alt=""/>
    </div>
</div>
<!--状态图标(快进、快退、暂停)-->
<div style="left:0; top:574;width:1280;height:146; position:absolute;">
    <div id="div0" style="left:105; top:<%=topRR%>;width:68;height:68; position:absolute;" align="center">
        <img id="img0" src="<%=imgRR%>" border="0" alt=""/>
    </div>

    <div id="div1" style="left:173; top:<%=topPP%>;width:83;height:83; position:absolute;" align="center">
        <img id="img1" src="<%=imgPP%>" border="0" alt=""/>
    </div>

    <div id="div2" style="left:258; top:<%=topFF%>;width:68;height:68; position:absolute;" align="center">
        <img id="img2" src="<%=imgFF%>" border="0" alt=""/>
    </div>
</div>

<!--当前时间和结束时间-->
<div style="left:1030; top:615;width:80;height:27; position:absolute;font-size:22px;color:#FFFFFF"
     id="currentTimeDiv"></div>
<div style="left:1100; top:615;width:50;height:27;font-size:22px; position:absolute;color:#FFFFFF" id="endTimeDiv">
</div>
<!--快进货快退倍数(2X)-->
<div align="right" style="left:325; top:590;width:40;height:27;font-size:22px;color:#FFFFFF; position:absolute"
     id="speedDiv">
</div>
<!--进度条-->
<div style="left:340; top:625;width:680;height:3; position:absolute;">
    <img id="speedBarDiv" src="images/vod/btv-02-progressred.png" width="4" height="3" alt="">
</div>
<div id="icon" style="left:337; top:615;width:26;height:26; position:absolute; ">
        <img src="images/vod/btv-02-progressico.png" alt="" width="26" height="26" border="0">
</div>

</body>
<script language="javascript" type="">
    var imgarr = ["images/vod/btv-02-leftc.png","images/vod/btv-02-pausec.png","images/vod/btv-02-rightc.png"];
    var imgarr1 = ["images/vod/btv-02-left.png","images/vod/btv-02-pause.png","images/vod/btv-02-right.png"];
    var toparr = [20,15,20];

    var type = "<%=request.getParameter("fast")%>";
    var speed = 1 ;
    var flag = 0;
    function pageResume() {
        if (top.isPlay() == true) {
            top.pageResume();
            top.mainWin.document.location = "portal.jsp?onlymenu=1";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
            return false;
        }
        return true;
    }
    top.jsSetupKeyFunction("top.mainWin.pageResume", <%=STBKeysNew.remoteMenu%>);


    function pagePlayPause() {
        top.jsDoResume();
        top.jsHideOSD();
    }

    //在这个页面按OK和按暂停效果是一样的都是重新播放。
    function pageOnKeyOK() {
        pagePlayPause();
    }

    //快进
    function pageFastForword() {
        var isFF=false;
        if(type=="RR"  || type=="pause"){
          isFF=true;
        }else{
          isFF=false;
        }
        type = "FF";
        speed = top.getStbPlaySpeed();
        if (speed < 0 || speed == 64)
        {
            speed = 2;
        }
        else
        {
            speed = speed * 2;
        }
        //top.mp.fastForward(speed);
        top.doFastForward(speed);
        top.mainWin.document.all.speedDiv.innerHTML = speed + "X";
        if(speed==2 && isFF==true){
          changeImg(2, 15);
        }
    }

    //快退
    function pageFastRewind() {
        var isRR=false;
        if(type=="FF" || type=="pause"){
            isRR=true;
        }else{
            isRR=false;
        }
        type = "RR";
        speed = top.getStbPlaySpeed();
        if (speed > 0 || speed == -64)
        {
            speed = -2;
        }
        else
        {
            speed = speed * 2;
        }
        var nowspeed = -speed;
        top.mainWin.document.all.speedDiv.innerHTML = nowspeed + "X";
        top.doFastRewind(speed);
        if(nowspeed==2 && isRR==true){
          changeImg(0, 15);
        }
    }

    //展示开始和结束的时间
    function pageVODSpeedInitStartAndEnd() {
        var duration = top.jsDoGetVODTimeInfo();
        var VODTimeInfo = parseInt(duration);
        var VODTotalHours = VODTimeInfo / 3600 ;
        VODTotalHours = parseInt(VODTotalHours);
        if (("" + VODTotalHours).length == 1)
        {
            VODTotalHours = "0" + VODTotalHours;
        }
        var StrVODTotalHours = VODTotalHours;
        VODTotalHours = parseInt(VODTotalHours, 10);
        var VODTotalMinutes = (VODTimeInfo - VODTotalHours * 3600) / 60;
        VODTotalMinutes = parseInt(VODTotalMinutes);
        if (("" + VODTotalMinutes).length == 1)
        {
            VODTotalMinutes = "0" + VODTotalMinutes;
        }
        top.mainWin.document.all.endTimeDiv.innerHTML = StrVODTotalHours + ":" + VODTotalMinutes;
    }

    //刷新当前播放时间
    function refreshCurrentTime() {
        // var currentTime = top.mp.getCurrentPlayTime();
        var currentTime = top.jsGetCurrentPlayTime();
        var VODTimeInfo = parseInt(currentTime);
        if (VODTimeInfo == 0)
        {
            top.mainWin.document.all.currentTimeDiv.innerHTML = " / ";
            return;
        }
        var VODTotalHours = VODTimeInfo / 3600 ;
        VODTotalHours = parseInt(VODTotalHours);
        if (("" + VODTotalHours).length == 1)
        {
            VODTotalHours = "0" + VODTotalHours;
        }
        var StrVODTotalHours = VODTotalHours;
        VODTotalHours = parseInt(VODTotalHours, 10);
        var VODTotalMinutes = (VODTimeInfo - VODTotalHours * 3600) / 60;
        VODTotalMinutes = parseInt(VODTotalMinutes);
        if (("" + VODTotalMinutes).length == 1)
        {
            VODTotalMinutes = "0" + VODTotalMinutes;
        }
        top.mainWin.document.all.currentTimeDiv.innerHTML = StrVODTotalHours + ":" + VODTotalMinutes + " / ";
    }

    //
    function setRefreshBarTimer() {
        if (type != "pause")
        {
            pageRefreshBarState();
        }
        setTimeout("setRefreshBarTimer()", 1000);
    }

    //控制当前播放时间的进度展示
    function pageRefreshBarState() {
        var state = top.getStatus();
        if (flag == 3 && state == "Normal Play")
        {
            top.hideOSD();
            return;
        }
        else
        {
            flag += 1;
        }
        var currTime = parseInt(top.jsGetCurrentPlayTime());
        if (currTime == -1)
        {
            return;
        }
        refreshCurrentTime();
        refreshBarLength();
    }

    //刷新进度条播放长度
    function refreshBarLength() {
        var tempCurrentTime = top.jsGetCurrentPlayTime();
        var tempEndTime = top.jsDoGetVODTimeInfo();
        var tempLength = (tempCurrentTime * 680) / tempEndTime;
        tempLength = parseInt(tempLength);
       if (tempLength == 0)
        {
            top.mainWin.document.all.speedBarDiv.style.width = 1;
            top.mainWin.document.all.icon.style.left = 337;
        }
        else if (tempLength >= 680)
        {
            top.mainWin.document.all.speedBarDiv.style.width = 680;
            top.mainWin.document.all.icon.style.left = tempLength+333;
        }
        else
        {
            top.mainWin.document.all.speedBarDiv.style.width = tempLength;
            top.mainWin.document.all.icon.style.left = tempLength+333;
        }
    }
    function changeImg(index, topvalue) {
        for (var i = 0; i < 3; i++) {
            if (i == index) {
                top.mainWin.document.getElementById("img" + i).src = imgarr[i];
                top.mainWin.document.getElementById("div" + i).style.top = topvalue;
           } else{
                top.mainWin.document.getElementById("img" + i).src = imgarr1[i];
                top.mainWin.document.getElementById("div" + i).style.top = toparr[i];
            }
        }
    }
   function onkeypress(evt) {
        var keyCode = parseInt(evt.which);
       // alert("SSSSSSSSSSSSSSSSSonkeypress_keyCode="+keyCode);
        if (keyCode == 0x0008  || keyCode == 24) {  //back
//            pageOnKeyOK();
            return false;
        } else {
            top.doKeyPress(evt);
            return true;
        }
        return false;
    }
    function pageInit() {
        top.jsSetupKeyFunction("top.mainWin.pageFastRewind", 0x0109);
        top.jsSetupKeyFunction("top.mainWin.pageFastForword", 0x0108);
        top.jsSetupKeyFunction("top.mainWin.pageFastRewind", <%=STBKeysNew.onKeyLeft%>);
        top.jsSetupKeyFunction("top.mainWin.pageFastForword", <%=STBKeysNew.onKeyRight%>);


        top.jsSetupKeyFunction("top.mainWin.pageOnKeyOK", 0x000d);
        top.jsSetupKeyFunction("top.mainWin.pagePlayPause", 0x0107);
        if (type == "FF") {
            top.mainWin.document.all.speedDiv.innerHTML = "2X";
        } else if (type == "RR") {
            top.mainWin.document.all.speedDiv.innerHTML = "2X";
        } else if (type == "pause") {
            top.mainWin.document.all.speedDiv.innerHTML = "";
            pageRefreshBarState();
        }
       document.onkeypress=onkeypress;
        pageVODSpeedInitStartAndEnd();
        setRefreshBarTimer();
    }
    document.onkeypress = top.doKeyPress;
    focus();
</script>
</html>
