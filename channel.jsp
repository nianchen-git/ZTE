<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ include file="inc/words.jsp" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%!
    public String getDateInfo(int direct, int timePrev, int timeNext) {
        String dateObject = "";
        int num = timePrev + 1 + timeNext;
        String[] dateObjectArr = new String[num];
        String resultText = "";
        try {
            Calendar today = Calendar.getInstance();
            today.add(Calendar.DATE, -timePrev);
            String year = "";
            String month = "";
            String day = "";
            String date = "";
            String weekDay = "";
            String[] param = {"Date", "WeekDay", "Month", "Day"};
            String[] value = {"", "", "", ""};
            for (int i = 0; i < num; i++) {
                if (i != 0) {
                    today.add(Calendar.DATE, 1);
                }
                year = today.get(Calendar.YEAR) + "";
                month = (today.get(Calendar.MONTH) + 1) + "";
                day = today.get(Calendar.DATE) + "";
                date = castNum(year) + "." + castNum(month) + "." + castNum(day);
                weekDay = today.get(Calendar.DAY_OF_WEEK) + "";
                value = new String[]{date, weekDay, month, day};
                dateObject = getJsonObject(param, value);
                dateObjectArr[i] = dateObject;
            }
            resultText = getJsonArray(dateObjectArr);
        } catch (Exception e) {
            //System.out.println(e);
        }
        return resultText;
    }

    public String getJsonObject(String[] param, String[] value) {
        String result = null;
        try {
            if (param != null && value != null && param.length == value.length) {
                result = "{";
                for (int i = 0; i < param.length; i++) {
                    if (param[i] != "ProgramList") {
                        value[i] = value[i].replaceAll("\"", "\\\\\"");
                        result += param[i] + ":" + "\"" + value[i] + "\"";
                    } else {
                        result += param[i] + ":" + value[i];
                    }
                    if (i != param.length - 1) {
                        result += ",";
                    }
                }
                result += "}";
            }
        } catch (Exception e) {

        }
        return result;
    }

    public String getJsonArray(String[] jsonObjectArr) {
        String result = null;
        if (jsonObjectArr != null) {
            result = "[";
            for (int i = 0; i < jsonObjectArr.length; i++) {
                result += jsonObjectArr[i];
                if (i != jsonObjectArr.length - 1) {
                    result += ",";
                }
            }
            result += "]";
        }
        return result;
    }

    public String castNum(String str) {
        String temp = str;
        Integer intTemp = 0;
        try {
            intTemp = Integer.parseInt(str);
            if (intTemp < 10) {
                temp = "0" + intTemp;
            } else {
                temp = "" + intTemp;
            }
        } catch (Exception e) {
            intTemp = 0;
            temp = "01";
        }
        return temp;
    }
    public ArrayList getCancelPara(String param) {
          ArrayList al = new ArrayList();

               String[] pa = param.split(":");
               for(int i = 0;i < pa.length ;i++)
               {
                   al.add(pa[i]);
               }

        return al;
    }
%>

<%
    String isnewopen = request.getParameter("isnewopen");

    if((isnewopen!=null && isnewopen.equals("1")) || (isnewopen!=null && isnewopen.equals("2"))){
        System.out.println("SSSSSSSSSSSSSSSSSSSSSSmeiyouyazhan!!!!");
%>

<%
}else{
%>
<epg:PageController name="channel.jsp"/>
<%
    }
