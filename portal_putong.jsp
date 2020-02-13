<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.HashMap" %>

<%@	page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="portal.jsp"/>
<html>
<head>
    <title>portal</title>
</head>
<%
     String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
     HashMap param = PortalUtils.getParams(path, "GBK");
     String TIME_COUNT=String.valueOf(param.get("TIME_COUNT"));
     String INTERVAL=String.valueOf(param.get("INTERVAL"));
     String channelColumnid=String.valueOf(param.get("column00"));
     String vodColumnid = String.valueOf(param.get("column01"));

     //社区
     String comm_yygh=(String)param.get("comm_yygh");//预约挂号
     String comm_cyyd=(String)param.get("comm_cyyd");//餐饮预订
     String comm_ycpw=(String)param.get("comm_ycpw");//演出票务
     String comm_sdzc=(String)param.get("comm_sdzc");//首都之窗
     String comm_bmfu=(String)param.get("comm_bmfu");//便民服务
     String comm_ltzx=(String)param.get("comm_ltzx");//联通在线

    //生活
    String life_gwsc=(String)param.get("life_gwsc");//购物商城
    String life_qxxx=(String)param.get("life_qxxx");//气息信息
    String life_zxyd=(String)param.get("life_zxyd");//在线阅读
    String life_slfw=(String)param.get("life_slfw");//商旅服务

    //应用
    String app_tgyx=(String)param.get("app_tgyx");//体感游戏
    String app_klok=(String)param.get("app_klok");//卡拉OK
    String app_jyzx=(String)param.get("app_jyzx");//教育在线
    String app_yjtc=(String)param.get("app_yjtc");//有奖调查





     String lastfocus = request.getParameter("lastfocus");
     int bottomMenuIndex = 3;
     int leftMenuIndex = 0;
     if(lastfocus != null && !"".equals(lastfocus)){
         try{
             String[] indexs = lastfocus.split("_");
             if(indexs!=null && indexs.length>0){
                   bottomMenuIndex=Integer.parseInt(indexs[0]);
                   if(indexs.length>1){
                       leftMenuIndex =Integer.parseInt(indexs[1]);
                   }
             }
             //bottomMenuIndex = Integer.parseInt(lastfocus);
         }catch(Exception e){
             System.out.println("fanhui de bushi bottomMenuIndex");
         }
     }

    System.out.println("++++++++++++++++request.getQueryString="+request.getQueryString());
    System.out.println("++++++++++++++++bottomMenuIndex="+bottomMenuIndex);
    System.out.println("++++++++++++++++leftMenuIndex="+leftMenuIndex);
%>

<script type="text/javascript" src="js/contentloader.js"></script>
<script language="javascript" type="">
Authentication.CTCSetConfig('SetEpgMode', '720P');
var $$ = {};

function $(id){
    if(!$$[id]){
       $$[id] = document.getElementById(id);
    }
    return $$[id];
}

//社区相关
var commarr=[{cname:'<%=comm_yygh%>',curl:'community.jsp?param=comm_yygh'},
              {cname:'<%=comm_cyyd%>',curl:'community.jsp?param=comm_cyyd'},
              {cname:'<%=comm_ycpw%>',curl:'community.jsp?param=comm_ycpw'},
              {cname:'<%=comm_sdzc%>',curl:'community.jsp?param=comm_sdzc'},
              {cname:'<%=comm_bmfu%>',curl:'community.jsp?param=comm_bmfu'},
              {cname:'<%=comm_ltzx%>',curl:'community.jsp?param=comm_ltzx'}];

//生活相关
var lifeArr = [
      {cname:'<%=life_gwsc%>',curl:'life.jsp?param=life_gwsc'},
      {cname:'<%=life_qxxx%>',curl:'life.jsp?param=life_qxxx'},
      {cname:'<%=life_zxyd%>',curl:'life.jsp?param=life_zxyd'},
      {cname:'<%=life_slfw%>',curl:'life.jsp?param=life_slfw'}
];

//应用
var appArr = [
      {cname:'<%=app_tgyx%>',curl:'application.jsp?param=app_tgyx'},
      {cname:'<%=app_klok%>',curl:'application.jsp?param=app_klok'},
      {cname:'<%=app_jyzx%>',curl:'application.jsp?param=app_jyzx'},
      {cname:'<%=app_yjtc%>',curl:'application.jsp?param=app_yjtc'}
];


//专题
var specialArr = [];

