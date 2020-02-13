<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
    String result = request.getParameter("result");
%>
<script type="text/javascript">
      if('<%=result%>'=='1'){
     	  top.jsSetRemindTime("0");  
      }
    //  alert("$$$$$$$$$$$$$$$$$$$$<%=result%>");
   top.mainWin.showaddRemind(<%=result%>);
</script>

