<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString1.jsp" %>
<%@ include file="inc/getchina.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%!

    String toXml(String key, String value) {
        String rt = "<" + key + ">" + value + "</" + key + ">";
        return rt;
    }

    String replaceUrl(HttpServletRequest req,String url,HashMap param)throws Exception{
        UserInfo userInfo = (UserInfo)req.getSession().getAttribute(EpgConstants.USERINFO);
        String tempUrl = url;
        if(tempUrl == null){
            return "";
        }

        tempUrl = tempUrl.replaceAll("\\{userid\\}", userInfo.getUserId());
        if(url.indexOf("EPG_INFO")>-1){
            String timeBasePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath() + "/";
            String returnUrl = timeBasePath + userInfo.getUserModel()+"/thirdback.jsp";

            String epginfo = "";
            epginfo+=toXml("server_ip",req.getServerName());
            epginfo+=toXml("group_name",String.valueOf(param.get("EPG_INFO_group_name")));
            epginfo+=toXml("group_path",String.valueOf(param.get("EPG_INFO_group_path")));
            epginfo+=toXml("oss_user_id",userInfo.getUserId());
            epginfo+=toXml("page_url",returnUrl);
            epginfo+=toXml("partner","ZTE");
            epginfo = java.net.URLEncoder.encode(epginfo, "UTF-8");
            url = url.replaceAll("EPG_INFO", epginfo);
        }
        return url;
    }

%>

<%
    String title = request.getParameter("param");
    String[] titleArr = title.split("_");
    String lastfocus = request.getParameter("lastfocus");
    String leefocus = request.getParameter("leefocus");

    //获取首页地址
	 String pageURI = request.getRequestURL().toString();
     int loc = pageURI.lastIndexOf("/");
	 pageURI = pageURI.substring(0,loc+1);
	 String portalUrl = pageURI+"portal.jsp";
	 String thirdbackUrl =  pageURI+"thirdback.jsp";
	 
    System.out.println("SSSSSSSSSSSSSSSSSSSSlastfocus="+request.getQueryString());
  // if((lastfocus==null || lastfocus.equals("")) && (leefocus!=null && !leefocus.equals(""))){
  //     System.out.println("SSSSSSSSSSSSSSSSSSS重复!!!!!");
%>
<epg:PageController name="application.jsp"/>
<%
// }
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String headname=getChinese(param,"app_"+title.substring(0,1)+"_name")+"&nbsp;>&nbsp;"+getChinese(param,"app_"+title+"_name");
    if(titleArr.length==2){
       headname=getChinese(param,"app_"+title.substring(0,1)+"_name")+"&nbsp;>&nbsp;"+getChinese(param,"app_"+title+"_name");
    }else if(titleArr.length==3){
       headname=getChinese(param,"app_"+title.substring(0,1)+"_name")+"&nbsp;>&nbsp;"+getChinese(param,"app_"+title.substring(0,3)+"_name")+">"+getChinese(param,"app_"+title+"_name");
    }

    Vector cUrl = new Vector();
    Vector cName = new Vector();
    Vector cImg = new Vector();
    Vector cGosd = new Vector();
    Vector invalidList = new Vector();
    String app_name = null;
    String app_img = null;
    String app_url = null;
    String app_gosd = null;
    String app_invalid = null;
    for (int i = 0; i <= 1000; i++) {
        if(param.get("app_"+title+"_" + i+"_name")==null){
            break;
        }
        app_name =  getChinese(param,"app_"+title+"_" + i+"_name");
        app_img = String.valueOf(param.get("app_"+title+"_" + i+"_img"));
        app_url = String.valueOf(param.get("app_"+title+"_" + i+"_url"));
        app_gosd = String.valueOf(param.get("app_"+title+"_" + i+"_gosd"));
        app_invalid = String.valueOf(param.get("app_"+title+"_" + i+"_invalid"));

        if (app_name == null) {
            break;
        } else {
            cName.add(i, app_name);
            cUrl.add(i, app_url);
            cImg.add(i, app_img);
            cGosd.add(i, app_gosd);
            invalidList.add(i, app_invalid);
        }
    }
    int totalpage = 0;
    int app_sum=cName.size();
    if (app_sum % 12 == 0) {
        totalpage = app_sum / 12;
    } else {
        totalpage = app_sum / 12 + 1;
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
        endindex = app_sum - (totalpage - 1) * 12;
    }
