<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteValueIn_3S" %>
<%@ page import="com.zte.iptv.newepg.datasource.DoDelFavorite3SDataSource" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="com.zte.iptv.epg.cache.engine.memory.HashMap" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.datasource.UserFavorite3SDataSource" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    String delall = "";
    if (request.getParameter("delall") != null) {
        delall = request.getParameter("delall");
    }

    System.out.println("SSSSSSSSSSSSSSSSSSSSSSSSchannel_favorite_del.reqeust="+request.getQueryString());

    int count =Integer.parseInt(request.getParameter("count"));
    String favorateTitleL = request.getParameter("FavoriteTitle");
    String contentIdL = request.getParameter("ContentID");
    String subjectIdL = request.getParameter("SubjectID");
    String[] listTitle = favorateTitleL.split("__");
    String[] listSubject = subjectIdL.split("__");
    String[] listContent = contentIdL.split("__");
    String favorateTitle = "";
    String contentId = "";
    String subjectId = "";
     int dellCount = 0;
    int failCount = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    if (!delall.equals("")) {
        try {
            int destPage = 1;
            int numpage = 20;
    //fan----30130909
 //           UserFavorite3SDataSource columnDas = new UserFavorite3SDataSource();
  //          FavoriteQueryValueIn_3S valueIn = (FavoriteQueryValueIn_3S) columnDas.getValueIn();
//            valueIn.setUserInfo(userInfo);
 //           valueIn.setFavoritetype("CHANNEL");
 //           valueIn.setNumPerPage(numpage);
//            valueIn.setPage(destPage);
            //分页相关参数
//            EpgResult results = columnDas.getData();
 //           List vColumnDatas = (Vector) results.getData();
            StringBuffer sb = new StringBuffer();
//            int flag = 0;
//            if (vColumnDatas.size() > 0) {
            if (listContent!=null && listContent.length>0) {//fan----20130909
//                String contentIds = "";
//                String subjectIds = "";
//                String favorateTitles = "";
                for (int i = 0; i < listContent.length; i++) {//fan---20130909
//                    FavoriteInfo_3S favoriteInfo = (FavoriteInfo_3S) vColumnDatas.get(i);
//                    subjectIds = favoriteInfo.getSubjectID();
//                    contentIds = favoriteInfo.getContentID();
//                    favorateTitles = favoriteInfo.getFavoriteTitle();
                    DoDelFavorite3SDataSource ds = new DoDelFavorite3SDataSource();
                    FavoriteValueIn_3S valueIns = (FavoriteValueIn_3S) ds.getValueIn();
                    valueIns.setDaUserID(userInfo.getUserId());
                    valueIns.setDaUserFlag("IPTV");
                    valueIns.setBizType("2");
                    valueIns.setFavoriteTitle("");
                    valueIns.setFavoriteType("CHANNEL");
                    valueIns.setContentID(listContent[i]);
                    valueIns.setSubjectID(listSubject[i]);
                    valueIns.setFavoriteAction("CANCEL");
                    valueIns.setUserInfo(userInfo);
                    Result result = ds.execute();
                    int f = result.getFlag();
                    if (f == 0) {
                        dellCount++;
                    }
                }
                  failCount = listContent.length  - dellCount;
            }
            sb.append("{dellCount:\"" + dellCount + "\",failCount:\"" + failCount + "\"}");

            JspWriter ot = pageContext.getOut();
            ot.write(sb.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        int flag = 0;
        if(count>0){
        for (int i = 0; i < listContent.length; i++) {

            subjectId = listSubject[i];
            contentId = listContent[i];
            favorateTitle = listTitle[i];
            DoDelFavorite3SDataSource ds = new DoDelFavorite3SDataSource();
            FavoriteValueIn_3S valueIn = (FavoriteValueIn_3S) ds.getValueIn();
            valueIn.setDaUserID(userInfo.getUserId());
            valueIn.setDaUserFlag("IPTV");
            valueIn.setBizType("2");
            valueIn.setFavoriteTitle(favorateTitle);
            valueIn.setFavoriteType("CHANNEL");
            valueIn.setContentID(contentId);
            valueIn.setSubjectID(subjectId);
            valueIn.setFavoriteAction("CANCEL");
            valueIn.setUserInfo(userInfo);
            Result result = ds.execute();
            int f = result.getFlag();
            if (f == 0) {
                        dellCount++;
             }
        }
           failCount = listContent.length - dellCount;
      }else{
           failCount=0; 
        }

        StringBuffer sb = new StringBuffer();
          sb.append("{dellCount:\"" + dellCount + "\",failCount:\"" + failCount + "\"}");
        System.out.println("===========sb"+sb.toString());
        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());
    }
%>

