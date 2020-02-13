<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.zte.iptv.newepg.datasource.UserConsumeDataSource" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.web.ConsumeQueryValueIn" %>
<%@ include file="inc/words.jsp" %>
<%@ include file="inc/ad_utils.jsp" %>
<epg:PageController name="selfcare_myAcount_ppv.jsp"/>
<%!
    public String dateFormat(Date date, String pattern) {
        try {
            DateFormat formater = new SimpleDateFormat(pattern);
            return formater.format(date);
        } catch (Exception ex) {
            return "";
        }
    }
    public int getTotal(String datasource,String name,PageContext pageContext){
        Map fieldData=(Map)getData(getEpgResult(datasource,pageContext));
        if(fieldData == null){ return 0; }
        Object value = fieldData.get(name);

        if(value instanceof Vector){
           Vector vector = (Vector)value;
           return vector.size();
        }
        return 0;
    }

    public String getParamFromField(String datasource, String name, PageContext pageContext, int index) {
        return(getParamFromFieldByIndex(getData(getEpgResult(datasource,pageContext)),name,index));
    }

    public String getParamFromFieldByIndex(Map fieldData, String name, int index) {
        if (index < 0) {
            return "";
        }
        if (fieldData == null) {
            return "";
        }

        Object value = fieldData.get(name);
        if (value instanceof Vector) {
            Vector vector = (Vector) value;
            if (vector.size() > index) {
                value = vector.get(index);
            } else {
                return "";
            }
        }
        return value == null ? "" : value.toString();
    }
%>
<%
    Calendar cal = new GregorianCalendar();
    cal.setTime(new Date());
    String dates1 = dateFormat(cal.getTime(), "yyyyMMdd");
    cal.add(Calendar.MONTH, -1);
    String dates2 = dateFormat(cal.getTime(), "yyyyMMdd");
    cal.add(Calendar.MONTH, -1);
    String dates3 = dateFormat(cal.getTime(), "yyyyMMdd");

    String lastmonth = dates2.substring(0, 4) + "." + dates2.substring(4, 6);
    String blastmonth = dates3.substring(0, 4) + "." + dates3.substring(4, 6);
    String curmonth=dates1.substring(0, 4) + "." + dates1.substring(4, 6);

    String date = request.getParameter("date");
    String index = request.getParameter("index");
    if ("".equals(date) || date == null) {
        date = dates1.substring(0, 4) + "." + dates1.substring(4, 6);
        index = "2";
    }
    String orderdate = date.substring(0, 4) + "." + date.substring(5, 7);

    String destpage = request.getParameter("destpage");
    if (destpage == null || destpage == "") {
        destpage = "1";
    }
    String leefocus = "";
    if (request.getParameter("lastfocus") != null && !request.getParameter("lastfocus").equals("")) {
        leefocus = request.getParameter("lastfocus");
    }
%>
<html>   
<head>
    <title>order list</title>
    <epg:script/>
    <script type="text/javascript">

        var index = parseInt(<%=index%>);
        var dateArr = ["<%=blastmonth%>","<%=lastmonth%>","<%=curmonth%>"];
        var curpage = "<%=destpage%>";
        var pagecount=0;
        var totalcount=0;
        var totalPrice=0;
        function showPrice(price) {
            document.write(price + "元");
        }
        function setPrice(price){
             totalPrice=parseInt(price)+parseInt(totalPrice);
        }
        function showScrollBar() {
            if (totalcount > 0) {
                var heightX = 504 / pagecount;
                var topX = 3 + heightX * (curpage - 1);
                document.getElementById("scrollbar2").height = heightX;
                document.getElementById("scroll").style.top = topX;
                document.getElementById("pageBar").style.visibility = "visible";
            } else {
                document.getElementById("pageBar").style.visibility = "hidden";
            }
        }
        function init(flag) {
            if (flag == 1) {
                document.getElementById("date" + index).style.color = "#FF0000";
                document.getElementById("line").style.left = 60 + index * 200;
            } else {
                document.getElementById("date" + index).style.color = "#FFFFFF";
                document.getElementById("line").style.left = 60 + index * 200;
            }
        }

        function pageDown() {
            if (curpage <pagecount){
                curpage++;
                document.location = "selfcare_myAcount_ppv.jsp?destpage=" + curpage + "&date=<%=date%>&<%=EpgConstants.LASTFOCUS%>=<%=leefocus%>&index=" + index;
            }
        }

        function pageUp() {
            if (curpage > 1) {
                curpage--;
                document.location = "selfcare_myAcount_ppv.jsp?destpage=" + curpage + "&date=<%=date%>&<%=EpgConstants.LASTFOCUS%>=<%=leefocus%>&index=" + index;
            }
        }
        function nextMonth() {
            init(-1);
            if (index >= 0 && index < 2) {
                index++;
            } else {
                index = 0;
            }
            init(1);
            var timer = setTimeout(urlLocation, 200);
        }
        function lastMonth() {
            init(-1);
            if (index > 0 && index <= 2) {
                index--;
            } else {
                index = 2;
            }
            init(1);
            var timer = setTimeout(urlLocation, 200);
        }
        function urlLocation() {
            document.location = "selfcare_myAcount_ppv.jsp?destpage=" + curpage + "&date=" + dateArr[index] + "&<%=EpgConstants.LASTFOCUS%>=<%=leefocus%>&index=" + index;
        }
        function ok() {
        }
        top.jsSetupKeyFunction("top.mainWin.pageUp", <%=STBKeysNew.remotePlayLast%>);
        top.jsSetupKeyFunction("top.mainWin.pageDown", <%=STBKeysNew.remotePlayNext%>);
        top.jsSetupKeyFunction("top.mainWin.lastMonth", <%=STBKeysNew.remoteFastRewind%>);
        top.jsSetupKeyFunction("top.mainWin.nextMonth", <%=STBKeysNew.remoteFastForword%>);
        top.jsSetupKeyFunction("top.mainWin.ok", <%=STBKeysNew.onKeyOK%>);
    </script>
