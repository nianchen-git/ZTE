<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.*" %>
<epg:PageController name="favorite_film.jsp"/>
<html>
    <head>
       <title> ’≤ÿ”∞ ”</title>
       <script type="text/javascript" src="js/contentloader.js"></script>
       <script type="text/javascript">
       var cdestpage;
       var totalpage;
       var index;
       var data;
       var arr;
       var leng;
       function init(){
          loadPage();
       }
       function loadPage(){
          var requestUrl = "action/favorite_data.jsp?destpage=" + cdestpage;
          var loaderSearch = new net.ContentLoader(requestUrl, showColumn);
       }
      function showColumn(){
           var results = this.req.responseText;
           data = eval("(" + results + ")");
           arr = data.Data;
           cdestpage = data.destpage;
           totalpage = data.pageCount;
           leng = carr.length;
           f (cleng > 0) {
                for (var i = 0; i < leng; i++) {
                    $("vod_img" + i).src = arr[i].normalpster
                }
            }
           
      }
       
       </script>
    </head>
    <body>
    <div style="position:absolute;  left:250; top:70;width:1000; height:595;">
    <div id="vod" style="position:absolute;  left:25; top:0;width:10000; height:595;">
        <!--vod-->
        <%
            for (int i = 0; i < 10; i++) {
                int frow = i / 5;
                int fcol = i % 5;
                int fleft = fcol * 192;
                int ftop = 35 + frow * 287;
        %>
        <div id="vod_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:160; height:240; ">
            <img id="vod_img<%=i%>" src="images/btn_trans.gif" alt="" width="158" height="227" border="0">
        </div>
        <div id="vod_name<%=i%>"
             style="position:absolute; background-image:url(images/vod/btv_vod.png); left:<%=fleft%>; top:<%=ftop+190%>;width:159; height:51px;font-size:20px; color:#FFFFFF;visibility:hidden"
             align="center"></div>


   

        <%
            }
        %>
    </div>
    </div>
    </body>
</html>