<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";

    String timeFrameUrl = timeBasePath + "function/index.jsp";
    
    //获取首页地址
	 String pageURI = request.getRequestURI();
     int loc = pageURI.lastIndexOf("/");
	 pageURI = pageURI.substring(0,loc+1);
	 String portalUrl = pageURI+"portal.jsp";
%>
<html>
<head>
    <script language="javascript" type="text/javascript">
    //修改为默认的颜色
     iPanel.defaultalinkBgColor = "#FF8F0D";//79FD21";FF8C00 //设置文字链接焦点颜色
     iPanel.defaultFocusColor = "#FF8F0D";//设置图片链接焦点颜色
     iPanel.focusWidth = "4";//焦点框宽度
	 var LastChannelNo;
	
     var isZTEBW = false;
        if(window.navigator.appName.indexOf("ztebw")>=0){
            isZTEBW = true;
        }
	var stbType = Authentication.CTCGetConfig("STBType");
	if(isZTEBW == false){
		LastChannelNo = Authentication.CUGetConfig("LastChannelNo");
	}else{
		if(stbType == "B860A"){
			LastChannelNo = Authentication.CUGetConfig("LastChannelNo");
		}
	}
     function keyEPGPortal(serviceUrl)
     {
      var xml = '';
      xml += "<?xml version='1.0' encoding='UTF-8'?>";
      xml += '<global_keytable>';
      xml += '<response_define>';
      xml += '<key_code>KEY_PORTAL</key_code>';
      xml += '<response_type>1</response_type>';
      xml += '<service_url>'+serviceUrl+'</service_url>';
      xml += '</response_define>';
      xml += '</global_keytable>';
      Authentication.CUSetConfig("GlobalKeyTable", xml);
	  Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>");
    }
   //判断是否为华为盒子，如果是，则获取首页键处理权
    var ua = window.navigator.userAgent;
    //alert("===thirdback==ua===="+ua);
    if(ua.indexOf("Ranger/3.0.0")>-1&&!isZTEBW){
      //alert("this is hw get key to epg");
      keyEPGPortal("<%=portalUrl%>");
    }

       try{
        if(isZTEBW == true){
            if("CTCSetConfig" in Authentication){
                Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>");
                Authentication.CTCSetConfig('SetEpgMode', '720P');
            }else{
                Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>");
                Authentication.CUSetConfig('SetEpgMode', '720P');
            }
        }else{
            Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>");
        }
		var frameid=top.jsGetControl("UserModel");
        var timer=-1;
		top.setDefaulchannelNo();
	//	var lastChannelNum = top.channelInfo.lastChannel;
     //   alert("=======================top.jsGetControl('backurlparam')============="+top.jsGetControl("backurlparam"));
        var backparam = top.jsGetControl("backurlparam");
        if (backparam.indexOf("application.jsp") > -1 ||backparam.indexOf("vod_favorite") > -1|| backparam.indexOf("portal.jsp") > -1) {
            top.vodBackTimer = top.setTimeout("top.mainWin.document.location="+"'"+top.jsGetControl('backurlparam')+"';top.showOSD(2, 0, 25);top.setBwAlpha(0);",1000);
           //  alert("=======================top.jsGetControl('backurlparam')========11111====="+top.jsGetControl("backurlparam"));
        }
            //获取当前播放频道，如果没有则上一次播放的频道
            var currentChannel = top.channelInfo.currentChannel;
			if(LastChannelNo > -1){
				if(LastChannelNo == currentChannel){
					currentChannel = currentChannel;
				}else{
					currentChannel = LastChannelNo;
				}
			}
            if (currentChannel == -1) {
                currentChannel = top.channelInfo.lastChannel;
            }
            //如果没有获取上一次播放频道且已订购频道列表有频道则获取已订购频道中的第一个频道
            var channelArray = top.channelList;
            if (currentChannel==-1 && channelArray.length > 0) {
                currentChannel = channelArray[0];
            }
            //如果用户当前没有可播放的频道则不播放任何频道
            if(currentChannel>-1){
                top.jsSetControl("isFromChannel","1");
                top.jsRedirectChannel(currentChannel);
            }

        }catch(e){
            //top.jsDebug("SSSSSSSSSSSSSSSSSSSSSSSchuo cuo le!!!"+e);
            if(isZTEBW == true){
            <%--Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>");--%>
                if("CTCSetConfig" in Authentication){
                    Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>");
                }else{
                    Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>");
                }
                ztebw.setAttribute('fromthirdback','1');
                document.location = "<%=timeFrameUrl%>";
            }else{
			iPanel.setGlobalVar("fromthirdback","1"); //设置全局变量fromthirdback=1
                Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>");
                document.location = "<%=timeFrameUrl%>";
            }
        }
    </script>
    <title>third back page</title>                                    `
</head>
<body  bgcolor="transparent">
</body>
</html>
