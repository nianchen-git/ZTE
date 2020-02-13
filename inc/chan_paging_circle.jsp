
<%
    // Previous channel page exists
    if(curNum > 1){
%>
    <div style="left:10; top:300;width:21;height:11; position:absolute">

    </div>
<% } // Next channel page exists
  if(curNum < sumNum){ %>
    <div style="left:10; top:441;width:21;height:11; position:absolute">

    </div>
<% } %>

<%
final String PARAMS[] = {"leefocus", "destpage", "numperpage", "pagecount", "lastfocus", "rowidx","rowindex"};
%>
<script language="JavaScript">
function clearExtraParams(text) {
//    alert("===============text="+text);
    var result  = text;
<% for(int i = 0; i < PARAMS.length; i++) { %>
    result = result.replace('&<%=PARAMS[i]%>=<%=request.getParameter(PARAMS[i])%>', "");
    result = result.replace('<%=PARAMS[i]%>=<%=request.getParameter(PARAMS[i])%>', "");
<% } %>
    return result;
}
<%
if(sumNum != 0){
  %>
  // Loop prev move
  function prevInCycle() {
        var url = "<%=pageName %>" + clearExtraParams("<%="?"+request.getQueryString()%>")
        + '&destpage=<%=((curNum+2*(sumNum -1))%sumNum + 1)%>'
        + '&numperpage=<%=String.valueOf(channelDisNum)%>&pagecount=<%=sumNum%>'
        + '&rowidx=10';
        document.location = url;
  }

  // Loop next move
  function nextInCycle() {
        var url = "<%=pageName %>" + clearExtraParams("<%="?"+request.getQueryString()%>")
        + '&destpage=<%=(curNum%sumNum + 1)%>'
        + '&numperpage=<%=String.valueOf(channelDisNum)%>&pagecount=<%=sumNum%>';
        document.location = url;
  }
<%
}
%>
//top.jsSetupKeyFunction("top.mainWin.prevInCycle",301);
//top.jsSetupKeyFunction("top.mainWin.nextInCycle",302);
</script>





