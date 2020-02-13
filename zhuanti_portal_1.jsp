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
<%@ page import="com.zte.iptv.newepg.datasource.ColumnOneDataSource" %>
<%@ include file="inc/getFitString.jsp" %>
<epg:PageController name="zhuanti_portal_1.jsp"/>
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
    String columnpath ="";
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    ColumnOneDataSource ds = new ColumnOneDataSource();
    ColumnValueIn valueIn = (ColumnValueIn) ds.getValueIn();
    valueIn.setColumnId(columnid);
    valueIn.setUserInfo(userInfo);
    try {
        EpgResult rs = ds.getData();
        Vector v=rs.getDataAsVector();
        ColumnInfo columnInfo = (ColumnInfo) v.get(0);
        columnpath = columnInfo.getColumnName();
    } catch (Exception e) {
        e.printStackTrace();
    }

    String lastfocus = request.getParameter("lastfocus");

%>
<html>
<head>
<title>专题</title>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript">
    var columnid = "<%=columnid%>";
    var vodArr = new Array();
    var lastfocus = "<%=lastfocus%>";
    var $$ = {};

    function $(id) {
        if (!$$[id]) {
            $$[id] = document.getElementById(id);
        }
        return $$[id];
    }
</script>

<script type="text/javascript">
var index = 0;
var destpage = 1;
var pageCount = 1;
var totalCount = 0;
var leng = 0;
var starIndex = 0;
var endIndex = 7;
var curArr = new Array();
var isback = false;
function initParam() {
        if (lastfocus != "" && lastfocus != "null" && lastfocus != null) {
            var parArr = lastfocus.split("_");
            if (parArr.length > 0) {
                isback = true;
                starIndex = parseInt(parArr[0]);
                endIndex = parseInt(parArr[1]);
                index = parseInt(parArr[2]);
            }
        }
        $("path").innerText = "<%=columnpath%>";
    }
