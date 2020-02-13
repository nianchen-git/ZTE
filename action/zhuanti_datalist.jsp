<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%
    String columnid = request.getParameter("columnid");
%>
<epg:PageController/>
<%
    StringBuffer sb = new StringBuffer();
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    VodDataSource vodDs = new VodDataSource();
    VoDQueryValueIn valueIn = (VoDQueryValueIn) vodDs.getValueIn();
    valueIn.setUserInfo(userInfo);
    valueIn.setColumnId(columnid);
    
    EpgResult result = vodDs.getData();
    List vVodData = (Vector) result.getData();

    String oColumnid = "";
    String oProgramid = "";
    String oProgramtype = "";
    String oProgramName = "";
    String oContentCode = "";
    String normalPoster = "";
    String bigPoster = "";

    sb.append("{vodData:[");
    int length = vVodData.size();
    for (int i = 0; i < length; i++) {
        VoDContentInfo vodInfo = (VoDContentInfo) vVodData.get(i);
        oColumnid = vodInfo.getColumnId();
        oProgramid = vodInfo.getProgramId();
        oProgramtype = vodInfo.getProgramType();
        oProgramName = vodInfo.getProgramName();
        oContentCode = vodInfo.getContentId();           
        normalPoster = vodInfo.getNormalPoster();
        bigPoster = vodInfo.getBigPoster();
        if(normalPoster.indexOf("defaultposter_n")!=-1 )normalPoster="images/vod/post.png";    
        if (i > 0 && i < length) {
            sb.append(",");
        }
        sb.append("{columnid:\"" + oColumnid + "\",");
        sb.append("programid:\"" + oProgramid + "\",");
        sb.append("normalPoster:\"" + normalPoster + "\",");
        sb.append("bigPoster:\"" + bigPoster + "\",");
        sb.append("programname:\"" + oProgramName + "\",");
        sb.append("contentcode:\"" + oContentCode + "\",");
        sb.append("programtype:\"" + oProgramtype + "\"}");
    }
    sb.append("]}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

