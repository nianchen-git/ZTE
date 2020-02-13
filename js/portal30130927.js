//Authentication.CTCSetConfig('SetEpgMode', '720P');
var $$ = {};

function $(id) {
    if (!$$[id]) {
        $$[id] = document.getElementById(id);
    }
    return $$[id];
}
var bottomMenuCount = 8;
var leftMenuCount = 7;
var upAction = false;
var downAction = false;
var pagecount = 1;
var columnArr = [];
var length = 7;
var bottomMenuTimer;
var channelType = "column";
var curcolumnid;
var columnIndex = -1;
var cIndex = -1;
var isFirstCome = true;
var moveRight = false;
var tempArr=new Array();
var totalCount=0;
var tempStartindex=0;
var tempEndindex=0;
//var leftFocusPosition = ['196','308','420','534','642','759','867','979'];
//var topFocusPosition = ['59','44','34','26','26','34','44','62'];
var topFocusPosition = [80,57,37,24,27,37,55,87];

//alert("SSSSSSSSSSSSSSSSSSSStop.columnid_tv="+top.columnid_tv);
//alert("SSSSSSSSSSSSSSSSSSSStop.channelid_tv="+top.channelid_tv);
var specalpagecount = parseInt((specallength-1)/leftMenuCount+1);
//alert("SSSSSSSSSSSSSSSSSSSSspecalpagecount="+specalpagecount);

function doKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0025) {
        goLeft();
    } else if (keycode == 0x0027) {
        goRight();
    } else if (keycode == 0x000D) {
        if(hasGetData==1){
            goOk();
        }
    } else if (keycode == 0x0026) {
        goUp();
    } else if (keycode == 0x0028) {
        if(hasGetData==1){
            goDown();
        }
    }else if(keycode == 0x0110 || keycode == 36){ //36为联通的首页键值
//        alert("SSSSSSSSSSSSSSSSSSSPORTAL!!!!");
        if(keycode == 0x0110){
            //Authentication.CTCSetConfig("KeyValue","0x110");
            if("CTCSetConfig" in Authentication)
            {
                //alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
                //alert("SSSSSSSSSSSSSSSSSSSSSSSSchannel_start_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }
        }
//        top.jsHideOSD();
    } else if (keycode == 0x0008 || keycode == 24) {
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSBACK");
        //top.jsHideOSD();
        if (bottomMenuIndex == 3 && channelType == 'channel') {
            columnIndex = cIndex;
            startIndex=tempStartindex;
            endIndex=tempEndindex;
            showBottomMenu();
        }else {
            top.jsHideOSD();
        }
    } else if (keycode == 0x0021) {
        pageUp();
    }else if (keycode ==0x0113 ) {       
        if (bottomMenuIndex >= 5 && hasGetData==1) {
            doRed();
        }
    }  else if (keycode == 0x0022) {
        pageDown();
    } else {
        commonKeyPress(evt);
    }
    return false;
}


var currentChannel = top.channelInfo.currentChannel;
if (currentChannel == -1) {
    currentChannel = "";
}


var isFavs=1;
var timer=-1;
var  doRed=function(){
//    alert("SSSSSSSSSSSSSSSSScolumnArr[leftMenuIndex].curl="+columnArr[leftMenuIndex].curl);
    if(columnArr[leftMenuIndex].invalid == 1){
       // alert("SSSSSSSSSSSSSSSSSSSshixiaole!@!!!");
        return;
    }
    if (columnArr[leftMenuIndex].curl.indexOf("http") ==0) {
        doFav(columnArr[leftMenuIndex]);
    }
}


