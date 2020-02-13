<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
   <%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.ArrayList" %>
  <epg:PageController />
<%!
    public String getMixno(String mixno){
        if(mixno.length()<3){
           mixno="0"+mixno;
           return getMixno(mixno);
        }else{
           return mixno;
        }
    }
%>
<%
    String strDestPage = request.getParameter("destpage");
    int destPage = Utils.toInt(strDestPage, 1);
    int numpage = 20;
    int pageCount = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    try {
        UserFavorite3SDataSource columnDas = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn = (FavoriteQueryValueIn_3S) columnDas.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setFavoritetype("CHANNEL");
        valueIn.setNumPerPage(numpage);
        valueIn.setPage(destPage);

        //分页相关参数
        EpgResult results = columnDas.getData();
        HashMap hmPage = results.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        pageCount = paging.getPageCount();

        List vColumnDatas = (Vector) results.getData();
        StringBuffer sb = new StringBuffer();
        sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destPage + "\", Data:[");
        if (vColumnDatas.size() > 0) {
            String columnids="";
            String programcode = "";
            String favoriteTitle="";
            for (int i = 0; i < vColumnDatas.size(); i++) {
                FavoriteInfo_3S favoriteInfo = (FavoriteInfo_3S) vColumnDatas.get(i);
                columnids = favoriteInfo.getSubjectID();
                programcode = favoriteInfo.getContentID();
                favoriteTitle = favoriteInfo.getFavoriteTitle();
                sb.append("{columnid:\"" + columnids + "\",");
                sb.append("programid:\"" + programcode + "\",");
                sb.append("selectIndex:\"" + i + "\",");
                sb.append("contentcode:\"" + programcode + "\",");
                sb.append("vSeriesprogramcode:\"" + programcode + "\",");
                sb.append("programname:\"" + favoriteTitle + "\"},");
            }
        }
//        String columnids = "0202";
//        String programcode = "1212121";
//        String favoriteTitle = "channelname";
//        for (int i = 0; i < 20; i++) {
//            sb.append("{columnid:\"" + columnids + "\",");
//            sb.append("programid:\"" + programcode + "\",");
//            sb.append("selectIndex:\"" + i + "\",");
//            sb.append("contentcode:\"" + programcode + "\",");
//            sb.append("vSeriesprogramcode:\"" + programcode + "\",");
//            sb.append("programname:\"" + favoriteTitle + "\"},");
//        }
        sb.append("]}");
        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());
//        System.out.println("=============sssssssssssssssssssssf"+sb.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
%>