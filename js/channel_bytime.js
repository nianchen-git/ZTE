var leftBorder = false;
var rightBorder = false;
var tt = -1;
 var pName = "";
 var playtime = "";
 var sTime = "";
 var eTime = "";
 var description = "";
 var recordprivateValue = "";
 var stateValue = "";
 var cid = "";
 var pType = "";
 var prevId = "";
 var isFav = false;
 var nowFocus = "";
 var arraychannelBasicID;
 var arrayHassubscrib;
 var arrayMixNoObj;
 var arrayChanNameObj;
 var arrayTvod;
 var arrayLevelvalue;
 var arrayIsCanLock;
 var arrayIsLock;
 var arrayRateID;
 var lastRow = 0;  // Save the last row index
 var leftChannelId = "";
 var channelbasicID = "";
 var channelName = "";
 var isRemind = "0";
 var usertvod = "";
 var hassubscrib = "";
 var isLock = false;
 var lockValue = "";
 var chLevel = '-1';
 var chIsCanLock = '-1';
 var chIsLock = '-1';
 var isRecord = false;
 var suppordRecord = "-1"; //是否支持录制
 var lpvrState = '-1';//是否已录制
 var npvrState = '-1';//是否已录制
 var foreShow = "-1";
 var programNamePvr = "";
 var rateIdValue = 0;
 var channelIdTem = "";
 var topWindow = top; //window.opener.top;
 var contentid="";

var $$ = {};

var $ = function(id){
    if(!$$[id]){
        $$[id] = document.getElementById(id);
    }
    return $$[id];
}

   function showTime1(s1){
    var s2 = s1.split(" ");
    var s3 = s2[1];
    s3 = s3.substring(0,5);
    return s3 ;
   }

   function showProgrameInfo(programName,contentDescription,startTime,endTime)
{
    if(document.getElementById("showProgramInfo").innerHTML != undefined)
    {
        document.getElementById("showProgramInfo").innerHTML = "";
    }
    if(programName != "")
    {
        if(programName.length > 60)
        {
            programName =  programName.substring(0,60);
        }
        var startTimeTemp = showTime1(startTime);
        var endTimeTemp = showTime1(endTime);

        playtime = startTimeTemp + "-" + endTimeTemp;

        var tempHtml = "";
        tempHtml += programName;
        tempHtml += "</br>";
        tempHtml += playtime;
        tempHtml += "<br>";
        tempHtml += contentDescription;
        document.getElementById("showProgramInfo").innerHTML = tempHtml;
    }
}

function resetTime(){
    return;
    if(tt != -1){
    clearTimeout(tt);
    }
    tt = setTimeout("goIframe()",1000);
    return false;
}


function goIframe(){
//        if(isByTimenew){
//            initCurProgramParms();
//        }
    showProgrameInfo(pName,description,sTime,eTime);
    if(leftChannelId != channelIdTem){
        checkFav();
        checkLock();
        leftChannelId = channelIdTem;
    }
    checkRemind(foreShow);
    checkSupportRecord();
    checkRecord();
    showIcon();
}

var upBorder = false;
var downBorder = false;
function goUp(){
    if(upBorder  == true) {
        prevInCycle();
        return false;
    }else if(nowFocus.length >=5){
        //alert('SSSSSSSSnowFocus='+nowFocus);
             var lineIndex = parseInt(nowFocus.substring(3,4));
             var columnIndex = parseInt(nowFocus.substring(4));
//             if(lineIndex>=1 && columnIndex==0){
//                 alert('YESYESYESYESYESYESYES!!');
                 lineIndex = lineIndex-1;
                 while(columnIndex>=0){
                     if(document.links['an_'+lineIndex+'0']){
                         document.links['an_'+lineIndex+'0'].focus();
                         return false;
                     }
                     columnIndex--;
                 }
//             }
    }
    return true;
}
function goDown(){
//    alert("SSSSSSSSSSSSSSSSSgoDown="+downBorder+"_"+nowFocus);
    if(downBorder  == true) {
        nextInCycle();
        return false;
    }else if(nowFocus.length >=5){
//        alert('SSSSSSSSnowFocus='+nowFocus);
             var lineIndex = parseInt(nowFocus.substring(3,4));
             var columnIndex = parseInt(nowFocus.substring(4));
//             alert("SSSSSSSSSSSSSSSSgoDown1="+lineIndex+"_"+columnIndex);
//             if(lineIndex<=3 && columnIndex==0){
//             if(columnIndex==0){
//                 alert('YESYESYESYESYESYESYES!!');
                 lineIndex = lineIndex+1;
                 while(columnIndex>=0){
                     if(document.links['an_'+lineIndex+'0']){
                         document.links['an_'+lineIndex+'0'].focus();
                         return false;
                     }
                     columnIndex--;
                 }

//                 alert("SSSSSSSSSSSSSSlineIndex="+lineIndex);
//                 alert("SSSSSSSSSSSSSSS$="+$['an_'+lineIndex+'0']);
//                 if($['an_'+lineIndex+'0']){
//                     $['an_'+lineIndex+'0'].focus();
//                     return false;
//                 }
//             }
    }
    return true;
}

