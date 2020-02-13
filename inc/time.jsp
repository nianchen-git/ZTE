<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*"%>
<style type="text/css">
    .topImg{
        left:42;                 
    }
</style>
<%--<script type="text/javascript" src="js/contentloader.js"></script>--%>
<%!
   public String checkNum(String str){
         if(str!=null && str.length()==1){
            str = "0"+str;
         }
         return str;
   }

%>

<%
//      String timepath = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
//      timepath = timepath.replace("action/", "");
//      HashMap timeparam = PortalUtils.getParams(timepath, "GBK");
//      String weatherReflashTime=String.valueOf(timeparam.get("weatherReflashTime"));
//      if(weatherReflashTime == null || "".equals(weatherReflashTime)){
//            weatherReflashTime = "60";
//      }
    Date nowtime_time = new Date();

    String time_year = String.valueOf(nowtime_time.getYear()+1900);
    String time_month = checkNum(String.valueOf(nowtime_time.getMonth()+1));
    String time_date = checkNum(String.valueOf(nowtime_time.getDate()));
    String time_hour = checkNum(String.valueOf(nowtime_time.getHours()));
    String time_minute = checkNum(String.valueOf(nowtime_time.getMinutes()));

    long cur_time = nowtime_time.getTime();

     Object weatherObj = session.getAttribute("weatherMap");
     String  w_temperature= "";
     String  imgurl="day/10.png";
     String  w_timespace = "images/weather/weather_bg_day.png";
     Map weatherMap = null;
     int getWeatherTime = 0;
     if(weatherObj!=null){
        weatherMap = (Map)weatherObj;
        try{
//            System.out.println("============weatherMap="+weatherMap);
            w_temperature = weatherMap.get("temperature").toString();
            imgurl = weatherMap.get("imgurl").toString();
            int nowhour = new Date().getHours();
            if(6<=nowhour && nowhour<=18){//白天
                imgurl = "day/"+imgurl;
                w_timespace = "images/weather/weather_bg_day.png";
            }else{
                imgurl = "night/"+imgurl;
                w_timespace = "images/weather/weather_bg_night.png";
            }
        }catch (Exception ex){
            ex.printStackTrace();
            System.out.println("没有读取到数据!!!");
        }
    } else{
        try{
            getWeatherTime = Integer.parseInt(String.valueOf(session.getAttribute("getWeatherTime")));
        }catch (Exception e){
//             e.printStackTrace();
            System.out.println("SSSSSSSSSSSSSSSSgetWeatherTimeERROR!!");
        }
    }

//    System.out.println("SSSSSSSSSSSSSSSSSSSSgetWeatherTime="+getWeatherTime);
%>

<script language="javascript" type="">
     var data_time = new Date();
     var time_mili = <%=cur_time%>
     var time_interval = 120000;
      function showCurrentTime(){
          time_mili = time_mili + time_interval;
//          alert("SSSSSSSSSSSSSSSSSSStime_mili="+time_mili);
          data_time.setTime(time_mili);
          document.getElementById("tm").innerHTML=data_time.getFullYear()+"/"+checkTime(data_time.getMonth()+1)+"/"+checkTime(data_time.getDate());
          document.getElementById("tm1").innerHTML=checkTime(data_time.getHours())+":"+checkTime(data_time.getMinutes());
          window.setTimeout("showCurrentTime()",time_interval);
      }

      function checkTime(i){
         if(i<10){
           i="0"+i;
         }
         return i;
      }


    function showWeatherInfo(){
          var requestUrl = "action/weather_data.jsp";
          var loaderSearch = new net.ContentLoader(requestUrl, showWeatherInfoResponse);
    }

    function showWeatherInfoResponse (){
         try{
             var results = this.req.responseText;
             var data = eval("(" + results + ")");
             var temperature = data.temperature;
             var img = data.imgurl;
             var timespace = data.timespace;
             if(temperature){
                 document.getElementById('tempearture').innerText= temperature;
             }
             if(img){
                 document.getElementById('weather_img').src="images/weather/"+img;
             }
             if(timespace =='day'){
                 document.getElementById('weather_bg_img').src="images/weather/weather_bg_day.png";
             }else if(timespace =='night'){
                 document.getElementById('weather_bg_img').src="images/weather/weather_bg_night.png";
             }
         }catch(e){
             //alert("SSSSSSSSSSSSSSSSSSSSSSe!!");
         }
    }

    window.setTimeout("showCurrentTime()",time_interval);
</script>
<%--<script type="text/javascript" src="js/time.js"></script>--%>
<div style="position:absolute;font-size:27px;color:#FFFFFF;width: 480px;height: 85px;left:475px;top: 0;">
    <%--<div style="position:absolute; font-size:27px; width: 129px;height: 45px;left:640px;top: 28;">--%>
        <%--<img  width="129" height="29" src="images/logo.png" />--%>
    <%--</div>--%>
    <%--<div style="position:absolute; font-size:27px; width: 332px;height: 62px;left:288px; top: 5px;">--%>
        <%--<img id="weather_bg_img" width="332" height="62" src="<%=w_timespace%>" />--%>
    <%--</div>--%>
    <%--<div style="position:absolute; font-size:27px; width: 108px;height: 58px;left:431px;top: 5;">--%>
        <%--<img id="weather_img" width="108" height="62" src="<%="images/weather/"+imgurl%>" />--%>
    <%--</div>--%>
    <%--<div align="right" id="tempearture" style=" position:absolute;font-size:27px; width: 140px;height: 30px;left:483px;top: 37;">--%>
        <%--<%=w_temperature%>--%>
    <%--</div>--%>
    <div id="tm"  style="position:absolute;  font-size:27px; width: 240px;height: 30px;  left:350px;top: 25px;">
        <%=time_year+"/"+time_month+"/"+time_date%>
    </div>
    <div id="tm1" style="position:absolute;  font-size:27px; width: 240px;height: 30px;  left:600px;top: 25px;">
        <%=time_hour+":"+time_minute%>
    </div>
</div>
<script language="javascript" type="">
    <%
    if(weatherMap==null && getWeatherTime<1){
    %>
//       window.setTimeout("showWeatherInfo()",2500);
    <%
    }
    %>
</script>

