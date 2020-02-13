<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString.jsp" %>

<%
    String isnewopen = request.getParameter("isnewopen");
//    System.out.println("SSSSSSSSSSSSSSSSSSSSisnewopen="+isnewopen);
    if((isnewopen!=null && isnewopen.equals("1")) || (isnewopen!=null && isnewopen.equals("2"))){
        System.out.println("SSSSSSSSSSSSSSSSSSSSSSmeiyouyazhan!!!!");
%>

<%
}else{
%>
<epg:PageController name="vod_favorite.jsp"/>
<%
    }
%>
<%
    String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String leftstate = String.valueOf(request.getParameter("leftstate"));
    if(leftstate.equals("null") || leftstate.equals("")){
        leftstate="0";
    }
    String lastfocus = request.getParameter("lastfocus");

    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();
	
	//获取首页地址
	 String pageURI = request.getRequestURI();
     int loc = pageURI.lastIndexOf("/");
	 pageURI = pageURI.substring(0,loc+1);
	 String portalUrl = pageURI+"portal.jsp";
	  String thirdbackUrl = pageURI+"thirdback.jsp";
%>
<html>
<head>
<title>order list</title>
<%
    String isAjaxCache = String.valueOf(param.get("isAjaxCache"));
    if(isAjaxCache!=null && isAjaxCache.equals("1")){
%>
<script type="text/javascript" src="js/contentloader.js"></script>
<%
}else{
%>
<script type="text/javascript" src="js/contentloader_nocache.js"></script>
<%
    }
%>
<script type="text/javascript" src="js/json.js"></script>
<script type="text/javascript">
var lastfocus = "<%=lastfocus%>";
var selectArr = [];

//获取数据相关
var data;
var arr;
var index = 0;
var destpage = 1;
var pageCount = 1;
var leng = 0;
var timer = -1;
var channeloutTime=-1;
var downIndex=4;

var isleft = true;
var isTop = false;
var leftindex = parseInt("<%=leftstate%>");
var portalUrl="<%=portalUrl%>";
var thirdbackUrl="<%=thirdbackUrl%>";
var topindex = 0;
var isShow = false;
var clearbar = true;
var leftFocusTime;
var stbType= Authentication.CTCGetConfig("STBType");
 function keySTBPortal(serviceUrl)
     {
var xml = '';
xml += "<?xml version='1.0' encoding='UTF-8'?>";
xml += '<global_keytable>';
xml += '<response_define>';
xml += '<key_code>KEY_PORTAL</key_code>';
xml += '<response_type>2</response_type>';
xml += '<service_url>'+serviceUrl+'</service_url>';
xml += '</response_define>';
xml += '</global_keytable>';
Authentication.CUSetConfig("GlobalKeyTable", xml);
}
var $$ = {};
function $(id) {
    if (!$$[id]) {
        return document.getElementById(id);
    }
    return $$[id];
}

var _window = window;

if(window.opener){
    _window = window.opener;
}

var loadProgram =1;

//function gotoUrl() {
//    if (leftindex == 3) {
//        changeImg(-1);
//        _window.top.mainWin.document.location = "favorite_service.jsp";
//    } else {
//        index = 0;
//        destpage = 1;
//        pageCount = 1;
//        requestDataSource();
//    }
//}

function leftSetTime() {
    loadProgram = 0;
    if (leftFocusTime) {
        window.clearTimeout(leftFocusTime);
    }
    leftFocusTime = window.setTimeout("leftMenuOK()", 800);
}

function init() {
    isTop = false;
    $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
//    topFcous(0);
    if (lastfocus != "" && lastfocus != null && lastfocus != "undefined" && lastfocus != "null") {
        var paramArr = lastfocus.split("_");
        leftindex = parseInt(paramArr[0]);
        destpage = parseInt(paramArr[1]);
        index = parseInt(paramArr[2]);
        isleft = eval(paramArr[3]);

        if(isNaN(leftindex)){
            leftindex = 0;
        }
        if(isNaN(destpage)){
            destpage = 1;
        }
        if(isNaN(index)){
            index = 0;
        }
    }
    requestDataSource();
}

function cleardiv() {
    for (var i = 0; i < 10; i++) {
        $("focus_bg" + i).style.visibility = "hidden";
        $("focus_img" + i).src = "images/btn_trans.gif";
        $("focus_name" + i).innerText = "";
        $("focus_name" + i).style.visibility = "hidden";

        $("vod_img" + i).src = "images/btn_trans.gif";
        $("vod_name" + i).innerText = "";
        $("vod_name" + i).style.visibility = "hidden";

        $("bg_x" + i).style.visibility = "hidden";
        $("focus_x" + i).style.visibility = "hidden";
        $("f_img" + i).width = "66";
        $("f_img" + i).height = "66";
        $("f_img" + i).src = "images/channel/btv-mytv-cancelclick.png";
    }
}

var date1 = null;
var date2 = null;

function requestDataSource() {
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSrequestDataSource_leftindex="+leftindex);
    if(leftindex==0){
        downIndex=4;
        date1 = new Date();
        var requestUrl = "action/channel_favorite_data.jsp?destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgram);
    }else if (leftindex == 1) {
        downIndex = 5;
        var requestUrl = "action/favorite_datas2.jsp?destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, showdata);
    } else if (leftindex == 2) {
        downIndex=5;
        var requestUrl = "action/favorite_bookMark_datas.jsp?destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, showdata);
    } else if(leftindex == 3){
        downIndex=5;
        loadFavService(destpage);
    }
}

function getMixno(mixno){
    if(mixno.length<3){
        mixno="0"+mixno;
        return getMixno(mixno);
    }else{
        return mixno;
    }
}

