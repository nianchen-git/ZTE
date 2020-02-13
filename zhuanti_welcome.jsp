<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<epg:PageController name="back.jsp"/>
<html>
<head>
    <title>×¨Ìâ</title>
    <script type="text/javascript" src="js/contentloader.js"></script>

        <script type="text/javascript" >
            function keyPress(evt) {
                var keyCode = parseInt(evt.which);
                if (keyCode == 0x0028) { //onKeyDown
                } else if (keyCode == 0x0026) {//onKeyUp
                } else if (keyCode == 0x0025) { //onKeyLeft
                } else if (keyCode == 0x0027) { //onKeyRight
                } else if (keyCode == 0x0022) {  //page down
                } else if (keyCode == 0x0021) { //page up
                } else if (keyCode == 0x0008 || keyCode == 24) {///back
                    goBack();
                } else if (keyCode == 0x000D) {  //OK
                } else {
                    commonKeyPress(evt);
                    return true;
                }
                return false;
        }
        function goBack() {
            document.location = "back.jsp";
        }
        document.onkeypress = keyPress;
    </script>
</head>

<body bgcolor="transparent">
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
      <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>