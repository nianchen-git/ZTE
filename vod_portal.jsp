<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.*" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ include file="inc/getFitString.jsp" %>
<%--<epg:PageController name="vod_portal.jsp"/>--%>

<%
    String isnewopen = request.getParameter("isnewopen");
    String topicindex = request.getParameter("topicindex");
    String columnname = request.getParameter("columnname");
    if(columnname == null){
        columnname = "";
    }

    if(!columnname.equals("")){
        columnname = " > "+ columnname;
    }

    topicindex = (topicindex==null)?"0":topicindex;
    if(topicindex.compareTo("8")>0){
        topicindex = "0";
    }
    if((isnewopen!=null && isnewopen.equals("1")) || (isnewopen!=null && isnewopen.equals("2"))){
        System.out.println("SSSSSSSSSSSSSSSSSSSSSSmeiyouyazhan!!!!");
%>

<%
}else{
%>
<epg:PageController name="vod_portal.jsp"/>
<%
    }
%>
<html>
<head>
    <title></title>
    <%
       String vodcolumnid="";
       String linePosterColumnlist="";
        String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
        HashMap param = PortalUtils.getParams(path, "GBK");
    try {
        vodcolumnid = request.getParameter("columnid");
        if (vodcolumnid == null || "".equals(vodcolumnid)) {
            String isFathercolumnlist = String.valueOf(param.get("isFathercolumnlist"));
            String Fathercolumnlist = String.valueOf(param.get("Fathercolumnlist"));
            if (isFathercolumnlist != null && Fathercolumnlist != null && isFathercolumnlist.equals("1")) {//读取N个一级栏目分支
                String[] columnlist = Fathercolumnlist.split(",");
                if(columnlist!=null && columnlist.length>0){
                    vodcolumnid = columnlist[0];
                }else{
                    vodcolumnid = (String) param.get("column01");
                }
            }else{
                vodcolumnid = (String) param.get("column01");
            }
        }
        linePosterColumnlist=String.valueOf(param.get("linePosterColumnlist"));
    } catch (Exception e) {
        e.printStackTrace();
    }

    String leefocus = request.getParameter("leefocus");
    String destpage = request.getParameter("destpage");
    destpage = (destpage==null)?"1":destpage;

    String isAjaxCache = String.valueOf(param.get("isAjaxCache"));
    if(isAjaxCache!=null && isAjaxCache.equals("1")){
    %>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <%
    }else{
    %>
    <script type="text/javascript" src="js/contentloader_nocache.js"></script>
    <%
        }
    %>
    <script type="text/javascript">
//        var isZTEBW = false;
//        if (window.navigator.appName == "ztebw") {
//            isZTEBW = true;
//        }
        //isZTEBW = false;
        var favoriteUrl = "";
        if (isZTEBW == true) {
            favoriteUrl = "vod_favorite_pre.jsp?leftstate=1";
        } else {
            favoriteUrl = "vod_favorite.jsp?leftstate=1";
        }
        var columnid = "<%=vodcolumnid%>";
