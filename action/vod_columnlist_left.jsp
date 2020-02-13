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
<%@ include file="get_columnPath.jsp"%>
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
    String columnid=request.getParameter("columnid");

    String destpage = request.getParameter("destpage");
    int destpage1=1 ;
    if(destpage != null && !"".equals(destpage)){
        try{
             destpage1 = Integer.parseInt(destpage);
        }catch (Exception e){
             e.printStackTrace();
        }
    }

    String numperpage = request.getParameter("numberperpage");
    int numperpage1=9;
    if(numperpage != null && !"".equals(numperpage)){
        try{
             numperpage1 = Integer.parseInt(numperpage);
        }catch (Exception e){
             e.printStackTrace();
        }
    }


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
        //if(destpage != null){ //����ҳ��Ҫչʾÿҳ��������¼��
//              valueIn.setNumPerPage(numperpage1);
//              valueIn.setPage(destpage1);
//        }

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
        String columnposter="";
        int oSubExist ;
        String columnpath="" ;
        sb.append("{columnData:[");
        int length = vColumnData.size();
		 String oColumnida="";
		 int la = length-1;
		 ColumnInfo columnInfoa = (ColumnInfo)vColumnData.get(la);
		 oColumnida  = columnInfoa.getColumnId();
        for(int i=0; i<length; i++){
		    
             ColumnInfo columnInfo = (ColumnInfo)vColumnData.get(i);
             columnposter=columnInfo.getNormalPoster();
             oColumnid  = columnInfo.getColumnId();
             oColumnName  = columnInfo.getColumnName();
             oSubExist =  columnInfo.getSubExist();
             oFcolumnid=columnInfo.getParentId();
             columnpath=getColumnPath(oColumnid,userInfo);
			 
             if(columnposter.indexOf("defaultcolumn_n")!=-1 ||columnposter.equals(""))columnposter="images/btn_trans.gif";
			 if((!"050A".equals(oColumnid)) && (!"080C".equals(oColumnid)) && (!"0C0B".equals(oColumnid))){
            
            sb.append("{columnid:\""+oColumnid+"\",");
            sb.append("fcolumnid:\""+oFcolumnid+"\",");
            sb.append("columnposter:\""+columnposter+"\",");
            sb.append("columnname:\""+formatName(oColumnName)+"\",");
            sb.append("columnpath:\""+columnpath+"\",");
            sb.append("subExist:\""+oSubExist+"\"}");
	    if(i >=0 && i<length-2){
               sb.append(","); 
            }
		if(i==length-2){
		  if((!"050A".equals(oColumnida)) && (!"080C".equals(oColumnida)) && (!"0C0B".equals(oColumnida))){
		    sb.append(",");
		  }
		}
		}
        }
        sb.append("]}");

//        if(!columnid.equals("0300")){
//            sb = new StringBuffer("{pageCount:\"1\",destpage:\"1\", columnData:[{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"},{columnid:\"03000400\",fcolumnid:\"030004\",columnposter:\"../images/poster/20120828000005.jpg\",columnname:\"yezi\",columnpath:\"点播>\",subExist:\"0\"}]}");
//        }

//        System.out.println("SSSSSSSSSSSSSSSSSSScolumnid"+columnid+"vod_columnlist.jsp="+sb.toString());
        JspWriter ot = pageContext.getOut();
	    ot.write(sb.toString());
    %>