<%
       //专题
    String spe_zt_sum=(String)param.get("spe_zt_sum");//专题一
    int spe_zt_sum1 = 0;
    try{
        spe_zt_sum1 = Integer.parseInt(spe_zt_sum);
    }catch (Exception e){

    }


   if(spe_zt_sum1>0){
       for(int i=0; i<spe_zt_sum1; i++){
          String spe_ztiname=(String)param.get("spe_zt"+i);//专题一
          if(spe_ztiname!=null && !"".equals(spe_ztiname)){
%>
       var special = {};
       special.cname ='<%=spe_ztiname%>';
       special.curl='special.jsp?param=<%="spe_zt"+i%>';
       specialArr.push(special);
<%
          }
       }
   }
%>



var bottomMenuIndex = <%=bottomMenuIndex%>;
var bottomMenuCount = 8;
var leftMenuIndex = <%=leftMenuIndex%>;
var leftMenuCount = 7;
var upAction = false;
var downAction = false;
var destpage = 1;
var pagecount = 1;
var columnArr = [];
var length = 7;
var bottomMenuTimer ;
var channelType = "column";
var curcolumnid ;
var columnIndex = -1;
var cIndex =-1;
var isFirstCome = true;

//alert("SSSSSSSSSSSSSSSSSSSStop.columnid_tv="+top.columnid_tv);
//alert("SSSSSSSSSSSSSSSSSSSStop.channelid_tv="+top.channelid_tv);
<%--var columnid_tv = '<%=channelColumnid%>';--%>
//var channelid_tv = top.channelid_tv;
var currentChannel = top.channelInfo.currentChannel;
if(currentChannel ==-1){
   currentChannel ="";
}

//alert("=======================currentChannel="+currentChannel);

//columnid_tv = "01";

var mytvArr = [{tvname:'收藏',tvurl:'favorite_portal.jsp?leefocus=0_0'}
                 ,{tvname:'导视',tvurl:'channel_bytime_pre.jsp?columnid=<%=channelColumnid%>&channelid1='+currentChannel+'&numperpage=10&timecount=<%=TIME_COUNT%>&interval=<%=INTERVAL%>&leefocus=0_1'}
                 ,{tvname:'消费记录',tvurl:'selfcare_myAcount_ppv.jsp?leefocus=0_2'}
//                 ,{tvname:'有奖调查',tvurl:'portal_2.jsp?leefocus=0_3'}
                 ,{tvname:'设置',tvurl:'setting.jsp?leefocus=0_3'}
                ];


function showBottomMenuTimer(){
    $('bottom_menu_focus_'+bottomMenuIndex).style.visibility = 'visible';
    $('bottom_menu_text_'+bottomMenuIndex).style.color = '#ff0000';

    if(bottomMenuTimer){
        window.clearTimeout(bottomMenuTimer)
    }
    bottomMenuTimer = window.setTimeout('showBottomMenu();',600);
}

function showBottomMenu(){


    if(bottomMenuIndex == 0){//我的tv
         showMyTvColumn();
    }else if(bottomMenuIndex == 1){//回看
         showTvodChannel(1);
    }else if(bottomMenuIndex == 2){//点播
         showVodColumn(1);
    }else if(bottomMenuIndex == 3){//频道
         showChannelColumn();
    }else if(bottomMenuIndex == 4){//专题
         showThirdArr(specialArr);
    }else if(bottomMenuIndex == 5){//应用
         showThirdArr(appArr);
    }else if(bottomMenuIndex == 6){//社区
         showThirdArr(commarr);
    }else if(bottomMenuIndex == 7){//生活
         showThirdArr(lifeArr);
    }

    if(bottomMenuIndex==3){
        $('left_menu_img').style.visibility = 'visible';
    }else{
        $('left_menu_img').style.visibility = 'hidden';
    }
}
function showThirdArr(Arr){
     if(!Arr){
        return;
     }
     length=Arr.length;
    if(isFirstCome){
       isFirstCome = false;
    }else{
       leftMenuIndex = 0;
    }
     for(var i=0; i<leftMenuCount; i++){
         if(i<length){
            $('left_menu_'+i).innerText = Arr[i].cname.substr(0,9);
            $('left_menu_'+i).style.visibility = 'visible';
         }else{
            $('left_menu_'+i).innerText ='';
            $('left_menu_'+i).style.visibility = 'hidden';
         }
     }
    $('up').style.visibility = "hidden";
    $('down').style.visibility = "hidden";
    changeLeftMenuFocus();
}
function showMyTvColumn(){
     destpage = 1;
     pagecount = 1;
     length = mytvArr.length;
    if(isFirstCome){
       isFirstCome = false;
    }else{
       leftMenuIndex = 0;
    }
    for(var i=0; i<leftMenuCount; i++){
         if(i<length){
            $('left_menu_'+i).innerText = mytvArr[i].tvname;
            $('left_menu_'+i).style.visibility = 'visible';
         }else{
            $('left_menu_'+i).innerText ='';
            $('left_menu_'+i).style.visibility = 'hidden';
         }
     }
    showupdowicon();
    changeLeftMenuFocus();
}

