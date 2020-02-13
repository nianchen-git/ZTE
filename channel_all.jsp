<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.*" %>
<%@ include file="inc/getFitString.jsp" %>
<%
   String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = com.zte.iptv.epg.util.PortalUtils.getParams(path, "GBK");
    String columnid = String.valueOf(param.get("column00"));
    String menuIndex = "0";
    String lastfocus = request.getParameter("lastfocus");
    String[] sdestpage = {"1","1","1","1","1","1"};
    String curIndex = "0";
    String proIndex = "0";
    String[] lastfocusArr = null;
    if (lastfocus != null) {
        lastfocusArr = lastfocus.split("_");
        if(lastfocusArr.length == 3){
        menuIndex = lastfocusArr[0];
        curIndex = lastfocusArr[1];
        proIndex = lastfocusArr[2];
        for(int i=2;i<lastfocusArr.length;i++){
          // sdestpage[i-2]= lastfocusArr[i];
          }
        }
    }
%>
<html>
<head>
    <%
        String isnewopen = request.getParameter("isnewopen");
//        System.out.println("SSSSSSSSSSSSSSSSSSSSisnewopen="+isnewopen);
        if((isnewopen!=null && isnewopen.equals("1")) || (isnewopen!=null && isnewopen.equals("2"))){
            System.out.println("SSSSSSSSSSSSSSSSSSSSSSmeiyouyazhan!!!!");
    %>

    <%
        }else{
    %>
    <epg:PageController name="channel_all.jsp"/>
    <%
        }
    %>

    <title>channel_all</title>
    <style type="text/css">
        .body_bg
         {
            margin: 0px;
            padding: 0px;
            background-color:transparent;
            background-image: url(images/vod/btv_bg.png);
            background-repeat: no-repeat;
			line-height:24px;
        }
	
	    .channel_size{
	     font-size:24px;
	    }
    </style>
    <%
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


    <meta name="page-view-size" content="1280*720">