function channelProgram() {
    date2 = new Date();

  //  alert("SSSSSSSSSSSSSSSSSSdate2-date1="+(date2.getTime()-date1.getTime()));
    loadProgram = 1;
    if(isReallyZTE == true){
        $("channelF").style.visibility = "visible";
        $("vod").style.visibility = "hidden";
        $("serviceF").style.visibility = "hidden";
    }else{
        $("channelF").style.display = "block";
        $("vod").style.display = "none";
//        $("serviceF").style.visibility = "hidden";
    }

    var results = this.req.responseText;
    data = eval("(" + results + ")");
    arr = data.Data;
    destpage = data.destpage;
    pageCount = data.pageCount;
    leng = arr.length;
    clearVodState();
    clearFavoriteSeriviceDiv();
//    alert("SSSSSSSSSSSSSSSSSSSSarr.length="+leng);
    for (var i = 0; i < 20; i++) {
        if (i < leng) {
//            alert("SSSSSSSSSSSSSSSSSSSSarr[i].programname="+arr[i].programname);
            var tempProgramName = writeFitStringNirui(arr[i].programname, 123, 22, 13, 11);
            $("tv_" + i).innerHTML = tempProgramName;
            if(tempProgramName != arr[i].programname){
                arr[i].hasBreak = '1';
                arr[i].breakName = tempProgramName;
            }
            $("max_" + i).innerText = getMixno(arr[i].programid);
        } else {
            $("tv_" + i).innerText = "";
            $("max_" + i).innerText = "";
        }
        $("bgtv_x" + i).style.visibility = "hidden";
    }
    if (leng <= 0){
        isleft = true;
        changeImg(-1);
    }
    if (isleft == true) {
        clearProdiv();
        leftFocusBar("images/portal/focus.png");//焦点在左边栏目上
    } else {
        changeImg(1);
        leftFocusBar("images/vod/btv_column_focus.png");//焦点在右边节目上
    }
    showScrollBar();
}

function showdata() {
    loadProgram = 1;
    if(isReallyZTE == true){
        $("channelF").style.visibility = "hidden";
        $("serviceF").style.visibility = "hidden";
        $("vod").style.visibility = "visible";
    }else{
        $("channelF").style.display = "none";
//        $("serviceF").style.visibility = "hidden";
        $("vod").style.display = "block";
    }

    var results = this.req.responseText;
    data = eval("(" + results + ")");
    arr = data.Data;
    destpage = data.destpage;
    pageCount = data.pageCount;
    leng = arr.length;

//    alert("sssssssssssssssssssssssssssssssssssssss"+index)
//    alert("sssssssssssssssssssssssssssssssssssssss"+leng)
    if(index==leng){
//        clearAllDiv();  (fangfai1)
//        favoriteKeyLeft();        (fangfai2)
        if (!isleft) {
            if (isTop) {
                if (topindex > 0 && topindex <= 1) {
                    $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                    topindex--;
                    $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
                } else {
                    isTop = false;
                    isleft = true;
                    $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                    changeImg(1);
                }
            } else {
                if (index == 0) {
                    changeImg(-1);
                    $("left" + leftindex).src = "images/portal/focus.png";
                    isleft = true;
                    clearProdiv();
                } else {
                    if (index >= 0 && index == leng) {
                        changeImg(-1);
                        index--;
                        changeImg(1);
                    }
                }
            }
        }
    }
//    clearChannelState();
    clearVodState();
    clearFavoriteSeriviceDiv();
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSSleng="+leng);
    for (var i = 0; i < 10; i++) {
        if (i < leng) {
            $("vod_img" + i).src = arr[i].normalposter;
            $("vod_name" + i).innerText = writeFitString(arr[i].programname, 18, 130);
            $("vod_name" + i).style.visibility = "visible";
            var frow = parseInt(i / 5);
            var fcol = i % 5;
            var fleft = fcol * 180 - 20;
            var ftop = 17 + frow * 248;
            $("focus_x" + i).style.left = fleft;
            $("focus_x" + i).style.top = ftop;
            for (var j = 0; j < selectArr.length; j++) {
                if (arr[i].selectIndex == selectArr[j].selectIndex) {
                    $("bg_x" + i).style.visibility = "visible";
                    $("f_img" + i).src = "images/channel/tv_Xico.png";
                    $("f_img" + i).width =  "36";
                    $("f_img" + i).height = "37";
                    $("focus_x" + i).style.left += 20;
                    $("focus_x" + i).style.top += 20;
                }
            }
        } else {
            $("vod_img" + i).src = "images/btn_trans.gif";
            $("vod_name" + i).innerText ="";
            $("focus_bg" + i).style.visibility = "hidden";  //失去焦点背景图
            $("focus_img" + i).src = "images/btn_trans.gif";
            $("focus_name" + i).innerText = "";
//            alert("SSSSSSSSSSSSSSSSSSSSSSSSSfocus_name" + i);
//            $("focus_name" + i).style.visibility = "hidden";
            $("focus_name" + i).style.visibility = "hidden";
            $("vod_name" + i).style.visibility = "hidden";
            $("focus_x" + i).style.visibility = "hidden";
        }
    }
     if(leng<=0){
        isleft = true;
    }
    if (isleft == true) {
        leftFocusBar("images/portal/focus.png");//焦点在左边栏目上
    } else {
        changeImg(1);
        leftFocusBar("images/vod/btv_column_focus.png");//焦点在右边节目上
    }
    showScrollBar();
}

function leftFocusBar(img) {
    if (leftindex == 0) {
        $("left0").src = img;
        $("left1").src = "images/btn_trans.gif";
        $("left2").src = "images/btn_trans.gif";
        $("left3").src = "images/btn_trans.gif";
    }else if (leftindex == 1) {
        $("left1").src = img;
        $("left2").src = "images/btn_trans.gif";
        $("left0").src = "images/btn_trans.gif";
        $("left3").src = "images/btn_trans.gif";
    } else if (leftindex == 2) {
        $("left2").src = img;
        $("left0").src = "images/btn_trans.gif";
        $("left1").src = "images/btn_trans.gif";
        $("left3").src = "images/btn_trans.gif";
    } else if(leftindex == 3){
        $("left3").src = img;
        $("left0").src = "images/btn_trans.gif";
        $("left1").src = "images/btn_trans.gif";
        $("left2").src = "images/btn_trans.gif";
    }
}
function showDellIcon() {

}
function showScrollBar() {
    if (leng > 0) {
        var heightX = parseInt(504 / pageCount);
        var topX = 3 + heightX * (destpage - 1);
        $("scrollbar2").height = heightX;
        $("scroll").style.top = topX;
        $("pageBar").style.visibility = "visible";
    } else {
        $("pageBar").style.visibility = "hidden";
    }
}

