
function addZero(str){
    var temp = "";
    if(str<10){
        temp = "0" + "" +str;
    }else{
        temp = str + "";
    }
    return temp;
}

function doUp() {
    if ((doOther == 1|| doOther == 7)  && isGetingData == 0){
        turnPageAction="up";

        if (curChannelPos == 0 && channel_pageAll > 1) {
            doPrevPage();
        } else if (curChannelPos > 0) {
            if(curChannelIndex != 0)
            {
                 freeFocus();
                progTableObj.upAction();
                curChannelPos = progTableObj.currRow;

                curChannelIndex = curChannelPos;
            }

        }
    }

}
function doDown() {
	//alert("curChannelPos==="+curChannelPos+"======channel_curPageSize="+channel_curPageSize+"channel_pageAll="+channel_pageAll);
    if ((doOther == 1|| doOther == 7) && isGetingData == 0){
		//alert("test111111");
        turnPageAction="down";

        if (curChannelPos == channel_curPageSize - 1 && channel_pageAll > 1) {
		//	alert("test222222222");
            doNextPage();
			
        } else if (curChannelPos < channel_curPageSize - 1) {
		//	alert("test333333");
            if(curChannelIndex != channel_curPageSize-1){
                freeFocus();

                progTableObj.downAction();
                curChannelPos = progTableObj.currRow;

                curChannelIndex = curChannelPos;
            }
        }
    }

}
function doLeft()
{
    if(isGetingData == 1)
    {
        return;
    }
    if (doOther == 1)
    {
        if (curDayIndex >= 1 && progTableObj.isGetOtherDay == -1) {
            doPrevDay();
        }else if (progTableObj._chanDataSize > 0) {
            progTableObj.leftAction();
        }
    }

}
function doRight()
{
    if(isGetingData == 1){
        return;
    }

    if (doOther == 1){
        if (curDayIndex == dateInfo.length - 1 && progTableObj._timeStart == 1320) {

        }else if (curDayIndex < dateInfo.length - 1 && progTableObj.isGetOtherDay == 1) {
            doNextDay();
        }else if (progTableObj._chanDataSize > 0) {
            progTableObj.rightAction();
        }
    }

}
function doBlue(){
    _window_frame.top.mainWin.document.location = "vod_search.jsp?";
}

function doPrevDay(){
    if(isGetingData == 1){
        return;
    }

    if (doOther == 1){
        if (curDayIndex > 0){
            isGetingData = 1;
            curDayIndex--;
            if (progTableObj.isGetOtherDay == -1) {
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, 22);
            } else{
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, timeStart);
            }
        }
    }
}

function doNextDay(){
    if(isGetingData == 1){
        return;
    }
    if (doOther == 1){
        if (curDayIndex < dateInfo.length - 1){
            isGetingData = 1;
            curDayIndex++;
            if (progTableObj.isGetOtherDay == 1){
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, 0);
            } else{
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, timeStart);
            }
        }    
    }
}

function doPrevPage(){
    if(isGetingData == 1 || channel_pageAll == 1){ //页面请求数据时，数据保护
        return;
    }
    if (doOther == 1){
        if(progTableObj &&curChannelPos != 0){
             $("programFocusImg_"+progTableObj.currRow).style.visibility = "hidden";
             progTableObj.stopscrollChanName();
        }
        progTableObj._loseFocus();
        if (channel_curPage > 1)
        {
            channel_curPage--;
            curChannelPos = 0;

            loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, timeStart);
        }
        else if(channelDataObject[0].Pagecount > 1)
        {
            curChannelPos = 0;

            loadTVGuideData(channelDataObject[0].Pagecount, curColumnId, dateInfo[curDayIndex].Date, timeStart);
        }
    }
}

function doNextPage()
{
    if(isGetingData == 1 ||  channel_pageAll == 1)
    { //页面请求数据时，数据保护
	//alert("444444444");
        return;
    }
//    状态7，弹出童锁时，暂时不处理翻页
//alert("5555555");
    if (doOther == 1 || doOther == 7) {

             $("programFocusImg_"+progTableObj.currRow).style.visibility = "hidden";
             progTableObj.stopscrollChanName();

        progTableObj._loseFocus();
        if (channel_curPage < channelDataObject[0].Pagecount){
            channel_curPage++;
            curChannelPos = 0;

            loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, timeStart);
        }else if(channelDataObject[0].Pagecount > 1){
            curChannelPos = 0;

            loadTVGuideData(1, curColumnId, dateInfo[curDayIndex].Date, timeStart);
        }
    }
}

function doBack(){
    _window_frame.top.mainWin.document.location = "back.jsp";
}

