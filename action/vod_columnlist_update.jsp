<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ include file="get_columnPath.jsp" %>
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

    String destpage = request.getParameter("destpage");
    int destpage1 = 1;
    if (destpage != null && !"".equals(destpage)) {
        try {
            destpage1 = Integer.parseInt(destpage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String numperpage = request.getParameter("numberperpage");
    int numperpage1 = 7;
    if (numperpage != null && !"".equals(numperpage)) {
        try {
            numperpage1 = Integer.parseInt(numperpage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


%>
<epg:PageController/>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String timepath = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    timepath = timepath.replace("action/", "");
    HashMap timeparam = PortalUtils.getParams(timepath, "GBK");
    String isFathercolumnlist = String.valueOf(timeparam.get("isFathercolumnlist"));
    String Fathercolumnlist = String.valueOf(timeparam.get("Fathercolumnlist"));
    System.out.println("+++++++++++++++++++isFathercolumnlist=" + isFathercolumnlist);
    if (isFathercolumnlist != null && Fathercolumnlist != null && isFathercolumnlist.equals("1")) {//读取N个一级栏目分支
        String[] columnlist = Fathercolumnlist.split(",");
        int columnLength = columnlist.length;
//        int pageCount = (columnLength - 1) / numperpage1 + 1;
        int pageCount = 0;
//             for(int i=0; i<columnlist.length; i++){
//                 System.out.println("++++++"+columnlist[i]);
//             }
//        int startIndex = (destpage1 - 1) * numperpage1;
//        int endIndex = destpage1 * numperpage1 - 1;
//        if (endIndex > (columnLength - 1)) {
//            endIndex = columnLength - 1;
//        }

        ColumnOneDataSource columnOneDataSource = null;
        String columnpath = "";
        String columnposter = "";
        String oColumnid = "";
        String oFcolumnid = "";
        String oColumnName = "";
        int oSubExist;

        StringBuffer sb = new StringBuffer();

        //记录存在的栏目号的个数
        int realcolumnLength=0;
        //sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\", columnData:[");
        sb.append("{destpage:\"" + destpage1 + "\", columnData:[");
        for (int i = 0; i < columnLength; i++) {
            String columnidone = columnlist[i];
            columnOneDataSource = new ColumnOneDataSource();
            ColumnValueIn valueIn = (ColumnValueIn) columnOneDataSource.getValueIn();
            valueIn.setUserInfo(userInfo);
            valueIn.setColumnId(columnidone);
            EpgResult result = columnOneDataSource.getData();
            List vColumnData = (Vector) result.getData();
            if(vColumnData!=null && vColumnData.size()>0){
                 realcolumnLength++;
            }else{
                continue;
            }
            ColumnInfo columnInfo1 = (ColumnInfo) vColumnData.get(0);
            columnposter = columnInfo1.getNormalPoster();
            oColumnName = columnInfo1.getColumnName();
            oSubExist = columnInfo1.getSubExist();

            columnpath = getColumnPath(columnidone, userInfo);

            if (columnposter.indexOf("defaultcolumn_n") != -1) columnposter = "";
            if (realcolumnLength > 1 && i <= columnLength) {
                sb.append(",");
            }
            sb.append("{columnid:\"" + columnidone + "\",");
            sb.append("fcolumnid:\"" + columnidone + "\",");
            sb.append("columnposter:\"" + columnposter + "\",");
            sb.append("columnname:\"" + formatName(oColumnName) + "\",");
            sb.append("columnpath:\"" + columnpath + "\",");
            sb.append("subExist:\"" + oSubExist + "\"}");
        }
        pageCount = (realcolumnLength - 1) / numperpage1 + 1;
        sb.append("]}");
        sb.insert(1,"pageCount:\"" + pageCount + "\",");
        System.out.println("+++++++realcolumnLength="+realcolumnLength);
        System.out.println("+++++++sb.toString()="+sb.toString());
        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());

    } else {//从父栏目取子栏目分支
        int pageCount = 0;
        int totalCount = 0;

        ColumnDataSource columnDs = new ColumnDataSource();
        ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnid);

        EpgResult result = columnDs.getData();
        List vColumnData = (Vector) result.getData();

        StringBuffer sb = new StringBuffer();

        String oColumnid = "";
        String oColumnName = "";
        sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\", columnData:[");
        int length = vColumnData.size();
        for (int i = 0; i < length; i++) {
            ColumnInfo columnInfo = (ColumnInfo) vColumnData.get(i);
            oColumnid = columnInfo.getColumnId();
            oColumnName = columnInfo.getColumnName();
            if (i > 0 && i < length) {
                sb.append(",");
            }
            sb.append("{columnid:\"" + oColumnid + "\",");
            sb.append("columnname:\"" + oColumnName + "\"}");
        }
        sb.append("]}");

        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());
    }
%>

