<%@    page contentType="text/html; charset=GBK" %>
<%@    page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="favorite_service.jsp"/>
<%
    String sdestpage="1";
    String sericeIndex="0";
    String isleft="true";
    String lastfocus = request.getParameter("lastfocus");
    String[] lastfocusArr = null;
       if (lastfocus != null) {
           lastfocusArr = lastfocus.split("_");
           if(lastfocusArr.length>1){
             sdestpage = lastfocusArr[0];
             sericeIndex = lastfocusArr[1];
             isleft="false";
           }
       }
%>
<%

    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();
%>
<html>
<head>
    <title>a</title>

<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript" src="js/json.js"></script>
<script type="" language="javascript">
    var index=0;
    var userid="<%=timeUserInfo.getUserId()%>";
    var sericeIndex = <%=sericeIndex%>;
    var totalservice=0;
    var servicedata;
    var serviceDs;     
    var sdestpage =<%=sdestpage%>;
    var spagecount;
    var isleft=<%=isleft%>;
    var leftFocusTime;
    var cleng = 4;
    var isFoucsLeftIndex;
    var cindex=3;
    var pageleng=5;
    var totalLeng=15;
    var saveInfo;
    var $$ = {};
    function $(id) {
        if (!$$[id]) {
            return document.getElementById(id);
        }
        return $$[id];
    }
    function toPrevPage() {
        if (sdestpage > 1) {
            changeBgImg(0);
            sdestpage--;
            sericeIndex = 0;
            loadFavService(sdestpage);
        }
    }
    function toNextPage() {
        if (spagecount > sdestpage) {
            changeBgImg(0);
            sdestpage++;
            sericeIndex = 0;
            loadFavService(sdestpage);
        }
    }

    var clearDiv = function() {
        for (var i = 0; i < 15; i++) {
            $("messImg" + i).src = "images/btn_trans.gif";
            $("messName" + i).innerText = " ";
        }
    }
    var loadFavService= function (destpage) {
        clearDiv();
        var str = ztebw.getAttribute(userid);
        if (str != null && str != "" && str !="undefined" && str != "[]") {
            serviceDs = eval("(" + str + ")");
            totalservice = serviceDs.length;
            spagecount = parseInt((totalservice - 1) / 15) + 1;
            var startIndex = (sdestpage - 1) * totalLeng;
            var endIndex = startIndex + totalLeng;
            if (endIndex > totalservice) {
                endIndex = totalservice;
            }
            index=0;
            if (totalservice > 0) {
                for (var s = startIndex; s < endIndex; s++) {
                    $("messImg" + index).src = serviceDs[s].cimg;
                    $("messName" + index).innerText = serviceDs[s].cname;
                    index++;
                }
                isFoucsLeftIndex = cindex;
                if (isleft) {
                    $("left" + cindex).src = "images/portal/focus.png";
                } else {
                    changeBgImg(1);
                }
            } else {
                isleft = true;
                changeBgImg(0);
                $("left" + cindex).src = "images/portal/focus.png";
            }
        } else {
            index=0;
            changeBgImg(0);
            $("left" + cindex).src = "images/portal/focus.png";
        }
        showScrollBar();
    }
    function showScrollBar() {
        if (index > 0) {
            var heightX = parseInt(504 / spagecount);
            var topX = 3 + heightX * (sdestpage - 1)
            $("scrollbar2").height = heightX;
            $("scroll").style.top = topX;
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
    }
    function ServiceKeyPress(evt) {
        var keyCode = parseInt(evt.which);
        if (keyCode == 0x0028) {
            ServiceKeyDown();
        } else if (keyCode == 0x0026) {
            ServiceKeyUp();
        } else if (keyCode == 0x0025) { //onKeyLeft
            ServiceKeyLeft();
        } else if (keyCode == 0x0027) { //onKeyRight
            ServiceKeyRight();
        } else if (keyCode == 0x0008) {///back
            document.location = 'back.jsp';
        } else if (keyCode == 0x0022) {  //page down
            toNextPage();
        } else if (keyCode == 0x0021) { //page up
            toPrevPage();
        } else if (keyCode == 280) { //yellow
             delFav();
        } else if (keyCode == 0x0116) {  //green
            //                 goSearch();
        } else if (keyCode == 0x000D) {  //OK
            ServiceKeyOK();
        } else {
            commonKeyPress(evt);
            return true;
        }
        return false;
    }
    var delFav=function(){
        if (!isleft) {
            var dellindex = sericeIndex + (sdestpage - 1) * 15;
            var leng1 = serviceDs.length;
            serviceDs.splice(dellindex, 1);
            var leng2 = serviceDs.length;
            var flag = leng1 == leng2 ? 1 : 0;
            if(sdestpage >1 && totalservice%15==1){
               sdestpage--; 
            }
            showMsg(flag);
        }
    }
    var ServiceKeyOK = function() {
        if (isleft) {
            loadFavService();
        }
        else {
            doServiceOk();
        }
    }
    var doServiceOk = function() {
        saveInfo = sdestpage + "_" + sericeIndex;
        setBackParam(saveInfo);
        top.jsSetControl("isCheckPlay", "0");
        top.doStop();
//        document.location="thirdlink.jsp";
       // alert("SSSSSSSSSSSSSSSSSSSSSSSgotosd="+serviceDs[sericeIndex].gosd);
        if(serviceDs[sericeIndex].gosd == '1'){
            Authentication.CTCSetConfig('SetEpgMode', 'SD');
        }
        document.location = serviceDs[sericeIndex].curl;
    }
    var setBackParam = function (saveInfo) {
        var backurlparam = "<%=timeFrameUrl%>/favorite_service.jsp";
        backurlparam += "?lastfocus=" + saveInfo;
        top.jsSetControl("backurlparam", backurlparam);
        var lastChannelNum = top.channelInfo.currentChannel;
      //  alert("SSSSSSSSSSSSSSSSSSSSfavorite_service_lastChannelNum="+lastChannelNum);
        ztebw.setAttribute("curMixno", lastChannelNum);
        Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
    }
    var ServiceKeyRight = function() {
        if (isleft&&index>0) {
            changgeImg(-1);
            $("left" + isFoucsLeftIndex).src = "images/vod/btv_column_focus.png";
            isleft = false;
            if (leftFocusTime) {
                window.clearTimeout(leftFocusTime);
            }
            changeBgImg(1);
        } else if (index > 0) {
            changeBgImg(0);
            sericeIndex++;
            if (sericeIndex > index - 1) {
                sericeIndex = 0;
            }
            changeBgImg(1);
        }
    }
    var ServiceKeyLeft = function() {
        if (isleft) {
        } else if (index > 0) {
            changeBgImg(0);
            if (sericeIndex %pageleng == 0) {
                isleft = true;
                $("left" + isFoucsLeftIndex).src = "images/portal/focus.png";
            } else {
                sericeIndex--;
                changeBgImg(1);
            }
        }
    }
    var ServiceKeyDown = function() {
        if (isleft) {
            changgeImg(-1);
            if (cindex >= 0 && cindex < cleng) {
                cindex++;
            }
            if (cindex == cleng) {
                cindex = 0;
            }
            changgeImg(1);
            leftSetTime();
        } else if (sericeIndex +pageleng<index) {
            changeBgImg(0);
            sericeIndex = sericeIndex + pageleng;
            changeBgImg(1);
        }
    }
    var ServiceKeyUp = function() {
        if (isleft) {
            changgeImg(-1);
            if (cindex < cleng) {
                cindex--;
            }
            if (cindex < 0) {
                cindex = cleng - 1;
            }
            changgeImg(1);
            leftSetTime();
        } else if (sericeIndex -pageleng>= 0) {
            changeBgImg(0);
            sericeIndex = sericeIndex - pageleng;
            changeBgImg(1);
        }
    }
    var changeBgImg = function(flag) {
        if (flag == 0) {
            $("imgs_" + sericeIndex).style.visibility = "hidden";
        } else {
            $("imgs_" + sericeIndex).style.visibility = "visible";
        }
    }

//    var isZTEBW = false;
//    if(window.navigator.appName == "ztebw"){
//        isZTEBW = true;
//    }
    //isZTEBW = false;

    var favoriteUrl = "";
    if(isZTEBW == true){
        favoriteUrl = "vod_favorite_pre.jsp";
    }else{
        favoriteUrl = "vod_favorite.jsp";
    }


    function changgeImg(flag) {
        if (flag == -1) {
            $("left" + cindex).src = "images/btn_trans.gif";
        } else {
            $("left" + cindex).src = "images/portal/focus.png";
        }
    }
    var gotoUrl = function() {
        document.location = favoriteUrl+"?leftstate="+cindex;
//        if (cindex == 1) {
//            document.location = favoriteUrl"vod_favorite.jsp?leftstate=1";
//        } else if (cindex == 2) {
//            document.location = "vod_favorite.jsp?leftstate=2";
//        } else if (cindex == 0) {
//            document.location = "favorite_portal.jsp?leftstate=0";
//        }
    }
    var leftSetTime = function() {
        if (leftFocusTime) {
            window.clearTimeout(leftFocusTime);
        }
        leftFocusTime = window.setTimeout("gotoUrl()", 2000);
    }
    function showMsg(flag) {
        dellflag = flag;
        if (dellflag == 0) {
            $("text").innerText = "删除成功";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else if (dellflag == 1) {
            $("text").innerText = "删除失败";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        }
    }
    function closeMessage() {
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
        changeBgImg(0);
        isleft = false;
        sericeIndex = 0;
        ztebw.setAttribute(userid, serviceDs.toJSONString());
        loadFavService(1);
        clearTimeout(timer);
    }
</script>
</head>
<body bgcolor="transparent">

<%@ include file="favorite_public.jsp" %>


<div style="position:absolute;">
    <div id="serviceF" style="position:absolute;visibility:visible">
        <%
            int left = 0;
            int top = 0;
            for (int i = 0; i < 15; i++) {
                int row = i / 5;//行
                int cow = i % 5;//列
                left = cow * 180 + 340;
                top = row * 170 + 100;
        %>


        <div id="imgs_<%=i%>"
             style="position:absolute;left:<%=left-5%>px; top:<%=top-4%>px; width:150px;visibility:hidden ">
            <img src="images/community/btv-mytv-appbgc.png" width="116" height="116" alt="" border="0">
        </div>
        <div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;">
            <img id="messImg<%=i%>"name="messImg<%=i%>" src="images/btn_trans.gif" width="105" height="105" alt="" border="0">
        </div>
        <!-- 名称信息 -->
        <div id="messName<%=i%>" style="position:absolute;left:<%=left-35%>px; top:<%=top+110 %>px; width:170px; font-size:24px;color:#ffffff;" align="center"></div>
        <%
            }
        %>


    </div>
</div>
<!--滚动条--->
<div style="position:absolute; width:20px; height:534px; left:1218px; top:103px;">
    <div id="pageBar" style="position:absolute; width:20px; height:534px; left:0px; top:0px;visibility:hidden">
        <div style="position:absolute; width:20px; height:534px; left:0px; top:0px;">
            <img src="images/vod/btv-02-scrollbar.png" border="0" alt="" width="20" height="534">
        </div>
        <div id="scroll" style="position:absolute; width:20px; height:534px; left:3px; top:3px;">
            <img id="scrollbar1" src="images/vod/btv-02-scrollbar01.png" border="0" width="13" height="10">
            <img id="scrollbar2" src="images/vod/btv-02-scrollbar02.png" border="0" width="13" height="10">
            <img id="scrollbar3" src="images/vod/btv-02-scrollbar03.png" border="0" width="13" height="10">
        </div>
    </div>
</div>
 <!-- 底部按钮 -->
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<div style="position:absolute; width:750px; height:38px; left:845px; top:640px;font-size:22px;">
    <div id="pre" style="visibility:visible">
        <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:7;top:4px;color:#424242">上页</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
    </div>
    <div id="next" style="visibility:visible">
        <img src="images/vod/btv_page.png"  width="60" height="31" alt="" style="position:absolute;left:200;top:0px;">
        <font style="position:absolute;left:207;top:4px;color:#424242">下页</font>
        <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
    </div>
</div>
<div style="position:absolute; width:200px; height:38px; left:600px; top:643px;font-size:22px;">
    <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
    <font style="position:absolute;left:7;top:4px;color:#424242">DEL</font>
    <font style="position:absolute;left:90;top:4px;color:#FFFFFF">删除收藏</font>
</div>

<div style="left:460px; top:300px;width:568px;height:215px; position:absolute;z-index:2000">
    <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
        <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
            <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
        </div>
        <div id="text"
             style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
        </div>
        <div id="closeMsg"
             style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;visibility:hidden;"
             align="center">
            2秒自动关闭
        </div>
    </div>
</div>


<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
<script type="text/javascript">
    loadFavService(sdestpage);
    document.onkeypress = ServiceKeyPress;
</script>
</html>