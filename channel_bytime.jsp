<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page import="com.zte.iptv.epg.util.EpgConstants"%>
<%@page import="com.zte.iptv.epg.web.Result"%>
<%@page import="com.zte.iptv.epg.content.BaseQueue"%>
<%@page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn"%>
<%@page import="com.zte.iptv.newepg.datasource.EpgResult"%>
<%@page import="com.zte.iptv.epg.content.ProgramInfo"%>
<%@page import="com.zte.iptv.epg.content.ChannelInfo"%>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.CodeBookNew"%>
<%@page import="com.zte.iptv.epg.util.PortalUtils"%>
<%@page import="com.zte.iptv.epg.util.*"%>
<%@page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.zte.iptv.newepg.datasource.EpgResult"%>
<%@page import="com.zte.iptv.newepg.decorator.ChannelOneForeshowDecorator"%>
<%@page import="com.zte.iptv.newepg.decorator.ChannelRecordForeshowDecorator"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.zte.iptv.newepg.tag.PageController"%>
<%@ include file="inc/ad_utils.jsp" %>
 <%@ include file="inc/getString_java.jsp" %>
<epg:PageController name="channel_bytime.jsp" />
<%!

 int channelWidth = 883;
 int leftPos = 314;


 String getFixedMixNo(String orgNumber){
    String tmpMixNo = orgNumber;
    if("-1".equals(orgNumber)){
        return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
    }
    if(tmpMixNo.length() < 3){
        tmpMixNo = (tmpMixNo.length() == 1 ? "00" : "0") + tmpMixNo;
    }
    return tmpMixNo;
}
	public String castNum(String str)
	{
		String temp = str;
		Integer intTemp = 0;
		try
		{
			intTemp = Integer.parseInt(str);
			if(intTemp < 10)
			{
				temp = "0" + intTemp;
			}
			else
			{
				temp = "" + intTemp;
			}
		}
		catch(Exception e)
		{
			intTemp = 0;
			temp = "01";
		}
		return temp;
	}
%>
<%
    long l1 = System.currentTimeMillis();

    String channelNum = "10";


    System.out.println("##################################3     channel_bytime1.jsp?"+request.getQueryString());
	String pageName = "channel_bytime.jsp";
	String isqucikmenu = request.getParameter("isqucikmenu");

	UserInfo ui = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
	String userId = ui.getUserId();
	String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
	HashMap param = PortalUtils.getParams(path, "GBK");

    String columnId = request.getParameter(EpgConstants.COLUMN_ID);
    if(null == columnId||columnId.equals("")){
        columnId = String.valueOf(param.get("column03"));
    }
	int curNum = 1;
	int sumNum = 1;
    int channelsNumber2show = Integer.parseInt(channelNum);
    String rowindex = request.getParameter("rowindex");
    rowindex = (rowindex==null)?"":rowindex;

//    System.out.println("==============rowindex="+rowindex);
%>
<%
//    long curTime2 = System.currentTimeMillis(); //curTime.getTime();
    boolean isDebuging = true;
//    String getNewFile = isDebuging?("?version="+curTime2):"";

    String imagesPath = "images";
%>
<html>
<head>
<%@include file="inc/chan_func_bytime.jsp" %>
<%@include file="inc/chan_time.jsp" %>

<title>channel_bytime</title>
<link rel="stylesheet" href="css/common.css" type="text/css" />
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript" src="js/STBKeyNew.js"></script>

<script language="javascript" type="">
var selectedChan = "<%=selectedChan%>";
var canRight = <%=canRight%>;
var canLeft = <%=canLeft%>;
var numper=<%=channelDisNum%>;
var curTime_g ="<%=curTime %>";

function goto(date,starthour,endhour,leefocus){
     var location = "channel_bytime.jsp?columnid=<%=request.getParameter(EpgConstants.COLUMN_ID)%>";
     location = location+"&<%=EpgConstants.TIME_COUNT%>=<%=timeCount%>";
     location = location+"&<%=EpgConstants.INTERVAL%>=<%=interval %>";
     /***********date*********/
     location = location+"&<%=EpgConstants.DATE%>="+date;

     location = location+"&<%=EpgConstants.START_HOUR%>="+starthour;
     location = location+"&<%=EpgConstants.END_HOUR%>="+endhour;
     <%--location = location+"&isqucikmenu=<%=isqucikmenu%>";--%>

     /****** page *******/
     <% if(request.getParameter("destpage") != null) {%>
     location = location + '&destpage=<%=request.getParameter("destpage")%>';
     location = location + '&numperpage=<%=request.getParameter("numperpage")%>';
     location = location + '&pagecount=<%=request.getParameter("pagecount")%>';
     <% } %>

     location = location+"&leefocus="+leefocus;
     location = location+"&lastfocus=an_"+ lastRow + "0";
     document.location = location;
}