function showMsg(flag) {
        dellflag = flag;
        if (dellflag == 0) {
            $("text").innerText = sus;
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else if (dellflag == 1) {
            $("text").innerText = alsus;
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        }
    }
    function closeMessage() {
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
        clearTimeout(timer);
    }


    var favArr = [];
    function isFav(url,cname) {
        var flag = 0;
        var str=ztebw.getAttribute(userid);
        if(str=="null" || str=="" || str=="undefined")return 0;
        favArr =eval("("+str+")");
        for(var i=0; i<favArr.length; i++){
           if(favArr[i].curl == url && favArr[i].cname == cname){
              return 1;
           }
        }
        return 0;
    }
    function doFav(arr) {
        if(isZTEBW == false){
            return ;
        }
        var flag = isFav(arr.curl,arr.cname);
        if (flag == 0) {
            favArr.push(arr);
            ztebw.setAttribute(userid, favArr.toJSONString());
        }
        showMsg(flag);
    }

var hasGetData = 1;

function showBottomMenuTimer() {
    $('bottom_menu_focus' + bottomMenuIndex).style.visibility = 'visible';
    $('bottom_menu_text_' + bottomMenuIndex).style.color = '#ff0000';
//    alert("SSSSSSSSSSSSSbottomMenuIndex_top="+bottomMenuIndex+"_"+$("buttom_" + bottomMenuIndex).style.top);
    $("buttom_" + bottomMenuIndex).style.top = (topFocusPosition[bottomMenuIndex]-15)+"px";
//    alert("SSSSSSSSSSSSSbottomMenuIndex_top="+bottomMenuIndex+"_"+$("buttom_" + bottomMenuIndex).style.top);
    if (bottomMenuTimer) {
        window.clearTimeout(bottomMenuTimer);
    }
    hasGetData = 0;
    bottomMenuTimer = window.setTimeout('showBottomMenu();', 400);
}


function showBottomMenu() {
    if (bottomMenuIndex == 0) {//
        hasGetData = 1;
        showMyTvColumn();
    } else if (bottomMenuIndex == 1) {//�
        showTvodChannel();
    } else if (bottomMenuIndex == 2) {//
        showVodColumn();
    } else if (bottomMenuIndex == 3) {//
        showChannelColumn();
    }else{
        loadSpecalColumn();
    }
}

function loadSpecalColumn(){
    hasGetData = 1;
    if(bottomMenuIndex == 4){
        totalCount=SpecalColumnlist.length;
    }else if(bottomMenuIndex == 5){
        totalCount=appArr.length;
    }else if(bottomMenuIndex == 6){
        totalCount=commarr.length;
    }else if(bottomMenuIndex == 7){
        totalCount=lifeArr.length;
    }
    if(endIndex>totalCount)endIndex=totalCount;
    showSpecalColumnlist();
}

function showSpecalColumnlist() {
    columnArr=new Array();
	var tempColumnname = null;
    for (var i = startIndex; i < endIndex; i++) {
        if(bottomMenuIndex == 4){
            columnArr.push(SpecalColumnlist[i]);
        }else if(bottomMenuIndex == 5){
            columnArr.push(appArr[i]);
        }else if(bottomMenuIndex == 6){
            columnArr.push(commarr[i]);
        }else if(bottomMenuIndex == 7){
            columnArr.push(lifeArr[i]);
        }
    }
    length = columnArr.length;

    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            
			 tempColumnname = writeFitStringNirui(columnArr[i].columnname,175,24,14.6,12);
            if(tempColumnname!=columnArr[i].columnname){
                columnArr[i].hasBreak = '1';
               
            }
		    $('left_menu_' + i).innerText = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
//            alert("SSSSSSSSSSSSSSScolumnArr[i].invalid="+columnArr[i].invalid);
            if(columnArr[i].invalid == '1'){
                $('left_menu_' + i).style.color = "gray";
            }else{
                $('left_menu_' + i).style.color = "white";
            }
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function showMyTvColumn() {
    if(startIndex ==0){
        endIndex = 7;
    }
    length = mytvArr.length;
    totalCount = length;
    if (isFirstCome) {
        isFirstCome = false;
    } else {
        leftMenuIndex = 0;
    }
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            $('left_menu_' + i).innerText = mytvArr[i].tvname;
            $('left_menu_' + i).style.visibility = 'visible';
//            alert("SSSSSSSSSSSSSS11111="+mytvArr[i].invalid);
            if(mytvArr[i].invalid == "true"){
//                alert("SSSSSSSSSSSSSS222222");
                $('left_menu_' + i).style.color = "gray";
            } else{
                $('left_menu_' + i).style.color = "white";
            }
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
    //少两个按钮
    length = length-2;
    totalCount = length;
}

function showTvodChannel() {
    var requestUrl = "action/allchannellistData.jsp?istvod=1&columnid=" + channelColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showtvodchannelsResponse);
}

function showtvodchannelsResponse() {
    hasGetData = 1;
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.channelData;
    var channelObj = {channelname:tvodchannelname,columnid:channelColumnid};
    tempArr.unshift(channelObj);
    if(startIndex ==0){
        endIndex = 7;
    }
    totalCount=tempArr.length;
    if(endIndex>totalCount){
        endIndex=totalCount;
    }
    showTvodList();
}
function showTvodList(){
    columnArr=new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            //$('left_menu_' + i).innerText = columnArr[i].channelname.substr(0, 8);
            var mixno = columnArr[i].mixno;
            if(mixno == undefined){
                mixno = "";
            }else if (mixno.length == 1) {
                mixno = "00" + mixno;
            } else if (mixno.length == 2) {
                mixno = "0" + mixno;
            }
//            alert("SSSSSSSSSSSSSSSSSmixno="+mixno);

            tempColumnname = writeFitStringNirui(columnArr[i].channelname,175,24,14.6,12);
            if(tempColumnname!=columnArr[i].channelname){
                columnArr[i].hasBreak = '1';
                columnArr[i].columnname = mixno + " "+columnArr[i].channelname;
            }
            $('left_menu_' + i).innerText = mixno + " " + tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function showVodColumn(destapage) {
    var requestUrl = "action/vod_columnlist_update.jsp?columnid=" + vodColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showvodcolumnlist);
}

function showChannelColumn() {
    var requestUrl = "action/zhuanti_columnlist.jsp?columnid=" + channelColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, loadChannelColumn);
}
function loadChannelColumn(){
    hasGetData = 1;
    channelType = "column";
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.columnData;
    var columnObj = {columnname:channelname1,columnid:channelColumnid};
    tempArr.unshift(columnObj);
    totalCount=tempArr.length;
    if(startIndex ==0){
        endIndex = 7;
    }
    if(endIndex>totalCount)endIndex=totalCount;
    showchannelcolumnlist();
}
var isFirstChannel = true;

