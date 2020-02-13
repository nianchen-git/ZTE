<%@ page contentType="text/html; charset=GBK" %>

<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>

<%@ page import="com.zte.iptv.epg.account.UserInfo" %>

<%@ page import="com.zte.iptv.epg.util.*" %>

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
    String programId = request.getParameter(EpgConstants.PROGRAM_ID);
    String columnId = request.getParameter(EpgConstants.COLUMN_ID);
	String strADid = request.getParameter("strADid");
	String strADid2 = request.getParameter("strADid2");
    String vod_type = request.getParameter(EpgConstants.VOD_TYPE);
    String seriesProgramCode = request.getParameter(EpgConstants.FATHER_CONTENT);
    String bp = request.getParameter(EpgConstants.BREAKPOINT);
    String userId = "";
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String contentId = request.getParameter(EpgConstants.CONTENT_ID);
    String programName = request.getParameter("programname");

    userId = userInfo.getUserId();
    if (bp == null) bp = "";
    String paras = EpgConstants.COLUMN_ID + "=" + columnId +
			"&strADid=" + strADid +
			"&strADid2=" + strADid2 +
            "&" + EpgConstants.PROGRAM_ID + "=" + programId +
            "&" + EpgConstants.VOD_TYPE + "=" + vod_type +
            "&" + EpgConstants.CONTENT_ID + "=" + contentId +
            "&" + EpgConstants.SERIES_PROGRAMCODE + "=" + seriesProgramCode;
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
            bpkey.setSeriesID(seriesProgramCode);
            BreakPointMngr3S.setBPInfo(userInfo, bpkey, 0);
        }
    }

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
        var programName = encodeURI("{ProgramName}");
        var ProgramCode= "{SeriesProgramCode}";
        top.jsSetMarkInfo("{ContentId}", "{ColumnId}", "{SeriesProgramCode}", "<%=userId%>", "IPTV", programName, "PROGRAM");
    </script>
</epg:out>
<epg:out datasource="VodUrlDecorator">
    <script language="javascript" type="">
        top.jsHideOSD();
        top.doStop();
        top.jsStopList();
        top.extrWin.document.location = "<%=path%>control_transit_series_play.jsp?<%=paras%>&programtype=1&seriesProgramCode1="+ProgramCode;
        top.jsVodPlay("{url}", "<%=programId%>");
    </script>
</epg:out>
</body>
</html>


