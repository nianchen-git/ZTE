<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodOneDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.EpgException" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="java.net.URLDecoder" %>
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
    String type = request.getParameter("fast");
    String columnid = request.getParameter("columnid");
    String contentid = request.getParameter("contentid");
    String programname = getVodConInf(columnid, contentid, pageContext);
	programname = formatName(programname);
%>

<body bgcolor="transparent" onLoad="pageInit();">

<%--下方进度条背景图片--%>

<div id="pro">
    <div style="left:30px; top:540px;width:1220px;height:130px; position:absolute;">
        <img src="images/vod/btv-04-progressbg.png" border="0" width="1220" height="130" alt=""/>
    </div>
    <!--状态图标(快进、快退、暂停)-->
    <div id="div0" style="left:286px;width:60px; height:60px; position:absolute; top: 555px; visibility:hidden;" >
        <img src="images/vod/btv-02-focuss.png" style="width:60px; height:60px;" border="0" alt=""/>
    </div>
    <div id="div1" style="left:350px; width:76px; height:76px; position:absolute; top: 546px;visibility:hidden;" >
        <img src="images/vod/btv-02-focus.png" style="width:76px; height:76px;" border="0" alt=""/>
    </div>
    <div id="div2" style="left:430px; width:60px; height:60px; position:absolute; top: 555px;visibility:hidden;">
        <img src="images/vod/btv-02-focuss.png" style="width:60px; height:60px;" border="0" alt=""/>
    </div>
    <!--当前时间和结束时间-->
    <div style="left:801px; top:574px;width:80px;height:27px; position:absolute;font-size:24px;color:#FFFFFF" id="currentTimeDiv"></div>
    <div style="left:913px; top:574px;width:50px;height:27px;font-size:24px; position:absolute;color:#FFFFFF" id="endTimeDiv"></div>
    <!--快进货快退倍数(2X)-->
    <div align="right" style="left:505px; top:550px;width:55px;height:27px;font-size:24px;color:#FFFFFF; position:absolute"id="speedDiv">    </div>
    <!--进度条-->
    <div style="left:510px; top:582px;width:0px;height:3px; position:absolute;">
        <img id="speedBarDiv" src="images/vod/btv-02-progressred2.png" width="0" height="3" alt="">
    </div>
    <div id="icon" style="left:508px; top:570px;width:26px;height:26px; position:absolute; ">
        <img src="images/vod/btv-02-progressico2.png" alt="" width="26" height="26" border="0">
    </div>
   <!--收藏-->
    <div style="left:290px; top:630px;width:500px;height:31px; position:absolute;font-size:22px;color:#FFFFFF">
        <img src="images/vod/btv_Collection.png" alt="" border="0"/>
        <font style="position:absolute;left:70px;top:5px;width:400px;">收藏</font>
    </div>
    <!--书签-->
    <div style="left:430px; top:630px;width:200px;height:31px; position:absolute;">
        <div id="point" style="left:0; top:0;width:200px;height:31px; position:absolute;font-size:22px;color:#FFFFFF;visibility:hidden">
            <img src="images/vod/btn_break_point.png" alt="" border="0"/>
            <font style="position:absolute;left:70px;top:5px;width:100px">书签</font>
        </div>
     </div>
    <!---定时播放-->
    <div id="locdiv" style="left:878px; top:628px;width:200;height:31; position:absolute;font-size:20px;">
        <div id="loc0" style="left:12px; top:2px;width:28;height:28;font-size:23px; position:absolute;color:#FFFFFF;">00</div>
        <div id="loc1" style="left:80px; top:2px;width:28;height:28;font-size:23px; position:absolute;color:#FFFFFF;">00</div>
        <div id="line" style="left:21px; top:3px;width:2px;height:20px; position:absolute;">
            <img src="images/vod/focusLine.gif" alt="" border="0"/>
        </div>
    </div>
    <!--收藏提示信息-->
    <div style="left:420px; top:229px;width:568px;height:215px; position:absolute;z-index:2000">
        <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
            <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
                <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
            </div>
            <div id="text" style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center"></div>
            <div id="closeMsg" style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
                 2秒自动关闭
            </div>
        </div>
    </div>
