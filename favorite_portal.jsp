<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="favorite_portal.jsp"/>
<%
    String menuIndex = "";
    String lastfocus = request.getParameter("lastfocus");

    String sdestpage = "";
    String rightIndex = "";
    boolean isleft=true;
    String[] lastfocusArr = null;
    if (lastfocus != null) {
        lastfocusArr = lastfocus.split("_");
        menuIndex = lastfocusArr[0];
        rightIndex = lastfocusArr[1];
    }

    if (lastfocusArr != null && lastfocusArr.length > 2) {
        sdestpage = lastfocusArr[2];
    }
    if (lastfocusArr != null && lastfocusArr.length > 3) {
        if(!lastfocusArr[3].equals("true")){
           isleft=false;
        }
    }
    if (sdestpage == null || sdestpage.equals("")) {
        sdestpage = "1";
    }
    if (menuIndex == null || menuIndex.equals("")) {
        menuIndex = "0";
    }
    if (rightIndex == null || rightIndex.equals("")) {
        rightIndex = "0";
    }
    if (request.getParameter("menuIndex") != null) {
        menuIndex = request.getParameter("menuIndex");
    }

%>
<html>
<head>
<title>fav</title>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript">
var $$ = {};
var vard;
var catedata;
var curMaxNo;
var curchannelName;
var curcolumnid;
//var isOnfocus = 0;
var vdestpage =<%=sdestpage%>;
var vpagecount;
var vleng;
var isleft = <%=isleft%>;
var vindex = <%=rightIndex%>;
var cleng = 4;
var cindex = <%=menuIndex%>;
var isCanShowp = true;
var isTops = false;
var topIndex = 0;
var delList = new Array();
var delInfo = new Array();
var delIndex = 0;
var isForOp = false;
var opIndex = 0;
var dellflag;
var isFoucsLeftIndex =<%=menuIndex%>;
var channeloutTime;
var saveInfo;
var leftFocusTime;
function $(id) {
    if (!$$[id]) {
        return document.getElementById(id);
    }
    return $$[id];
}
var initByIndex = function() {
    if (cindex == 0) {
        showInfo();
    } else if (cindex == 1) {
        document.location = "vod_favorite.jsp?leftstate=1";
    } else if (cindex == 2) {
        document.location = "vod_favorite.jsp?leftstate=2";
    } else{
        document.location = "favorite_service.jsp?leftstate=3"; 
    }
    //    } else {
    //        $("channelF").style.visibility = "hidden";
    ////        $("serviceF").style.visibility = "visible";
    //        $("topMessage").style.visibility = "hidden";
    //        $("left" + isFoucsLeftIndex).src = "images/btn_trans.gif";
    //        loadFavService();
    //    }
}
var gotoUrl=function(){
     if (cindex == 1) {
        document.location = "vod_favorite.jsp?leftstate=1";
    } else if (cindex == 2) {
        document.location = "vod_favorite.jsp?leftstate=2";
    }else if(cindex==3){
        document.location = "favorite_service.jsp?leftstate=3";
    }
}
var leftSetTime = function() {
    if (leftFocusTime) {
        window.clearTimeout(leftFocusTime);
    }
    leftFocusTime = window.setTimeout("gotoUrl()", 500);
}
var showInfo = function() {
    var requestUrl = "action/channel_favorite_data.jsp?destpage=" + vdestpage;
    var loaderSearch = new net.ContentLoader(requestUrl, channelProgram);
}
function channelProgram() {
    clearProdiv();
    clearChanneldiv();
    var results = this.req.responseText;
    catedata = eval("(" + results + ")");
    vard = catedata.Data;
    vdestpage = catedata.destpage;
    vpagecount = catedata.pageCount;
    vleng = vard.length;
    if (vleng > 0) {
        $("channelF").style.visibility = "visible";
        for (var a = 0; a < vleng; a++) {
            var names = vard[a].favoriteTitle;
            var lists = names.split("&");
            var mNo = vard[a].maxNo;
            if (mNo.length == 1) {
                mNo = "00" + mNo;
            }
            if (mNo.length == 2) {
                mNo = "0" + mNo;
            }
//            $("tv_" + a).innerText = writeFitString(lists[0], 22, 120); //
            $("tv_" + a).innerText = writeFitStringNirui(lists[0],123, 22,13 ,11);
            $("max_" + a).innerText = mNo;
            for (var i = 0; i < delList.length; i++) {
                if (delInfo[i] == vard[a].maxNo) {
                    if (!isCanShowp) {
                        $("bgtv_x" + a).style.visibility = "visible";
                    }
                }
            }
        }
        if (isTops && topIndex == 0) {
            $("top" + topIndex + "f").style.visibility = "visible";
        } else if(isleft){
            changgeImg(1);
        } else {
            if (isCanShowp) {
                if (channeloutTime) {
                    clearTimeout(channeloutTime);
                }
                channeloutTime = setTimeout("showFocusTv()", 500);
            }
            $("bg_pro" + vindex).style.visibility = "visible";
            isleft = false;
            $("left" + cindex).src = "images/vod/btv_column_focus.png";

        }
    } else {
        isleft=true;
        changgeImg(1);
    }
    isFoucsLeftIndex = cindex;
}
var clearChanneldiv = function() {
    for (var i = 0; i < vleng; i++) {
        $("tv_" + i).innerText = "";
        $("max_" + i).innerText = "";
        $("bgtv_x" + i).style.visibility = "hidden";
    }
}
function cateKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) {
        cateKeyDown();
    }
    else if (keyCode == 0x0026) {
        cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        cateKeyRight();
    } else if (keyCode == 0x0008) {///back
        cateBack();
    } else if (keyCode == 0x0022) {  //page down
        toNextPage();
    } else if (keyCode == 0x0021) { //page up
        toPrevPage();
    } else if (keyCode == 0x0115) { //yellow

    } else if (keyCode == 0x0116) {  //green
        //                                 goSearch();
    } else if (keyCode == 0x000D) {  //OK
        cateKeyOK();
    } else {
        //                clearStack();
        commonKeyPress(evt);
        return true;
    }
    return false;
}