function showTvodChannel(destpage){
      var requestUrl = "action/allchannellistData.jsp?columnid=<%=channelColumnid%>&isFromPortal=1&destpage="+destpage;
      var loaderSearch = new net.ContentLoader(requestUrl, showtvodchannelsResponse);
}

function showtvodchannelsResponse(){
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     destpage = data.destpage;
     pagecount = data.pageCount;
     columnArr = data.channelData;

     if(destpage == 1){
         var channelObj = {channelname:'全部',columnid:'<%=channelColumnid%>'};
         columnArr.unshift(channelObj);
     }
    if(isFirstCome){
       isFirstCome = false;
    }else{
       leftMenuIndex = 0;
    }
     if(upAction == true){
         upAction = false;
         leftMenuIndex = 6;
     }else if(downAction == true){
         leftMenuIndex = 0;
     }

//     alert("==============leftMenuIndex="+leftMenuIndex);

     length = columnArr.length;
     for(var i=0; i<leftMenuCount; i++){
         if(i<length){
            $('left_menu_'+i).innerText = columnArr[i].channelname.substr(0,8);
            $('left_menu_'+i).style.visibility = 'visible';
         }else{
            $('left_menu_'+i).innerText ='';
            $('left_menu_'+i).style.visibility = 'hidden';
         }
     }
    showupdowicon();
    changeLeftMenuFocus();
}

function showVodColumn(destapage){
      var requestUrl = "action/vod_columnlist.jsp?columnid=<%=vodColumnid%>&numberperpage=7&destpage="+destapage;
      var loaderSearch = new net.ContentLoader(requestUrl, showvodcolumnlist);
}

function showChannelColumn(){
      <%--alert("SSSSSSSSSSSSSSSSshowChannelColumn=<%=channelColumnid%>");--%>
      var requestUrl = "action/vod_columnlist.jsp?columnid=<%=channelColumnid%>&numberperpage=6&destpage=1";
      var loaderSearch = new net.ContentLoader(requestUrl, showchannelcolumnlist);
}

var isFirstChannel = true;

