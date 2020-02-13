<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtility" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%--<%@ page import="com.zte.iptv.newepg.channel.Controller" %>--%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page isELIgnored="false" %>
<%--<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>--%>
<%--<%@ include file="inc/words.jsp" %>--%>
<%
    //[{prevuename=The Sixth Sense, begintime=2012.04.17 08:00:01, channelcode=0, isRemindNow=0, timeValue=0}]


    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "UTF-8");
    String showReminderTimerStr = String.valueOf(param.get("showReminderTimer"));
    //默认展示时间
    long showReminderTimer = 15000;
    try{
        showReminderTimer = Long.parseLong(showReminderTimerStr);
    }catch(Exception e){
        e.printStackTrace();
        System.out.println("show reminder timer delay!!");
    }

    String reminderWindowTopStr = String.valueOf(param.get("reminderWindowTop"));
    //默认展示时间
    long reminderWindowTop = 670;
    try{
        reminderWindowTop = Long.parseLong(reminderWindowTopStr);
    }catch(Exception e){
        e.printStackTrace();
        System.out.println("reminder window top index");
    }
//    showReminderTimer = showReminderTimer*1000;
    System.out.println("SSSSSSSSSSSSSSSSSSshowReminderTimer_reminderWindowTop="+showReminderTimer+"_"+reminderWindowTop);

    //开机时提醒的节目是包括正在播放的(1)，添加和删除时正在播放的节目就不再提醒了(0)
    String isReminderProgramPlay = "0";

    isReminderProgramPlay = request.getParameter("isReminderProgramPlay");
    if(isReminderProgramPlay == null || isReminderProgramPlay.equals("")){
        isReminderProgramPlay = "0";
    }

    //[{prevuename=The Sixth Sense, begintime=2012.04.17 08:00:01, channelcode=0, isRemindNow=0, timeValue=0}]
%>

<body bgcolor="transparent" ></body>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript">
    var showReminderTimer = parseInt('<%=showReminderTimer%>',10);

    function initRemindList(){
        url = "action/get_remindList.jsp?isReminderProgramPlay=<%=isReminderProgramPlay%>";
        new net.ContentLoader(url, function() {
		    data = eval("(" + this.req.responseText + ")");
          //  alert("SSSSSSSSSSSSSSSSdata.length="+data.length);
            if(data && data.length>0){
                 for(var i=0; i<data.length; i++){
                    //立即提醒
                    if(data[i].isRemindNow == "1"){
                     //   alert("SSSSSSSSSSSSSSliji");
                        showReminderProxy(data[i],"1");
                    }else{
                    //   alert("SSSSSSSSSSSSSSbulijidata[i].timeValue="+data[i].timeValue);
                       showReminderByTimer(data[i],"2");
                    }
                 }
            }
	    });
    }

//    var reminderList = new Array(10);
//    var reminderList = new Array(0);
//    if(reminderList &&reminderList.length>0){
//         for(var i=0; i<reminderList.length; i++){
//             var obj = {};
//             obj.begintime="2012.04.20";
//             obj.prevuename='YES'+i;
//             obj.timeValue=10000*i+3000;
//             showReminderByTimer(obj);
//         }
//    }

    /*
     *展示提醒延迟方法
     * type: 1 立即提醒 ，2：按timerValue时间提醒。
     */
    function showReminderByTimer(obj,type){
     //   alert("SSSSSSSSSSSSSSSSSSSSSSobj.timeValue="+obj.timeValue);
         if(type == 1){

         }
         setTimeout(function(){
             showReminderProxy(obj,type);
         },parseInt(obj.timeValue));
    }

    //展示提醒代理方法
    function showReminderProxy(remindObj,type){
        //alert("SSSSSSSSSSSSSSSSSSSSSSSSshowReminderProxySSSSSSS");
        for(var p in remindObj){
           // alert("SSSSSSSSSSSSSSSSSSSSSSSSshowReminderProxy_remindObj["+p+"]="+remindObj[p]);
        }
        var reminderWindow = window.getWindowByName("reminderWindow");
        if (typeof(reminderWindow) != "object") {
//            alert("1111111111111111111remindObj="+remindObj);
            reminderWindow = window.open('reminderWindow.jsp', 'reminderWindow', 'width=1280,height=50,top=<%=reminderWindowTop%>,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
            reminderWindow.setzindex(212);
            reminderWindow.show();
            setTimeout(function(){
                 showReminder(remindObj,type);
            },1200);
            if(top.mainWin._windowframe){
                top.mainWin._windowframe.setWindowFocus();
            }else{
                top.mainWin.setWindowFocus();
            }
        }else{
            reminderWindow.show();
            setTimeout(function(){
                 showReminder(remindObj,type);
            },1200);
//            reminderWindow.close();
            if(top.mainWin._windowframe){
                top.mainWin._windowframe.setWindowFocus();
            }else{
                top.mainWin.setWindowFocus();
            }
        }
    }

    /*
     *展示提醒方法
     * type: 1 立即提醒 ，2：按timerValue时间提醒。
     */

    var reminderTimer = null;
    function showReminder(remindObj,type){
      //  alert("SSSSSSSSSSSSshowReminderTimer1111=type="+type);
        var reminderWindow = window.getWindowByName("reminderWindow");
        //拼接字符串
        var reminderStr = "";
//        reminderStr = remindObj.begintime+"   "+remindObj.channelcode+"  "+remindObj.prevuename;
        if(type == '1'){
            <%--reminderStr = "<%=W_PROGRAM%> " +remindObj.prevuename+" <%=W_INCHANNEL%> " +remindObj.channelcode+ " <%=W_HASBEGIN%>";--%>
//            reminderStr =  "频道 " +remindObj.channelcode+ " 的节目 "+remindObj.prevuename+" 已经播放了";
            reminderStr =  "节目 "+remindObj.prevuename+" 已经播放了";
        }else if(type == '2'){
            <%--reminderStr = "<%=W_PROGRAM%> " +remindObj.prevuename+" <%=W_INCHANNEL%> " +remindObj.channelcode+ " <%=W_STARTAT%> "+remindObj.begintime;--%>
//            reminderStr =  "频道 " +remindObj.channelcode+ " 的节目 "+remindObj.prevuename+" 将在"+remindObj.begintime+"播放";
            reminderStr =  "节目 "+remindObj.prevuename+" 将在"+remindObj.begintime+"播放";
        }
        reminderWindow.showReminder(reminderStr);
      //  alert("SSSSSSSSSSSSshowReminderTimer="+showReminderTimer);
//        return;
        if(reminderTimer!=null){
            clearTimeout(reminderTimer);
        }

        reminderTimer = setTimeout(function(){
           // alert("close111!!!!");
            reminderWindow.close();
        },showReminderTimer);
    }

    if(isZTEBW == true){
        initRemindList();
    }

</script>