function toPrevPage() {
    if (vdestpage > 1) {
        vdestpage--;
        var requestUrl = "action/channel_favorite_data.jsp?destpage=" + vdestpage;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgram);
    }
}

function toNextPage() {
    if (vpagecount > vdestpage) {
        vdestpage++;
        var requestUrl = "action/channel_favorite_data.jsp?destpage=" + vdestpage;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgram);
    }
}
//var goSearch = function() {
//    document.location = "vod_search.jsp";
//}
var cateKeyOK = function() {
    if (isTops && !isForOp) {
        doTopOk();
    } else if (isForOp) {
        isForOp = false;
        doOptionOk();
    } else if (isleft) {
        initByIndex();
    }
    else {
        doChannelOk();
    }
}
var doOptionOk = function () {
    if (opIndex == 0) {
        var requestUrl = "action/channel_favorite_del.jsp?delall=all&SubjectID='1'&ContentID='1'&FavoriteTitle='1'&type=channel&count=" + delList.length;
        var loaderSearch = new net.ContentLoader(requestUrl, showdellFav);
        $("top" + topIndex + "f").style.visibility = "hidden";
        $("top" + topIndex).style.visibility = "visible";
        isTops = false;
    }
    $("clearInfo").style.visibility = "hidden";
}
function showdellFav() {
    var timer;
    var results = this.req.responseText;
    var tempData = eval("(" + results + ")");
    var dellCount = tempData.dellCount;
    var failCount = tempData.failCount;
    if (failCount == 0 && dellCount == 0) {
        $("text").innerText = "请选择需要删除的数据";
    } else {
        $("text").innerText = "您成功删除了" + dellCount + "条数据";
    }
    $("msg").style.visibility = "visible";
    clearTimeout(timer);
    timer = setTimeout(closeMessage, 2000);
}
function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    if (cindex == 0) {
        showInfo();
    }
}
function changeBg(flag){
    for(var i=0;i<20;i++){
        var widths;
        var  lefts = 300 + i % 4 * 230;
        if(flag==0){
            widths=185;
           lefts=lefts+40;
        }else{
           widths=222;
           lefts=lefts+5;
        }
        $("bg_pro"+i).style.left=lefts;
        $("bg_pro"+i).style.width=widths;
    }
}
var doTopOk = function() {
    if (topIndex == 0) {
        if (isCanShowp) {
            $("buttonone").innerText = "确定";
            $("buttontwo").innerText = "取消";
            $("info").style.visibility = "visible";
            changeBg(1);
            isCanShowp = false;
        } else {
            var deltitle = "";
            var delSubject = "";
            var delContent = "";
            for (var i = 0; i < delList.length; i++) {
                var names = vard[i].favoriteTitle;
                var lists = names.split("&");
                deltitle = deltitle + lists[0] + "__";
                delSubject = delSubject + vard[delList[i]].tvcolumnid + "__";
                delContent = delContent + vard[delList[i]].maxNo + "__";
            }

            var requestUrl = "action/channel_favorite_del.jsp?SubjectID=" + delSubject + "&ContentID=" + delContent + "&FavoriteTitle=" + deltitle + "&type=CHANNEL&count=" + delList.length;
            var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
            clearDelIco();
            $("top" + topIndex + "f").style.visibility = "hidden";
            $("top" + topIndex).style.visibility = "visible";

        }
    } else {
        if (isCanShowp) {
            isForOp = true;
            opIndex = 0;
            $("clearInfo").style.visibility = "visible";
            $("doNf").style.visibility = "hidden";
            $("doYf").style.visibility = "visible";


        } else {
            $("buttonone").innerText = "编辑";
            $("buttontwo").innerText = "清空";
            $("info").style.visibility = "hidden";
            changeBg(0);
            clearDelIco();
            isCanShowp = true;
        }

    }
}
var doChannelOk = function() {
    if (!isCanShowp) {

//        $("bg_del" + vindex).style.visibility = "hidden";
        var isBool = 0;
        if (delList.length > 0) {
            for (var i = 0; i < delList.length; i++) {
                if (delList[i] == vindex) {
                    isBool = 1;
                }
            }
        }
        if (isBool == 0) {
            $("bgtv_x" + vindex).style.visibility = "visible";
            delList[delIndex] = vindex;
            delInfo[delIndex] = vard[vindex].maxNo;
            delIndex++;
        }else{
            $("bgtv_x" + vindex).style.visibility = "hidden";

            for (var i = 0; i < delList.length; i++) {
                if (delInfo[i] == vard[vindex].maxNo) {
                    delList.splice(i,1);
                    delInfo.splice(i,1);
                }
            }
            delIndex--;
        }
    } else {
        saveInfo = cindex + "_" + vindex + "_" + cdestpage+"_"+isleft;
        document.location = "channel_play.jsp?mixno=" + vard[vindex].maxNo + "&leefocus=" + saveInfo;
    }
}
var clearDelIco = function() {
    for (var i = 0; i < delList.length; i++) {

        $("bgtv_x" + delList[i]).style.visibility = "hidden";

    }
    delIndex = 0;
    delInfo = new Array();
    delList = new Array();
}