var curLinkId = {id:"",row:0,col:0,
    change: function(name,rowIndex){
        this.id= name;
        this.row = rowIndex;
        this.col = parseInt(name.replace(/[^\d]*./,""),10);
    },
    getLeft: function(){
        return this.id.replace(/\d*$/,"")+this.row+(this.col-1);
    },
    getRight: function(){
        return this.id.replace(/\d*$/,"")+this.row+(this.col+1);
    },
    getUp: function(){
        return this.id.replace(/\d*$/,"")+(this.row-1)+this.col;
    },
    getDown: function(){
        return this.id.replace(/\d*$/,"")+(this.row+1)+this.col;
    }
}

function gotoPrev(date,starthour,endhour,leefocus,prevdate){
    if(endhour==24){
    goto(prevdate,starthour,endhour,leefocus);
    }else{
    goto(date,starthour,endhour,leefocus);
    }
}

function gotoNext(date,starthour,endhour,leefocus,nextdate){
    if(starthour=='00'){
        goto(nextdate,starthour,endhour,leefocus);
    }else{
        goto(date,starthour,endhour,leefocus);
    }
}


function channelPlay(mixNo,channelCode,anchorId){
    var currentChannel = top.channelInfo.currentChannel;
    if(mixNo != currentChannel)
    {
    top.doStop();
    top.jsRedirectChannel(mixNo);
    }else{
    top.jsHideOSD();
    }
}

function anBlur(nodeId,rowIndex) {
    changeHeaderColor(rowIndex, false,nodeId,'TVprogram_line.png',1,1);
}

var curMixno=-1;
var curColumnid = -1;
function anFocus(divWidth, programTop, columnid, nodeId, rowIndex, chanId,up,down,left,right,programName,startTime,endTime,img,onfocusimg,recordprivate, mixno,prevueid, contentId) {
    changeHeaderColor(rowIndex, true,nodeId,img,onfocusimg, divWidth, programTop);
//    document.onkeypress = doKeyChannelByTime;
//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSSanfocus????");
    upBorder = up;
    downBorder = down;
    leftBorder = left;
    rightBorder = right;
    curMixno = mixno;
    curColumnid = columnid;
//        alert("SSSSSSSSSSSSSSSSSSSSSSSScurColumnid"+columnid);
//        alert("SSSSSSSSSSSSSSSSSSSSSSSScurMixno"+curMixno);
    pName = programName;
    channelIdTem = chanId;
    contentid=contentId;

    curLinkId.change(nodeId,rowIndex);
    lastRow = rowIndex;
    prevId = prevueid;
    nowFocus = nodeId;
    sTime = startTime;
    eTime = endTime;

    var playType = compareTo(startTime, endTime);
    if(playType == "tvod"){
        type = "tvod";
    }else{
        type = "living";
    }
    pType = type;
    foreShow = playType;
    resetTime();
    return false;
}

// Direction arrows

function changeHeaderColor(rowIndex, isFocus,nodeId,img,onfocusimg,divWidth, programTop) {
    var imgObj = document.getElementById("text" + nodeId);
    imgObj.style.background = (isFocus) ? "url(images/liveTV/channelSelect_bg.png)" : "none";

    var bg_img = document.getElementById("bg_focus_" + rowIndex);
    if(isFocus){
       bg_img.style.visibility = "visible";
    }else{
       bg_img.style.visibility = "hidden";
    }
}

 function hidVodInfo(){
     document.location = "back.jsp";
 }

   var rowSpa = 25;


//top.jsSetupKeyFunction("top.mainWin.changeChannelMode",<%=STBKeysNew.remoteStop%>);//??б??