%>
<html>
<head>
    <title>社区</title>
    <epg:script/>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script type="" language="javascript">
        var linkindex;
        var next = <%=next%>;
        var totalpage = <%=totalpage%>;
        var portalUrl="<%=portalUrl%>";
        var thirdbackUrl="<%=thirdbackUrl%>";
        function toPrevPage() {
         if(next == 1){
                next = totalpage;
            }else{
                next = next -1;
            }
            document.location = "application.jsp?leefocus=llinker0&param=<%=title%>&nextPage="+next;
        }

        function toNextPage() {
        if(next == totalpage){
                next = 1;
            }else{
                next = next +1;
            }
            document.location = "application.jsp?leefocus=llinker0&param=<%=title%>&nextPage="+next;
        }
        function changeImg(index, state,name,url,img,gosd,invalid){
           linkindex= index;
            if (state == 1) {
               // alert("SSSSSSSSSSSSSSSSSSSchangeImgOnfocus"+index);
                favObject.cname=name;
                favObject.curl=url;
                favObject.cimg=img;
                favObject.gosd=gosd;
                favObject.invalid=invalid;
                document.getElementById("img_" + index).src = "images/community/btv-mytv-appbgc11.png";
                document.getElementById("img_" + index).style.visibility = "visible";
            } else {
                document.getElementById("img_" + index).src = "images/btn_trans.gif";
                document.getElementById("img_" + index).style.visibility = "hidden";
            }
        }

        function gotothrid(url,index,gosd,invalid) {
         //   alert("SSSSSSSSSSSSSSSSSgosd="+gosd);
           if(invalid == 1){
            //   alert("SSSSSSSSSSSSSSSSSSSSSSinvalid=1_return!!!!!");
               return;
            }
            if (url.indexOf("http")>-1) {
                <%--if (url.indexOf('?') > -1) {--%>
                    <%--url = url + "&returnurl=<%=timeBasePath%>function/index.jsp";--%>
                <%--} else {--%>
                    <%--url = url + "?returnurl=<%=timeBasePath%>function/index.jsp";--%>
                <%--}--%>
                top.doStop();
                top.jsSetControl("isCheckPlay","0");
                setBackParam(index,"<%=title%>");

                if(gosd=='1' && isZTEBW == true){
                    //Authentication.CTCSetConfig('SetEpgMode', 'SD');
                    if("CTCSetConfig" in Authentication)
                    {
                       // alert("SSSSSSSSSSSSSSSSSSetEpgMode_CTC");
                        Authentication.CTCSetConfig('SetEpgMode', 'SD');
                    }
                    else{
                       // alert("SSSSSSSSSSSSSSSSSSetEpgMode_CU");
                        Authentication.CUSetConfig('SetEpgMode', 'SD');
                    }
                }
                top.mainWin.document.location = url;
            }else{
//                document.location="thirdlink.jsp?leefocus=llinker"+index;
                if(url == ""){
                    url = "application.jsp";
                }
                if(url.indexOf('?') > -1){
                    url = url + "&leefocus=llinker"+index+"&param=<%=title%>_"+index
                }else{
                    url = url + "?leefocus=llinker"+index+"&param=<%=title%>_"+index
                }
                top.mainWin.document.location=url;
            }
        }

         function goRight(){
                 if(document.links["llinker"+(++linkindex)]){
                     document.links["llinker"+linkindex].focus();
                 } else{
                     document.links["llinker0"].focus();
                 }
//                  if(linkindex==5&&document.links["llinker"+6]){
//                      document.links["llinker"+6].focus();
//                      alert("SSSSSSSSSSSSSSSSSSSSzhixingledao6");
//                  }else if(linkindex==17&&document.links["llinker"+18]){
//                      document.links["llinker"+18].focus();
//                  }else if(!document.links["llinker"+(++linkindex)]){
//                      document.links["llinker"+0].focus();
//                  }
          }

         function goLeft(){
             if(document.links["llinker"+(--linkindex)]){
                 document.links["llinker"+linkindex].focus();
             } else{
                 document.links["llinker<%=endindex-1%>"].focus();
             }
    }

         function goUp(){
             if(linkindex%12<6){
                 toPrevPage();
             }
         }

         function goDown(){
             if(linkindex%12>=6){
                 toNextPage();
             }else{
                 var templinkerIndex =  (next-1)*12+6;
                 if(!document.links["llinker"+templinkerIndex]){
                   //  alert("SSSSSSSSSSSSSSSSSSSSSmeiyoudieryele!!!!");
                     toNextPage();
                 }
            
}
         }

         function  doKeyPress(evt){
             var keycode=evt.which;
             if(keycode==0x0027){
                  goRight();
                  return false;
             <%--}else if(keycode==<%=STBKeysNew.onKeyLeft%>){--%>
             }else if(keycode==0x0025){
                  goLeft();
                  return false;
   }else if(keycode==0x0026){ //up
                 goUp();
//                 return false;
             }else if(keycode==0x0028){ //down
                 goDown();
//                 return false;
             }else  if(keycode ==0x0113){
                 doRed();
             }else  if(keycode ==0x0008 || keycode == 24){
                 document.location = "back.jsp";
             } else if (keycode == 0x0110) {
        //Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 36) {
        _window.top.mainWin.document.location = "portal.jsp";
    } else{
                  top.doKeyPress(evt);
                  return true;
             }
         }
        document.onkeypress = doKeyPress;
    </script>
