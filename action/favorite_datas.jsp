<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@ page import="com.zte.iptv.newepg.decorator.BreakPointDecorator" %>
<%@ page import="com.zte.iptv.epg.web.PageQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.util.BreakPointInfo" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtils" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.web.VodContentInfoValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.newepg.decorator.VodSeriesDecorator" %>
<%@ include file="../inc/ad_utils.jsp" %>
<epg:PageController/>
<%!
    public Map getData(String dataSource, PageContext pageContext, String[][] array, boolean isList) {
        try {
            PageController pc = (PageController) pageContext.getAttribute(EpgConstants.CONTROLLER);
            if (pc == null) {
                pc = new PageController();
                pageContext.setAttribute(EpgConstants.CONTROLLER, pc);
            }
            Map paras = null;
            paras = pc.getParameter();
            if (paras == null) {
                paras = new HashMap();
            }
            //循环设置参数
            for (int i = 0; i < array.length; i++) {
                paras.put(array[i][0], array[i][1]);
            }
            pc.addParameter(paras);
            pc.putDataSource("com.zte.iptv.newepg.decorator." + dataSource, null);

            EpgDataSource eds = pc.getDataSource(dataSource);
            EpgResult result = eds.getData();
            if (result.isEmpty()) {
                return null;
            }
            Map dataOut = (Map) result.getDataOut();
            Map data = (Map) dataOut.get(EpgResult.DATA);
            //isList 是判断是不是要获取列表的（多的数据）还是要获取如ChannelOneDecorator等单个数据集
            if (isList) {
                EpgPaging pageData = (EpgPaging) dataOut.get("page");
                pageContext.setAttribute("curPage", new Integer(pageData.getCurPage()));//当前页
                pageContext.setAttribute("pageCount", new Integer(pageData.getPageCount()));//总页数
                pageContext.setAttribute("totalCount", new Integer(pageData.getTotalCount()));//总的数据数
            }
            return data;
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public VoDContentInfo getVodConInf(String columnId, String contentId, PageContext pageContext) {
        VoDContentInfo vodConInf = null;
        try {
            UserInfo userInfoForFav = (UserInfo) pageContext.getSession().getAttribute(EpgConstants.USERINFO);
            VodQueryDataSource vodDs = new VodQueryDataSource();
            VodContentInfoValueIn vodValueIn = (VodContentInfoValueIn) vodDs.getValueIn();
            vodValueIn.setSubjectCode(columnId);
            vodValueIn.setUserInfo(userInfoForFav);
            vodValueIn.setContentCode(contentId);
            EpgResult result = vodDs.getData();
            vodConInf = (VoDContentInfo) result.getData();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return vodConInf;
    }
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
//    System.out.println("==============pagescomein");
    String strDestPage = request.getParameter("destpage");
    int destPage = Utils.toInt(strDestPage, 1);
    int numpage = 10;
    int pageCount = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    try {
        UserFavorite3SDataSource columnDs = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn = (FavoriteQueryValueIn_3S) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setFavoritetype("PROGRAM");
//        valueIn.setNumPerPage(numpage);
//        valueIn.setPage(destPage);

        //分页相关参数
        EpgResult result = columnDs.getData();
//        HashMap hmPage = result.getDataOut();
//        EpgPaging paging = (EpgPaging) hmPage.get("page");
//        pageCount = paging.getPageCount();

        List vColumnData = (Vector) result.getData();
 UserFavorite3SDataSource columnDs1 = new UserFavorite3SDataSource();
        FavoriteQueryValueIn_3S valueIn1 = (FavoriteQueryValueIn_3S) columnDs1.getValueIn();
        valueIn1.setUserInfo(userInfo);
        valueIn1.setFavoritetype("SERIES");
        EpgResult result1 = columnDs1.getData();
        List vColumnData1 = (Vector) result1.getData();
        vColumnData.addAll(vColumnData1);
//        for(int i=0;i<vColumnData.size();i++){
//            FavoriteInfo_3S favoriteInfo = (FavoriteInfo_3S) vColumnData.get(i);
//            VoDContentInfo vodConInf = getVodConInf(favoriteInfo.getSubjectID(), favoriteInfo.getContentID(), pageContext);
//            if(vodConInf.getProgramId()==""){
//              vColumnData.remove(i);
//            }
//        }
        int length = vColumnData.size();
        int starnum = 0;
        int endnum = 0;
        if (length > 0) {
            starnum = 10 * (destPage - 1);
            endnum = 10 * destPage;
        }
        pageCount=(int)(length-1)/10+1;
        if (endnum > length) endnum = length;
        StringBuffer sb = new StringBuffer();
        sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destPage + "\", Data:[");
        if (vColumnData.size() > 0) {
            String columnid = "";
            String programcode = "";
            String seriesid = "";
            String seriesnum = "";
            String programtype = "";
            String programid="";
            for (int i =(int)starnum ; i < (int)endnum; i++) {
                FavoriteInfo_3S favoriteInfo = (FavoriteInfo_3S) vColumnData.get(i);
                columnid = favoriteInfo.getSubjectID();
                programcode = favoriteInfo.getContentID();
                VoDContentInfo vodConInf = getVodConInf(columnid, programcode, pageContext);

                seriesid = String.valueOf(vodConInf.getSeriesProgramCode());
                programtype =vodConInf.getProgramType();
                programid = vodConInf.getProgramId();

                String[][] vodSeriesArray = {{EpgConstants.COLUMN_ID, columnid}, {EpgConstants.SERIES_PROGRAMCODE, seriesid}};
                Map vodSeriesData = getData("VodSeriesDecorator", pageContext, vodSeriesArray, false);
                Vector seriescode = (Vector) vodSeriesData.get("ProgramId");
                Vector Seriesnum = (Vector) vodSeriesData.get("Seriesnum");
                String tempprogramId = vodConInf.getProgramId();
                for (int j = 0; j < seriescode.size(); j++) {
                    if (seriescode.get(j).equals(tempprogramId)) {
                        seriesnum = String.valueOf(Seriesnum.get(j));
                        programtype="1";
                        programid=vodConInf.getSeriesProgramCode();
                    }
                }
                if("".equals(seriesid))seriesnum="0";
                String normalposter=vodConInf.getNormalPoster();
                if(normalposter.indexOf("defaultposter_n")!=-1 || normalposter=="")normalposter="images/vod/post.png";
                sb.append("{programid:\"" + programid + "\",");
                sb.append("programtype:\"" + programtype+ "\",");
                sb.append("programname:\"" + formatName(vodConInf.getProgramName()) + "\",");
                sb.append("normalposter:\"" + normalposter + "\",");
                sb.append("columnid:\"" + columnid + "\",");
                sb.append("selectIndex:\"" + i + "\",");
                sb.append("Seriesnum:\"" + seriesnum + "\",");
                sb.append("vSeriesprogramcode:\"" + vodConInf.getSeriesProgramCode() + "\",");
                sb.append("contentcode:\"" + favoriteInfo.getContentID() + "\"},");                     
            }
        }

//        String columnid = "0020";
//        String programcode = "123456";
//        String seriesid = "1223213213213213";
//        String seriesnum = "";
//        String programtype = "1";
//        String programid = "1213123";
//        String normalposter = "";
//        String getProgramName = "saaaaaaaaaaa";
//        for (int i = 0; i < 8; i++) {
//            if (normalposter.indexOf("defaultposter_n") != -1 || normalposter == "")
//                normalposter = "images/vod/post.png";
//            sb.append("{programid:\"" + programid + "\",");
//            sb.append("programtype:\"" + programtype + "\",");
//            sb.append("programname:\"" + getProgramName + "\",");
//            sb.append("normalposter:\"" + normalposter + "\",");
//            sb.append("columnid:\"" + columnid + "\",");
//            sb.append("selectIndex:\"" + i + "\",");
//            sb.append("Seriesnum:\"" + seriesnum + "\",");
//            sb.append("vSeriesprogramcode:\"" + seriesid + "\",");
//            sb.append("contentcode:\"" + seriesid + "\"},");
//        }
        sb.append("]}");
        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());
//        System.out.println("===========================sbsbsb" + sb.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
%>