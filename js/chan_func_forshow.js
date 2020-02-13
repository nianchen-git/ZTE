
//max collength for every row
var maxColLengthArr = [8,8,8,8,8,8,8,8,8,8];
//last collength for ever row
var lastColLengthArr = [];

function ProgTableObj(timeDuration, tableWidth, totalRow, totalCol, data, startIndex, startTime_minute, currRow, currCol) {
    totalCol = 10;
    this._timeDuration = timeDuration;
    this._tableWidth = tableWidth;
    this._totalRow = totalRow;
    this._totalCol = totalCol;
    this._data = data;
    this._chanDataSize = this._data.length;
    this._chanStartIndex = startIndex;
    this._indexInfoArray = new Array(this._totalRow);
    for (var i = 0; i < this._indexInfoArray.length; i++) {
//        this._indexInfoArray[i] = new Array(this._totalCol);
//        for (var j = 0; j < this._indexInfoArray[i].length; j++) {
//            this._indexInfoArray[i][j] = {};
//        }
         this._indexInfoArray[i] = [];
    }
    this.currRow = currRow;
    this.currCol = currCol;
    this.lastRow = 0;
    this.lastCol = 0;
    this.isGetOtherDay = 0;
    this._timeStart = startTime_minute;
    this._firstFlag = 0;
    this._action = 1;
    /*0:left,right 1:init,up,down*/
    this._lastTdColIndenx = [];
    for (var i = 0; i < this._totalRow; i++) {
        this._lastTdColIndenx[i] = 0;
    }
    this.drawProgTable = function() {
        var tdID = "td00";
//        for (var i = 0; i < this._totalRow; i++) {
//            for (var j = 0; j < this._totalCol; j++) {
//                tdID = "td" + i + "" + j;
//                $(tdID).style.visibility = "hidden";
//                $(tdID).style.backgroundColor="";
//            }
//        }
        var timeEnd = this._timeStart + this._timeDuration;
        var row;
        var chanIndex = 0;
        var tdCol = 0;
        var progList =[];
        var j;

//        alert("SSSSSSSSSSSSSSSSSthis._chanDataSize="+this._chanDataSize);
//        alert("SSSSSSSSSSSSSSSSSthis._totalRow="+this._totalRow);

        for (row = 0; row < this._chanDataSize && row < this._totalRow; row++) {
            chanIndex = (row + this._chanStartIndex + this._chanDataSize) % this._chanDataSize;
            tdCol = 0;
            progList = this._data[chanIndex].ProgramList;
            for (j = 0; j < progList.length; j++) {
//                if (progList[j].startTime_minute > timeEnd || progList[j].startTime_minute == timeEnd || tdCol >= this._totalCol) {
                if (progList[j].startTime_minute > timeEnd || progList[j].startTime_minute == timeEnd ) {
                    break;
                }else if (progList[j].endTime_minute < this._timeStart || progList[j].endTime_minute == this._timeStart) {
                    continue;
                }else {
                    var tdStart = Math.max(progList[j].startTime_minute, this._timeStart);
                    var tdEnd = Math.min(progList[j].endTime_minute, timeEnd);
                    this._drawTd(row, tdCol, tdStart, tdEnd, progList[j].PrevueName, {chanPos:chanIndex,progPos:j}, progList[j]);
                    tdCol++;
                }
            }
//            if (0 == tdCol || ((timeEnd - progList[j - 1].endTime_minute) > 5) && tdCol < this._totalCol) {
            //when program has not in end of area
//            alert("SSSSSSSSSSSSSSSSSSSSrow="+row);
//            alert("SSSSSSSSSSSSSSSSSSSStimeEnd="+timeEnd);
//            alert("SSSSSSSSSSSSSSSSSSSSendTime_minute="+progList[j - 1].endTime_minute);endTime_minute
            if (0 == tdCol || ((timeEnd - progList[j - 1].endTime_minute) > 5)) {
                var tdStart =0;
                var templeft = programAreaLeft;
                if(0 == tdCol){
                   tdStart = this._timeStart;
                    templeft = programAreaLeft;
                }else{
                   tdStart =progList[j - 1].endTime_minute;
                   templeft = parseInt(progList[j - 1].left)+parseInt(progList[j - 1].divWidth);
                }
//                var tdStart = (0 == tdCol) ? this._timeStart : progList[j - 1].endTime_minute;
                this._drawTd(row, tdCol, tdStart, timeEnd, templeft, {chanPos:chanIndex,progPos:-1});
                tdCol++;
            }
            this._lastTdColIndenx[row] = tdCol - 1;
            initFinish = true;

            //清空剩余的div
//            if(tdCol < this._totalCol){
//               for(var i=tdCol; i<this._totalCol; i++){
//                   $('td'+row+i).style.visibility = "hidden";
//               }
//            }            
            if(tdCol < lastColLengthArr[row]){
               for(var i=tdCol; i<lastColLengthArr[row]; i++){
                   $('td'+row+i).style.visibility = "hidden";
               }
            }
        }

        if(this._chanDataSize<this._totalRow){
            for (var i = this._chanDataSize; i < this._totalRow; i++) {
                for (var j = 0; j < lastColLengthArr[i]; j++) {
                    tdID = "td" + i + "" + j;
                    $(tdID).style.visibility = "hidden";
                }
            }
        }
        this._showCurTime();

        isFromDrawTable = true;

        //set lastColLengthArr and maxColLengthArr
        for (var i = 0; i < this._totalRow; i++) {
            lastColLengthArr[i]=this._indexInfoArray[i].length;
            if(lastColLengthArr[i]>maxColLengthArr[i]){
                 maxColLengthArr[i] = lastColLengthArr[i];
            }
        }        
    }
    this._drawTd = function(row, col, startTime, endTime, tempLeft, indexInfo, programList) {
//        $(tdId).innerHTML = name;
//        $(tdId).innerHTML = programList.PrevueName;
//        $(tdId).innerHTML = 'Стандарт2337';
        this._indexInfoArray[row][col] = {};
        if ("" == indexInfo) {
            this._indexInfoArray[row][col].chanPos = -1;
            this._indexInfoArray[row][col].progPos = -1;
        } else {
            this._indexInfoArray[row][col].chanPos = indexInfo.chanPos;
            this._indexInfoArray[row][col].progPos = indexInfo.progPos;
        }

        var tdId = "td" + row + "" + col;
        var tdWidth = 0;
        var left =0;
        var programNameText = "";
//        for(var p in programList){
//            alert("SSSSSSSSSSSSSSSSSSprogramList["+p+"]="+programList[p]);
//        }
        if(programList){
            tdWidth = programList.divWidth;
            left = programList.left;
            programNameText = programList.showProgramName;
        }else{
            left = tempLeft;
            tdWidth = Math.floor(endTime * this._tableWidth / this._timeDuration) - Math.floor(startTime * this._tableWidth / this._timeDuration);
            programNameText = "";
        }
         left = left-programAreaLeft;
//         alert("SSSSSSSSSSSStdId="+tdId);
//         alert("SSSSSSSSSSSSrow="+row);
//         alert("SSSSSSSSSSSSmaxColLengthArr[row].length="+maxColLengthArr[row]);
         if(col>=maxColLengthArr[row]){
            var tdDivObj = document.createElement("div");
            tdDivObj.id = tdId;
            tdDivObj.align = "center";
            tdDivObj.className = "channel_col";
            tdDivObj.innerHTML = programNameText;
            tdDivObj.style.left = left;
             if(col == 0){
                 tdDivObj.style.width = tdWidth-2;
             }else{
                 tdDivObj.style.width = tdWidth-1;
             }
            tdDivObj.style.visibility = "visible";
            $("Layer_"+row).appendChild(tdDivObj);

         }else{
            $(tdId).innerHTML = programNameText;
            $(tdId).style.left = left;
             if(col == 0){
                 $(tdId).style.width = tdWidth-2;
             }else{
                 $(tdId).style.width = tdWidth-1;
             }
            $(tdId).style.visibility = "visible";
//             alert("SSSSSSSSSSSS$left="+left+"_"+tdWidth);
//            alert("SSSSSSSSSSSS$(tdId).style.left="+$(tdId).style.left);
         }

    }

    this.focusFrom = "init";
    this.rightAction = function() {
        if (isGetingData == 1) {
            return;
        }
        this.focusFrom = "right";
        this._loseFocus();
        if (this.currCol != this._lastTdColIndenx[this.currRow]) {
            this.currCol++;
//            alert("SSSSSSSSSSSSSSSSSSS444444");
        } else {
            if (this._timeStart + this._timeDuration < 24 * 60){
                this._timeStart += this._timeDuration;
                if (this._pageTime > "22:00" || this._pageTime == "22:00") {
                    this._pageTime = "22:00";
                    this._timeStart = 22 * 60;
                }
                if (this._timeStart > 22 * 60 || this._timeStart == 22 * 60) {
                    this._pageTime = "22:00";
                    this._timeStart = 22 * 60;
                }
                initFinish = false;
                this.currCol = 0;
//                alert("SSSSSSSSSSSSSSSSSSS1111");
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, this._timeStart / 60);
                return;
            } else {
//                alert("SSSSSSSSSSSSSSSSSSS3333333");
                this.isGetOtherDay = 1;
                doRight();
                return;
            }
        }
//        alert("SSSSSSSSSSSSSSSSSSS22222");
        this._getFocus();
    }

    this.leftAction = function() {
        if (isGetingData == 1) {
            return;
        }
        this.focusFrom = "left";
        this._loseFocus();
        if (0 != this.currCol) {
            this.currCol--;
        } else {
            if (curDayIndex == 0 && this._timeStart == 0) {
                this._getFocus();
                return;
            }
            if (0 != this._timeStart) {
                this._timeStart -= this._timeDuration;
                if (this._timeStart < 0) {
                    this._timeStart = 0;
                }
                this.currCol = this._lastTdColIndenx[this.currRow];
                loadTVGuideData(channel_curPage, curColumnId, dateInfo[curDayIndex].Date, this._timeStart / 60);
                return;
            } else {
                this.isGetOtherDay = -1;
                doLeft();
            }
        }
        this._getFocus();
    }

    this.upAction = function() {
        if (isGetingData == 1) {
            return;
        }
        this.focusFrom = "up";
        this._loseFocus();
        if (0 != this.currRow) {
            this.currRow--;
        } else if (0 == this.currRow && this._chanDataSize <= this._totalRow) {
            this.currRow = this._chanDataSize - 1;
        } else {
        }
        this._countNewCol();
        this.getChanIndex();
        this._getFocus();
    }

    this.downAction = function() {
        if (isGetingData == 1) {
            return;
        }
        this.focusFrom = "down";
        this._loseFocus();
        if (this._chanDataSize - 1 == this.currRow) {
        } else if (parseInt(this.currRow) + 1  < this._totalRow) {
            this.currRow++;
        } else {
        }
        this._countNewCol();
        this.getChanIndex();
        this._getFocus();
    }

    this._getFocus = function() {
        if(this._lastTdColIndenx[curChannelPos] < curChannelcols){   // todo gabe last  Focus
            curChannelcols = this._lastTdColIndenx[curChannelPos];
            this.currCol = curChannelcols;
        }
        var tdId = "td" + this.currRow + "" + this.currCol;
        var indexInfo = this._getIndexInfo(this.currRow, this.currCol);
        curChannelPos = this.currRow;
        curChannelcols = this.currCol;
		
        this.getFocus(tdId, indexInfo);
    }
    
    this._loseFocus = function() {
        this.lastRow = this.currRow;
        this.lastCol = this.currCol;
        //if(doOther == 1 && (this.focusFrom == "down" || this.focusFrom == "up" || this.focusFrom == "init"))
        //频道失去焦点的设置
        if(!(this.focusFrom=='right' || this.focusFrom=='left')){  //todo gabe add init
            $("programFocusImg_"+this.currRow).style.visibility = "hidden";
            this.stopscrollChanName();
//            $('channelName_'+this.lastRow).style.color="#000000";
//            $('channelName_'+this.lastRow).innerText = channelDataObject[this.lastRow].ShowChannelName;
//            $("Layer_"+this.currRow).style.color = "#000000";

        }
        //节目单失去焦点的设置
        var tdId = "td" + this.lastRow + "" + this.lastCol;
//        $(tdId).style.backgroundColor="";
//        alert("++++++++++++++++=SSSSSSSSSSSSSSSSSSSSSSS_loseFocus_tdId="+tdId);
        $(tdId).style.background = "none";
        var indexInfo = this._getIndexInfo(this.currRow, this.currCol);
        var programInfo = this._data[indexInfo.chanPos].ProgramList[indexInfo.progPos];
        if(programInfo){
            $(tdId).innerHTML = programInfo.showProgramName;
        }
    }

    this.scrollChanName = function() {
//        setFocus();                                //频道名称滚动同时混排号获得焦点
//        $("Layer_"+this.currRow).style.color = "#FFFFFF";
//        alert("SSSSSSSSSSSSSSSSSSSSSscrollChanNamecurrRow_isBreak="+this.currRow+"_"+channelDataObject[this.currRow].isBreak);
        if(channelDataObject[this.currRow].isBreak=="1"){
//            alert("SSSSSSSSSSSSSSSSSSscrollChanName1111111");
            $("channelName_" + this.currRow).innerHTML="<marquee version='3' scrolldelay='250' ><font color='#FFFFFF'>" + channelDataObject[this.currRow].ChannelName + "</font></marquee>";
        }else{
//            $("channelName_" + this.currRow).style.color='#FFFFFF';
        }
    }

    this.stopscrollChanName = function() {
        if(channelDataObject[this.currRow].isBreak=="1"){
            $("channelName_" + this.currRow).innerHTML=channelDataObject[this.currRow].ShowChannelName;
        }
    }

    this.showProgramInfo = function(tdObj, row, col) {
        var tempRow = row;
        var tempCol = col;
        var channelInfo = this._data[tempRow];
        var programInfo = this._data[tempRow].ProgramList[tempCol];
        if (channelInfo != null && channelInfo != "" && channelInfo != "undefined") {
            if (programInfo != null && programInfo != "" && programInfo != "undefined") {
                var hasBreak = programInfo.hasBreak;    //是否被截取
//                alert("SSSSSSSSSSSSSSSSShasBreak="+hasBreak);
                if (hasBreak == 1) {
                    starScroll(tdObj,programInfo.PrevueName,delPX($(tdObj).style.width));
                }
            }
        }
    }

    this.getFocus = function(tdObj, progInfo) {
        var tempRow = progInfo.chanPos;
        var tempCol = progInfo.progPos;
        this.prevuecode = "";
//        this.systemrecord = "";
//        this.privaterecord = 0;
//        this.recordstatus = 0;
        this.pro_startTime_minute = 0;
        this.pro_endTime_minute =0;
        var channelInfo = this._data[tempRow];
        var programInfo = this._data[tempRow].ProgramList[tempCol];
        this.channelId = channelInfo.ChannelId;
        this.mixno = channelInfo.MixNo;
        this.channelname = channelInfo.ChannelName;
        this.columncode = channelInfo.ColumnCode;
        this.ContentId = "";
        if (programInfo){
//            this.recordcode = programInfo.Recordcode;
            this.prevuecode = programInfo.Prevuecode;
//            this.systemrecord = programInfo.Systemrecord;
//            this.recordstatus = programInfo.Recordstatus;
            this.prevuename = programInfo.PrevueName;
            this.startTime = programInfo.StartTime;
            this.pro_startTime_minute = programInfo.startTime_minute;
            this.pro_endTime_minute = programInfo.endTime_minute;
            this.ContentId = programInfo.ContentId;
            this.Systemrecord = programInfo.Systemrecord;
            this.playable = programInfo.playable;
            this.PrevueId = programInfo.PrevueId;

//            for(var p in programInfo){
//                 alert("SSSSSSSSSSSSSSSSSSSprogramInfo["+p+"]="+programInfo[p]);
//            }
        }

        window.clearTimeout(chanNameTimeOut);
        window.clearTimeout(focusTimeOut);
        
        if(!(this.focusFrom=='right' || this.focusFrom=='left')){
            $("programFocusImg_"+this.currRow).style.visibility = "visible";
            chanNameTimeOut = setTimeout("progTableObj.scrollChanName();",700);
        }
        focusTimeOut = setTimeout("progTableObj.showProgramInfo('" + tdObj + "','" + tempRow + "','" + tempCol + "');", 800);
//        $(tdObj).style.backgroundColor="#206989";
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSgetFocus_tdObj="+tdObj);
        $(tdObj).style.background = "url(images/liveTV/channelSelect_bg.png)";
    }

    this.loseFocus = function(tdObj) {
    }

    this._getIndexInfo = function(row, col) {
          return this._indexInfoArray[row][col];
    }
    this._getTdStartTime = function(row, col, flag) {
        if (-1 == this._indexInfoArray[row][col].progPos && 1 == flag) {
            return -1;
        }
        if (0 == col) {
            return this._timeStart;
        } else {
            if (-1 != this._indexInfoArray[row][col].progPos) {
                var chanPos = this._indexInfoArray[row][col].chanPos;
                var progPos = this._indexInfoArray[row][col].progPos;
                return this._data[chanPos].ProgramList[progPos].startTime_minute;
            } else {
                var chanPos = this._indexInfoArray[row][col - 1].chanPos;
                var progPos = this._indexInfoArray[row][col - 1].progPos;
                return this._data[chanPos].ProgramList[progPos].endTime_minute;
            }
        }
    }
    this._countNewCol = function() {
        this.currCol = 0;
        var lastTime = this._getTdStartTime(this.lastRow, this.lastCol, -1);
        var distant = this._timeDuration;
        for (var i = 0; i < this._lastTdColIndenx[this.currRow] + 1; i++) {
            var tempTime = this._getTdStartTime(this.currRow, i, 1);
            if (-1 == tempTime) {
                continue;
            }
            var tempDistant = tempTime - lastTime;
            if (0 == tempDistant) {
                this.currCol = i;
                break;
            } else if (Math.abs(tempDistant) < distant) {
                distant = Math.abs(tempDistant);
                this.currCol = i;
            }
        }
    }
    this._addZero = function(str) {
        var temp = "";
        if (str < 10) {
            temp = "0" + "" + str;
        } else {
            temp = str + "";
        }
        return temp;
    }
    this._changeTime = function(temp) {
        var tempArr = this._pageTime.split(":");
        var tempArrOne = parseInt(tempArr[0], 10);
        if (temp == "1") {
            if (tempArrOne >= 22) {
                tempArrOne = 0 + "";
            } else {
                tempArrOne = tempArrOne + 2;
            }
        } else if (temp == "-1") {
            if (tempArrOne == 0) {
                tempArrOne = 22 + "";
            } else {
                tempArrOne = tempArrOne - 2;
            }
        }
        var tempArrTwo = tempArr[1];
        this._pageTime = this._addZero(tempArrOne) + ":" + tempArrTwo;
        this._showCurTime();
    }
    this._getNowTime = function() {
        var tempDay = new Date();
        var hour = tempDay.getHours();
        var minute = tempDay.getMinutes();
        return hour * 60 + minute;
    }
    var time_p_timeout = -1;
    this._showTimeProgress = function() {
        if (curDayIndex =="<%=timePrev%>") {
            var nowTime_minute = this._getNowTime();
            var tdWidth = Math.floor((nowTime_minute - this._timeStart) * this._tableWidth / this._timeDuration) + 330;
            if (tdWidth < 330 || (nowTime_minute - this._timeStart >= 60 * 2)) {
                $("time_plant").style.visibility = "hidden";
            } else {
                $("time_plant").style.visibility = "visibility";
                $("time_plant").style.left = tdWidth;
            }
        } else {
            $("time_plant").style.visibility = "hidden";
        }

        clearTimeout(time_p_timeout);
        time_p_timeout = setTimeout("progTableObj._showTimeProgress();", 60 * 1000);
    }
    this._showCurTime = function() {
        this._pageTime = this._addZero(timeStart) + ":00";
        //        this._pageTime = "16:00";
        var tempTime = this._pageTime;
        $("timeFirst").innerText = tempTime;
        $("timeSecond").innerText = (tempTime = this.getNextTimes("1", tempTime));
        $("timeThird").innerText = (tempTime = this.getNextTimes("1", tempTime));
        $("timeFourth").innerText = (tempTime = this.getNextTimes("1", tempTime));
    }
    this.getNextTimes = function(temp, time) {
        var resultTime = "";
        var tempArr = time.split(":");
        var tempArrOne = parseInt(tempArr[0], 10);
        var tempArrTwo = parseInt(tempArr[1], 10);
        if (temp == "1") {
            if (tempArrTwo == 30) {
                tempArrTwo = 0;
                tempArrOne = tempArrOne + 1;
            } else if (tempArrTwo == 0) {
                tempArrTwo = 30;
                tempArrOne = tempArrOne;
            }
            if (tempArrOne == 24) {
                tempArrOne = 0;
            }
        } else if (temp == "-1") {
            if (tempArrTwo == 30) {
                tempArrTwo = 0;
                tempArrOne = tempArrOne;
            } else if (tempArrTwo == 0) {
                tempArrTwo = 30;
                tempArrOne = tempArrOne - 1;
            }
            if (tempArrOne == -1) {
                tempArrOne = 23;
            }
        }
        resultTime = addZero(tempArrOne) + ":" + addZero(tempArrTwo);
        return resultTime;
    }
    this.getShowTime = function() {
        var hour_min = (this._timeStart - this._timeStart % 60) / 60;
        var minute_min = this._timeStart % 60;
        if (minute_min < 30) {
            this._pageTime = this._addZero(hour_min) + ":" + "00";
            this._timeStart = hour_min * 60;
        } else {
            this._pageTime = this._addZero(hour_min) + ":" + "30";
            this._timeStart = hour_min * 60 + 30;
        }
        if (this._pageTime >= "22:00") {
            this._pageTime = "22:00";
            this._timeStart = 22 * 60;
        }
    }
    this.getChanIndex = function() {
        this._chanIndex = (this.currRow + this._chanStartIndex + this._chanDataSize) % this._chanDataSize;
    }
    this._chanIndex = (this.currRow + this._chanStartIndex + this._chanDataSize) % this._chanDataSize;

}

