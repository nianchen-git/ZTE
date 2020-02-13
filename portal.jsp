<%@	page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%
    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();
    String lastfocus = request.getParameter("lastfocus");
	  String tempno = request.getParameter("tempno");
%>
<meta name="page-view-size" content="1280*720"/>
<html>
<head>
    <title>portal</title>
</head>
<body bgcolor="transparent">
<script>
  // function epg_log(log_info) {
        //var log_img = document.createElement("img");
        //log_img.src = "JSConsole?logtype=normal&t=" + (new Date()).getTime() + "&msg=" + log_info;
        //return;
    //}
		top.jsSetControl("preMillisecond",60000);
		
		 var tempno =<%=tempno%>;
	
        var curMixno ;
		 var LastChannelNo;
		
	if(tempno != null){//tianjia
        //epg_log("=====00000000000======"+tempno);//undefined
		if(tempno == 501){
            tempno=21;
        }
		//curMixno=tempno;
			curMixno=21;//开机频道为1
	}else{
		 var isZTEBW = false;
	var stbType = Authentication.CTCGetConfig("STBType");
			if(window.navigator.appName.indexOf("ztebw")>=0){
				isZTEBW = true;
				//epg_log("=====00000000000"+curMixno);//undefined
			}
			
		if(isZTEBW == false){
			LastChannelNo = Authentication.CUGetConfig("LastChannelNo");
			curMixno =top.channelInfo.currentChannel;
			if(LastChannelNo==501){
                    LastChannelNo=21;
                }
				 //epg_log("========1111111111"+curMixno);

                //epg_log("============22222222==========="+LastChannelNo);
		}else{
			
			curMixno =ztebw.getAttribute("curMixno");	
				LastChannelNo = top.channelInfo.currentChannel;	
				//epg_log("============33333333==========="+curMixno);//21
               // epg_log("============44444444==========="+LastChannelNo);//-1
				 
		}
		
			if(stbType == "B860A" || stbType == "B860AV1.2"){
				LastChannelNo = Authentication.CUGetConfig("LastChannelNo");
					// epg_log("============55555555555==========="+LastChannelNo);
			}
		
			if(LastChannelNo > -1){
				if(LastChannelNo == curMixno){
					curMixno = curMixno;
					//epg_log("============66666666==========="+curMixno);
                    //epg_log("============7777777==========="+LastChannelNo);
				}else{
					curMixno = LastChannelNo;	
						if(curMixno==501){
                        curMixno=21;
                    }
					 //epg_log("============8888888==========="+curMixno);
				}
				Authentication.CUSetConfig("LastChannelNo",-1);	
			}
		}
	
		if (curMixno !="" && !top.isPlay()) {
			top.setDefaulchannelNo();
			top.jsRedirectChannel(curMixno);
			top.setTimeout(function () {
				top.mainWin.document.location = '<%=timeFrameUrl+"/portal_frame.jsp?fromplay=1"%>&lastfocus=<%=lastfocus%>';
				top.showOSD(2, 0, 25);
				top.setBwAlpha(0);
			}, 1500);  
    }else{
		
		  //top.mainWin.document.location = '<%=timeFrameUrl+"/portal_frame.jsp?"%>lastfocus=<%=lastfocus%>';
        top.mainWin.document.location = 'portal_frame.jsp?lastfocus=<%=lastfocus%>';
    }
</script>
</body>
</html>