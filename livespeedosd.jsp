<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.content.ProgramInfo" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@include file="inc/words.jsp"%>
<%
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);

    String columnId = (String)param.get("column0");
    String channelId = request.getParameter("channelid");
    String type=request.getParameter("fast");
%>
<html>
    <head>
        <title>

        </title>
        <style type="text/css">
            div{
                color:#FFFFFF;
            }
            .STYLE4 {
                font-size: 24px;
            }
        </style>
    </head>
    <body bgcolor="transparent" background="" onLoad="pageInit();">
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
    <div style="left:801px; top:574px;width:80px;height:27px; position:absolute;font-size:24px;color:#FFFFFF"id="startTimeDiv"></div>
    <div style="left:913px; top:574px;width:50px;height:27px;font-size:24px; position:absolute;color:#FFFFFF" id="endTimeDiv"></div>
    <!--快进货快退倍数(2X)-->
    <div align="right" style="left:505px; top:550px;width:55px;height:27px;font-size:24px;color:#FFFFFF; position:absolute"id="speedDiv"></div>
    <!--进度条-->
    <div style="left:510px; top:582px;width:0px;height:3px; position:absolute;">
        <img id="speedBarDiv" src="images/vod/btv-02-progressred2.png" width="0" height="3" alt="">
    </div>
    <div id="icon" style="left:508px; top:570px;width:26px;height:26px; position:absolute; ">
        <img src="images/vod/btv-02-progressico2.png" alt="" width="26" height="26" border="0">
    </div>
    <div style="left:610px; top:550px;width:68px;height:33px;font-size:24px;position:absolute" id="currentTimeDiv"></div>

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
        <div id="text" style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">

        </div>
        <div  id="closeMsg" style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
            2秒自动关闭
        </div>
    </div>
</div>
    <div  id="advert_t" style="position:absolute; width:220px; height:110px; left:40px; top: 550px;">
    <img src="" id="advert_pic0" alt="" width="220" height="110" border="0">
    </div>
    <div  style="position:absolute; width:220px; height:110px; left:1020px; top: 550px;">
    <img src="" id="advert_pic1" alt="" width="220" height="110" border="0">
    </div>

</body>
<script language="javascript">
      var imgarr = ["images/vod/btv-02-leftc.png","images/vod/btv-02-pausec.png","images/vod/btv-02-rightc.png"];
    var imgarr1 = ["images/vod/btv-02-left.png","images/vod/btv-02-pause.png","images/vod/btv-02-right.png"];
    var toparr = [20,15,20];
    var type="<%=type%>";
    var speed = 1 ;

	if ("RR"==type) {
        top.mainWin.document.getElementById("div0").style.visibility="visible";
    } else if ("pause"==type) {
        top.mainWin.document.getElementById("div1").style.visibility="visible";
    } else if ("FF"==type) {
        top.mainWin.document.getElementById("div2").style.visibility="visible";
    }

    function pagePlayPause() {

	    if(MonitorTimerId != null) {
	     	top.mainWin.clearTimeout(MonitorTimerId);
	     	MonitorTimerId = null;
	    }
		top.pageResume();
        top.hideOSD();
        return false;
    }