</head>
<body bgcolor="transparent" >
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<div class="topImg" style="font-size:20px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <%
    String tempUrl = String.valueOf(param.get("app_1_img"));
    if (title.indexOf("1")==0) {
        tempUrl = String.valueOf(param.get("app_1_img"));
    } else if (title.indexOf("2")==0) {
        tempUrl = String.valueOf(param.get("app_2_img"));
    } else if (title.indexOf("3")==0) {
        tempUrl = String.valueOf(param.get("app_3_img"));
	}
    %>
    <div style=" left:-10px; top:-12px; width:32px; height:41px; position:absolute; ">
	<!--<div style=" left:3px; top:3px; width:32px; height:41px; position:absolute; ">-->
		<img  src="<%=tempUrl%>" width="66" height="66" />
        <!--<img  src="< %=tempUrl% >" width="52" height="52" />-->
    </div>
   
    <div id="path" align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:500px; height:35px; position:absolute; ">
        <%=headname%>
    </div>
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
            int toplink = row*5;

            String url = "";
            if(cUrl.get(index) != null){
                url = (String)cUrl.get(index);
                 if(url.trim().equals("#") || url.trim().equals("")){
                      url = "";
                 }
                url = replaceUrl(request,url,param);
            }
String tempInvalid = String.valueOf(invalidList.get(index));
%>

<div style="position:absolute;left:<%=left %>px; top:<%=toplink %>px; width:150px;" align="center">
    <a name="llinker<%=index%>" href="javascript:gotothrid('<%=url %>','<%=index%>','<%=String.valueOf(cGosd.get(index))%>','<%=String.valueOf(invalidList.get(index))%>')"
       onfocus="changeImg('<%=index%>','1','<%=cName.get(index)%>','<%=url%>','<%=cImg.get(index) %>','<%=String.valueOf(cGosd.get(index))%>','<%=String.valueOf(invalidList.get(index))%>')"
       onblur="changeImg('<%=index%>','0','<%=cName.get(index)%>','<%=url%>','<%=cImg.get(index) %>')">
        <img src="images/btn_trans.gif" width="1" height="1" alt="" border="0">
    </a>
</div>
<div style="position:absolute;left:<%=left %>px; top:<%=top-10 %>px; width:150px;" align="center">
    <img id="img_<%=index%>" src="images/btn_trans.gif" width="130" height="130" alt="" border="0">
    <%
//        System.out.println("SSSSSSSSSSSSSSSSSSSSScImg.get(index)="+cImg.get(index));
    %>
</div>
<!-- 图片信息 -->
<div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;" align="center">
    <img src="<%=cImg.get(index) %>" width="105" height="105" alt="" border="0">
</div>

<%
    if(tempInvalid.equals("1")){
%>
<!-- 名称信息 -->
<div style=" color:gray; position:absolute;left:<%=left-20%>px; top:<%=top+110 %>px;width:185px; font-size:24px;" align="center">
    <%=String.valueOf(cName.get(index)) %>
</div>
<%
    }else{
%>
<!-- 名称信息 -->
<div style=" position:absolute;left:<%=left-20%>px; top:<%=top+110 %>px;width:185px; font-size:24px;color:white;" align="center">
    <%=String.valueOf(cName.get(index)) %>
</div>
<%
    }
%>
<%

        } else {
            break;
        }
    }
%>
<!-- 广告一 -->
<%--<div style="position: absolute;left: 65px;top: 528px; border:1px solid red; ">--%>
    <%--<epg:FirstPage left="65" top="533" width="354" height="85" location="guanggao01"/>--%>
<%--</div>--%>
<%--<!-- 广告二 -->--%>
<%--<div style="position: absolute;left: 449px;top: 528px; border:1px solid red; ">--%>
    <%--<epg:FirstPage left="449" top="533" width="354" height="85" location="guanggao02"/>--%>
<%--</div>--%>
<%--<!-- 广告三 -->--%>
<%--<div style="position: absolute;left: 833px;top: 528px; border:1px solid red; ">--%>
    <%--<epg:FirstPage left="833" top="533" width="354" height="85" location="guanggao03"/>--%>
<%--</div>--%>

<!-- 底部按钮 -->
<%
    if(totalpage>1){
%>
<div style="position:absolute; width:750px; height:38px; left:700px; top:643px;font-size:22px;">
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
<%--<%@ include file="inc/mailreminder.jsp" %>--%>
<%@ include file="inc/favorite_service_add.jsp" %>
<%--<%@include file="inc/goback.jsp" %>--%>
<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/time.jsp" %>
</body>
</html>