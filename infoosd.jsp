<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodOneDataSource" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<html>
<head>
    <script type="text/javascript">
        function osdkeypress(evt) {
            var keyCode = parseInt(evt.which);
            if (keyCode == 0x0028) {

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
               _window.top.mainWin.document.location = "portal.jsp";
            } else if (keyCode == 0x0110) {
        //Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keyCode == 36) {
        _window.top.mainWin.document.location = "portal.jsp";
    }else if(keyCode == 0x000D){
				doJump();//OK键跳转  去掉点播信息页点击图片OK跳转
			}else if (keyCode == 0x0026) {

            } else if (keyCode == 0x0025) { //onKeyLeft

            } else if (keyCode == 0x0027) { //onKeyRight

            } else if (keyCode == 0x0008  || keyCode == 24 || keyCode == 0x010c ) {///back
                hiddenOSD();
            } else {
                //                clearStack();
//                top.onkeypress(evt);
                top.doKeyPress(evt);
                return true;
            }
            return false;
        }

    </script>
</head>
<%!
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
<epg:script/>
<script type="text/javascript">
    function showDescripton(description) {
        var des = description;
        if (des.length > 70) {
            des = des.substr(0, 70) + "...";
        }
        document.write("<font  style=' word-break:break-all; ' >" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + des + "</font>");
    }
    function getLength(contentlength)
    {
        var hours = contentlength.split(':');
        var minutes = 0;
        if (hours[0] > 0) {
            minutes = hours[0] * 60;
        }
        var showMinutes = parseInt(minutes) + parseInt(hours[1])
        document.write(showMinutes + "分钟");
    }


</script>
<%
    String columnid=request.getParameter("columnid");
    String programid=request.getParameter("programid");
    String programtype=request.getParameter("programtype");

    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    VodOneDataSource ds=new VodOneDataSource();
    VoDQueryValueIn valueIn=(VoDQueryValueIn)ds.getValueIn();
    valueIn.setColumnId(columnid);
    valueIn.setProgramId(programid);
    valueIn.setUserInfo(userInfo);

    //!=1就是连续剧了
    if(programtype!=null && !programtype.equals("") && !programtype.equals("1")){
        System.out.println("SSSSSSSSSSSSSSSSSSSS1111");
        valueIn.setVoDType(CodeBook.VOD_TYPE_SERIES_Head);
    }

    EpgResult result=ds.getData();
    Vector vector=(Vector)result.getData();
    VoDContentInfo vodInfo = null;
    String actor = "";
    String director = "";
     String programName = "";
    String description = "";
//System.out.println("==aaaaaaaaaaaa==");
    if(vector!=null && vector.size()>0){
	//alert("aaaaaaaaaaaaaaaaaaa");
        vodInfo = (VoDContentInfo)vector.get(0);
        actor = vodInfo.getActor();
        director = vodInfo.getDirector();
        programName = vodInfo.getProgramName();
        description = vodInfo.getDescription();
		//alert("description="+description);
		System.out.println("==description=="+description);
    }
	

       if(programName.length()>49){
        programName = programName.substring(0,49)+"...";
    }
    if(actor.length()>15){
        actor = actor.substring(0,15)+"...";
    }
    if(director.length()>11){
        director = director.substring(0,11)+"...";
    }

    if(description.length()>70){
        description = description.substring(0,70)+"...";
    }

%>

<body bgcolor="transparent">
<%--info背景图片--%>
<div id="pasuse_ad" style="left:30px; top:540px;width:1220px;height:130px; position:absolute">
    <img src="images/vod/btv-02-bottombg3.png" width="1220px" height="130px" border="0" alt="" />
</div>
<!--片名-->


<%--<epg:div left="153" top="575" width="480" height="34" type="text" field="ProgramName" datasource="VodOneDecorator">--%>
<%--    <epg:formatter size="5" color="#CC0000" pattern="50." bolded="true"/>--%>
<div style=" left:50px; top:550px;width:980px;height:34px; position:absolute;font-size:25px;color:#CC0000;">
    <%=programName%>
</div>
<%--</epg:div>--%>
<%
    if(!director.equals("")){
%>
<!--导演-->
<div style="position:absolute; width:320px; height:22px; left:220px; top: 580px; color:#FFFFFF;font-size:20px;">
    导演：<%=director%>
</div>
<%--<epg:div left="153" top="604" width="380" height="36" field="Director" datasource="VodOneDecorator">--%>
  <%--  <epg:formatter size="5" color="#FFFFFF" pattern="20.0"/>--%>
<%--</epg:div>--%>

<%
    }

    if(!actor.equals("")){
%>
<!--主演-->
<div style="position:absolute; width:360px; height:22px; left: 540px; top: 580px; font-size:20px;color:#FFFFFF;">
    主演：<%=actor%>
</div>
<%--<epg:div left="548" top="604" width="550" height="36" field="Actor" datasource="VodOneDecorator">--%>
  <%--  <epg:formatter size="5" color="#FFFFFF" pattern="20.0"/>--%>

<%--</epg:div>--%>

<%
    }
