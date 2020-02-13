<%@	page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<% if (request.getParameter("lastfocus") != null) {%>
<script language="javascript" type="">
    if (document.links["<%=request.getParameter(EpgConstants.RETURNFOCUS)%>"] != null)
        document.links["<%=request.getParameter(EpgConstants.RETURNFOCUS)%>"].focus();
</script>
<%}%>

<%--<div style="left:550; top:50; width:90; height:100; position:absolute" id="channelNumber">--%>
<div style="left:78%; top:7%; width:90; height:100; position:fixed" id="channelNumber">
</div>
<%--</div>--%>
<script language="javascript" type="">
     <%--<%@ include file="../js/lastfocus.js" %>--%>
var isZTE ="<h1>";//?????????  ?????h1??
if(window.navigator.appName.indexOf("ztebw")==-1){
    isZTE="";
}
    var FONTHEAD = "<font color='00FF00' size='8' >"+isZTE;
    var FONTTAIL = isZTE+"</font>";

    function showChannelNumber(channelNum)
    {
        if (channelNum != null && channelNum != undefined)
        {
            top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
    }

    function clearChannelNumber(){
        top.mainWin.document.all.channelNumber.innerHTML = "";
    }

    function do_nothing() {
        return false;
    }

   function commonKeyPress(evt){
        var keycode = evt.which;
//        alert("SSSSSSSSSSSSSSSSSSSlastfocus_commonKeyPress="+keycode);

        var _window_pre = window;
        if(window.opener){
            _window_pre = window.opener;
        }
        if(keycode==0x0101){ //频道加减键
            _window_pre.top.remoteChannelPlus();
        }else if(keycode==0x0102){
            _window_pre.top.remoteChannelMinus();
        }else if(keycode == 0x0110 || keycode == 36){ //36为联通的首页键值
           /* if(keycode == 36){
//                Authentication.CUSetConfig("KeyValue","36");
            }else{
                //Authentication.CTCSetConfig("KeyValue","0x110");
                if("CTCSetConfig" in Authentication)
                {
                 //   alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CTC");
                    Authentication.CTCSetConfig("KeyValue","0x110");
                }else{
                  //  alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CU");
                    Authentication.CUSetConfig("KeyValue","0x110");
                }
            }*/
            _window_pre.top.mainWin.document.location = "portal.jsp";
        }else if (keycode == 0x0008 || keycode == 24){  //24为联通返回键值
            _window_pre.top.mainWin.document.location = "back.jsp";
        }else{
            _window_pre.top.doKeyPress(evt);
        }
   }

    function doPublicRed(){
        //if(window.navigator.appName.indexOf("ztebw")>=0){
            top.mainWin.document.location = "channel_all_pre.jsp?leefocus=xx";
        // }else{
            // top.mainWin.document.location = "channel_all.jsp?leefocus=xx";
        // }
    }

    function doPublicGreen(){
        top.mainWin.document.location =  "channel_all_tvod.jsp?leefocus=xx";
    }

    function doPublicYellow(){
       // if(window.navigator.appName.indexOf("ztebw")>=0){
            top.mainWin.document.location = "vod_portal_pre.jsp?leefocus=xx";
        // }else{
            // top.mainWin.document.location = "vod_portal.jsp?leefocus=xx";
        // }
    }

    function doPublicBlue(){
        top.mainWin.document.location = "vod_search.jsp?leefocus=xx";
    }

    if(window.opener){
        window.opener.top.setBwAlpha(0);
        window.opener.top.jsEnableNumKey();
        window.opener.top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0105);
        window.opener.top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0103);
        window.opener.top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0104);
        //四色键
        window.opener.top.jsSetupKeyFunction("top.mainWin.doPublicRed", 0x0113);
        window.opener.top.jsSetupKeyFunction("top.mainWin.doPublicGreen", 0x0114);
        window.opener.top.jsSetupKeyFunction("top.mainWin.doPublicYellow", 0x0115);
        window.opener.top.jsSetupKeyFunction("top.mainWin.doPublicBlue", 0x0116);
    }else{
        top.setBwAlpha(0);
        top.jsEnableNumKey();
        top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0105);
        top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0103);
        top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0104);
        //四色键
        top.jsSetupKeyFunction("top.mainWin.doPublicRed", 0x0113);
        top.jsSetupKeyFunction("top.mainWin.doPublicGreen", 0x0114);
        top.jsSetupKeyFunction("top.mainWin.doPublicYellow", 0x0115);
        top.jsSetupKeyFunction("top.mainWin.doPublicBlue", 0x0116);
    }
//    alert("+++++++++++++++lastfocus++++");
</script>
<%--<script type="text/javascript" src="js/lastfocus.js"></script>--%>