function favoriteKeyPress(evt) {
    var keyCode = parseInt(evt.which);

    if(loadProgram == 2){
        return false;
    }

    if (keyCode == 0x0028) { //onKeyDown
        favoriteKeyDown();
    } else if (keyCode == 280) { //yellow
        delFav();
    }else if (keyCode == 0x0026) {//onKeyUp
        favoriteKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        favoriteKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        favoriteKeyRight();
    } else if (keyCode == 0x0008  || keyCode == 24) {///back
        favoriteBack();
    } else if (keyCode == 0x0022) {  //page down
        favoritepageNext();
    } else if (keyCode == 0x0021) { //page up
        favoritepagePrev();
    }else if (keyCode == 0x000D) {  //OK
        favoriteKeyOK();
    } else if (keyCode == 0x0110 || keyCode == 36) {  //shouye
         top.mainWin.document.location="portal.jsp";
    } else {
        //                clearStack();
        _window.top.mainWin.commonKeyPress(evt);
        return true;
    }
    return false;
}

var delFav=function(){
    if (!isleft && leftindex ==3) {
        var dellindex = index + (destpage - 1) * 15;
        var leng1 = serviceDs.length;
        serviceDs.splice(dellindex, 1);
        var leng2 = serviceDs.length;
        var flag = leng1 == leng2 ? 1 : 0;
        if(destpage >1 && leng1%15==1){
            destpage--;
        }
        showMsg(flag);
    }
}

function showMsg(flag) {
//    dellflag = flag;
    if (flag == 0) {
        $("text").innerText = "删除成功";
        $("msg").style.visibility = "visible";
        $("closeMsg").style.visibility = "visible";
//        $("closeMsg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
    } else if (flag == 1) {
        $("text").innerText = "删除失败";
        $("msg").style.visibility = "visible";
        $("closeMsg").style.visibility = "visible";
//        $("closeMsg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
    }
}

function favoriteKeyDown() {
    if (isleft) {
        changeImg(-1);
        if (leftindex >= 0 && leftindex < 3) {
            leftindex++;
        } else {
            leftindex = 0;
        }
        changeImg(1);
        leftSetTime();
    } else {
        if (isTop) {
            topFcous(-1);
        } else {
            changeImg(-1);
            if (parseInt(index) + downIndex < leng) {
                index = parseInt(index) + downIndex;
                changeImg(1);
            }else{
                var tempIndexDestpage = parseInt(parseInt(index)/5+1);
                var tempLengthDestpage = parseInt((leng-1)/5 +1);
                //alert("SSSSSSSSSSSSSSSSSSSSSSSindex="+index+"_tempIndexDestpage="+tempIndexDestpage);
                //alert("SSSSSSSSSSSSSSSSSSSSSSSleng="+leng+"_tempLengthDestpage="+tempLengthDestpage);
                if((tempIndexDestpage%2)!=(tempLengthDestpage%2)){
                     index = 5;
                     changeImg(1);
                     return;
                }
                favoritepageNext();
            }
        }
    }
}
function favoriteKeyUp() {
	if (isleft) {
        changeImg(-1);
        if (leftindex > 0 && leftindex <= 3) {
            leftindex--;
        } else {
            leftindex = 3;
        }
        changeImg(1);
        leftSetTime();
    } else {
        if (!isTop) {
            if (leng > downIndex && index >= downIndex) {
                changeImg(-1);
                index = index - downIndex;
                changeImg(1);
            } else if(leftindex!=3) {
                topindex=0;
                clearProdiv();
                topFcous(1);
            }else if(leftindex==3){
                favoritepagePrev();
            }
        }
    }
}
function topFcous(flag) {
    if (flag == 1) {
        isTop = true;
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
        changeImg(-1);
    } else {
        isTop = false;
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
        changeImg(1);
    }
}
function favoriteKeyLeft() {
	if (!isleft) {
        if (isTop) {
            if (topindex > 0 && topindex <= 1) {
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                topindex--;
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
            } else {
                isTop = false;
                isleft = true;
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                changeImg(1);
            }
        } else {
            if (index % downIndex == 0) {
                changeImg(-1);
                $("left" + leftindex).src = "images/portal/focus.png";
                isleft = true;
                clearProdiv();
            } else {
                if (index >= 0 && index < leng) {
                    changeImg(-1);
                    index--;
                    changeImg(1);
                }
            }
        }
    }
}
function favoriteKeyRight() {
	if (isleft == true && leng > 0 && loadProgram==1) {
        isleft = false;
        $("left" + leftindex).src = "images/vod/btv_column_focus.png";
        changeImg(1);
    } else {
        if (isTop) {
            $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
            if (topindex >= 0 && topindex < 1) {
                topindex++;
            } else {
                topindex = 0;
            }
            $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
        } else if (leng > 0) {
            changeImg(-1);
            if (index >= 0 && index < leng - 1) {
                index++;
            } else {
                index = 0;
            }
            changeImg(1);
        }
    }
}
function clearAllDiv(){
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSSclearAllDiv！!!!!");
    changeImg(-1);
    for (var i = 0; i < 20; i++) {
        $("tv_" + i).innerText = "";
        $("max_" + i).innerText = "";
        $("bgtv_x" + i).style.visibility = "hidden";
    }
    isleft=true;
    index=0;
    destpage=1;
    cleardiv();
    clearFavoriteSeriviceDiv();
    leftFocusBar("images/btn_trans.gif");
}

function clearSomeDiv(){
    changeImg(-1);
    isleft=true;
    index=0;
    destpage=1;
}

function favoriteBack() {
    _window.top.mainWin.document.location = "back.jsp";
}
function favoritepageNext() {
    if(isleft || isTop){
        return;
    }
    if (pageCount > 1 && destpage < parseInt(pageCount)) {
        destpage++;
    }else{
        destpage = 1;
    }
    changeImg(-1);
    index = 0;
//    destpage++;
    requestDataSource();
//    if (pageCount > 1 && destpage < parseInt(pageCount)) {
//        changeImg(-1);
//        index = 0;
//        destpage++;
//        requestDataSource();
//    }
}