var timer = null;
      function showMessage(type){
          if(type == 1){
              document.getElementById("text").innerHTML = "您输入的时间错误！";
          }else{
              document.getElementById("text").innerHTML = "您输入的时间超出范围！";
          }

          document.getElementById("msg").style.visibility = "visible";
document.getElementById("closeMsg").style.visibility = "visible";
          if(timer != null){
          clearTimeout(timer);
}
          timer = setTimeout(closeMessage, 2000);
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

      function closeMessage() {
          document.getElementById("loc0").innerHTML = "00";
          document.getElementById("loc1").innerHTML = "00";
          document.getElementById("text").innerText = "";
          document.getElementById("msg").style.visibility = "hidden";
          document.getElementById("closeMsg").style.visibility = "hidden";
          clearTimeout(timer);
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
			  var hoursInput = document.getElementById("loc0").innerHTML;
			  var minutesInput = document.getElementById("loc1").innerHTML;
			  if (hoursInput == "" && minutesInput == "")
			  {
				  showMessage(1);
				  return;
			  }
			  var targetHours = getNumFromInput(hoursInput);
			  if (targetHours == -1 || targetHours >= 24)
			  {
				  showMessage(1);
				  return;
			  }

			  var targetMinutes = getNumFromInput(minutesInput);
			  if (targetMinutes == -1 || targetMinutes >= 60)
			  {
				  showMessage(1);
				  return;
			  }
			  //    top.jsDebug("input hours = " + targetHours + " and input minutes = " + targetMinutes);
			  if (top.currState == 2)
			  {
				  //20081013T191625.56Z-20081014T101625.56Z
				  var targetDate = "";
				  var inputTime = new Date();
				  inputTime.setHours(parseInt(targetHours));
				  inputTime.setMinutes(parseInt(targetMinutes));
				  top.getTSTVTime();
				  var beginHourInt = top.TSTVBeginTime.getHours();
				  var endHourInt = top.TSTVEndTime.getHours();

				  if ((beginHourInt > endHourInt || beginHourInt == endHourInt) && targetHours > endHourInt)
				  {
					  inputTime.setTime(inputTime.getTime() - 24 * 3600 * 1000);
				  }

				  var TSBeginTimeM = parseInt(top.TSTVBeginTime.getTime() / 60000);
				  var inputTimeM = parseInt(inputTime.getTime() / 60000);
				  var TSEndTimeM = parseInt(top.TSTVEndTime.getTime() / 60000);
				  if (TSBeginTimeM <= inputTimeM && inputTimeM <= TSEndTimeM){
					  inputTime.setTime(inputTime.getTime() + inputTime.getTimezoneOffset() * 60 * 1000);
					  var year = inputTime.getFullYear() + "";
					  var month = top.formatStr(inputTime.getMonth() + 1);
					  var day = top.formatStr(inputTime.getDate());
					  targetHours = top.formatStr(inputTime.getHours());
					  targetMinutes = top.formatStr(inputTime.getMinutes());
					  targetDate = year + month + day + "T" + targetHours + targetMinutes + "00Z";
					  top.mp.playByTime(2, targetDate, 1);
					  top.jsHideOSD();
				  }else{
					  showMessage(2);
				  }
			  }
			}
		}
      function locationPlay()
      {
//          var hoursInput = document.getElementById("hoursInput").value;
//          var minutesInput =document.getElementById("minutesInput").value;
		 if("pause" != type){
			 	doJump();
				return; 
		 }else if( type == "pause" ){
			if(document.getElementById("advert_t").style.border == "4px solid red"){
				doJump();
				return;	
			}
          var hoursInput = document.getElementById("loc0").innerHTML;
          var minutesInput = document.getElementById("loc1").innerHTML;
          if (hoursInput == "" && minutesInput == "")
          {
              showMessage(1);
              return;
          }
          var targetHours = getNumFromInput(hoursInput);
          if (targetHours == -1 || targetHours >= 24)
          {
              showMessage(1);
              return;
          }

          var targetMinutes = getNumFromInput(minutesInput);
          if (targetMinutes == -1 || targetMinutes >= 60)
          {
              showMessage(1);
              return;
          }
          //    top.jsDebug("input hours = " + targetHours + " and input minutes = " + targetMinutes);
          if (top.currState == 2)
          {
              //20081013T191625.56Z-20081014T101625.56Z
              var targetDate = "";
              var inputTime = new Date();
              inputTime.setHours(parseInt(targetHours));
              inputTime.setMinutes(parseInt(targetMinutes));
              top.getTSTVTime();
              var beginHourInt = top.TSTVBeginTime.getHours();
              var endHourInt = top.TSTVEndTime.getHours();

              if ((beginHourInt > endHourInt || beginHourInt == endHourInt) && targetHours > endHourInt)
              {
                  inputTime.setTime(inputTime.getTime() - 24 * 3600 * 1000);
              }

              var TSBeginTimeM = parseInt(top.TSTVBeginTime.getTime() / 60000);
              var inputTimeM = parseInt(inputTime.getTime() / 60000);
              var TSEndTimeM = parseInt(top.TSTVEndTime.getTime() / 60000);
              if (TSBeginTimeM <= inputTimeM && inputTimeM <= TSEndTimeM){
                  inputTime.setTime(inputTime.getTime() + inputTime.getTimezoneOffset() * 60 * 1000);
                  var year = inputTime.getFullYear() + "";
                  var month = top.formatStr(inputTime.getMonth() + 1);
                  var day = top.formatStr(inputTime.getDate());
                  targetHours = top.formatStr(inputTime.getHours());
                  targetMinutes = top.formatStr(inputTime.getMinutes());
                  targetDate = year + month + day + "T" + targetHours + targetMinutes + "00Z";
                  top.mp.playByTime(2, targetDate, 1);
//                  pageDisableWithTimer();
                  top.jsHideOSD();
              }else{
                  showMessage(2);
              }
          }
		 }
      }

      function onkeypress(evt) {
          var keyCode = parseInt(evt.which);
        //  alert("SSSSSSSSSSSSSSSSSSSSSSonkeypress="+keyCode);
          if (keyCode == 0x0028) { //onKeyDown
				onKeyDown();
		  }else if (keyCode == 0x0026) { //onKeyUp
				onKeyUp();
		  }else if (keyCode == 0x0025) { //onKeyLeft
		  		/*if("pause" == type){
					  onLeft();	
				}*/
              onLeft(); 
          }else if (keyCode == 0x0027) { //onKeyRight
		  		/*if("pause" == type){
					 onRight();
				}*/
              onRight();
          }else if (keyCode == 0x000D) {  //OK
              //locationPlay();
			  pressKeyOK();
          }else if (keyCode == 0x0022) {  //remotePlayNext
              playNext();
          }else if (keyCode == 0x0021) {  //remotePlayLast
              playLast();
          }else if (keyCode == 0x0109) {  //快退
			  pageFastRewind();  
          }else if (keyCode == 0x0107) {  //暂停
			  pagePlayPause(); 
          }else if (keyCode == 0x0108) {  //快进
			  pageFastForword(); 
          }else if (keyCode == 0x0008 || keyCode == 24) {  //back
//              pageOnKeyOK();
              return false;
          }else if (keyCode == 0x0110 || keyCode == 36) {  //portal
				pageResume();
          }else if (keyCode >= 0x30 && keyCode <= 0x39){
              onKeyNumChar(keyCode);
          }else {
              top.doKeyPress(evt);
              return true;
          }
          return false;
      }

      var index = -1;
      //var leftarr = [26,94]
	var leftarr = [21,89];
	function onLeft(){
	  /*
	  if(index==0){
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
	  }
	  */
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
	function onRight(){
	  /*
	  if(index<0){
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
	  }
	  */
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
        //  alert("SSSSSSSSSSSSindex_value="+index+"_"+value);
          if (value.length == 2) {
              document.getElementById("loc" + index).innerHTML = "";
              document.getElementById("loc" + index).innerHTML = checkNum(channelNum);
			  document.getElementById("line").style.left = leftarr[index]+14;
//              if(index==0){
//                  index=1;
//                  document.getElementById("line").style.left = leftarr[1];
//              }
          } else {
              document.getElementById("loc" + index).innerHTML += channelNum;
//              if (index < 1) {
//                  index++;
//                  document.getElementById("line").style.left = leftarr[index];
//              }
          }
      }

      function checkNum(num) {
//          if (index == 0) {
//              return "0"+num;
//          } else if (index == 1) {
//              if (parseInt(num) <= 5) {
//                  return parseInt(num);
//              }else{
//                  return "0"+parseInt(num);
//              }
//          }
          if(index ==0){
              if (parseInt(num) <= 2) {
                  return parseInt(num);
              }else{
                  return "0"+parseInt(num);
              }
          }else if (index == 1 ) {
              if (parseInt(num) <= 5) {
                  return parseInt(num);
              }else{
                  return "0"+parseInt(num);
              }
          }
          return "00";
      }

    function pageOnKeyOK() {
        pagePlayPause();
    }

    function pageFastForword() {
		if(document.getElementById("advert_t").style.border == "4px solid red"){
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
		}else if(document.getElementById("line").style.visibility=="visible"){
			document.getElementById("line").style.visibility="hidden";
			index = -1;
		}
        var isFF=false;
        if(type=="RR" || type=="pause"){
            isFF=true;
        }else{
            isFF=false;
        }
	  /*  if(type == "pause") {

	    	top.mainWin.clearTimeout(refreshTimerId);
	    	refreshTimerId = top.mainWin.setTimeout("setRefreshBarTimer()", 1000);
	    }*/
        type = "FF";
        speed = top.getStbPlaySpeed();
        if (speed <= 0 || speed == 64) {
            speed = 2;
        } else {
            speed = speed * 2;
        }
      	top.doFastForward(speed);
        top.mainWin.document.all.speedDiv.innerHTML = speed + "X";
        //if(speed==2 && isFF==true){
            changeImg(2);
        //}
    }


    function pageFastRewind() {
		if(document.getElementById("advert_t").style.border == "4px solid red"){
			document.getElementById("advert_t").style.border = "0px solid red";
			document.getElementById("advert_t").style.top = "550px";
		}else if(document.getElementById("line").style.visibility=="visible"){
			document.getElementById("line").style.visibility="hidden";
			index = -1;
		}	
        var isRR=false;
        if(type="FF" || type=="pause"){
            isRR=true;
        }else{
            isRR=false;
        }
	   /* if(type == "pause") {

	    	top.mainWin.clearTimeout(refreshTimerId);
	    	refreshTimerId = top.mainWin.setTimeout("setRefreshBarTimer()", 1000);
	    }*/
        type = "RR";
        speed = top.getStbPlaySpeed();
        if (speed >= 0 || speed == -64) {
            speed = -2;
        } else {
            speed = speed * 2;
        }
        var nowspeed = speed;
        if (window.navigator.appName == "ztebw") {
            speed = -speed;
        }
        top.mainWin.document.all.speedDiv.innerHTML =  nowspeed + "X" ;
        //if(nowspeed == -2 && isRR==true){
            changeImg(0);
        //}
	   	top.doFastRewind(speed);
    }


    function pageVODSpeedInitStartAndEnd() {
        var beginTime = top.TSTVBeginTime;
        var endTime = top.TSTVEndTime;

        top.jsDebug("SSSSSSSSSSSSSSSSSSSpageVODSpeedInitStartAndEnd_beginTime="+new Date(beginTime));
        top.jsDebug("SSSSSSSSSSSSSSSSSSSpageVODSpeedInitStartAndEnd_endTime="+new Date(endTime));

        var beginTimeHour = top.formatStr(beginTime.getHours());
        var beginTimeMin = top.formatStr(beginTime.getMinutes());
//        var beginTimeAmOrPm=parseInt(beginTimeHour)>11?"pm":"am";
        var beginHourMin = beginTimeHour+":"+beginTimeMin;
        var endTimeHour = top.formatStr(endTime.getHours());
        var endTimeMin = top.formatStr(endTime.getMinutes());
//        var endTimeAmOrPm=parseInt(endTimeHour)>11?"pm":"am";
        var endTimeHourMin = endTimeHour+":"+endTimeMin;
        top.mainWin.document.all.startTimeDiv.innerText = beginHourMin;
        top.mainWin.document.all.endTimeDiv.innerText = endTimeHourMin;
    }
    var MonitorTimerId = null;
    function setMonitorTimer() {
        MonitorTimerId = null;
        var state = top.getStatus();
        if(state == "Normal Play") {
//            alert("==============hahah");
            top.hideOSD();
        }
    }
    function clearMonitorTimer() {
        if(MonitorTimerId != null) {
            top.mainWin.clearTimeout(MonitorTimerId);
            MonitorTimerId = null;
        }
    }

    function setRefreshBarTimer() {
	 	var currTime = parseInt(top.jsGetCurrentPlayTime());
        if (currTime == -1) {
        refreshTimerId = top.mainWin.setTimeout("setRefreshBarTimer()", 1000);
            return false;
        }
        pageRefreshBarState();
        if(type == "pause") {
            refreshTimerId = top.mainWin.setTimeout("setRefreshBarTimer()", 1000);
        } else {
            refreshTimerId = top.mainWin.setTimeout("setRefreshBarTimer()", 1000);
        }
   }


    function pageRefreshBarState() {
        top.jsDebug("SSSSSSSSSSSSSSpageRefreshBarState_top.currState="+top.currState);
	    if(top.currState == 2 || top.currState == 4) {
		    top.getTSTVTime();
		    pageVODSpeedInitStartAndEnd();
            var PlaySpeed = top.getStbPlaySpeed();
            var TSTVPlayTime = top.TSTVCurrentTime.getTime()+PlaySpeed*1000;
            var TSBeginTimeM = top.TSTVBeginTime.getTime();
            var TSEndTimeM = top.TSTVEndTime.getTime();

            top.jsDebug("SSSSSSSSSSSSSSSSSSpageRefreshBarState_PlaySpeed="+PlaySpeed);
            top.jsDebug("SSSSSSSSSSSSSSSSSSpageRefreshBarState_type="+type);
            top.jsDebug("SSSSSSSSSSSSSSSSSSpageRefreshBarState_TSTVCurrentTime="+new Date(top.TSTVCurrentTime));
            top.jsDebug("SSSSSSSSSSSSSSSSSSpageRefreshBarState_top.TSTVBeginTime="+new Date(top.TSTVBeginTime));
            top.jsDebug("SSSSSSSSSSSSSSSSSSpageRefreshBarState_top.TSTVEndTime="+new Date(top.TSTVEndTime));

//              alert("=============TSBeginTimeM"+TSBeginTimeM);
//              alert("=============TSTVPlayTime"+TSTVPlayTime);
//              alert("=============TSEndTimeM"+TSEndTimeM);
            if(type == "pause") {
                TSTVPlayTime = top.TSTVCurrentTime.getTime();
            } else if (TSTVPlayTime > TSEndTimeM && type == "FF") {
//                  alert("=========caca====TSTVPlayTime"+TSTVPlayTime);
			    clearMonitorTimer();
                top.doGoToEnd();
                top.jsHideOSD();
                return false;
            } else if (TSTVPlayTime < TSBeginTimeM && type == "RR") {
//                alert("=========haha====TSTVPlayTime"+TSTVPlayTime);
//                alert("=============TSBeginTimeM"+TSBeginTimeM);
			    clearMonitorTimer();
                top.doGoToStart();
                top.jsHideOSD();
                return false;
            }
            var currentPlayTime = new Date(TSTVPlayTime);
            var currentHours = top.formatStr(currentPlayTime.getHours());
            var currentMinutes = top.formatStr(currentPlayTime.getMinutes());
//            var curAmOrPm=parseInt(currentHours)>11?"pm":"am";
            top.mainWin.document.all.currentTimeDiv.innerText=currentHours+":"+currentMinutes;
            var beginToCurrTime = TSTVPlayTime - TSBeginTimeM;
            var beginToEndTime = TSEndTimeM - TSBeginTimeM;
//             alert("=======beginToEndTime========beginToEndTime"+beginToEndTime);
//             alert("=======beginToCurrTime========beginToCurrTime"+beginToCurrTime);
            var tempLength = parseInt(270 * beginToCurrTime / beginToEndTime);
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
		pageVODSpeedInitStartAndEnd();

        if (type == "FF"){
//            top.mainWin.document.all.stateImg.src = "images/liveTV/jin.png";
            top.mainWin.document.all.speedDiv.innerHTML = "2X";
			//document.getElementById("locdiv").style.visibility = "hidden";
			document.getElementById("line").style.visibility = "hidden";
        } else if(type == "RR") {
//            top.mainWin.document.all.stateImg.src = "images/liveTV/tui.png";
            top.mainWin.document.all.speedDiv.innerHTML = "-2X";
			//document.getElementById("locdiv").style.visibility = "hidden";
			document.getElementById("line").style.visibility = "hidden";
        } else if(type == "pause") {
//   	 	    top.mainWin.document.all.stateImg.src = "images/liveTV/pause.png";
   	 	    top.mainWin.document.all.speedDiv.innerHTML = "";
			//document.getElementById("locdiv").style.visibility = "visible";
			document.getElementById("line").style.visibility = "hidden";
   	    }
		
        //top.jsSetupKeyFunction("top.mainWin.pageFastRewind", 0x0109);
        //top.jsSetupKeyFunction("top.mainWin.pageFastForword", 0x0108);
        //top.jsSetupKeyFunction("top.mainWin.pageOnKeyOK", 0x000d);
        //top.jsSetupKeyFunction("top.mainWin.pageOnKeyOK", 8);
        //top.jsSetupKeyFunction("top.mainWin.pagePlayPause", 0x0107);
		
        setRefreshBarTimer();
   	    MonitorTimerId = top.mainWin.setTimeout("setMonitorTimer()", 5000);
    }

    function pageResume() {
//        if(top.isPlay() == true) {
  
            /*top.mainWin.document.location="portal.jsp?onlymenu=1";*/
     	top.mainWin.document.location="portal.jsp";
//        }
    }
 function playLast(){
          if(top.currState == 2)
          {
              top.getTSTVTime();
              var TSTVCurrentTimeM = parseInt(top.TSTVCurrentTime.getTime()/1000);
              var TSTVBeginTimeM = parseInt(top.TSTVBeginTime.getTime()/1000);
              if(TSTVCurrentTimeM > TSTVBeginTimeM)
              {
                  top.doGoToStart();
                  if(top.ippvObject.isIPPVChannel(top.channelInfo.currentChannel))
                  {
                      top.jsIPPVLocatePlay(channelInfo.currentChannel);
                  }
              }
          }else{
              top.remotePlayLast();
          }
          return false;
      }

      function playNext(){
          if(top.currState == 2 || top.currState ==5)
          {
              top.doGoToEnd();
              if(top.ippvObject.isIPPVChannel(top.channelInfo.currentChannel))
              {
                  top.jsIPPVLocatePlay(top.channelInfo.currentChannel);
              }
          }else{
              top.remotePlayNext();
          }
          return false;
      }
    top.jsSetupKeyFunction("top.mainWin.pageResume", <%=STBKeysNew.remoteMenu%>);
    top.jsSetupKeyFunction("top.mainWin.pageResume", 36);

//    document.onkeypress = top.doKeyPress;
    document.onkeypress = onkeypress;
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
					top.doStop();     //直播的快退快进的广告图片点击跳转
					top.mainWin.document.location = advert_pic_jump[j].url;
					return;
				}
			}
		}
	</script>
</html>