function cateBack() {
    document.location = 'back.jsp';
}
var showFocusTv = function() {
    var names = vard[vindex].favoriteTitle;
    var lists = names.split("&");
    var requestUrl = "action/channel_programD.jsp?channelid=" + lists[1] + "&columnid=" + vard[vindex].tvcolumnid + "&maxno=" + vard[vindex].maxNo;
    var loaderSearch = new net.ContentLoader(requestUrl, showtvProgram);
}

function showtvProgram() {
    clearProdiv();
    var results = this.req.responseText;
    catedata = eval("(" + results + ")");
    var names = vard[vindex].favoriteTitle;
    var lists = names.split("&");
    $("ids").innerHTML = vard[vindex].maxNo + "&nbsp;&nbsp;&nbsp;" + lists[0];
    $("currentProgram").innerHTML = "<br>" + catedata.curprogram;
    $("nextProgram").innerHTML = "<br>" + catedata.nextprogram;
    $("thirdProgram").innerHTML = "<br>" + catedata.thirdprogram;
    $("firstP").style.visibility = "visible";
    $("programInfo").style.visibility = "visible";
}

var clearProdiv = function() {
    if (channeloutTime) {
      clearTimeout(channeloutTime);
    }
    $("ids").innerText = "";
    $("currentProgram").innerText = "";
    $("nextProgram").innerText = "";
    $("thirdProgram").innerText = "";
    $("firstP").style.visibility = "hidden";
    $("programInfo").style.visibility = "hidden";
}
function cateKeyLeft() {
    if (isForOp) {
        $("doNf").style.visibility = "hidden";
        $("doYf").style.visibility = "visible";
    } else {
        if (isTops) {
            if (topIndex == 0) {
                isleft = true;
                isTops = false;
                $("top" + topIndex + "f").style.visibility = "hidden";
                $("top" + topIndex).style.visibility = "visible";
                changgeImg(1);
                leftSetTime();
            }
            else {
                $("top" + topIndex + "f").style.visibility = "hidden";
                $("top" + topIndex).style.visibility = "visible";
                topIndex = 0;
                $("top" + topIndex + "f").style.visibility = "visible";
                $("top" + topIndex).style.visibility = "hidden";
            }
        } else {
            if (!isleft) {
//                $("bg_del" + vindex).style.visibility = "hidden";
                $("bg_pro" + vindex).style.visibility = "hidden";
                if (vindex % 4 == 0) {
                    isleft = true;
                    changgeImg(1);
                    leftSetTime();
                    clearProdiv();
                } else {
                    if (vindex % 4 > 0) {
                        vindex --;
                    }
                    if (isCanShowp) {
                        if (channeloutTime) {
                            clearTimeout(channeloutTime);
                        }
                        channeloutTime = setTimeout("showFocusTv()", 500);
                    }
                    $("bg_pro" + vindex).style.visibility = "visible";
                }
            }
        }
    }
}
//function isShowDel(){
//    $("bg_del" + vindex).style.visibility = "visible";
//    if (delList.length > 0) {
//        for (var i = 0; i < delList.length; i++) {
//            if (delList[i] == vindex) {
//                $("bg_del" + vindex).style.visibility = "hidden";
//            }
//        }
//    }
//
//}
function cateKeyRight() {
    if (isForOp) {
        $("doYf").style.visibility = "hidden";
        $("doNf").style.visibility = "visible";
        opIndex = 1;
    } else {
        if (isTops) {

            $("top" + topIndex + "f").style.visibility = "hidden";
            $("top" + topIndex).style.visibility = "visible";
            topIndex ++;
            if (topIndex > 1) {
                topIndex = 0;
            }
            $("top" + topIndex + "f").style.visibility = "visible";
            $("top" + topIndex).style.visibility = "hidden";
        }
        else {
            if (isleft && vleng > 0) {
                isleft = false;
                changgeImg(-1);
                $("left" + isFoucsLeftIndex).src = "images/vod/btv_column_focus.png";
                cindex=isFoucsLeftIndex;
                if(leftFocusTime){
                  window.clearTimeout(leftFocusTime);
                }
                $("bg_pro" + vindex).style.visibility = "visible";
                if (isCanShowp) {
                    if (channeloutTime) {
                        clearTimeout(channeloutTime);
                    }
                    channeloutTime = setTimeout("showFocusTv()", 500);
                }
            } else if (vleng > 0) {
//                $("bg_del" + vindex).style.visibility = "hidden";
                $("bg_pro" + vindex).style.visibility = "hidden";
                if (vindex == vleng - 1) {
                    vindex = 0;
                } else {
                    vindex = vindex + 1;
                }
                if (isCanShowp) {
                    if (channeloutTime) {
                        clearTimeout(channeloutTime);
                    }
                    channeloutTime = setTimeout("showFocusTv()", 500);
                }
                $("bg_pro" + vindex).style.visibility = "visible";

            }
        }
    }
}
function cateKeyUp() {
    if (!isForOp) {
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
        } else if (vleng > 0) {

            if (vindex / 4 < 1) {
                $("bg_pro" + vindex).style.visibility = "hidden";
//                $("bg_del" + vindex).style.visibility = "hidden";
                if (vindex == 0) {
                    $("top" + topIndex + "f").style.visibility = "visible";
                    $("top" + topIndex).style.visibility = "hidden";
                } else {
                    topIndex = 1;
                    $("top" + topIndex + "f").style.visibility = "visible";
                    $("top" + topIndex).style.visibility = "hidden";
                }
                isTops = true;
                vindex = 0;
                clearProdiv();
            } else {
//                $("bg_del" + vindex).style.visibility = "hidden";
                $("bg_pro" + vindex).style.visibility = "hidden";
                vindex = vindex - 4;
                if (isCanShowp) {
                    if (channeloutTime) {
                        clearTimeout(channeloutTime);
                    }
                    channeloutTime = setTimeout("showFocusTv()", 500);
                }

                $("bg_pro" + vindex).style.visibility = "visible";
            }
        }
    }
}
function cateKeyDown() {
    if (!isForOp) {
        if (isTops) {
            $("top" + topIndex + "f").style.visibility = "hidden";
            $("top" + topIndex).style.visibility = "visible";
            topIndex = 0;
            if (vleng > 0) {
                isTops = false;
                if (isCanShowp) {
                    if (channeloutTime) {
                        clearTimeout(channeloutTime);
                    }
                    channeloutTime = setTimeout("showFocusTv()", 500);
                }
                $("bg_pro" + vindex).style.visibility = "visible";
            }
        } else {
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
            } else if (vleng > 0) {
//                $("bg_del" + vindex).style.visibility = "hidden";
                $("bg_pro" + vindex).style.visibility = "hidden";
                if (vindex < vleng - 4) {
                    vindex = vindex + 4;
                } else{
                     var row=parseInt(vindex/4);
                     vindex = vindex - 4*row;
//                    vindex = vindex % 4 + 1;
//                    if (vindex == 4) {
//                        vindex = 0;
//                    }
                }
                if (isCanShowp) {
                    if (channeloutTime) {
                        clearTimeout(channeloutTime);
                    }
                    channeloutTime = setTimeout("showFocusTv()", 500);
                }
                $("bg_pro" + vindex).style.visibility = "visible";
            }
        }
    }
}
function changgeImg(flag){
    if(flag==-1){
      $("left" + cindex).src = "images/btn_trans.gif";
    }else{
      $("left" + cindex).src = "images/portal/focus.png";
    }
}
</script>