function favoritepagePrev() {
    if(isleft || isTop){
        return;
    }
    if (destpage > 1) {
        destpage--;
    }else{
        destpage = parseInt(pageCount);
    }
//    if (destpage > 1) {
        changeImg(-1);
        index = 0;
//        destpage--;
        requestDataSource();
//    }
}
function favoriteKeyOK() {
    if (isleft) {
        leftMenuOK();
    } else {
        if (isTop) {
            topOK();
        } else {
            favoriteRightOK();
        }
    }
}
function leftMenuOK() {
//    if (leftindex == 3) {
//        changeImg(-1);
//        _window.top.mainWin.document.location = "favorite_service.jsp";
//    } else {
        index = 0;
        destpage = 1;
        pageCount = 1;
        requestDataSource();
//    }
}

function clearList() {
    if (leftindex == 0) {
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSarr.length="+arr.length);
        var delContent = "";
        var delSubject = "";
//        var obj = arr[0];
//        for(var p in obj){
//           alert("SSSSSSSSSSSSSSSSSSSSSSSobj["+p+"]="+obj[p]);
//        }
//        return ;
        for(var i=0; i<arr.length; i++){
            if(_window.top.channelInfoArr[arr[i].contentcode]){
                delContent = delContent + _window.top.channelInfoArr[arr[i].contentcode].channelId + "__";
            }else{
                delContent = delContent + arr[i].contentcode + "__";
            }
            delSubject = delSubject+arr[i].columnid+"__";
        }
        //alert("SSSSSSSSSSSSSSSSSSSSSSSdelContent="+delContent);
        //alert("SSSSSSSSSSSSSSSSSSSSSSSdelSubject="+delSubject);
//        return;
        var requestUrl = "action/channel_favorite_del.jsp?delall=all&SubjectID="+delSubject+"&ContentID="+delContent+"&FavoriteTitle='1'&type=channel&count=" + arr.length;
        var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
    }else if (leftindex == 1) { //清空收藏
        var requestUrl = "action/favorite_del.jsp?type=all";
        var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
    } else if(leftindex == 2) {//清空书签
        var requestUrl = "action/bookpoint_del.jsp?type=all";
        var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
    }
}

function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    $("closeMsg").style.visibility = "hidden";
    clearTimeout(timer);
    if(leftindex == 3  && isZTEBW == true){
        ztebw.setAttribute(userid, serviceDs.toJSONString());
    }
//    alert("SSSSSSSSSSSSSSSSSSSSSSScloseMessageselectArr.length="+selectArr.length);
    refresh();
}
function refresh() {
//    isTop = false;
//    selectArr = new Array();
    index = 0;
//    destpage = 1;

    lastfocus = "";
    init();
}
function favoriteRightOK() {
    if (isShow) {
         if(leftindex==0){
             doChannelPushList();
         }else if(leftindex!=3){
             doVodPushList();
         }
    } else {
        goVodDetail();
    }
}
function  doChannelPushList(){
    if ($("bgtv_x" + index).style.visibility != "visible") {
        $("bgtv_x" + index).style.visibility = "visible";
    } else {
        $("bgtv_x" + index).style.visibility = "hidden";
    }
    pushList();
}
function  doVodPushList(){
  //  alert("SSSSSSSSSSSSSSSSSSSSSdoVodPushList$(f_img + index).src="+$("f_img" + index).src);
    var tempSrc = $("f_img" + index).src;
//    if ($("f_img" + index).src != "images/channel/tv_Xico.png") {
    if (tempSrc.indexOf('images/channel/tv_Xico.png') == -1) {
       // alert("SSSSSSSSSSSSSSSSSSSSS1111111111");
        $("bg_x" + index).style.visibility = "visible";
        $("f_img" + index).src = "images/channel/tv_Xico.png";
        $("f_img" + index).width = "36";
        $("f_img" + index).height = "37";
        $("focus_x" + index).style.top += 20;
        $("focus_x" + index).style.left += 20;
    } else {
       // alert("SSSSSSSSSSSSSSSSSSSSS222222222");
        $("bg_x" + index).style.visibility = "hidden";
        $("f_img" + index).src = "images/channel/btv-mytv-cancelclick.png";
        $("f_img" + index).width = "66";
        $("f_img" + index).height = "66";
        $("focus_x" + index).style.top -= 20;
        $("focus_x" + index).style.left -= 20;
    }
    pushList();
}

function setBackParam(saveInfo) {
    //对华为盒子的处理，首页键交由机顶盒
	        var ua = window.navigator.userAgent;
	       //alert("=====vod_favorite ua==111=="+ua);
          if(ua.indexOf("Ranger/3.0.0")>-1){
              //alert("this is hw get key to stb");
             keySTBPortal(thirdbackUrl);
          }
    var backurlparam = "<%=timeFrameUrl%>/vod_favorite_pre.jsp?leftstate=3";
    if(isZTEBW == false){
        backurlparam = "<%=timeFrameUrl%>/vod_favorite.jsp?leftstate=3";
    }
    backurlparam += "&lastfocus=" + saveInfo;
    _window.top.jsSetControl("backurlparam", backurlparam);
    var lastChannelNum = _window.top.channelInfo.currentChannel;

    if(isZTEBW == true){
        ztebw.setAttribute("curMixno", lastChannelNum);
        Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
    }else{
        Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
    }

}

