<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<html>
<head>
    <title>portal</title>
	<%--<meta name="page-view-size" content="1280*720"/>--%>
    <%
            String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
            HashMap param = PortalUtils.getParams(path, "UTF-8");
            String reminderTextTopStr = String.valueOf(param.get("reminderTextTop"));
            //默认展示时间
            int reminderTextTop = 5;
            try{
                reminderTextTop = Integer.parseInt(reminderTextTopStr);
            }catch(Exception e){
                System.out.println("show reminder timer delay!!");
            }

            //默认展示时间
            String showReminderTimerStr = String.valueOf(param.get("showReminderTimer"));
            long showReminderTimer = 15000;
            try{
                showReminderTimer = Long.parseLong(showReminderTimerStr);
            }catch(Exception e){
                e.printStackTrace();
                System.out.println("show reminder timer delay!!");
            }

            System.out.println("SSSSSSSSSSSSSSSSSSreminderTextTop="+reminderTextTop);
    %>
</head>

<script language="javascript" type="">
    var showReminderTimer = parseInt('<%=showReminderTimer%>');
  var reminderTimer = null;

  function closeByTimer(){
      if(reminderTimer!=null){
          clearTimeout(reminderTimer);
      }
      reminderTimer = setTimeout(function (){
         // alert("SSSSSSSSSSSSSSSSSSSSSSSSSreminderWindow_close!!!");
          window.close();
      },showReminderTimer);
  }

//  alert("SSSSSSSSSSSSSSSSshowReminderTimer="+showReminderTimer);
  

  function showReminder(obj){
      //  alert("SSSSSSSSSSSSSS="+obj);
        var lastHTML = document.getElementById('reminderName').innerHTML;
        if(lastHTML){
             obj = lastHTML + "&nbsp;&nbsp;&nbsp;&nbsp;"+obj;
        }
        document.getElementById('reminderName').innerHTML=obj;
        closeByTimer();
  }

</script>
<body bgcolor="white" >
<div style="font-size:28px; width:1240px; position:absolute; color:blue; left:20px; top: <%=reminderTextTop%>px;">
    <marquee id="reminderName" scrollamount='30' version='3' scrolldelay='250'></marquee>
</div>
</body>
</html>