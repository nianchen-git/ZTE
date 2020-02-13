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
// top.mainWin.document.location = "<%=path%>back.jsp";
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
				   top.jsHideOSD();
                    top.jsSetControl("isFromChannel","1"); 
                    top.jsRedirectChannel(currentChannel);
                }
            }
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
function onkeypress(evt) {
            var keyCode = parseInt(evt.which);
           // alert("SSSSSSSSSSSSSSSSSonkeypress_keyCode="+keyCode);
            if (keyCode == 0x0008  || keyCode == 24) {  //back
                disablePageWithoutTimer();
                return false;
            } else {
                top.doKeyPress(evt);
                return true;
            }
            return false;
        }

        document.onkeypress = onkeypress;
    </script>
</head>
<body bgcolor="transparent">
<div style="left:250px; top:244px;width:464px;height:230px; position:absolute;">
    <img src="images/vod/btv_promptbg2.png" border="0" alt="" width="464" height="230">
</div>


<div style="position:absolute;width:400;height:30;left:283px;top:320;font-size:23px;color:#FFFFFF;" align="center">您是否要结束观看？</div>
<!--stop-->
<div style="left:450; top:10;width:90;height:30px; position:absolute;">
    <a href="javascript:pageDoVodStop();" name="llinkerplay"
       onFocus="changeImage('1','divtrail');"
       onBlur="changeImage('0','divtrail')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div  style="left:286; top:416px;width:175;height:36px; position:absolute;">
    <%--<div id="divtrail0" style="left:0; top:0px;width:175;height:36px; position:absolute;">--%>
	<div style="left:0; top:0px;width:175;height:36px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquit2.png" width="175" height="36" border="0" alt=""/>
    </div>
    <div id="divtrail" style="left:0; top:0px;width:175;height:36px; position:absolute;visibility:hidden">
        <img src="images/vod/btv-02-add-bookmarkc2.png" width="175" height="36" border="0" alt=""/>
    </div>
</div>


<!--cancle-->
<div style="left:650; top:10px;width:94px;height:30px; position:absolute;">
    <a href="javascript:disablePageWithoutTimer();" name="llinkerplay2"
       onFocus="changeImage('1','canclediv');"
       onBlur="changeImage('0','canclediv')">
        <img src="images/btn_trans.gif" width="1" height="1" border="0" alt=""/>
    </a>
</div>
<div style="left:505; top:416px;width:175px;height:36px; position:absolute;">
    <%--<div id="canclediv0" style="left:0; top:0;width:175px;height:36px; position:absolute;">--%>
    <div style="left:0; top:0;width:175px;height:36px; position:absolute;">
        <img src="images/vod/btv-02-add-bookmarkquitq2.png" width="176" height="38" border="0" alt=""/>
    </div>
    <div id="canclediv"  style="left:0; top:0px;width:175px;height:36px; position:absolute;visibility:hidden">
		<img src="images/vod/btv-02-add-bookmarkc2.png" width="175" height="36" border="0" alt=""/>
    </div>
</div>
<div style="left:724px; top:244px;width:306px;height:230px; position:absolute;">
    <img src="" id="advert_pic" border="0" alt="" width="306" height="230"></div>
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
