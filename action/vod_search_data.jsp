<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.EpgException" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%!
   UserInfo userInfo=null;
%>
<%!
    public boolean checkColumn(String columnid) {
        ColumnOneDataSource columnOneDataSource = new ColumnOneDataSource();
        ColumnValueIn valueIn = (ColumnValueIn) columnOneDataSource.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnid);
        EpgResult result = null;
        try {
            result = columnOneDataSource.getData();
        } catch (EpgException e) {
            e.printStackTrace();  
        }
        Vector vector= (Vector)result.getData();
        if(vector.size()<=0){
            return false;
        }else{
            return true;
        }
    }

%>
<epg:PageController/>
<%
    userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String columnid = request.getParameter("columnid");
    String title = request.getParameter("title");
    String destpage = request.getParameter("destpage");
    String timepath = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    timepath = timepath.replace("action/", "");
    HashMap timeparam = PortalUtils.getParams(timepath, "GBK");
    String isFathercolumnlist = String.valueOf(timeparam.get("isFathercolumnlist"));
    String Fathercolumnlist = String.valueOf(timeparam.get("Search"));

    String AllFathercolumnlist=Fathercolumnlist;//搜索添加点播二级分类

    int destpage1 = 1;
    try{
        destpage1 = Integer.parseInt(destpage);
    }catch (Exception e){
        System.out.println("SSSSSSSSSSSSSSSSdestpage1error!!!!");
    }
    int pageCount =0;
    int totalCount = 0;
    StringBuffer sb = new StringBuffer();
    List searchList = new ArrayList();
    List tempList=new ArrayList();
    EpgResult result = null;
    if (isFathercolumnlist != null && AllFathercolumnlist != null && isFathercolumnlist.equals("1")) {//读取N个一级栏目分支
        String[] columnlist = AllFathercolumnlist.split(",");
        int columnLength = columnlist.length;
        for (int i = 0; i < columnLength; i++) {
            if(checkColumn(columnlist[i])){
                VodSearchDataSource vodDs = new VodSearchDataSource();
                VoDQueryValueIn valueIn = (VoDQueryValueIn) vodDs.getValueIn();
                valueIn.setUserInfo(userInfo);
                valueIn.setColumnId(columnlist[i]);
                valueIn.setNameFirst(title.toLowerCase());
                //valueIn.setNumPerPage(9);
                //valueIn.setPage(destpage1);
                result = vodDs.getData();
                tempList.addAll(result.getDataAsVector());
            }
        }
        //去重
        for(int i = 0; i < tempList.size(); i ++){
            VoDContentInfo vodInfo1 = (VoDContentInfo) tempList.get(i);
            for(int j = i+1; j < tempList.size(); j ++){
                VoDContentInfo vodInfo2 = (VoDContentInfo) tempList.get(j);
                if(vodInfo1.getContentId().equals(vodInfo2.getContentId())){
                    tempList.remove(j);
                    j--;
                }
            }
        }
        totalCount = tempList.size();
        pageCount = (totalCount - 1) / 9 + 1; //总页数
        int starindex = (destpage1 - 1) * 9;//起始值
        int endindex = destpage1 * 9; //结束值
        if (endindex > totalCount) endindex = totalCount;
        searchList = tempList.subList(starindex, endindex);
    } else {
	   // System.out.println("sssssssssssssssssss33333333333333333");
        VodSearchDataSource vodDs = new VodSearchDataSource();
        VoDQueryValueIn valueIn = (VoDQueryValueIn) vodDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnid);
        valueIn.setNameFirst(title.toLowerCase());
        valueIn.setNumPerPage(9);
        valueIn.setPage(destpage1);
        result = vodDs.getData();
        searchList = (List) result.getData();
        HashMap hmPage = result.getDataOut();
        if (hmPage != null) {
            EpgPaging paging = (EpgPaging) hmPage.get("page");
            pageCount = paging.getPageCount();
            totalCount = paging.getTotalCount();
        }
    }
    String oColumnid = "";
    String oProgramid = "";
    String oProgramtype = "";
    String oProgramName = "";
    String oContentCode = "";

    sb.append("{totalCount:"+totalCount+",destpage:"+destpage1+",pageCount:"+pageCount+",vodData:[");
//    sb.append("{vodData:[");
    int length = searchList.size();
	if(length>9){
	   length = 9; 
	}
	System.out.println("sssssssssssssssssss33333333333333333length="+length);
    for (int i = 0; i < length; i++) {
        VoDContentInfo vodInfo = (VoDContentInfo) searchList.get(i);
        oColumnid = vodInfo.getColumnId();
        oProgramid = vodInfo.getProgramId();
        oProgramtype = vodInfo.getProgramType();
        oProgramName = vodInfo.getProgramName();
        oContentCode = vodInfo.getContentId();
        if (i > 0 && i < length) {
            sb.append(",");
        }
        sb.append("{columnid:\"" + oColumnid + "\",");
        sb.append("programid:\"" + oProgramid + "\",");
        sb.append("programname:\"" + oProgramName + "\",");
        sb.append("contentcode:\"" + oContentCode + "\",");
        sb.append("programtype:\"" + oProgramtype + "\"}");
    }
    sb.append("]}");
    //System.out.println("===============sb.toString()============="+sb.toString());

    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

