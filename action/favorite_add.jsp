<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteValueIn_3S" %>
<%@ page import="com.zte.iptv.epg.web.IsFavorited3SQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    String type = request.getParameter("type");
    String favorateTitle = request.getParameter("FavoriteTitle");
    String contentId = request.getParameter("ContentID");
    String subjectId = request.getParameter("SubjectID");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    int flag = 0;
    //删除收藏
    if ("dell".equals(type)) {
        DoDelFavorite3SDataSource ds = new DoDelFavorite3SDataSource();
        FavoriteValueIn_3S valueIn = (FavoriteValueIn_3S) ds.getValueIn();
        valueIn.setDaUserID(userInfo.getUserId());
        valueIn.setDaUserFlag("IPTV");
        valueIn.setBizType("2");
        valueIn.setFavoriteTitle(favorateTitle);
        valueIn.setFavoriteType("PROGRAM");
        valueIn.setContentID(contentId);
        valueIn.setSubjectID(subjectId);
        valueIn.setFavoriteAction("CANCEL");
        valueIn.setUserInfo(userInfo);
        Result result = ds.execute();
        flag = result.getFlag();
    } else {
        //添加收藏之前需要检查vod收藏是否已达上线
        UserFavorite3SDataSource columnDs = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1 = (FavoriteQueryValueIn_3S) columnDs.getValueIn();
        valueIn1.setUserInfo(userInfo);
        valueIn1.setFavoritetype("PROGRAM");
        valueIn1.setNumPerPage(20); //收藏上限个数，这个应该从配置文件读取
        valueIn1.setPage(1);
        //分页相关参数
        EpgResult result1 = columnDs.getData();
        HashMap hmPage = result1.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        int totalCount = paging.getTotalCount();  //获取已经收藏的总记录数

   /*****************************增加关于连续剧个数的检查**************************/
        UserFavorite3SDataSource columnDsseries = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1series = (FavoriteQueryValueIn_3S) columnDsseries.getValueIn();
        valueIn1series.setUserInfo(userInfo);
        valueIn1series.setFavoritetype("SERIES");
        valueIn1series.setNumPerPage(20); //收藏上限个数，这个应该从配置文件读取
        valueIn1series.setPage(1);
        //分页相关参数
        EpgResult result1series = columnDsseries.getData();
        HashMap hmPageseries = result1series.getDataOut();
        EpgPaging pagingseries = (EpgPaging) hmPageseries.get("page");
        int totalCountseries = pagingseries.getTotalCount();  //获取已经收藏的总记录数

        System.out.println("SSSSSSSSSSSSSSSfavorite_add_totalCount="+totalCount);
        System.out.println("SSSSSSSSSSSSSSSfavorite_add_totalCountseries="+totalCountseries);
//        (syl)(相重叠了)
//        totalCount = totalCount+totalCountseries;
        if (totalCount >= 20) {//收藏已达上线
            flag = 3;
        } else { //没有达到收藏上限，添加收藏
            //添加收藏之前需要检查此vod是否已经收藏
            DoCheckFavoritedVod3SDataSource checkds = new DoCheckFavoritedVod3SDataSource();
            IsFavorited3SQueryValueIn checkvalueIn = (IsFavorited3SQueryValueIn) checkds.getValueIn();
            checkvalueIn.setColumnId(subjectId);
            checkvalueIn.setContent_Code(contentId);
            checkvalueIn.setContent_Type("PROGRAM");
            checkvalueIn.setsDauserId(userInfo.getUserId());
            checkvalueIn.setUserInfo(userInfo);
            Result rs = checkds.execute();
            FavoriteInfo_3S favorite_3S = (FavoriteInfo_3S) rs.getInfo();
            if (favorite_3S != null) {//已经收藏过了
                flag = 2;
            } else { //没有收藏过添加收藏
                DoAddFavorite3SDataSource ds = new DoAddFavorite3SDataSource();
                FavoriteValueIn_3S valueIn = (FavoriteValueIn_3S) ds.getValueIn();
                valueIn.setDaUserFlag("IPTV");
                valueIn.setBizType("2");
                valueIn.setFavoriteTitle(favorateTitle);
                valueIn.setFavoriteType("PROGRAM");
                valueIn.setContentID(contentId);
                valueIn.setSubjectID(subjectId);
                valueIn.setFavoriteAction("FAVORITE");
                valueIn.setUserInfo(userInfo);
                Result result = ds.execute();
                flag = result.getFlag();
            }
        }
    }
    StringBuffer sb = new StringBuffer();
     //将操作之后的状态输出,0:添加或删除成功(添加或者删除根据页面操作而定)；1：添加或删除失败；2：节目已收藏；3：收藏已达上线
    sb.append("{requestflag:\"" + flag + "\"}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

