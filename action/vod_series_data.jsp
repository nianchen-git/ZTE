<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodSeriesDataSource" %>
<%@ page import="com.zte.iptv.epg.web.SearchResult" %>
<%@ page import="com.zte.iptv.epg.content.VoDQuery" %>
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
<epg:PageController/>
<%
    session.setAttribute("AuthorizationIDsession", "0");
    UserInfo userInfo = (UserInfo) pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);

    String strColumnid = request.getParameter("columnid");
    String strProgramid = request.getParameter("programid");

    int pageCount=1;
    VodSeriesDataSource seriesNumDs = new VodSeriesDataSource();
    VoDQueryValueIn seriesNumValueIn = (VoDQueryValueIn) seriesNumDs.getValueIn();
    seriesNumValueIn.setUserInfo(userInfo);
    seriesNumValueIn.setColumnId(strColumnid);
    seriesNumValueIn.setSeriesprogramcode(strProgramid);
    seriesNumValueIn.setNumPerPage(40);
    seriesNumValueIn.setPage(destpage1);
    seriesNumValueIn.setVoDType(com.zte.iptv.epg.util.CodeBook.VOD_TYPE_SERIES_Single);
    seriesNumValueIn.setOrderMode(com.zte.iptv.epg.util.CodeBook.SORT_TYPE_SERIESNUM);
    EpgResult result = seriesNumDs.getData();
     //分页相关数据
    HashMap hmPage = result.getDataOut();
    EpgPaging paging = (EpgPaging) hmPage.get("page");
    pageCount = paging.getPageCount();



    SearchResult seriesNumResult = VoDQuery.getInstance().getVoDContent(seriesNumValueIn);
    Vector vseriesNumData = seriesNumResult.getItemList();
    StringBuffer sb = new StringBuffer();
       //连续剧的单集播放url
    String seriesNumColumnid="";
    String seriesNumProgramId="";
    String SeriesProgramCode="";
    String seriesContentID="";
    String programType="";
    int seriesnum=0;
    int length = vseriesNumData.size();
    sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\",totalCount:\""+paging.getTotalCount()+"\", seriesdata:[");
    for (int i = 0; i < length; i++) {
         VoDContentInfo seriesNumConInf = (VoDContentInfo) vseriesNumData.get(i);
         seriesNumColumnid = seriesNumConInf.getColumnId();
         seriesNumProgramId = seriesNumConInf.getProgramId();
         SeriesProgramCode =  seriesNumConInf.getSeriesProgramCode();
         programType= seriesNumConInf.getProgramType();
         seriesContentID=seriesNumConInf.getContentId();
         seriesnum =  seriesNumConInf.getSeriesnum();
        sb.append("{columnid:\"" + seriesNumColumnid + "\",");
        sb.append("programid:\"" + seriesNumProgramId + "\",");
        sb.append("SeriesProgramCode:\"" + SeriesProgramCode + "\",");
        sb.append("programType:\"" + programType + "\",");
        sb.append("contentcode:\"" + seriesContentID + "\",");
        sb.append("seriesnum:\"" + seriesnum + "\"},");
    }
    sb.append("]}");

//    System.out.println("===================sb.toString()==============="+sb.toString());
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