function showchannelcolumnlist() {
    columnArr=new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    if (isFirstChannel) {
        isFirstChannel = false;
    }
//    if (isFirstCome) {
//        isFirstCome = false;
//    } else {
//        leftMenuIndex = 0;
//    }

    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            //$('left_menu_'+i).innerHTML = columnArr[i].columnname+"&nbsp;&nbsp;&nbsp;&nbsp;<img style='' width='30' height='19' src='images/liveTV/btv-channel-right.png'/>";
            //$('left_menu_' + i).innerHTML = columnArr[i].columnname; writeFitStringNirui(columnArr[i].columnname,205,24,14.6,12);
            tempColumnname = writeFitStringNirui(columnArr[i].columnname,205,24,14.6,12);
            if(tempColumnname!=columnArr[i].columnname){
                columnArr[i].hasBreak = '1';
            }
            $('left_menu_' + i).innerHTML = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    if (columnIndex != -1) {
        leftMenuIndex = columnIndex;
        columnIndex = -1;
    }


    showupdowicon();
    changeLeftMenuFocus();
}

function showupdowicon() {
   $("up").style.visibility=startIndex>0 ? "visible":"hidden";
   $("down").style.visibility=endIndex<totalCount ? "visible":"hidden";
}

function showvodcolumnlist() {
    hasGetData = 1;
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.columnData;
    totalCount=tempArr.length;
    if(startIndex ==0){
        endIndex = 7;
    }
    if(endIndex>totalCount)endIndex=totalCount;
    showVodList();
}
function showVodList(){
    columnArr=new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
//            alert("++++++columnArr[i].columnname="+columnArr[i].columnname);
            //$('left_menu_' + i).innerText = writeFitString(columnArr[i].columnname, 20, 180);
            tempColumnname = writeFitStringNirui(columnArr[i].columnname,205,24,14.6,12);
            if(tempColumnname!=columnArr[i].columnname){
                columnArr[i].hasBreak = '1';
            }
            $('left_menu_' + i).innerText = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function hiddenBottomMenuFocus() {
    $('bottom_menu_focus' + bottomMenuIndex).style.visibility = 'hidden';
    $('bottom_menu_text_' + bottomMenuIndex).style.color = '#ffffff';
}

var tempChannelName = null;
function changeLeftMenuFocus(flag) {
//    if (bottomMenuIndex == 4) { //专题
//        $('left_focus_img').style.top = 89 + 90 * leftMenuIndex + 'px';
//    } else {
//        $('left_focus_img').style.top = 89 + 51 * leftMenuIndex + 'px';
//    }
     if(flag == -1){
      //  alert("SSSSSSSSSSSSSSSSflag="+flag);
         if(bottomMenuIndex ==1 || bottomMenuIndex ==2 || bottomMenuIndex ==3 || bottomMenuIndex ==4){
             if(columnArr[leftMenuIndex].hasBreak == '1'){
                 $('left_menu_' + leftMenuIndex).innerHTML = tempChannelName;
             }
         }
     }else{
       // alert("SSSSSSSSSSSSSSSSflag=true");
         if(bottomMenuIndex ==1 || bottomMenuIndex ==2 || bottomMenuIndex ==3 || bottomMenuIndex ==4){
             if(columnArr[leftMenuIndex].hasBreak == '1'){
                 tempChannelName = $('left_menu_' + leftMenuIndex).innerHTML;
                 $('left_menu_' + leftMenuIndex).innerHTML = "<marquee version='3' scrolldelay='250' width='185'>" + columnArr[leftMenuIndex].columnname+ "</marquee>";;
             }
         }
     }
     $('left_focus_img').style.top = 89 + 51 * leftMenuIndex + 'px';
     $('left_focus_img').style.visibility="visible";
}

function goLeft() {
    startIndex=0;
    endIndex=7;
    totalCount=0;
    leftMenuIndex=0;
    hiddenBottomMenuFocus();
    $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex]+"px";
    bottomMenuIndex = (--bottomMenuIndex + bottomMenuCount) % 8;
    showBottomMenuTimer();
}

