<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnOneDataSource" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@	page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%
    String vodcolumnid="";
    String leefocus = request.getParameter("leefocus");
    String linePosterColumnlist="";
    String columnname = request.getParameter("columnname");
    if(columnname == null){
        columnname = "";
    }



    try {
        UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
        String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
        HashMap param = PortalUtils.getParams(path, "GBK");
        vodcolumnid = request.getParameter("columnid");

        linePosterColumnlist=String.valueOf(param.get("linePosterColumnlist"));
        if (vodcolumnid == null || "".equals(vodcolumnid)) {
            String isFathercolumnlist = String.valueOf(param.get("isFathercolumnlist"));
            String Fathercolumnlist = String.valueOf(param.get("Fathercolumnlist"));
            System.out.println("SSSSSSSSSSSSSSSSSSSvod_portal_isFathercolumnlist="+isFathercolumnlist);
            System.out.println("SSSSSSSSSSSSSSSSSSSvod_portal_Fathercolumnlist="+Fathercolumnlist);
            if (isFathercolumnlist != null && Fathercolumnlist != null && isFathercolumnlist.equals("1")) {//读取N个一级栏目分支
                String[] columnlist = Fathercolumnlist.split(",");
                if(columnlist!=null && columnlist.length>0){
                    vodcolumnid = columnlist[0];
                }else{
                    vodcolumnid = (String) param.get("column01");
                }
            }else{
                vodcolumnid = (String) param.get("column01");
            }

            ColumnOneDataSource columnOneDataSource = new ColumnOneDataSource();
            ColumnValueIn valueIn = (ColumnValueIn) columnOneDataSource.getValueIn();
            valueIn.setUserInfo(userInfo);
            valueIn.setColumnId(vodcolumnid);
            EpgResult result = columnOneDataSource.getData();
            List vColumnData = (Vector) result.getData();
            if(vColumnData!=null && vColumnData.size()>0){
                ColumnInfo columnInfo1 = (ColumnInfo) vColumnData.get(0);
                columnname = columnInfo1.getColumnName();
            }
            System.out.println("SSSSSSSSSSSSSSSSSSvodcolumnid="+vodcolumnid);
            System.out.println("SSSSSSSSSSSSSSSSSScolumnname="+columnname);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

//    System.out.println("SSSSSSSSSSSSSSSSSSSvod_portal_vodcolumnid="+vodcolumnid);
    String tempName = columnname;
    if(!columnname.equals("")){
        columnname = " > "+ columnname;
    }
    String queryString = request.getQueryString();
    String topicindex = request.getParameter("topicindex");
    topicindex = (topicindex==null)?"0":topicindex;
    if(topicindex.compareTo("8")>0){
        topicindex = "0";
    }
    String destpage = request.getParameter("destpage");
    destpage = (destpage==null)?"1":destpage;
%>
<html>
<head>
     <epg:PageController name="vod_portal_pre.jsp"/>
    <title>portal</title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script language="javascript" type="">
        var _windowframe = window.getWindowByName("vodPortal");

        function _showWindow(){
            //if(isReallyZTE == false){
                //alert("SSSSSSSSSSSSSSSSSSSStest1111");
                document.location = "vod_portal.jsp?isnewopen=1&<%=queryString%>&columnname=<%=tempName%>";
                return;
            //}
            //alert("SSSSSSSSSSSSSSSSSSSStest2222");

			if(typeof(_windowframe) != "object"){
                _windowframe = window.open('vod_portal.jsp?isnewopen=1&<%=queryString%>&columnname=<%=columnname%>','vodPortal','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
                _windowframe.setWindowFocus();
                top.showOSD(2,0,0);
                top.setBwAlpha(0);
			}else{
//                _windowframe.pathstr = new Array();
                _windowframe._window = top;
                <%
                if(leefocus !=null && !leefocus.equals("")){
                %>
//                alert("SSSSSSSSSSSSSSSSSSSSS111");
                top.jsSetControl("cachestr","");
				_windowframe.pathstr=new Array();
				_windowframe.statckIndex = new Array();
				_windowframe.statckdestpage = new Array();
				_windowframe.statcksubIndex=new Array();
				_windowframe.arrcindex = new Array();
                _windowframe.clearStack();
				//alert("SSSSSSSSSSSSSSSSSSSSS33333");
                _windowframe.columnid = "<%=vodcolumnid%>";
                <%
                 }
                %>
                _windowframe.show();
                _windowframe.linePosterColumnlist = "<%=linePosterColumnlist%>";
                _windowframe.firstColumnName = "<%=columnname%>";
                _windowframe.topicindex = parseInt("<%=topicindex%>",10) ;
                _windowframe.tempDestpage = parseInt("<%=destpage%>",10) ;
                _windowframe.init();
                _windowframe.setWindowFocus();
				top.showOSD(2,0,0);
                top.setBwAlpha(0);
                clearChannelNumber();
			}
		}
    </script>
</head>

<body bgcolor="transparent" onunload="hidePortal();">
<%@include file="inc/lastfocus_window.jsp" %>
</body>
</html>