<meta name="page-view-size" content="1280*720">
</head>

<body bgcolor="transparent">
<%@ include file="favorite_public.jsp" %>
<%--频道--%>
<div style="position:absolute;font-size:22;color:#ffffff;">
    <div id="channelF" style="position:absolute;visibility:hidden;width:1000;height:600;">
        <%
            for (int i = 0; i < 20; i++) {
                int lefts = 300 + i % 4 * 230;
                int tops = 150 + i / 4 * 55;
        %>
        <div id="bg_pro<%=i%>"
             style="left:<%=lefts+40%>;top:<%=tops-7%>; background:url('images/portal/focus1.png');  position:absolute;width:185;height:40;visibility:hidden;">

        </div>
        <%--<div id="bg_pro<%=i%>"--%>
             <%--style="left:<%=lefts+5%>;top:<%=tops-7%>; background:url('images/portal/focus.png');  position:absolute;width:205;height:40;visibility:hidden;">--%>

        <%--</div>--%>
        <%--<div id="bg_del<%=i%>"--%>
             <%--style="left:<%=lefts+217%>;top:<%=tops%>; position:absolute;width:40;font-weight:bold; height:40;font-size:25px; color:#FFFFFF; visibility:hidden;">--%>
            <%--X--%>
        <%--</div>--%>
        <div id="max_<%=i%>"
             style="left:<%=lefts+45%>; top:<%=tops%>;position:absolute;width:44;height:40; "
             align="left">
        </div>
        <div id="tv_<%=i%>"
             style="left:<%=lefts+81%>; top:<%=tops%>; position:absolute;width:130;height:40;"
             align="left">
        </div>

        <div id="bgtv_x<%=i%>"
             style="left:<%=lefts+5%>;top:<%=tops-7%>; position:absolute;width:40;height:40;visibility:hidden;">
            <img src="images/channel/btv-mytv-cancelclick.png" width="40" height="40" alt=""/>
        </div>
        <%}%>
        <div id="programInfo" style="position:absolute;visibility:visible;font-size:22;top:12">
            <div
                    style="background:url('images/liveTV/channel_programinfo.png'); left:0px;top:525px;position:absolute; width:1280px; height:100px;">

                <div style="left:51;top:37;height:70;width:321;position:absolute;">
                    <img name="bottom_bg" src="images/channel/channel_bottom_focus.png" width="321" height="51" alt=""/>
                </div>
                <div style="left:371;top:38;height:48;width:321;position:absolute; border-right:1px solid white; border-top:1px solid white; border-bottom:1px solid white; ">
                    <%--<img name="bottom_bg" src="images/channel/channel_bottom_blur.png" height="51" alt=""/>--%>
                </div>
                <div style="left:691;top:38;height:48;width:321;position:absolute; border-right:1px solid white; border-top:1px solid white; border-bottom:1px solid white; ">
                    <%--<img name="bottom_bg" src="images/channel/channel_bottom_blur.png" height="51" alt=""/>--%>
                </div>
            </div>
            <div id="ids"
                 style="left:51;top:535;height:10;width:1000;position:absolute;">
            </div>
            <div id="currentProgram"
                 style="padding-left:10px;left:51;top:540;height:70;width:320;position:absolute;">
            </div>
            <div id="nextProgram"
                 style="padding-left:10px;left:372;top:540;height:70;width:320;position:absolute;">
            </div>
            <div id="thirdProgram"
                 style="padding-left:10px;left:693;top:540;height:70;width:320;position:absolute;">
            </div>
            <div id="firstP" style="left:1020;top:562;height:68;width:174;position:absolute;visibility:hidden">
                <epg:FirstPage width="203" height="51" location="guanggao04"/>
            </div>
        </div>
        <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
        </div>
        <div style="position:absolute; width:750px; height:38px; left:805px; top:640px;font-size:22px;">
            <div id="pre" style="visibility:visible">
                <img src="images/vod/btv_page.png" alt="" width="60" height="31">
                <font style="position:absolute;left:7;top:4px;color:#424242">上页</font>
                <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
            </div>
            <div id="next" style="visibility:visible">
                <img src="images/vod/btv_page.png" alt="" width="60" height="31"
                     style="position:absolute;left:200;top:0px;">
                <font style="position:absolute;left:207;top:4px;color:#424242">下页</font>
                <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
            </div>
        </div>
    </div>
