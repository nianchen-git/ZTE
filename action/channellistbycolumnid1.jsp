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
<%
    String columnid=request.getParameter("columnid");
    String numberperpage=request.getParameter("numberperpage");
    String destpage = request.getParameter("destpage");
    int destpage1=1 ;
    if(destpage != null && !"".equals(destpage)){
        try{
             destpage1 = Integer.parseInt(destpage);
        }catch (Exception e){
            System.out.println("destpage youwenti!!!!!");
            e.printStackTrace();
        }
    }

    int numberperpage1 = 9;
    if(numberperpage!=null && !"".equals(numberperpage)){
        try{
             numberperpage1 = Integer.parseInt(numberperpage);
        }catch (Exception e){
            System.out.println("numberperpage youwenti!!!!!");
            e.printStackTrace();
        }
    }

    System.out.println("SSSSSSSSSnumberperpage1="+numberperpage1);
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
        if(destpage != null){ //如果分页就要展示每页多少条记录了
              valueIn.setNumPerPage(numberperpage1);
              valueIn.setPage(destpage1);
        }

        EpgResult result = columnDs.getData();
        HashMap hmPage = result.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        pageCount = paging.getPageCount();
        totalCount = paging.getTotalCount();
        List vColumnData = (Vector) result.getData();

        StringBuffer sb = new StringBuffer();

        String oColumnid = "";
        String oColumnName = "";
        String oFcolumnid="";
        int oSubExist ;

        sb.append("{pageCount:\""+pageCount+"\",destpage:\""+destpage1+"\", columnData:[");
        int length = vColumnData.size();
        for(int i=0; i<length; i++){
             ColumnInfo columnInfo = (ColumnInfo)vColumnData.get(i);
             oColumnid  = columnInfo.getColumnId();
             oColumnName  = columnInfo.getColumnName();
             oSubExist =  columnInfo.getSubExist();
             oFcolumnid=columnInfo.getParentId();
            if(i > 0 && i<length){
                sb.append(",");
            }
            sb.append("{columnid:\""+oColumnid+"\",");
            sb.append("fcolumnid:\""+oFcolumnid+"\",");
            sb.append("columnname:\""+oColumnName+"\",");
            sb.append("subExist:\""+oSubExist+"\"}");
        }
        sb.append("]}");

        JspWriter ot = pageContext.getOut();

	    ot.write(sb.toString());
    %>