function doKeyChannelByTime(evt){
        var keyCode = parseInt(evt.which);
        if(window.event){
            keyCode = window.event.keyCode;
        } else if(evt){
            keyCode = evt.keyCode;
        }
        switch(keyCode){
            case STBKeysNew.remoteInfo:
                //showProgramDetail();
                break;
            case STBKeysNew.onKeyDown:
                return goDown();
                break;
            case STBKeysNew.onKeyLeft:
                return goLeft();
                break;
            case STBKeysNew.onKeyRight:
                return goRight();
                break;
            case STBKeysNew.onKeyUp:
                return goUp();
                break;
            case STBKeysNew.onKeyOK:
                tvodPlay();
                break;
            case STBKeysNew.onKeyRed:
                doRed();
                return ;
                break;
            case STBKeysNew.onKeyBlue:
//                alert("SSSSSSSSSSSSSSSSSSSS");
                top.mainWin.document.location = "vod_search.jsp?columnpath="+encodeURIComponent('')
                break;
            case STBKeysNew.remoteFastRewind:
            case STBKeysNew.remoteFastForword:
//                return fastRewind();
            case STBKeysNew.onKeyGrey:
//                showGridViewByChannel();
                    return false;
		        break;
        case STBKeysNew.remoteBack:
//                hidVodInfo();
                //top.mainWin.document.location = "channel_bytime_pre.jsp?columnid=0000&destpage=1&numperpage=10&timecount=3&interval=30";
                top.mainWin.document.location = "back.jsp";
            break;
        case STBKeysNew.remotePlayLast:
            prevInCycle();
            break;
        case STBKeysNew.remotePlayNext:
            nextInCycle();
            break;
        default:
            return topWindow.doKeyPress(evt);
        }
    	return false;
	}

    var doRed = function() {
       // operation.location= "channel_remind.jsp?Prevue_id=" + prevId + "&ActionType=1";        
    }
    var tvodPlay = function() {
        var playurl = "";
        if (pType == "tvod") {
            playurl = "channel_tvod_play.jsp?columnid=" + curColumnid
                    + "&prevueid=" + prevId
                    + "&programid=" + contentid
                    + "&contentCode=" + contentid
                    + "&channelid=" + channelIdTem;
        } else {
            playurl = "channel_play.jsp?mixno=" + curMixno;
        }
//        alert("SSSSSSSSSSSSSSSSSSnowFocus="+nowFocus);
//        return;
        document.location = playurl+"&leefocus="+nowFocus;
    }

    function closeMessage() {
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
    }

     document.onkeypress = doKeyChannelByTime;


function getPageTotal(itemTotal, numPerPage){
        var temppagecount = 0;
        if(itemTotal % numPerPage == 0){
            temppagecount = itemTotal / numPerPage;
        }else{
            temppagecount = Math.ceil((itemTotal + 1) / numPerPage);
        }
        return temppagecount;
    }
    function getCurPageSize(itemTotal,curPage,numPerPage){
		var curPageSize=0;
		if(itemTotal - curPage*numPerPage > numPerPage){
			curPageSize = numPerPage;
		}else{
			curPageSize = itemTotal - curPage*numPerPage;
		}
		return curPageSize;
	}
    function addZero(str){
        return (str<10?"0":"")+str;
    }
    function writeFitString_Tmp(string2show, charactorWidth, lineWidth){
        var curLanguage = 'zh';
        var stringLength = lineWidth / charactorWidth;
        var string2return = string2show;
        if(curLanguage != 'en'){
            stringLength = stringLength / 2;
        }
        if(stringLength > stringLength){
            string2return = string2show.substring(0, (stringLength > 2) ? (stringLength - 2) : stringLength) + "...";
        }
        return string2return;
    }

    Date.prototype.getDateYYMMDD = function(){
        var y = this.getFullYear();
        var m = this.getMonth() + 1;
        var d = this.getDate();
        m = m < 10 ? "0" + m : m;
        d = d < 10 ? "0" + d : d;
        return y + "." + m + "." + d;
    };


function showallbg(){
   $('bg_img').style.visibility = "visible";
}

function hideallbg(){
   $('bg_img').style.visibility = "hidden";
}

     function compareTo(startTime, endTime) {
        var curTime = curTime_g;
        var reg = /\./g;
        startTime = startTime.replace(reg, "/");
        endTime = endTime.replace(reg, "/");
        var a = new Date(curTime);
        var b = new Date(startTime);
        var c = new Date(endTime);
        if(b > a){
            return "foreshow";
        }
        if(a >= b && c > a){
            return "living";
        }
        if(a > c){
            return "tvod";
        }
    }

 	function goLeft(){
		if(leftBorder  == true && canLeft == 1) {
            gotoPrev(dateString ,sprevHour,starthour,'',prevdate);
			return false;
		}else if(leftBorder ==  false && nowFocus.length >=5){
             var lineIndex = parseInt(nowFocus.substring(4,6));
             var an_ = nowFocus.substring(0,4);
                 if(lineIndex>0){
                     lineIndex = lineIndex-1;
                     if(document.links[an_+lineIndex]){
                         document.links[an_+lineIndex].focus();
                         return false;
                     }
                 }
        }
		return true;
	}

	function goRight(){
		if(rightBorder  == true && canRight == 1) {
            gotoNext(dateString,snextHour,snext2Hour,'',nextdate);
			return false;
		}else if(rightBorder ==  false && nowFocus.length >=5){
             var lineIndex = parseInt(nowFocus.substring(4,6));
             var an_ = nowFocus.substring(0,4);
                 lineIndex = lineIndex+1;
                 if(document.links[an_+lineIndex]){
                     document.links[an_+lineIndex].focus();
                     return false;
                 }
        }
		return true;
	}
