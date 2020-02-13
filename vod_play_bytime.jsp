<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page contentType="text/html; charset=UTF-8" %>
<%--<%@ include file="inc/words.jsp" %>--%>
<%--<%@include file="inc/changeskin.jsp" %>--%>
<epg:PageController/>
<html>
<head>
    <title>vod_play_bytime.jsp</title>
    <script language="javascript" type="">
//        iPanel.focusWidth = "0";

        function changeImg(name1, name2)
        {
            document.getElementById(name1).src = "url('images/vod/btv-02-add-bookmarkc.png')";
            document.getElementById(name2).src = "url('images/vod/btv-02-add-bookmarkquit.png')";
        }
        function disableNumKey() {
            top.jsSetupKeyFunction("top.mainWin.donothing", 280);
            for (var j = 0; j < 10; j++) {
                top.keyFuncArray[top.keyCodeArray["onKeyNumChar"] + j] = "donothing";
            }
        }
        function hourFocus(){
            document.getElementById("ok_key").src = "url('images/vod/btv-02-add-bookmarkquit.png')";
            document.getElementById("cancel_key").src = "url('images/vod/btv-02-add-bookmarkquit.png')";
        }

        function enableNumKey() {
            top.resetOSDInfoTimer(10);
            top.jsEnableNumKey();
        }
    </script>
</head>

<%
    String W_MSG = "输入的时间错误,请重新输入!";
    String W_FROM = "从";
    String W_TO = "到";

%>
<body bgcolor="transparent" onload="pageInit();">
<div style="left:370px; top:225px;width:493px;height:268; position:absolute" align="center">
    <%--yes--%>

    <div style="left:222px; top:260px;width:100px;height:25px; position:absolute;">
        <a id="yesButton" href="javascript:pageDoSeek();"
           onfocus="changeImg('ok_key', 'cancel_key');"
           onblur="changeImg('cancel_key', 'ok_key');">
            <img alt="" width="1" height="1" border="0" src="images/btn_trans.gif"/>
        </a>
    </div>
    <%--no--%>

    <div style="left:300px; top:260;width:100px;height:25px; position:absolute">
        <a id="nobutton" href="javascript:pageDisableWithTimer()"
           onfocus="changeImg('cancel_key', 'ok_key');"
           onblur="changeImg('ok_key', 'cancle');">
            <img alt="" width="1" height="1" border="0" src="images/btn_trans.gif"/>
        </a>
    </div>
    <div style="left:30px; top:0px;width:493px;height:268; position:absolute" align="center">
        <img width="493" height="268" src="images/vod/btv_promptbg.png" alt=""/>
    </div>
    <div style="left:112px; top:94px;width:130;height:25;font-size:22px; position:absolute">
        <font color="#ffffff">定位到
      </font>
  </div>

    <div style="left:268px; top:94px;width:30;height:25;font-size:20px; position:absolute">
        <font color="#ffffff">时
      </font>
  </div>

    <div style="left:360px; top:94px;width:30;height:25;font-size:20px; position:absolute">
        <font color="#ffffff">分
      </font>
  </div>

    <div style="left:222px; top:91px;width:40;height:28; position:absolute">
        <input type="text" style="font-size:22px; width:40;height:30px" maxlength="2" id="hoursInput"
               onfocus="disableNumKey();hourFocus()" onblur="enableNumKey();"  />
  </div>

    <div style="left:315px; top:91px;width:40;height:28px; position:absolute">
        <input type="text" style="font-size:22px; width:40;height:30px" maxlength="2" id="minutesInput"
               onfocus="disableNumKey();" onblur="enableNumKey();"  />
  </div>

    

        <div style="position: absolute;left: 95px;top:205px;width:174px;height:37px;color: white;font-size:20px;line-height: 39px;text-align: center;">
            <img id="ok_key" src="images/vod/btv-02-add-bookmarkc.png" width="174" height="38" />
        </div>

        <div style="position: absolute;left: 290px;top:205px;width:174px;height:37px; color: white;font-size:20px;line-height: 39px;text-align: center;">
            <img id="cancel_key" src="images/vod/btv-02-add-bookmarkquit.png" width="174" height="38" />
        </div>

        <div  style="position: absolute;left: 95px;top:205px;width:174px;height:38px; color: white;font-size:20px;line-height: 39px;text-align: center;">
            确认
        </div>

        <div  style="position: absolute;left: 290px;top:205px;width:174px;height:38px; color: white;font-size:20px;line-height: 39px;text-align: center;">
            取消
        </div>

    <div align="center" style=" left:100px; top:135px;width:347px;height:20; position:absolute;font-size:22px;color:#FFFFFF;" id="errorDiv">
    </div>
    <div style="left:80px;top:50px;width:300;height:20;position:absolute;font-size:22px;color:#FFFFFF;" id="infoDiv" align="center">
    </div>
