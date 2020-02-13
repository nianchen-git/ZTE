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
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelDataSource" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%
    String columnid = request.getParameter("columnid");
    String numberperpage = request.getParameter("numberperpage");
    String destpage = request.getParameter("destpage");
    int destpage1 = 1;
    if (destpage != null && !"".equals(destpage)) {
        try {
            destpage1 = Integer.parseInt(destpage);
        } catch (Exception e) {
            System.out.println("destpage youwenti!!!!!");
            e.printStackTrace();
        }
    }
    int numberperpage1 = 9;
    if (numberperpage != null && !"".equals(numberperpage)) {
        try {
            numberperpage1 = Integer.parseInt(numberperpage);
        } catch (Exception e) {
            System.out.println("numberperpage youwenti!!!!!");
            e.printStackTrace();
        }
    }
    System.out.println("SSSSSSSSSnumberperpage1=" + numberperpage1);
%>
<epg:PageController/>
<%
    int pageCount = 0;
    int totalCount = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    ChannelDataSource channelDs = new ChannelDataSource();
    ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
    valuesIn.setUserInfo(userInfo);
    valuesIn.setColumnId(columnid);
    EpgResult result = channelDs.getData();
    List vChannelData = (Vector) result.getData();
    //Ìí¼Ó301ÆÁ±Î
    for (int m = 0; m < vChannelData.size(); m++) {
        ChannelInfo ChannelInfom = (ChannelInfo) vChannelData.get(m);
        String noas = String.valueOf(ChannelInfom.getMixNo());
        if ("302".equals(noas)||"303".equals(noas)) {
            vChannelData.remove(m);
            m--;
        }
    }

    StringBuffer sb = new StringBuffer();
    int mixNo = 0;
    String channelId = "";
    String oColumnid = "";
    String channelName = "";
    sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\", channelData:[");
    int length = vChannelData.size();
    for (int i = 0; i < length; i++) {
        ChannelInfo ChannelInfo = (ChannelInfo) vChannelData.get(i);
        String mixnoa = String.valueOf(ChannelInfo.getMixNo());
        if (!"6".equals(mixnoa)) {
            oColumnid = ChannelInfo.getFcolumnid();
            channelName = ChannelInfo.getChannelName();
            channelId = ChannelInfo.getChannelId();
            mixNo = ChannelInfo.getMixNo();
            sb.append("{columnid:\"" + oColumnid + "\",");
            sb.append("channelid:\"" + channelId + "\",");
            sb.append("channelname:\"" + channelName + "\",");
            sb.append("mixno:\"" + mixNo + "\"}");
            if (i < length - 1) {
                sb.append(",");
            }
        }
    }
    sb.append("]}");
    System.out.println("===========SB=" + sb);
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>