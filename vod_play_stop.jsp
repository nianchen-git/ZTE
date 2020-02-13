<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
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
<%
     String path = getPath(request.getRequestURI());
%>
<html>
<head>
    <title>osd</title>
    <script language="javascript">
        function delayStop() {
            top.vodBackTimer = top.setTimeout("top.switchToStopOSDUrl(0)", 600);
           <%--top.setTimeout("top.mainWin.document.location='<%=path%>back.jsp'",1000);--%>
        }
        //Stop
        function pageDoVodStop() {
            var currentChannel = top.channelInfo.currentChannel;
            if (currentChannel == -1) {
                currentChannel = top.channelInfo.lastChannel;
            }
            delayStop();
            top.jsHideOSD();
            top.doStop();
            top.setBwAlpha(0);
            if (top.channelInfoArr[currentChannel] != undefined && top.channelInfoArr[currentChannel] != null) {
                if (top.channelInfoArr[currentChannel].channelType != 3) {
                    top.jsRedirectChannel(currentChannel);
                }
            }
        }
        //Mark and Stop
        function pageDoVODMark()
        {
            top.setBwAlpha(0);
            top.jsSaveFaver();//添加书签，方法在框架中
            pageDoVodStop();
        }
        //cancle
        function disablePageWithoutTimer()
        {
            top.jsHideOSD();
        }
        function changeImage(flag, id) {
            if(flag==1){
                document.getElementById(id).style.visibility ="visible";
                document.getElementById(id+"0").style.visibility ="hidden";
            }else{
                document.getElementById(id).style.visibility ="hidden";             
                document.getElementById(id+"0").style.visibility ="visible";             
            }
        }
        document.onkeypress = top.doKeyPress;
        focus();
    </script>
</head>
<body bgcolor="transparent">
<div style="left:176px; top:244px;width:612px;height:230px; position:absolute;">
    <img src="images/vod/btv_promptbg3.png" border="0" alt="">
</div>


<!--Mark and Stop-->
<div style="left:370; top:10;width:142px;height:32px; position:absolute;">
    <a href="javascript:pageDoVODMark();" name="llinkerplay1"
       onFocus="changeImage('1','divplay');"
       onBlur="changeImage('0','divplay')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div style="left:212; top:416px;width:175px;height:36px; position:absolute;">
    <%--<div id="divplay0" style="left:0; top:0px;width:175px;height:36px; position:absolute;visibility:hidden">--%>
	<div style="left:0; top:0px;width:175px;height:36px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquitb.png" width="175" height="36" border="0" alt=""/>
    </div>
    <div id="divplay" style="left:0; top:0px;width:175px;height:36px; position:absolute;visibility:visible">
        <img src="images/vod/btv-02-add-bookmarkc2.png" width="175" height="36" border="0" alt=""/>
    </div>
</div>
<!--stop-->
<div style="left:550; top:10;width:90;height:30px; position:absolute;">
    <a href="javascript:pageDoVodStop();" name="llinkerplay"
       onFocus="changeImage('1','divtrail');"
       onBlur="changeImage('0','divtrail')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div  style="left:397; top:416px;width:175;height:36px; position:absolute;">
    <%--<div id="divtrail0" style="left:0; top:0px;width:175;height:36px; position:absolute;">--%>
	<div style="left:0; top:0px;width:175;height:36px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquit2.png" width="175" height="36" border="0" alt=""/>
    </div>
    <div id="divtrail" style="left:0; top:0px;width:175;height:36px; position:absolute;visibility:hidden">
        <img src="images/vod/btv-02-add-bookmarkc2.png" width="175" height="36" border="0" alt=""/>
    </div>
</div>
<!--cancle-->
<div style="left:730; top:10px;width:94px;height:30px; position:absolute;">
    <a href="javascript:disablePageWithoutTimer();" name="llinkerplay2"
       onFocus="changeImage('1','canclediv');"
       onBlur="changeImage('0','canclediv')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div style="left:582; top:416px;width:175px;height:36px; position:absolute;">
    <%--<div id="canclediv0" style="left:0; top:0;width:175px;height:36px; position:absolute;">--%>
	<div style="left:0; top:0;width:175px;height:36px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquitq2.png" width="175" height="36" border="0" alt=""/>
    </div>
    <div id="canclediv"  style="left:0; top:0px;width:175px;height:36px; position:absolute;visibility:hidden">
		<img src="images/vod/btv-02-add-bookmarkc2.png" width="175" height="36" border="0" alt=""/>
    </div>
</div>
</div>
<script language="javascript">
    if (document.links["llinkerplay"] != null){
        changeImage('0','divplay');
        document.links["llinkerplay"].focus();
    }
</script>
<div style="left:798px; top:244px;width:306px;height:230px; position:absolute;">
    <img src="" id="advert_pic" border="0" alt="" width="306" height="230">
</div>
</body>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script type="text/javascript" >
		function $(id){
    		return document.getElementById(id);
		}
		if(play_flag_pic==0){
			for(var i=0;i<advert_pic.length;i++){
				if(advert_pic[i].areaName=="quit"){
					$("advert_pic").src = "images/advert/"+ advert_pic[i].picName;
					break;
				}
			}
		}
	</script>
</html>
