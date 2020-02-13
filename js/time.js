     var year;
     var month;
     var day;
     var hours;
     var minutes;

      function showCurrentTime(){
          var requestUrl = "action/getnowtime.jsp";
          var loaderSearch = new net.ContentLoader(requestUrl, showCurrentTimeResponse);
      }

      function showCurrentTimeResponse(){
            var results = this.req.responseText;
            var data = eval("(" + results + ")");
            year=parseInt(data.year)+1900;
            month=parseInt(data.month)+1;
            day=parseInt(data.date);
            hours = data.hour;
            minutes = data.minute;

            month=checkTime(month);
            day=checkTime(day);
            hours=checkTime(hours);
            minutes=checkTime(minutes);

            document.getElementById("tm").innerHTML=year+"/"+month+"/"+day
            document.getElementById("tm1").innerHTML=hours+":"+minutes;
//          tm.innerHTML=year+"/"+month+"/"+day+"  "+hours+":"+minutes;
            window.setTimeout("showCurrentTime()",60000);
      }

      function checkTime(i){
         if(i<10){
           i="0"+i;
         }
         return i;
      }

      showCurrentTime();

    function showWeatherInfo(){
          var requestUrl = "action/weather_data.jsp";
          var loaderSearch = new net.ContentLoader(requestUrl, showWeatherInfoResponse);
    }

    function showWeatherInfoResponse (){
         var results = this.req.responseText;
         var data = eval("(" + results + ")");
         var temperature = data.temperature;
         var img = data.imgurl;
         var timespace = data.timespace;
//         alert('SSSSSSSSSSSSSSSSStemperature='+temperature);
         if(temperature){
             //alert('TTTTTTTTTTTTTTTTTTTT');
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
         //window.setTimeout("showWeatherInfo()",weatherReflashTime*60*1000);
    }

    showWeatherInfo();