function goVodDetail() {
	var leefocus = leftindex + "_" + destpage + "_" + index + "_" + isleft;
    if(leftindex == 0){
//        changeImg(-1);
        _window.top.mainWin.document.location = "channel_play.jsp?mixno="+arr[index].contentcode+ "&leefocus=" + leefocus;
        return;
    }else if(leftindex == 3){
        setBackParam(leefocus);
        _window.top.jsSetControl("isCheckPlay", "0");
        _window.top.doStop();
        var tempindex = index+(destpage-1)*totalLeng;
//        alert("SSSSSSSSSSSSSSSSSSSSStempindex="+tempindex+"_"+index+"_"+destpage+"_"+totalLeng);
//        alert("SSSSSSSSSSSSSSSSSSSSSSSgotosd="+serviceDs[tempindex].gosd);
        if(serviceDs[tempindex].gosd == '1' && isZTEBW == true){
            if("CTCSetConfig" in Authentication)
            {
               // alert("SSSSSSSSSSSSSSSSSSetEpgMode_CTC");
                Authentication.CTCSetConfig('SetEpgMode', 'SD');
            }
            else{
              //  alert("SSSSSSSSSSSSSSSSSSetEpgMode_CU");
                Authentication.CUSetConfig('SetEpgMode', 'SD');
            }
        }
        _window.top.mainWin.document.location = serviceDs[tempindex].curl;
        return;
    }
    if (arr[index].programid == "" || arr[index].programid == null || arr[index].programid == "null" || arr[index].programid == "undfined") {
        showDetailMsg();
    } else {
        if (arr[index].programtype == "1" || arr[index].programtype == "10") {
            var url = "vod_detail.jsp?columnid=" + arr[index].columnid
                    + "&programid=" + arr[index].programid
                    + "&programtype=" + arr[index].programtype
                    + "&contentid=" + arr[index].contentcode
                    + "&from=" + leftindex
                    + "&columnpath="
                    + "&programname=" + arr[index].programname + "&leefocus=" + leefocus;
            _window.top.mainWin.document.location = encodeURI(encodeURI(url));
        } else if (arr[index].programtype == "14") {
            var url = "vod_series_list.jsp?columnid=" + arr[index].columnid
                    + "&programid=" + arr[index].programid
                    + "&leefocus=" + leefocus
                    + "&from=" + leftindex
                    + "&columnpath="
                    + "&seriesnum=" + arr[index].Seriesnum
                    + "&programtype=" + arr[index].programtype
                    + "&contentid=" + arr[index].contentcode
                    + "&programname=" + arr[index].programname;
            +"&seriesprogramcode=" + arr[index].programid + "&vodtype=100";
            _window.top.mainWin.document.location = encodeURI(encodeURI(url));
        }
    }
}
function pushList() {
    var flag = true;
    for (var i = 0; i < selectArr.length; i++) {
        if (arr[index].selectIndex == selectArr[i].selectIndex) {//当前选择的已经在列表里面了
            selectArr.splice(i, 1);
            flag = false;
        }
    }
    if (flag) {
//        alert("SSSSSSSSSSSSSSSSSSS1111index="+index);
//        alert("SSSSSSSSSSSSSSSSSSS1111arr[index]="+arr[index].selectIndex);
        selectArr[selectArr.length] =
        {
            programid:arr[index].programid,
            selectIndex:arr[index].selectIndex,
            programname:arr[index].programname,
            columnid:arr[index].columnid,
            contentid:arr[index].contentcode,
            seriesid:arr[index].vSeriesprogramcode,
            curIndex:index
        };
    }
}