%>

<!--时长-->
<div style="position:absolute; width:70px; height:22px; left: 50px; top: 580px;color:#FFFFFF;font-size:20px ;">
    时长：
</div>
<div id="endTime" style="position:absolute; width:120px; height:22px; left: 120px; top: 580px;color:#FFFFFF;font-size:20px ;"></div>
<!--介绍-->
<div style="position:absolute; width:827px; height:50px; left: 50px; top: 617px; font-size:20px;color:#FFFFFF">简介: <%=description%>
</div>
<%--<epg:div left="88" top="636" width="1150" height="60" type="script" data="showDescripton('{Description}');"
         datasource="VodOneDecorator">--%>
  <%--  <epg:formatter bolded="false" size="5" color="#FFFFFF" pattern="20."/>--%>
  <%--</epg:div>--%>

<%--<div style="left:1100; top:580;width:80;height:27; position:absolute;font-size:22px;color:#FFFFFF"
     id="currentTimeDiv"></div>--%>
    <div  id="advert" style="position:absolute; width:330px; height:110px; left:900px; top: 546px;visibility:hidden;">
        <img src="" id="advert_pic" alt="" width="330" height="110" border="0">
    </div>
    <!--<div  style="position:absolute; width:330px; height:110px; left:1134px; top: 476px;">
        <img src="images/vod/zhaoshang.png" alt="" width="134" height="109" border="0">
    </div>-->
<script type="text/javascript">
var VODTotalHours=0;
var VODTotalMinutes =0;
    function getTimeLength() {
        var duration = top.jsDoGetVODTimeInfo();
        var VODTimeInfo = parseInt(duration);
        var VODTotalMinutes = VODTimeInfo / 60;  
		if(VODTimeInfo==0||VODTimeInfo==""||VODTimeInfo==null){
			setTimeout(getTimeLength(),0.2);
			return;
		}
		VODTotalMinutes = parseInt(VODTotalMinutes);
        if (VODTotalMinutes < 1) {
            VODTotalMinutes = 1;
        }
        VODTotalMinutes = VODTotalMinutes;
        top.mainWin.document.all.endTime.innerHTML = VODTotalMinutes + "分钟";
    }
    function refreshCurrentTime() {
        var currentTime = top.jsGetCurrentPlayTime();
		System.out.println("==currentTime=="+currentTime);
        var VODTimeInfo = parseInt(currentTime,10);
         VODTotalHours = VODTimeInfo / 3600 ;
		 System.out.println("==VODTotalHours 111=="+VODTotalHours);
        VODTotalHours = parseInt(VODTotalHours,10);
		System.out.println("==VODTotalHours 222=="+VODTotalHours);
        if (("" + VODTotalHours).length == 1)
        {
            VODTotalHours = "0" + VODTotalHours;
        }
		System.out.println("==VODTotalHours 333=="+VODTotalHours);
        var StrVODTotalHours = VODTotalHours;
		System.out.println("==StrVODTotalHours 222=="+StrVODTotalHours);
        VODTotalHours = parseInt(VODTotalHours, 10);
         VODTotalMinutes = (VODTimeInfo - VODTotalHours * 3600) / 60;
        VODTotalMinutes = parseInt(VODTotalMinutes);
        if (("" + VODTotalMinutes).length == 1)
        {
            VODTotalMinutes = "0" + VODTotalMinutes;
        }
      top.mainWin.document.all.currentTimeDiv.innerHTML = StrVODTotalHours + ":" + VODTotalMinutes + "";
    }
	
	
    function hiddenOSD() {
        top.jsHideOSD();
    }
    getTimeLength();
   // refreshCurrentTime();
    setTimeout(hiddenOSD, 6000);
    <%--top.jsSetupKeyFunction("top.mainWin.hiddenOSD", <%=STBKeysNew.remoteBack%>);    --%>
    document.onkeypress = osdkeypress;


</script>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script type="text/javascript" >
		function $(id){
    		return document.getElementById(id);
		}
		if(play_flag_pic==0){
			var columnIda = "<%=columnid%>".substr(0, 2);
            $("advert_pic").src = "images/advert/"+ column_pic[0].info_pic;
			$("advert").style.visibility="visible";
			$("advert").style.border = "4px solid red";       //广告位默认图片边框
			for(var i=0;i<column_pic.length;i++){
				if(column_pic[i].category_id==columnIda){
					$("advert_pic").src = "images/advert/"+ column_pic[i].info_pic;
					break;
				}
			}
		}
		function doJump(){
			for(var j=0;j<advert_pic_jump.length;j++){
				if(advert_pic_jump[j].name=="live6"){
					top.doStop();     //点播信息页广告图片点击的跳转
					top.mainWin.document.location = advert_pic_jump[j].url;
					return;
				}
			}
		}
	</script>
</body>
</html>