function showchannelcolumnlist(){
     channelType = "column";
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     destpage = data.destpage;
     pagecount = data.pageCount;
     columnArr = data.columnData;
     var columnObj = {columnname:'全部',columnid:'<%=channelColumnid%>'};
     columnArr.unshift(columnObj);
     length = columnArr.length;
     if(isFirstChannel){
        isFirstChannel = false;
        for(var i=length; i>=length && i<leftMenuCount; i++){
          $('left_menu_img'+i).style.visibility = 'hidden';
        }
     }

     if(isFirstCome){
        isFirstCome = false;
     }else{
        leftMenuIndex = 0;
     }
     for(var i=0; i<leftMenuCount; i++){
         //alert('++++++++++++columnName='+columnArr[i].columnname);
         if(i<length){
            //$('left_menu_'+i).innerHTML = columnArr[i].columnname+"&nbsp;&nbsp;&nbsp;&nbsp;<img style='' width='30' height='19' src='images/liveTV/btv-channel-right.png'/>";
            $('left_menu_'+i).innerHTML = columnArr[i].columnname;
            $('left_menu_'+i).style.visibility = 'visible';
         }else{
            $('left_menu_'+i).innerText ='';
            $('left_menu_'+i).style.visibility = 'hidden';
         }
     }
    if(columnIndex !=-1){
        leftMenuIndex = columnIndex;
        columnIndex =-1;
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function showupdowicon(){
     if(destpage>1){
         $('up').style.visibility = 'visible';
     }else{
         $('up').style.visibility = 'hidden';
     }

     if(destpage<pagecount){
         $('down').style.visibility = 'visible';
     }else{
         $('down').style.visibility = 'hidden';
     }
}

function showvodcolumnlist(){
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    destpage = data.destpage;
    pagecount = data.pageCount;
    columnArr = data.columnData;

    if(isFirstCome){
       isFirstCome = false;
    }else{
       leftMenuIndex = 0;
    }
    if(upAction == true){
        upAction = false;
        leftMenuIndex = 6;
    }else if(downAction == true){
        leftMenuIndex = 0;
    }

//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    length = columnArr.length;
    for(var i=0; i<leftMenuCount; i++){
        //alert('++++++++++++columnName='+columnArr[i].columnname);
        if(i<length){
           $('left_menu_'+i).innerText = columnArr[i].columnname.substr(0,8);
           $('left_menu_'+i).style.visibility = 'visible';
        }else{
           $('left_menu_'+i).innerText ='';
           $('left_menu_'+i).style.visibility = 'hidden';
        }
    }
   showupdowicon();
   changeLeftMenuFocus();
}

function hiddenBottomMenuFocus(){
    $('bottom_menu_focus_'+bottomMenuIndex).style.visibility = 'hidden';
    $('bottom_menu_text_'+bottomMenuIndex).style.color = '#ffffff';
}

function changeLeftMenuFocus(){
    $('left_focus_img').style.top = 90+51*leftMenuIndex+'px';
}

function goLeft(){
    hiddenBottomMenuFocus();
    bottomMenuIndex = (--bottomMenuIndex+bottomMenuCount)%8;
    showBottomMenuTimer();
}

function goRight(){
    //alert('+++++++++++right++++++');
    hiddenBottomMenuFocus();
    bottomMenuIndex = (++bottomMenuIndex+bottomMenuCount)%8;
    showBottomMenuTimer();
}

function goOk(){
    if(bottomMenuIndex==0){//mytv
//         alert('SSSSSSSSSSSSStvurl='+mytvArr[leftMenuIndex].tvurl);
         document.location = mytvArr[leftMenuIndex].tvurl;
    }else if(bottomMenuIndex==1){ //回看
         if(destpage == 1 && leftMenuIndex == 0){//回看全部，链接地址
              top.mainWin.document.location = "channel_all_tvod.jsp?leefocus=1_0";
         }else{ //单个频道回看
             var columnid = columnArr[leftMenuIndex].columnid;
             var channelid = columnArr[leftMenuIndex].channelid;
             var mixno =  columnArr[leftMenuIndex].mixno;
//             alert("SSSSSS"+columnid+channelid+"===="+mixno);
             top.mainWin.document.location = "channel_onedetial_tvod.jsp?columnid="+columnid+"&channelid="+channelid+"&mixno="+mixno+"&leefocus=1_"+leftMenuIndex;
         }
    }else if(bottomMenuIndex==2){ //点播
         var curColumnid = columnArr[leftMenuIndex].columnid;
         top.mainWin.document.location = "vod_portal.jsp?columnid="+curColumnid+"&leefocus=2_"+leftMenuIndex;
    }else if(bottomMenuIndex==3){ //频道
         if(channelType == 'column'){ //在频道列表上
             if(leftMenuIndex == 0){//跳到全频道展示列表
                 top.mainWin.document.location = "channel_all.jsp?leefocus=3_0";
             }else{
                 curcolumnid = columnArr[leftMenuIndex].columnid;
                 cIndex = leftMenuIndex;
                 $('left_menu_img').style.visibility='hidden';
                 showChannelListByColumnid(1);
             }
         }else if(channelType == 'channel'){
              var mixno = columnArr[leftMenuIndex].mixno;
//              alert("SSSSSSSSSSSSSmixno="+mixno);
//              return;
              top.mainWin.document.location = "channel_play.jsp?mixno="+mixno;
         }
    }else{
        var url="";
        if(bottomMenuIndex==4){
            url = specialArr[leftMenuIndex].curl;
        }else if(bottomMenuIndex==5){
            url = appArr[leftMenuIndex].curl;
        }else if(bottomMenuIndex==6){
           url = commarr[leftMenuIndex].curl;
        }else if(bottomMenuIndex==7){
            url = lifeArr[leftMenuIndex].curl;
        }
        url = url+"&leefocus="+bottomMenuIndex+"_"+leftMenuIndex;
      //  alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSurl="+url);
        top.mainWin.document.location = url;
    }
}

function showChannelListByColumnid(destpage){
    var requestUrl = "action/channellistbycolumnid.jsp?columnid="+curcolumnid+"&numberperpage=7&destpage="+destpage;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelbycolumnid);
}

function showchannelbycolumnid(){
    channelType = "channel";
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    destpage = data.destpage;
    pagecount = data.pageCount;
    columnArr = data.channelData;
    leftMenuIndex = 0;
    if(upAction == true){
        upAction = false;
        leftMenuIndex = 6;
    }else if(downAction == true){
        leftMenuIndex = 0;
    }

    length = columnArr.length;
    for(var i=0; i<leftMenuCount; i++){
        if(i<length){
           var mixno = columnArr[i].mixno;
           if(mixno.length == 1){
              mixno = "00"+mixno;
           }else if(mixno.length == 2){
              mixno = "0"+mixno;
           }
//           alert("SSSSSSSSSSSSSSSSSmixno="+mixno);
           $('left_menu_'+i).innerText = mixno+" "+columnArr[i].channelname.substr(0,9);
           $('left_menu_'+i).style.visibility = 'visible';
        }else{
           $('left_menu_'+i).innerText ='';
           $('left_menu_'+i).style.visibility = 'hidden';
        }
    }
   showupdowicon();
   changeLeftMenuFocus();
}

function goUp(){
     if(leftMenuIndex>0){
       leftMenuIndex--
       changeLeftMenuFocus();
     }else if(leftMenuIndex == 0){
         doLast();
     }
}

function doLast(){
    if(bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex==3 && channelType=='channel')){ //点播
        if(destpage >1){
            upAction = true;
            downAction = false;
            if(bottomMenuIndex == 2){
                showVodColumn(--destpage);
            }else if(bottomMenuIndex == 1){
                showTvodChannel(--destpage);
            }else if(bottomMenuIndex == 3){
                showChannelListByColumnid(--destpage);
            }
        }
    }
}

