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
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
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
    int destpage = EpgUtils.toInt(request.getParameter("destpage"), 1); //取得当前页码
    System.out.println("================ddestpageestpage"+destpage);
    int pagecount = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    Vector vProgramName = new Vector();
    Vector vColumnId = new Vector();
    Vector vContentcode = new Vector();
    Vector vSeriesprogramcode = new Vector();
    Vector vProgramtype = new Vector();
    StringBuffer sb = new StringBuffer();
    Map bookMarkDataOut = getData(getEpgResult("BreakPoint3SDecorator", pageContext));
    // 计算总页数
//           System.out.println("datasourse======="+bookMarkDataOut);
    if (bookMarkDataOut != null)
    {
        vProgramName = (Vector) bookMarkDataOut.get("Marktitle");                            
//           System.out.println("datasourse======="+vProgramName);
//           System.out.println("datasourse======="+vProgramName.size());
        int totalcount = vProgramName.size(); //总记录数
        if (totalcount % 10 == 0)
        {
            pagecount = totalcount / 10;
        }
        else
        {
           pagecount = totalcount / 10 + 1;
        }
    }
    sb.append("{totalcount:\""+vProgramName.size()+"\",pageCount:\"" + pagecount + "\",destpage:\"" + destpage + "\", Data:[");
    if (bookMarkDataOut != null) {
        vProgramName = (Vector) bookMarkDataOut.get("Marktitle");
        vColumnId = (Vector) bookMarkDataOut.get("Subjectid");
        vContentcode = (Vector) bookMarkDataOut.get("Contentid");
        vSeriesprogramcode = (Vector) bookMarkDataOut.get("Seriesid");
        vProgramtype = (Vector) bookMarkDataOut.get("Programtype");
        int totalcount = vProgramName.size(); //总记录数
        int starnum = 0;
        int endnum = 0;
        if (totalcount > 0) {
            starnum = 10 * (destpage - 1);
            endnum = 10 * destpage;
        }
        if (endnum > totalcount) endnum = totalcount;
        if (vProgramName.size() > 0) {
            String columnId = "";
            String programId = "";
            String contentId = "";
            String seriesid = "";
            String seriesnum = "";
            String programtype = "";
            for (int i = starnum; i < endnum; i++) {
                columnId = String.valueOf(vColumnId.get(i));
                contentId = String.valueOf(vContentcode.get(i));
                programtype =  String.valueOf(vProgramtype.get(i));

                seriesid = String.valueOf(vSeriesprogramcode.get(i));
                programtype=seriesid.equals("0") ? "0":"1";
                String[][] vodSeriesArray = {{EpgConstants.COLUMN_ID, columnId}, {EpgConstants.SERIES_PROGRAMCODE, seriesid}};
                Map vodSeriesData = null;
                Vector seriescode = null;
                Vector Seriesnum = null;

                VoDContentInfo vodConInf = getVodConInf(columnId, contentId, pageContext);

                String seriesProgramCode = vodConInf.getSeriesProgramCode();
                programId=vodConInf.getProgramId();
                 String normalposter=vodConInf.getNormalPoster();
                if(seriesProgramCode!=null &&  !seriesProgramCode.equals("")){//连续剧
                    VodOneDataSource ds=new VodOneDataSource();
                    VoDQueryValueIn valueIn=(VoDQueryValueIn)ds.getValueIn();
                    valueIn.setColumnId(columnId);
                    valueIn.setProgramId(vodConInf.getSeriesProgramCode());
                    valueIn.setVoDType(CodeBook.VOD_TYPE_SERIES_Head);
                    valueIn.setUserInfo(userInfo);

                    EpgResult result=ds.getData();
                    Vector vector=(Vector)result.getData();
                    VoDContentInfo vodInfo = null;
                    if(vector!=null && vector.size()>0){
                        vodInfo = (VoDContentInfo)vector.get(0);
                        normalposter = vodInfo.getNormalPoster();
                    }

                    programtype = "14";
                    vodSeriesData = getData("VodSeriesDecorator", pageContext, vodSeriesArray, false);
                    seriescode = (Vector) vodSeriesData.get("ProgramId");
                    Seriesnum = (Vector) vodSeriesData.get("Seriesnum");
                for (int j = 0; j < seriescode.size(); j++) {
                    if (seriescode.get(j).equals(programId)) {
                        seriesnum = String.valueOf(Seriesnum.get(j));
                        programId=vodConInf.getSeriesProgramCode();
                     }
                    }
                }else{
                    programtype = "1";
                }
                if(normalposter.indexOf("defaultposter_n")!=-1 )normalposter="images/vod/post.png";                                     
                sb.append("{programid:\"" + programId + "\",");
                sb.append("programtype:\"" + programtype + "\",");
                sb.append("normalposter:\"" +normalposter  + "\",");
                sb.append("programname:\"" +formatName(vodConInf.getProgramName()) + "\",");
                sb.append("columnid:\"" + columnId + "\",");
                sb.append("Seriesnum:\"" + seriesnum + "\",");
                sb.append("selectIndex:\"" + i + "\",");
                sb.append("vSeriesprogramcode:\"" + seriesProgramCode + "\",");
                sb.append("contentcode:\"" + vodConInf.getContentId() + "\"},");
            }
        }
    }

    sb.append("]}");
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
//    System.out.println("=====favorite_bookMark_datas="+sb.toString());
%>