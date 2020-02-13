<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils"%>
<%@page import="java.util.*"%>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneDataSource" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.newepg.decorator.ChannelOneForeshowDecorator" %>
<%@include file="inc/words.jsp" %>

<epg:PageController/>

<html>
<head>
	<%--<link rel="stylesheet" href="css/fontcolor.css" type="text/css"> </link>--%>
</head>
<%--<script src="js/contentloader.js"></script>--%>
<%!
    /**
     * 判断字符是否为中文
     *
     * @param str
     *            指定的字符
     * @return true or false
     */
    public boolean isChinese(String str) {
        boolean value = false;
        String chinese = "[\u0391-\uFFE5]";
        if (str.matches(chinese)) {
            value = true;
        }
        return value;
    }


    /**
     * 获取字符串的长度，如果有中文，则每个中文字符计为2位
     *
     * @param value
     *            指定的字符串
     * @return 字符串的长度
     */
    public int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1 */
        for (int i = 0; i < value.length(); i++) {
            /* 获取一个字符 */
            String temp = value.substring(i, i + 1);
            /* 判断是否为中文字符 */
            if (isChinese(temp)) {
                /* 中文字符长度为2 */
                valueLength += 2;
            } else {
                /* 其他字符长度为1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }

    /**
     * 根据输入字符串的字体大小和div的宽度，截取不会折行的字符串，超过div宽度的后面加".."
     * @param text  原始字符串
     * @param px  字体大小，以px为单位
     * @param divwidth  div的宽度，以px为单位
     * @return 适合宽度的字符串
     */
    public String getFitString(String text, int px, int divwidth) {
        int curwidth = 0;
        String distext = "";
        int stringwidth = length(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (int i = 0; i < text.length(); i++) {
                String chartemp = text.substring(i, i + 1);
                if (isChinese(chartemp)) {
                    curwidth = curwidth + px;
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + chartemp;
            }
            distext = distext + "..";
        }
        return distext;
    }

    public String getFitStringNew(String text) {
        if(text!=null && text.length()>9){
            text = text.substring(0,9)+"...";
        }
        return text;
    }


%>

<%!
    public String formatDate(String str){
       StringBuffer sb = new  StringBuffer();

       sb.append(str.substring(0, 4)).append(str.substring(5, 7)).append(str.substring(8,10)).append(str.substring(11, 13)).append(str.substring(14,16)).append(str.substring(17,19));
       return sb.toString();
   }

    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }
%>
<%

    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    SimpleDateFormat formatOutputHour = new SimpleDateFormat("HH:mm");
	SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd");

    UserInfo userInfo = (UserInfo)pageContext.getSession().getAttribute(EpgConstants.USERINFO);
	String columnId = request.getParameter(EpgConstants.COLUMN_ID);
    String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
    String dateString = formatOutput.format(new Date());

    ChannelOneDataSource cod = new ChannelOneDataSource();
    ChannelQueryValueIn oneValueIn = (ChannelQueryValueIn)cod.getValueIn();
    oneValueIn.setUserInfo(userInfo);
    oneValueIn.setColumnId(columnId);
    oneValueIn.setChannelId(channelId);
    EpgResult es =cod.getData();
    ChannelInfo ci = (ChannelInfo)es.getDataAsInfo();

    String ChannelNo = ci.getMixNo()+"";
    String ChannelCode =ci.getChannelId();
    String ChannelName = ci.getChannelName();

    if(ChannelName.length()>50){
        ChannelName = ChannelName.substring(0,49);
    }

	String startTime = formatOutputHour.format(new Date());
	startTime = startTime == null ? "" : startTime;
    String startTimeStr = dateString+" 00:00:00";
    String curTimeStr = dateString+" "+startTime+":00";
    Calendar calendar = new GregorianCalendar();
    calendar.setTime(new Date());
    calendar.add(calendar.DAY_OF_YEAR, 1);
    String endTimeStr = formatOutput.format(calendar.getTime())+" 23:59:59";
    String prevueSql = " channelcode='"+ChannelCode+"' and begintime>'"+startTimeStr+"' and endtime<'"+endTimeStr+"'";
    String prevueOrder="begintime asc";
    Map programInfo = null;
    List channelPrevueList = new ArrayList();
    String fromplay = request.getParameter("fromplay");
%>

<ex:search tablename="user_channelprevue" fields="*" order="<%=prevueOrder%>" condition="<%=prevueSql%>" var="prevuelist">
    <%
        try{
            List<Map> prevueList = (List<Map>)pageContext.getAttribute("prevuelist");
            //out.print("777777prevueList.size()="+prevueList.size());
            //out.print("*****66666prevueList="+prevueList); 
            //if(prevueList!=null && prevueList.size()>0){
			for(int i=0;i<prevueList.size();i++){
				Map prevueInfo = (Map)prevueList.get(i);
				String prevueCode = (String)prevueInfo.get("prevuecode");
				String prevueName = (String)prevueInfo.get("prevuename");
				String beginTime = (String)prevueInfo.get("begintime");
				String endTime = (String)prevueInfo.get("endtime");
				if(curTimeStr.compareTo(endTime)<0){                       
					programInfo = new HashMap();
					programInfo.put("startime",beginTime.substring(11,16)+"-");
					programInfo.put("endtime",endTime.substring(11,16));
					programInfo.put("programname",prevueName);
					//out.println("6666666programInfo="+programInfo.toString());
					channelPrevueList.add(programInfo);
					if(channelPrevueList.size() >= 3){
						break;
					}
				}
			}
			while(channelPrevueList.size()<3){
				//out.print("***channelPrevueList.size()="+channelPrevueList.size());
				programInfo = new HashMap();
				programInfo.put("startime","  ");
				programInfo.put("endtime","   ");
				programInfo.put("programname","无节目");
				channelPrevueList.add(programInfo);
			}
    %>             
            
<body bgcolor="transparent">
    
    <div style="background:url('images/liveTV/channel_programinfo3.png'); left:30px;top:540px;position:absolute; width:1220px; height:130px; font-size:24px; color:#FFFFFF; ">
        <div style="left:0px;top:0px;position:absolute; width:1220px; ">
        <div style="left:40px; top:10px; position:absolute; height:33px; width:630px; line-height:33px; font-size:24px;" align="left" >
             <%=ChannelNo%> <%=ChannelName%>
        </div>
        <div style="left:680px; top:10px; position:absolute; height:33px; width:300px; line-height:33px;" align="left" >
             <font style="font-size:24px;"><%=dateString%>&nbsp;&nbsp;<%=startTime%></font>
        </div>
        <%
            for(int i=0; i<channelPrevueList.size(); i++){
                programInfo = (HashMap)channelPrevueList.get(i);
                int leftpos = 20+280*i;
                if(i==channelPrevueList.size()-1){
        %>

        <div style="font-size:24px;  left:<%=leftpos+18%>px; top:57px;  position:absolute; height:78px; width:278px; " align="left" >
             <%=getFitStringNew(String.valueOf(programInfo.get("programname")))%><br>
             <font style="font-size:18px;"><%=programInfo.get("startime")%><%=programInfo.get("endtime")%></font>
        </div>
			<%
                }else{
                    if(i==0){
                        String borderString = "border:2px solid red;";
                        if("无节目".equals(programInfo.get("programname"))){
                            borderString = "";
						}
			%>
            <div style="left:<%=leftpos+1%>px; font-size:24px;   top:41px;  position:absolute; height:78px; width:278px; " >
                <img name="bottom_bg" src="images/channel/channel_bottom_focus2.png" height="77" width="277" alt=""/>
            </div>
            <div style="font-size:24px;  left:<%=leftpos+18%>px; top:56px;  position:absolute; height:78px; width:278px; " align="left" >
                <%=getFitStringNew(String.valueOf(programInfo.get("programname")))%><br>
                <font style="font-size:18px;"><%=programInfo.get("startime")%><%=programInfo.get("endtime")%></font>
            </div>
					<%}else{%>
			<div style="font-size:24px;  left:<%=leftpos+18%>px; top:56px; position:absolute; height:78px; width:278px; " align="left" >
				 <%=getFitStringNew(String.valueOf(programInfo.get("programname")))%><br>
				 <font style="font-size:18px;"><%=programInfo.get("startime")%><%=programInfo.get("endtime")%></font>
			</div>
        <%
                    }
				}
			}
        %>
        </div>
    </div>

    <%
			//} 
        }catch (Exception e){
            System.out.println("channel play for show programinfo error!!!");
			out.print("*******error!!");
            e.printStackTrace();
        }
        
    %>
</ex:search>

    <%--4K提示--%>
    <div id="alert_text" style="position:absolute; left: 424px; top: 242px; width: 432px; height:234px; visibility:hidden;"><img src="images/4kjump.png" width="432" height="234"/></div>
    <%--海报--%>
    <%--<div  style="position:absolute; width:179px; height:73px; left:1039px; top: 572px;">--%>
        <%--<epg:FirstPage left="0" top="0" width="179" height="73" location="miniRight"/>--%>
    <%--</div>--%>
    <div id="advert" style="position:absolute; width:330px; height:110px; left:902px;
    top: 546px;border:4px solid red;visibility:hidden;">  <%--直播信息页广告图片--%>
        <img src="" id="advert_pic" alt="" width="330" height="110" border="0">
    </div>
    <!--<div  style="position:absolute; width:330px; height:110px; left:1134px; top: 476px;">
    <img src="images/vod/zhaoshang.png" alt="" width="134" height="109" border="0">
    </div>-->
</body>
	<%--<script>--%>
		<%--init();--%>
	<%--</script>--%>
    <script type="text/javascript" language="javascript">

top.jsSetControl("preMillisecond",60000);

/**
 * 4K
 */
    var stbType= Authentication.CTCGetConfig("STBType");
    
    var Channel_no= top.channelInfo.currentChannel;//获取当前频道号

    

	function channelKeyPress(evt){
		var keyCode = parseInt(evt.which);
		if (keyCode == 0x0026 || keyCode==0x0101)//onKeyUp
		{
            top.remoteChannelPlus();
    } 
		else if (keyCode == 0x0028 || keyCode==0x0102)//onKeyDown
		{
            top.remoteChannelMinus();
		}
       else if(keyCode == 265)// remoteFastRewind
        {
            return false;
        }
        else if(keyCode == 264)// remoteFastForworde
        {
            return false;
        }
        else if(keyCode == 263)// RmotePlayPause
        {
            return false;
        }
        else if(keyCode == 270)// remoteStop
        {
            return false;
        }
		else if(keyCode == 0x0025)// onKeyLeft
		{
		}
		else if(keyCode == 0x0027)// onKeyRight
		{
		}
		else if(keyCode == 0x0022)// remotePlayNext
		{
		}
		else if(keyCode == 0x0021)// remotePlayLast
		{
		}
		else if(keyCode == 0x000D)//onKeyOK
		{
//			gotoChannelOrderAuth();
			doJump();
		}
		else if(keyCode == 0x0115)//onKeyYellow
		{
		
		}
		else if(keyCode == 0x0008 || keyCode == 24)//remoteBack
		{
            top.jsHideOSD();
		}else if(keyCode == 0x0110){
          /*  if("CTCSetConfig" in Authentication)
            {
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            top.mainWin.document.location = "portal.jsp";
        top.showOSD(2, 0, 0);
    }else if(keyCode == 36){
      top.mainWin.document.location = "portal.jsp";
      top.showOSD(2, 0, 0);
    }else if(keyCode==0x010c){
        top.jsHideOSD();
    }else{
        top.doKeyPress(evt);
        return true;
    }        
    	return false; 
	}

    document.onkeypress = channelKeyPress;


    <%

    System.out.println("SSSSSSSSSSSSSSSSSfromplay="+fromplay);
    if(fromplay==null || "".equals(fromplay)){
    System.out.println("SSSSSSSSSSSSSSSSSjin_ru_le_fromplay=");
    %>
    window.onload = function(){
        showChannelNumber('<%=ChannelNo%>');
    }

    <%
    }
    %>

    window.setTimeout("top.jsHideOSD();",6000);

</script>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script type="text/javascript" >
		function $(id){
    		return document.getElementById(id);
		}
		if(play_flag_pic==0){
			$("advert").style.visibility = "visible";
            $("advert_pic").src = "images/advert/"+ channel_pic[0].info_pic;
			for(var i=0;i<channel_pic.length;i++){
				if(channel_pic[i].channel_id==<%=ChannelNo%>){
					$("advert_pic").src = "images/advert/"+ channel_pic[i].info_pic;
					break;
				}
			}
		}
		function doJump(){
			for(var j=0;j<advert_pic_jump.length;j++){
				if(advert_pic_jump[j].name=="live6"){
					top.doStop();  //直播信息页点击广告图片OK跳转
					top.mainWin.document.location = advert_pic_jump[j].url;
					return;
				}
			}
		}

    if(stbType != "EC6108V9U_pub_bjjlt" && stbType != "Q1" && stbType != "B860A" && stbType != "HG680-JLGEH-52" && stbType != "Q5" && stbType != "EC5108" && stbType != "B860AV1.2" && stbType != "Q7" && stbType != "S-010W-A" && stbType != "DTTV100" && stbType != "EC6108V9U_ONT_bjjlt"){
		// top.doStop();//黑屏
        // top.doLeaveChannel();
		if(Channel_no == 401 || Channel_no == 40){
			if(window.navigator.appName.indexOf("ztebw") >= 0){
          		top.doLeaveChannel();
       		 }
			$("alert_text").style.visibility = "visible";
		}
    } 
	</script>
</html>
	<%@include file="inc/lastfocus.jsp"%>