<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.zte.iptv.epg.web.FavoriteQueryValueIn" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="com.zte.iptv.newepg.tag.PageController" %>
<%@page import="com.zte.iptv.newepg.datasource.UserFavoriteDataSource" %>
<%@page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@page import="com.zte.iptv.epg.account.FavoriteInfo" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Vector" %>
<%@page import="com.zte.iptv.epg.util.*" %>
<%@page import="com.zte.iptv.epg.utils.Utils" %>
<%@include file="inc/ad_utils.jsp" %>
<meta http-equiv="pragma"   content="no-cache" />  
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate" />  
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT" />
<epg:PageController/>
<%!
    public String formatName(Object oldName) {
        String newName = String.valueOf(oldName);
        if (!"null".equals(newName)) {
//            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\\\\", "\\\\\\\\");
            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\'", "\\\\\'");
        } else {
            newName = "";
        }
        return newName;
    }
%>
<%

    UserInfo userInfo = (UserInfo) pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);
	String userId = userInfo.getUserId();
    
	String strADid =request.getParameter("strADid");
	String strADid2 =request.getParameter("strADid2");
    String programId =request.getParameter("programid");
    String columnId = request.getParameter("columnid");
    String vod_type = request.getParameter(EpgConstants.VOD_TYPE);
    String contentId = request.getParameter(EpgConstants.CONTENT_ID);
	String seriesProgramCode = request.getParameter("seriesprogramcode");
    String programtype=request.getParameter("programtype");
%>
<script type="text/javascript" src="js/advertisement_manager.js"></script>
<script type="text/javascript">

var playflag =1;//0Îª²¥·ÅÇ°ÌùÆ¬
var columnIda = "<%=columnId%>".substr(0, 2);
var secondcolumnIda = "<%=columnId%>";
var strADid2 = "<%=strADid2%>";
var global_code=0;
var inverse_time=0;
//for(var i=0; i<category_list.length; i++){
//	if(columnIda==category_list[i]){
//		playflag=1;
//		break;
//	}
//}
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

</script>
<%
    String seriesId="0";
    String programname="";
    Map newDataOut = getData(getEpgResult("VodOneDecorator", pageContext));
        if (null !=newDataOut){
            contentId=(String)newDataOut.get("ContentId");
            if(vod_type.equals(String.valueOf(CodeBook.VOD_TYPE_SERIES_Single))){
            seriesId =(String) newDataOut.get("SeriesProgramCode");
            }
            programname=(String)newDataOut.get("ProgramName");
        }
 programname = formatName(programname);

    BreakPointKey key = new BreakPointKey();
    key.setUserID(userId);
    key.setContentID(contentId);
    key.setSeriesID(seriesId);
	key.setSubjectID(columnId);
    BreakPointInfo3S breakPointInfo3S = BreakPointMngr3S.getNewBPInfo(key);
     int breakPoint=0;
     String dauserid="";
    if (null != breakPointInfo3S) {
            breakPoint = breakPointInfo3S.getBreakpoint();

        } else {
            breakPointInfo3S = new BreakPointInfo3S();
            breakPointInfo3S.setDauserid(userId);
            breakPointInfo3S.setUserid(userId);
            breakPointInfo3S.setContentid(contentId);
            breakPointInfo3S.setSeriesid("0");
            breakPointInfo3S.setSubjectid(columnId);
     }

    StringBuffer sb = new StringBuffer();

    if(vod_type.equals(String.valueOf(CodeBook.VOD_TYPE_SERIES_Single))){
           sb.append("vod_series_play.jsp");

    }else{
        sb.append("vod_Playy.jsp");

    }

    sb.append("?" + EpgConstants.COLUMN_ID + "=").append(columnId);
    sb.append("&" + EpgConstants.CONTENT_ID + "=").append(contentId);
    sb.append("&" + EpgConstants.PROGRAM_ID + "=").append(programId);
    sb.append("&strADid=").append(strADid);
	sb.append("&strADid2=").append(strADid2);
	sb.append("&programtype=").append(programtype);
    //sb.append("&programname=").append(programname);
    sb.append("&" + EpgConstants.VOD_TYPE).append("=").append(vod_type);
    sb.append("&" + EpgConstants.FATHER_CONTENT).append("=").append(seriesProgramCode);
    sb.append("&" + EpgConstants.LASTFOCUS).append("=").append(request.getParameter("leefocus"));
	sb.append("&" + EpgConstants.BP_DAUSERID).append("=").append(userId);
	sb.append("&" + EpgConstants.BP_DAUSERFLAG).append("=IPTV");
//	sb.append("&" + EpgConstants.BP_MARKTITLE).append("=").append(programname);
	sb.append("&" + EpgConstants.BP_MARKTYPE).append("=PORGRAM");
	sb.append("&" + EpgConstants.BP_CONTENTID).append("=").append(contentId);
	sb.append("&" + EpgConstants.BP_SERIESID).append("=0");

    if (breakPoint == 0) {
        sb.append("&").append(EpgConstants.BREAKPOINT).append("=");
%>
<script type="text/javascript">

	    top.doStop();
        top.jsStopList();
		top.jsHideOSD();
if(playflag==1){
    top.mainWin.document.location = "<%=sb.toString()%>";
}else{
	var lastChannelNum = top.channelInfo.currentChannel;
	 if(isZTEBW == true){
        ztebw.setAttribute("curMixno", lastChannelNum);
    }
	var play_urla="<%=sb.toString()%>";
	play_urla=play_urla.replace(/&/g,"@");
	top.mainWin.document.location = "vod_player_simple.jsp?global_code="+global_code+"&inverse_time="+inverse_time+"&playUrl="+encodeURI(encodeURI(play_urla));
		
}
    
</script>
<%
//        pageContext.forward(sb.toString());
        System.out.println("SSSSSSSSSSSSSSSSSSSzhijiebofang le="+sb.toString());
        return;
    }
    String playUrl = sb.toString() + "&" + EpgConstants.BREAKPOINT + "=";
%>

<%--<html>--%>
<%--<head>--%>
    <%--<title>music_video_playlist</title>--%>
<%--</head>--%>

<%--<body bgcolor="transparent">--%>
<script type="text/javascript">
if(playflag==1){
	top.mainWin.showTips("<%=playUrl%>","<%=breakPoint%>");
}else{
	var play_urla = "<%=playUrl%>";
	play_urla=play_urla.replace(/&/g,"@");
	top.mainWin.showTips("vod_player_simple.jsp?global_code="+global_code+"&inverse_time="+inverse_time+"&playUrl="+encodeURI(encodeURI(play_urla)),"<%=breakPoint%>");
}
</script>
<%--</body>--%>
<%--</html>--%>

