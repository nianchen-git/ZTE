<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="java.util.HashMap" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
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
    String destpage = request.getParameter("destpage");
    int destpage1 = 1;
    if (destpage != null && !"".equals(destpage)) {
        try {
            destpage1 = Integer.parseInt(destpage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<%
    String columnid = request.getParameter("columnid");
    int pageCount = 1;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    ColumnDataSource columnDs = new ColumnDataSource();
    ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
    valueIn.setUserInfo(userInfo);
    valueIn.setColumnId(columnid);
    EpgResult result = columnDs.getData();
    List vColumnData = (Vector) result.getData();
    int totalSize = vColumnData.size();
    if (totalSize == 0) {
        ColumnInfo columnInfo1 = new ColumnInfo();
        columnInfo1.setColunmId(columnid);
        columnInfo1.setColumnName("频道");
        columnInfo1.setColumnDescription("频道");
        vColumnData.add(columnInfo1);
        totalSize++;
    }
    StringBuffer sb = new StringBuffer();

    String oColumnid = "";
    String oColumnName = "";
    String oFcolumnid = "";
    int oSubExist;
    String columnpath = "";
    int totalSizea =5;
    sb.append("{columnCount:\""+totalSizea+"\", columnData:[");
    int length = vColumnData.size();
    for (int i = 0; i < length; i++) {
     ColumnInfo columnInfo = (ColumnInfo) vColumnData.get(i);
     oColumnid = columnInfo.getColumnId();
  if("0401".equals(oColumnid) || "0402".equals(oColumnid) ||"0403".equals(oColumnid) || "0405".equals(oColumnid) || "0407".equals(oColumnid)){
      oColumnName = formatName(columnInfo.getColumnDescription());
        sb.append("{columnid:\"" + oColumnid + "\",");
        sb.append("columnname:\"" + oColumnName + "\"}");
        sb.append(",");
     }
    }
    sb.deleteCharAt(sb.length() - 1);
    sb.append("]}");

//    for (int i = 0; i < length; i++) {
//        ChannelDataSource channelDs = new ChannelDataSource();
//        ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
//        ColumnInfo columnInfo = (ColumnInfo) vColumnData.get(i);
//        valuesIn.setUserInfo(userInfo);
//        valuesIn.setColumnId(columnInfo.getColumnId());
////        if (destpage != null) {
//            valuesIn.setNumPerPage(7);
//            valuesIn.setPage(1);
////        }
//        EpgResult resultTV = channelDs.getData();
//        List vChannelData = (Vector) resultTV.getData();
//        int totalchannelS = vChannelData.size();
//
//        //分页相关数据
//        HashMap hmPage = resultTV.getDataOut();
//        EpgPaging paging = (EpgPaging) hmPage.get("page");
//        pageCount = paging.getPageCount();
//        String MixNo = "";
//        String programName = "";
//        String channelId = "";
//        int plength = vChannelData.size();
//        System.out.println("=========plength"+plength);
//        sb.append("columnid: pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\",channeldata:[");
//        for (int a = 0; a < plength; a++) {
//            ChannelInfo ChannelInfo = (ChannelInfo) vChannelData.get(a);
//            MixNo = ChannelInfo.getMixNo() + "";
//            programName = ChannelInfo.getChannelName();
//            channelId = ChannelInfo.getChannelId();
//            sb.append("{MixNo:\"" + MixNo + "\",");
//            sb.append("programName:\"" + programName + "\",");
//            sb.append("channelId:\"" + channelId + "\"}");
//              if (a < plength-1) {
//                sb.append(",");
//            }
//        }
//    }
//    sb.append("]}");


    JspWriter ot = pageContext.getOut();
    System.out.println("========sb" + sb.toString());
    ot.write(sb.toString());
%>