</script>
 <%
     String jsDebugStatus=(String)param.get("jsDebugStatus");
     if(jsDebugStatus!=null && jsDebugStatus.equals("1")){
 %>
    <script language="javascript" type="">
        <%@ include file="js/channel_bytime.js" %>
    </script>
 <%
     }else{
 %>
    <script type="text/javascript" src="js/channel_bytime.js"></script>
 <%
     }
 %>

</head>
<body bgcolor="transparent"  >

<div style=" left:0; top:0px; width:1280px; height:720px; position:absolute; ">
    <img src="images/mytv/btv_bg_daoshi.png" width="1280" height="720"/>
</div>
<%@ include file="inc/time.jsp" %>
<div class="topImg" style="font-size:20px;top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/channel/btv-mytv-ico.png'); left:13; top:8px; width:37px; height:35px; position:absolute; ">
    </div>
    <div align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
          我的TV  > 节目导视
    </div>
</div>

    <%--中间大图--%>
	<%--<div style="left:83;top:103px;position:absolute; width:1214px; height:525px;">--%>
		<%--<img src="images/mytv/mytv-tvguide_bg.png" width="1114" height="525" alt="" border="0"/>--%>
	<%--</div>--%>
    <div align="center" style=" font-size:24px; left:80px; top:103px; position:absolute; width:201px; height:42px; line-height:42px; color:#ffffff;">
		<%=dateString%>
	</div>
<%
    int countNum = Integer.parseInt(timeCount);
	for(int i=0; i<countNum; i++){
%>
	<!-- line bar -->
	<div style="left:<%=leftPos+ i*(channelWidth/countNum) %>; top:135;position:absolute; width:2px; height:7px; background-color:white; ">
	<%--<img src="images/liveTV/TVprogram_line_small.png" width="2" height="7" alt="" border="0"/>--%>
	</div>

    <%--<div style="left:<%=leftPos%>; top:86; width:<%=channelWidth%>px; height:10px; border:1px solid red; position:absolute">--%>
	<%--</div>--%>
<%
	}
%>
    <div id="channelList"><%-- 左侧频道信息 ---%>
    <%@include file="inc/channels_bytime.jsp"%>
<%
    int intdestpage = Integer.parseInt(destpage);

    StringBuffer arrayMixNo = new StringBuffer();
    StringBuffer arrayChanName = new StringBuffer();
    StringBuffer arraychannelBasicID = new StringBuffer();
    StringBuffer arrayLevelvalue = new StringBuffer();
    StringBuffer arrayIsCanLock = new StringBuffer();
    StringBuffer arrayIsLock = new StringBuffer();
    StringBuffer arrayRateID = new StringBuffer();

//    System.out.println("++++++++++++++++channelTotal="+channelTotal);

    for(int i=0;i<channelTotal;i++){
        arrayMixNo.append(channelObjectArr[i][5]).append(",");
        arrayChanName.append("'").append(channelObjectArr[i][3]).append("',");
        arraychannelBasicID.append("'").append(channelObjectArr[i][10]).append("',");
        arrayLevelvalue.append(channelObjectArr[i][11]).append(",");
        arrayIsCanLock.append(channelObjectArr[i][12]).append(",");
        arrayIsLock.append(channelObjectArr[i][13]).append(",");
        arrayRateID.append(channelObjectArr[i][14]).append(",");
        if(i < channelsNumber2show){
            //System.out.println("++++++++++++++++channelTotal="+channelObjectArr[i][3].toString());
            String channelNamme = channelObjectArr[i][3].toString();
             channelNamme=getFitString(channelNamme,24,176);
%>

    <div id="channel_<%=i%>" class="channelList">
        <%=getFixedMixNo(channelObjectArr[i][5].toString())%>
        <%--<%--%>
            <%--System.out.println("SSSSSSSSSSSSSSSSSS1TT="+channelObjectArr[i][5].toString());--%>
            <%--System.out.println("SSSSSSSSSSSSSSSSSS2TT="+getFixedMixNo(channelObjectArr[i][5].toString()));--%>
        <%--%>--%>
            <%--<img class="channelMark" src="<%=channelObjectArr[i][4].toString()%>">--%>
            <%=channelNamme%>
        </div>
    <%
        }
    }
%>
    </div>