</div>
<div id="locTime" style="left:1100; top:30;width:30;height:28; position:absolute;font-size:30px;color:#FFFFFF;visiblity:hidden"></div>
        <!--广告-->
	<div  id="advert_t" style="position:absolute; width:220px; height:110px; left:40px; top: 550px;">
        <img src="" id="advert_pic0" alt="" width="220" height="110" border="0">
    </div>
    <div  style="position:absolute; width:220px; height:110px; left:1020px; top: 550px;">
        <img src="" id="advert_pic1" alt="" width="220" height="110" border="0">
    </div>
</body>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript">
    var $$ = {};
    var timer=-1;
    var toptimer=-1;
    var $ = function(id) {
        if (!$$[id]) {
            $$[id] = document.getElementById(id);
        }
        return $$[id];
    }
    var index = -1;
   // var leftarr = [26,94];
	var leftarr = [21,89];
    function onkeypress(evt) {
        var keyCode = parseInt(evt.which);
        if (keyCode == 0x0028) { //onKeyDown
			onKeyDown();
		}else if (keyCode == 0x0026) {//onKeyUp
			onKeyUp();
		}else if (keyCode == 0x0025) { //onKeyLeft
				/*if("pause" == type){
					  onLeft();	
				}*/
            onLeft();   
        } else if (keyCode == 0x0027) { //onKeyRight
				/*if("pause" == type){
					    onRight();
				}*/
            onRight();  
        }else if(keyCode == 0x0109){ // remind
                //checkPress();
            //document.getElementById("point").style.visibility="hidden";
            pageFastRewind();
        } else if(keyCode == 0x0108){ //reForard
                //checkPress();
            //document.getElementById("point").style.visibility="hidden";
            pageFastForword();
        } else if (keyCode == 0x000D) {  //OK
                //locationPlay();
			pressKeyOK();	
        }else if(keyCode == 0x0107){//pause
            pagePlayPause();
		}else if (keyCode == 0x0008  || keyCode == 24) {  //back
//            pageOnKeyOK();
            return false;
        }else if (keyCode == 0x0110  || keyCode == 36) {  //portal
			gotoPortal();
        }else if(keyCode == 0x0114){
             if(type == "pause"){
                 addMark();
             }
        } else if (keyCode >= 0x30 && keyCode <= 0x39){
				if(index == -1){
				
				}else{
                	onKeyNumChar(keyCode);
				}
        }else if(keyCode==0x0113){ //red favorite
                favoritedo();
        } else {
            top.doKeyPress(evt);
            return true;
        }                                                                                            
        return false;
    }
	var isZTEBW = false;
    if (window.navigator.appName.indexOf("ztebw") >= 0) {
        isZTEBW = true;
    }
	function pressKeyOK(){//新OK方法
		if(document.getElementById("advert_t").style.border == "4px solid red"){//焦点位于左侧广告图片上
			doJump();
			return;
		}else if(document.getElementById("div0").style.visibility == "visible"){//焦点位于快退上
			pageFastRewind();
		}else if(document.getElementById("div1").style.visibility == "visible"){//暂停
			pagePlayPause();
		}else if(document.getElementById("div2").style.visibility == "visible"){//快进
			pageFastForword();
		}else{//跳转时间点
		    var duration = parseInt(top.jsDoGetVODTimeInfo());
			var hours = document.getElementById("loc0").innerHTML;
			var min = document.getElementById("loc1").innerHTML;
			var inputTime = parseInt(hours,10) * 3600 + parseInt(min,10) * 60;
			if (inputTime >= 0 && inputTime <= duration)
			{
				document.getElementById("pro").style.visibility="hidden";
				document.getElementById("locdiv").style.visibility="hidden";
				document.getElementById("line").style.visibility="hidden";
				document.getElementById("div1").style.visibility="hidden";
				//document.getElementById("div3").style.visibility="hidden";
				document.getElementById("advert_pic0").style.visibility="hidden";
				document.getElementById("advert_pic1").style.visibility="hidden";
				document.getElementById("locTime").innerHTML=hours+":"+min;
				document.getElementById("locTime").style.visibility="visible";
				document.getElementById("point").style.visibility="hidden";
				if (isZTEBW) {
					clearTimeout(toptimer);
					top.jsDoSeekTargetTime(1, inputTime);
					toptimer = setTimeout(hiddenTop, 3000);
				} else {
					top.jsDoResume();
					setTimeout(function () {
						top.jsDoSeekTargetTime(1, inputTime);
						document.getElementById("locTime").innerHTML = "";
						document.getElementById("locTime").style.visibility = "hidden";
						top.jsHideOSD();
					}, 500);
				}
			} else {
				$("text").innerHTML = "您输入的时间超出范围！";
				$("msg").style.visibility = "visible";
				$("closeMsg").style.visibility = "visible";
				clearTimeout(timer);
				timer = setTimeout(closeMessage, 2000);
			}
		}
	}
	/*
     function locationPlay() {
		 
		 if("pause" != type){
			 	doJump();
				return; 
		}else if( type == "pause" ){
			if(document.getElementById("advert_t").style.border == "4px solid red"){
				doJump();
				return;	
			}
			var duration = parseInt(top.jsDoGetVODTimeInfo());
			var hours = document.getElementById("loc0").innerHTML;
			var min = document.getElementById("loc1").innerHTML;
			var inputTime = parseInt(hours,10) * 3600 + parseInt(min,10) * 60;
			if (inputTime >= 0 && inputTime <= duration)
			{
				document.getElementById("pro").style.visibility="hidden";
				document.getElementById("locdiv").style.visibility="hidden";
				document.getElementById("line").style.visibility="hidden";
				document.getElementById("div1").style.visibility="hidden";
				//document.getElementById("div3").style.visibility="hidden";
				document.getElementById("advert_pic0").style.visibility="hidden";
				document.getElementById("advert_pic1").style.visibility="hidden";
				document.getElementById("locTime").innerHTML=hours+":"+min;
				document.getElementById("locTime").style.visibility="visible";
				document.getElementById("point").style.visibility="hidden";
				if (isZTEBW) {
					clearTimeout(toptimer);
					top.jsDoSeekTargetTime(1, inputTime);
					toptimer = setTimeout(hiddenTop, 3000);
				} else {
					top.jsDoResume();
					setTimeout(function () {
						top.jsDoSeekTargetTime(1, inputTime);
						document.getElementById("locTime").innerHTML = "";
						document.getElementById("locTime").style.visibility = "hidden";
						top.jsHideOSD();
					}, 500);
				}
			} else {
				$("text").innerHTML = "您输入的时间超出范围！";
				$("msg").style.visibility = "visible";
				$("closeMsg").style.visibility = "visible";
				clearTimeout(timer);
				timer = setTimeout(closeMessage, 2000);
			}
		}
    }*/
    function hiddenTop(){
        document.getElementById("locTime").innerHTML="";
        document.getElementById("locTime").style.visibility="hidden";
        top.jsDoResume();
        top.jsHideOSD();
        clearTimeout(toptimer);
    }
    function onLeft() {
		/*if(index==0){
			document.getElementById("advert_t").style.border ="4px solid red";
			document.getElementById("advert_t").style.top="546px";
			document.getElementById("line").style.visibility="hidden";
			document.getElementById("line").style.left = leftarr[0];
			index--;	
		}else if (index > 0 && index <= 1) {
            var str=document.getElementById("loc"+index).innerHTML;
            if(str.length<1){
                document.getElementById("loc"+index).innerHTML = "0"+str;
            }
            index--;
            document.getElementById("line").style.left = leftarr[index];
        }*/
		if(document.getElementById("div0").style.visibility == "visible"){//焦点位于快退上
			document.getElementById("div0").style.visibility = "hidden";
			document.getElementById("advert_t").style.border = "4px solid red";
			document.getElementById("advert_t").style.top="546px";
		}else if(document.getElementById("div1").style.visibility == "visible"){//暂停
			document.getElementById("div1").style.visibility = "hidden";
			document.getElementById("div0").style.visibility = "visible";
		}else if(document.getElementById("div2").style.visibility == "visible"){//快进
			document.getElementById("div2").style.visibility = "hidden";
			document.getElementById("div1").style.visibility = "visible";
		}else{//焦点位于时间定位上			
			if(index==0){//焦点位于左边方格上
				document.getElementById("line").style.visibility="hidden";
				document.getElementById("line").style.left = leftarr[0];
				document.getElementById("loc"+index).style.visibility = "visible";
				index--;					
				document.getElementById("div2").style.visibility = "visible";
			}else if(index > 0 && index <= 1){//焦点位于右边方格上
				var str=document.getElementById("loc"+index).innerHTML;
				if(str.length<1){
					document.getElementById("loc"+index).innerHTML = "0"+str;
				}
				document.getElementById("loc"+index).style.visibility = "visible";
				index--;
				document.getElementById("loc"+index).style.visibility = "hidden";
				document.getElementById("line").style.left = leftarr[index];
			}
		}
		
    }
    function onRight() {
		/*if(index<0){
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
			document.getElementById("locdiv").style.visibility = "visible";	
			 index++;
            document.getElementById("line").style.left = leftarr[index];	
			document.getElementById("line").style.visibility="visible";
			
		}else if (index >= 0 && index < 1) {
            var str=document.getElementById("loc"+index).innerHTML;
            if(str.length<1){
                document.getElementById("loc"+index).innerHTML = "0"+str;
            }
            index++;
            document.getElementById("line").style.left = leftarr[index];
        }*/
		if(document.getElementById("advert_t").style.border == "4px solid red"){//焦点位于左侧广告图片上
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
			document.getElementById("div0").style.visibility = "visible";	
		}else if(document.getElementById("div0").style.visibility == "visible"){//焦点位于快退上
			document.getElementById("div0").style.visibility = "hidden";
			document.getElementById("div1").style.visibility = "visible";
		}else if(document.getElementById("div1").style.visibility == "visible"){//暂停
			document.getElementById("div1").style.visibility = "hidden";
			document.getElementById("div2").style.visibility = "visible";
		}else if(document.getElementById("div2").style.visibility == "visible"){//快进
			document.getElementById("div2").style.visibility = "hidden";			
			if(index<0){	
				index++;
				document.getElementById("line").style.left = leftarr[index];					
				document.getElementById("loc"+index).style.visibility = "hidden";
				document.getElementById("line").style.visibility="visible";
			}
		}else{//焦点位于时间定位上			
			if(index >= 0 && index < 1) {
				var str=document.getElementById("loc"+index).innerHTML;
				if(str.length<1){
				  document.getElementById("loc"+index).innerHTML = "0"+str;
				}
				document.getElementById("loc"+index).style.visibility = "visible";
				index++;
				document.getElementById("loc"+index).style.visibility = "hidden";
				document.getElementById("line").style.left = leftarr[index];	
				
			}
		}
    }
	
	function onKeyUp(){
		if(index==0){//焦点位于左边方格上
			document.getElementById("line").style.visibility="hidden";
			document.getElementById("line").style.left = leftarr[0];
			document.getElementById("loc"+index).style.visibility = "visible";
			index--;
			document.getElementById("div2").style.visibility = "visible";
		}else if(index > 0 && index <= 1){//焦点位于右边方格上
			var str=document.getElementById("loc"+index).innerHTML;
			if(str.length<1){
				document.getElementById("loc"+index).innerHTML = "0"+str;
			}
			document.getElementById("line").style.visibility="hidden";
			document.getElementById("line").style.left = leftarr[0];
			document.getElementById("loc"+index).style.visibility = "visible";
			index = -1;
			document.getElementById("div2").style.visibility = "visible";			
		}
	}
	
	function onKeyDown(){
		if(document.getElementById("advert_t").style.border == "4px solid red"){
			return;
		}
		document.getElementById("div0").style.visibility = "hidden";
		document.getElementById("div1").style.visibility = "hidden";
		document.getElementById("div2").style.visibility = "hidden";
		if(index<0){	
			index++;
			document.getElementById("line").style.left = leftarr[index];	
			document.getElementById("loc"+index).style.visibility = "hidden";
			document.getElementById("line").style.visibility="visible";
		}
	}
	
    function onKeyNumChar(keyCode) {
		document.getElementById("loc"+index).style.visibility = "visible";
        var channelNum = keyCode - 0x30;
        var value = document.getElementById("loc" + index).innerHTML;
        if (value.length == 2) {
            document.getElementById("loc" + index).innerHTML = "";
            document.getElementById("loc" + index).innerHTML = checkNum(channelNum);
            if(index==0){
                index=1;
				document.getElementById("loc"+index).style.visibility = "hidden";
                document.getElementById("line").style.left = leftarr[1];
            }else{
				document.getElementById("line").style.left = leftarr[index]+14;
			}
        } else {
            document.getElementById("loc" + index).innerHTML += channelNum;
            if (index < 1) {
                index++;
                document.getElementById("line").style.left = leftarr[index];
            }
        }
    }

    function checkNum(num) {
        if (index == 0) {
            return "0"+num;
        } else if (index == 1) {
            if (parseInt(num) <= 5) {
                return parseInt(num);
            }else{
                return "0"+parseInt(num);
            }
//        } else if (index == 1) {
//            return num;
//        }
        }
        return "00";
    }
    function getNumFromInput(textInput) {
        var num = -1;
        if (textInput == "") {
            num = 0;
        } else {
            for (var i = 0; i < textInput.length; i++) {
                if (textInput.charAt(i) < "0" || textInput.charAt(i) > "9") {
                    num = -1;
                    return num;
                }
            }
            num = parseInt(textInput, 10);
        }
        return num;
    }
    function checkPress(){
        document.onkeypress=top.doKeyPress;
        document.getElementById("locdiv").style.visibility="hidden";
        document.getElementById("point").style.visibility="hidden";
    }


    //添加书签  规避js方法
    function jsSaveFaver()
    {
        var currentTime = top.mp.getCurrentPlayTime();
        if (top.configPara["bpBookMarkParm"] != "")
        {
            top.refrWin.document.location = top.configPara["BPSaveUrl"] + top.configPara["bpBookMarkParm"] + "&breakpoint=" + currentTime;
//            configPara["bpBookMarkParm"] = "";
        }
        else
        {
            top.refrWin.document.location = top.configPara["BPSaveUrl"] + "?programid=" + top.configPara["vodProgramid"] + "&breakpoint=" + currentTime;
        }
    }

    function addMark(){
//        top.jsSaveFaver();
       // alert("SSSSSSSSSSSSSSSSSSmyaddMark!!!!!");
        jsSaveFaver();
        $("text").innerText = "添加书签成功";
        $("msg").style.visibility = "visible";
        $("closeMsg").style.visibility = "visible"; 
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
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
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else if (dellflag == 2) {
            $("text").innerText = "节目已收藏";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else if (dellflag == 3) {
            $("text").innerText = "您的收藏已达上限";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else {
            $("text").innerText = "收藏失败";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        }
    }
    function closeMessage() {
        document.getElementById("loc0").innerHTML = "00";
        document.getElementById("loc1").innerHTML = "00";
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
        $("closeMsg").style.visibility = "hidden";
        clearTimeout(timer);        
    }
	function gotoPortal() {
   			
  		  _window.top.mainWin.document.location = "portal.jsp";
    		
  		   
		}
    top.jsSetupKeyFunction("top.mainWin.favoritedo", 0x0113);
    top.jsSetupKeyFunction("top.mainWin.gotoPortal",  0x0110);
	top.jsSetupKeyFunction("top.mainWin.gotoPortal", 36);
</script>

<script language="javascript" type="">
    var imgarr = ["images/vod/btv-02-leftc.png","images/vod/btv-02-pausec.png","images/vod/btv-02-rightc.png"];
    var imgarr1 = ["images/vod/btv-02-left.png","images/vod/btv-02-pause.png","images/vod/btv-02-right.png"];
    var toparr = [20,15,20];

    var type = "<%=request.getParameter("fast")%>";
    var speed = 1 ;
    var flag = 0;
	
	if ("RR"==type) {
        top.mainWin.document.getElementById("div0").style.visibility="visible";
    } else if ("pause"==type) {
        top.mainWin.document.getElementById("div1").style.visibility="visible";
    } else if ("FF"==type) {
        top.mainWin.document.getElementById("div2").style.visibility="visible";
    }
	
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
		document.getElementById("advert_pic0").style.visibility="hidden";
		document.getElementById("advert_pic1").style.visibility="hidden";
    }

    //在这个页面按OK和按暂停效果是一样的都是重新播放。
    function pageOnKeyOK() {
        pagePlayPause();
    }

    //快进
    function pageFastForword() {
		document.getElementById("point").style.visibility="hidden";
		if(document.getElementById("advert_t").style.border == "4px solid red"){
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
		}else if(document.getElementById("line").style.visibility=="visible"){
			document.getElementById("line").style.visibility="hidden";
			index = -1;
		}
        var isFF=false;
        if(type=="RR"  || type=="pause"){
          isFF=true;
        }else{
          isFF=false;
        }
        type = "FF";
        speed = top.getStbPlaySpeed();
        if (speed <= 0 || speed == 64)
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
        //if(speed==2 && isFF==true){
          changeImg(2);
        //}
    }

    //快退
    function pageFastRewind() {
		document.getElementById("point").style.visibility="hidden";
		if(document.getElementById("advert_t").style.border == "4px solid red"){
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
		}else if(document.getElementById("line").style.visibility=="visible"){
			document.getElementById("line").style.visibility="hidden";
			index = -1;
		}
        var isRR=false;
        if(type=="FF" || type=="pause"){
            isRR=true;
        }else{
            isRR=false;
        }
        type = "RR";
        speed = top.getStbPlaySpeed();
        if (speed >= 0 || speed == -64)
        {
            speed = -2;
        }
        else
        {
            speed = speed * 2;
        }
        var nowspeed = speed;
        top.mainWin.document.all.speedDiv.innerHTML = nowspeed + "X";
        top.doFastRewind(speed);
        //if(nowspeed == -2 && isRR==true){
          changeImg(0);
        //}
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
        var VODTimeInfo = parseInt(currentTime,10);
        if (VODTimeInfo == 0)
        {
            top.mainWin.document.all.currentTimeDiv.innerHTML = " / ";
            return;
        }
        var VODTotalHours = VODTimeInfo / 3600 ;
        VODTotalHours = parseInt(VODTotalHours,10);
        if (("" + VODTotalHours).length == 1)
        {
            VODTotalHours = "0" + VODTotalHours;
        }
        var StrVODTotalHours = VODTotalHours;
        VODTotalHours = parseInt(VODTotalHours, 10);
        var VODTotalMinutes = (VODTimeInfo - VODTotalHours * 3600) / 60;
        VODTotalMinutes = parseInt(VODTotalMinutes,10);
        if (("" + VODTotalMinutes).length == 1)
        {
            VODTotalMinutes = "0" + VODTotalMinutes;
        }
        top.mainWin.document.all.currentTimeDiv.innerHTML = StrVODTotalHours + ":" + VODTotalMinutes ;
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
        var tempLength = (tempCurrentTime * 270) / tempEndTime;
        tempLength = parseInt(tempLength);
       if (tempLength == 0)
        {
            top.mainWin.document.all.speedBarDiv.style.width = 1;
            top.mainWin.document.all.icon.style.left = 508;
        }
        else if (tempLength >= 270)
        {
            top.mainWin.document.all.speedBarDiv.style.width = 270;
            top.mainWin.document.all.icon.style.left = tempLength+508;
        }
        else
        {
            top.mainWin.document.all.speedBarDiv.style.width = tempLength;
            top.mainWin.document.all.icon.style.left = tempLength+508;
        }
    }
    function changeImg(index) {
        for (var i = 0; i < 3; i++) {
            if (i == index) {
                top.mainWin.document.getElementById("div" + i).style.visibility="visible";
            } else {
                top.mainWin.document.getElementById("div" + i).style.visibility="hidden";
            }
        }
    }
    function pageInit() {
        //top.jsSetupKeyFunction("top.mainWin.pageFastRewind", 0x0109);
        //top.jsSetupKeyFunction("top.mainWin.pageFastForword", 0x0108);
        //top.jsSetupKeyFunction("top.mainWin.pageFastRewind", <%=STBKeysNew.onKeyLeft%>);
        //top.jsSetupKeyFunction("top.mainWin.pageFastForword", <%=STBKeysNew.onKeyRight%>);


        //top.jsSetupKeyFunction("top.mainWin.pageOnKeyOK", 0x000d);
        //top.jsSetupKeyFunction("top.mainWin.pagePlayPause", 0x0107);
        if (type == "FF") {
            top.mainWin.document.all.speedDiv.innerHTML = "2X";
			//document.getElementById("point").style.visibility = "hidden";
			//document.getElementById("locdiv").style.visibility = "hidden";
			document.getElementById("line").style.visibility = "hidden";
        } else if (type == "RR") {
            top.mainWin.document.all.speedDiv.innerHTML = "-2X";
			//document.getElementById("point").style.visibility = "hidden";
			//document.getElementById("locdiv").style.visibility = "hidden";
			document.getElementById("line").style.visibility = "hidden";
        } else if (type == "pause") {
            top.mainWin.document.all.speedDiv.innerHTML = "";
            document.getElementById("point").style.visibility = "visible";
			//document.getElementById("locdiv").style.visibility = "visible";
			document.getElementById("line").style.visibility = "hidden";
            pageRefreshBarState();
        }
       // document.getElementById("locdiv").style.visibility = "visible";
        document.onkeypress = onkeypress;
        pageVODSpeedInitStartAndEnd();
        setRefreshBarTimer();
    }
    document.onkeypress = top.doKeyPress;
    focus();
</script>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script type="text/javascript" >
		function $(id){
    		return document.getElementById(id);
		}
		if(play_flag_pic==0){
            for(var i=0;i<advert_pic.length;i++){
                if(advert_pic[i].areaName=="speed"){
                $("advert_pic0").src = "images/advert/"+ advert_pic[i].picName;
                $("advert_pic1").src = "images/advert/"+ advert_pic[i].picName1;
                break;
                }
            }
		}
		function doJump(){
			for(var j=0;j<advert_pic_jump.length;j++){
				if(advert_pic_jump[j].name=="live6"){
					top.doStop();  //点播快进快退时广告图片点击OK的跳转
					top.mainWin.document.location = advert_pic_jump[j].url;
					return;
				}
			}
		}
	</script>
</html>
