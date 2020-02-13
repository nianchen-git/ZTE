<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtils" %>
<%@ page import="java.net.URLDecoder" %>
<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
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
            VodQueryDataSource vodDs = new com.zte.iptv.newepg.datasource.VodQueryDataSource();
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
%>

<%
    String type = request.getParameter("type");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    StringBuffer sb = new StringBuffer();

    String favorateTitle = "";
    String contentId = "";
    String subjectId = "";
    String seriesids = "";
    int dellCount = 0;
    int failCount = 0;

    System.out.println("SSSSSSSSSSSSSSSSSSSSSSSSSbookpoint_del="+request.getQueryString());

    if (type.equals("all")) {
        try {
            Vector vProgramName = new Vector();
            Vector vColumnId = new Vector();
            Vector vProgramcode = new Vector();
            Vector vProgramtype = new Vector();
            Vector vBreakpoint = new Vector();
            Vector vSeriesprogramcode = new Vector();
            Map bookMarkDataOut = getData(getEpgResult("BreakPoint3SDecorator", pageContext));
            if (bookMarkDataOut != null) {
                vProgramName = (Vector) bookMarkDataOut.get("Marktitle");
                vColumnId = (Vector) bookMarkDataOut.get("Subjectid");
                vProgramcode = (Vector) bookMarkDataOut.get("Contentid");
                vProgramtype = (Vector) bookMarkDataOut.get("Programtype");
                vBreakpoint = (Vector) bookMarkDataOut.get("Breakpoint");
                vSeriesprogramcode = (Vector) bookMarkDataOut.get("Seriesid");
                int totalcount = vProgramName.size(); //总记录数
                int starnum = 0;
                int endnum = totalcount;
                if (vProgramName.size() > 0) {
                    String programName = "";
                    String columnId = "";
                    String programId = "";
                    String seriesid = "";
                    String seriesnum = "";
                    for (int i = 0; i < endnum; i++) {
                        programName = (String) vProgramName.get(i);
                        columnId = String.valueOf(vColumnId.get(i));
                        programId = String.valueOf(vProgramcode.get(i));

                        seriesid = String.valueOf(vSeriesprogramcode.get(i));

                        String[][] vodSeriesArray = {{EpgConstants.COLUMN_ID, columnId}, {EpgConstants.SERIES_PROGRAMCODE, seriesid}};
                        Map vodSeriesData = getData("VodSeriesDecorator", pageContext, vodSeriesArray, false);
                        Vector seriescode = (Vector) vodSeriesData.get("ProgramId");
                        Vector Seriesnum = (Vector) vodSeriesData.get("Seriesnum");
                        for (int j = 0; j < seriescode.size(); j++) {
                            if (seriescode.get(j).equals(programId)) {
                                seriesnum = String.valueOf(Seriesnum.get(j));
                            }
                        }
                        VoDContentInfo vodConInf = getVodConInf(columnId, programId, pageContext);


                        DealBP3SDataSource dealbpDa = new DealBP3SDataSource();
                        DealBPValueIn3S valueInbp = (DealBPValueIn3S) dealbpDa.getValueIn();
                        valueInbp.setDaUserID(userInfo.getUserId());
                        valueInbp.setDaUserFlag("IPTV");
                        if (vodConInf.getProgramType().equals("100")) {
                            valueInbp.setSeriesID(seriesid);
                        } else {
                            valueInbp.setSeriesID("0");
                        }
                        valueInbp.setMarkTitle(programName);
                        valueInbp.setMarkType("PROGRAM");
                        valueInbp.setContentID(vodConInf.getContentId());
                        valueInbp.setSubjectID(columnId);
                        valueInbp.setUserInfo(userInfo);
                        Result result = dealbpDa.execute();
                        int f = result.getFlag();
                        if (f == 0) {
                            dellCount++;
                        }
                    }
                }
            }
            sb.append("{dellCount:\"" + dellCount + "\",failCount:\"" + failCount + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
        }
 }else if(type.equals("last")){
        int f = -1;
        Vector vProgramName = new Vector();
        Vector vColumnId = new Vector();
        Vector vProgramcode = new Vector();
        Vector vProgramtype = new Vector();
        Vector vBreakpoint = new Vector();
        Vector vSeriesprogramcode = new Vector();
        Map bookMarkDataOut = getData(getEpgResult("BreakPoint3SDecorator", pageContext));
        if (bookMarkDataOut != null) {
            vProgramName = (Vector) bookMarkDataOut.get("Marktitle");
            vColumnId = (Vector) bookMarkDataOut.get("Subjectid");
            vProgramcode = (Vector) bookMarkDataOut.get("Contentid");
            vProgramtype = (Vector) bookMarkDataOut.get("Programtype");
            vBreakpoint = (Vector) bookMarkDataOut.get("Breakpoint");
            vSeriesprogramcode = (Vector) bookMarkDataOut.get("Seriesid");
//            int totalcount = vProgramName.size(); //总记录数
            if (vProgramName.size() > 0) {
                String programName = "";
                String columnId = "";
                String programId = "";
                String seriesid = "";
                String seriesnum = "";
                int i = vProgramName.size()-1;
                programName = (String) vProgramName.get(i);
                columnId = String.valueOf(vColumnId.get(i));
                programId = String.valueOf(vProgramcode.get(i));

                seriesid = String.valueOf(vSeriesprogramcode.get(i));

                String[][] vodSeriesArray = {{EpgConstants.COLUMN_ID, columnId}, {EpgConstants.SERIES_PROGRAMCODE, seriesid}};
                Map vodSeriesData = getData("VodSeriesDecorator", pageContext, vodSeriesArray, false);
                Vector seriescode = (Vector) vodSeriesData.get("ProgramId");
                Vector Seriesnum = (Vector) vodSeriesData.get("Seriesnum");
                for (int j = 0; j < seriescode.size(); j++) {
                    if (seriescode.get(j).equals(programId)) {
                        seriesnum = String.valueOf(Seriesnum.get(j));
                    }
                }
                VoDContentInfo vodConInf = getVodConInf(columnId, programId, pageContext);


                DealBP3SDataSource dealbpDa = new DealBP3SDataSource();
                DealBPValueIn3S valueInbp = (DealBPValueIn3S) dealbpDa.getValueIn();
                valueInbp.setDaUserID(userInfo.getUserId());
                valueInbp.setDaUserFlag("IPTV");
                if (vodConInf.getProgramType().equals("100")) {
                    valueInbp.setSeriesID(seriesid);
                } else {
                    valueInbp.setSeriesID("0");
                }
                valueInbp.setMarkTitle(programName);
                valueInbp.setMarkType("PROGRAM");
                valueInbp.setContentID(vodConInf.getContentId());
                valueInbp.setSubjectID(columnId);
                valueInbp.setUserInfo(userInfo);
                Result result = dealbpDa.execute();
                f = result.getFlag();
            }
        }
        sb.append("{flag:"+f+"}");
    } else {
        String favorateTitleL = request.getParameter("FavoriteTitle");
        favorateTitle = URLDecoder.decode(favorateTitle, "GBK");
        String contentIdL = request.getParameter("ContentID");
        String subjectIdL = request.getParameter("SubjectID");
        String seriesidL = request.getParameter("seriesids");
        String[] listTitle = favorateTitleL.split("__");
        String[] listSubject = subjectIdL.split("__");
        String[] listContent = contentIdL.split("__");
        String[] listSeriesid = seriesidL.split("__");
        for (int i = 0; i < listContent.length; i++) {
            subjectId = listSubject[i];
            contentId = listContent[i];
            favorateTitle = listTitle[i];
            seriesids = listSeriesid[i];
//            System.out.println("SSSSSSSSSSSSSSSSSSSSS"+subjectId+"_"+contentId+"_"+favorateTitle+"_"+seriesids);
            DealBP3SDataSource dealbpDa = new DealBP3SDataSource();
            DealBPValueIn3S valueInbp = (DealBPValueIn3S) dealbpDa.getValueIn();
            valueInbp.setDaUserID(userInfo.getUserId());
            valueInbp.setDaUserFlag("IPTV");
            if (seriesids != null) {
//                System.out.println("SSSSSSSSSSSSSSSSSseriesids="+seriesids);
                valueInbp.setSeriesID(seriesids);
            } else {
                valueInbp.setSeriesID("0");
            }
            valueInbp.setMarkTitle(favorateTitle);
            valueInbp.setMarkType("PROGRAM");
            valueInbp.setContentID(contentId);
            valueInbp.setSubjectID(subjectId);
            valueInbp.setUserInfo(userInfo);
            Result result = dealbpDa.execute();
            int f = result.getFlag();
            if (f == 0) {
//                System.out.println("SSSSSSSSSSSSSSSSSSSSSSSdellCount="+dellCount);
                dellCount++;
            }
        }
        sb.append("{dellCount:\"" + dellCount + "\",failCount:\"" + failCount + "\"}");
    }
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

