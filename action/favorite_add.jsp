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
    //ɾ���ղ�
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
        //����ղ�֮ǰ��Ҫ���vod�ղ��Ƿ��Ѵ�����
        UserFavorite3SDataSource columnDs = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1 = (FavoriteQueryValueIn_3S) columnDs.getValueIn();
        valueIn1.setUserInfo(userInfo);
        valueIn1.setFavoritetype("PROGRAM");
        valueIn1.setNumPerPage(20); //�ղ����޸��������Ӧ�ô������ļ���ȡ
        valueIn1.setPage(1);
        //��ҳ��ز���
        EpgResult result1 = columnDs.getData();
        HashMap hmPage = result1.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        int totalCount = paging.getTotalCount();  //��ȡ�Ѿ��ղص��ܼ�¼��

   /*****************************���ӹ�������������ļ��**************************/
        UserFavorite3SDataSource columnDsseries = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1series = (FavoriteQueryValueIn_3S) columnDsseries.getValueIn();
        valueIn1series.setUserInfo(userInfo);
        valueIn1series.setFavoritetype("SERIES");
        valueIn1series.setNumPerPage(20); //�ղ����޸��������Ӧ�ô������ļ���ȡ
        valueIn1series.setPage(1);
        //��ҳ��ز���
        EpgResult result1series = columnDsseries.getData();
        HashMap hmPageseries = result1series.getDataOut();
        EpgPaging pagingseries = (EpgPaging) hmPageseries.get("page");
        int totalCountseries = pagingseries.getTotalCount();  //��ȡ�Ѿ��ղص��ܼ�¼��

        System.out.println("SSSSSSSSSSSSSSSfavorite_add_totalCount="+totalCount);
        System.out.println("SSSSSSSSSSSSSSSfavorite_add_totalCountseries="+totalCountseries);
//        (syl)(���ص���)
//        totalCount = totalCount+totalCountseries;
        if (totalCount >= 20) {//�ղ��Ѵ�����
            flag = 3;
        } else { //û�дﵽ�ղ����ޣ�����ղ�
            //����ղ�֮ǰ��Ҫ����vod�Ƿ��Ѿ��ղ�
            DoCheckFavoritedVod3SDataSource checkds = new DoCheckFavoritedVod3SDataSource();
            IsFavorited3SQueryValueIn checkvalueIn = (IsFavorited3SQueryValueIn) checkds.getValueIn();
            checkvalueIn.setColumnId(subjectId);
            checkvalueIn.setContent_Code(contentId);
            checkvalueIn.setContent_Type("PROGRAM");
            checkvalueIn.setsDauserId(userInfo.getUserId());
            checkvalueIn.setUserInfo(userInfo);
            Result rs = checkds.execute();
            FavoriteInfo_3S favorite_3S = (FavoriteInfo_3S) rs.getInfo();
            if (favorite_3S != null) {//�Ѿ��ղع���
                flag = 2;
            } else { //û���ղع�����ղ�
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
     //������֮���״̬���,0:��ӻ�ɾ���ɹ�(��ӻ���ɾ������ҳ���������)��1����ӻ�ɾ��ʧ�ܣ�2����Ŀ���ղأ�3���ղ��Ѵ�����
    sb.append("{requestflag:\"" + flag + "\"}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