<script language="javascript" type="">
    <%if(arrayMixNo.length() > 0){%>
    arrayMixNoObj = [<%=arrayMixNo.substring(0, arrayMixNo.length()-1).toString()%>];
    arrayChanNameObj = [<%=arrayChanName.substring(0, arrayChanName.length()-1).toString()%>];
    arraychannelBasicID = [<%=arraychannelBasicID.substring(0, arraychannelBasicID.length()-1).toString()%>];
    arrayLevelvalue = [<%=arrayLevelvalue.substring(0, arrayLevelvalue.length()-1).toString()%>];
    arrayIsCanLock = [<%=arrayIsCanLock.substring(0, arrayIsCanLock.length()-1).toString()%>];
    arrayIsLock = [<%=arrayIsLock.substring(0, arrayIsLock.length()-1).toString()%>];
    arrayRateID = [<%=arrayRateID.substring(0, arrayRateID.length()-1).toString()%>];
    <%}else{%>
    arrayMixNoObj = [];
    arrayChanNameObj = [];
    arraychannelBasicID = [];
    arrayLevelvalue = [];
    arrayIsCanLock = [];
    arrayIsLock = [];
    arrayRateID = [];
    <%}%>
</script>

<!-- Hours Line -->
<epg:table  left="<%=(leftPos-33)+""%>" top="110" width="<%=channelWidth+""%>" height="40" rows="1" cols="<%=timeCount %>" datasource="TimeSpanDecorator">
  <epg:col left="5" top="0" width="100" height="40" field="time" bgcolor="">
	<epg:formatter size="5" color="#FFFFFF" bolded="true"/>
  </epg:col>
</epg:table>

<!-- Channel foreshow list -->
<%
	String[] tables =null;
    int tableLength = 0;

    tables = formForeshowTables(request,channelDisNum,totalMin,49,"10");
    if(tables!=null){
        tableLength = tables.length;
    }
    for(int i=0; i<Integer.parseInt(channelNum); i++){
          int toppos = 149+48*i;
    %>
        <div id="bg_focus_<%=i%>" style="visibility:hidden; left:83px;  top:<%=toppos%>px;width:1115px;height:47px;font-size:22px;position:absolute; ">
            <img src="images/mytv/TVprogram_redline.png" width="1115" height="49" />
        </div>
    <%
     }
	for(int i = 0; tables != null && i < tables.length && i<channelsNumber2show; i++){
%>
    <%--<%--%>
        <%--System.out.println("tables["+i+"]="+tables[i]);--%>
    <%--%>--%>

	<div style="color:#FFFFFF; left:<%=leftPos%>;top:<%=149+i*(Integer.parseInt(span))%>;width:<%=channelWidth%>;height:49;position:absolute;">
		<%=tables[i]%>
	</div>
<%
	}
    if ("".equals(starthour)) {
        Calendar time = Calendar.getInstance();
          starthour=String.valueOf(time.get(Calendar.HOUR_OF_DAY));
    }

    int prevHour=Integer.parseInt(starthour)-totalMin/60;
    if(prevHour<0){
        if(!starthour.equals("00")){      // ?00??
        prevHour=0;
        starthour=String.valueOf(prevHour+totalMin/60);
        }else{
            prevHour=24+ prevHour;
        }
    }

    String sprevHour=String.valueOf(prevHour);
    if(sprevHour.length()<2){
         sprevHour= "0"+sprevHour;
    }
    if(starthour.length()<2){
         starthour= "0"+starthour;
    }

    int nextHour=Integer.parseInt(starthour)+totalMin/60;
    if(nextHour>=24){
        nextHour=nextHour-24;
    }

    int next2Hour=nextHour+totalMin/60;
    if(next2Hour>24){
        next2Hour=24;
        nextHour=24- totalMin/60;
    }

    String snextHour=String.valueOf(nextHour);
    if(snextHour.length()<2){
        snextHour="0"+snextHour;
    }
    String snext2Hour=String.valueOf(next2Hour);
    if(snext2Hour.length()<2){
        snext2Hour="0"+snext2Hour;
    }

    int nextHour3 = Integer.parseInt(starthour)+totalMin/120;
    int nextHour4 = nextHour3+totalMin/60;
    String snext3Hour=String.valueOf(nextHour3);
    if(snext3Hour.length()<2){
        snext3Hour="0"+snext3Hour;
    }

    String snext4Hour=String.valueOf(nextHour4);
    if(snext4Hour.length()<2){
        snext4Hour="0"+snext4Hour;
    }

    Calendar cDay = Calendar.getInstance();
    SimpleDateFormat curday = new SimpleDateFormat("yyyy.MM.dd");

    Date  curdate= curday.parse(inputStrDate);
    cDay.setTime(curdate);
    cDay.add(Calendar.DAY_OF_MONTH,-1);
    String prevdate=formatOutput.format(cDay.getTime());
    cDay.add(Calendar.DAY_OF_MONTH,2);
    String nextdate=formatOutput.format(cDay.getTime());
    if(starthour.equals("00")){
        starthour="24";
    }