function changeImg(flag) {
    if (!isleft) {
        if (leftindex == 0) {
            var tempObj = arr[index];
//            alert("SSSSSSSSSSSSSSchangeImg_flag_hasBreak="+flag+"_"+tempObj.hasBreak);
            if (flag == -1) {
                $("bg_pro" + index).style.visibility = "hidden";
                if(tempObj.hasBreak == '1'){
                    $("tv_" + index).innerHTML = tempObj.breakName;
                }
            } else {
                if(tempObj.hasBreak == '1'){
                    $("tv_" + index).innerHTML = "<marquee version='3' scrolldelay='250' width='130'>"+tempObj.programname+"</marquee>";
                }
                $("bg_pro" + index).style.visibility = "visible";
                if(channeloutTime){
                    clearTimeout(channeloutTime);
                }
                channeloutTime=setTimeout(requestProgram,500);
            }
        } else if(leftindex == 3){
//            alert("SSSSSSSSSSSSSSSSSchangeImg_flag="+flag+"_index="+index);
            if (flag == -1) {
                $("imgs_" + index).style.visibility = "hidden";
            } else {
                $("imgs_" + index).style.visibility = "visible";
            }
        }else {
            changeVodImg(flag);
        }
    } else {
        if (flag == 1) {
            $("left" + leftindex).src = "images/portal/focus.png";
        } else {
            $("left" + leftindex).src = "images/btn_trans.gif";
        }
    }
}
function changeVodImg(flag){
    if (flag == 1) {
        $("vod_name" + index).style.visibility = "hidden";

        $("focus_bg" + index).style.visibility = "visible";
        //获取焦点背景图
        $("focus_img" + index).src = arr[index].normalposter;
//        $("focus_name" + index).innerText = writeFitString(arr[index].programname, 20, 130);
//        scrollString("focus_name" + index,arr[index].programname, 20, 130);
        var text=arr[index].programname;
        text = text.replace(new RegExp("<","gm"),"&lt;");
        text = text.replace(new RegExp(">","gm"),"&gt;");
        var px=20;
        var divwidth=130;
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            var scrolltext = "<marquee version='3' scrolldelay='250' width='"+divwidth+"'>" + text + "</marquee>";
            document.getElementById("focus_name" + index).innerHTML = scrolltext;
        }else{
            document.getElementById("focus_name" + index).innerHTML = text;
        }
        $("focus_name" + index).style.visibility = "visible";
        if (isShow) {
            $("focus_x" + index).style.visibility = "visible";
        }
    } else {
        $("focus_bg" + index).style.visibility = "hidden";  //失去焦点背景图
        $("focus_img" + index).src = "images/btn_trans.gif";
        $("focus_name" + index).style.visibility = "hidden";

        $("vod_name" + index).style.visibility = "visible";
        if (isShow) {
            $("focus_x" + index).style.visibility = "hidden";
        }
    }
}
function requestProgram(){
    var tempMixno = parseInt(arr[index].programid);
    var channelInfo = _window.top.channelInfoArr[tempMixno];
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSarr[index].programid="+arr[index].programid+"_"+tempMixno);
//    alert("SSSSSSSSSSSSSSSSSSSSchannelInfo="+channelInfo);
    if (channelInfo != undefined) {
        var requestUrl = "action/channel_programD.jsp?channelid=" + channelInfo.channelId + "&columnid=" + arr[index].columnid + "&maxno=" +arr[index].programid;
        var loaderSearch = new net.ContentLoader(requestUrl, showtvProgram);
    }
}
function showtvProgram(){
    var results = this.req.responseText;
    var catedata = eval("(" + results + ")");
    $("ids").innerHTML = arr[index].programid + "&nbsp;&nbsp;&nbsp;" + arr[index].programname;
    if(catedata.HasCurProgram == "0"){
        $("currentProgramb").style.border = "none";
    }else{
        $("currentProgramb").style.border = "2px solid red";
    }
    $("currentProgram").innerHTML = "<br>" + catedata.curprogram;
    $("nextProgram").innerHTML = "<br>" + catedata.nextprogram;
    $("thirdProgram").innerHTML = "<br>" + catedata.thirdprogram;
    $("firstP").style.visibility = "visible";
    $("programInfo").style.visibility = "visible";
    clearTimeout(channeloutTime);
}
function clearProdiv(){
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
function cancelKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown

    } else if (keyCode == 0x0026) {//onKeyUp

    } else if (keyCode == 0x0025) { //onKeyLeft
        cancelKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        cancelKeyRight();
    } else if (keyCode == 0x0008  || keyCode == 24) {///back

    } else if (keyCode == 0x000D) {  //OK
        cancelKeyOK();
    } else if (keyCode == 0x0110 || keyCode == 36) {  //shouye
          _window.top.mainWin.document.location="portal.jsp";
    } else {
        _window.top.mainWin.commonKeyPress(evt);
        return true;
    }
    return false;
}
function cancelKeyLeft() {
    clearbar = true;
    $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
    $("doY").src = "images/vod/btv-02-add-bookmarkc.png";
}
function cancelKeyRight() {
    clearbar = false;
    $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
    $("doN").src = "images/vod/btv-02-add-bookmarkc.png";
}
function cancelKeyOK() {
    if (!clearbar) {
        $("clearInfo").style.visibility = "hidden";
        $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
    } else {
        $("clearInfo").style.visibility = "hidden";
        $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
        clearList();
    }
    document.onkeypress = favoriteKeyPress;
}
document.onkeypress = favoriteKeyPress;
function topOK() {
    if (isShow) {
        if (topindex == 0) {
            var deltitle = "";
            var delSubject = "";
            var delContent = "";
            var delSeriesid = "";
            for (var i = 0; i < selectArr.length; i++) {
                if (i == selectArr.length - 1) {
//                    deltitle = deltitle + selectArr[i].programname;
                    deltitle = deltitle + "name";
                    delSubject = delSubject + selectArr[i].columnid;
                    if(leftindex == 0 && _window.top.channelInfoArr[selectArr[i].contentid]){
                        delContent = delContent + _window.top.channelInfoArr[selectArr[i].contentid].channelId;
                    }else{
                        delContent = delContent + selectArr[i].contentid;
                    }
                    delSeriesid = delSeriesid + selectArr[i].seriesid;
                } else {
//                    deltitle = deltitle + selectArr[i].programname + "__";
                    deltitle = deltitle + "name" + "__";
                    delSubject = delSubject + selectArr[i].columnid + "__";
                    if(leftindex == 0 && _window.top.channelInfoArr[selectArr[i].contentid]){
                        delContent = delContent + _window.top.channelInfoArr[selectArr[i].contentid].channelId + "__";
                    }else{
                        delContent = delContent + selectArr[i].contentid + "__";
                    }
                    delSeriesid = delSeriesid + selectArr[i].seriesid + "__";
                }
            }

            loadProgram = 2;
            if(leftindex == 0){
                var requestUrl = "action/channel_favorite_del.jsp?SubjectID=" + delSubject + "&ContentID=" + delContent + "&FavoriteTitle=" + encodeURIComponent(deltitle) + "&type=CHANNEL&count=" + selectArr.length;
                var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
            } else if (leftindex == 1) { //删除收藏
                var requestUrl = "action/favorite_del.jsp?SubjectID=" + delSubject + "&ContentID=" + delContent + "&FavoriteTitle=" + deltitle + "&type=selectitem";
                var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
            } else {//删除书签
                var requestUrl = "action/bookpoint_del.jsp?SubjectID=" + delSubject + "&ContentID=" + delContent + "&FavoriteTitle=" + deltitle + "&seriesids=" + delSeriesid + "&type=selectitem";
                var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
            }
        } else {
            clearVodState();
            changeImg(1);
        }
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
    } else {
        if (topindex == 0) {
            $("buttonone").innerText = "确认";
            $("buttontwo").innerText = "取消";
            $("info").style.visibility = "visible";
            isShow = true;
        } else {
            $("clearInfo").style.visibility = "visible";
            $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
            $("doY").src = "images/vod/btv-02-add-bookmarkc.png";
            $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
            clearbar = true;
            document.onkeypress = cancelKeyPress;
        }
    }
}


function clearVodState() {
    $("buttonone").innerText = "编辑";
    $("buttontwo").innerText = "清空";
    $("topMessage").style.visibility = "visible";
    $("favorite_del").style.visibility = "hidden";
    clearVodStateReally();
}

function clearVodState1() {
    $("buttonone").style.visibility='hidden';
    $("buttontwo").style.visibility='hidden';
    clearVodStateReally();
}

function clearVodStateReally() {
    $("info").style.visibility = "hidden";
    isShow = false;
    isTop = false;
//    alert("SSSSSSSSSSSSSSSSSSclearVodState="+selectArr.length);
    for (var i = 0; i < selectArr.length; i++) {
        var _index = selectArr[i].curIndex;
//        alert("SSSSSSSSSSSSSSSSSSSSSSselectArr[i].curIndex="+selectArr[i].curIndex);
        $("bgtv_x" + _index).style.visibility = "hidden";
        if(_index<10){
            $("bg_x" + _index).style.visibility = "hidden";
            $("focus_x" + _index).style.visibility = "hidden";
            $("focus_x" + _index).style.top -= 30;
            $("focus_x" + _index).style.left -= 30;
            $("f_img" + _index).width = "66";
            $("f_img" + _index).height = "66";
            $("f_img" + _index).src = "images/channel/btv-mytv-cancelclick.png";
        }
    }
    selectArr = new Array();
}

function showdellFav() {
    var results = this.req.responseText;
    var tempData = eval("(" + results + ")");
    var dellCount = tempData.dellCount;
    $("text").innerText = "您成功删除  " + dellCount + "  条数据";
    $("msg").style.visibility = "visible";
    $("closeMsg").style.visibility = "visible";
    try{
//        alert("SSSSSSSSSSSSSSSSSSSSlength="+leng);
//        alert("SSSSSSSSSSSSSSSSSSSSselectArr.length="+selectArr.length);
//        var temppage1 = parseInt((leng-1)/10)+1;
//        var tempppage2 = parseInt((leng-1-selectArr.length)/10)+1;
//        alert("SSSSSSSSSSSshowdelltemppage1"+temppage1);
//        alert("SSSSSSSSSSSshowdelltemppage2"+tempppage2);
        if(leng<=selectArr.length){
            destpage--;
        }
    }catch(e){
     //  alert("SSSSSSSSSSSshowdellFav_error!");
    }

    clearTimeout(timer);
    timer = setTimeout(closeMessage, 2000);
}

