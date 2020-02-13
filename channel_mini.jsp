<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@include file="inc/words.jsp"%>
<%@ include file="inc/getFitString.jsp" %>
<epg:PageController name="back.jsp"/>

<%
     String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
     HashMap param = PortalUtils.getParams(path, "GBK");
     String TIME_COUNT=String.valueOf(param.get("TIME_COUNT"));
     String INTERVAL=String.valueOf(param.get("INTERVAL"));
     String channelColumnid=String.valueOf(param.get("column00"));
%>

<html>
<head>
</head>
<title></title>
<body bgcolor="transparent" >
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript">
function getChannellist(destpage){
   var requestUrl = "action/allchannellistData.jsp?columnid=<%=channelColumnid%>";
   var loaderSearch = new net.ContentLoader(requestUrl, showChannelListResponse);
}

var startIndex = 0;
var endIndex = 9;
var totalCount=0;
var columnArr = [];
var leftMenuIndex =0;
var length = 1;
var leftMenuCount = 9;
var upAction = false;
var downAction = false;
var tempArr=[];
function $(id){
    return document.getElementById(id);
}

function showChannelListResponse(){
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     tempArr = data.channelData;
     totalCount=tempArr.length;
     if(endIndex>totalCount)endIndex=totalCount;
	 for(var i = 0; i< totalCount; i++){
		 if(top.channelInfo.currentChannel == tempArr[i].mixno){
		//if(28 == tempArr[i].mixno){	 
			 if(totalCount - i >= 9 && i >= 9){
			     startIndex = i -4;
			     endIndex = i + 5;
				 leftMenuIndex = 4;
			 }else if(totalCount > 9 &&  totalCount - i <= 9){
				 endIndex = totalCount;
				 startIndex = totalCount -9;
				 leftMenuIndex = i - startIndex;
			 }else if( i < 9 || totalCount <=9){
				 startIndex = 0;
			     endIndex = 9;
				 leftMenuIndex = i;
			 }
			 break;
		 }
	 }
     showChannelList();
}
function showChannelList(){
     columnArr=new Array();
     for(var i=startIndex;i<endIndex;i++){
         columnArr.push(tempArr[i]);
     }
     length = columnArr.length;
     changefocusImg(-1);
     for(var i=0; i<leftMenuCount; i++){
         if(i<length){
            var mixno = columnArr[i].mixno;
            if(mixno.length == 1){
               mixno = "00"+mixno
            }else if(mixno.length == 2){
               mixno = "0"+mixno
            }
//            $('left_menu_'+i).innerText = columnArr[i].mixno+"  "+writeFitString(columnArr[i].channelname, 22, 185);
            var str=mixno+"  "+columnArr[i].channelname;
            columnArr[i].programeName = str;
            var tempText = writeFitStringNirui(str,205, 22,13 ,11);
            $('left_menu_'+i).innerText = tempText;
            $('left_menu_'+i).style.visibility = 'visible';
            if(tempText != str){
                columnArr[i].hasBreak = '1';
                columnArr[i].breakName = tempText;
            }
         }else{
            $('left_menu_'+i).innerText ='';
            $('left_menu_'+i).style.visibility = 'hidden';
         }
     }
    showPage();
    changefocusImg();
}
function showPage(){
    $("upimg").style.visibility = startIndex > 0 ? "visible" : "hidden";
    $("downimg").style.visibility = endIndex < totalCount ? "visible" : "hidden";
}

function changefocusImg(flag){
    var tempObj = columnArr[leftMenuIndex];
   // alert("SSSSSSSSSSSSSSSSSSchangefocusImg_="+flag);
    if(flag == -1){
        if(tempObj.hasBreak == '1'){
            $('left_menu_'+leftMenuIndex).innerHTML = tempObj.breakName;
        }
    }else{
        if(tempObj.hasBreak == '1'){
            $('left_menu_'+leftMenuIndex).innerHTML = "<marquee version='3' scrolldelay='250' width='130'>"+tempObj.programeName+"</marquee>";
        }
        $('img_focus').style.top=(30+53*leftMenuIndex)+"px";
    }
}

