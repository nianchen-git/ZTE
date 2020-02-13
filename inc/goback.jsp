<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page contentType="text/html; charset=GBK" %>
<script language="javascript" type="">
    function back_shortcut() {
        document.location = "back.jsp";
//        debug("SSSSSSSSSSSSSSSSSSSSSSSback.jsp");
        return false;
    }
    top.jsSetupKeyFunction("top.mainWin.back_shortcut", <%=STBKeysNew.remoteBack%>);
    top.jsSetupKeyFunction("top.mainWin.back_shortcut", 24);
</script>
