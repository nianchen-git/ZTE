<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Vector" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%
    String columnid = "";
    try {
        String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
        HashMap param = PortalUtils.getParams(path, "GBK");
        columnid = request.getParameter("columnid");
        if (columnid == null || "".equals(columnid)) {
            columnid = (String) param.get("column01");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    String columnpath=request.getParameter("columnpath");
    if(columnpath!=null){
        columnpath= URLDecoder.decode(columnpath, "UTF-8");
    }
    String lastfocus=request.getParameter("lastfocus");
%>
<%
    StringBuffer sb = new StringBuffer();
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    VodDataSource vodDs = new VodDataSource();
    VoDQueryValueIn valueIn = (VoDQueryValueIn) vodDs.getValueIn();
    valueIn.setUserInfo(userInfo);
    valueIn.setColumnId(columnid);

    EpgResult result = vodDs.getData();
    List vVodData = (Vector) result.getData();

    String oColumnid = "";
    String oProgramid = "";
    String oProgramtype = "";
    String oProgramName = "";
    String oContentCode = "";


    int length = vVodData.size();
    if (length > 0) {
        sb.append("[");
        for (int i = 0; i < length; i++) {
            VoDContentInfo vodInfo = (VoDContentInfo) vVodData.get(i);
            oColumnid = vodInfo.getColumnId();
            oProgramid = vodInfo.getProgramId();
            oProgramtype = vodInfo.getProgramType();
            oProgramName = vodInfo.getProgramName();
            oContentCode = vodInfo.getContentId();
            if (i > 0 && i < length) {
                sb.append(",");
            }
            sb.append("{columnid:\"" + oColumnid + "\",");
            sb.append("programid:\"" + oProgramid + "\",");
            sb.append("programname:\"" + oProgramName + "\",");
            sb.append("contentcode:\"" + oContentCode + "\",");
            sb.append("programtype:\"" + oProgramtype + "\"}");
        }
        sb.append("]");
    }else{
        pageContext.forward("zhuanti_welcome.jsp");
    }
    String vodDataStr=sb.toString();
%>
<epg:PageController name="zhuanti_program.jsp"/>
<html>
<head>
    <title>专题</title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script type="text/javascript">
        var $$ = {};
        function $(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        var vodArr=new Array();
        var columnid="<%=columnid%>";
        var totalCount=0;
        var index = 0;
        var leng = 0;
        var starIndex=0;
        var endIndex=9;
        var showIndex=0;
        var isback=false;
        var curArr=new Array();
       function getData() {
           if("<%=lastfocus%>"!="" && "<%=lastfocus%>"!="null" && "<%=lastfocus%>"!=null){
               var lastfocus="<%=lastfocus%>";
               var parArr=lastfocus.split("_");
               if(parArr.length>0){
                   isback=true;
                   starIndex=parseInt(parArr[0]);
                   endIndex=parseInt(parArr[1]);
                   index=parseInt(parArr[2]);
               }
           }
           $("path").innerText = "<%=columnpath%>";
           initData();
       }
        function initData() {
            vodArr =<%=vodDataStr%>;
            totalCount=vodArr.length;
            if(isback==false){
                if(totalCount <9)endIndex=totalCount;
            }
            showProgram();
        }
        function showProgram(){
            clearProgram();
            curArr=new Array();
            for (var i = starIndex; i < endIndex; i++) {
                curArr.push(vodArr[i]);
            }
            leng = curArr.length;
            showIndex=starIndex;
            if (leng > 0) {
                for (var i = 0; i <leng; i++) {
                   showIndex++;
                   $("name"+i).innerText=showIndex+"、"+curArr[i].programname;
                }
                changeImg(1);
            }
            showPage();
        }

        function clearProgram(){
            for(var i =0;i<9;i++){
               $("name"+i).innerText=" ";
               $("focus"+i).style.visibility="hidden";
            }
        }
        function keyPress(evt) {
            var keyCode = parseInt(evt.which);
            if (keyCode == 0x0028) { //onKeyDown
              goDown();
            } else if (keyCode == 0x0026) {//onKeyUp
              goUp();
            } else if (keyCode == 0x0025) { //onKeyLeft

            } else if (keyCode == 0x0027) { //onKeyRight

            }else if (keyCode == 0x0022) {  //page down
               pageDown();
           } else if (keyCode == 0x0021) { //page up
               pageUp();
           }  else if (keyCode == 0x0008 || keyCode == 24) {///back
                goBack();
            } else if (keyCode == 0x000D) {  //OK
                goOK();
            } else {
                commonKeyPress(evt);
                return true;
            }
            return false;
        }
        function goBack() {                                        
            document.location = "back.jsp";
        }
        function goUp(){
         if(index>0 && index<leng){
             changeImg(-1);
             index--;
             changeImg(1);
          }else{
            if(starIndex>0){
                starIndex--;
                if(leng==9)endIndex--;
                showProgram();
            }
          }
        }
        function goDown(){
          if(index>=0 && index<leng-1){
             changeImg(-1);
             index++;
             changeImg(1);
          }else{
            if(endIndex<totalCount){
                starIndex++;
                endIndex++;
                showProgram();
            }
          }
        }
        function goOK(){
            if (leng > 0) {
                var leefocus = starIndex + "_" + endIndex + "_" + index;
                var url = "";
                if (curArr[index].programtype == "0") {
                    url = "vod_detail.jsp?columnid=" + curArr[index].columnid
                            + "&programid=" + curArr[index].programid
                            + "&programtype=" + curArr[index].programtype
                            + "&contentid=" + curArr[index].contentcode
                            + "&columnpath=" + $("path").innerText
                            + "&leefocus=" + leefocus
                            + "&programname=" + curArr[index].programname;
                } else if (curArr[index].programtype == "1") {
                    url = "vod_series_list.jsp?columnid=" + curArr[index].columnid
                            + "&programid=" + curArr[index].programid
                            + "&programtype=" + curArr[index].programtype
                            + "&contentid=" + curArr[index].contentcode
                            + "&columnpath=" + $("path").innerText
                            + "&leefocus=" + leefocus
                            + "&programname=" + curArr[index].programname;
                }
                document.location = encodeURI(encodeURI(url));
            }
        }
        function pageUp(){                           
            if (starIndex > 0) {  
                if (starIndex>=9 && endIndex>9) {
                    starIndex -= 9;
                    endIndex =starIndex+9;
                } else {
                    starIndex =0;
                    endIndex = 9;
                }
                changeImg(-1);
                index = 0;
                showProgram();
            }
        }
        /*
        当前最后的下标小于总记录数才能翻页，下一页的开始下标就是上一页的结束下标
        如果当前页的下标加上每页显示的个数小于总记录数，下一页的结束下标endIndex += 9,否则endIndex = totalCount;
         */
        function pageDown(){
            if (endIndex < totalCount) {
                starIndex = endIndex;
                if ((endIndex + 9) <=totalCount) {
                    endIndex += 9;
                } else {
                    endIndex = totalCount;
                }
                changeImg(-1);
                index = 0;
                showProgram();
            }
        }
        function changeImg(flag){
           if(flag==1){
             $("focus"+index).style.visibility="visible";
           }else{
               $("focus"+index).style.visibility="hidden";
           }
        }
       function showPage(){
            $("up").style.visibility=starIndex>0 ? "visible":"hidden";
            $("down").style.visibility=endIndex<totalCount ? "visible":"hidden";
        }
        document.onkeypress = keyPress;
    </script>
</head>

<body bgcolor="transparent">
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/special/zhuanti.png" height="720" width="1280" alt="">
</div>
<div style="position:absolute; left: 135px; width: 311px; top: 48px; height: 41px;font-size:24px;color:#FFFFFF" id="path"></div>

<!--翻页图标 -->
<div style="position:absolute; width:223px; height:543px; left:80px; top:100px;">
    <div id="up" style="position:absolute; width:25px; height:14px; left:93px; top:6px;visibility:hidden">
        <img src="images/vod/btv_up.png" height="14" width="25" alt="" border="0"></div>
    <div id="down" style="position:absolute; width:25px; height:14px; left:93px; top:522px;visibility:hidden">
        <img src="images/vod/btv_down.png" height="14" width="25" alt="" border="0"></div>
</div>
<div style="position:absolute; left: 78px; width: 844px; top: 125px; height: 491px;font-size:20px;color:#FFFFFF">
    <%
    for(int i=0;i<9;i++){
       int top=50*i+20;
%>


<div  style="position:absolute;line-height:35px; left: 37px; width: 670px; top: <%=top-3%>px; height: 38px;">
    <div id="focus<%=i%>" style="position:absolute;line-height:35px; left: 0px; width: 670px; top: 0px; height: 38px;visibility:hidden">
        <img src="images/portal/focus.png"alt="" width="600" height="38">
    </div>
</div>
<div id="name<%=i%>" style="position:absolute;line-height:35px; left: 50px; width: 700px; top: <%=top%>px; height: 35px;"></div>

<%--<hr style="position:absolute; left: 37px; width: 700px; top: <%=top+37%>px; height: 1px;" size="1">--%>
<div style="position:absolute; left: 0px; width: 807px; top: <%=top+40%>px; height: 2px;">
    <img src="images/portal/line.png" alt="" width="680" height="2">
</div>
<%
    }
%>
</div>




<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:637px;">
</div>
<div style="position:absolute; width:400px; height:38px; left:800px; top:643px;font-size:22px;">
    <div id="pre" style="visibility:visible">
        <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:7;top:4px;color:#424242">上页</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
    </div>
    <div id="next" style="visibility:visible">
        <img src="images/vod/btv_page.png" width="60" height="31" alt="" style="position:absolute;left:200;top:0px;">
        <font style="position:absolute;left:207;top:4px;color:#424242">下页</font>
        <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
    </div>
</div>
<script type="text/javascript">
    getData();
</script>
<%@ include file="inc/mailreminder.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>