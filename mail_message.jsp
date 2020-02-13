<%@page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="mail_message.jsp"/>
<html>
<head>
    <title></title>
    <script type="text/javascript">
        var isZTEBW = false;
        if(window.navigator.appName.indexOf("ztebw")>=0){
            isZTEBW = true;
        }

        function debug(str){
            if(isZTEBW == false){
                iSTB.evt.debug(str);
            }else{
             //   alert(str);
			 break;
            }
        }

        var $$ = {};
        var index=0;
        var topindex=0;
        var leftindex=0;
        var leng=9;
        var isleft=false;
        var istop=false;
        function $(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        function keyPress(evt) {
            var keyCode = parseInt(evt.which);
            if (keyCode == 0x0028) { //onKeyDown
                goDown();
            } else if (keyCode == 0x0026) {//onKeyUp
                goUp();
            } else if (keyCode == 0x0025) { //onKeyLeft
               goLeft();
            } else if (keyCode == 0x0027) { //onKeyRight
               goRight();
            } else if (keyCode == 0x0022) {  //page down
                pageDown();
            } else if (keyCode == 0x0021) { //page up
                pageUp();
            } else if (keyCode == 0x0008  || keyCode == 24) {///back
                goBack();
            } else if (keyCode == 0x000D) {  //OK
                goOK();
            } else {
                commonKeyPress(evt);
                return true;
            }
            return false;
        }

        function  goOK(){
            if(isleft ==false && istop ==false){
                document.location="mail_detail.jsp";
            }
        }
        function goLeft(){
           if((istop==true && topindex==0 && isleft==false) || (isleft==false && istop==false)){
               isleft=true;
               istop=false;
               changeImg(-1)
               changeTopImg(-1);
               $("leftbar").style.visibility="visible";
           }else if(istop == true && isleft==false && topindex!=0){
               changeTopImg(-1);
               topindex--;
               changeTopImg(1);
           }
        }
        function goRight(){
            if(isleft){
                isleft=false;
                $("leftbar").style.visibility="hidden";
                changeImg(1);
            }else if(isleft ==false && istop==true)
            {
                changeTopImg(-1);
                if(topindex < 1){
                   topindex++;
                }
                changeTopImg(1);
            }
        }

        function goDown() {
            debug("SSSSSSSSSSSSSSSSSSSgoDown");
            if (isleft) {
                if (leftindex == 0) {
                    leftindex = 1;
                } else {
                    leftindex = 0
                }
                $("leftbar").style.top = 41 * leftindex;
            } else if (isleft == false && istop == true && index == 0) {
                  istop=false;
                  changeImg(1);
                  changeTopImg(-1);
            } else {
                if (index >= 0 && index < leng - 1) {
                    changeImg(-1);
                    index++;
                    changeImg(1);
                }
            }
        }
        function goUp(){
            if(isleft){
              if(leftindex==0){
                   leftindex=1;
               }else{
                  leftindex=0
               }
              $("leftbar").style.top=41*leftindex;
            }else{
                if (index == 0) {
                    changeImg(-1);
                    isleft=false;
                    istop = true;
                    topindex=0;
                    changeTopImg(1);
                } else if (index > 0 && index <= leng - 1) {
                    changeImg(-1);
                    index--;
                    changeImg(1);
                }
//                  if(index>0 && index<=leng-1){
//                    changeImg(-1);
//                    index--;
//                    changeImg(1);
//                }
            }
        }
        function goBack(){
           document.location="back.jsp"; 
        }
        function changeImg(flag) {
            if (flag == 1) {
               $("rightbar"+index).style.visibility="visible";
            } else {
               $("rightbar"+index).style.visibility="hidden";
            }
        }
        function changeTopImg(flag){
           if(flag ==1){
             $("topbar"+topindex).style.visibility='visible';
             $('topbg'+topindex).style.visibility='hidden';
           } else{
               $("topbar" + topindex).style.visibility = 'hidden';
               $('topbg' + topindex).style.visibility = 'visible';
           }
           
        }
        document.onkeypress = keyPress;
        function init(){
            isleft=false;
           $("rightbar"+index).style.visibility="visible";
        }
    </script>
</head>
<body bgcolor="transparent" onLoad="init();">


<div style="position:absolute; width:1292px; height:720; top:0; left:25">
    <img src="images/mail_bg.png" border="0" width="1255" height="720">
</div>
<%--<div style="font-size:20px; left:30; top:7px; width:177px; height:45px; position:absolute; color:#ffffff;">--%>
    <%--<div style="background:url(images/channel/btv-mytv-ico.png); left:13; top:8px; width:37px; height:35px; position:absolute; ">--%>
    <%--</div>--%>
    <%--<div align="center"style="font-size:24px; line-height:50px; left:30; top:4px; width:260px; height:35px; position:absolute; ">--%>
        <%--我的TV > 信箱--%>
    <%--</div>--%>
<%--</div>--%>
<%--顶部信息--%>
<div style="line-height:48px; position:absolute; width:300px; height:80px; top:108px; left:275px;font-size:22px;color:#FFFFFF">
    <div id="topbar0" style="position:absolute; width:86px; height:40px; top:8px; left:0px;visibility:hidden">
        <img src="images/vod/btv-btn-cancelclick.png" width="120" height="36"/>
    </div>
     <div id="topbg0" style="position:absolute; width:100px; height:40px; top:8px; left:0px;visibility:visible">
        <img src="images/vod/btv-btn-cancel.png" width="120" height="36"/>
    </div>
    <div style="line-height:48px;position:absolute; width:100px; height:36px; top:0px; left:15px;font-size:22px;color:#FFFFFF">
        全部已读
    </div>

    <div id="topbar1" style="position:absolute; width:86px; height:40px; top:8px; left:150px;visibility:hidden">
        <img src="images/vod/btv-btn-cancelclick.png"  width="120" height="36"/>
    </div>
    <div id="topbg1" style="position:absolute; width:100px; height:40px; top:8px; left:150px;visibility:visible">
        <img src="images/vod/btv-btn-cancel.png" width="120" height="36"/>
    </div>
    <div style="line-height:48px; position:absolute; width:100px; height:40px; top:0px; left:185px;font-size:22px;color:#FFFFFF">
        清空
    </div>

</div>


<div style="line-height:48px; position:absolute; width:150px; height:48px; top:156px; left:310px;font-size:22px;color:#FFFFFF">
    发件人
</div>
<div style="line-height:48px; position:absolute; width:400px; height:32px; top:156px; left:505px;font-size:22px;color:#FFFFFF">
    邮件主题</div>
<div style="line-height:48px; position:absolute; width:200px; height:48px; top:155px; left:955px;font-size:22px;color:#FFFFFF">
    日期
</div>

<div style="position:absolute; width:185px; height:524px; top:110px; left:59px;font-size:20px;color:#FFFFFF;">
    <div id="leftbar" style="position:absolute; width:181px; height:30px; top:0px; left:0px;visibility:hidden">
        <img src="images/portal/focus.png" alt="" width="181" height="40"/>
    </div>

    <div style="position:absolute; width:178px; height:30px; top:8px; left:2px" align="center">收信箱(9)</div>
    <div style="position:absolute; width:185px; height:30px; top:41px; left:0px"  align="center"><img src="images/line.png" width="180" height="1"></div>
    <div style="position:absolute; width:180px; height:30px; top:52px; left:2px"  align="center">未读邮件(2)</div>
</div>


<div style="position:absolute; width:977px; height:430px; top:201px; left:255px;font-size:20px;color:#FFFFFF;">
    <%
        for (int i = 0; i < 9; i++) {
            int top = 12 + i * 48;
    %>
    <div id="rightbar<%=i%>" style="visibility:hidden;left:1px;  top:<%=top-11%>px;width:957px;height:47px;font-size:22px;position:absolute; background-image:url(images/liveTV/channel_minifocus.png)">
        <img src="images/mytv/TVprogram_redline.png" width="957" height="50"/>
    </div>
    <div style="position:absolute; width:209px; height:30px; top:<%=top-5%>px; left:10px;"><img src="images/read.png" width="30" height="30"></div>
    <div style="position:absolute; width:209px; height:30px; top:<%=top%>px; left:45px;">收件人</div>
    <div style="position:absolute; width:431px; height:30px; top:<%=top%>px; left:225px;">XXXXXXXXXXXXXXXXXXXXXXX</div>
    <div style="position:absolute; width:282px; height:30px; top:<%=top%>px; left:696px;">2011.7.1 11:50</div>
    <%
        }
    %>
</div>
<div style="background:url(images/bg_bottom.png); position:absolute; width:1280px; height:43px; left:25px; top:637px;">
</div>
<div style="position:absolute; width:750px; height:38px; left:860px; top:643px;font-size:22px;">
    <div id="pre" style="visibility:visible;">
        <img src="images/vod/btv_page.png" alt="" width="60" height="31" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:7;top:4px;color:#424242">上页</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
    </div>
    <div id="next" style="visibility:visible">
        <img src="images/vod/btv_page.png" width="60" height="31" alt="" style="position:absolute;left:200;top:0px;">
        <font style="position:absolute;left:207;top:4px;color:#424242">下页</font>
        <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
    </div>
</div>
      <%@include file="inc/time.jsp" %>
    <div class="topImg" style="font-size:20px;  top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
        <div style="background:url('images/channel/btv-mytv-ico.png'); left:13; top:8px; width:37px; height:35px; position:absolute; ">
        </div>
        <div align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
              我的TV  > 信箱
        </div>
    </div>
<%@ include file="inc/mailreminder.jsp" %>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>