function doOK(){
    if (doOther == 1){//播放频道
        playTVOD();
    }
}

function hiddeOSD() {
    _window_frame.top.jsClearKeyFunction();
    _window_frame.top.jsHideOSD();
}

document.onkeypress = dokeypress;
/*
 * 不支持NPVR弹出提示时的，初始化操作
 */
function showNotSupportNPVR(){
    if(channel_pageAll > 0)
            {
                progTableObj.focusFrom = "init";
                progTableObj._loseFocus();
                freeFocus();
            }
            $("showNpvr").style.display = "block";
}

function doRemind() {
    if(isGetingData == 1){ //页面请求数据时，数据保护
        return;
    }

}

function addRemind() {
  /*  if(dateInfo[curDayIndex].Date>curtime1 || (dateInfo[curDayIndex].Date==curtime1 && progTableObj.pro_startTime_minute>now_minutes)){
        var url = "action/channel_remind.jsp?Prevue_id=" + progTableObj.prevuecode + "&ActionType=1";
        new net.ContentLoader(url, function() {
            var data = eval("(" + this.req.responseText + ")");

            showaddRemind(data.flag);

        });
    }
*/
}

function addFav(){
    if (channelDataObject.length > 0 && allColumnId.length > 0) {
        var _columncode = progTableObj.columncode;
        var channelname = progTableObj.channelname;
        var _mixno = progTableObj.mixno;
        var url = "action/add_channelFavorite3S.jsp?SubjectID="+curColumnId+"&ContentID=" + _mixno + "&FavoriteTitle=" + channelname;
        new net.ContentLoader(url, function() {
            addFavResult = eval("(" + this.req.responseText + ")");
            var result = addFavResult.requestflag;
            var npvrFailedMsg = addFavResult.return_message;
            if (result == 0) {//add success
                messagesuccess();
                progTableObj._data[progTableObj.currRow].HasFav = 1;
                progTableObj._getFocus();
            }
        });
    }
}

function playTVOD(){
    var gotourl="channel_play.jsp?mixno=" +progTableObj.mixno;

    if(progTableObj.prevuecode=="" || dateInfo[curDayIndex].Date>curtime1 || (dateInfo[curDayIndex].Date==curtime1 && progTableObj.pro_endTime_minute>now_minutes)){
        gotourl="channel_play.jsp?mixno=" +progTableObj.mixno;
    }else if(progTableObj.Systemrecord=='1' && progTableObj.playable == 'true'){
       // alert("channel.jsp ---chan_func.js tvod play ##"+dateInfo[curDayIndex].Date);
        _window_frame.top.jsSetControl("tvodcurdate",dateInfo[curDayIndex].Date);
        gotourl = "channel_tvod_auth.jsp?columnid=" + progTableObj.columncode
                +"&prevueid="+progTableObj.PrevueId
                +"&programid="+progTableObj.ContentId
                +"&contentCode="+progTableObj.ContentId
                +"&ContentType=4"
                +"&CategoryID="+progTableObj.columncode
                +"&ContentID="+progTableObj.channelId
                +"&FatherContent="+progTableObj.channelId
                +"&type=tvod"
                +"&channelid="+progTableObj.channelId;

    }else{
        gotourl="channel_play.jsp?mixno=" +progTableObj.mixno;
    }    

    gotourl = gotourl+"&leefocus="+getleefocus();



	_window_frame.top.mainWin.document.location = gotourl;
}


function showCurTime() {
    getNewDate(dateInfo[curDayIndex].Date,"curTime");
}
function getleefocus(){
    var focusString = "";
    focusString = curDayIndex+":"+timeStart+":"+channel_curPage+":"+curChannelPos+":"+curChannelcols;
    return focusString;
}

function getNewDate(_date,div){

   if(_date){

       $(div).innerHTML = _date;
   }
}