//        var columnid = "00";
        var path = "点播";
        var pathstr = new Array();
        var statckIndex = new Array();
        var statckdestpage = new Array();
        var statcksubIndex=new Array();
        var arrcindex = new Array();

        var cachestr;
        var pathleng = 0;
        var catedata;
        var infotimer = -1;
        var lefttimer = -1;
        var showChirld=false;
        var isleft = true;
        var $$ = {};
        //栏目相关
        var carr;
        var cdestpage = 1;
        var cpagecount = 1;
        var cleng = 0;
        var cindex = 0;
        var fcolumnid;
        var isleftpage = false;
		var cstart =0;
		var cend =9;

        //vod项目
        var varr;
        var vcolumnid;
        var vdestpage = 1;
        var vpagecount = 1;
        var vodname;
        var normalposter;
        var vleng = 0;
        var vindex = 0;


        //子栏目相关
        var subcolumnid;
        var subArr;
        var subdestpage=1;
        var subpagecount=1;
        var subindex=0;
        var subleng=0;
        var _window = window;
        var lefttime = null;
        var firstColumnName = "<%=columnname%>";
        var action = "";

        if(window.opener){
           _window = window.opener;
        }

    <%
    if(leefocus !=null && !leefocus.equals("")){
    %>
//    alert("SSSSSSSSSSSSSSSSSSSSS111");
    top.jsSetControl("cachestr","");
    <%
     }
    %>


      var linePosterColumnlist = "<%=linePosterColumnlist%>";
      //横版本标志
      var lineColumn = "";
    var topicindex = parseInt("<%=topicindex%>",10) ;
    var tempDestpage = parseInt("<%=destpage%>",10) ;
      function testLineColumn(columnid){
           if(linePosterColumnlist){
                var arr = linePosterColumnlist.split(',');
                for(var i=0; i<arr.length; i++){
                     if(columnid.indexOf(arr[i])==0){
                         lineColumn = "line_";
                         return;
                     }
                }
           }
          lineColumn = "";
      }

    </script>
    <script type="text/javascript">
        function showColumnPath() {
            path = path + firstColumnName;
            for (var i = 0; i < pathstr.length; i++) {
                path = path + " > " + pathstr[i];
//                alert("SSSSSSSSSSSSSSSSSSshowColumnPath"+i+"="+pathstr[i]);
            }
//            path = "点播 > 点播 > 中国有多大啊 > 中国有多大啊 > 中国有多大啊";
//            alert("SSSSSSSSSSSSSSSSSpath.length="+path.length);
            if(path.length>32){
                path = "<marquee version='3' scrolldelay='250' width='590'>"+path+"</marquee>";
            }
            $("path").innerHTML = path;
            path = "点播";
        }

        function clearPage() {
            //columnclear
            textScroll(-1);
            $("columnbar" + cindex).src = "images/btn_trans.gif";
            //vod clear
            changeVodImg(1);
            stopVodScroll();
            columnid = "<%=vodcolumnid%>";
            isleft = true;
            pathstr = new Array();
            path = "点播";

            vdestpage = 1;
            vpagecount = 1;
            vindex = 0;
            vleng = 0;


            cdestpage = 1;
            cpagecount = 1;
            cindex = 0;
            cleng = 0;

            subdestpage = 1;
            subpagecount = 1;
            subindex = 0;
            subleng = 0;
            $("listMsg").style.visibility="hidden";

            if(lineColumn ==""){
                $("sucolumn").style.visibility = "hidden";
                $("vodDiv").style.visibility = "hidden";
            }else{
                $("sucolumn").style.visibility = "hidden";
                $("line_vodDiv").style.visibility = "hidden";
            }
//            for (var i = 0; i < 9; i++) {
//                    if (i < 8) {
//                        $("focus_bg" + i).style.visibility = "hidden";
//                        $("line_" + i).style.visibility = "hidden";
//                        $("fline_" + i).style.visibility = "hidden";
//                        $("focus_name" + i).style.visibility = "hidden";
//                        $("focus_img" + i).src = "images/btn_trans.gif";
//                        $("focus_name" + i).innerHTML = "";
//                        $("vod_img" + i).src = "images/btn_trans.gif";
//                        $("vod_name" + i).innerText = "";
//                        $("vod_name" + i).style.visibility = "visible";
//
//                        $("column_img" + i).src = "images/btn_trans.gif";
//                        $("column_bg" + i).style.visibility = "hidden";
//                        $("sub_column" + i).innerText = "";
//                        $("sub_column" + i).style.visibility = "visible";
//                        $("fcolumn_img" + i).src = "images/btn_trans.gif";
//                        $("fcolumn_bg" + i).style.visibility = "hidden";
//                        $("fsub_column" + i).innerHTML = "";
//                        $("fsub_column" + i).style.visibility = "hidden";
//                    }
//                $("column_div" + i).innerText = "";
//                $("columnbar" + i).src = "images/btn_trans.gif";
//            }
        }

//        function clearVodDiv(){
//
//        }
    </script>
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
    <script type="text/javascript" src="js/vod_portal.js"></script>
</head>
<body bgcolor="transparent" style="overflow:hidden;">
<div  style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
  <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<%@ include file="inc/time.jsp" %>

<!--顶部信息-->
<div class="topImg" style="font-size:20px; top:14px; width:600px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/vod/btv-02-demand.png'); left:13; top:8px; width:22px; height:35px; position:absolute; ">
    </div>
    <div id="path" align="left" style=" font-size:24px; line-height:50px; left:48; top:4px; width:590px; height:35px; position:absolute; ">
    </div>
</div>