%>
<%
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap paramete = PortalUtils.getParams(path, "UTF-8");

    String channelAllColumnId = String.valueOf(paramete.get("column00"));     //含有所有频道所在的子栏目id
    int timeprev = 5;
    int timenext = 5;
    try{
        timeprev = Integer.valueOf(String.valueOf(paramete.get("timeprev")));     //channel
    }catch(Exception e){
    }
    try{
        timenext = Integer.valueOf(String.valueOf(paramete.get("timenext")));     //channel
    }catch(Exception e){

    }
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);


    ArrayList focusarray = null;
    String curDayIndex = "-1";
    String timeStart = "-1";
    String lastrow = "0";
    String lastcol = "0";
    int timePrev = timeprev;
    int nowHour = 0;
         timeStart = String.valueOf(nowHour);
         Date nowDate = new Date();                         //取当前小时数做数据请求
         nowHour = nowDate.getHours();
 int channel_curPage = 0;
    int isFocus = 0;
    String focusString =  request.getParameter("lastfocus");
    if(focusString != null){
        isFocus = 1;
        String[] focusArr = focusString.split(":");
        timePrev = Integer.parseInt(focusArr[0]);
        nowHour = Integer.parseInt(focusArr[1]);
        channel_curPage = Integer.parseInt(focusArr[2]);
        lastrow = focusArr[3];
        lastcol = focusArr[4];
    }
    Integer.valueOf(String.valueOf(curDayIndex));


    String imagesPath = "images";
    String lockPwd = "1";
    String dateInfo = getDateInfo(1, timeprev, timenext);
    int userLevel = userInfo.getLevelvalue();


    int programWidth = 882;
%>
<html>
<head>
   
    <meta name="page-view-size" content="1280*720"/>
    <title>无标题文档</title>
    <style>
        .channelMinxo {
            color: #000000;
            left: 61px;
            width: 47px;
            height: 34px;
            z-index: 2;
            font-size: 22;
        }

        .markUrl {
            left: 108px;
            width: 41px;
            height: 30px;
            z-index: 2;
        }

        .channel_col {
            /*top:0px;*/
            width:1px;
            height:48px;
            /*float:left;*/
            line-height:48px;
            /*overflow:hidden;*/
            /*background-image:url('images/tv_guide/programline.png');*/
            border-right:1px solid #CCCCCC;
            /*background-repeat:no-repeat;*/
            visibility:hidden;
            position:absolute;
        }

        .channelName {
            color: #000000;
            left: 151px;
            width: 140px;
            height: 34px;
            font-size: 22px;
            white-space: nowrap;
            z-index: 2;
        }

        .CurTimeStyle{
            /*border:1px solid red;*/
            font-weight: bold;
        }

        .CurTimeStyle1{
            border:1px solid white;
        }
    </style>
</head>

<body bgcolor="transparent" style="color:#ffffff" >
<div style="position:absolute;left:-50px;visibility:hidden"><a href="#">a</a></div>

<div style=" left:0; top:0px; width:1280px; height:720px; position:absolute; ">
    <img src="images/mytv/btv_bg_daoshi.png" width="1280" height="720"/>
</div>
<%--<div style="border:1px solid red; left:313; top:200px; width:880px; height:20px; position:absolute; ">--%>
<%--</div>--%>

<%@ include file="inc/time.jsp" %>
<div class="topImg" style="font-size:20px;top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/channel/btv-mytv-ico.png'); left:13; top:8px; width:37px; height:35px; position:absolute; ">
    </div>
    <div align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
        订制空间  > 节目导视
    </div>
</div>

<%
    for(int i=0; i<10; i++){
        int top = 149+48*i;
%>
<div id="mixNo_<%=i%>" style=" font-weight: bolder; line-height:48px; position:absolute;width:40px;height:48px;z-index:3;left:92px;top:<%=top%>px;font-size:22px;"></div>
<div id="channelName_<%=i%>" style=" font-weight: bolder; line-height:48px; position:absolute;width:170px;height:48px;z-index:3;left:142px;top:<%=top%>px;font-size:22px;"></div>
<%
    }
%>

<div id="Layer3" style="position:absolute;width:880px;height:344px;z-index:3;left:314px;top:149px;font-size:22px;">
    <%
      for(int i=0; i<10; i++){
          int top = 48*i;
    %>
        <div id="Layer_<%=i%>" style=" position:absolute;width:880px;height:48px;top:<%=top%>px;left:0px;">
    <%
          for(int j=0; j<8; j++){
            if(j == 0){
            %>
            <div id="td<%=i%><%=j%>" align="center" class="channel_col" style="border-left:1px solid #CCCCCC;" ></div>
            <%
            }else{
            %>
            <div id="td<%=i%><%=j%>" align="center" class="channel_col"></div>
            <%
            }
          }
    %>
        </div>
    <%
      }
    %>