function stopscrollStringPname(divid, text, px, divwidth, color) {
    if (tmpScrollHtml == "") {
        tmpScrollHtml = document.getElementById(divid).innerHTML;
    }
    divwidth = parseInt(divwidth);
    if (tmpScrollHtml != "") {
        var isHaveRec = tmpScrollHtml.indexOf("<IMG");
        if (isHaveRec > -1) {
            tmpScrollHtml = tmpScrollHtml.replace('</MARQUEE>', '').replace('<MARQUEE VERSION="3" SCROLLDELAY="250">', '');
            tmpScrollHtml = tmpScrollHtml.substr(tmpScrollHtml.indexOf('<IMG'));
            if (divwidth < 65) {
                if (divwidth < 10) {
                } else {
                    tmpScrollHtml = escapingQuotes0(writeFitString(text, 29, divwidth - 10)) + tmpScrollHtml;
                }
            } else {
                tmpScrollHtml = tmpScrollHtml.replace('STYLE="visibility:hidden;" ', '');
                tmpScrollHtml = escapingQuotes0(writeFitString(text, 29, (divwidth - 35))) + tmpScrollHtml;
            }
        } else {
            if (divwidth < 10) {
                tmpScrollHtml = "";
            } else {
                tmpScrollHtml = escapingQuotes0(writeFitString(text, 29, divwidth - 10));
            }
        }
        document.getElementById(divid).innerHTML = tmpScrollHtml;
    } else {
        px = parseInt(px, 10);
        divwidth = parseInt(divwidth, 10);
        var stringwidth = strlen(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (stringwidth > divwidth) {
            text = writeFitString(text, px, divwidth - 10);
            if (divwidth < 10) {
                text = "";
            }
            document.getElementById(divid).innerHTML = "<font color='#" + color + "' size='" + pxtosize(px) + "'>" + escapingQuotes0(text) + "</font>";
        }
    }
    tmpScrollHtml = "";
}
//去除数据中的px
function delPX(num){
    return parseInt(num);
}

function getTimeAs_hhmm(time) {
    var temp = "";
    temp = time.substring(11, 16);
    return temp;
}
function freeFocus(){

}
function setFocus(){

}

function forShowPic(picUrl){
    var showpicture = "";
    showpicture += "<img src='images/tv_guide/" + picUrl + "' width='20' height='21'/>" + "<img src='#' width='20' height='21'/>";
    return  showpicture;
}
function returnTime(y,m,d,h,im,s)
{

	var thetime = new Date();
	thetime.setFullYear(y, m-1, d);
	thetime.setHours(h, im, s);
	return thetime;
}

function hiddenRefreshBarDiv()
{
    $("refreshBar_div").style.visibility = "hidden";
    $("programname").style.visibility = "hidden";
    $("program_startTime").style.visibility = "hidden";
    $("backImg").style.visibility = "hidden";
    $("blueImg").style.visibility = "hidden";
    $("program_endTime").style.visibility = "hidden";
    $("channelDesc").style.visibility = "hidden";
}
function showRefreshBarDiv()
{
    $("refreshBar_div").style.visibility = "visible";
    $("programname").style.visibility = "visible";
    $("program_startTime").style.visibility = "visible";
    $("backImg").style.visibility = "visible";
    $("blueImg").style.visibility = "visible";
    $("program_endTime").style.visibility = "visible";
    $("channelDesc").style.visibility = "visible";
}

function doNothing(){
    return false;
}

function getformartStarttime(starttime)
{
    var startTime = parseInt(starttime);
    if (startTime > 22) {
        startTime = 22;
    }

    return startTime;
}
/*
 *   date  页面日期 beginTime = "2012.02.01";
 *   starttime    请求区间开始时间   startTime = "18:00";
 *   starttime    请求区间结束时间   endTime = "20:00";
 */
function loadTVGuideData(destpage, columnId, date, starttime, currentchan) {
    isGetingData = 1;
    if (date == "" || date == undefined){
        date = "";
        starttime = 0;
    }
    if (currentchan == undefined || currentchan == null){
        currentchan = "";
    }

    var tempDestpage = parseInt(destpage);
    if(isNaN(tempDestpage)){
        tempDestpage = 1;
    }

    var url = "action/channel_TVGuide1.jsp?columnid=" + columnId +
        "&destpage=" + tempDestpage + "&numperpage=10" + "&begintime=" + date + "&starttime=" + starttime + "&currentchannel=" + currentchan;

    new net.ContentLoader(url, function() {
        var _data = eval("(" + this.req.responseText + ")");
        init(_data, starttime);
    });
}

/*
 id:div的ID
 text:div的文字
 divWidth：div的宽度
 */
function starScroll(id, text, divWidth) {
    $(id).innerHTML = text;
//    var textWidth = $(id).scrollWidth;
    var textWidth = $(id).style.width;
    divWidth = parseInt(divWidth);
    if(isNaN(divWidth)){
        divWidth = 0;
    }

    textWidth = parseInt(textWidth);
    if(isNaN(textWidth)){
        textWidth = 0;
    }



    if (textWidth >= divWidth) {

        $(id).innerHTML = "<marquee scrolldelay='150' version='5'>" + text + "</marquee>";
    } else {

        $(id).innerHTML = text;
    }
}
function stopScroll(id, text) {
    $(id).innerHTML = text;
}