function getData() {
    initParam();
    var requestUrl = "action/zhuanti_datalist.jsp?columnid=" + columnid;
    var loaderSearch = new net.ContentLoader(requestUrl, initData);
}
function initData() {
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    vodArr = data.vodData;
    totalCount = vodArr.length;
    if (!isback) {
        if (endIndex > totalCount) endIndex = totalCount;
    }
    showProgram();
}
function showProgram() {
    curArr = new Array();
    curArr = vodArr.slice(starIndex, endIndex)
    leng = curArr.length;
    for (var i = 0; i < 7; i++) {
        if (i < leng) {
            $("img_" + i).src = curArr[i].normalPoster;
            $("fimg_" + i).src = curArr[i].normalPoster;
            $("name" + i).innerText = writeFitString(curArr[i].programname, 18, 130);
            $("fname" + i).innerText = writeFitString(curArr[i].programname, 20, 125);
            $("poster" + i).style.visibility = "visible";
            $("name_div" + i).style.visibility = "visible";
        } else {
            $("poster" + i).style.visibility = "hidden";
            $("name_div" + i).style.visibility = "hidden";
            $("name" + i).innerText = " ";
            $("fname" + i).innerText = " ";
        }
        changeImg(1);
    }
    if (leng > 0)$("bigimg").src = vodArr[0].bigPoster;
    showPage();
}
function keyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown
        goDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        goUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        goLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        goRight();
    } else if (keyCode == 0x0022) {  //page down
        pageDown();
    } else if (keyCode == 0x0021) { //page up
        pageUp();
    } else if (keyCode == 0x0008 || keyCode == 24) {///back
        goBack();
    } else if (keyCode == 0x000D) {  //OK
        goOK();
    } else {
        commonKeyPress(evt);
        return true;
    }
    return false;
}
function goDown() {
    $("focus_poster").style.visibility = "hidden";
    changeImg(1);
}
function goUp() {
    changeImg(-1);
    $("focus_poster").style.visibility = "visible";
}
function goBack() {
    document.location = "back.jsp";
}
function goLeft() {
    if (index > 0 && index < leng) {
        changeImg(-1);
        index--;
        changeImg(1);
    } else {
        if (starIndex > 0) {
            starIndex--;
            if (leng == 7)endIndex--;
            showProgram();
        }
    }
}
function goRight() {
    if (index >= 0 && index < leng - 1) {
        changeImg(-1);
        index++;
        changeImg(1);
    } else {
        if (endIndex < totalCount) {
            starIndex++;
            endIndex++;
            showProgram();
        }
    }
}
function pageUp() {
    if (starIndex > 0) {
        if (starIndex - 7 >= 0 && endIndex > 14) {
            starIndex -= 7;
            endIndex = starIndex + 7;
        } else {
            starIndex = 0;
            endIndex = 7;
        }
        changeImg(-1);
        index = 0;
        showProgram();
    }
}
function pageDown() {
    if (endIndex < totalCount) {
        starIndex = endIndex;
        if ((endIndex + 7) <= totalCount) {
            endIndex += 7;
        } else {
            endIndex = totalCount;
        }
        changeImg(-1);
        index = 0;
        showProgram();
    }
}
function goOK() {
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
function showColumnPath() {
    
}
function changeImg(flag) {
    if (flag == 1) {
        $("poster" + index).style.visibility = "hidden";
        $("name_div" + index).style.visibility = "hidden";

        $("fname_div" + index).style.visibility = "visible";
        $("big_poster" + index).style.visibility = "visible";
    } else {
        $("big_poster" + index).style.visibility = "hidden";
        $("fname_div" + index).style.visibility = "hidden";

        $("poster" + index).style.visibility = "visible";
        $("name_div" + index).style.visibility = "visible";
    }
}
function showPage() {
    $("up").style.visibility = starIndex > 0 ? "visible" : "hidden";
    $("down").style.visibility = endIndex < totalCount ? "visible" : "hidden";
}
document.onkeypress = keyPress;
</script>
</head>

<body bgcolor="transparent">
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<div style="position:absolute; left: 135px; width: 800px; top: 30px; height: 41px;font-size:24px;color:#FFFFFF" id="path"></div>

<!--翻页图标 -->
<div id="up" style="position:absolute; width:25px; height:14px; left:34px; top:515px;visibility:hidden">
    <img src="images/down_left.png" height="24" width="14" alt="" border="0"></div>
<div id="down" style="position:absolute; width:25px; height:14px; left:1224px; top:515px;visibility:hidden">
    <img src="images/down_right.png" height="24" width="14" alt="" border="0"></div>
<div style="position:absolute; left: 60px; width: 1085px; top: 420px; height: 202px;color:#FFFFFF;">
    <%
        for (int i = 0; i < 7; i++) {
            int left = i * 168;
    %>
    <div id="poster<%=i%>" style="position:absolute; left: <%=left%>px; width: 143px; top: 0px; height: 200px;border:1px solid white;visibility:hidden">
        <img id="img_<%=i%>" src="images/btn_trans.gif" alt="" width="143" height="200" border="0">
    </div>
    <div id="name_div<%=i%>" style="background:url('images/vod/btv_vod.png');position:absolute; left: <%=left+1%>px; width: 143px; top: 175px; height: 25px;visibility:hidden">
        <div id="name<%=i%>" style="position:absolute; left: 0px; width: 124px; top: 2px; height: 25px;font-size:18px;" align="center"> </div>
    </div>

    <div id="big_poster<%=i%>" style="position:absolute; left: <%=left-7%>px; width: 157px; top: -10px; height: 220px;visibility:hidden;">
        <img id="fimg_<%=i%>" src="images/btn_trans.gif" alt="" width="157" height="220" style="border:2px solid red">
    </div>
    <div id="fname_div<%=i%>" style="background:url('images/vod/btv_vod.png');position:absolute;line-height:35px; left: <%=left-4%>px; width: 157px;font-size:20px; top: 176px; height: 35px;visibility:hidden" align="center">
        <div id="fname<%=i%>" style="position:absolute; left: 0px; width: 157px; top: 0px; height: 25px;font-size:22px" align="center"> </div>
    </div>
    <%
        }
    %>
</div>

<div style="position:absolute; width:1154px; height:296px; left:60px; top:100px;">
    <img  id="bigimg" src="images/btn_trans.gif" alt="" width="1154" height="296">
</div>
<div id="focus_poster" style="position:absolute; width:1154px; height:296px; left:60; top:98px;visibility:hidden;border:2px solid red"></div>

<%--<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:637px;">--%>
<%--</div>--%>
<%--<div style="position:absolute; width:400px; height:38px; left:800px; top:643px;font-size:22px;">--%>
    <%--<div id="pre" style="visibility:visible">--%>
        <%--<img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">--%>
        <%--<font style="position:absolute;left:7;top:4px;color:#424242">上页</font>--%>
        <%--<font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>--%>
    <%--</div>--%>
    <%--<div id="next" style="visibility:visible">--%>
        <%--<img src="images/vod/btv_page.png" width="60" height="31" alt="" style="position:absolute;left:200;top:0px;">--%>
        <%--<font style="position:absolute;left:207;top:4px;color:#424242">下页</font>--%>
        <%--<font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>--%>
    <%--</div>--%>
<%--</div>--%>
<script type="text/javascript">
    getData();
</script>
<%--<%@ include file="inc/mailreminder.jsp" %>--%>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>