<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@page import="org.jdom.Attribute"%>
<%@page import="org.jdom.Document"%>
<%@page import="org.jdom.Element"%>
<%@page import="org.jdom.JDOMException"%>
<%@page import="org.jdom.input.SAXBuilder"%>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>


<%--<epg:PageController/>--%>
<%!
public Map getShooterParams(String destUrl, String charset) throws IOException {
  try{
//    System.out.println("=======================get weather ============");
    Map parameters = new HashMap();
    BufferedInputStream centerBis = null;
    HttpURLConnection httpUrl = null;
    URL url = null;
    try{
      url = new URL(destUrl);
      httpUrl = (HttpURLConnection) url.openConnection();
      //Á¬½ÓÖ¸¶¨µÄ×ÊÔ´
      System.setProperty("sun.net.client.defaultConnectTimeout", "5000");
      System.setProperty("sun.net.client.defaultReadTimeout", "5000");
      httpUrl.connect();
      //»ñÈ¡ÍøÂçÊäÈëÁ÷
      centerBis = new BufferedInputStream(httpUrl.getInputStream());
      StringBuffer sb = new StringBuffer();
      //½¨Á¢Á´½Ó
      SAXBuilder sax = new SAXBuilder();
      Document doc = null;
      try{
        doc = sax.build(new InputStreamReader(centerBis, charset));
      }
      catch(JDOMException ex){
        ex.printStackTrace();
//        System.out.println("TTTTTTTTTTTTTTTTTT1");
        return null;
      }
      Element root=doc.getRootElement();
       List citys = root.getChildren("city");
       if(citys != null && citys.size()>0){
           Element city1 = (Element)citys.get(0);
           parameters.put("city", city1.getChildText("name"));
           parameters.put("date", city1.getChildText("time"));
           parameters.put("temperature_h", city1.getChildText("temperature_h"));
//           parameters.put("temperature",city1.getChildText("temperature"));
//           parameters.put("phenomena_day_imgurl",city1.getChildText("phenomena_day_imgurl"));
//           parameters.put("phenomena_night_imgurl",city1.getChildText("phenomena_night_imgurl"));
           parameters.put("temperature_l",city1.getChildText("temperature_l"));
           parameters.put("wind",city1.getChildText("wind"));
           parameters.put("windpower",city1.getChildText("windpower"));
           parameters.put("phenomena",city1.getChildText("phenomena"));
       }
    }catch(Exception ex){
      ex.printStackTrace();
//      System.out.println("TTTTTTTTTTTTTTTTTT2");
      return null;
    }
    finally {
      centerBis.close();
      httpUrl.disconnect();
    }
    return parameters;
  }
  catch(Exception ex){
    ex.printStackTrace();
//    System.out.println("TTTTTTTTTTTTTTTTTT3");
    return null;
  }
}

 public String getImgFromPhenomena(String phenomena){
     String imgUrl = "10.png";
     if(phenomena!=null){
         if(phenomena.indexOf("ÌØ´ó±©Óê")>-1){
             imgUrl = "12.png";
         }else if(phenomena.indexOf("´ó±©Óê")>-1){
             imgUrl = "02.png";
         }else if(phenomena.indexOf("±©Óê")>-1){
             imgUrl = "01.png";
         }else if(phenomena.indexOf("±©Ñ©")>-1){
             imgUrl = "00.png";
         }else if(phenomena.indexOf("´óÓê")>-1){
             imgUrl = "03.png";
         }else if(phenomena.indexOf("¶³Óê")>-1){
             imgUrl = "04.png";
         }else if(phenomena.indexOf("¶àÔÆ")>-1){
             imgUrl = "05.png";
         }else if(phenomena.indexOf("¸¡³¾")>-1){
             imgUrl = "06.png";
         }else if(phenomena.indexOf("À×³ÂÓê")>-1){
             imgUrl = "07.png";
         }else if(phenomena.indexOf("À×ÕóÓê°éÓÐ±ù±¢")>-1){
             imgUrl = "08.png";
         }else if(phenomena.indexOf("Ç¿É³³¾±©")>-1){
             imgUrl = "09.png";
         }else if(phenomena.indexOf("É³³¾±©")>-1){
             imgUrl = "11.png";
         }else if(phenomena.indexOf("Îí")>-1){
             imgUrl = "13.png";
         }else if(phenomena.indexOf("Ð¡Ñ©")>-1){
             imgUrl = "14.png";
         }else if(phenomena.indexOf("Ð¡Óê")>-1){
             imgUrl = "15.png";
         }else if(phenomena.indexOf("ÑïÉ³")>-1){
             imgUrl = "16.png";
         }else if(phenomena.indexOf("Òõ")>-1){
             imgUrl = "17.png";
         }else if(phenomena.indexOf("Óê¼ÐÑ©")>-1){
             imgUrl = "18.png";
         }else if(phenomena.indexOf("ÕóÑ©")>-1){
             imgUrl = "19.png";
         }else if(phenomena.indexOf("ÕóÓê")>-1){
             imgUrl = "20.png";
         }else if(phenomena.indexOf("ÖÐÑ©")>-1){
             imgUrl = "21.png";
         }else if(phenomena.indexOf("ÖÐÓê")>-1){
             imgUrl = "22.png";
         }
     }
     return imgUrl;
 }
