<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@page import="com.zte.iptv.epg.util.BreakPointMngr3S" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodOneDataSource" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
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
    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }

	String partFrame(String reqURI) {
	int start = reqURI.indexOf("frame");
	int end = reqURI.indexOf("/", start);
	return reqURI.substring(start, end);
  }
%>
<%
    String path = getPath(request.getRequestURI());
    String bp = request.getParameter(EpgConstants.BREAKPOINT);
    String programId = request.getParameter(EpgConstants.PROGRAM_ID);
	String columnId = request.getParameter("columnid");
	String programName = request.getParameter("programname");
  if(programName == null){
        programName = "";
    }
    String programType ="0";
//	String strprogramName="";
//    strprogramName = java.net.URLDecoder.decode(programName, "GBK");
//	strprogramName = formatName(strprogramName);
	String contentId = request.getParameter(EpgConstants.CONTENT_ID);
	UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
	String userId = userInfo.getUserId();
    VodOneDataSource ds=new VodOneDataSource();
    VoDQueryValueIn valueIn=(VoDQueryValueIn)ds.getValueIn();
    valueIn.setColumnId(columnId);
    valueIn.setProgramId(programId);
    valueIn.setUserInfo(userInfo);

    EpgResult result=ds.getData();
    Vector vector=(Vector)result.getData();
    VoDContentInfo vodInfo = null;
    if(vector!=null && vector.size()>0){
        vodInfo = (VoDContentInfo)vector.get(0);
        contentId = vodInfo.getContentId();
        programType = vodInfo.getProgramType();
        programName = vodInfo.getProgramName();
    }

    programName = formatName(programName);
	String contentType="";
    if (bp == null)
        bp = "";
    if ("0".equals(bp)) {
        if (userInfo != null) {

			BreakPointKey bpkey = new BreakPointKey();
            bpkey.setUserID(userId);
            bpkey.setDaUserID(userId);
            bpkey.setDaUserFlag("IPTV");
            bpkey.setMarkTitle(programName);
            bpkey.setMarkType("PROGRAM");
            bpkey.setContentID(contentId);
            bpkey.setSubjectID(columnId);
            bpkey.setSeriesID("0");
            BreakPointMngr3S.setBPInfo(userInfo, bpkey, 0);
        }
    }

	String reqFrame = partFrame(request.getRequestURI());
%>
<epg:PageController name="back.jsp"/>
<html>
<head>
    <title>vod_sitcomplay.jsp</title>
    <epg:script lasturl="false"/>
</head>
<body bgcolor="transparent">
<epg:replace cleardatasource="com.zte.iptv.newepg.decorator.VodOneDecorator">
    <epg:para name="<%=EpgConstants.PROGRAM_ID %>" value="<%=programId%>"/>
</epg:replace>
<epg:out datasource="VodOneDecorator">
    <script language="javascript" type="">
        //var programName = encodeURI("{ProgramName}");
        top.jsSetMarkInfo("<%=contentId%>", "<%=columnId%>", 0, "<%=userId%>", "IPTV", "", "PROGRAM");
    </script>
</epg:out>
<epg:out datasource="VodUrlDecorator">
    <script language="javascript" type="">
		top.doStop();
        top.jsStopList();
		top.jsHideOSD();
		top.extrWin.document.location = "<%=path%>control_transit_vod_play.jsp?columnid=<%=columnId%>&programid=<%=programId%>&contentid=<%=contentId%>&programtype=<%=programType%>";
        top.jsVodPlay("{url}", "<%=programId%>");
    </script>
</epg:out>
</body>
</html>
