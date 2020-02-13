<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<html>
<epg:PageController name="back.jsp"/>
<head>
    <title>thirdlink</title>
    <epg:script/>
</head>
<script>
    function doKeyPress(evt){
   var keycode = evt.which;
   if (keycode == <%=STBKeysNew.remoteBack%> || keycode == 24){
      document.location="back.jsp";
    }else if(keycode == 0x0110){
     /*  if("CTCSetConfig" in Authentication)
       {
        //   alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
           Authentication.CTCSetConfig("KeyValue","0x110");
       }else{
          // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
           Authentication.CUSetConfig("KeyValue","0x110");
       }*/
       top.mainWin.document.location="portal.jsp";
    }else if(keycode == 36){
       top.mainWin.document.location="portal.jsp";
    }else{
        //top.doKeyPress(evt);
        commonKeyPress(evt);
    }
    return false;
}
document.onkeypress = doKeyPress;
</script>

<body bgcolor="transparent">
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/third_bg.png" height="720" width="1280" alt="">
</div>

<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/goback.jsp" %>
</body>

</html>