</div>

<div style="left:78%; top:7%; width:90; height:100; position:fixed" id="channelNumber" >
</div>
<script language="javascript">

function cateKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0025) { //onKeyRight
        //alert("SSSSSSSSSSSSSSSSSkeyCode="+keyCode);
        var srcStr = document.getElementById("ok_key").src;
        if(srcStr.indexOf("images/vod/btv-02-add-bookmarkc.png")>-1){
            return false;
        }else{
            return true;
        }
    }else if (keyCode == 0x000D) {  //OK
        var okStr = document.getElementById("ok_key").src;
        var cancelStr = document.getElementById("cancel_key").src;
        if(okStr.indexOf("images/vod/btv-02-add-bookmarkc.png")==-1 && cancelStr.indexOf("images/vod/btv-02-add-bookmarkc.png")==-1){
            pageDoSeek();
        }else{
            return true;
        }
        return true;
    }
    else {
        top.doKeyPress(evt);
        return true;
    }
    return false;
}

document.onkeypress = cateKeyPress;

//document.getElementById("yesButton").focus();

document.getElementById("hoursInput").focus();

function pageDoSeek(){
    if (top.currState == 1 || top.currState == 7 || top.currState == 8 || top.currState == 10){
        pageDoVodSeek();
    }else if (top.currState == 2){
        pageDoLiveSeek();
    }
}


function getNumFromInput(textInput){
    var num = -1;

    if (textInput == ""){
         num = 0;
    }else{
        for (var i = 0; i < textInput.length; i++){
            if (textInput.charAt(i) < "0" || textInput.charAt(i) > "9"){
                num = -1;
                return num;
            }
        }
        num = parseInt(textInput, 10);
    }
    return num;
}


function pageDoLiveSeek(){
    var hoursInput = top.mainWin.document.all.hoursInput.value;
    var minutesInput = top.mainWin.document.all.minutesInput.value;
    if (hoursInput == "" && minutesInput == ""){
        top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
        return;
    }

    var targetHours = getNumFromInput(hoursInput);
    if (targetHours == -1 || targetHours >= 24){
        top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
        return;
    }

    var targetMinutes = getNumFromInput(minutesInput);

    if (targetMinutes == -1 || targetMinutes >= 60){
        top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
        return;
    }

    //    top.jsDebug("input hours = " + targetHours + " and input minutes = " + targetMinutes);
    if (top.currState == 2){

        //20081013T191625.56Z-20081014T101625.56Z
        var targetDate = "";
        var inputTime = new Date();
        inputTime.setHours(parseInt(targetHours));
        inputTime.setMinutes(parseInt(targetMinutes));
        top.getTSTVTime();
        var beginHourInt = top.TSTVBeginTime.getHours();
        var endHourInt = top.TSTVEndTime.getHours();
        if (beginHourInt > endHourInt && targetHours > endHourInt){
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
            pageDisableWithTimer();
        }else{
            top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
            top.getTSTVTime();
            var beginTime = top.TSTVBeginTime;
            var endTime = top.TSTVEndTime;
            var beginTimeHour = top.formatStr(beginTime.getHours());
            var beginTimeMin = top.formatStr(beginTime.getMinutes());
            var beginHourMin = beginTimeHour + ":" + beginTimeMin;
            var endTimeHour = top.formatStr(endTime.getHours());
            var endTimeMin = top.formatStr(endTime.getMinutes());
            var endTimeHourMin = endTimeHour + ":" + endTimeMin;
            top.mainWin.document.all.infoDiv.innerHTML ='<%=W_FROM%>'+" " + beginHourMin + " "+'<%=W_TO%>'+" " + endTimeHourMin;
        }
    }
}


