<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteValueIn_3S" %>
<%@ page import="com.zte.iptv.epg.web.IsFavorited3SQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
        String favorateTitle = request.getParameter("FavoriteTitle");
        String channelid = request.getParameter("channelid");
    favorateTitle = java.net.URLDecoder.decode(favorateTitle == null ? "" : favorateTitle,"UTF-8");
//    favorateTitle=favorateTitle+"&"+channelid;
    String contentId = request.getParameter("ContentID");
    String subjectId = request.getParameter("SubjectID");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    int flag = 0;
     UserFavorite3SDataSource columnDs = new UserFavorite3SDataSource();
    FavoriteQueryValueIn_3S valueIn1 = (FavoriteQueryValueIn_3S) columnDs.getValueIn();
    valueIn1.setUserInfo(userInfo);
    valueIn1.setFavoritetype("CHANNEL");
    valueIn1.setNumPerPage(20);
    valueIn1.setPage(1);

    //分页相关参数
    EpgResult result1 = columnDs.getData();
    HashMap hmPage = result1.getDataOut();
    EpgPaging paging = (EpgPaging) hmPage.get("page");
    int totalCount = paging.getTotalCount();
    DoCheckFavoritedVod3SDataSource checkds = new DoCheckFavoritedVod3SDataSource();
    IsFavorited3SQueryValueIn checkvalueIn = (IsFavorited3SQueryValueIn) checkds.getValueIn();
    checkvalueIn.setColumnId(subjectId);
   // checkvalueIn.setContent_Code(contentId);
    checkvalueIn.setContent_Code(channelid);//fan---20130829
    checkvalueIn.setContent_Type("CHANNEL");
    checkvalueIn.setsDauserId(userInfo.getUserId());
    checkvalueIn.setUserInfo(userInfo);
    Result rs = checkds.execute();
    FavoriteInfo_3S favorite_3S = (FavoriteInfo_3S) rs.getInfo();
    if(totalCount>=20){
         flag=3;
    }
    else if (favorite_3S != null) {
        flag = 2;
    } else {
        DoAddFavorite3SDataSource ds = new DoAddFavorite3SDataSource();
        FavoriteValueIn_3S valueIn = (FavoriteValueIn_3S) ds.getValueIn();
        valueIn.setDaUserFlag("IPTV");
        valueIn.setBizType("2");
        valueIn.setFavoriteTitle(favorateTitle);
        valueIn.setFavoriteType("CHANNEL");
      //  valueIn.setContentID(contentId);
        valueIn.setContentID(channelid);//fan-----20130829
        valueIn.setSubjectID(subjectId);
        valueIn.setFavoriteAction("FAVORITE");
        valueIn.setUserInfo(userInfo);
        Result result = ds.execute();
        flag = result.getFlag();
    }
    StringBuffer sb = new StringBuffer();
    sb.append("{requestflag:\"" + flag + "\"}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

