<%@page contentType="text/html; charset=GBK" isELIgnored="false"%>
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

<%@ page import="java.util.Map" %>
<%@ taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>
<%@ include file="get_columnPath.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

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
    String columnid = String.valueOf(request.getParameter("columnid"));
   // String conditions = "parentcode=0201";
    int pageCount = 8;//每页显示条数
    //int destpage = 1;//指定当前页数（从1开始），默认是1，即第一页。
    String destpage = request.getParameter("destpage");

    String orderNew="sortnum asc,onlinetime desc";
    int destpage1 = 1;
    if (destpage != null && !"".equals(destpage)) {
        try {
            destpage1 = Integer.parseInt(destpage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    StringBuffer jsonBuffer = new StringBuffer();
		String vodSql = "columncode='"+ columnid+ "' and (programtype=1 or programtype=14) and mediaservices&1=1";
%>
<epg:PageController/>
<ex:params var="inputHash">
    <ex:param name="columnavailable" value="<%=columnid%>"/>
</ex:params>
<ex:search tablename="user_vod" fields="*" order="<%=orderNew%>"
           inputparams="${inputHash}" condition="<%=vodSql%>" curpagenum="<%=destpage1%>" pagecount="<%=pageCount%>" var="vodData">
<%
	UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    //xjf add for 4k 
	if(columnid == "1604" ) {  //0100 is the 4k columnid
		userInfo.setMediaservices(499);
	}
	    int totalpage = (Integer) pageContext.getAttribute("pagenums");
    long totalcount =  (Long)pageContext.getAttribute("totalcount");
	List<Map> vodData = (List<Map>) pageContext.getAttribute("vodData");	
        jsonBuffer.append("{vodData:[");
        for (int i = 0; i < vodData.size(); i++) {
            Map column = vodData.get(i);
            String columncode = (String)column.get("columncode");
           // columnpath = getColumnPath(parentcode, userInfo);
            String programname="";
            String actor="";
            String desc="";
            String contentcode="";
            String programtype="";
            String normalposter="";
            //5.0接口取得数据
            jsonBuffer.append("{columnid:\"" + columncode + "\"");
            jsonBuffer.append(",programid:\"" + column.get("programcode")+ "\"");
            jsonBuffer.append(",programname:\"" + formatName(column.get("programname")) + "\"");
            jsonBuffer.append(",actor:\"" + formatName(column.get("actor")) + "\"");
            jsonBuffer.append(",desc:\"" + formatName(column.get("description")) + "\"");
            jsonBuffer.append(",contentcode:\"" +column.get("contentcode") + "\"");
            jsonBuffer.append(",programtype:\"" +column.get("programtype") + "\"");
            jsonBuffer.append(",normalposter:\"" + column.get("poster1") + "\"}");
            if (i < vodData.size() - 1) {
                jsonBuffer.append(",");
            }
        }
        jsonBuffer.append("],pageCount:\"" + totalpage + "\"");
        jsonBuffer.append(",destpage:\"" + destpage + "\"");
    %>
</ex:search>	
<%
    jsonBuffer.append("}");

    JspWriter ot = pageContext.getOut();
    ot.write(jsonBuffer.toString());
%>

