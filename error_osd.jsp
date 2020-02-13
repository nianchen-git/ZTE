<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ include file="inc/words.jsp" %>
<%
    String pushtype=String.valueOf(session.getAttribute("pushportal"));
    if("1".equals(pushtype)){
        session.setAttribute("pushportal","0");
%>
<epg:PageController name="portal_frame.jsp" />
<%
    }else{
%>
<epg:PageController name="back.jsp" />
<%
    }
%>

<html>
	<head>
        <epg:script/>
         <script type="text/javascript">
             function doKeyPress(evt){
                var keycode = evt.which;
                if(keycode == 0x0110){
                  /*  if("CTCSetConfig" in Authentication)
                    {
                        //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                        Authentication.CTCSetConfig("KeyValue","0x110");
                    }else{
                        //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                        Authentication.CUSetConfig("KeyValue","0x110");
                    }*/
                    top.mainWin.document.location = "portal.jsp";
                }else if (keycode == 36){
                    top.mainWin.document.location = "portal.jsp";
                }else if (keycode == <%=STBKeysNew.remoteBack%> || keycode == 24){
                    doBack();
                }else{
                    top.doKeyPress(evt);
                }
                return false;
            }

             function delayStop() {
                 top.vodBackTimer = top.setTimeout("top.switchToStopOSDUrl(0)", 600);
             <%--top.setTimeout("top.mainWin.document.location='<%=path%>back.jsp'",1000);--%>
             }

             function doBack(){
                 //alert("SSSSSSSSSSSSSSSdoBack_top.isPlay()="+top.isPlay());
                 if(top.isPlay() == true){
//                     alert("SSSSSSSSSSSSSSSdoBack_11111");
                     top.mainWin.document.location = "back.jsp";
                 }else{
                     var currentChannel = top.channelInfo.currentChannel;
//                     alert("SSSSSSSSSSSScurrentChannel="+currentChannel);
                     if (currentChannel == -1 || currentChannel=="") {
                         currentChannel = top.channelInfo.lastChannel;
                     }
                   //  alert("SSSSSSSSSSSScurrentChannel="+currentChannel);
                     delayStop();
                     top.jsHideOSD();
                     top.doStop();
                     top.setBwAlpha(0);
//                     alert("SSSSSSSSSSSStop.channelInfoArr[currentChannel]="+top.channelInfoArr[currentChannel]);
                     if (top.channelInfoArr[currentChannel] != undefined && top.channelInfoArr[currentChannel] != null) {
                         if (top.channelInfoArr[currentChannel].channelType != 3) {
                             top.jsRedirectChannel(currentChannel);
                         }
                     }
                 }
             }

            document.onkeypress = doKeyPress;


            function pageInit1() {
                //不需要检查频道播放
                top.jsSetControl("isCheckPlay","1");
				if(top.errorMsg.errorCode == "2003"){
					//top.mainWin.document.all.description.innerHTML = "<font  color=\"FFFFFF\">" + "很抱歉，您所选择的是付费内容，您暂无访问权限" +"("+ top.errorMsg.errorCode +")</font>";
					document.getElementById("desc_1").style.visibility = "visible";
					document.getElementById("desc_2").style.visibility = "visible";
				}else{
		        	top.mainWin.document.all.description.innerHTML = "<font  color=\"FFFFFF\">" + top.errorMsg.errorMessage +"("+ top.errorMsg.errorCode +")</font>";
				}
            }

//            top.channelInfo.currentChannel="";
         </script>
	</head>
	<body onload="pageInit1();" bgcolor="transparent" style="margin:0; padding:0;" >
       <%--<div align="center"  id="description" style="width:300; height:90; left:170; top:220;color:#FFF; font-size:20;position:absolute;">--%>
        <%--</div>--%>
 <div align="center" style="left:139; top:532;width:1003;height:137; position:absolute">
    <img width="1003" height="137" src="images/message.png" alt=""/>
</div>
<div align="center" id="description" style="left:209; top:562;width:868;height:65;font-size:24px; position:absolute; font-weight:bold; color:#FFF;">
</div>
<div align="center" id="desc_1" style="left:180; top:562;width:920;height:65;font-size:32px; position:absolute; color:#FFF; visibility:hidden;">很抱歉，您所选择的是付费内容，您暂无访问权限。</div>
<div align="center" id="desc_2" style="left:180; top:625;width:920;height:65;font-size:32px; position:absolute; color:#FFF; visibility:hidden;">请您切换至其他频道再选择节目观看。</div>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
	</body>
</html>