function showDetailMsg() {
    var text = "节目已下线";
    $("text").innerText = text;
    $("msg").style.visibility = "visible";
    $("closeMsg").style.visibility = "visible";
    clearTimeout(timer);
    timer = setTimeout(closeMessage2, 2000);
}
function closeMessage2() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    clearTimeout(timer);
}


//favorite_service相关

var userid="<%=timeUserInfo.getUserId()%>";
var serviceDs;
var isFoucsLeftIndex;
var totalLeng=15;


function clearFavoriteSeriviceDiv() {
    for (var i = 0; i < 15; i++) {
        $("messImg" + i).src = "images/btn_trans.gif";
        $("messName" + i).innerText = " ";
        $("imgs_" + i).style.visibility = "hidden";
    }
}

function changeBgImg(flag) {
    if (flag == 0) {
        $("imgs_" + index).style.visibility = "hidden";
    } else {
        $("imgs_" + index).style.visibility = "visible";
    }
}

function loadFavService() {
    loadProgram = 1;
//    clearAllDiv();

//    alert("SSSSSSSSSSSSSSSSSSSSSSSSloadFavService11=");
    if(isReallyZTE == true){
        clearFavoriteSeriviceDiv();
        $("vod").style.visibility = "hidden";
        $("channelF").style.visibility = "hidden";
        $("serviceF").style.visibility = "visible";
    } else{
        $("vod").style.display = "none";
        $("channelF").style.display = "none";
    }

    $("favorite_del").style.visibility = "visible";

    $("topMessage").style.visibility = "hidden";
//    clearVodState1();
    var str = "";
    if(isZTEBW == true){
        str = ztebw.getAttribute(userid);
    }
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSloadFavService22="+str);
    if (str != null && str != "" && str !="undefined" && str != "[]") {
        serviceDs = eval("(" + str + ")");
        leng = serviceDs.length;
        pageCount = parseInt((leng - 1) / 15) + 1;
        var startIndex = (destpage - 1) * totalLeng;
        var endIndex = startIndex + totalLeng;
        if (endIndex > leng) {
            endIndex = leng;
        }
        //real pagelength
        leng = endIndex - startIndex;
//        index=0;
        var tempIndex =0;
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSserviceDs.length="+serviceDs.length+"_"+leng);
        if (leng > 0) {
            for (var s = startIndex; s < endIndex; s++) {
//                alert("SSSSSSSSSSSSSSSserviceDs[s]="+serviceDs[s].cname);
                $("messImg" + tempIndex).src = serviceDs[s].cimg;
                $("messName" + tempIndex).innerText = serviceDs[s].cname;
                tempIndex++;
            }
            isFoucsLeftIndex = leftindex;
            if (isleft) {
                $("left" + leftindex).src = "images/portal/focus.png";
            } else {
                changeBgImg(1);
            }
        } else {
            isleft = true;
            changeBgImg(0);
            $("left" + leftindex).src = "images/portal/focus.png";
        }
    } else {
        index=0;
        leng = 0;
        destpage = 1;
        pageCount = 0;
        changeBgImg(0);
        isleft = true;
        $("left" + leftindex).src = "images/portal/focus.png";
    }
    showScrollBar();
}


</script>
</head>
<body bgcolor="transparent" >
<%@include file="favorite_public.jsp" %>
<div id="topMessage" style="top:38;left:90;position:absolute;font-size:22px;color:#ffffff;visibility:visible;">
    <div style=" position:absolute; left:250;top:53;width:150;height:50; ">
        <img id="top0" src="images/vod/btv-02-add-bookmarkquit.png" alt="" height="36" width="150"/>
    </div>

    <div id="buttonone" style=" position:absolute; left:250;top:53;width:150;height:36; line-height:36px "
         align="center">
        编辑
    </div>
    <div style=" position:absolute; left:440;top:53;width:150;height:38; ">
        <img id="top1" src="images/vod/btv-02-add-bookmarkquit.png" height="36" alt="" width="150"/>
    </div>

    <div id="buttontwo" style=" position:absolute; left:440;top:53;width:150;height:36; line-height:36px"
         align="center">
        清空
    </div>
    <div id="info" style=" position:absolute; left:600;top:63;width:400;height:50;visibility:hidden ">
        请标记要删除的节目，选择确定删除
    </div>
</div>

<div id="vod" style="position:absolute;  left:330; top:100;width:960; height:520;">
    <!--vod-->
    <%
        for (int i = 0; i < 10; i++) {
            int frow = i / 5;
            int fcol = i % 5;
            int fleft = fcol * 175 + 10;
            int ftop = 47 + frow * 263;
    %>
    <div id="vod_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:158; height:210; ">
        <img id="vod_img<%=i%>" src="images/btn_trans.gif" alt="" width="140" height="200" border="0">
    </div>
    <div id="vod_name<%=i%>" style="line-height:28px;position:absolute; background-image:url(images/vod/btv_vod.png); left:<%=fleft%>; top:<%=ftop+172%>;width:141; height:28px;font-size:20px; color:#FFFFFF;visibility:hidden" align="center"></div>
    <div id="bg_x<%=i%>" style="left:<%=fleft+7%>;top:<%=ftop+6%>; position:absolute;width:180;height:35;visibility:hidden;">
        <img src="images/channel/tv_Xico.png" width="36" height="37" alt=""/>
    </div>

    <div id="focus_bg<%=i%>" style="position:absolute;border:6px solid red; left:<%=fleft-14%>; top:<%=ftop-17%>;width:157; height:227;visibility:hidden" align="left"></div>
    <div style="position:absolute;  left:<%=fleft-7%>; top:<%=ftop-10%>;width:155; height:225;">
        <img id="focus_img<%=i%>" src="images/btn_trans.gif" alt="" width="155" height="225" border="0">
    </div>

    <div id="focus_x<%=i%>" style="position:absolute; left:<%=fleft-27%>; top:<%=ftop-30%>;width:66; height:66;visibility:hidden">
        <img id="f_img<%=i%>" src="images/channel/btv-mytv-cancelclick.png" width="66" height="66" alt=""/>
    </div>
     <div id="focus_name<%=i%>" style=" line-height:35px;position:absolute;background-image:url(images/vod/btv_focus.png);left:<%=fleft-7%>; top:<%=ftop+180%>;width:155; height:35;font-size:24px;color:#FFFFFF;;visibility:hidden" align="center"></div>
    <%
        }
    %>