%>

    <div id="bg_img" style="left:<%=leftPos%>px;top:149px;width:880px;height:480px;font-size:22px;position:absolute; ">
        <img id="bg_img_0" src="images/mytv/bg_black.png" width="880" height="480" />
    </div>
    <%@include file="inc/chan_paging_circle.jsp" %>
    <%@include file="inc/lastfocus.jsp" %>
    <div id="time_red_line" style="visibility:hidden; left:<%=leftPos%>; top:96; width:16px; height:532px; position:absolute">
        <img src="images/mytv/tvguide-vertical_red.png" width="16" height="532" />
	</div>
<%
//日期集合
    StringBuffer dateBuffer = new StringBuffer();
    Calendar todoyCal = Calendar.getInstance();
    String timeprev = String.valueOf(param.get("timeprev"));
    String timenext = String.valueOf(param.get("timenext"));

    int preMaxDay =Integer.parseInt(timeprev) + 1;
    int nextMaxDay = Integer.parseInt(timenext);
    todoyCal.add(Calendar.DATE, preMaxDay*(-1));

    int curDivIndex = 0;

    for(int i = 0;i<(preMaxDay+nextMaxDay);i++){
        todoyCal.add(Calendar.DATE, 1);
        dateBuffer.append(",'");
        dateBuffer.append(EpgUtility.date2str(todoyCal.getTime(),"yyyy.MM.dd"));
        dateBuffer.append("'");

        if(inputStrDate.equals(EpgUtility.date2str(todoyCal.getTime(),"yyyy.MM.dd"))){
            curDivIndex = i;
        }
    }
    int curDivPage4Date = curDivIndex / 4 - 1;
    int curDivPos4Date = curDivIndex % 4;

    long l3 = System.currentTimeMillis();

//    System.out.println("l3-l2="+(l3-l2));
%>

