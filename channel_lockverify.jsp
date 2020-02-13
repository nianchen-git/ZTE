<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="java.util.*" %>
<%@page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ include file="inc/words.jsp" %>
<%
    String mixno = request.getParameter("channelnumber");
    UserInfo suserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String pwd = suserInfo.getUserLockPwd();
    String type = request.getParameter("type");
    String tvodurl = "";
    if ("tvod".equals(type)) {
        tvodurl = "channel_tvod_auth.jsp?" + request.getQueryString();
    }
   String isFromStartChannel="";
       if(request.getParameter("isFromStartChannel")!=null){
       isFromStartChannel=request.getParameter("isFromStartChannel");
       }
       if(isFromStartChannel.equals("true")) {

    %>
<epg:PageController />
    <% }else{ %>
<epg:PageController name="back.jsp" />
  <% }%>
<html>
<head>
    <title>Con</title>
    <epg:script/>
    <script type="text/javascript">
        var lockpwd = "<%=pwd%>";
        var mixno =<%=mixno%>;
        var type = "<%=type%>";
        function changeOneImgByName(imgName, imgPath) {
            document.images[imgName].src = imgPath;
        }

        function close() {
            document.getElementById("main").style.visibility = "visible";
            document.getElementById("error").style.visibility = "hidden";
             myform.pwd.focus();
        }
       function goBack(){
          top.channelInfo.currentChannel=-1;
           top.mainWin.document.location="back.jsp";
       }
        function confirmOk() {
//            if(document.myform.pwd.value == "") return;
            if(document.getElementById("error").style.visibility == "hidden") {
                var pwd = document.getElementById("pwd").value;
                if (pwd == lockpwd) {
                    if (type == "tvod") {
                        document.location = "<%=tvodurl%>";
                    } else {
                        var channelislock=top.jsGetControl("CHANNEL_ISINLOCK");
                        if(channelislock=="1"){
                             top.vodBackTimer=top.setTimeout("top.switchToStopOSDUrl(0)",1000);
                             top.jsSetControl("CHANNEL_ISINLOCK","0");
                        }
                        top.jsRedirectLockChannel(mixno);
                    }
                } else {
                    document.getElementById("main").style.visibility = "hidden";
                    document.getElementById("error").style.visibility = "visible";
                    setTimeout("close();",2000);
                }
            } else {
                document.getElementById("error").style.visibility = "hidden";
                document.location.reload();
            }
        }
    </script>
</head>
    <body bgcolor="transparent">
        <div align="center" style="left:0px; width:1270; top:165; position:absolute;">
            <img src="images/alert.png" width="700" height="305" border="0" alt="">
        </div>
        <div id="main" align="center" style="visibility:visible;top:180;width:1260; height:205;position:absolute; ">
            <div align="center" style="margin-top:50;color:#FFF; font-size:24;">
                <%--<%=W_LOCK_INPUT %>--%>
                «Î ‰»ÎÕØÀ¯√‹¬Î
            </div>
            <div style="margin-left:20; margin-top:40;color:#FFF; font-size:24;">
                <form name="myform" action="javascript:confirmOk();">
                   <input name="pwd" type="password" id="pwd"
                       style="width:250; margin:0; padding:0; height:25; font-size:12; color:#333">
                </form>
            </div>

            <!--  “Ï¥Œ‘™Õº?? -->
            <div  style="margin-top:10;  left:502px; top:225px; position:absolute;">
                <a href="javascript:confirmOk()" name="transaction1"
                   onfocus="changeOneImgByName('btn1','images/btn_confirm.png');"
                   onblur="changeOneImgByName('btn1','images/btn_trans.gif');">
                    <img src="images/btn_trans.gif" alt="" width="1" height="1" border="0">
                </a>
                <a href="javascript:goBack();" name="transaction2"
                   onfocus="changeOneImgByName('btn2','images/btn_confirm.png');"
                   onblur="changeOneImgByName('btn2','images/btn_trans.gif');">
                    <img src="images/btn_trans.gif" alt="" width="1" height="1" border="0">
                </a>
            </div>

            <div style="position:absolute; left:502px; top:225px;">
                <img style=" " id="btn1" src="images/btn_trans.gif" border="0" width="90" height="34" alt="" >
            </div>
            <div style="position:absolute; left:652px; top:225px;">
                <img style="" id="btn2" src="images/btn_trans.gif" border="0" width="90" height="34" alt="">
            </div>

            <div align="center" style="left:502; top:228; width:90; height:30; font-size:24; color:#FFFFFF;  position:absolute;">
                <%--<%=W_OK%>--%>»∑∂®
            </div>
            <div align="center" style="left:652; top:228; width:90; height:30; font-size:24; color:#FFFFFF;  position:absolute;">
                <%--<%=W_CANCEL%>--%>»°œ˚
            </div>
        </div>



        <div id="error" align="center" style="visibility:hidden;width:100%;top:240;color:#FFFFFF;font-size:24;position:absolute;">
            <%--<%=W_PWD_WRONG%>--%>
            √‹¬Î¥ÌŒÛ
        </div>




        <%@include file="inc/lastfocus.jsp" %>
        <%--<%@include file="inc/goback.jsp" %>--%>
      <script language="javascript" type="">
          top.jsSetupKeyFunction("top.mainWin.goBack", <%=STBKeysNew.remoteBack%>);
            var FONTHEAD = "<font color='00FF00' size='8' ><h1>";
            var FONTTAIL = "</h1></font>";
            if(mixno)
         top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + mixno + FONTTAIL;
          setTimeout("clearChannelNumber()",3000);
            function clearChannelNumber()
             {
                    top.mainWin.document.all.channelNumber.innerHTML = "";
              }
            function showChannelNumber(channelNum)
    {
        if (channelNum != null && channelNum != undefined)
        {
            top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
    }
            </script>
    </body>
</html>