function goRight() {
    startIndex=0;
    endIndex=7;
    totalCount=0;
    leftMenuIndex=0;
    hiddenBottomMenuFocus();
    $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex]+"px";
    bottomMenuIndex = (++bottomMenuIndex + bottomMenuCount) % 8;
    showBottomMenuTimer();
}

function goOk() {
    if (bottomMenuIndex == 0) {//mytv
        if(mytvArr[leftMenuIndex].invalid == "true"){
          //  alert("SSSSSSSSSSSSSSSSzhihui!!!");
        }else{
            document.location = mytvArr[leftMenuIndex].tvurl;
        }
//        alert("SSSSSSSSSSSSSSSSSSSSnew");
//        window.location = mytvArr[leftMenuIndex].tvurl;
    } else if (bottomMenuIndex == 1) { //�ؿ�
        if (startIndex == 0 && leftMenuIndex == 0) {//�ؿ�
            top.mainWin.document.location = "channel_all_tvod.jsp?leefocus=1_0";
        } else { //�
            var columnid = columnArr[leftMenuIndex].columnid;
            var channelid = columnArr[leftMenuIndex].channelid;
            var mixno = columnArr[leftMenuIndex].mixno;
            if(isZTEBW == true){
                top.mainWin.document.location = "channel_onedetail_tvod_pre.jsp?columnid=" + columnid + "&channelid=" + channelid + "&mixno=" + mixno + "&leefocus=1_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
            }else{
                top.mainWin.document.location = "channel_onedetail_tvod.jsp?columnid=" + columnid + "&channelid=" + channelid + "&mixno=" + mixno + "&leefocus=1_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
            }
        }
    } else if (bottomMenuIndex == 2) { //�㲥
        var curColumnid = columnArr[leftMenuIndex].columnid;
        var columnname =  columnArr[leftMenuIndex].columnname;
        if(columnname.length>15){
            columnname = columnname.substr(0,15)+"...";
        }
        if(isZTEBW == true){
            top.mainWin.document.location = "vod_portal_pre.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex+"&columnname="+columnname;
        }else{
            top.mainWin.document.location = "vod_portal.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex+"&columnname="+columnname;
        }
        //top.mainWin.document.location = "vod_portal_pre.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
//        top.mainWin.document.location = "vod_portal.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
    } else if (bottomMenuIndex == 3) { //
        if (channelType == 'column') { //
            if (startIndex == 0 && leftMenuIndex==0) {//
                if(isZTEBW == true){
                    top.mainWin.document.location = "channel_all_pre.jsp?leefocus=3_0";
                }else{
                    top.mainWin.document.location = "channel_all.jsp?leefocus=3_0";
                }
//                top.mainWin.document.location = "channel_all_pre.jsp?leefocus=3_0";
//                top.mainWin.document.location = "channel_all.jsp?leefocus=3_0";
            } else {
                curcolumnid = columnArr[leftMenuIndex].columnid;
                tempStartindex=startIndex;
                tempEndindex=endIndex;
                cIndex = leftMenuIndex;
                showChannelListByColumnid();
            }
        } else if (channelType == 'channel') {
            var mixno = columnArr[leftMenuIndex].mixno;
            top.mainWin.document.location = "channel_play.jsp?mixno=" + mixno;
        }
    } else if(bottomMenuIndex == 4){  //专题跳转链接 ，唐红成添加
        var columnid = columnArr[leftMenuIndex].columnid;
        if (columnid == "0") { //链接为专题配置项
            url = columnArr[leftMenuIndex].columnposter;
            if (url.indexOf(".jsp?") >= 0 || url.indexOf(".html?") >= 0 || url.indexOf(".htm?") >= 0 || url.indexOf(".php?") >= 0) {
                url += "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            } else {
                url += "?leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            }
        } else if (leftMenuIndex == 0 || leftMenuIndex == 1) {
            url = "zhuanti_portal.jsp?columnid=" + columnid + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        } else {
            url = "zhuanti_portal_1.jsp?columnid=" + columnid + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        }
        //url为第三方页面  关闭视频
        if(url.indexOf("http://")>-1 ){
           savePlayChannel();
        }
        top.mainWin.document.location = url;
    }else{
        if(columnArr[leftMenuIndex].invalid==1){
            return ;
        }
        var url = columnArr[leftMenuIndex].curl;
        if (url.indexOf('?') > -1) {
            url = url + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex+ "_" + startIndex + "_" + endIndex;
        } else {
            url = url + "?leefocus=" + bottomMenuIndex + "_" + leftMenuIndex+ "_" + startIndex + "_" + endIndex;
        }
//        if (url.indexOf('application.jsp') > -1 || url.indexOf('zhanti.jsp') > -1) {
//        } else {
//           savePlayChannel();
//        }
        //var a=leftMenuCount-leftMenuIndex+"_"+bottomMenuIndex
        var obj = columnArr[leftMenuIndex];
//        for(var p in obj){
//            alert("SSSSSSSSSSSSSSSSSSSSSobj["+p+"]="+obj[p]);
//        }
      //  alert("SSSSSSSSSSSSSSSSSSSGOTOSD="+columnArr[leftMenuIndex].gosd);
        if(columnArr[leftMenuIndex].gosd == '1' && isZTEBW ==true){
          //  alert("SSSSSSSSSSSSSSSSSSSSSSSSSetEpgMode!!!!");
            if("CTCSetConfig" in Authentication)
            {
             //   alert("SSSSSSSSSSSSSSSSSSetEpgMode_CTC");
                Authentication.CTCSetConfig('SetEpgMode', 'SD');
            }else{
               // alert("SSSSSSSSSSSSSSSSSSetEpgMode_CU");
                Authentication.CUSetConfig('SetEpgMode', 'SD');
            }
        }
        var a=(bottomMenuIndex-4)+"_"+(startIndex+leftMenuIndex);
        if(url.indexOf("http://")>-1){
            savePlayChannel();
            top.mainWin.document.location = columnArr[leftMenuIndex].curl;
            return ;
        }
        top.mainWin.document.location = url+"&param="+a;
    }
}
function savePlayChannel(){
    top.jsSetControl("isCheckPlay", "0");
    top.doStop();
//    var lastChannelNum = top.channelInfo.currentChannel;
//    ztebw.setAttribute("channelNO", lastChannelNum);
    setBackParam();
}
function setBackParam() {
    backurlparam += "?lastfocus="+bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
    top.jsSetControl("backurlparam", backurlparam);
    var lastChannelNum = top.channelInfo.currentChannel;
   // alert("SSSSSSSSSSSSSSSSSSSS11111portal_lastChannelNum="+lastChannelNum);
    if(isZTEBW == true){
        ztebw.setAttribute("curMixno", lastChannelNum);
//        Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
        if("CTCSetConfig" in Authentication){
            Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
        }else{
            Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
        }
    }else{
        Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
    }
}

function showChannelListByColumnid() {
    var requestUrl = "action/channellistbycolumnid.jsp?columnid=" + curcolumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelbycolumnid);
}