</div>

<%
    for(int i=0; i<10; i++){
        int top = 149+48*i;
%>
<div id="programFocusImg_<%=i%>" style="  position:absolute; left: 83px; top: <%=top%>px; width: 1114px; height: 49px;  visibility: hidden;">
    <img src="images/mytv/TVprogram_redline.png" width="1114" height="49" />
</div>
<%
    }
%>


<div id="curTime" class="CurTimeStyle" align="center" style="  position:absolute;left:67px;top:110px;width:225px;height:21px;font-size:25px;"></div>

<div align="left" id="timeFirst" class="CurTimeStyle"
     style=" position:absolute;left:260px;top:97px;width:82px;height:39px;font-size:25px;padding-left:20px; padding-top:10px">
</div>
<div align="left" id="timeSecond" class="CurTimeStyle"
     style=" position:absolute;left:480px;top:97px;width:62px;height:42px;font-size:25px;background-image:url('images/tv_guide/programline.png');background-repeat:no-repeat; padding-left:20px;padding-top:10px">
</div>
<div align="left" id="timeThird" class="CurTimeStyle"
     style=" position:absolute;left:701px;top:97px;width:62px;height:42px;font-size:25px;background-image:url('images/tv_guide/programline.png');background-repeat:no-repeat; padding-left:20px;padding-top:10px">
</div>
<div align="left" id="timeFourth" class="CurTimeStyle"
     style=" position:absolute;left:921px;top:97px;width:62px;height:41px;font-size:25px;background-image:url('images/tv_guide/programline.png');background-repeat:no-repeat; padding-left:20px;padding-top:10px">
</div>

<%---------------------------%>
<div align="left"  class="CurTimeStyle1"
     style=" position:absolute;left:313px;top:136px;width:0px;height:5px;">
</div>
<div align="left"  class="CurTimeStyle1"
     style=" position:absolute;left:533px;top:136px;width:0px;height:5px;">
</div>
<div align="left" class="CurTimeStyle1"
     style=" position:absolute;left:754px;top:136px;width:0px;height:5px;">
</div>
<div align="left" class="CurTimeStyle1"
     style=" position:absolute;left:974px;top:136px;width:0px;height:5px;">
</div>

<%--<div id="channelFocusImg"--%>
     <%--style="position:absolute;left:64px;top:305px;width:226px;height:40px;z-index:1;visibility:hidden;">--%>
<%--</div>--%>

<%--<div id="time_line" style="border:1px solid red; position:absolute; left: 300px; top: 291px; width: 4px; height: 348px; background-image:url(images/tv_guide/time_line.png);visibility:hidden;z-index:4;">--%>
<%--</div>--%>
<%--<div id="time_plant" style="border:1px solid red; position:absolute; left: 300px; top: 292px; width: 292px; height: 348px;background-image:url(images/mytv/bg_black.png); z-index:4; visibility:hidden">--%>
<%--</div>--%>

<div id="time_plant" style=" left:314px;top:149px;width:880px;height:480px; background-image:url(images/mytv/bg_black.png); position:absolute; z-index: 10;">
    <%--<img id="bg_img_0" src="images/mytv/bg_black.png" width="880" height="480" />--%>
</div>
<div id="time_line" style=" visibility:hidden; width:16px; height:532px; left:313; top:96; width:16px; height:532px; position:absolute; z-index: 10;">
    <img src="images/mytv/tvguide-vertical_red.png" width="16" height="540" />
</div>

<div id="showpage" style=" border:1px solid red; visibility: hidden; left:1064px;top:61px;width:155px;height:34px;z-index:6;font-size:29px;color:#ffffff; position:absolute;"  align="center">
</div>

<div id="msg" style="left:416px; top:289px;width:568px;height:262px; position:absolute;visibility:hidden;z-index:15">
    <div style="left:0px;top:0px;width:568px;height:262px;position:absolute;">
        <img src="images/vod/btv_promptbg.png" alt="" width="568" height="262" border="0"/>
    </div>

    <div id="text"  style="left:30px;top:100px;width:500px;height:34px;font-size:22px;color:#FFFFFF;position:absolute; " align="center">
    </div>
    <div id="closeMsg" style=" left:0px;top:200px;width:568px;height:34px; font-size:22px;color:#FFFFFF;position:absolute;" align="center">
        2秒自动关闭
    </div>
