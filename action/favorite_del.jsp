<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteValueIn_3S" %>
<%@ page import="com.zte.iptv.newepg.datasource.DoDelFavorite3SDataSource" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.zte.iptv.newepg.datasource.UserFavorite3SDataSource" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    String type = request.getParameter("type");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    StringBuffer sb = new StringBuffer();
    int dellCount = 0;
    int failCount = 0;

    if ("all".equals(type)) {
        int destPage = 1;
        int numpage = 20;
        UserFavorite3SDataSource columnDas = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1 = (FavoriteQueryValueIn_3S) columnDas.getValueIn();
        valueIn1.setUserInfo(userInfo);
        valueIn1.setFavoritetype("PROGRAM");
        valueIn1.setNumPerPage(numpage);
        valueIn1.setPage(destPage);
        //分页相关参数
        EpgResult results = columnDas.getData();
        List vColumnDatas = (Vector) results.getData();
  /*****************************增加关于连续剧个数的检查**************************/
        UserFavorite3SDataSource columnDasseries = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1series = (FavoriteQueryValueIn_3S) columnDasseries.getValueIn();
        valueIn1series.setUserInfo(userInfo);
        valueIn1series.setFavoritetype("SERIES");
        valueIn1series.setNumPerPage(numpage);
        valueIn1series.setPage(destPage);
        //分页相关参数
        EpgResult resultsseries = columnDasseries.getData();
        List vColumnDatasseries = (Vector) resultsseries.getData();

        if(vColumnDatas!=null){
//            vColumnDatas.addAll(vColumnDatasseries);     (syl)(对连续剧的查询已经包含在program中了，若添加进去会导致个数不对)
        }else{
            vColumnDatas = vColumnDatasseries;
        }
        if (vColumnDatas.size() > 0) {
            String contentIds = "";
            String subjectIds = "";
            String favorateTitles = "";
            for (int i = 0; i < vColumnDatas.size(); i++) {
                FavoriteInfo_3S favoriteInfo = (FavoriteInfo_3S) vColumnDatas.get(i);
                subjectIds = favoriteInfo.getSubjectID();
                contentIds = favoriteInfo.getContentID();
                favorateTitles = favoriteInfo.getFavoriteTitle();
                DoDelFavorite3SDataSource ds = new DoDelFavorite3SDataSource();
                FavoriteValueIn_3S valueIns = (FavoriteValueIn_3S) ds.getValueIn();
                valueIns.setDaUserID(userInfo.getUserId());
                valueIns.setDaUserFlag("IPTV");
                valueIns.setBizType("2");
                valueIns.setFavoriteTitle(favorateTitles);
                valueIns.setFavoriteType("PROGRAM");
                valueIns.setContentID(contentIds);
                valueIns.setSubjectID(subjectIds);
                valueIns.setFavoriteAction("CANCEL");
                valueIns.setUserInfo(userInfo);
                Result result = ds.execute();
                int f = result.getFlag();
                if (f == 0) {
                    dellCount++;
                }
            }
        }
        failCount = vColumnDatas.size() - dellCount;
    } else {
        String favorateTitle = request.getParameter("FavoriteTitle");
        favorateTitle = URLDecoder.decode(favorateTitle, "GBK");
        String contentId = request.getParameter("ContentID");
        String subjectId = request.getParameter("SubjectID");
        String[] listTitle = favorateTitle.split("__");
        String[] listContentid = contentId.split("__");
        String[] listSubject = subjectId.split("__");
        for (int i = 0; i < listTitle.length; i++) {
            DoDelFavorite3SDataSource ds = new DoDelFavorite3SDataSource();
            FavoriteValueIn_3S valueIn = (FavoriteValueIn_3S) ds.getValueIn();
            valueIn.setDaUserID(userInfo.getUserId());
            valueIn.setDaUserFlag("IPTV");
            valueIn.setBizType("2");
            valueIn.setFavoriteTitle(listTitle[i]);
            valueIn.setFavoriteType("PROGRAM");
            valueIn.setContentID(listContentid[i]);
            valueIn.setSubjectID(listSubject[i]);
            valueIn.setFavoriteAction("CANCEL");
            valueIn.setUserInfo(userInfo);
            Result result = ds.execute();
            int flag1 = result.getFlag();
            if (flag1 == 0) {
                dellCount++;
            }
        }
        failCount = listContentid.length - dellCount;
    }
    sb.append("{dellCount:\"" + dellCount + "\",failCount:\"" + failCount + "\"}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