<script language="JavaScript">
    function showaddRemind(dellflag) {
        var timer;
        if (dellflag == 1) {
            $("text").innerText = "提醒成功";
            $("msg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else {
            $("text").innerText = "提醒失败";
            $("msg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        }
    }
     var columnid_str = "<%=columnId%>";

     var dateString = '<%=dateString %>';
     var sprevHour = '<%=sprevHour %>';
     var starthour = '<%=starthour %>';
     var prevdate = '<%=prevdate %>';
     var snextHour = <%=snextHour%>;
     var snext2Hour = <%=snext2Hour%>;
     var nextdate = "<%=nextdate%>";

</script>
<script type="text/javascript" id="fun_apps">

<%
    try{
//        System.out.println("======================dateString="+dateString);
        if(dateString.equals(todayTime) ){
              int starthour1 = Integer.parseInt(starthour);
%>
      function showTimeRedLine(){
          var requestUrl = "action/getnowtime.jsp";
          var loaderSearch = new net.ContentLoader(requestUrl, showTimeRedLineResponse);

          window.setTimeout("showTimeRedLine()",1000*5*60);
      }

      function showTimeRedLineResponse(){
            var results = this.req.responseText;
            var data = eval("(" + results + ")");
//          var today1 = new Date();
          var hours = data.hour;
          var minutes = data.minute;
          var hourSpace = hours - <%=starthour1%>;
          var minuteSpace = -1;

          if(hourSpace>=0){
             var minuteSpace = hourSpace*60+parseInt(minutes);
             var minuteparam = minuteSpace/<%=totalMin%>;
             if(minuteparam>=3/4 && minuteparam<=1){
                 gotoNext(dateString,'<%=snext3Hour%>','<%=snext4Hour%>','',nextdate);
                 return;
             }
             var redWidth = minuteparam*<%=channelWidth%>;
//              alert("========================redWidth="+redWidth);
             var leftpos = <%=leftPos-6%>+redWidth;

             var totalMin = parseInt('<%=totalMin%>');
             if(minuteSpace<totalMin){
                  $('bg_img_0').width = redWidth+"px";
                  showallbg();
             }else if(minuteSpace>totalMin){//全部当前时间以前
                  showallbg();
             }

//             alert("========================leftpos="+leftpos);
             <%--leftpos = 280+<%=channelWidth%>;--%>
             document.getElementById('time_red_line').style.visibility='visible';
             document.getElementById('time_red_line').style.left = leftpos+"px";
          }else{
             hideallbg();
          }
      }

      showTimeRedLine();
 <%
      }else if(dateString.compareTo(todayTime) >0){
 %>
       hideallbg();
 <%
      }else if(dateString.compareTo(todayTime) <0){
 %>
       showallbg();
 <%
      }
    }catch (Exception e){

    }

    String prevueid = request.getParameter("prevueid");
    prevueid = (prevueid==null)?"":prevueid;

    String lastfocus = request.getParameter("lastfocus");

    if(lastfocus!=null && !lastfocus.equals("")){
        prevueid = lastfocus;
    }

    String rowidx = request.getParameter("rowidx");

//    System.out.println("SSSSSSSSSSSSSSSSSSprevueid="+prevueid);

    long l2 = System.currentTimeMillis();
    System.out.println("l2-l1="+(l2-l1));
%>

<%--alert("SSSSSSSSSSSSSSSSSSSSSSStttttttt<%=prevueid%>");--%>
//alert("SSSSSSSSSSSSSSSSSSSS111111");
if('<%=prevueid%>' && document.links['an<%=prevueid%>']){
//    alert("SSSSSSSSSSSSSSSSSSSS222222");
    if(document.links['an<%=prevueid%>'].length>1){
        document.links['an<%=prevueid%>'][0].focus();
    }else{
        document.links['an<%=prevueid%>'].focus();
    }
}else if('<%=prevueid%>' && document.links['<%=prevueid%>']){
//    alert("SSSSSSSSSSSSSSSSSSSS333333");
    if(document.links['<%=prevueid%>'].length>1){
        document.links['<%=prevueid%>'][0].focus();
    }else{
        document.links['<%=prevueid%>'].focus();
    }
}else if('<%=rowindex%>'){
//    alert("SSSSSSSSSSSSSSSSSSSS3333331111");
    <%--alert("SSSSSSSSSSSSSSSSSSSSSSSbbbbbbban_<%=rowindex%>0");--%>
    if($('an_<%=rowindex%>0')){
        $('an_<%=rowindex%>0').focus();
    }
}else if(<%=(rowidx!=null && rowidx.equals("10"))%>){
//    alert("SSSSSSSSSSSSSSSSSSS444444444");
    if($('an_<%=tableLength-1%>0')){
        $('an_<%=tableLength-1%>0').focus();
    }
}else{
//    alert("SSSSSSSSSSSSSSSSSSS5555555");
    if($('an_00')){
        $('an_00').focus();
    }
}
</script>

<div align="center"  style="font-size:22px; color:#ffffff; line-height:31px;  position:absolute; width:1280px; height:35px; left:0px; top:640px;">
     <div style="color:#424242;   position:absolute; width:60px; height:31px; left:466px; top:0px;">
         上页
     </div>
    <div style="position:absolute; width:70px; height:31px; left:556px; top:0px;" align="center">
         上一页
     </div>
     <div style="color:#424242;   position:absolute; width:60px; height:31px; left:677px; top:0px;">
         下页
     </div>
    <div style="position:absolute; width:70px; height:31px; left:767px; top:0px;" align="center">
         下一页
     </div>
     <div style="position:absolute; width:120px; height:31px; left:967px; top:0px;">
         直播提醒
     </div>
     <div style="position:absolute; width:60px; height:31px; left:1163px; top:0px;">
         搜索
     </div>
</div>


<div id="msg" style="left:416px; top:289px;width:568px;height:262px; position:absolute;visibility:hidden;z-index:5">
    <div style="left:0px;top:0px;width:568px;height:262px;position:absolute;">
        <img src="images/vod/btv_promptbg.png" alt="" width="568" height="262" border="0"/>
    </div>

    <div id="text"  style="left:30px;top:100px;width:500px;height:34px;font-size:22px;color:#FFFFFF;position:absolute; " align="center">
    </div>
    <div id="closeMsg" style=" left:0px;top:200px;width:568px;height:34px; font-size:22px;color:#FFFFFF;position:absolute;" align="center">
         2秒自动关闭
    </div>
</div>
 <iframe width="0" height="0" name="operation" id="operation" src="empty.jsp" frameborder="0" scrolling="NO">
</iframe>
<%@ include file="inc/mailreminder.jsp" %>

</body>
</html>