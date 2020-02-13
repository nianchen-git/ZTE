<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page isELIgnored="false" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>
<%@ include file="../inc/ad_utils.jsp" %>
<epg:PageController/>
<%!
    /**
     * ��ȡӰƬ�Ĵ󺣱�
     * @param postfilelist 12�ź���·���ַ���
     * @return ӰƬ�Ĵ󺣱�URL
     **/
    public String getNormalPoster(String postfilelist) {
        String posterPath = "images/vod/post.png";
        if (null != postfilelist) {
            String[] tempArr = postfilelist.split(";");
            if (tempArr.length > 0 && !"".equals(tempArr[0])) {
                return "../images/poster/" + tempArr[0];
            }
        }
        return posterPath;
    }
    /**
     * JSON��ת�庯����ƴ��JSON��ǰ����
     * ���ܣ�ת�巴б�ܡ���˫����
     * @param str ��ת���ַ���
     * @return ת�����ַ���
     * ע��:���ñ�����֮ǰ��Ҫ��������String.valueOf��װ�ַ������������Ϊnullʱ�򣬷����ַ���"null"
     */
    public String getJsonPattern(String str) {
        if (null != str && !"".equals(str)) {
            str = str.replaceAll("\\\\", "\\\\\\\\")
                    .replaceAll("'", "\\\\\'")
                    .replaceAll("\"", "\\\\\"");
        } else {
            str = "";
        }
        return str;
    }
%>

<%
    String mediaservice = "1";
    if ("1".equals((String) session.getAttribute("isHls"))) {
        mediaservice = "2";
    }
    String destpagestr = request.getParameter("destpage");
    String index = request.getParameter("index");
    if ("".equals(index) || index == null) {
        index = "0";
    }
    String strpage = request.getParameter("numperpage");
    int destpage = (destpagestr == null) ? 1 : Integer.parseInt(destpagestr);
    int numperpage = (strpage == null) ? 10 : Integer.parseInt(strpage);
    Map vChannelData = new HashMap();
    List favList = new ArrayList();
    Map favInfo = new HashMap();
    FavoriteInfo_3S vodInfo = null;

    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    path = path.replace("action/", "");
    HashMap param = PortalUtils.getParams(path, "UTF-8");
    String vodcolumnid = "";
    String isFathercolumnlist = String.valueOf(param.get("isFathercolumnlist"));
    String Fathercolumnlist = String.valueOf(param.get("Fathercolumnlist"));
    if (isFathercolumnlist != null && Fathercolumnlist != null && isFathercolumnlist.equals("1")) {//��ȡN��һ����Ŀ��֧
        String[] columnlist = Fathercolumnlist.split(",");
        if(columnlist!=null && columnlist.length>0){
            vodcolumnid = columnlist[0];
        }else{
            vodcolumnid = (String) param.get("column01");
        }
    }else{
        vodcolumnid = (String) param.get("column01");
    }


//    System.out.println("=========vodcolumnid="+vodcolumnid);
    //  ��ҳ����
    int pagecount = 0;
    int totalCount = 0;
    int pageSize = 0;
    int endIndex = 0;
    int startIndex = 0;
    StringBuffer sql = new StringBuffer();
    sql.append("state=1");
    List result = new ArrayList();
%>
<ex:params var="inputparams">
    <ex:param name="unique" value="1"/>
</ex:params>
<ex:search tablename="user_favorite" fields="*" inputparams="${inputparams}" condition="<%=sql.toString()%>"
           var="vodFavList" order="savetime desc">
    <%
        result = (List) pageContext.getAttribute("vodFavList");
    %>
</ex:search>
<%
    if (result != null && result.size() > 0) {
        for (int i = 0; i < result.size(); i++) {
            vChannelData = (Map) result.get(i);
            String vodsql = " columncode = '" + vChannelData.get("columncode") + "' and contentcode='" + vChannelData.get("contentcode")+ "'";
%>
<ex:params var="inputhash">
    <ex:param name="columnavailable" value="<%=vodcolumnid%>"/>
</ex:params>
<ex:search tablename="user_vod" fields="*"  order="createtime desc" condition="<%=vodsql%>"
           var="programlist">
    <%
        List vodData = (ArrayList) pageContext.getAttribute("programlist");
        if (vodData.size() > 0) {
            favList.add(vodData.get(0));
        }
    %>
</ex:search>
<%
        }
    }