</div>


<div id="topMessage" style="top:38;left:90;position:absolute;font-size:22px;color:#ffffff;visibility:visible;">
    <div id="top0" style=" position:absolute; left:250;top:53;width:150;height:50; ">
        <img src="images/vod/btv-02-add-bookmarkquit.png" alt="" height="36" width="150"/>
    </div>
    <div id="top0f" style=" position:absolute; left:250;top:53;width:150;height:50;visibility:hidden; ">
        <img src="images/vod/btv-02-add-bookmarkc.png" alt="" height="36" width="150"/>
    </div>
    <div id="buttonone" style=" position:absolute; left:250;top:53;width:150;height:36; line-height:36px "
         align="center">
        编辑
    </div>
    <div id="top1" style=" position:absolute; left:440;top:53;width:150;height:38; ">
        <img name="top1" src="images/vod/btv-02-add-bookmarkquit.png" height="36" alt="" width="150"/>
    </div>
    <div id="top1f" style=" position:absolute; left:440;top:53;width:150;height:50;visibility:hidden; ">
        <img src="images/vod/btv-02-add-bookmarkc.png" height="36" alt="" width="150"/>
    </div>
    <div id="buttontwo" style=" position:absolute; left:440;top:53;width:150;height:36; line-height:36px"
         align="center">
        清空
    </div>
    <div id="info"
         style=" position:absolute; left:640;top:53;width:400;height:36; line-height:36px;visibility:hidden ">
        请标记要删除的收藏频道，选择确定删除
    </div>
