
<script language="javascript" type="">

    function doPublicRed(){
        // if(window.navigator.appName.indexOf("ztebw")>=0){
            top.mainWin.document.location = "<%=path%>channel_all_pre.jsp";
        // }else{
            // top.mainWin.document.location = "<%=path%>channel_all.jsp";
        // }
        top.showOSD(2, 0, 0);
        top.setBwAlpha(0);
    }

    function doPublicGreen(){
        top.mainWin.document.location =  "<%=path%>channel_all_tvod.jsp";
        top.showOSD(2, 0, 0);
        top.setBwAlpha(0);
    }

    function doPublicYellow(){
        // if(window.navigator.appName.indexOf("ztebw")>=0){
            top.mainWin.document.location = "<%=path%>vod_portal_pre.jsp?leefocus=xx";
        // }else{
            // top.mainWin.document.location = "<%=path%>vod_portal.jsp?leefocus=xx";
        // }
        top.showOSD(2, 0, 0);
        top.setBwAlpha(0);
    }

    function doPublicBlue(){
        top.mainWin.document.location = "<%=path%>vod_search.jsp";
        top.showOSD(2, 0, 0);
        top.setBwAlpha(0);
    }

    top.jsSetVideoKeyFunction("top.extrWin.doPublicRed", 0x0113);
    top.jsSetVideoKeyFunction("top.extrWin.doPublicGreen", 0x0114);
    top.jsSetVideoKeyFunction("top.extrWin.doPublicYellow", 0x0115);
    top.jsSetVideoKeyFunction("top.extrWin.doPublicBlue", 0x0116);

</script>