<div id="listMsg" style="position:absolute; width:200px; height:51px; left:330px; top:130px;font-size:28px;color:#FFFFFF;visibility:hidden">暂无内容</div>
<!---左边栏目-->
<div style="position:absolute; width:223px; height:543px; left:68px; top:100px;">
    <img src="images/vod/btv_vod_left.png" height="530" width="223" alt="" border="0">
</div>
<!--翻页图标 -->
<div style="position:absolute; width:223px; height:543px; left:67px; top:100px;">
    <div id="up" style="position:absolute; width:25px; height:14px; left:93px; top:12;visibility:hidden">
        <img  src="images/vod/btv_up.png" height="14" width="25" alt="" border="0">

    </div>
    <div id="down" style="position:absolute; width:25px; height:14px; left:93px; top:509px;visibility:hidden">
        <img src="images/vod/btv_down.png" height="14" width="25" alt="" border="0">
    </div>
</div>
<div style="position:absolute;  left:76; top:101;width:212; height:530;">
        <%
            for (int i = 0; i < 9; i++) {

        %>
    <div style="position:absolute;  left:-3; top:<%=i*52+30%>;width:213; height:52;" align="center">
        <img id="columnbar<%=i%>" src="images/btn_trans.gif" alt="" width="213" height="51" border="0">
  </div>
        <div id="column_div<%=i%>"
             style="position:absolute;left:3; top:<%=42+i*52%>;width:200; height:30;color:#FFFFFF;font-size:26px;"
             align="center"></div>
        <%
            }
        %>
</div>
                  
