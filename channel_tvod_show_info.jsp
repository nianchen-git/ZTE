<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
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
<%@ page import="java.text.DateFormat" %>
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
    String timeprev = String.valueOf(param.get("param"));
    int timeprei = 7;
    try{
        timeprei = Integer.parseInt(timeprev);
    }catch (Exception e){

    }
    SimpleDateFormat formatOutputHour = new SimpleDateFormat("HH:mm");
	SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd");
    String curdate = request.getParameter("curdate");
    String prevueid = request.getParameter("prevueid");

    System.out.println("SSSSSSSSSSSSSSSSSchannel_tvod_show_info_queryStirng="+request.getQueryString());

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
//    ChannelNo = "-1";
    String ChannelCode =ci.getChannelId();
    String ChannelName = ci.getChannelName();

    if(ChannelName.length()>50){
        ChannelName = ChannelName.substring(0,49);
    }

	String startTime = formatOutputHour.format(new Date());
	startTime = startTime == null ? "" : startTime;

	ChannelOneForeshowDataSource oneFs=new ChannelOneForeshowDataSource();
	ChannelForeshowQueryValueIn valueIn= (ChannelForeshowQueryValueIn)oneFs.getValueIn();
	valueIn.setUserInfo(userInfo);
	valueIn.setDate(curdate);
    valueIn.setStartTime("00:00");
	valueIn.setEndTime("23:59");
	valueIn.setColumnId(columnId);
	valueIn.setChannelId(channelId);



	String endtime = "";
    String curProgramName ="";
    String startime = "";
    List channelProgramList = new ArrayList();
    Map programMap = null;
	try{
		EpgResult result=oneFs.getData();
		ChannelOneForeshowDecorator oneDs=new ChannelOneForeshowDecorator();
		EpgResult trueResult=oneDs.decorate(result);
		Map dataOut = (Map) trueResult.getDataOut().get(EpgResult.DATA);

		if (dataOut != null) {
			List oneProgramNameV= (Vector)dataOut.get("Programname");
			List oneStartTimeV=(Vector)dataOut.get("StartTimeF");
			List oneEndTimeV=(Vector)dataOut.get("EndTimeF");
			List onePrevueidV = (Vector)dataOut.get("Prevueid");
            List oneContentCodeV = (Vector)dataOut.get("ContentId");
            List oneRecordsystem = (Vector)dataOut.get("Recordsystem");
            List onePlayable = (Vector)dataOut.get("IsPlayable");
//            System.out.println("dvrinfo 0 ************ oneProgramNameV.size()"+oneProgramNameV.size());
            programMap = new HashMap();
            boolean allowadd = false;
			for(int i=0;i<oneProgramNameV.size();i++) {
				startime = (String)oneStartTimeV.get(i);
				endtime = (String)oneEndTimeV.get(i);
				String prevueidTemp = String.valueOf(onePrevueidV.get(i));
                String contentid = String.valueOf(oneContentCodeV.get(i));
                String playable = String.valueOf(onePlayable.get(i));
                String recordsystem = String.valueOf(oneRecordsystem.get(i));
                if(prevueidTemp.equals(prevueid)){
                    //添加之前一个节目哪怕是空的
//                    System.out.println("SSSSSSSSSSSSSSSTTTTTT");
                    if(programMap.isEmpty()){
                        programMap = new HashMap();
                        programMap.put("startime","");
                        programMap.put("endtime","   ");
                        programMap.put("programname","无节目");
                        channelProgramList.add(programMap);
                    }else{
                        channelProgramList.add(programMap);
                    }
                    allowadd = true;
                }

                curProgramName = (String)oneProgramNameV.get(i);
                programMap = new HashMap();
                programMap.put("startime",startime);
                programMap.put("endtime",endtime);
                programMap.put("programname",curProgramName);
                programMap.put("Prevueid",prevueidTemp);
                programMap.put("contentid",contentid);
                programMap.put("playable",playable);
                programMap.put("recordsystem",recordsystem);

                if(allowadd){
                    channelProgramList.add(programMap);
                }

                if(channelProgramList.size() >= 3){
                    break;
                }
			}

            while(channelProgramList.size() <3){
                 programMap = new HashMap();
                 programMap.put("startime","");
                 programMap.put("endtime","   ");
                 programMap.put("programname","无节目");
                 channelProgramList.add(programMap);
            }
        }
    }catch (Exception e){
        System.out.println("channel play for show programinfo error!!!");
        e.printStackTrace();
    }

    Map preMap = (Map)channelProgramList.get(0);
    String preUrlStr = "";

    Date nowDate = new Date();
    DateFormat df = new SimpleDateFormat("yyyy.MM.dd HH:mm");


    if(preMap.get("Prevueid")!=null){
        StringBuffer preUrl = new StringBuffer("channel_tvod_auth.jsp?columnid=");
        preUrl.append(columnId).append("&prevueid=").append(preMap.get("Prevueid"))
        .append("&programid=").append(preMap.get("contentid"))
        .append("&contentCode=").append(preMap.get("contentid"))
        .append("&ContentType=4&type=tvod")
        .append("&CategoryID=").append(columnId)
        .append("&ContentID=").append(channelId)
        .append("&FatherContent=").append(channelId)
        .append("&channelid=").append(channelId);
//         Date curDate = formatOutput.parse(curdate);
        nowDate.setTime(nowDate.getTime()-timeprei*1000*60*60*24);
        String MaxPreDayStr = formatOutput.format(nowDate);
        System.out.println("SSSSSSSSSSSSSSSSSSSSMaxPreDayStr="+MaxPreDayStr);
//        System.out.println("ssssssss="+"7".compareTo("1"));
        if(!preMap.get("playable").equals("true") || !preMap.get("recordsystem").equals("1")){
            preUrlStr = "";
        }else if(curdate.compareTo(MaxPreDayStr)>=0){
            preUrlStr = preUrl.toString();
        }else{
            preUrlStr = "";
        }
//        preUrlStr = "";
    }

    nowDate = new Date();
    Map nextMap = (Map)channelProgramList.get(2);
    String nextUrlStr = "";
    if(nextMap.get("Prevueid")!=null){
        Date endTimeS = df.parse(curdate+" "+nextMap.get("endtime"));
//        StringBuffer nextUrl = new StringBuffer("channel_tvod_play.jsp?columnid=");
//        nextUrl.append(columnId).append("&prevueid=").append(nextMap.get("Prevueid"))
//                .append("&programid=").append(nextMap.get("contentid"))
//                .append("&contentCode=").append(nextMap.get("contentid"))
//                .append("&channelid=").append(channelId);
        StringBuffer nextUrl = new StringBuffer("channel_tvod_auth.jsp?columnid=");
        nextUrl.append(columnId).append("&prevueid=").append(nextMap.get("Prevueid"))
                .append("&programid=").append(nextMap.get("contentid"))
                .append("&contentCode=").append(nextMap.get("contentid"))
                .append("&ContentType=4&type=tvod")
                .append("&CategoryID=").append(columnId)
                .append("&ContentID=").append(channelId)
                .append("&FatherContent=").append(channelId)
                .append("&channelid=").append(channelId);

        if(!nextMap.get("playable").equals("true") || !nextMap.get("recordsystem").equals("1")){
            nextUrlStr = "";
        }else if((endTimeS.getTime() - nowDate.getTime())>1*1000*60){
            nextUrlStr = "";
        }else{
            nextUrlStr = nextUrl.toString();
        }
    }

    System.out.println("SSSSSSSSSSSSSSSSpreUrlStr="+preUrlStr);
    System.out.println("SSSSSSSSSSSSSSSSnextUrlStr="+nextUrlStr);