function showChannelList() {
    for (var i = 0; i < 10; i++) {
        if (i < channel_curPageSize) {
//            $("channel_" + i).innerHTML = addZeroChannel(channelDataObject[i].MixNo);
//            $("channel_" + i).style.color = "#000000";
//            $("channelName_" + i).innerText = writeFitString(trimSuffix(channelDataObject[i].ChannelName), 22, 140);
            $("channelName_" + i).innerText =channelDataObject[i].ShowChannelName ;
            $("mixNo_" + i).innerText =addZeroChannel(channelDataObject[i].MixNo);
//            $("mixNo_" + i).innerText =addZeroChannel(-1);
//            $("channelName_" + i).style.color = "#000000";
//            $("markURL_" + i).src = channelDataObject[i].MarkURL;
        } else {
//            $("channel_" + i).innerText = "";
            $("channelName_" + i).innerText = "";
            $("mixNo_" + i).innerText ="";
//            $("markURL_" + i).src = "images/btn_trans.gif";
        }
    }
    if(channelDataObject.length> 0)
    {
        $("showpage").innerHTML = channelDataObject[0].CurPage + "/"+ channelDataObject[0].Pagecount;
    }
    curChannelIndex = curChannelPos;
}
/*
 *刷新时间轴
 */

function showTimeLine(){
        if(lineTimeout){
            clearTimeout(lineTimeout);
        }
//         lineTimeout = window.setTimeout("showTimeLine()",1000*5*60);
//         showTimeLineResponse();
          var requestUrl = "action/getnowtime1.jsp";
          var loaderSearch = new net.ContentLoader(requestUrl, showTimeLineResponse);

//      alert("===sml===frame===.jsp====requestUrl--->"+requestUrl);
          
      }

  var curtime1 = null;

  function showTimeLineResponse(){
      var results = this.req.responseText;
      var timedata = eval("(" + results + ")");
//      var timedata = new Date();
//      var _year = timedata.getFullYear();
//      var _month = timedata.getMonth()+1;
//      var _day = timedata.getDate();
//      if((_month+"").length<2){
//          _month = "0"+_month;
//      }
//      if((_day+"").length<2){
//          _day = "0"+_day;
//      }
      $('time_plant').style.visibility='hidden';
      $('time_line').style.visibility='hidden';
//           	    ts_m = tstime.getMonth()+1;
//     	    ts_d = tstime.getDate();
//      var year = _year+"."+_month+"."+_day;
//        var hours = timedata.getHours();
//        var minutes = timedata.getMinutes();
      curtime1 = timedata.year;
      var year = timedata.year;
      //显示当前系统取到的日期
      var hours = timedata.hour;
      var minutes = timedata.minute;
      now_minutes = hours*60+parseInt(minutes);

//      alert("SSSSSSSSSSSSSSSSS111now_minutes="+now_minutes);
      var hourSpace = hours - timeStart;
      var minuteSpace = -1;
//      alert("HHHHHHHHHyear="+year);
//      alert("HHHHHHHHHdateInfo[curDayIndex].Date="+dateInfo[curDayIndex].Date);
      if(year == dateInfo[curDayIndex].Date){
         if(hourSpace>=0){
             var minuteSpace = hourSpace*60+parseInt(minutes);
//             minuteSpace = 119;
             pageShowTimeline(minuteSpace);
//             var minuteparam = minuteSpace/120;
//             var redWidth = minuteparam*928;
//             var leftpos = 300+redWidth;
//             if(minuteparam>1){
////                 alert("22222222222222222222222222222");
//                 redWidth = 928;
//             }else{
//                 $('time_line').style.visibility='visible';
//                 $('time_line').style.left = leftpos+"px";
//             }
////             alert("1111111111111111111111111111redWidth="+redWidth);
//             $('time_plant').style.visibility='visible';
//             $('time_plant').style.width = redWidth+"px";
        }
      }else if(year < dateInfo[curDayIndex].Date){
//          alert("33333333333333333333333333333");
          return;
      }else{
//          alert("4444444444444444444444444444");
//         $('time_line').style.visibility='visible';
//         $('time_line').style.left = 1228+"px";
         $('time_plant').style.visibility='visible';
         $('time_plant').style.width = programWidth+"px";
      }

  }

