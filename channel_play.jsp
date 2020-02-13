<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%!
    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }
%>
<%
    String path = getPath(request.getRequestURI());
	String mixNo = request.getParameter("mixno");
		String isforjump = request.getParameter("isforjump");//信息条广告位跳转频道
    String reload = request.getParameter("reload");
    if(reload != null) {

        session.setAttribute("channelInfo",true);
    }

%>
<epg:PageController name="back.jsp"/>

<html>
	<head>
		<title>channel_play.jsp</title>
		<epg:script lasturl="false"/>
		<script type="text/javascript">
            top.jsHideOSD();
            var mixNo = parseInt('<%=mixNo%>',10);
			var isforjump = parseInt('<%=isforjump%>',10);
            if(top.channelInfo.currentChannel == mixNo){
				if(isforjump == 1){
					if(top.isPlay()){
						  top.doStop();
						  top.setDefaulchannelNo();
						  top.doLeaveChannel();
						  top.jsRedirectChannel(mixNo);
					  }else{
						 top.setDefaulchannelNo();
						 top.doLeaveChannel();
						 top.jsRedirectChannel(mixNo);
					}
				}else{
					if(!top.isPlay()){
					
                      top.setDefaulchannelNo();
					  top.doLeaveChannel();
                      top.jsRedirectChannel(mixNo);
                  }	
				}
                  
            }else{
		
				if(!top.isPlay()){
					top.doLeaveChannel();
					top.jsRedirectChannel(mixNo);	
				}else{
					top.doStop();
					top.doLeaveChannel();
					top.jsRedirectChannel(mixNo);
				}
            }
            //if(!(top.channelInfo.currentChannel == mixNo && top.channelIsExistInAuthList(mixNo) != "0")) {
                <%--top.doStop();--%>
                <%--top.setDefaulchannelNo();--%>
                <%--top.jsRedirectChannel(mixNo);--%>
            //}
		</script>

	</head>
	<body bgcolor="transparent">

	</body>
</html>
