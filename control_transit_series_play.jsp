<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.RelatedVodDataSource" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodOneDataSource" %>
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
    String contentid=request.getParameter("contentid");
    String seriesProgramCode=request.getParameter("seriesProgramCode1");
    String columnid=request.getParameter("columnid");
    String programtype=request.getParameter("programtype");
    UserInfo userInfo = (UserInfo) pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);






    boolean hasNext = false;
    String strNextUrl = "";

    boolean hasPre = false;
    String strPreUrl = "";
    RelatedVodDataSource ds = new RelatedVodDataSource();
    VoDQueryValueIn valueIn = (VoDQueryValueIn) ds.getValueIn();
    String sColumnId = request.getParameter(EpgConstants.COLUMN_ID);
    String sProgramId = request.getParameter(EpgConstants.PROGRAM_ID);
	String strADid=request.getParameter("strADid");
	String strADid2=request.getParameter("strADid2");
    String sSeriesProgramCode = request.getParameter(EpgConstants.SERIES_PROGRAMCODE);

    valueIn.setColumnId(sColumnId);
    valueIn.setProgramId(sProgramId);
    valueIn.setSeriesprogramcode(sSeriesProgramCode);
    valueIn.setVoDType(CodeBook.VOD_TYPE_SERIES_Single);
    valueIn.setUserInfo(userInfo);

    String nextProgramId = null;
    String preProgramId = null;

    String strNextSer = "";

    String strPreSer = "";

    boolean isShowInfo = false;
    try {
        ds.execute();
        VoDContentInfo nextSeries = ds.getNext();
        VoDContentInfo preSeries = ds.getPrev();

//        VoDContentInfo thisVodInfo = ds.getThis();
//
//        if(thisVodInfo!=null){
//            String vodActor = thisVodInfo.getActor();
//            String vodDirector = thisVodInfo.getDirector();
//
//            if((vodActor!=null && !vodActor.equals("")) || (vodDirector!=null && !vodDirector.equals(""))){
//                isShowInfo = true;
//            }
//        }
//
//        System.out.println("SSSSSSSSSSSSSSSSSSSSSSSSisShowInfo="+isShowInfo);

        if (nextSeries != null) {
            nextProgramId = nextSeries.getProgramId();
            strNextSer = "" + nextSeries.getSeriesnum();
            hasNext = true;
        } else {//没有下一集
            hasNext = false;
        }
        if (preSeries != null) {
            preProgramId = preSeries.getProgramId();
            strPreSer = "" + preSeries.getSeriesnum();

            hasPre = true;
        } else {//没有上一集
            hasPre = false;

        }
    }
    catch (Exception ex) {//出错
        hasNext = false;
        hasPre = false;
        strNextSer = "";
        strPreSer = "";
    }

    //生成下一集播放入口页面的链接
    if (hasNext) {
        String nextSeriesUrl = "vod_series_play.jsp";

        StringBuffer sb = new StringBuffer();
        sb.append(nextSeriesUrl);
        sb.append("?"+EpgConstants.COLUMN_ID).append("="+sColumnId);
		sb.append("&"+EpgConstants.PROGRAM_ID).append("="+nextProgramId);
		sb.append("&contentid="+sColumnId);
		sb.append("&strADid="+strADid);
		sb.append("&strADid2="+strADid2);
		sb.append("&contenttype="+ CodeBookNew.ContentType_Series);
		sb.append("&CategoryID="+sColumnId);
		sb.append("&FatherContent="+sSeriesProgramCode);
		sb.append("&"+ EpgConstants.VOD_TYPE).append("="+CodeBook.VOD_TYPE_SERIES_Single);
		sb.append("&Seriesnum="+strNextSer);
                sb.append("&"+EpgConstants.SERIES_PROGRAMCODE+"="+sSeriesProgramCode);
                sb.append("&seriesProgramCode1="+sSeriesProgramCode);

        sb.append("&programtype=10");
         strNextUrl = sb.toString();
         strNextUrl=  path+ strNextUrl;
    }

    //生成上一集播放入口页面的链接
    if (hasPre) {
        String preSeriesUrl = "vod_series_play.jsp";
        StringBuffer sb = new StringBuffer();
        sb.append(preSeriesUrl);
       sb.append("?"+EpgConstants.COLUMN_ID).append("="+sColumnId);
		sb.append("&"+EpgConstants.PROGRAM_ID).append("="+preProgramId);
		sb.append("&contentid="+sColumnId);
		sb.append("&strADid="+strADid);
		sb.append("&strADid2="+strADid2);
		sb.append("&contenttype="+ CodeBookNew.ContentType_Series);
		sb.append("&CategoryID="+sColumnId);
		sb.append("&FatherContent="+sSeriesProgramCode);
		sb.append("&"+ EpgConstants.VOD_TYPE).append("="+CodeBook.VOD_TYPE_SERIES_Single);
		sb.append("&Seriesnum="+strPreSer);
                sb.append("&"+EpgConstants.SERIES_PROGRAMCODE+"="+sSeriesProgramCode);
                sb.append("&seriesProgramCode1="+sSeriesProgramCode);
         sb.append("&programtype=10");
        strPreUrl = sb.toString();
        strPreUrl=path+strPreUrl;
    }
