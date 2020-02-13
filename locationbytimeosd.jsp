<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%@ include file="inc/words.jsp" %>
<% 
	String imagesPath = "images1";

    String W_INPUTWRONG = "输入的时间错误,请重新输入!";

    String W_FROM = "从";
    String W_TO = "到";

    String W_INPUTTIME1 = "输入时间";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>/* locationbytimeosd.jsp
		* author:hanbing
		* date:2012.02.08
		*/</title>
<script type="text/javascript" src="js/STBKeyNew.js"></script>
<script type="text/javascript">
var inputflag = false;
var currIndex = 0;
function donothing(){}
function disableNumKey() {
    top.jsSetupKeyFunction("top.mainWin.donothing", 280);
    for (var j = 0; j < 10; j++) {
        top.keyFuncArray[top.keyCodeArray["onKeyNumChar"] + j] = "top.mainWin.donothing";
    }
}

function enableNumKey() {
    top.jsEnableNumKey();
}
function focusInput(inid)
{
	disableNumKey();
	inputflag = true;
	document.getElementById(inid).focus();
}
function blurInput(inid)
{
	enableNumKey();
	inputflag = false;
	document.getElementById(inid).blur();
}
function init()
{
	pageInit();
	currIndex = 0;
//	document.getElementById("error_show").style.display="none";
    document.getElementById("errorDiv").innerHTML = "";
	document.getElementById("locat_div").style.display="block";
	goUp();
}
function goUp()
{
	document.getElementById("hiddenFocus").blur();
	focusInput("hoursInput");
	document.getElementById("ok_key").src="url('images/vod/btv-02-add-bookmarkquit.png')";
	document.getElementById("cancel_key").src="url('images/vod/btv-02-add-bookmarkquit.png')";
	currIndex = 0;	
}
function goDown()
{
	blurInput("hoursInput");
	blurInput("minutesInput");
	document.getElementById("hiddenFocus").focus();
	document.getElementById("ok_key").src="url('images/vod/btv-02-add-bookmarkc.png')";
	document.getElementById("cancel_key").src="url('images/vod/btv-02-add-bookmarkquit.png')";
	currIndex = 2;	
}
function goLeft()
{
	if(currIndex==3)
	{
		document.getElementById("ok_key").src="url('images/vod/btv-02-add-bookmarkc.png')";
		document.getElementById("cancel_key").src="url('images/vod/btv-02-add-bookmarkquit.png')";
		currIndex =2;
	}
}
function goRight()
{

	if(currIndex==2)
	{
		document.getElementById("ok_key").src="url('images/vod/btv-02-add-bookmarkquit.png')";
		document.getElementById("cancel_key").src="url('images/vod/btv-02-add-bookmarkc.png')";
		currIndex =3;	
	}
}
function goOk()
{
	if(currIndex==2 || currIndex == 0)
	{
		pageDoSeek();
	}
	if(currIndex==3)
	{
		pageDisableWithTimer();
	}
}
function goBack()
{
	//if(currIndex==0||currIndex==1)
	//{
	//	return;
	//}
	pageDisableWithTimer();
}
function showMessage()
{
//	document.getElementById("hoursInput").value="";
//	document.getElementById("minutesInput").value="";
//	document.getElementById("hiddenFocus").focus();
	document.getElementById("errorDiv").innerHTML ="<%=W_INPUTWRONG%>";
//	document.getElementById("locat_div").style.display="none";
//	document.getElementById("error_show").style.display="block";
//	setTimeout("init()",2000);
}
document.onkeypress = dokeypress;
function dokeypress(evt)
{
	var keyCode = parseInt(evt.which);
    switch(keyCode)
   	{
		case STBKeysNew.onKeyUp:
		 	goUp();
	    	break;        
		case STBKeysNew.onKeyDown:
			goDown();
		    break;
		case STBKeysNew.onKeyLeft:
			if(inputflag)
			{
				top.doKeyPress(evt);
				return true;
			}
			goLeft();
	    	break;
		case STBKeysNew.onKeyRight:
			if(inputflag)
			{
				top.doKeyPress(evt);
				return true;
			}
			goRight();
		    break; 
		case STBKeysNew.onKeyOK:
			goOk();
		    break;
		case STBKeysNew.remoteLastPage:
			prevpage();
		    break;
		case STBKeysNew.remoteNextPage:
			nextpage();
		   break;
		case  STBKeysNew.remoteBack:
		case  STBKeysNew.remoteLocation:
			goBack();
			break;
		default:
			top.doKeyPress(evt);
			return true;
   	}
	return false;	
}
</script>
</head>
<body bgcolor="transparent" onload="init();">
<div  style="left:-50px;top:30px;width:1px; height:1px; position:absolute;">
     <a href="" id="hiddenFocus"><img src="images/btn_trans.gif" width="1" height="1"> </a>