</div>
<div id="channelF" style="position:absolute;width:1000;height:600;font-size:22;color:#ffffff;">
    <%
        for (int i = 0; i < 20; i++) {
            int lefts = 300 + i % 4 * 230;
            int tops = 150 + i / 4 * 55;
    %>
    <div id="bg_pro<%=i%>" style="left:<%=lefts+40%>;top:<%=tops-7%>; background:url('images/portal/focus1.png');  position:absolute;width:185;height:40;visibility:hidden;"> </div>
    <div id="max_<%=i%>" style="left:<%=lefts+45%>; top:<%=tops%>;position:absolute;width:44;height:40; " align="left"></div>
    <div id="tv_<%=i%>" style="left:<%=lefts+81%>; top:<%=tops%>; position:absolute;width:130;height:40;" align="left"></div>
    <div id="bgtv_x<%=i%>" style="left:<%=lefts+5%>;top:<%=tops-7%>; position:absolute;width:40;height:40;visibility:hidden;">
        <img src="images/channel/btv-mytv-cancelclick.png" width="40" height="40" alt=""/>
    </div>
    <%}%>
    <div id="programInfo" style="position:absolute;visibility:visible;font-size:22;top:12">
        <div style="background:url('images/liveTV/channel_programinfo.png'); left:0px;top:525px;position:absolute; width:1280px; height:100px;">
            <div id="currentProgramb" style="border:2px solid red; left:46;top:38;height:46;width:321;position:absolute;">
                <img name="bottom_bg" src="images/channel/channel_bottom_focus2.png" width="321" height="46" alt=""/>
            </div>
            <div style="left:371;top:38;height:48;width:321;position:absolute; border:1px solid white; ">
            </div>
            <div style="left:691;top:38;height:48;width:321;position:absolute; border-right:1px solid white; border-top:1px solid white; border-bottom:1px solid white; ">
            </div>
        </div>
        <div id="ids"  style="left:51;top:535;height:10;width:1000;position:absolute;"> </div>
        <div id="currentProgram" style="padding-left:10px;left:51;top:540;height:70;width:320;position:absolute;"> </div>
        <div id="nextProgram" style="padding-left:10px;left:372;top:540;height:70;width:320;position:absolute;"> </div>
        <div id="thirdProgram" style="padding-left:10px;left:693;top:540;height:70;width:320;position:absolute;"> </div>
        <div id="firstP" style="left:1020;top:562;height:68;width:174;position:absolute;visibility:hidden">
            <%--<epg:FirstPage width="203" height="51" location="guanggao04"/>--%>
            <!--<img src="images/logo.png" alt="" border="0" width="193" height="51" />-->
        </div>
    </div>
</div>
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
    <div id="imgs_<%=i%>" style="position:absolute;left:<%=left-5%>px; top:<%=top-4%>px; width:150px;visibility:hidden ">
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
<!--删除提示-->
<div style="left:356px; top:229px;width:568px;height:262px; position:absolute;font-size:20px;color:#FFFFFF;z-index:2000">
    <div id="msg" style="left:0px; top:0px;width:568px;height:262px; position:absolute;visibility:hidden;">
        <div style="left:0px;top:0px;width:250px;height:200px;position:absolute;">
            <img src="images/vod/btv_promptbg.png" alt="" width="568" height="262"/>
        </div>
        <div id="text" style="left:0px;top:100px;width:568px;height:34px;z-index:6;;position:absolute;" align="center">
        </div>
        <div id="closeMsg" style="left:0px;top:210px;width:568px;height:34px;z-index:6;position:absolute;" align="center">
            2秒自动关闭
        </div>
    </div>
</div>

<div style="position:absolute; left:450;top:250;width:370;height:200; ">
    <div id="clearInfo"
         style=" position:absolute; left:0;top:0;width:370;height:200;font-size:20px;color:#ffffff;visibility:hidden ">
        <img src="images/vod/btv_promptbg.png" alt="" width="370" height="200"/>

        <div style="position:absolute; left:0;top:70;width:370;height:100;" align="center">
            确定要清空所有的节目？
        </div>
        <div style="position:absolute; left:10;top:160;width:100;height:100;">
            <img id="doY" src="images/vod/btv-02-add-bookmarkquit.png" width="160" height="37" alt=""/>
        </div>
        <div style="position:absolute; left:10;top:170;width:174;height:32;"
             align="center">
            确定
        </div>
        <div style="position:absolute; left:190;top:160;width:100;height:100; ">
            <img id="doN" src="images/vod/btv-02-add-bookmarkquit.png" width="160" height="37" alt=""/>
        </div>
        <div style="position:absolute; left:190;top:170;width:174;height:32;"
             align="center">
            取消
        </div>
    </div>
</div>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;"></div>
<div style="position:absolute; width:750px; height:38px; left:845px; top:640px;font-size:22px;">
    <div id="pre" style="visibility:visible">
        <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:7;top:4px;color:#424242">上页</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
    </div>
    <div id="next" style="visibility:visible">
        <img src="images/vod/btv_page.png" width="60" height="31" alt="" style="position:absolute;left:200;top:0px;">
        <font style="position:absolute;left:207;top:4px;color:#424242">下页</font>
        <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
    </div>
    <div id="favorite_del" style="visibility:visible; position:absolute;left:-200px; width:200px; ">
        <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:7;top:4px;color:#424242">DEL</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">删除收藏</font>
    </div>
</div>

<script type="text/javascript">
    <%--<%--%>
    <%--if(isnewopen!=null && isnewopen.equals("1")){--%>
    <%--%>--%>
    <%--init();--%>
    <%--<%--%>
    <%--}--%>
    <%--%>--%>

    <%--if(isZTEBW == false){--%>
        <%--init();--%>
    <%--}--%>

    init();
</script>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>