function showchannelbycolumnid() {
    leftMenuIndex=0;
    startIndex=0;
    endIndex=7;
    channelType = "channel";
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.channelData;
    totalCount=tempArr.length;
    if(endIndex>totalCount)endIndex=totalCount;
    showChannelList();
}
function showChannelList(){
    columnArr=new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            var mixno = columnArr[i].mixno;
            if (mixno.length == 1) {
                mixno = "00" + mixno;
            } else if (mixno.length == 2) {
                mixno = "0" + mixno;
            }
            tempColumnname = writeFitString(columnArr[i].channelname, 20, 130);
            if(tempColumnname!=columnArr[i].channelname){
                columnArr[i].hasBreak = '1';
                columnArr[i].columnname = mixno + " "+columnArr[i].channelname;
            }
            $('left_menu_' + i).innerText = mixno + " " + tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function goUp() {
    if (leftMenuIndex > 0) {
        changeLeftMenuFocus(-1);
        leftMenuIndex--
        changeLeftMenuFocus();
    } else if (leftMenuIndex == 0) {
        doLast();
    }
}

function doLast() {
    changeLeftMenuFocus(-1);
//    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) { //�㲥
    if (bottomMenuIndex != 0) {
//        alert("SSSSSSSSSSSSSSSSlength="+length);
//        alert("SSSSSSSSSSSSSSSSstartIndex="+startIndex);
        if (startIndex > 0) {
            startIndex--;
            if(length==7)endIndex--;
            goPage();
        } else if(startIndex ==0) {
//            alert("SSSSSSSSSSSSSSSSSSS1111totalCount="+totalCount);
            if(totalCount>7){
//                alert("SSSSSSSSSSSSSSSSSSS222222=");
                startIndex = totalCount-7;
                endIndex = totalCount;
                leftMenuIndex = length-1;
                goPage();
            }else{
                leftMenuIndex = length-1;
                changeLeftMenuFocus();
            }
        }
    }else{
        leftMenuIndex = length-1;
        changeLeftMenuFocus();  
    }
}
function pageUp(){
    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) {
        if (startIndex > 0) {
            if (startIndex>= 0 && endIndex>15) {
                startIndex -= 7;
                endIndex =startIndex+7;
            } else {
                startIndex =0;
                endIndex = 7;
            }
            leftMenuIndex=0;
            goPage();
        }
    }
}
function pageDown(){
    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) {
        if (endIndex < totalCount) {
            startIndex = endIndex;
            if ((endIndex + 7) <=totalCount) {
                endIndex += 7;
            } else {
                endIndex = totalCount;
            }
            leftMenuIndex=0;
            goPage();
        }
    }
}
function goPage(){
    switch (bottomMenuIndex) {
            case 1 :showTvodList();break;
            case 2 :showVodList();break;
            case 3 :showChannelPage();break;
            case 4 :showSpecalColumnlist();break;
            case 5 :showSpecalColumnlist();break;
            case 6 :showSpecalColumnlist();break;
            case 7 :showSpecalColumnlist();break;
            default :break;
     }
}
function showChannelPage(){
    if(channelType=="column"){
      showchannelcolumnlist();
    }else{
       showChannelList(); 
    }
}

function goDown() {
//    alert("SSSSSSSSSSSSSSSSSleftMenuCount="+leftMenuCount);
    changeLeftMenuFocus(-1);
    if (leftMenuIndex < length - 1) {
        leftMenuIndex++;
        changeLeftMenuFocus();
    }else{
        doNext();
    }
//    else if (leftMenuIndex == leftMenuCount - 1) {
//        doNext();
//    }else{
//       leftMenuIndex=0;
//       alert("SSSSSSSSSSSSSSSSendIndex="+endIndex);
//       alert("SSSSSSSSSSSSSSSStotalCount="+totalCount);
//       changeLeftMenuFocus();
//    }
}

function doNext() {
        if (endIndex < totalCount) {
            startIndex++;
            endIndex++;
            goPage();
        }else{
           if(totalCount > 7){
               startIndex=0;
               endIndex=7;
               leftMenuIndex=0;
               goPage();
           }else{
               changeLeftMenuFocus(-1);
               leftMenuIndex=0;
               changeLeftMenuFocus();
           }
        }
}

function dotest() {
    return true;
}

document.onkeypress = doKeyPress;

showBottomMenuTimer();