%>
<html>
	<head>
		<title>control_transit_vodplay.jsp</title>
		<script type="text/javascript" src="js/advertisement_manager.js"></script>
		<script type="text/javascript">
			top.jsClearVideoKeyFunction();
            if(top.channelInfo.currentChannel != -1) {
                top.setDefaulchannelNo();
}
        function doNothing(){
            return false;
        }
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastRewind%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteFastForword%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.remoteStop%>);
        top.jsSetVideoKeyFunction("top.extrWin.doNothing", <%=STBKeysNew.RmotePlayPause%>);
        function pauseFunction(){
            top.jsSetVideoKeyFunction("top.extrWin.pause", <%=STBKeysNew.RmotePlayPause%>);
            top.jsSetVideoKeyFunction("top.extrWin.FastForword", <%=STBKeysNew.remoteFastForword%>);
            top.jsSetVideoKeyFunction("top.extrWin.FastRewind", <%=STBKeysNew.remoteFastRewind%>);
            top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", <%=STBKeysNew.remoteStop%>);
			
			top.jsSetVideoKeyFunction("top.extrWin.showvolumeRight", <%=STBKeysNew.remoteVolumePlus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteVolumeMinus%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeMute", <%=STBKeysNew.remoteVolumeMute%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", <%=STBKeysNew.remoteAudioTrack%>);
	top.jsSetVideoKeyFunction("top.extrWin.showvolumeLeft", 286);//九州声道键
        }
		
		function showvolumeMute() {
			var muteState = top.doGetMuteState();
			if(muteState == 0){
				top.doSetMuteState(1);
        		top.showMuteOSD();
			}else{
				top.doSetMuteState(0);
    			top.mainWin.document.location = "<%=path%>volumeosd.jsp";
    			top.showOSD(2, 0, 0);
     			top.setBwAlpha(0);
			}
		}

		
		//volumeosd.jsp add wy
		function showvolumeLeft() {
			top.mainWin.document.location = "<%=path%>volumeosd.jsp?type=leftVolume";
			top.showOSD(2, 0, 0);
			top.setBwAlpha(0);
		}
		
		function showvolumeRight() {
			top.mainWin.document.location = "<%=path%>volumeosd.jsp?type=rightVolume";
			top.showOSD(2, 0, 0);
			top.setBwAlpha(0);
		}

        function showInfo(){
//              alert('SSSSSSSSSSSSSSSlocation='+top.mainWin.document.location);
            var reg = /refreshOSD/;
            if(reg.test(top.mainWin.document.location.href)){
                info();
                setTimeout(pauseFunction,200);
            }
            }
			function delayStop() {
				top.vodBackTimer = top.setTimeout("top.switchToStopOSDUrl(0)",600);
			}

			//play end
			function showThank() {
				var currentChannel = top.channelInfo.currentChannel;
				if(currentChannel ==-1){
				    currentChannel =  top.channelInfo.lastChannel;
			    }
				
                top.jsHideOSD();
				top.doStop();
				top.setBwAlpha(0);
                if(top.channelInfoArr[currentChannel]){
                    if(top.channelInfoArr[currentChannel].channelType != 3){
                        top.jsRedirectChannel(currentChannel);
                    }
                }
delayStop();
            }
            function showThanks(){
                top.setBwAlpha(0);
                top.jsHideOSD();
                top.doStopVideo();
                if (sitcom_hasnext) {      //有下一集
                    top.jsEPGChange("<%=path%>vod_series_play_next.jsp?");
                } else {    //没有下一集
                   showThank();
                }
              }

            function FastRewind() {
                top.doFastRewind(-2);
                top.mainWin.document.location =  "<%=path%>speedosd.jsp?fast=RR&programid=<%=seriesProgramCode%>&columnid=<%=columnid%>&contentid=<%=contentid%>";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
            }

            function FastForword() {
                top.doFastForward(2);
                top.mainWin.document.location = "<%=path%>speedosd.jsp?fast=FF&programid=<%=seriesProgramCode%>&columnid=<%=columnid%>&contentid=<%=contentid%>";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
            }

            function pause() {
                top.doPause();
                top.mainWin.document.location = "<%=path%>speedosd.jsp?fast=pause&programid=<%=seriesProgramCode%>&columnid=<%=columnid%>&contentid=<%=contentid%>";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
            }

            function VODPlayStop() {
                top.mainWin.document.location = "<%=path%>vod_play_stop.jsp";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
                return false;
            }
            
            function gotoPortal() {
                top.jsSetControl("currentColumnIndex", 0);
                top.jsHideOSD();
                top.mainWin.document.location = "<%=path%>portal.jsp";
                top.showOSD(2, 0, 0);
                return false;
            }

            function info(){
                top.mainWin.document.location = "<%=path%>infoosd.jsp?programid=<%=seriesProgramCode%>&columnid=<%=columnid%>&programtype=<%=programtype%>";
                top.showOSD(2, 0, 0);
                top.setBwAlpha(0);
            }

        function playLast(){
//                top.remotePlayLast();
//                alert("SSSSSSSSSSSSSSSSSSplayLast!!!!");
            top.seek(1);
            return false;
        }

        function playNext(){
//                alert("SSSSSSSSSSSSSSSSSSplayNext!!!!");
            var duration = top.getMediaDuration();
            top.seek(duration);
            return false;
        }

        function postion() {
            top.mainWin.document.location = "<%=path%>vod_play_bytime.jsp";
            top.showOSD(2, 0, 0);
        }
            try{
                top.clearTimeout(top.timerChannel);
            }catch(e){
              //  alert("SSSSSSSSSSSSSSSSerror!!!!????");
            }

            setTimeout("showInfo();",200);

            function doNathing(){}

          top.jsSetVideoKeyFunction("top.extrWin.FastRewind", <%=STBKeysNew.onKeyLeft%>);
        top.jsSetVideoKeyFunction("top.extrWin.FastForword", <%=STBKeysNew.onKeyRight%>);

        top.jsSetVideoKeyFunction("top.extrWin.info", <%=STBKeysNew.remoteInfo%>);
 //add wy ???????? 0x458
        top.jsSetVideoKeyFunction("top.extrWin.info", 0x458);

        top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", <%=STBKeysNew.remoteBack%>);
        top.jsSetVideoKeyFunction("top.extrWin.VODPlayStop", 24);
        top.jsSetVideoKeyFunction("top.extrWin.showThanks", "mediaEnd");
        top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", <%=STBKeysNew.remoteMenu%>);
        top.jsSetVideoKeyFunction("top.extrWin.gotoPortal", 36);

        top.jsSetVideoKeyFunction("top.remoteChannelPlus()", <%=STBKeysNew.remoteChannelPlus%>);
        top.jsSetVideoKeyFunction("top.remoteChannelMinus()", <%=STBKeysNew.remoteChannelMinus%>);

        top.jsSetVideoKeyFunction("top.extrWin.playLast", <%=STBKeysNew.remotePlayLast%>);
        top.jsSetVideoKeyFunction("top.extrWin.playNext", <%=STBKeysNew.remotePlayNext%>);
        top.jsSetVideoKeyFunction("top.extrWin.postion", <%=STBKeysNew.remoteLocation%>);
        </script>
    </head>
    <body bgcolor="transparent" >
    <%--跳转时是否播放广告--%>
    <script language="javascript" type="text/javascript">
        var sitcom_hasnext = <%=hasNext%>;
        var sitcom_hasPre = <%=hasPre%>;
		var playflag =1;//0为贴片播放
		var columnIda = "<%=sColumnId%>".substr(0, 2);
		var secondcolumnIda = "<%=sColumnId%>";
		var strADid2 = "<%=strADid2%>";
		//for(var i=0; i<category_list.length; i++){