</div>
<div id="clearInfo"
     style=" position:absolute; left:450;top:250;width:370;height:200;font-size:22px;color:#ffffff;visibility:hidden ">
    <img src="images/vod/btv_promptbg.png" alt="" width="370" height="200"/>

    <div style="position:absolute; left:0;top:70;width:370;height:100;" align="center">
        确定要清空所有的频道?
    </div>
    <div style="position:absolute; left:10;top:160;width:100;height:100;">
        <img src="images/vod/btv-02-add-bookmarkquit.png" width="160" height="36" alt=""/>
    </div>
    <div id="doYf" style="position:absolute; left:10;top:160;width:100;height:100;visibility:hidden;">
        <img src="images/vod/btv-02-add-bookmarkc.png" width="160" height="36" alt=""/>
    </div>
    <div style="position:absolute; left:8;top:165;width:174;height:36;"
         align="center">
        确定
    </div>
    <div id="doN" style="position:absolute; left:199;top:160;width:100;height:100;  ">
        <img src="images/vod/btv-02-add-bookmarkquit.png" width="160" height="36" alt=""/>
    </div>
    <div id="doNf" style="position:absolute; left:199;top:160;width:100;height:100; visibility:hidden;">
        <img src="images/vod/btv-02-add-bookmarkc.png" width="160" height="36" alt=""/>
    </div>
    <div style="position:absolute; left:197;top:165;width:174;height:36;"
         align="center">
        取消
    </div>
</div>

<div style="left:356px; top:229px;width:568px;height:262px; position:absolute;font-size:22px;color:#FFFFFF;z-index:2000">
    <div id="msg" style="left:0px; top:0px;width:568px;height:262px; position:absolute;visibility:hidden;">
        <div style="left:0px;top:0px;width:250px;height:200px;position:absolute;">
            <img src="images/vod/btv_promptbg.png" alt="" width="568" height="262"/>
        </div>
        <div id="text"
             style="left:0px;top:100px;width:568px;height:34px;z-index:6;;position:absolute;"
             align="center">

        </div>
        <div style="left:0px;top:210px;width:568px;height:34px;z-index:6;position:absolute;"
             align="center">
            2秒自动关闭
        </div>
    </div>
</div>
<%--<%@ include file="favorite_service.jsp" %>--%>
<script type="text/javascript">
    document.onkeypress = cateKeyPress;
    clearProdiv();
    initByIndex();
</script>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>

</html>