</div>
<div style="position: absolute;left: 405px;top:190px;width: 493px;height: 286px;">
    <img width="493" height="268" src="images/vod/btv_promptbg.png" alt=""/>
</div>
<div id="locat_div" style="position: absolute;left: 395px;top:180px;width: 493px;height: 286px;display: block;">
	<div style="left:120;top:87;width:228;height:20;position:absolute;font-size:22px;color:#FFFFFF;" id="infoDiv" align="center">
	</div>
	<div style="left:35px; top:130px;width:200;height:25;font-size:22px; position:absolute" align="center">
	    <font color="#ffffff"><%=W_INPUTTIME1%>:
	    </font>
	</div>
	
	<div style="left:285; top:130;width:30;height:25;font-size:22px; position:absolute">
	    <font color="#ffffff">时
	    </font>
	</div>
	
	<div style="left:383px; top:130;width:30;height:25;font-size:22px; position:absolute">
	    <font color="#ffffff">分
	    </font>
	</div>
	
	<div style="left:240; top:130;width:40;height:28; position:absolute">
	    <input type="text" style="font-size:22px;width:40;height:30px;" maxlength="2" id="hoursInput"
	           onfocus="top.resetOSDInfoTimer(10);" />
	</div>
	
	<div style="left:333; top:130;width:40;height:28; position:absolute">
	    <input type="text" style="font-size:22px;width:40;height:30px;" maxlength="2" id="minutesInput"
	           onfocus="top.resetOSDInfoTimer(10);" />
	</div>
	
	<%--yes--%>
	 
	<div  style="position: absolute;left: 85px;top:220px;width:139px;height:39px;color: white;font-size:20px;line-height: 39px;text-align: center;">
        <img id="ok_key" src="images/vod/btv-02-add-bookmarkc.png" width="174" height="38" />
	</div> 
		   
	<div  style="position: absolute;left: 290px;top:220px;width:139px;height:39px; color: white;font-size:20px;line-height: 39px;text-align: center;">
        <img id="cancel_key" src="images/vod/btv-02-add-bookmarkquit.png" width="174" height="38" />
	</div>

    <div  style="position: absolute;left: 100px;top:220px;width:139px;height:39px; color: white;font-size:20px;line-height: 39px;text-align: center;">
        确认
    </div>

    <div  style="position: absolute;left: 305px;top:220px;width:139px;height:39px; color: white;font-size:20px;line-height: 39px;text-align: center;">
        取消
    </div>
</div>


<div id="error_show" style="position: absolute;left: 395px;top:175px;width: 493px;height: 286px;">
	<div style=" left:80px; top:180px;width:330px;height:20px; position:absolute;font-size:22px;color:#FFFFFF;" align="center" id="errorDiv">
	</div>
	 <%--<div  style="position: absolute;left: 120px;top:230px;width:300px;height:39px;color: white;font-size: 20px;">--%>
	   <%--2秒钟后自动返回--%>
	 <%--</div>--%>
</div>     

<script language="javascript">
function pageDoSeek()
{
    if (top.currState == 1 || top.currState == 7 || top.currState == 8 || top.currState == 10)
    {
        pageDoVodSeek();
    }

    else if (top.currState == 2)
    {
        pageDoLiveSeek();
    }
}

function getNumFromInput(textInput)
{
    var num = -1;
    if (textInput == "")
    {
        num = 0;
    }
    else
    {
        for (var i = 0; i < textInput.length; i++)
        {
            if (textInput.charAt(i) < "0" || textInput.charAt(i) > "9")
            {
                num = -1;
                return num;
            }
        }
        num = parseInt(textInput, 10);
    }
    return num;
}