function pageShowTimeline(minute,iscom){
    if(lineTimeout){
        clearTimeout(lineTimeout);
    }
    now_minutes =parseInt(minute)+timeStart*60
//    alert("SSSSSSSSSSSSSSSSSSSnow_minutes="+now_minutes);

    if(minute < 120){
         var minuteparam = minute/120;
         var redWidth = minuteparam*programWidth;
         var leftpos = programAreaLeft+redWidth-4;
             $('time_line').style.visibility='visible';
             $('time_line').style.left = leftpos+"px";
         $('time_plant').style.visibility='visible';
         $('time_plant').style.width = redWidth+"px";
         minute++;
        lineTimeout = setTimeout("pageShowTimeline("+minute+",1)",1000*1*60);
    }else {
//        $('time_line').style.visibility='visible';
//        $('time_line').style.left = leftpos+"px";
        $('time_plant').style.visibility='visible';
        $('time_plant').style.width = "882px";
    }
}
//curChannelPos = "0";

//ProgTableObj(120, 819, channel_pageNum, 12, sml, 0, 16 * 60, curChannelPos, 0);

function init(data, _starttime){
    if (data.length > 0){
        if(doOther == 4 && channel_pageAll > 0){
            progTableObj._loseFocus();
        }
        timeStart = _starttime;
        channelDataObject = data;
        channel_curPage = parseInt(channelDataObject[0].CurPage);
        channel_pageAll = parseInt(channelDataObject[0].Pagecount);
        channel_curPageSize = channelDataObject.length;
	if(channel_curPageSize > 10){
	channel_curPageSize = 10;
	}
        var colLength = 1;
        var curRowid =  channelDataObject[0].Rowid;
        if(curChannelPos == 0 && curRowid != -1 ){
            curChannelPos =  parseInt(curRowid);
        }
        if(curChannelPos != -1){
             colLength =  channelDataObject[curChannelPos].ProgramList.length;
        }
        if(turnPageAction == "init"){
            if(colLength > 0 && (isFocus == 0 || isFocus == "0")){
                curChannelcols = parseInt(channelDataObject[curChannelPos].ProgramList[colLength-1].programfocus);
            }
        }else if(turnPageAction=='left'){
            if(colLength > 0){
                var tdId = "td" + curChannelPos + "" + 0;
                $(tdId).style.background = "none";
                curChannelcols = colLength -1;
            }
            else{
                curChannelcols = 0;
            }
        }else if(turnPageAction=='right'){
            curChannelcols = 0;
        }else if(turnPageAction=='up'){
            $("programFocusImg_0").style.visibility = "hidden";
                curChannelPos = channel_curPageSize-1;
                if(colLength > 0)
                {
                	if(channelDataObject[curChannelPos].ProgramList[colLength-1]!=undefined && channelDataObject[curChannelPos].ProgramList[colLength-1]!=null){
                		curChannelcols = parseInt(channelDataObject[curChannelPos].ProgramList[colLength-1].programfocus);
                	}else{
                		curChannelcols = 0;
                	}
                    
                }
                if(isNaN(curChannelcols)){
                   curChannelcols = 0;
                }
        }else if(turnPageAction=='down'){
                curChannelPos = 0;
                var colLength =  channelDataObject[curChannelPos].ProgramList.length;
                if(colLength > 0)
                {
                    curChannelcols = parseInt(channelDataObject[curChannelPos].ProgramList[colLength-1].programfocus);
                }
                if(isNaN(curChannelcols)){
                   curChannelcols = 0;
                }
        }
        if(progTableObj && $('td'+progTableObj.currRow+progTableObj.currCol)){
            $('td'+progTableObj.currRow+progTableObj.currCol).style.backgroundColor="";
        }
        progTableObj = new ProgTableObj(120, programWidth, channel_pageNum, 12, data, 0, _starttime * 60, curChannelPos, curChannelcols);
        progTableObj.drawProgTable();
        showLeftAndRightArr();
        if(turnPageAction == "up" || turnPageAction == "down" || turnPageAction == "prePage" || turnPageAction == "nextPage"){
        showChannelList();
        }else if(turnPageAction == "right" || turnPageAction == "left" || turnPageAction == "preDay" || turnPageAction == "nextDay"){
            showCurTime();
            showTimeLine();
        }else{
            showChannelList();
            showCurTime();
            showTimeLine();
        }
    }else{
        timeStart = _starttime;
        channelDataObject = data;
        channel_curPage = 0;
        channel_pageAll = 0;
        channel_curPageSize = 0;
        curChannelPos = 0;
        curChannelcols = 0;
        progTableObj = new ProgTableObj(120, programWidth, channel_pageNum, 12, data, 0, _starttime * 60, curChannelPos, curChannelcols);
        progTableObj.drawProgTable();
        $("showpage").innerText = "0/0";
        $("channelDesc_").innerHTML = "";
        hiddenRefreshBarDiv();
        $("showIcon").innerHTML= "";
        showChannelList();
        showCurTime();
        showTimeLine();
    }
    freefocusTimeOut = setTimeout("freeGetingData()",500);
}

//请求数据保护加载  延时0.5秒
function freeGetingData(){
    isGetingData = 0;
    if(doOther == 1)
    {
        progTableObj._getFocus();
    }
}
function showLeftAndRightArr(){
    return ;
    if(curDayIndex == 0 && timeStart == 0)
    {
         $("timeleft").style.visibility = "hidden";
    }
    else if($("timeleft").style.visibility == "hidden")
    {
        $("timeleft").style.visibility = "visible";
    }
    if(curDayIndex == dateInfo.length -1 && timeStart == 22)
    {
        $("timerigth").style.visibility = "hidden";
    }else if($("timerigth").style.visibility == "hidden")
    {
         $("timerigth").style.visibility = "visible";
    }
}
