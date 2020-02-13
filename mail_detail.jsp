<%@page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="mail_detail.jsp"/>
<html>
  <head><title></title>
      <link rel="stylesheet" href="css/common.css" type="text/css" />
  <script type="text/javascript">
      var $$ = {};
      var index=0;
      function init(){
          changeImg(1);
      }
      function goLeft() {
          changeImg(-1);
          if (index > 0 && index <2) {
              index--;
          }
           changeImg(1);
      }

      function goRight() {
          changeImg(-1);
          if (index >= 0 && index < 1) {
              index++;
          }
          changeImg(1);
      }
      function changeImg(flag) {
          if (flag == 1) {
              $("bar" + index).style.visibility = 'visible';
              $("bg" + index).style.visibility = 'hidden';
          } else {
              $("bar" + index).style.visibility = 'hidden';
              $("bg" + index).style.visibility = 'visible';
          }
      }
      function $(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        function goBack(){
            document.location="back.jsp";
        }
        function goOK(){
            if(index ==0){
                goBack();
            }
        }
        function keyPress(evt) {
            var keyCode = parseInt(evt.which);
            if (keyCode == 0x0028) { //onKeyDown
//                goDown();
            } else if (keyCode == 0x0026) {//onKeyUp
//                goUp();
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
       document.onkeypress = keyPress;
  </script>
  </head>
  <body bgcolor="transparent" class="body_bg">
  <%@include file="inc/time.jsp" %>
  <div class="topImg" style="font-size:20px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
      <div style="background:url('images/channel/btv-mytv-ico.png'); left:13; top:8px; width:37px; height:35px; position:absolute; ">
      </div>
      <div align="left"
           style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
          我的TV > 信箱
      </div>
  </div>

  <%--底图--%>
  <div style="font-size:24px;line-height:50px;position:absolute;left:70px;width:1181px;height:500px;top:100px;">
      <img src="images/mytv/btv_letter_detail.png"  width="1141" height="526"/>
  </div>

  <div style="font-size:24px;line-height:50px;position:absolute;left:70px;width:1100px;height:500px;top:100px;">
      <div style="font-size:24px;line-height:50px;position:absolute;left:0px;width:1098px;height:100px;top:0px; color:#FFFFFF;">
          <div style="position:absolute;left:20px;top:5">主题:主题主题主题主题主题主题</div>
          <div style="position:absolute;left:20px;top:40">发件人：tanghc@yahoo.cn</div>
          <div style="position:absolute;left:900px;top:40">2011.10.20 19:34</div>
      </div>

      <div style="font-size:24px;line-height:50px;position:absolute;left:20px;width:1098px;height:400px;top:125px;color:#FFFFFF;">
          邮件内容:
          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
          XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      </div>

      <div style="position:absolute;left:0px;width:1098px;height:40px;top:475px;">

          <div id="bg0" style="position:absolute; width:100px; height:40px; top:8px; left:400px;visibility:visible">
              <img src="images/vod/btv-btn-cancel.png" width="120" height="36"/>
          </div>
          <div id="bar0" style="position:absolute; width:86px; height:40px; top:8px; left:400px;visibility:hidden">
              <img src="images/vod/btv-btn-cancelclick.png" width="120" height="36"/>
          </div>
           <div style="line-height:48px;position:absolute; width:100px; height:36px; top:0px; left:437px;font-size:22px;color:#FFFFFF">
            确定
          </div>

          <div id="bg1" style="position:absolute; width:100px; height:40px; top:8px; left:600px;visibility:visible">
              <img src="images/vod/btv-btn-cancel.png" width="120" height="36"/>
          </div>
          <div id="bar1" style="position:absolute; width:86px; height:40px; top:8px; left:600px;visibility:hidden">
              <img src="images/vod/btv-btn-cancelclick.png" width="120" height="36"/>
          </div>
          <div style="line-height:48px;position:absolute; width:100px; height:36px; top:0px; left:637px;font-size:22px;color:#FFFFFF">
            删除
          </div>
      </div>
  </div>

  <div style="background:url(images/bg_bottom.png); position:absolute; width:1280px; height:43px; left:25px; top:630px;">
  </div>
  <div style="position:absolute; width:750px; height:38px; left:810px; top:636px;font-size:22px;">
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
  <script type="text/javascript">
      init();
  </script>
  <%@include file="inc/goback.jsp" %>
  <%@include file="inc/lastfocus.jsp" %>
  </body>
</html>