function goDown(){
//   alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSlength="+length);
   if(leftMenuIndex<length-1){
       leftMenuIndex++
       changeLeftMenuFocus();
   }else if(leftMenuIndex == leftMenuCount-1){
       doNext();
   }
}

function doNext(){
    if(bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex==3 && channelType=='channel')){ //点播
        if(destpage < pagecount){
            downAction = true;
            upAction = false;
            if(bottomMenuIndex == 2){
                showVodColumn(++destpage);
            }else if(bottomMenuIndex == 1){
                showTvodChannel(++destpage);
            }else if(bottomMenuIndex == 3){
                showChannelListByColumnid(++destpage);
            }
        }
    }
}

function doKeyPress(evt){
    var keycode = evt.which;
    if (keycode == <%=STBKeysNew.onKeyLeft%>){
        goLeft();
    }else if (keycode == <%=STBKeysNew.onKeyRight%>){
        goRight();
    }else if (keycode == <%=STBKeysNew.onKeyOK%>){
        try{
           goOk();
        }catch(e){
          //  alert('SSSSSSSSSSSSSSSSSSS error!!!');
        }

    }else if (keycode == <%=STBKeysNew.onKeyUp%>){
        goUp();
    }else if (keycode == <%=STBKeysNew.onKeyDown%>){
        goDown();
    }else if(keycode == 0x0110){
        Authentication.CTCSetConfig("KeyValue","0x110");
        top.jsHideOSD();
    }else if (keycode == <%=STBKeysNew.remoteBack%>){
        //top.jsHideOSD();
        if(bottomMenuIndex == 3 && channelType == 'channel'){
            columnIndex  = cIndex;
            showBottomMenu();
        }else{
            //top.mainWin.document.location = "portal.jsp";
            top.jsHideOSD();
        }
    }else if(keycode == <%=STBKeysNew.remotePlayLast%>){
          doLast();
    }else if(keycode == <%=STBKeysNew.remotePlayNext%>){
          doNext();
    }else{
        //top.doKeyPress(evt);
        commonKeyPress(evt);
    }
    return false;
}

function dotest(){
   // alert('SSSSSSSSSSSSSSSSSSSSSSSSS');
    return true;
}

document.onkeypress = doKeyPress;
</script>