<div style="position:absolute;  left:320px; top:70px;width:980px; height:560px;">
    <%--横版--%>
    <div id="line_vodDiv" style="position:absolute;  left:0; top:0;width:980px; height:560px;">
        <!--vod-->
        <%
            for (int i = 0; i < 8; i++) {
                int frow = i / 4;
                int fcol = i % 4;
                int fleft = fcol * 225+16-15;
                int ftop = 55 + frow * 281;
        %>
        <div id="line_vod_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:200; height:160; ">
            <img id="line_vod_img<%=i%>" src="images/btn_trans.gif" alt="" width="200" height="160" border="0">
        </div>
        <div id="line_line_<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop+131%>;width:198; height:28;visibility:hidden;border:1px solid #8D8D8D">
            <img src="images/vod/btv_vod.png" alt="" width="198" height="28" border="0">
        </div>
        <div id="line_vod_name<%=i%>" style=" position:absolute;left:<%=fleft%>; line-height:28px;top:<%=ftop+131%>;width:196; height:28px;font-size:20px; color:#FFFFFF;"align="center">
        </div>

        <div id="line_focus_bg<%=i%>" style="position:absolute;  left:<%=fleft-15%>; top:<%=ftop-9%>;width:221; height:176;visibility:hidden;border:4px solid red">
        </div>
        <div style="position:absolute;  left:<%=fleft-10%>; top:<%=ftop-5%>;width:220; height:176; ">
            <img id="line_focus_img<%=i%>" src="images/btn_trans.gif" alt="" width="220" height="176" border="0">
        </div>
        <div id="line_fline_<%=i%>" style="position:absolute;  left:<%=fleft-10%>; top:<%=ftop+136%>;width:220; height:35; border-top:1px solid #8D8D8D;visibility:hidden">
            <img src="images/vod/btv_vod.png" alt="" width="220" height="35" border="0">
        </div>
        <div id="line_focus_name<%=i%>" style="visibility: hidden; position:absolute;left:<%=fleft-10%>;line-height:40px;top:<%=ftop+135%>;width:220; height:40;font-size:22px;color:#FFFFFF;"
             align="center" ></div>
        <%
            }
        %>
    </div>

    <%--竖版--%>
    <div id="vodDiv" style="position:absolute;  left:0; top:0;width:980px; height:560px;overflow:hidden;">
    <%--下线提示--%>
    <div id="hint" style="visibility:hidden;text-align:left;overflow:hidden;position:absolute; width:780px; height:38px; left:14px; top:4px;background:url('images/xiaxiantishi.png');line-height:38px;padding-left:26px;padding-right:26px;color:white; font-size:22px;">
    </div>

    <!--vod-->
            <%
                for (int i = 0; i < 8; i++) {
                    int frow = i / 4;
                    int fcol = i % 4;
                    int fleft = 41+fcol * 210;
                    int ftop = 57 + frow * 242;
            %>
        <div id="vod_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:150px; height:214px; ">
            <img id="vod_img<%=i%>" src="images/btn_trans.gif" alt="" width="150" height="214" border="0">
        </div>
        <div id="line_<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop+185%>;width:148px; height:28px;visibility:hidden;border:1px solid #8D8D8D">
            <img src="images/vod/btv_vod.png" alt="" width="148" height="28" border="0">
        </div>
        <div id="vod_name<%=i%>" style=" position:absolute;left:<%=fleft%>; line-height:28px;top:<%=ftop+185%>;width:148px; height:28px;font-size:20px; color:#FFFFFF;"align="center">
        </div>

    <div id="focus_bg<%=i%>" style="position:absolute;  left:<%=fleft-8%>; top:<%=ftop-9%>;width:160px; height:225px;visibility:hidden;border:3px solid red;border-bottom:5px solid red;">
        </div>
        <div style="position:absolute;  left:<%=fleft-5%>; top:<%=ftop-6%>;width:160px; height:226px; ">
            <img id="focus_img<%=i%>" src="images/btn_trans.gif" alt="" width="160" height="226" border="0">
        </div>
        <div id="fline_<%=i%>" style="position:absolute;  left:<%=fleft-5%>; top:<%=ftop+180%>;width:160px; height:39px; border-top:1px solid #8D8D8D;visibility:hidden">
            <img src="images/vod/btv_vod.png" alt="" width="160" height="39" border="0">
        </div>
        <div id="focus_name<%=i%>" style="visibility: hidden; position:absolute;left:<%=fleft-5%>;line-height:39px;top:<%=ftop+180%>;width:160px; height:39px;font-size:22px;color:#FFFFFF;"align="center" ></div>
            <%
                }
            %>
    </div>

    <%--<div id="vodDiv"  style="position:absolute;  left:0; top:0;width:980; height:560;visibility:hidden">--%>
        <%--<!--vod-->--%>
        <%--<%--%>
            <%--for (int i = 0; i < 8; i++) {--%>
                <%--int frow = i / 4;--%>
                <%--int fcol = i % 4;--%>
                <%--int fleft = fcol * 225+16;--%>
                <%--int ftop = 35 + frow * 281;--%>
        <%--%>--%>
        <%--<div id="vod_poster<%=i%>" style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:160; height:215; ">--%>
            <%--<img id="vod_img<%=i%>" src="images/btn_trans.gif" alt="" width="161" height="215" border="0">--%>
        <%--</div>--%>
        <%--<div id="line_<%=i%>" style="position:absolute;  left:<%=fleft+1%>; top:<%=ftop+185%>;width:157; height:28;visibility:hidden;border:1px solid #8D8D8D">--%>
            <%--<img src="images/vod/btv_vod.png" alt="" width="157" height="28" border="0">--%>
        <%--</div>--%>
        <%--<div id="vod_name<%=i%>" style="position:absolute;left:<%=fleft%>; line-height:28px;top:<%=ftop+185%>;width:160; height:28px;font-size:20px; color:#FFFFFF;"align="center">--%>
        <%--</div>--%>

        <%--<div id="focus_bg<%=i%>" style="position:absolute;  left:<%=fleft-13%>; top:<%=ftop-12%>;width:182; height:246;visibility:hidden;border:2px solid red">--%>
        <%--</div>--%>
        <%--<div style="position:absolute;  left:<%=fleft-10%>; top:<%=ftop-10%>;width:180; height:270; ">--%>
            <%--<img id="focus_img<%=i%>" src="images/btn_trans.gif" alt="" width="180" height="245" border="0">--%>
        <%--</div>--%>
        <%--<div id="fline_<%=i%>" style="position:absolute;  left:<%=fleft-10%>; top:<%=ftop+194%>;width:180; height:40; border-top:1px solid #8D8D8D;visibility:hidden">--%>
            <%--<img src="images/vod/btv_vod.png" alt="" width="180" height="40" border="0">--%>
        <%--</div>--%>
        <%--<div id="focus_name<%=i%>" style="position:absolute;left:<%=fleft-10%>;line-height:40px;top:<%=ftop+194%>;width:190; height:40;font-size:22px;color:#FFFFFF;"--%>
             <%--align="center" ></div>--%>

        <%--<%--%>
            <%--}--%>
        <%--%>--%>
    <%--</div>--%>

