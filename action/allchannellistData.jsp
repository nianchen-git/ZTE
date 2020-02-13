<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
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
<%@ page import="java.util.ArrayList" %>
<%
    String columnid=request.getParameter("columnid");
    String numberperpage=request.getParameter("numberperpage");
    String destpage = request.getParameter("destpage");
    String isFromPortal = request.getParameter("isFromPortal");
    isFromPortal = (isFromPortal==null) ? "":isFromPortal;

    int destpage1=1 ;
    if(destpage != null && !"".equals(destpage)){
        try{
             destpage1 = Integer.parseInt(destpage);
        }catch (Exception e){
            System.out.println("destpage youwenti!!!!!");
            e.printStackTrace();
        }
    }

    int numberperpage1 = 7;
    if(numberperpage!=null && !"".equals(numberperpage)){
        try{
             numberperpage1 = Integer.parseInt(numberperpage);
        }catch (Exception e){
            System.out.println("numberperpage youwenti!!!!!");
            e.printStackTrace();
        }
    }

    String istvod = request.getParameter("istvod");
//
//    int numberperpage1 = 10;

%>
<epg:PageController />
    <%
        int pageCount ;
        int totalCount ;
        UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
        ColumnDataSource columnDs = new ColumnDataSource();
        ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnid);
//        if(destpage != null){ //如果分页就要展示每页多少条记录了
//              valueIn.setNumPerPage(numberperpage1);
//              valueIn.setPage(destpage1);
//        }

        EpgResult result = columnDs.getData();
        HashMap hmPage = result.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        pageCount = paging.getPageCount()-1;//fan-----paging.getPageCount();
        totalCount = paging.getTotalCount();
        List vColumnData = (Vector) result.getData();

        String oColumnid = "";
        int length = vColumnData.size();
        int size = 0;
        ChannelDataSource channelDs = null;
        ColumnInfo columnInfo = null;
        ChannelInfo channelInfo = null;

        List ChannelInfoList = new ArrayList();

        if(length > 0){
             for(int i=0; i<length; i++){
                columnInfo = (ColumnInfo)vColumnData.get(i);
                oColumnid  = columnInfo.getColumnId();
		if("0400".equals(oColumnid) || "0401".equals(oColumnid) || "0402".equals(oColumnid) ||"0403".equals(oColumnid) || "0405".equals(oColumnid) || "0407".equals(oColumnid)){
                channelDs = new ChannelDataSource();
                ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
                valuesIn.setUserInfo(userInfo);
                valuesIn.setColumnId(oColumnid);
                EpgResult resultTV = channelDs.getData();
                List vChannelData = (Vector) resultTV.getData();
                ChannelInfoList.addAll(vChannelData);
                 }
             }
        }else if(length == 0){
                channelDs = new ChannelDataSource();
                ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
                valuesIn.setUserInfo(userInfo);
                valuesIn.setColumnId(columnid);
                EpgResult resultTV = channelDs.getData();
                List vChannelData = (Vector) resultTV.getData();
                ChannelInfoList.addAll(vChannelData);
        }
//添加301屏蔽
        //迷你页屏蔽(直播+点播) //备注
		for (int m = 0; m < ChannelInfoList.size(); m++) {
            ChannelInfo ChannelInfom = (ChannelInfo) ChannelInfoList.get(m);
            String noas = String.valueOf(ChannelInfom.getMixNo());
            
            if("302".equals(noas)||"301".equals(noas)||"303".equals(noas)){
                ChannelInfoList.remove(m);
                m--;
            }
        }


        size = ChannelInfoList.size();
        List tempChannelInfoList = new ArrayList();
        if(istvod!=null && istvod.equals("1")){
            for(int i=0; i<size; i++){
                channelInfo = (ChannelInfo)ChannelInfoList.get(i);
                if(channelInfo.getUsertvodenable()){
                    tempChannelInfoList.add(channelInfo);
                }
            }
            ChannelInfoList = tempChannelInfoList;
        }

        size = ChannelInfoList.size();

//        System.out.println("SSSSSSSSSSSSSSSSSSSSSSSTVOD_SIZE="+size);

        StringBuffer sb = new StringBuffer();
        sb.append("{pageCount:\""+pageCount+"\",destpage:\""+destpage1+"\", channelData:[");

        for(int i=0; i<size; i++){
            channelInfo = (ChannelInfo)ChannelInfoList.get(i);
			String mixnoa = String.valueOf(channelInfo.getMixNo());
			if(!"200".equals(mixnoa)){
            sb.append("{mixno:\""+channelInfo.getMixNo()+"\",");
            sb.append("channelid:\""+channelInfo.getChannelId()+"\",");
            sb.append("channelname:\""+channelInfo.getChannelName()+"\",");
            sb.append("columnid:\""+channelInfo.getFcolumnid()+"\"}");
            if(i<size){
               sb.append(",");
            }
			}
        }

        sb.append("]}");

//        System.out.println("========channellist="+sb);

        JspWriter ot = pageContext.getOut();
	    ot.write(sb.toString());
    %>

