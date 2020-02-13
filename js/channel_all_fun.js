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
                 $("tv" + ctopindex + curindex).style.visibility = "visible";
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
                window.setTimeout("getInfo("+i+","+despageL[i].page+")",200);
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
        tvInfoL[curIndex].leng=tvDs.length;
        if (tvDs.length > 0) {
             if( cDs.totalcountL>parseInt(tvDs.length)+parseInt(proIndexL[curIndex].count)){
                $("down" + curIndex).style.visibility = "visible";
             }
             if(tvDs.length<proLeng+1){
                $("down" + curIndex).style.visibility = "hidden";
             }
             for (var i = 0; i < tvDs.length; i++) {
                 var maxn = tvDs[i].MixNo;
                 if (maxn.length == 1) {
                     maxn = "00" + maxn;
                 } else if (maxn.length == 2) {
                     maxn = "0" + maxn;
                 }
                 $("max" + curIndex + i).innerText = maxn+" "+writeFitStringNirui(tvDs[i].programName,123, 22,13 ,11);
             }
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
      }

    function tvKeyPress(evt) {
        var keyCode = parseInt(evt.which);
        if (keyCode == 0x0008) {///back
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
       return true;
    }

    function commonKeyPress(evt){
        var keycode = evt.which;
        if(keycode==0x0101){ 
              _window.top.remoteChannelPlus();
        }else if(keycode==0x0102){
              _window.top.remoteChannelMinus();
        }else if(keycode == 0x0110){
           // Authentication.CTCSetConfig("KeyValue","0x110");
            _window.top.mainWin.document.location = "portal.jsp";
        }else if (keycode == 0x0008){
            _window.top.mainWin.document.location = "back.jsp";
        }else{
            _window.top.doKeyPress(evt);
        }
    }

       //ok
    var pageUps =function(){
         if(tvInfoL[ctopindex].leng>0){
            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            pageUp();
            curindex=0;
            $("tv" + ctopindex + curindex).style.visibility = "visible";
         }
    }
    var pageDowns=function(){
        if(tvInfoL[ctopindex].leng>0){
           $("tv" + ctopindex + curindex).style.visibility = "hidden";
           pageDown();
            curindex=0;
          $("tv" + ctopindex + curindex).style.visibility = "visible";
        }
    }
    function doOK(){
      if(tvInfoL[ctopindex].leng>0){
         changeDs();
          var saveInfo=ctopindex+"_"+curindex;
          var pageInfo="";
          for(var a=0;a<topLeng;a++){
           pageInfo=pageInfo+"_"+despageL[a].page;
          }
          saveInfo=saveInfo+pageInfo;
//          window.opener.top.mainWin.document.location = "channel_play.jsp?mixno=" + curMaxNo + "&leefocus=" + saveInfo;
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
            if ($("fav_0").src == "images/vod/btv-btn-cancelclick.png") {
                //进入TV收藏
                closeMessage();
                document.onkeypress=tvKeyPress;
//                window.opener.top.mainWin.document.location = "favorite_portal.jsp";
                _window.top.mainWin.document.location = "favorite_portal.jsp";
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
     }
    function pageDown() {
        var cpages = parseInt(despageL[ctopindex].page) + 1;
        if (cpages <= pagecountL[ctopindex].count) {
            $("up" + ctopindex).style.visibility = "visible";
            despageL[ctopindex].page = cpages;
            clearTvInfo();
            getInfo(ctopindex,cpages);
            //proIndexL[ctopindex].count=proLeng*(cpages-1)+1;
            proIndexL[ctopindex].count=(proLeng+1)*(cpages-1);
          //  alert('SSSSSSSSproIndexL[ctopindex].count='+proIndexL[ctopindex].count);
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
    var getInfo=function(id,pages){
        var requestUrl = "action/channel_all_program_data.jsp?columnid=" + columnDs[id].columnid + "&destpage=" + pages+"&curIndex="+id;
        var loaderSearch = new net.ContentLoader(requestUrl, channelProgramOnlyOne);
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
//        alert("+++++++++++++++++++++++++++++++goDown++++++++++++++++++++");
        if(tvInfoL[ctopindex].leng>0){
//            alert("+++++++++++++++++++++++++++++++goDown1111111++++++++++++++++++++");
            curLeng=tvInfoL[ctopindex].leng;
            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            curindex++;
          //  alert("curindexcurindexcurindexcurindex"+curindex);
           // alert("curindex+proIndexL[ctopindex].count"+proIndexL[ctopindex].count);
            //alert("totalcountL[ctopindex].count"+totalcountL[ctopindex].count);
//            alert(typeof proIndexL[ctopindex].count == 'number');
            //if (curindex >= curLeng&&curLeng>0&&totalcountL[ctopindex].count>parseInt(curindex)+parseInt(proIndexL[ctopindex].count)) {
            if (curindex >= curLeng&&curLeng>0&&totalcountL[ctopindex].count>=curindex+proIndexL[ctopindex].count+1) {
//              alert('+++++++++++++++++++++++++============yao fen ye');
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
                $("tv" + ctopindex + curindex).style.visibility = "visible";
                goBytimes();
//            }
        }
    }
    function pageUpDown(){
       var requestUrl = "action/channel_all_program_data.jsp?columnid=" + columnDs[ctopindex].columnid + "&destpage=" + despageL[ctopindex].page+"&curIndex="+ctopindex+"&UpDown=1&proIndex="+proIndexL[ctopindex].count;
       var loaderSearch = new net.ContentLoader(requestUrl, channelProgramOnlyOne);
    }
    function goUp() {
        curLeng = tvInfoL[ctopindex].leng;
        if (curLeng > 0) {
            $("tv" + ctopindex + curindex).style.visibility = "hidden";
            curindex--;
//            alert('+++++++++++++++++++++++goUp++++++++++++++++');
//            alert(typeof proIndexL[ctopindex].count == 'number');
            if (curindex < 0 && curLeng > 0 && proIndexL[ctopindex].count > 0) {
                proIndex = proIndexL[ctopindex].count;
                proIndex--;
                proIndexL[ctopindex].count = proIndex;
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
            $("tv" + ctopindex + curindex).style.visibility = "visible";
            goBytimes();
//            }
        }
    }
    function goLeft() {
        $("tv" + ctopindex + curindex).style.visibility = "hidden";
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
        $("tv" + ctopindex + curindex).style.visibility = "visible";
            goBytimes();
        }
        proIndex=0;
    }
    function goRight() {
        $("tv" + ctopindex + curindex).style.visibility = "hidden";
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
            $("tv" + ctopindex + curindex).style.visibility = "visible";
            goBytimes();
        }
        proIndex=0;
    }