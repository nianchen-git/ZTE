<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString1.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ include file="inc/getchina.jsp" %>
 <epg:PageController name="community.jsp"/>



<%
    String title = request.getParameter("param");
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
//    String headname=(String)param.get(title);
    String headname=getChinese(param,title);
    int comm_sum = 0;
    try {
        comm_sum = Integer.parseInt(param.get(title + "_sum").toString());
//        System.out.println("===============lq==============" + comm_sum);
    } catch (Exception e) {
        comm_sum = 0;
    }
    Vector cUrl = new Vector(comm_sum);
    Vector cName = new Vector(comm_sum);
    Vector cImg = new Vector(comm_sum);
    for (int i = 0; i <= comm_sum; i++) {
//        String comm_name = (String) param.get(title + "_name" + i);
        String comm_name =  getChinese(param,title + "_name" + i);
        String comm_img = (String) param.get(title + "_img" + i);
        String comm_url = (String) param.get(title + "_url" + i);
        if(comm_name==null){
             break;
        }else{
        cName.add(i, comm_name);
        cUrl.add(i, comm_url);
        cImg.add(i, comm_img);
        }
//        System.out.println("================lq===============" + comm_name);
//        System.out.println("================lq===============" + comm_img);
//        System.out.println("================lq===============" + comm_url);
    }


    int totalpage = 0;
    if (comm_sum % 12 == 0) {
        totalpage = comm_sum / 12;
    } else {
        totalpage = comm_sum / 12 + 1;
    }


    String nextPage = request.getParameter("nextPage");
    if (null == nextPage || nextPage.equals("")) {
        nextPage = "1";
    }
    int next = Integer.parseInt(nextPage);
    if (next > totalpage) {
        next = totalpage;
    }
    if (next <= 0) {
        next = 1;
    }
    int starindex = 0;
    int endindex = 0;

    if (next < totalpage) {
        starindex = 0;
        endindex = 12;
    } else if (next == totalpage) {
        starindex = 0;
        endindex = comm_sum - (totalpage - 1) * 12;
    }
%>
<html>
<head>
    <title>社区</title>
    <epg:script/>
    <script type="" language="javascript">
        var linkindex;
        function toPrevPage() {
            document.location = "community.jsp?nextPage=<%=next-1%>&param=<%=title%>"
        }

        function toNextPage() {
            document.location = "community.jsp?nextPage=<%=next+1%>&param=<%=title%>"
        }
        function changeImg(index, state,name,url,img) {
            linkindex=index;
            if (state == 1) {
                favObject.cname=name;
                favObject.curl=url;
                favObject.cimg=img;
                document.getElementById("img_" + index).src = "images/community/btv-mytv-appbgc.png";
                document.getElementById("img_" + index).style.visibility="visible";
            } else {
                document.getElementById("img_" + index).src = "images/btn_trans.gif";
                document.getElementById("img_" + index).style.visibility="hidden";
            }
        }

        function gotothrid(url, index) {
            if (url) {
                if (url.indexOf('?') > -1) {
                    url = url + "&returnurl=<%=timeBasePath%>function/index.jsp";
                } else {
                    url = url + "?returnurl=<%=timeBasePath%>function/index.jsp";
                }
                top.doStop();
                top.jsSetControl("isCheckPlay", "0");
                //设置第三方页面返回的参数
                setBackParam(index);
                top.mainWin.document.location=url;
           }else{
                document.location="thirdlink.jsp?leefocus=llinker"+index;
            }


        }
        function goRight(){
                  if(linkindex==5&&document.links["llinker"+6]){
                    document.links["llinker"+6].focus();
                  }else if(linkindex==17&&document.links["llinker"+18]){
                     document.links["llinker"+18].focus(); 
                  }else if(!document.links["llinker"+(++linkindex)]){
                     // alert((++linkindex)+"==========comeuin"+document.links["llinker"+parseInt(linkindex+1)]);
                     document.links["llinker"+0].focus();
                  }
         }
        function goLeft(){
             if(linkindex==6&&document.links ["llinker"+5]){
                 document.links["llinker"+5].focus();
             }else if(linkindex==18&&document.links ["llinker"+17]){
                 document.links["llinker"+17].focus();
             }else if(linkindex==0){
                  document.links["llinker"+<%=endindex-1%>].focus();
             }
         }
         function  doKeyPress(evt){
             var keycode=evt.which;
             if(keycode==0x0027){
                  goRight();
             }else if(keycode==<%=STBKeysNew.onKeyLeft%>){
                  goLeft();
             }else  if(keycode ==0x0113){
                 doRed();
             }else{
                  top.doKeyPress(evt);
                  return true;
             }
             return true;
         }
        document.onkeypress = doKeyPress;
    </script>