function pageDoVodSeek(){
    var hours = top.mainWin.document.all.hoursInput.value;
    var minutes = top.mainWin.document.all.minutesInput.value;
    var hoursInt = 0;
    var minutesInt = 0;
    if (hours.length == 2){
        var tem = hours.substring(0, 1);
        if (tem == "0"){
            hoursInt = parseInt(hours.substring(1, 2));
        }else{
            hoursInt = parseInt(hours);
        }
    }else if (hours.length == 1){
        hoursInt = parseInt(hours);
    }else if (hours.length == 0){
            hoursInt = 0;
    }


    if (minutes.length == 2){
        var temp = minutes.substring(0, 1);
        if (temp == "0"){
            minutesInt = parseInt(minutes.substring(1, 2));
        }else{
            minutesInt = parseInt(minutes);
        }
    }else if (minutes.length == 1){
        minutesInt = parseInt(minutes);
    }else if (minutes.length == 0){
            minutesInt = 0;
    }
    var duration = parseInt(top.mp.getMediaDuration());

    if (isNaN(hours) || isNaN(minutes) || ((hours == "") && (minutes == ""))){
        top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
        return;
    }


    var inputTime = hoursInt * 3600 + minutesInt * 60;
    if (inputTime >= 0 && inputTime <= duration){
        top.mp.playByTime(1, inputTime, 1);
        pageDisableWithTimer();
    }else{
        top.mainWin.document.all.errorDiv.innerHTML ="<%=W_MSG%>";
    }
}


function pageDisableWithTimer(){
    top.jsHideOSD();
}


function pageLocation(){
    pageDisableWithTimer();
}


function pageInit(){
    if (top.currState == 1 || top.currState == 7 || top.currState == 8 || top.currState == 10){
        var duration = top.mp.getMediaDuration();
        var VODTimeInfo = parseInt(duration);
        var VODTotalHours = VODTimeInfo / 3600 ;
        VODTotalHours = parseInt(VODTotalHours);
        if (("" + VODTotalHours).length == 1){
            VODTotalHours = "0" + VODTotalHours;
        }

        var StrVODTotalHours = VODTotalHours;
        VODTotalHours = parseInt(VODTotalHours, 10);
        var VODTotalMinutes = (VODTimeInfo - VODTotalHours * 3600) / 60;
        VODTotalMinutes = parseInt(VODTotalMinutes);
        if (("" + VODTotalMinutes).length == 1){
            VODTotalMinutes = "0" + VODTotalMinutes;
        }
        top.mainWin.document.all.infoDiv.innerHTML =  '<%=W_FROM%>'+" "+ "00:00" + " "+'<%=W_TO%>'+" " + StrVODTotalHours + ":" + VODTotalMinutes;
    }else if (top.currState == 2){
        top.getTSTVTime();
        var beginTime = top.TSTVBeginTime;
        var endTime = top.TSTVEndTime;
        var beginTimeHour = top.formatStr(beginTime.getHours());
        var beginTimeMin = top.formatStr(beginTime.getMinutes());
        var beginHourMin = beginTimeHour + ":" + beginTimeMin;
        var endTimeHour = top.formatStr(endTime.getHours());
        var endTimeMin = top.formatStr(endTime.getMinutes());
        var endTimeHourMin = endTimeHour + ":" + endTimeMin;
        top.mainWin.document.all.infoDiv.innerHTML =  '<%=W_FROM%>'+" " + beginHourMin + " "+'<%=W_TO%>'+" " + endTimeHourMin;
    }
    top.jsSetupKeyFunction("top.mainWin.pageDisableWithTimer", <%=STBKeysNew.remoteLocation%>);
    top.jsSetupKeyFunction("top.mainWin.pageDisableWithTimer", <%=STBKeysNew.remoteBack%>);
    window.setTimeout(function (){
        pressUp();
    },100);
}

//document.onkeypress = top.doKeyPress;

function pressDown(){
    document.getElementById("yesButton").focus();
}
top.jsSetupKeyFunction("top.mainWin.pressDown", 0x28);

function pressUp(){
    document.getElementById("hoursInput").focus();
}
top.jsSetupKeyFunction("top.mainWin.pressUp", 0x0026);

var FONTHEAD = "<font color='00FF00' size='8' ><h1>";
    var FONTTAIL = "</h1></font>";

    function showChannelNumber(channelNum)
    {
        if (channelNum != null && channelNum != undefined)
        {
            top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
    }

    function clearChannelNumber(){
        top.mainWin.document.all.channelNumber.innerHTML = "";
    }
</script>
</body>
</html>