//			if(columnIda==category_list[i]){
//				playflag=1;
//				break;
//			}
//		}
var isplayflag=0;
for(var j=0;j<secondclonm.length;j++){
	if(secondcolumnIda==secondclonm[j].secclonm_id){
			isplayflag=1;
	}
	
}
      if(isplayflag ==0){
			for(var i=0; i<codelist.length; i++){
				if(columnIda==codelist[i].category_id){
					playflag=0;
					global_code=codelist[i].global_code;
					inverse_time=codelist[i].inverse_time;
					break;
				}
			}
		}
		if(strADid2=="true"){
			playflag=1;
			// columnIda = "<%=strADid%>";
		}

		if(play_flag==1){
		playflag=1;
		}
		//播广告的下一集地址
		var sitcom_nexturl = "<%=strNextUrl%>";
		if(playflag==0){
			sitcom_nexturl =sitcom_nexturl .replace(/&/g,"@");
			sitcom_nexturl =  "vod_player_simple.jsp?global_code="+global_code+"&inverse_time="+inverse_time+"&playUrl="+encodeURI(encodeURI(sitcom_nexturl));
	 	}
       
			
        var sitcom_preurl = "<%=strPreUrl%>";
			sitcom_preurl=encodeURI(sitcom_preurl);
        top.jsSetControl("sitcom_nexturl", sitcom_nexturl);
    </script>
    <%@include file="inc/public_control_play.jsp" %>
    </body>
</html>