</div>

<%--4K提示--%>
    <div id="alert_4K" style="visibility:hidden; position:absolute; width:432px; height:234px; left:424px; top:242px;background:url('images/4K_alert.png');">
        <img src="images/4K_alert_focus.png" height="38" width="138" style="position:absolute; top:182px; left:147px;"/>
    </div>
<%--频道跳转海报--%>
    <div id="channel_jump0" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg0" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img0"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img0" src="" style="width:926px;height:504px;">
        </div>
        <%--淘剧场--%>
        <%--<div id="livefocus_img0" style="visibility:hidden;position:absolute;width:304px;height:65px;top:107px;left:268px;border:0px;"></div>--%>
    </div>
	   
    <%--淘电影--%>
    <div id="channel_jump1" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg1" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img1"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img1" src="" style="width:926px;height:504px;">
        </div>
    </div>

    <%--大健康--%>
    <div id="channel_jump2" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg2" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img2"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img2" src="" style="width:926px;height:504px;">
        </div>
    </div>
	<%--4k超清--%>
	<div id="channel_jump3" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg3" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img3"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img3" src="" style="width:926px;height:504px">
        
        </div>
    </div>
	<%--淘Bady--%>
	<div id="channel_jump4" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg4" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img4"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img4" src="" style="width:926px;height:504px">
        
        </div>
    </div>
	<%--淘剧场--%>
	<div id="channel_jump5" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg5" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img5"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img5" src="" style="width:926px;height:504px">
      
        </div>
    </div>
	<%--淘电影--%>
	<div id="channel_jump6" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg6" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img6"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img6" src="" style="width:926px;height:504px">
       
        </div>
    </div>
	<%--淘娱乐--%>
	<div id="channel_jump7" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg7" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img7"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img7" src="" style="width:926px;height:504px">
        
        </div>
    </div>
	<%--DOGTV--%>
	<div id="channel_jump8" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg8" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img8"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img8" src="" style="width:926px;height:504px">
        </div>
    </div>
	<%--大健康--%>
    <div id="channel_jump9" style="visibility:hidden; position:absolute; width:926px; height:504px; left:310px; top:106px;">
        <img id="liveJumpImg9" src="" style="width:926px; height:504px; border:0px;">
        <div id="livefocus_img9"  style="visibility:hidden;position:absolute;top:0px;left:0px;width:926px;height:504px;z-index:100">
        <img id="live_img9" src="" style="width:926px;height:504px">
        </div>
    </div>
	
	
    
<div style=" position:absolute;  left:280; top:73;width:980; height:520;">
    <div id="sucolumn" style=" position:absolute;  left:0; top:0;width:980; height:520;">
            <!--vod-->
            <%
                for (int i = 0; i < 8; i++) {
                    int row = i / 4;
                    int col = i % 4;
                    int left = col * 230+16;
                    int top = 30 + row * 270;
            %>
            <div id="column_bg<%=i%>" style="position:absolute;  left:<%=left%>; top:<%=top%>;width:220; height:223;visibility:hidden ">
                <img src="images/vod/btv13-column.png" alt="" width="220" height="223" border="0">
            </div>
            <div id="column_pos<%=i%>" style="position:absolute;  left:<%=left+9%>; top:<%=top+16%>;width:200; height:160">
                <img id="column_img<%=i%>" src="images/btn_trans.gif" alt="" width="200" height="160" border="0">
            </div>
            <div id="sub_column<%=i%>" style="position:absolute; line-height:40px; left:<%=left+10%>; top:<%=top+177%>;width:199; height:40;font-size:20px;color:#FFFFFF" align="center"></div>

            <%--<div id="fcolumn_bg<%=i%>" style="position:absolute; left:<%=left%>; top:<%=top%>;width:220; height:223;visibility:hidden ">--%>
                <%--<img src="images/vod/btv13-column.png" alt="" width="220" height="223" border="0">--%>
            <%--</div>--%>
            <%--<div id="fcolumn_pos<%=i%>" style="position:absolute;  left:<%=left+9%>; top:<%=top+16%>;width:200; height:160">--%>
                <%--<img id="fcolumn_img<%=i%>" src="images/btn_trans.gif" alt="" width="200" height="160" border="0">--%>
            <%--</div>--%>
            <%--<div id="fsub_column<%=i%>" style="position:absolute; line-height:40px; left:<%=left+10%>; top:<%=top+177%>;width:199; height:40;font-size:20px;color:#FFFFFF" align="center"></div>--%>

            <div id="fcolumn_bg<%=i%>" style="position:absolute;   left:<%=left-7%>; top:<%=top+0%>;width:243; height:195;visibility:hidden ">
                <img src="images/vod/btv13-column_big.png" alt="" width="230" height="243" border="0">
            </div>
            <div id="fcolumn_pos<%=i%>" style="position:absolute; left:<%=left-3%>; top:<%=top+11%>;width:220; height:176;visibility:hidden">
                <img id="fcolumn_img<%=i%>" src="images/btn_trans.gif" alt="" width="220" height="176" border="0">
            </div>
            <div id="fsub_column<%=i%>" style="visibility:hidden;line-height:47px;position:absolute;  left:<%=left-3%>; top:<%=top+191%>;width:219; height:47;font-size:22px;color:#FFFFFF" align="center"></div>

            <div id="fcolumn_bgb<%=i%>" style="position:absolute; border:4px solid red; left:<%=left-3%>; top:<%=top+12%>;width:213; height:219;visibility:hidden ">
            </div>
            <%
                }
            %>
    </div>