</div>

<div align="center"  style="font-size:22px; color:#ffffff; line-height:31px;  position:absolute; width:1280px; height:35px; left:0px; top:640px;">
    <div style="color:#424242;   position:absolute; width:60px; height:31px; left:466px; top:0px;">
        上页
    </div>
    <div style="position:absolute; width:70px; height:31px; left:556px; top:0px;" align="center">
        上一页
    </div>
    <div style="color:#424242;   position:absolute; width:60px; height:31px; left:677px; top:0px;">
        下页
    </div>
    <div style="position:absolute; width:70px; height:31px; left:767px; top:0px;" align="center">
        下一页
    </div>
   <!-- <div style="position:absolute; width:120px; height:31px; left:967px; top:0px;">
        直播提醒
    </div>-->
    <div style="position:absolute; width:120px; height:31px; left:967px; top:0px;">
        搜索
    </div>
</div>

</body>
<%@include file="inc/getFitString.jsp" %>
<script>
    var _window_frame = window;
    if(window.opener){
        _window_frame = window.opener;
    }
    var channel_pageNum = 10;        //页频道展示数据量
    var curChannelPos = "<%=lastrow%>";          //行焦点
    var curChannelcols = "<%=lastcol%>";         //列焦点
    var dateInfo = eval('<%=dateInfo%>');
    var curDayIndex = <%=timePrev%>;
    var curdate = dateInfo[curDayIndex].Date;
    var channelTotal = 0;
    var channel_curPageSize = 0;                               //页数据量
    var channel_curPage ="<%=channel_curPage%>";                                     //当前页码
    var channel_pageAll = 0;                                    //数据总页数
    var channelDataObject;                                     //节目数据存储对象
    var curChannelIndex = 0;
    var progTableObj;                                           //节目单列表绘制对象
    var timeStart = "<%=timeStart%>";
    var chanStartIndex = 0;
//    var curColumnIndex = 0;
//    var lastColumnIndex = curColumnIndex;             //记录前一次切换栏目时的位置，用于为切换栏目时不刷新数据
    var curColumnId = '<%=channelAllColumnId%>';
//    var allColumnId = new Array();
//    var allColumnName = new Array();
    var focusTimeOut = "";//定时器对象
    var chanNameTimeOut = "";//定时器对象
    var channelDataObject = "";             //记录数据对象
    var doOther = 1;                     //记录当前的操作状态，1：tv guide  2：add Npvr 3：add remind   4:栏目切换  5:收藏   6 :展示操作请求返回结果，屏蔽其他操作 7:pip播放展示童锁  上下可切换焦点， 8、向右切换到童锁框，捕获焦点
    var currentMixno = "";               //记录当前的焦点的混排号
    <%--var userLevel = "<%=userLevel%>";               //获取用户级别--%>
    var isGetingData = 0;               //1：正在取数据  0 是未取数据
    var isformTV = "";
    var now_minutes = 0;                  //当前时间秒数
    var isRefreshData = 0;                  //是否页内刷能数据
    var joinResult = 0;
//    var pipNum = "";                         //记录焦点所在频道的PIP混排号
    var lineTimeout;                        //时间轴刷新对象
    var programAreaLeft = 314;
    var programWidth = <%=programWidth%>
    var nowHour = "<%=nowHour%>";           //获取当前小时
    var isFocus = "<%=isFocus%>"; 
    var $$ = {};

    function $(id) {
        if (!$$[id]) {
            $$[id] = document.getElementById(id);
        }
        return $$[id];
    }

    function unload(){
        hidenMessage();
        if(channel_pageAll > 0)
        {
            progTableObj._loseFocus();
        }
    }

    function addZeroChannel(number) {
        if(number == -1){
            return "";
        }
        var showNo = parseInt(number,10);
        if (showNo < 10) {
            showNo = "00" + showNo;
        } else if (showNo >= 10 && showNo < 100) {
            showNo = "0" + showNo;
        }
        return showNo;
    }