<script type="text/javascript">
    <%--var curindex =<%=curIndex%>;--%>
    var curindex =0;
    <%--var ctopindex =<%=menuIndex%>;--%>
    var ctopindex =0;
    var tempmenuIndex = <%=menuIndex%>;
    var tempcurIndex = <%=curIndex%>;
    var tempproIndex = <%=proIndex%>;
    var channelcolumnid ="<%=columnid%>";
    var topLeng;
    var curLeng;
    var $$ = {};
    var channelOutTime;
    var tvDs0;
    var tvDs1;
    var tvDs2;
    var tvDs3;
    var tvDs4;
    var tvDs5;
    var tvDs;
    var curchannelid;
    var curMaxNo;
    var curcolumnid;
    var curchannelName;
    var tvInfoL = [{leng:"0"},{leng:"0"},{leng:"0"},{leng:"0"},{leng:"0"},{leng:"0"}];
    var despageL= [{page:<%=sdestpage[0]%>},{page:<%=sdestpage[1]%>},{page:<%=sdestpage[2]%>},{page:<%=sdestpage[3]%>},{page:<%=sdestpage[4]%>},{page:<%=sdestpage[5]%>}];
    var pagecountL = [{count:"0"},{count:"0"},{count:"0"},{count:"0"},{count:"0"},{count:"0"}];
    var totalcountL = [{count:"0"},{count:"0"},{count:"0"},{count:"0"},{count:"0"},{count:"0"}];
    var proIndexL = [{count:0},{count:0},{count:0},{count:0},{count:0},{count:0}];
    var proLeng=6;
    var proIndex=0;
    var isFirsts=0;
    var times = 1;
    var _window = window;

    if(window.opener){
        _window = window.opener;
    }


    function $(id) {
        if (!$$[id]) {
            $$[id] = document.getElementById(id);
        }
        return $$[id];
    }
    //     var columnDs = [{columnid:"0F04",columnname:"卫视"},{columnid:"0F04",columnname:"卫视1"},{columnid:"0F04",columnname:"卫视2"}];
    var columnDs = [];
    //    var intiByIndex = function() {
    //          topLeng = columnDs.length;
    //          for(var i=0;i<columnDs.length;i++) {
    //         $("topN" + i).innerText = columnDs[i].columnname;
    //         $("topB" + i).style.visibility = "visible";
    //          getInfo(i,1);
    //        }
    //    document.onkeypress = tvKeyPress;
    //    window.setTimeout("isFrist()",1000);
    //    }
    function isFrist(){
        if (tvInfoL[ctopindex].leng > 0) {
            isFirsts = 1;
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
            showPorgramInfo();
            $("topB" + ctopindex).style.visibility = "hidden";
            $("topF" + ctopindex).style.visibility = "visible";
        } else if (times == topLeng) {
            isFirsts = 1;
            $("topB" + ctopindex).style.visibility = "hidden";
            $("topF" + ctopindex).style.visibility = "visible";
        } else {
            ctopindex++;
            if (ctopindex == topLeng) {
                ctopindex = 0;
            }
        }
        times++;

    }
    var gotoAction = function() {
        var requestUrl = "action/channel_all_column_data.jsp?columnid="+channelcolumnid;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgram);
    }
    //加载栏目
    function channelProgram() {
//        var cpages = parseInt(despageL[ctopindex]);
        document.onkeypress = tvKeyPress;
        var results = this.req.responseText;
        var cDs = eval("(" + results + ")");
        columnDs = cDs.columnData;
        topLeng = cDs.columnCount;
        if(topLeng>6){
            topLeng = 6;
        }
        if (topLeng > 0) {
            for (var i = 0; i < topLeng; i++) {
                //$("topN" +i).innerText = columnDs[i].columnname;
                $("topN" +i).innerText = writeFitStringNirui(columnDs[i].columnname,123, 22,13 ,11);
                $("topB" + i).style.visibility = "visible";
                var tempProIndex = 0;
                if(tempmenuIndex == i){
                    tempProIndex = tempproIndex;
                }else{
                    tempProIndex = 0;
                }
//                alert("SSSSSSSSSSSSSSSSSSSSStempProIndex="+tempProIndex);
                window.setTimeout("getInfo("+i+","+despageL[i].page+","+tempProIndex+")",200);
            }
        }
    }
    //加载单个栏目下的节目
    var channelProgramOnlyOne = function() {
        var results = this.req.responseText;
        var cDs = eval("(" + results + ")");
        var curIndex=cDs.curIndex;
        despageL[curIndex].page = cDs.destpage;
        pagecountL[curIndex].count = cDs.pageCount;
        totalcountL[curIndex].count = cDs.totalcountL;
        tvDs = cDs.tvprogramdata;
//        alert("SSSSSSSSSSSSSSSSSSlength="+tvDs.length);
        tvInfoL[curIndex].leng=tvDs.length;
        tvInfoL[curIndex].dataArr = tvDs;
 if (tvDs.length > 0) {
            getFocus(false);
            if( cDs.totalcountL>parseInt(tvDs.length)+parseInt(proIndexL[curIndex].count)){
                $("down" + curIndex).style.visibility = "visible";
            }
            if(tvDs.length<proLeng+1){
                $("down" + curIndex).style.visibility = "hidden";
            }

            var tempProgramName = null;
            for (var i = 0; i < tvDs.length; i++) {
                var maxn = tvDs[i].MixNo;
                if (maxn.length == 1) {
                    maxn = "00" + maxn;
                } else if (maxn.length == 2) {
                    maxn = "0" + maxn;
                }
                tempProgramName = writeFitStringNirui(tvDs[i].programName,123, 22,13 ,11);
                $("max" + curIndex + i).innerText = maxn+" "+tempProgramName;
                if(tempProgramName != tvDs[i].programName){
                    tvDs[i].hasBreak = 1;
                    tvDs[i].MixNo = maxn;
                    tvDs[i].hasBreakName = maxn+" "+tempProgramName;
                }
            }
//            alert("SSSSSSSSSSSSSSSSSSSSSbianlishuju_zhixingwancheng!!!!");
        }
        switch (curIndex) {
            case "0" :tvDs0=tvDs;break;
            case "1" :tvDs1=tvDs;break;
            case "2" :tvDs2=tvDs;break;
            case "3" :tvDs3=tvDs;break;
            case "4" :tvDs4=tvDs;break;
            default :tvDs5=tvDs;break;
        }
        if(isFirsts==0){
            isFrist();
        }
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSSfanyeleme!!!!!!");
        getFocus(true);
        goBytimes();
    }

    //加载单个栏目下的节目
    var channelProgramOnlyOne1 = function() {
        var results = this.req.responseText;
        var cDs = eval("(" + results + ")");
        var curIndex=cDs.curIndex;
        despageL[curIndex].page = cDs.destpage;
        pagecountL[curIndex].count = cDs.pageCount;
        totalcountL[curIndex].count = cDs.totalcountL;
        tvDs = cDs.tvprogramdata;
//        alert("SSSSSSSSSSSSSSSSSSlength="+tvDs.length);
//        alert("SSSSSSSSSSSSSSSSSSlength="+tvDs.length);
        tvInfoL[curIndex].leng=tvDs.length;
        tvInfoL[curIndex].dataArr = tvDs;
//        alert("SSSSSSSSSSSSSSSSSSSproIndexL111[curIndex].count="+proIndexL[curIndex].count);

        proIndexL[curIndex].count = tempproIndex;
        if(tempproIndex>0){
            $("up" + curIndex).style.visibility = "visible";
        }
        if (tvDs.length > 0) {
            getFocus(false);
            if( cDs.totalcountL>parseInt(tvDs.length)+parseInt(proIndexL[curIndex].count)){
                $("down" + curIndex).style.visibility = "visible";
            }
            if(tvDs.length<proLeng+1){
                $("down" + curIndex).style.visibility = "hidden";
            }

            var tempProgramName = null;
            for (var i = 0; i < tvDs.length; i++) {
                var maxn = tvDs[i].MixNo;
                if (maxn.length == 1) {
                    maxn = "00" + maxn;
                } else if (maxn.length == 2) {
                    maxn = "0" + maxn;
                }
                tempProgramName = writeFitStringNirui(tvDs[i].programName,123, 22,13 ,11);
                $("max" + curIndex + i).innerText = maxn+" "+tempProgramName;
                if(tempProgramName != tvDs[i].programName){
                    tvDs[i].hasBreak = 1;
                    tvDs[i].MixNo = maxn;
                    tvDs[i].hasBreakName = maxn+" "+tempProgramName;
                }
            }
//            alert("SSSSSSSSSSSSSSSSSSSSSbianlishuju_zhixingwancheng!!!!");
        }
        switch (curIndex) {
            case "0" :tvDs0=tvDs;break;
            case "1" :tvDs1=tvDs;break;
            case "2" :tvDs2=tvDs;break;
            case "3" :tvDs3=tvDs;break;
            case "4" :tvDs4=tvDs;break;
            default :tvDs5=tvDs;break;
        }
        if(isFirsts==0){
            isFrist();
        }
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSSfanyeleme!!!!!!");
        getFocus(true);
        goBytimes();
    }

    function tvKeyPress(evt) {
        var keyCode = parseInt(evt.which);
//        debug("SSSSSSSSSSSSSSSSSSSSkeyCode="+keyCode);
        if (keyCode == 0x0008 || keyCode == 24) {///back
//            window.opener.top.mainWin.document.location = "back.jsp";
            _window.top.mainWin.document.location = "back.jsp";
        } else if (keyCode ==0x0028) {  //page down
            goDown();
        } else if (keyCode ==0x0026) { //page up
            goUp();
        } else if (keyCode ==0x0025) {
            goLeft();
        } else if (keyCode == 0x0022) {
            pageDowns();
        } else if (keyCode == 0x0021) {
            pageUps();
        }else if (keyCode == 0x0027) {
            goRight();
        }else if (keyCode == 0x0113) {
            doRed();
        }else if (keyCode ==0x000D) {
            doOK();
        }else if (keyCode ==278) {
            closeMessage();
//          window.opener.top.mainWin.document.location = "vod_search.jsp";
            _window.top.mainWin.document.location = "vod_search.jsp";
        }else {
            closeMessage();
//          window.opener.top.mainWin.commonKeyPress(evt);
            _window.top.mainWin.commonKeyPress(evt);
            return true;
        }
        return false;
    }

    function commonKeyPress(evt){
        var keycode = evt.which;
        if(keycode==0x0101){
            _window.top.remoteChannelPlus();
        }else if(keycode==0x0102){
            _window.top.remoteChannelMinus();
        }else if(keycode == 0x0110 ){
          /*  if("CTCSetConfig" in Authentication)
            {
         //       alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
         //       alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            _window.top.mainWin.document.location = "portal.jsp";
        }else if(keycode == 36){
            _window.top.mainWin.document.location = "portal.jsp";
        }else if (keycode == 0x0008 || keycode == 24){
            _window.top.mainWin.document.location = "back.jsp";
        }else{
            _window.top.doKeyPress(evt);
        }
    }

    //ok
    var pageUps =function(){
        if(tvInfoL[ctopindex].leng>0){
//            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            getFocus(false);
            pageUp();
            curindex=0;
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
        }
    }
    var pageDowns=function(){
//        alert("SSSSSSSSSSSSSSSSSSSSSSSpageDowns!!!!");
        if(tvInfoL[ctopindex].leng>0){
//            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            getFocus(false);
            pageDown();
            curindex=0;
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
        }
    }
    function doOK(){
        if(tvInfoL[ctopindex].leng>0){
            changeDs();
            var saveInfo=ctopindex+"_"+curindex+"_"+proIndexL[ctopindex].count;
            //var pageInfo="";
            //for(var a=0;a<topLeng;a++){
            //    pageInfo=pageInfo+"_"+despageL[a].page;
            //}
           // saveInfo=saveInfo+pageInfo;
          //window.opener.top.mainWin.document.location = "channel_play.jsp?mixno=" + curMaxNo + "&leefocus=" + saveInfo;
         //alert("======play====mixno=" + curMaxNo);
            _window.top.mainWin.document.location = "channel_play.jsp?mixno=" + curMaxNo + "&leefocus=" + saveInfo;
        }
    }
    //red
    var doRed = function() {
        if(tvInfoL[ctopindex].leng>0){
            changeDs();
            var requestUrl = "action/channel_favorite_add.jsp?SubjectID=" + curcolumnid + "&ContentID=" + curMaxNo + "&FavoriteTitle=" + encodeURI(encodeURI(curchannelName)) + "&channelid=" + curchannelid;
            var loaderSearch = new net.ContentLoader(requestUrl, showMsg);
        }
    }
    //收藏上限
    function cancelKeyOK() {
//        alert("SSSSSSSSSSSSSSSfavIndex="+favIndex);
//        if ($("fav_0").src == "images/vod/btv-btn-cancelclick.png") {
        if (favIndex == 0) {
            //进入TV收藏
            closeMessage();
            document.onkeypress=tvKeyPress;
//                window.opener.top.mainWin.document.location = "favorite_portal.jsp";
            if(isZTEBW == true){
                _window.top.mainWin.document.location = "vod_favorite_pre.jsp";
            }else{
                _window.top.mainWin.document.location = "vod_favorite.jsp";
            }
        } else {
            $("fav_0").src = "images/vod/btv-btn-cancel.png";
            $("fav_1").src = "images/vod/btv-btn-cancel.png";
            closeMessage();
            document.onkeypress = tvKeyPress;
        }
    }

    function closeMessage() {
        $("text").innerText = "";
        $("favMax").style.visibility="hidden";
        $("msg").style.visibility = "hidden";
        $("closeMsg").style.visibility = "hidden";
    }

    function pageDown() {
//        alert("SSSSSSSSSSSSSSSSSSSSSSSpageDown!!!!");
        var cpages = parseInt(despageL[ctopindex].page) + 1;
        if (cpages <= pagecountL[ctopindex].count) {
//            alert("SSSSSSSSSSSSSSSSSSSSSSSpageDown111111!!!!");
            $("up" + ctopindex).style.visibility = "visible";
            despageL[ctopindex].page = cpages;
            clearTvInfo();
            getInfo(ctopindex,cpages);
            //proIndexL[ctopindex].count=proLeng*(cpages-1)+1;
            proIndexL[ctopindex].count=(proLeng+1)*(cpages-1);
//            alert('SSSSSSSSproIndexL[ctopindex].count='+proIndexL[ctopindex].count);
        }
        if(cpages == pagecountL[ctopindex].count){
            $("down" + ctopindex).style.visibility = "hidden";
        }
    }
    function pageUp() {
        var cpages = parseInt(despageL[ctopindex].page) - 1;
        if(cpages == 0){
            cpages =1;
        }
        if (cpages >= 1) {
            $("down" + ctopindex).style.visibility = "visible";
            despageL[ctopindex].page = cpages;
            clearTvInfo();
            getInfo(ctopindex,cpages);
            //proIndexL[ctopindex].count=proLeng*(cpages-1)+1;
            proIndexL[ctopindex].count=(proLeng+1)*(cpages-1);
        }
        if(cpages==1){
            proIndexL[ctopindex].count=0;
            $("up" + ctopindex).style.visibility = "hidden";
        }
    }
    //全局变量转换
    function changeDs(){
        switch (ctopindex) {
            case 0 :tvDs=tvDs0;break;
            case 1 :tvDs=tvDs1;break;
            case 2 :tvDs=tvDs2;break;
            case 3 :tvDs=tvDs3;break;
            case 4 :tvDs=tvDs4;break;
            default:tvDs=tvDs5;break;
        }
        curchannelid=tvDs[curindex].channelId;
        curcolumnid=columnDs[ctopindex].columnid;
        curMaxNo=tvDs[curindex].MixNo;
        curchannelName=tvDs[curindex].programName;
    }
    var showPorgramInfo = function() {
        changeDs();
        var requestUrl = "action/channel_programD.jsp?channelid=" + curchannelid + "&columnid=" + curcolumnid + "&maxno=" + curMaxNo;
        var loaderSearch = new net.ContentLoader(requestUrl, showchannelProgram);
    }
    function showchannelProgram() {
        clearProdiv();
        var results = this.req.responseText;
        var catedata = eval("(" + results + ")");
        $("pdiv").style.visibility = "visible";
        var maxn = curMaxNo;
        if (maxn.length == 1) {
            maxn = "00" + maxn;
        } else if (maxn.length == 2) {
            maxn = "0" + maxn;
        }
        $("ids").innerHTML = maxn + "&nbsp;&nbsp;&nbsp;" + curchannelName.substr(0, 40);
        if(catedata.HasCurProgram == "0"){
            $("currentProgramb").style.border = "none";
        }else{
            $("currentProgramb").style.border = "2px solid red";
        }
        $("currentProgram").innerHTML = "<br>" + catedata.curprogram;
        $("nextProgram").innerHTML = "<br>" + catedata.nextprogram;
        $("thirdProgram").innerHTML = "<br>" + catedata.thirdprogram;
    }

    var clearProdiv = function() {
        $("ids").innerHTML = "";
        $("currentProgram").innerHTML = "";
        $("pdiv").style.visibility = "hidden";
        $("nextProgram").innerHTML = "";
        $("thirdProgram").innerHTML = "";
    }
    //    获取单个栏目下的信息
    var getInfo=function(id,pages,proIndex){
if(!proIndex){
            proIndex = 0;
        }
       // var requestUrl = "action/channel_all_program_data.jsp?columnid=" + columnDs[id].columnid + "&destpage=" + pages+"&curIndex="+id;
 var requestUrl = "action/channel_all_program_data.jsp?columnid=" + columnDs[id].columnid + "&destpage=" + pages+"&curIndex="+id+"&UpDown=1&proIndex="+proIndex;
        if(proIndex>0){
            var loaderSearch = new net.ContentLoader(requestUrl, channelProgramOnlyOne1);
        }else{
            var loaderSearch = new net.ContentLoader(requestUrl, channelProgramOnlyOne);
        }
    }
    var clearTvInfo=function(){
        for(var i=0;i<7;i++){
            $("max" + ctopindex + i).innerText = " ";
//          $("pname" + ctopindex + i).innerText = " ";
        }
    }
    //    延迟加载节目信息
    function goBytimes(){
        if (channelOutTime) {
            window.clearTimeout(channelOutTime);
        }
        channelOutTime = window.setTimeout("showPorgramInfo()", 1000);
    }
    function goDown() {
//        debug("+++++++++++++++++++++++++++++++goDown++++++++++++++++++++");
        if(tvInfoL[ctopindex].leng>0){
//            debug("+++++++++++++++++++++++++++++++goDown1111111++++++++++++++++++++");
            curLeng=tvInfoL[ctopindex].leng;
//            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            getFocus(false);
            curindex++;
//            alert("curindexcurindexcurindexcurindex"+curindex);
//            alert("curindex+proIndexL[ctopindex].count"+proIndexL[ctopindex].count);
//            alert("totalcountL[ctopindex].count"+totalcountL[ctopindex].count);
//            alert(typeof proIndexL[ctopindex].count == 'number');
            //if (curindex >= curLeng&&curLeng>0&&totalcountL[ctopindex].count>parseInt(curindex)+parseInt(proIndexL[ctopindex].count)) {
			
            if (curindex >= curLeng&&curLeng>0&&totalcountL[ctopindex].count>=curindex+proIndexL[ctopindex].count+1) {
//                debug('+++++++++++++++++++++++++============yao fen ye');
                proIndex=proIndexL[ctopindex].count;
                proIndex++;
                proIndexL[ctopindex].count=proIndex;
                curindex = curLeng-1;
                pageUpDown();
                $("up" + ctopindex).style.visibility = "visible";
            }

            //if(totalcountL[ctopindex].count==parseInt(curindex)+parseInt(proIndexL[ctopindex].count)+1){
            if(totalcountL[ctopindex].count==curindex+proIndexL[ctopindex].count+1){
                despageL[ctopindex].page=pagecountL[ctopindex].count;
                $("down" + ctopindex).style.visibility = "hidden";
                proIndex=0;
            }
            if( curindex>=curLeng){
                curindex= curLeng-1;
            }
//            if(curLeng>0){
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
            goBytimes();
//            }
        }
    }
    function pageUpDown(){
        var requestUrl = "action/channel_all_program_data.jsp?columnid=" + columnDs[ctopindex].columnid + "&destpage=" + despageL[ctopindex].page+"&curIndex="+ctopindex+"&UpDown=1&proIndex="+proIndexL[ctopindex].count;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgramOnlyOne);
    }

    var tempChannelName = null;

    function getFocus(flag){
    //    alert("SSSSSSSSSSSSSSSSSSSSSS11getFocus_"+flag);
      try{
//        alert("SSSSSSStvInfoL[ctopindex].dataArr[curindex].hasBreak="+tvInfoL[ctopindex].dataArr[curindex].hasBreak);
        if(flag == true){

            if(tvInfoL[ctopindex].dataArr[curindex].hasBreak == 1){
//                alert("SSSSSSSSSSSSSSSSSSZABUGUDONG");
                tempChannelName = $("max" + ctopindex + curindex).innerHTML;
//                alert("SSSSSSSSSSSSSSSSSSgundongChannelName="+tempChannelName);
                $("max" + ctopindex + curindex).innerHTML ="<marquee version='3' scrolldelay='250' width='155' class='channel_size'>" +tvInfoL[ctopindex].dataArr[curindex].MixNo+" "+tvInfoL[ctopindex].dataArr[curindex].programName+ "</marquee>" ;
//                alert("SSSSSSSSSSSSSSSSSSZABUGUDONG="+$("max" + ctopindex + curindex).innerHTML);
            }
            $("tv" + ctopindex + curindex).style.visibility = "visible";
        }else{

            if(tvInfoL[ctopindex].dataArr[curindex].hasBreak == 1){
                if(tvInfoL[ctopindex].dataArr[curindex].hasBreakName){
                    $("max" + ctopindex + curindex).innerHTML = tvInfoL[ctopindex].dataArr[curindex].hasBreakName;
                }else{
                    $("max" + ctopindex + curindex).innerHTML = tempChannelName;
                }
//                alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSbubugundongChannelName="+$("max" + ctopindex + curindex).innerHTML);
            }
            $("tv" + ctopindex + curindex).style.visibility = "hidden";
        }
      }catch(e){
        //  alert("SSSSSSSSgetFocus_error="+e);
      }
    }

    function goUp() {
        curLeng = tvInfoL[ctopindex].leng;
        if (curLeng > 0) {
//            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            getFocus(false);
            curindex--;
//            alert('+++++++++++++++++++++++goUp++++++++++++++++');
//            alert(typeof proIndexL[ctopindex].count == 'number');
            if (curindex < 0 && curLeng > 0 && proIndexL[ctopindex].count > 0) {
                proIndex = proIndexL[ctopindex].count;
                proIndex--;
                proIndexL[ctopindex].count = proIndex;
                if(proIndex==0){
                   if(parseInt(despageL[ctopindex].page)>1){
                      despageL[ctopindex].page = 1;
                   }
                }
                if (curLeng > proLeng) {
                    $("down" + ctopindex).style.visibility = "visible";
                }
                pageUpDown();
                curindex = 0;
            }
            if (proIndexL[ctopindex].count == 0) {
                $("up" + ctopindex).style.visibility = "hidden";
                despageL[ctopindex].page = 1;
            }
            if ( curindex < 0) {
                curindex = 0;
            }
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
            goBytimes();
//            }
        }
    }
    function goLeft() {
//        $("tv" + ctopindex + curindex).style.visibility = "hidden";
        getFocus(false);
        $("topF" + ctopindex).style.visibility = "hidden";
        $("topB" + ctopindex).style.visibility = "visible";
        ctopindex--;
        if (ctopindex < 0) {
            ctopindex = topLeng - 1;
        }
        $("topB" + ctopindex).style.visibility = "hidden";
        $("topF" + ctopindex).style.visibility = "visible";
        curLeng=tvInfoL[ctopindex].leng;
        if(curindex>curLeng-1){
            curindex=0;
        }

        if(tvInfoL[ctopindex].leng>0){
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
            goBytimes();
        }
        proIndex=0;
    }
    function goRight() {
//        $("tv" + ctopindex + curindex).style.visibility = "hidden";
        getFocus(false);
        $("topF" + ctopindex).style.visibility = "hidden";
        $("topB" + ctopindex).style.visibility = "visible";
        ctopindex++;
        if (ctopindex >= topLeng) {
            ctopindex = 0;
        }
        $("topF" + ctopindex).style.visibility = "visible";
        $("topB" + ctopindex).style.visibility = "hidden";
        curLeng=tvInfoL[ctopindex].leng;
        if(curindex>curLeng-1){
            curindex=0;
        }
        if(tvInfoL[ctopindex].leng>0){
//            $("tv" + ctopindex + curindex).style.visibility = "visible";
            getFocus(true);
            goBytimes();
        }
        proIndex=0;
    }
 function initFocus(){
        goBytimes();
    }
 </script>
</head>
<body bgcolor="transparent" class="body_bg">
<!--顶部信息-->
<%@ include file="inc/time.jsp" %>
<%--<div style="position:absolute; width:33; height:36; left:39px; top:20px;">--%>
    <%--<img src="images/channel/channel-ico.png" border="0" alt="">--%>
<%--</div>--%>

<%--<div id="path" style="position:absolute; width:760px; height:51px; left:90px; top:22px;font-size:24px;color:#FFFFFF">--%>
    <%--频道> 频道导航--%>
<%--</div>--%>
<div class="topImg" style="top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/channel/channel-ico.png'); left:13; top:8px; width:33px; height:35px; position:absolute; ">
    </div>
    <div align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
          直播 > 导航列表
    </div>
</div>

 <%
     for(int i=0;i<5;i++){
      int lefttop = 80 + i * 226;
%>
<div id="topF<%=i%>" style="position:absolute;left:<%=lefttop%>;top:90;width:216;height:52;visibility:hidden">
    <img src="images/channel/btv_channel_bar.png" width="216" height="52" alt=""/>
   </div>
<div id="topB<%=i%>" style="position:absolute;left:<%=lefttop%>;top:90;width:216;height:52;visibility:hidden">
    <img src="images/channel/channel_top_bg.png" alt="" width="216" height="52" />
   </div>
<div id="topN<%=i%>"  style="font-size:24px; color:#ffffff; position:absolute;left:<%=lefttop%>;top:100;width:216;height:35;" align="center">

    </div>
  <div id="up<%=i%>" style="position:absolute;left:<%=lefttop+95%>;top:150;width:25;height:14;visibility:hidden">
    <img src="images/vod/btv_up.png" width="25" height="14" alt=""/>
   </div>
 <div id="down<%=i%>" style="position:absolute;left:<%=lefttop+95%>;top:515;width:25;height:14;visibility:hidden">
    <img src="images/vod/btv_down.png" width="25" height="14" alt=""/>
   </div>
   <%
 }
   %>
<%
 for(int j=0;j<35;j++){
     int lefts=  80 + j/7* 226;
     int tops = 166 + j%7 * 50;
     String index=j/7+""+j%7;

%>
<%--<div  style="position:absolute;left:<%=lefts%>;top:<%=tops %>;width:180;height:45; ">--%>
    <div id="tv<%=index%>"   style="position:absolute; left:<%=lefts%>;top:<%=tops %>; width:216;height:45;visibility:hidden ">
        <img src="images/tvod/btv-replay-focus.png" width="216" height="40" alt=""/>
    </div>
<%--</div>--%>

<div id="max<%=index%>"  style=" position:absolute; font-size:22px;color:#ffffff;left:<%=lefts+7%>;top:<%=tops+8 %>;width:174;height:35; "
     align="left">
</div>
<%}%>
<%--节目详细--%>
<div id="pdiv" style=" position:absolute;visibility:hidden;font-size:22px;color:#ffffff;top:515px; width:1280px; left:0px; height:100px;">
    <div style=" left:0px;top:25px;width:1280;height:100;position:absolute; ">
        <img src="images/liveTV/channel_programinfo.png" alt="" width="1280" height="100"/>
       </div>
    <div id="currentProgramb" style="left:51;top:63;height:48;width:321;position:absolute; border:0px solid white;">
        <img name="bottom_bg" src="images/channel/channel_bottom_focus.png" width="321"  height="52" alt=""/>
    </div>
    <div style="left:371;top:64;height:48;width:321;position:absolute; border:1px solid white;  ">
        <%--<img name="bottom_bg" src="images/channel/channel_bottom_blur.png" height="51" alt=""/>--%>
    </div>
    <div style="left:691;top:64;height:48;width:321;position:absolute; border-right:1px solid white; border-top:1px solid white; border-bottom:1px solid white; ">
        <%--<img name="bottom_bg" src="images/channel/channel_bottom_blur.png" height="51" alt=""/>--%>
    </div>
    <div id="ids"
         style="font-size:24px;left:51;top:35;height:10;width:1000;position:absolute;">
    </div>

    <div id="currentProgram"
         style=" padding-left:10px;left:51;top:40;height:50;width:320;position:absolute;">
    </div>
    <div id="nextProgram"
         style="padding-left:10px;left:372;top:40;height:50;width:320;position:absolute;">
    </div>
    <div id="thirdProgram"
         style="padding-left:10px;left:693;top:40;height:50;width:320;position:absolute;">
    </div>
    <div  style="left:1020;top:60;height:68;width:174;position:absolute;">
        <%--<epg:FirstPage width="203" height="51" location="guanggao04"/>--%>
            <img src="images/guanggao1.png" alt="" border="0" width="174" height="58" />
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
    gotoAction();
  <%
      if(!menuIndex.equals("0") || !curIndex.equals("0")){
    %>
        window.setTimeout(function(){
//            return;
            getFocus(false);
            $("topF" + ctopindex).style.visibility = "hidden";
            $("topB" + ctopindex).style.visibility = "visible";
            curindex =<%=curIndex%>;
            ctopindex =<%=menuIndex%>;
            $("topF" + ctopindex).style.visibility = "visible";
            $("topB" + ctopindex).style.visibility = "hidden";
            getFocus(true);
            goBytimes();
        },2000);
    <%
      }
    %>
</script>
<%@ include file="favorite_msg.jsp" %>
<%--<%@ include file="inc/goback.jsp" %>--%>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
</html>