<%@page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo"%>
<%@ page import="com.zte.iptv.epg.util.PropertyUtil"%>
<%@ page import="com.zte.iptv.epg.util.MsgUtil"%>

<html>
<head>
<title></title>
<script language="javascript" type="">
<%
	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
	String action = (String)request.getAttribute(EpgConstants.CHANNEL_OPERATION);
	String errorCode = (String)request.getAttribute(EpgConstants.ERROR_CODE);
	UserInfo userinfo =(UserInfo)pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);
	String lan= userinfo.getLanguage();
	String failureMsg=MsgUtil.getMsg("EPGActM0158",lan);
	if(action!=null && action.equals(EpgConstants.CHANNEL_ORDER))
	{
		failureMsg=(String) request.getAttribute(EpgConstants.TIPS);
	%>
		top.jsOrderFailure('<%=startTime%>','<%=endTime%>','<%=errorCode%>');
	<% 
	} else {
	%>
		top.doStopVideo();
	<% 
	}
	%>
</script>
    <style type="text/css">
        div{word-break:break-all;}
    </style>
</head>	
<body bgcolor="transparent" link="#FFFFFF">
<div style="left:550; top:50; width:90; height:100; position:absolute" id="channelNumber" >
<div style="left:78%; top:7%; width:90; height:100; position:fixed" id="channelNumber" >
</div>
<script language="javascript" type="">
   function back()
	{
	   top.doStopVideo();
       top.switchToStopUrl();
       top.setDefaulchannelNo();
	}

    function showChannelNumber(channelNum)
    {
       top.jsDebug("showChannelNumber ======= " + channelNum);
	   top.mainWin.document.all.channelNumber.innerHTML = "<font color='00FF00' size='8'><h1>" + channelNum + "</h1></font>";
    }

    function clearChannelNumber()
    {
	   top.jsDebug(" clearChannelNumber ");
	   top.mainWin.document.all.channelNumber.innerHTML = "";
    }	
	
	top.jsSetupKeyFunction("top.mainWin.back", top.keyCodeArray["remoteBack"]);
   top.jsSetupKeyFunction("top.mainWin.back", 0xd);

    document.onkeypress = top.doKeyPress;
    focus();
</script>
    <div align="center" style="left:139; top:532;width:1003;height:137; position:absolute">
    <img width="1003" height="137" src="images/message.png" alt="" />
</div>
<div align="center" id="description" style="left:209; top:562;width:868;height:65;font-size:24px; position:absolute; font-weight:bold; color:#FFF;">
<font color="#FFFFFF"  ><%=failureMsg%></font>
</div>
</body>
</html>