var turnPageAction = "init";

function clearAllTimer(){
    window.clearTimeout(focusTimeOut);
    window.clearTimeout(chanNameTimeOut);
    window.clearTimeout(lineTimeout);
}

function dokeypress(evt){
    var keyCode = evt.which;
   
    clearAllTimer();
    if (keyCode == <%=STBKeysNew.remoteBack%> || keyCode == 24){
        doBack();
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyOK%>){
        if(channel_pageAll > 0){
            doOK();
        }
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyRed%>){
        if(channel_pageAll > 0){
            addRemind();
        }
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyUp%>){
        if(channel_pageAll > 0){
            doUp();
        }
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyDown%>){
        if(channel_pageAll > 0){
            doDown();
        }
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyRight%>){
        turnPageAction="right";
        doRight();
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyLeft%>){
        turnPageAction="left";
        doLeft();
        return false;
    }else if (keyCode == <%=STBKeysNew.onKeyBlue%>){
        turnPageAction="doBlue";
        doBlue();
        return false;
    }else if (keyCode == <%=STBKeysNew.remotePlayLast%>){
        if(channel_pageAll > 0){
            turnPageAction="prePage";
            doPrevPage();
        }
        return false;
    }else if (keyCode == <%=STBKeysNew.remotePlayNext%>){
        if(channel_pageAll > 0){
            turnPageAction="nextPage";
            doNextPage();
        }
        return false;
    }else if (keyCode == 280){
        if(inputIsFocus == 0){

        }else{
            _window_frame.top.mainWin.commonKeyPress(evt);
        }
        return false;
    } else {
        _window_frame.top.mainWin.commonKeyPress(evt);
        return true;
    }
}
document.onkeypress = dokeypress;
</script>

<%--<%@ include file="inc/TVGuidetime.jsp" %>--%>
<%--<script src="js/timeformat_frame.js"></script>--%>
<%
    String isAjaxCache = String.valueOf(paramete.get("isAjaxCache"));
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
<%--<script type="text/javascript" src="js/chan_func.js"></script>--%>
<%--<script type="text/javascript" src="js/chan_func_forshow.js"></script>--%>
<script>
<%@ include file="js/chan_func.js" %>
<%@ include file="js/chan_func_forshow.js" %>

var isDelay = true;
function getChannnelColumn() {
    isGetingData = 1;
    var _curChannel_last;
    _curChannel_last = _window_frame.top.channelInfo.currentChannel;
  if(_curChannel_last == undefined || _curChannel_last == -1 )
        _curChannel_last = _window_frame. top.channelInfo.lastChannel;
    loadTVGuideData(1, curColumnId, curdate, getformartStarttime(nowHour), _curChannel_last);
}

function clearPage(){}


function showaddRemind(dellflag) {
    var timer;
    if (dellflag == 0) {
        $("text").innerText = "提醒成功";
        $("msg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
        _window_frame.top.remindWin.document.location = "loadRemindList.jsp";
    } else {
        $("text").innerText = "提醒失败";
        $("msg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
    }
}

function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
}

function comSecond(){
    turnPageAction = "init";
    currentMixno =-1;

    isDelay = false;
    if(progTableObj){
        progTableObj.focusFrom = 'init';
    }
    var _curChannel_last = _window_frame.top.channelInfo.currentChannel;
 if(_curChannel_last == undefined || _curChannel_last == -1 )
        _curChannel_last = _window_frame. top.channelInfo.lastChannel;
    var _rowid = -1;
    if(channel_pageAll > 0)
    {
        progTableObj._loseFocus();        
    }
    curDayIndex = <%=timeprev%>;
    curdate = dateInfo[curDayIndex].Date;

    loadTVGuideData(1, curColumnId, curdate, getformartStarttime(nowHour), _curChannel_last);
}




getChannnelColumn();

</script>

<%@ include file="inc/lastfocus.jsp" %>
</html>
