<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
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
    String columnid = request.getParameter("columnid");
%>
<epg:PageController/>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    ColumnDataSource columnDs = new ColumnDataSource();
    ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
    valueIn.setUserInfo(userInfo);
    valueIn.setColumnId(columnid);

    EpgResult result = columnDs.getData();
    List vColumnData = (Vector) result.getData();

    StringBuffer sb = new StringBuffer();

    String oColumnid = "";
    String oColumnName = "";
    String oFcolumnid = "";
    String columnposter = "";
    int oSubExist;
    sb.append("{columnData:[");
    int length = vColumnData.size();
    for (int i = 0; i < length; i++) {
        ColumnInfo columnInfo = (ColumnInfo) vColumnData.get(i);
       
        oColumnid = columnInfo.getColumnId();
	 if("0401".equals(oColumnid) || "0402".equals(oColumnid) ||"0403".equals(oColumnid) || "0405".equals(oColumnid) || "0407".equals(oColumnid)){
        columnposter = columnInfo.getNormalPoster();
        oColumnName = formatName(columnInfo.getColumnName());
        oSubExist = columnInfo.getSubExist();
        oFcolumnid = columnInfo.getParentId();
        if (columnposter.indexOf("defaultcolumn_n") != -1) columnposter = "images/vod/post.png";

        sb.append("{columnid:\"" + oColumnid + "\",");
        sb.append("fcolumnid:\"" + oFcolumnid + "\",");
        sb.append("columnposter:\"" + columnposter + "\",");
        sb.append("columnname:\"" + oColumnName + "\",");
        sb.append("subexist:\"" + oSubExist + "\"}");
        sb.append(",");
        }
    }
    sb.deleteCharAt(sb.length() - 1);
    sb.append("]}");

    JspWriter ot = pageContext.getOut();

    ot.write(sb.toString());
%>

