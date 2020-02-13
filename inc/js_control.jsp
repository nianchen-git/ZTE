<%
    String reqURI = request.getRequestURI();
    int start = reqURI.indexOf("frame");
    int end = reqURI.indexOf("/", start);
    String reqFrame = reqURI.substring(start, end);
    String reqURL = request.getRequestURL().toString();
    String appUrl = reqURL.substring(0, reqURL.indexOf("frame"));
    String frameUrl = appUrl + reqFrame;
    System.out.println("frameUrl**********************"+frameUrl);
%>

<script type="text/javascript">
    top.jsSetControl("UserModel","<%=reqFrame%>");
    top.jsSetControl("ChannelAuthUrl","<%=frameUrl%>/channelOrderAuth.jsp");
    top.jsSetControl("ChannelOrderUrl","<%=frameUrl%>/channel_order_lock.jsp");
    top.jsSetControl("ShowOrderListUrl","<%=frameUrl%>/channelOrderShowOrderList.jsp");
	top.jsSetControl("lockvertifyjsp","<%=frameUrl%>/lockvertify.jsp");
	<%--top.jsSetControl("errorTipOsdUrl","<%=frameUrl%>/error_osd.jsp");--%>
	<%--top.jsSetControl("errorOsdUrl","<%=frameUrl%>/errorOSD.jsp");--%>
	<%--top.jsSetControl("NoResourceOSD","<%=frameUrl%>/noresource_osd.jsp");--%>
     top.jsSetControl("STBLocalAudioUIFlag","0");
	top.jsSetControl("muteOsdUrl","<%=frameUrl%>/mute.jsp");
	top.jsSetControl("volumeOsdUrl","<%=frameUrl%>/volumeosd.jsp");
	top.jsSetControl("frameBackUrl","<%=frameUrl%>/back.jsp");
    top.jsSetControl("stopVodOsdUrl","<%=frameUrl%>/vod_play_stop.jsp");
	top.jsSetControl("stopTvodOsdUrl","<%=frameUrl%>/music_play_stop.jsp");
	top.jsSetControl("liveSpeedOsdUrl","<%=frameUrl%>/livespeedosd.jsp");
	top.jsSetControl("vodSpeedOsdUrl","<%=frameUrl%>/speedosd.jsp");
    top.jsSetControl("liveLocationOsdUrl","<%=frameUrl%>/locationbytimeosd.jsp");
	top.jsSetControl("vodLocationOsdUrl","<%=frameUrl%>/locationbytimeosd.jsp");
    top.jsSetControl("goToStartOrEndOsdUrl","<%=frameUrl%>/goToStartOrEndOSD.jsp");
</script>