</head>
<body bgcolor="transparent">
<div id="div0" style="position:absolute; width:1145px; height:526px; left:59px; top:110px;">
    <img src="images/mytv/btv-mytv-consumerbg.png" height="526" width="1145" alt="" border="0">
</div>
<%@ include file="inc/time.jsp"%>
<!--顶部信息-->
<div style="position:absolute; width:22; height:35; left:55px; top:18px;">
    <img src="images/search/TV.png" border="0">
</div>

<div id="path" style="position:absolute; width:760px; height:30px; left:110px; top:25px;font-size:24px;color:#FFFFFF">
    我的TV>消费记录
</div>
<div id="date0" style="position:absolute; width:100px; height:32px; left:60px; top:69px;font-size:26px;color:#FFFFFF;"align="center"><%=blastmonth%></div>
<div id="date1" style="position:absolute; width:100px; height:36px; left:260px; top:68px;font-size:26px;color:#FFFFFF;"align="center"><%=lastmonth%></div>
<div id="date2" style="position:absolute; width:100px; height:34px; left:460px; top:67px;font-size:26px;color:#FFFFFF;"align="center">本月</div>

<div style="position:absolute; width:164px; height:51px; left:941px; top:61px;font-size:26px;color:#FFFFFF;">月共消费:</div>
<div id="totalprice" style="position:absolute; width:164px; height:51px; left:1050px; top:61px;font-size:26px;color:#FFFFFF;font-weight:bold"></div>

<hr id="line" style="position:absolute; width:100px; height:0px; left:60px; top:101px;font-size:26px;" color="#FF0000">

<div style="position:absolute; width:200px; height:40px; left:100px; top:115px;font-size:26px;color:#FFFFFF;">影片名称</div>
<div style="position:absolute; width:200px; height:40px; left:740px; top:115px;font-size:26px;color:#FFFFFF;"> 价格</div>
<div style="position:absolute; width:200px; height:40px; left:1000px; top:115px;font-size:26px;color:#FFFFFF;"> 购买时间</div>
<%
    Integer pagecount = 0;
    Integer totalcount =0;
%>


<epg:replace cleardatasource="com.zte.iptv.newepg.decorator.UserConsumeDecorator">
    <epg:para name="<%=EpgConstants.CONSUME_TYPE%>" value="100"/>
    <epg:para name="<%=EpgConstants.CDRTYPE%>" value="100"/>
    <epg:para name="<%=EpgConstants.CONSUME_TIME%>" value="<%=orderdate%>"/>
    <epg:para name="<%=EpgConstants.DEST_PAGE%>" value="<%=destpage%>"/>