%>
<%
//    System.out.println("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n"
//            +" favorite_datas2.jsp"+"- -"+"result.size() "+"\n:::"
//            +result.size());
//    System.out.println("_ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n"
//            +" favorite_datas2.jsp"+"- -"+"favList.size() "+"\n:::"
//            +favList.size());
    String columnId = "";
    String programId = "";
    String programType = "";
    String seriesprogramcode = "";
    String contentcode = "";
    String programName = "";
    String offlinetime = "";
    String posterfilelist = "";
    String normalposter = "";

    String Seriesnum ="";


    totalCount = favList.size();//�ܼ�¼��
    int indexNum = Integer.parseInt(index);
    pagecount = (totalCount - 1) / numperpage + 1;  //��ǰ��ҳ��
    int tempnum = (destpage - 1) * 10 + indexNum + 1; //����ϸҳ�滹û��ɾ���ղص��ܼ�¼��
    if (tempnum > totalCount) {  //��vod��ϸҲ���˳��ղغ�ĸ�����һ��
        if (destpage > 1) {
            if (indexNum == 0) { //���һҳ���һ����ɾ��
                destpage--;
                indexNum = 9;
            } else {
                indexNum = indexNum - 1;
            }
        } else {
            destpage = 1;
            if (indexNum > 0) indexNum = indexNum - 1;
        }
    }
    startIndex = (destpage - 1) * numperpage;
    endIndex = destpage * numperpage;

    startIndex = (startIndex >= totalCount) ? (totalCount - 1) : startIndex;
    if (startIndex < 0) {
        startIndex = 0;
    }
    endIndex = (endIndex >= totalCount) ? totalCount : endIndex;
    StringBuffer favoriteJsonData = new StringBuffer("{");
    favoriteJsonData.append("\"Data\":").append("[");
//    System.out.println("...................\nstartIndex"+startIndex+"==endIndex=="+endIndex);
    if (totalCount > 0) {
        for (int i = startIndex; i < endIndex; i++) {
            Map columnInfo = (Map) favList.get(i);
            columnId = (String) columnInfo.get("columncode");
            programId = (String) columnInfo.get("programcode");
            programType = (String) columnInfo.get("programtype");
            seriesprogramcode = (String) columnInfo.get("seriesprogramcode");
            Seriesnum = (String) columnInfo.get("seriesnum");
            contentcode = (String) columnInfo.get("contentcode");
            programName  = getJsonPattern(String.valueOf(columnInfo.get("programname")));
            offlinetime = String.valueOf(columnInfo.get("offlinetime"));
            if (offlinetime.length() >= 10)
                offlinetime = offlinetime.substring(5, 10) + "." + offlinetime.substring(0, 4);
            posterfilelist = String.valueOf(columnInfo.get("posterfilelist"));
            normalposter = getNormalPoster(posterfilelist);
            if (i > startIndex && i < endIndex) {
                favoriteJsonData.append(",");
            }
            favoriteJsonData.append("{");
            favoriteJsonData.append("programid:\"" + programId + "\",");
            favoriteJsonData.append("programtype:\"" + programType + "\",");
            favoriteJsonData.append("programname:\"" + programName + "\"," );
            favoriteJsonData.append("normalposter:\"" + normalposter + "\",");
            favoriteJsonData.append("columnid:\"" + columnId + "\",");
            favoriteJsonData.append("selectIndex:\"" + i + "\",");
            favoriteJsonData.append("Seriesnum:\"" + Seriesnum + "\",");
            favoriteJsonData.append("vSeriesprogramcode:\"" + seriesprogramcode + "\",");
            favoriteJsonData.append("contentcode:\"" + contentcode + "\"}");
        }
    }
    pageSize = endIndex - startIndex;
    favoriteJsonData.append("],\"destpage\":\"").append(destpage).append("\",");
    favoriteJsonData.append("\"cursize\":\"").append(pageSize).append("\",");
    favoriteJsonData.append("\"indexNum\":\"").append(indexNum).append("\",");
    favoriteJsonData.append("\"pageCount\":\"").append(pagecount).append("\",");
    favoriteJsonData.append("\"totalcount\":\"").append(totalCount).append("\"");
    favoriteJsonData.append("}");
//    System.out.println("-----------------------\n( data .jsp)__( favoriteJsonData ):::"+favoriteJsonData);
    JspWriter ot = pageContext.getOut();
    ot.write(favoriteJsonData.toString());
%>