function goUp(){
    if(leftMenuIndex>0){
         changefocusImg(-1);
         leftMenuIndex--;
         changefocusImg();
    }else{
        prePage();
    }
}

function goDown(){
    if(leftMenuIndex<length-1){
         changefocusImg(-1);
         leftMenuIndex++;
         changefocusImg();
    }else {
        nextPage();
    }
}

function prePage() {
    if (startIndex > 0) {
        startIndex--;
        endIndex = 9 + startIndex;
        showChannelList();
    }
}

function nextPage() {
    if (endIndex < totalCount) {
        startIndex++;
        endIndex++;
        showChannelList();
    }
}
function pageDown() {
    if (endIndex < totalCount) {
        startIndex = endIndex;
        if ((endIndex + 9) <= totalCount) {
            endIndex += 9;
        } else {
            endIndex = totalCount;
        }
        leftMenuIndex = 0;
        showChannelList();
    }
}
function pageUp() {
    if (startIndex > 0) {
        if (startIndex >= 0 && endIndex > 19) {
            startIndex -= 9;
            endIndex = startIndex + 9;
        } else {
            startIndex = 0;
            endIndex = 9;
        }
        leftMenuIndex = 0;
        showChannelList();
    }
}

function goOk() {
   var mixno = columnArr[leftMenuIndex].mixno;
   top.mainWin.document.location = "channel_play.jsp?mixno="+mixno;
}

function doKeyPress(evt){
    var keycode = evt.which;
    if (keycode == <%=STBKeysNew.onKeyLeft%>){
//        goLeft();
    }else if(keycode==0x0101){ //频道加减键
          top.remoteChannelPlus();
    }else if(keycode==0x0102){
          top.remoteChannelMinus();
    }else if (keycode == <%=STBKeysNew.onKeyRight%>){
//        goRight();
    }else if (keycode == <%=STBKeysNew.onKeyOK%>){
        goOk();
    }else if (keycode == <%=STBKeysNew.onKeyUp%>){
        goUp();
    }else if (keycode == <%=STBKeysNew.onKeyDown%>){
        goDown();
    }else if (keycode == <%=STBKeysNew.remotePlayNext%>){
        pageDown();
    }else if (keycode == <%=STBKeysNew.remotePlayLast%>){
        pageUp();
    }else if(keycode == 0x0110){
       /* if("CTCSetConfig" in Authentication)
        {
        //    alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
            Authentication.CTCSetConfig("KeyValue","0x110");
        }else{
            //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
            Authentication.CUSetConfig("KeyValue","0x110");
        }*/
        top.mainWin.document.location = "portal.jsp";
    }else if(keycode == 36){
        top.mainWin.document.location = "portal.jsp";
    }else if (keycode == <%=STBKeysNew.remoteBack%> || keycode == 24){
         top.jsHideOSD();
    }else{
        top.doKeyPress(evt);
    }
    return false;
}



document.onkeypress = doKeyPress;

</script>
 <div style="position:absolute; left:80px; top:101px; background:url('images/liveTV/channel_mini_bg.png'); width:226px; font-size:22px; color:#FFFFFF; height:544px; line-height:55px;" align="left">
     <div id="upimg" style="background:url('images/portal/up.png'); position:absolute; left:100px; top:13px; width:24px; height:14px;visibility:hidden">
     </div>
     <div id="downimg" style="background:url('images/portal/down.png'); position:absolute; left:100px; top:512px; width:24px; height:14px;visibility:hidden">
     </div>

     <div id="img_focus" style="position:absolute; left:5px; top:30px; width:213px; height:54px;">
         <img src="images/liveTV/channel_minifocus.png" width="215" height="54" />
     </div>

     <%
         for(int i=0; i<9; i++){
             int topindex = 30+53*i;
     %>
     <div id="left_menu_<%=i%>" style="left:20px; top:<%=topindex%>px; position:absolute; width:205px; height:53px; ">
         <%--生活乱如麻--%>
     </div>
     <%
         }
     %>
 </div>

<script type="text/javascript">

getChannellist(1);

</script>

</body>
</html>