function pageDoLiveSeek()
{
    var hoursInput = document.getElementById("hoursInput").value;
    var minutesInput =document.getElementById("minutesInput").value;
    if (hoursInput == "" && minutesInput == "")
    {
    	showMessage();
        return;
    }
    var targetHours = getNumFromInput(hoursInput);
    if (targetHours == -1 || targetHours >= 24)
    {
    	showMessage();
        return;
    }

    var targetMinutes = getNumFromInput(minutesInput);
    if (targetMinutes == -1 || targetMinutes >= 60)
    {
    	showMessage();
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
        if (TSBeginTimeM <= inputTimeM && inputTimeM <= TSEndTimeM)
        {
            inputTime.setTime(inputTime.getTime() + inputTime.getTimezoneOffset() * 60 * 1000);
            var year = inputTime.getFullYear() + "";
            var month = top.formatStr(inputTime.getMonth() + 1);
            var day = top.formatStr(inputTime.getDate());
            targetHours = top.formatStr(inputTime.getHours());
            targetMinutes = top.formatStr(inputTime.getMinutes());
            targetDate = year + month + day + "T" + targetHours + targetMinutes + "00Z";
            top.mp.playByTime(2, targetDate, 1);
            pageDisableWithTimer();
        }
        else
        {
        	showMessage();
            top.getTSTVTime();
            var beginTime = top.TSTVBeginTime;
            var endTime = top.TSTVEndTime;
            var beginTimeHour = top.formatStr(beginTime.getHours());
            var beginTimeMin = top.formatStr(beginTime.getMinutes());
            var beginHourMin = beginTimeHour + ":" + beginTimeMin;
            var endTimeHour = top.formatStr(endTime.getHours());
            var endTimeMin = top.formatStr(endTime.getMinutes());
            var endTimeHourMin = endTimeHour + ":" + endTimeMin;
            document.getElementById("infoDiv").innerHTML ="<%=W_FROM%> " + beginHourMin + " <%=W_TO%> " + endTimeHourMin;
        }
    }
}

function pageDoVodSeek()
{
    var hours = document.getElementById("hoursInput").value;
    var minutes = document.getElementById("minutesInput").value;
    var hoursInt = 0;
    var minutesInt = 0;
    if (hours.length == 2)
    {
        var tem = hours.substring(0, 1);
        if (tem == "0")
        {
            hoursInt = parseInt(hours.substring(1, 2));
        }
        else
        {
            hoursInt = parseInt(hours);
        }
    }
    else if (hours.length == 1)
    {
        hoursInt = parseInt(hours);
    }

    else if (hours.length == 0)
    {
        hoursInt = 0;
    }

    if (minutes.length == 2)
    {
        var temp = minutes.substring(0, 1);
        if (temp == "0")
        {
            minutesInt = parseInt(minutes.substring(1, 2));
        }

        else
        {
            minutesInt = parseInt(minutes);
        }
    }

    else if (minutes.length == 1)
    {
        minutesInt = parseInt(minutes);
    }
    else if (minutes.length == 0)
    {
        minutesInt = 0;
    }

    var duration = parseInt(top.mp.getMediaDuration());
    if (isNaN(hours) || isNaN(minutes) || ((hours == "") && (minutes == "")))
    {
    	showMessage();
        return;
    }

    var inputTime = hoursInt * 3600 + minutesInt * 60;
    if (inputTime >= 0 && inputTime <= duration)
    {
        top.mp.playByTime(1, inputTime, 1);
        pageDisableWithTimer();
    }
    else
    {
    	showMessage();
    }
}

function pageDisableWithTimer()
{
    top.jsHideOSD();
}

function pageLocation()
{
    pageDisableWithTimer();
}

function pageInit()
{
    if (top.currState == 1 || top.currState == 7 || top.currState == 8 || top.currState == 10)
    {
        var duration = top.mp.getMediaDuration();
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
        document.getElementById("infoDiv").innerHTML =  "<%=W_FROM%> " + "00:00" + " <%=W_TO%> " + StrVODTotalHours + ":" + VODTotalMinutes;

    }
    else if (top.currState == 2)
    {
        top.getTSTVTime();
        var beginTime = top.TSTVBeginTime;
        var endTime = top.TSTVEndTime;
        var beginTimeHour = top.formatStr(beginTime.getHours());
        var beginTimeMin = top.formatStr(beginTime.getMinutes());
        var beginHourMin = beginTimeHour + ":" + beginTimeMin;
        var endTimeHour = top.formatStr(endTime.getHours());
        var endTimeMin = top.formatStr(endTime.getMinutes());
        var endTimeHourMin = endTimeHour + ":" + endTimeMin;
        document.getElementById("infoDiv").innerHTML =  "<%=W_FROM%> " + beginHourMin + " <%=W_TO%> " + endTimeHourMin;
    }
}


</script>
</body>

</html>