%>

<%
    try{
         long l1 = System.currentTimeMillis();
         UserInfo timeUserInfo = (UserInfo)request.getSession().getAttribute(EpgConstants.USERINFO);
         String timePath1 = request.getContextPath();
         String timeBasePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+timePath1+"/";
         String timeFrameUrl = timeBasePath+timeUserInfo.getUserModel();
         String timepath = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
         timepath = timepath.replace("action/", "");
         HashMap timeparam = PortalUtils.getParams(timepath, "GBK");
         String weatherXmlUrl=String.valueOf(timeparam.get("weatherXmlUrl"));

         System.out.println("SSSSSSSSSSSSweatherXmlUrl1="+weatherXmlUrl);
         weatherXmlUrl = weatherXmlUrl.replace("{framUrl}",timeFrameUrl);
		 System.out.println("SSSSSSSSSSSSweatherXmlUrl2="+weatherXmlUrl);
         Object o = session.getAttribute("weatherMap");
         Map weatherMap = null;
         if(o==null){
//             System.out.println("=======================get weather ============");
             int getWeatherTime = 0;
             try{
                 getWeatherTime = Integer.parseInt(String.valueOf(session.getAttribute("getWeatherTime")));
             }catch (Exception e){
                 getWeatherTime = 0;
                 e.printStackTrace();
             }
             getWeatherTime = getWeatherTime+1;
             session.setAttribute("getWeatherTime",getWeatherTime);
             weatherMap = getShooterParams(weatherXmlUrl, "GBK");
             session.setAttribute("weatherMap",weatherMap);

//             System.out.println("SSSSSSSSSSSSSSS1111getWeatherTime="+getWeatherTime);
         }else{
             weatherMap = (Map)o;
         }

             String  w_city= "";
             String  w_date= "";
             String  w_phenomena= "";
             String  w_temperature_h= "";
             String  w_temperature_l= "";
             String w_temperature="";
//             String  w_wind= "";
//             String  w_wind_force= "";
             String  imgurl="";
             String  w_stateFlag = "1";

        try{
            System.out.println("============weatherMap="+weatherMap);
            w_city= weatherMap.get("city").toString();
            w_date= weatherMap.get("date").toString();
            w_phenomena= weatherMap.get("phenomena").toString();
            w_temperature_h= weatherMap.get("temperature_h").toString();
            w_temperature_l= weatherMap.get("temperature_l").toString();
            imgurl = getImgFromPhenomena(w_phenomena);
            w_temperature =  w_temperature_l+"¡æ-"+w_temperature_h+"¡æ";
            weatherMap.put("imgurl",imgurl);
            weatherMap.put("temperature",w_temperature);
//            phenomena_day_imgurl= weatherMap.get("phenomena_day_imgurl").toString();
//            phenomena_night_imgurl= weatherMap.get("phenomena_night_imgurl").toString();

            StringBuffer sb = new StringBuffer();
            sb.append("{city:\"").append(w_city)
            .append("\",date:\"").append(w_date)
            .append("\",temperature:\"").append(w_temperature);
            int nowhour = new Date().getHours();
            if(6<=nowhour && nowhour<=18){//°×Ìì
                sb.append("\",imgurl:\"").append("day/"+imgurl);
                sb.append("\",timespace:\"").append("day");
            }else{
                sb.append("\",imgurl:\"").append("night/"+imgurl);
                sb.append("\",timespace:\"").append("night");
            }
            sb.append("\"}");

//          System.out.println("============weather_date="+sb);
          long l2 = System.currentTimeMillis();

//            System.out.println("==============weather_consumetime="+(l2-l1));
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());


        }catch (Exception ex){
            ex.printStackTrace();
            System.out.println("Ã»ÓÐ¶ÁÈ¡µ½Êý¾Ý!!!");
        }


    }catch (Exception e){
          e.printStackTrace();
    }

%>





