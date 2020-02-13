<%@page contentType="text/html; charset=GBK"%>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants"%>
<%@page import="com.zte.iptv.epg.util.CodeBook"%>
<%@page import="com.zte.iptv.epg.util.STBKeysNew"%>
<epg:PageController name="olympic_index.jsp"/>
<html>
<head>
<title> template tool gernerated 2.0 </title>
<epg:script stopurl="true"/><%@include file="../js/linkbold.jsp"%>
<script language="javascript">
     if (typeof(ztebw) != 'undefined' && ztebw != null && typeof(ztebw.ioctlRead) == 'function')
     {
         var otherTVStandard = ztebw.ioctlRead("otherTVStandard");
         if (otherTVStandard != 1 && otherTVStandard != 2)
         {
             Authentication.CTCSetConfig('SetEpgMode', '720P');
         }
     }
</script>
<script language="javascript">
<!--
//-----------leewer comment javascript start------
function vod_Playy.jsp?columnid=0002&programid=0000003020000012&seriesprogramcode=0000003020000012&programtype=0(termtype,controlid)
{
    
}
//------------leewer comment javascript end-------
-->
</script>
</head>
<epg:xmlreader/>
<% if(request.getParameter(EpgConstants.RETURNFOCUS)!=null){%>
  <script language="javascript" type="">
   function include_lastfocus_focusMe(){
     document.links["<%=request.getParameter(EpgConstants.RETURNFOCUS)%>"].focus();
   }
    include_lastfocus_focusMe();
</script>
 <%}%>
<script language="javascript" type="">
  function back_shortcut(){
    document.location = "back.jsp";
  }
   top.jsSetupKeyFunction("top.mainWin.back_shortcut",<%=STBKeysNew.remoteBack%>);
</script>
<div style="left:550; top:50; width:90; height:100; position:absolute" id="channelNumber">
</div>
<script language="javascript" type="">
 var FONTHEAD = "<font color=\"00ff00\" size=\"8\" ><h1>";
var FONTTAIL = "</h1></font>";
  function showChannelNumber(channelNum){
    if (channelNum != null && channelNum != undefined){
        top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
   }
  function clearChannelNumber(){
       top.mainWin.document.all.channelNumber.innerHTML = "";
   }
</script>
</body>
</html>