</div>
 <!--滚动条--->
<div style="position:absolute; width:20px; height:534px; left:1218px; top:103px;">
    <div id="pageBar" style="position:absolute; width:20px; height:534px; left:0px; top:0px;visibility:hidden">
      <div style="position:absolute; width:20px; height:534px; left:0px; top:0px;">
            <img src="images/vod/btv-02-scrollbar.png" border="0" alt="" width="20" height="534">
      </div>

        <div id="scroll" style="position:absolute; width:20px; height:534px; left:3px; top:3px;">
                <img id="scrollbar1" src="images/vod/btv-02-scrollbar01.png" border="0" width="13" height="10">
                <img id="scrollbar2" src="images/vod/btv-02-scrollbar02.png" border="0" width="13" height="10" >
                <img id="scrollbar3" src="images/vod/btv-02-scrollbar03.png" border="0" width="13" height="10">
        </div>
    </div>
</div>
<%--下方提示--%>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<div style="position:absolute;width:1280px; height:40px; left: -10px; top: 640px; color:black;font-size:22px;">
    <div  style="position:absolute;width:60px; height:32px; left: 560px; top: -2px; color:black;font-size:22px;">
        <img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 620px; top: 2px; color:white; font-size:22px;">
        &nbsp;上一页
    </div>
    <div  style="position:absolute;width:60px; height:32px; left: 720px; top: -2px; color:black; font-size:22px;">
        <img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 780px; top: 2px; color:white; font-size:22px;">
        &nbsp;下一页
    </div>
    <%--<div  style="position:absolute;width:60px; height:32px; left: 920px; top: -2px; color:black; font-size:22px;">--%>
    <%--<img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >--%>
    <%--</div>--%>
    <%--<div  style="position:absolute;width:120px; border:1px solid red; height:30px; left: 980px; top: 0px; color:white; font-size:22px;">--%>
    <%--&nbsp;按红色按钮为收藏--%>
    <%--</div>--%>
    <div  style="position:absolute;width:60px; height:32px; left: 870px; top: -2px; color:black; font-size:22px;">
        <img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >
    </div>
    <div  style="position:absolute;width:190px; height:30px; left: 930px; top: 2px; color:white; font-size:22px;">
        &nbsp;收藏
    </div>
    <div  style="position:absolute;width:60px; height:32px; left: 1130px; top: -2px; color:black;font-size:22px;">
        <img src="images/vod/btv_Search.png" alt="" width=60px height="32" border="0" >
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 1190px; top: 2px; color:white; font-size:22px;">
        &nbsp;搜索
    </div>
</div>

<%--<div style="left:550; top:50; width:90; height:100; position:absolute" id="channelNumber">--%>
<%--</div>--%>
<script type="text/javascript">
    <%
    if(isnewopen!=null && isnewopen.equals("1")){
    %>
    init();
    <%
    }
    %>

    if(isZTEBW == false){
        init();
    }
//    init();
</script>
<%@ include file="favorite_msg.jsp" %>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
</html>