</epg:replace>
<epg:table datasource="UserConsumeDecorator" left="100" top="150" width="1000" height="480" rows="10" rowspan="0"
           cols="1">
    <epg:paging numperpage="10" target="selfcare_myAcount_ppv.jsp" goto="true" skipEmpty="true">
        <%
            pagecount = (Integer) pageContext.getAttribute("pagecount");
            totalcount = (Integer) pageContext.getAttribute("totalcount");
        %>
    </epg:paging>

    <epg:col field="ContentName" left="0" top="20" width="400" height="44">
        <epg:formatter color="#ffffff" size="5" pattern="20"/>
    </epg:col>
    <epg:col data="showPrice('{Price}');" left="650" top="20" width="100" height="44" type="script">
        <epg:formatter color="#ffffff" size="5"/>
    </epg:col>
    <epg:col left="900" top="20" width="200" height="44" field="StartTime">
        <epg:formatter color="#ffffff" size="5" pattern="16"/>
    </epg:col>
</epg:table>

 <epg:replace cleardatasource="com.zte.iptv.newepg.decorator.UserConsumeDecorator">
    <epg:para name="<%=EpgConstants.CONSUME_TYPE%>" value="100"/>
    <epg:para name="<%=EpgConstants.CDRTYPE%>" value="100"/>
    <epg:para name="<%=EpgConstants.CONSUME_TIME%>" value="<%=orderdate%>"/>
    <epg:para name="<%=EpgConstants.DEST_PAGE%>" value="<%=destpage%>"/>
</epg:replace>
<epg:table datasource="UserConsumeDecorator" left="1" top="1" width="1" height="1" rows="200" rowspan="0"
           cols="1">
    <epg:paging numperpage="200" target="selfcare_myAcount_ppv.jsp" goto="true" skipEmpty="true">
    </epg:paging>
    <epg:col data="setPrice('{Price}');" left="1" top="1" width="1" height="1" type="script">
        <epg:formatter color="#ffffff" size="5"/>
    </epg:col>
</epg:table>
<!--滚动条--->
<div style="position:absolute; width:20px; height:534px; left:1218px; top:103px;">
    <div id="pageBar" style="position:absolute; width:20px; height:534px; left:0px; top:0px;visibility:hidden">
        <div style="position:absolute; width:20px; height:534px; left:0px; top:0px;">
            <img src="images/vod/btv-02-scrollbar.png" border="0" alt="" width="20" height="534">
        </div>

        <div id="scroll" style="position:absolute; width:20px; height:534px; left:3px; top:3px;">
            <img id="scrollbar1" src="images/vod/btv-02-scrollbar01.png" border="0" width="13" height="10">
            <img id="scrollbar2" src="images/vod/btv-02-scrollbar02.png" border="0" width="13" height="10">
            <img id="scrollbar3" src="images/vod/btv-02-scrollbar03.png" border="0" width="13" height="10">
        </div>
    </div>
</div>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;"></div>
<div style="position:absolute;width:870px; height:40px; left: 330px; top: 640px; color:black;font-size:22px;">
    <div style="position:absolute;width:60px; height:32px; left: 200px; top: -1px; color:black;font-size:22px;">
        <img src="images/tvod/btv-btn-page_left.png" alt="" style="position:absolute;left:0;top:0px;">
    </div>
    <div style="position:absolute;width:120px; height:30px; left: 260px; top: 0px; color:white; font-size:22px;">
        &nbsp;前一月
    </div>
    <div style="position:absolute;width:60px; height:32px; left: 380px; top: -2px; color:black; font-size:22px;">
        <img src="images/tvod/btv_page_right.png" alt="" style="position:absolute;left:0px;top:0px;">
    </div>
    <div style="position:absolute;width:120px; height:30px; left: 440px; top: 0px; color:white; font-size:22px;">
        &nbsp;后一月
    </div>
    <div style="position:absolute;width:60px; height:32px; left: 560px; top: -1px; color:black;font-size:22px;">
        <img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
    </div>
    <div style="position:absolute;width:120px; height:30px; left: 620px; top: 0px; color:white; font-size:22px;">
        &nbsp;上一页
    </div>
    <div style="position:absolute;width:60px; height:32px; left: 740px; top: -2px; color:black; font-size:22px;">
        <img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
    </div>
    <div style="position:absolute;width:120px; height:30px; left: 800px; top: 0px; color:white; font-size:22px;">
        &nbsp;下一页
    </div>
</div>
<script type="text/javascript">
    init(1);
    pagecount="<%=pagecount%>";
    totalcount="<%=totalcount%>";
    showScrollBar();
    document.getElementById("totalprice").innerText=totalPrice+"元";    
</script>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>