%>

<script type="text/javascript" language="javascript">
    var leftPos = 1;
    var preUrlStr = "<%=preUrlStr%>";
    var nextUrlStr = "<%=nextUrlStr%>";

    function doLeft(){
        reSethideTime();
        leftPos = leftPos-1;
        if(leftPos == -1){
            //leftPos = 2;
			leftPos = 3;      //焦点到广告位图片
        }
		if(leftPos == 3){
           $("img_focus").style.visibility="hidden";
		   $("advert").style.border="4px solid red";  //回看信息页广告位图片边框
		   $("advert").style.top="546px";
		   return;
        }else{
		   $("img_focus").style.visibility="visible";
		   $("advert").style.border="none";
		   $("advert").style.top="550px";	
		}
        getImgFocus();
    }

    function doRight(){
        reSethideTime();
        leftPos = leftPos+1;
        /*if(leftPos == 3){
            leftPos = 0;
        } */      //焦点到广告位图片时推到0
		
		if(leftPos == 3){
           $("img_focus").style.visibility="hidden";
		   $("advert").style.border="4px solid red";  //回看信息页广告位图片边框
		   $("advert").style.top="546px";
		   return;
        }
		if(leftPos > 3){
			leftPos = 0;
			$("img_focus").style.visibility="visible";
		    $("advert").style.border="none";
			$("advert").style.top="550px";	
		}
		  getImgFocus();
    }

    function getImgFocus(){
        document.getElementById("img_focus").style.left = leftPos*280+18;
    }

    function doOk(){
        if(leftPos == 0){
            if(preUrlStr){
                document.location = preUrlStr;
            }
        }else if(leftPos == 2){
            if(nextUrlStr){
                document.location = nextUrlStr;
            }
        }else if(leftPos == 3){//如果是广告位
			if(nextUrlStr){
				doJump();
			}
		}
    }

	function channelKeyPress(evt){
		var keyCode = parseInt(evt.which);
		if (keyCode == 0x0026)//onKeyUp
		{
             top.remoteChannelPlus();
    	} 
		else if (keyCode == 0x0028)//onKeyDown
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
            doLeft();
		}
		else if(keyCode == 0x0027)// onKeyRight
		{
            doRight();
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
            doOk();
		}
		else if(keyCode == 0x0115)//onKeyYellow
		{
		
		}
		else if(keyCode == 0x0008 || keyCode == 24)//remoteBack
		{
            top.jsHideOSD();
		}else if(keyCode == 0x0110){
           /* if("CTCSetConfig" in Authentication)
            {
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
             //   alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            top.mainWin.document.location = "portal.jsp";
        }else if(keyCode == 36){
            top.mainWin.document.location = "portal.jsp";
        }else if(keyCode==0x0101){ //频道加减键
              top.remoteChannelPlus();
        }else if(keyCode==0x0102){
              top.remoteChannelMinus();
        }else if(keyCode==0x010c){
            top.jsHideOSD();
        }else{
        	top.doKeyPress(evt);
        	return true;
    	}    
    	return false; 
	}

    document.onkeypress = channelKeyPress;

    var hideosdTimer = window.setTimeout("top.jsHideOSD();",6000);

    function reSethideTime(){
       window.clearTimeout(hideosdTimer);
        hideosdTimer = window.setTimeout("top.jsHideOSD();",6000);
    }

</script>

<body bgcolor="transparent">

    <%
//        System.out.println("========================ChannelName="+ChannelName);
    %>
	<div style="background:url('images/liveTV/channel_programinfo3.png'); left:30px;top:540px;position:absolute; width:1220px; height:130px;font-size:24px; color:#FFFFFF; " align="center">
        <div style="left:0px;top:0px;position:absolute; width:1220px;">
		
        <div style="left:40px; top:10px; position:absolute; height:33px; width:630px; line-height:33px; font-size:24px;" align="left" >
             <%=ChannelNo%> <%=ChannelName%>
        </div>
        <div style="left:680px; top:10px; position:absolute; height:33px; width:300px; line-height:33px;" align="left" >
            <font style="font-size:24px;"><%=curdate%>&nbsp;&nbsp;<%=startTime%></font>
        </div>
		<div id="img_focus" style="left:297px; font-size:24px; border:3px solid red;  top:39px;  position:absolute; height:77px; width:277px; " >
            <img name="bottom_bg" src="images/channel/channel_bottom_focus2.png" width="277" height="77" alt=""/>
        </div>


        <%
            for(int i=0; i<channelProgramList.size(); i++){
                programMap = (HashMap)channelProgramList.get(i);
//                System.out.println("SSSSSSSSSSSSSSSSSSprogramMap.get(\"startime\")="+programMap.get("startime"));
                if(programMap.get("startime")!=null && !programMap.get("startime").equals("")){
//                    System.out.println("SSSSSSSSSSSSSSSSS1111");
                    programMap.put("startime",programMap.get("startime")+"-");
                }
                int leftpos = 20+280*i;
            if(i==channelProgramList.size()-1){
        %>
		
         <%--第三个--%>
        <div style="font-size:24px;  left:<%=leftpos+18%>px; top:56px;  position:absolute; height:78px; width:278px; " align="left" >
             <%=getFitStringNew(String.valueOf(programMap.get("programname")))%><br>
             <font style="font-size:18px;"><%=programMap.get("startime")%><%=programMap.get("endtime")%></font>
        </div>
        <%
            }else if(i==0){
        %>
        <div style="font-size:24px;  left:<%=leftpos+18%>px; top:56px;  position:absolute; height:78px; width:278px; " align="left" >
            <%=getFitStringNew(String.valueOf(programMap.get("programname")))%><br>
            <font style="font-size:18px;"><%=programMap.get("startime")%><%=programMap.get("endtime")%></font>
        </div>
            <%}else{%>
        <div style="font-size:24px;  left:<%=leftpos+18%>px; top:56px; position:absolute; height:78px; width:278px; " align="left" >
             <%=getFitStringNew(String.valueOf(programMap.get("programname")))%><br>
             <font style="font-size:18px;"><%=programMap.get("startime")%><%=programMap.get("endtime")%></font>
        </div>
        <%
             }
          }
        %>
        </div>


	</div>
    <div id="advert" style="position:absolute; width:330px; height:110px; left:902px; top: 550px;visibility:hidden;">
        <img src="" id="advert_pic" alt="" width="330" height="110" border="0">
    </div>
    <!--<div  style="position:absolute; width:330px; height:110px; left:1134px; top: 476px;">
    <img src="images/vod/zhaoshang.png" alt="" width="134" height="109" border="0">
    </div>-->
</body>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script type="text/javascript" >
		function $(id){
    		return document.getElementById(id);
		}
		if(play_flag_pic==0){
			$("advert").style.visibility = "visible";
			for(var i=0;i<advert_pic.length;i++){
				if(advert_pic[i].areaName=="tvodInfo"){
					$("advert_pic").src = "images/advert/"+ advert_pic[i].picName;
					break;
				}
			}
		}
		function doJump(){
			for(var j=0;j<advert_pic_jump.length;j++){
				if(advert_pic_jump[j].name=="live6"){
					top.doStop();         //回看信息页点击广告图片的跳转
					top.mainWin.document.location = advert_pic_jump[j].url;
					return;
				}
			}
		}
	</script>
</html>
<%@include file="inc/lastfocus.jsp"%>