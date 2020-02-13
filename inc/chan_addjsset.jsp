<%!
	String partFrameUrl(String reqURI) {
    	int start = reqURI.indexOf("frame");
    	int end = reqURI.indexOf("/", start);

    	return reqURI.substring(start, end);
	}
%>

<%
	String reqFrame = partFrameUrl(request.getRequestURI());
	String requestURL = request.getRequestURL().toString();
	String appUrl = requestURL.substring(0, requestURL.indexOf("frame"));
	String frameUrl = appUrl + reqFrame;
%>

<script language="javascript" type="">
    if(isReallyZTE == true){
        //Authentication.CTCSetConfig('SetEpgMode', '720P');
        if("CTCSetConfig" in Authentication)
        {
          //  alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CTC");
            Authentication.CTCSetConfig('SetEpgMode', '720P');
        }else{
           // alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CU");
            Authentication.CUSetConfig('SetEpgMode', '720P');
        }
    }
	top.jsSetControl("lockvertifyjsp","<%=frameUrl%>/channel_lockverify.jsp");
	top.jsSetControl("ChannelAuthUrl","<%=frameUrl%>/channelOrderAuth.jsp");
	top.jsSetControl("ChannelOrderUrl","<%=frameUrl%>/channelOrder.jsp");
	top.jsSetControl("ShowOrderListUrl","<%=frameUrl%>/channelOrderShowOrderList.jsp");
	<%--top.jsSetControl("tvmsOsdUrl","<%=frameUrl%>/channel_lpvr.jsp?tvms=1");--%>
	top.jsSetControl("errorTipOsdUrl","<%=frameUrl%>/error_osd.jsp");
	top.jsSetControl("errorOsdUrl","<%=frameUrl%>/error_osd.jsp");
	<%--top.jsSetControl("NoResourceOSD","<%=frameUrl%>/noresource_osd.jsp");--%>
	top.jsSetControl("muteOsdUrl","<%=frameUrl%>/mute.jsp");
	top.jsSetControl("volumeOsdUrl","<%=frameUrl%>/volumeosd.jsp");
	<%--top.jsSetControl("mosaicOsdUrl","<%=frameUrl%>/channel_mosaic.jsp");--%>
	<%--top.jsSetControl("soundAndTitleUrl","<%=frameUrl%>/track_osd.jsp");--%>
	top.jsSetControl("adBeforeUrl","<%=frameUrl%>/vod_play_tips.jsp");
	<%--top.jsSetControl("adAfterUrl","<%=frameUrl%>/vod_play_ad_after_vod.jsp");--%>
	<%--top.jsSetControl("remindOsdUrl","<%=frameUrl%>/channel_remind_alert.jsp");--%>
	<%--top.jsSetControl("refreshOSDUrl","<%=frameUrl%>/refreshOSD.jsp");--%>
	top.jsSetControl("refreshOsdUrl","<%=frameUrl%>/refreshOSD.jsp");
</script>