<body bgcolor="transparent">

 <%--左侧的大的div--%>
 <div style="background:url('images/portal/bg_portal_left.png'); position:absolute; width:227px; height:483px; left:39px; top:87px; font-size:24;color:#FFFFFF; line-height:51px;" align="center">
      <div id='up' style="background:url('images/portal/up.png'); position:absolute; width:24px; height:14px; left:95px; top:73px; " >
      </div>
      <div id='down' style="background:url('images/portal/down.png'); position:absolute; width:24px; height:14px; left:95px; top:456px; " >
      </div>


      <div id="left_focus_img" style="position:absolute; width:205px; height:51px; left:8px; top:90px; " >
          <img height="51" width="205" src="images/portal/focus.png" />
      </div>
     <%
         for(int i=0; i<7; i++){
             int topIndex = 90+51*i;
     %>
      <%--<div style="border:1px solid red;background:url('images/portal/line.png') bottom no-repeat; position:absolute; width:205px; height:51px; left:8px; top:<%=topIndex%>px; " >--%>
      <%--</div>--%>
      <div id="left_menu_<%=i%>" style="background:url('images/portal/line.png') no-repeat bottom; position:absolute; width:205px; height:51px; left:8px; top:<%=topIndex%>px; " >
          <%--生活乱如麻--%>
      </div>
     <%
         }
     %>

      <div id="left_menu_img" style=" visibility:hidden; position:absolute; width:50px; height:380px; left:178px; top:102px; " >
          <%
              for(int i=1; i<7; i++){
                  int topindex = 0+51*i;
          %>
              <div id="left_menu_img<%=i%>" style=" position:absolute; width:30px; height:49px; left:0px; top:<%=topindex%>px; " >
                  <img src="images/portal/btv-channel-right.png" width="14" height="22"/>
              </div>
          <%
              }
          %>
      </div>
 </div>


 <%--下方菜单展示--%>
 <div style="position:absolute; width:1280px; height:720px; left:0px; top:490px; font-size:28px;" align="center">
    <div style="left:-590; top: 100; width: 1; height: 1; position: absolute">
        <a
           href="javascript:dotest();" >
            <img alt="" src="images/btn_trans.gif" width="30" height="30" border="0"/>
        </a>
    </div>

     <div style="background:url('images/portal/bg_portal_down.png'); position:absolute; width:1279px; height:178px; left:0px; top:40px; ">
    </div>
    <%--我的tv--%>
    <div style="background:url('images/portal/icons/myTV.png'); position:absolute; width:100px; height:100px; left:204px; top:80px; ">
        <div id="bottom_menu_focus_0" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden;">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_0" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
            我的TV
        </div>
    </div>
    <%--回看--%>
    <div style="background:url('images/portal/icons/tvod.png'); position:absolute; width:100px; height:100px; left:316px; top:70px;" >
        <div id="bottom_menu_focus_1" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden;">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_1" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             回看
        </div>
	</div>
    <%--点播--%>
    <div style="background:url('images/portal/icons/vod.png'); position:absolute; width:100px; height:100px; left:428px; top:48px; ">
	    <div id="bottom_menu_focus_2" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_2" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             点播
        </div>
    </div>
    <%--频道--%>
    <div style="background:url('images/portal/icons/channel.png'); position:absolute; width:100px; height:100px; left:547px; top:46px; ">
        <div id="bottom_menu_focus_3" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_3" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             频道
        </div>
    </div>
    <%--专题--%>
    <div style="background:url('images/portal/icons/zhuanti.png'); position:absolute; width:100px; height:100px; left:650px; top:48px; ">
	    <div id="bottom_menu_focus_4" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_4" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             专题
        </div>
    </div>
    <%--应用--%>
    <div style="background:url('images/portal/icons/application.png'); position:absolute; width:100px; height:100px; left:767px; top:50px; ">
	    <div id="bottom_menu_focus_5" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_5" style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             应用
        </div>
    </div>
    <%--社区--%>
    <div style="background:url('images/portal/icons/community.png'); position:absolute; width:100px; height:100px; left:875px; top:70px; ">
	    <div id="bottom_menu_focus_6" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_6"  style=" position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             社区
        </div>
    </div>
    <%--生活--%>
    <div style="background:url('images/portal/icons/shenghuo.png'); position:absolute; width:100px; height:100px; left:987px; top:80px; ">
	    <div id="bottom_menu_focus_7" style="position:absolute; width:116px; height:116px; left:-8px; top:-6px; visibility:hidden; ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
        <div id="bottom_menu_text_7" style="position:absolute; width:116px; height:30px; left:-8px; top:105px; color:#ffffff;">
             生活
        </div>
    </div>
</div>

<%--海报--%>
<div  style="position:absolute; width:202px; height:44px; left:47px; top: 92px;">
    <epg:FirstPage left="0" top="0" width="205" height="48" location="portalTop"/>
</div>
 <script language="javascript" type="">
     showBottomMenuTimer();
 </script>

<%@ include file="inc/lastfocus.jsp" %>
</body>
</html>