</head>
<body bgcolor="transparent">
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
     <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
     </div>
<%
    int left = 0;
    int top = 0;
    for (int i = starindex; i < endindex; i++) {
        if (i < cUrl.size()) {
            int index = (next - 1) * 12 + i;
            int row = i / 6;//行
            int cow = i % 6;//列
            left = cow * 195 + 80;
            top = row * 195 + 100;
            String url = "";
            if(cUrl.get(index) != null){
                url = (String)cUrl.get(index);
                 if(url.trim().equals("#") || url.trim().equals("")){
                      url = "";
                 }
            }

%>
<div style="position:absolute; width:22; height:35; left:33px; top:22px;">
	<img src="images/community/btv-service-ico.png" border="0">
</div>
<div id="path" style="position:absolute; width:760px; height:51px; left:80px; top:25px;font-size:24px;color:#FFFFFF">社区 ><%=headname%>
</div>
<%--<div class="topImg" style="font-size:20px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/community/btv-service-ico.png'); left:13; top:12px; width:41px; height:30px; position:absolute; ">
    </div>
    <div id="path" align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
          社区 > <%//=headname%>
    </div>
</div>--%>

<div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;" align="center">
    <a name="llinker<%=index%>" href="javascript:gotothrid('<%=url %>','<%=index%>')" onFocus="changeImg('<%=index%>','1','<%=cName.get(index) %>','<%=url %>','images/community/<%=cImg.get(index) %>')"
       onblur="changeImg('<%=index%>','0','<%=cName.get(index) %>','<%=url %>','images/community/<%=cImg.get(index) %>')">
        <img src="images/btn_trans.gif" width="1" height="1" alt="" border="0">
    </a>
</div>
<div style="position:absolute;left:<%=left %>px; top:<%=top-5 %>px; width:150px;" align="center">
    <img id="img_<%=index%>" src="images/btn_trans.gif" width="116" height="116" alt="" border="0">
</div>
<!-- 图片信息 -->
<div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;" align="center">
    <img src="images/community/<%=cImg.get(index) %>" width="105" height="105" alt="" border="0">
</div>
<!-- 名称信息 -->
<div style="position:absolute;left:<%=left+8 %>px; top:<%=top+110 %>px; width:150px; font-size:24px;color:white;" align="center" >
    <%=String.valueOf(cName.get(index)) %>
</div>
<%

        } else {
            break;
        }
    }
%>
<!-- 广告一 -->
<div style="position: absolute;left: 65px;top: 528px;">
    <!--epg:FirstPage left="65" top="533" width="354" height="85" location="guanggao01"/-->
	<img src="images/guanggao3.png" alt="" width="354" height="85" border="0">
</div>
<!-- 广告二 -->
<div style="position: absolute;left: 449px;top: 528px;">
    <!--epg:FirstPage left="449" top="533" width="354" height="85" location="guanggao02"/-->
	<img src="images/guanggao4.png" alt="" width="354" height="85" border="0">
</div>
<!-- 广告三 -->
<div style="position: absolute;left: 833px;top: 528px;">
    <!--epg:FirstPage left="833" top="533" width="354" height="85" location="guanggao03"/-->
	<img src="images/guanggao5.png" alt="" width="354" height="85" border="0">
</div>


<!-- 底部按钮 -->
<%
    if(totalpage>1){
%>
<div style="position:absolute; width:150px; height:38px; left:700px; top:643px;font-size:22px;">
    <div id="pre" style="visibility:visible">
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
<%
    }
%>


<script language="javascript" type="">
    top.jsSetupKeyFunction("top.mainWin.toPrevPage", 0x0021);
    top.jsSetupKeyFunction("top.mainWin.toNextPage", 0x0022);
</script>
 <script type="text/javascript" src="js/json.js"></script>
<%@ include file="inc/mailreminder.jsp" %>
<%@ include file="inc/favorite_service_add.jsp" %>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/time.jsp"%>
</body>
</html>