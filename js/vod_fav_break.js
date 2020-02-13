function $(id) {
    if (!$$[id]) {
        return document.getElementById(id);
    }
    return $$[id];
}
var gotoUrl = function() {
    if (leftindex == 0) {
        document.location = "favorite_portal.jsp?menuindex=0";
    } else if(leftindex==3){
       document.location = "favorite_service.jsp";
    }else if (leftindex != leftstate) {
        datetype=leftindex;
        index = 0;
        destpage = 1;
        pageCount = 1;
        leftstate = leftindex;
        requestDataSource();
    }
}
var leftSetTime = function() {
    if (leftFocusTime) {
        window.clearTimeout(leftFocusTime);
    }
    leftFocusTime = window.setTimeout("gotoUrl()", 1000);
}
function init() {
    if (lastfocus != "" && lastfocus != null && lastfocus != "undefined" && lastfocus != "null") {
        var paramArr = lastfocus.split("_");
        leftstate = paramArr[0];
        leftindex = paramArr[1];
        destpage = paramArr[2];
        index = paramArr[3];
        isleft = eval(paramArr[4]);
        datetype=leftindex;
    }
    requestDataSource();
}
function cleardiv() {
    for (var i = 0; i < 10; i++) {
        $("focus_bg" + i).style.visibility = "hidden";
        $("focus_img" + i).src = "images/btn_trans.gif";
        $("focus_name" + i).innerText = "";
        $("focus_name" + i).style.visibility = "hidden";

        $("vod_img" + i).src = "images/btn_trans.gif";
        $("vod_name" + i).innerText = "";
        $("vod_name" + i).style.visibility = "hidden";

        $("bg_x" + i).style.visibility = "hidden";
        $("focus_x" + i).style.visibility = "hidden";
        $("f_img" + i).width = "66";
        $("f_img" + i).height = "66";
        $("f_img" + i).src = "images/channel/btv-mytv-cancelclick.png";
    }
}
function requestDataSource() {
    cleardiv();
    if (datetype == 1) {
        var requestUrl = "action/favorite_datas.jsp?destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, showdata);
    } else if (datetype == 2) {
        var requestUrl = "action/favorite_bookMark_datas.jsp?destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, showdata);
    }
}
function showdata() {
    var results = this.req.responseText;
    data = eval("(" + results + ")");
    arr = data.Data;
    destpage = data.destpage;
    pageCount = data.pageCount;
    leng = arr.length;
    if (leng > 0) {
        for (var i = 0; i < leng; i++) {
            $("vod_img" + i).src = arr[i].normalposter;
            $("vod_name" + i).innerText = writeFitString(arr[i].programname, 18, 130);
            $("vod_name" + i).style.visibility = "visible";
            var frow = parseInt(i / 5);
            var fcol = i % 5;
            var fleft = fcol * 180-20;
            var ftop = 17 + frow * 248;
            $("focus_x"+i).style.left=fleft;
            $("focus_x"+i).style.top=ftop;
            for (var j = 0; j < selectArr.length; j++) {
                if (arr[i].selectIndex == selectArr[j].selectIndex) {
                    $("bg_x" + i).style.visibility = "visible";
                    $("f_img" + i).src = "images/channel/tv_Xico.png";
                    $("f_img" + i).width = "36";
                    $("f_img" + i).height = "37";
                    $("focus_x"+i).style.left+=20;
                    $("focus_x"+i).style.top+=20;
                }
            }
        }
    }else{
        isleft=true;
    }
    if(isleft==true){
         leftFocusBar("images/portal/focus.png");//焦点在左边栏目上
    }else{
         changeImg(1);
         leftFocusBar("images/vod/btv_column_focus.png");//焦点在右边节目上
    }
    showScrollBar();
}
function leftFocusBar(img) {
    if (leftindex == 1) {
        $("left1").src = img;
        $("left2").src = "images/btn_trans.gif";
    } else if (leftindex == 2) {
        $("left2").src = img;
        $("left1").src = "images/btn_trans.gif";
    }
}
function showDellIcon() {

}
function showScrollBar() {
    if (leng > 0) {
        var heightX = parseInt(504 / pageCount);
        var topX = 3 + heightX * (destpage - 1)
        $("scrollbar2").height = heightX;
        $("scroll").style.top = topX;
        $("pageBar").style.visibility = "visible";
    } else {
        $("pageBar").style.visibility = "hidden";
    }
}

function favoriteKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown
        favoriteKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        favoriteKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        favoriteKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        favoriteKeyRight();
    } else if (keyCode == 0x0008) {///back
        favoriteBack();
    } else if (keyCode == 0x0022) {  //page down
        favoritepageNext();
    } else if (keyCode == 0x0021) { //page up
        favoritepagePrev();
    } else if (keyCode == 0x0113) { //yellow
        //                favoritedo();
    } else if (keyCode == 0x0116) {  //green
        //                goSearch();
    } else if (keyCode == 0x000D) {  //OK
        favoriteKeyOK();
    } else {
        //                clearStack();
        commonKeyPress(evt);
        return true;
    }
    return false;
}
function favoriteKeyDown() {
    if (isleft) {
        changeImg(-1);
        if (leftindex >= 0 && leftindex < 3) {
            leftindex++;
        } else {
            leftindex = 0;
        }
        changeImg(1);
        leftSetTime();
    } else {
        if (isTop) {
            topFcous(-1);
        } else {
            changeImg(-1);
            if (parseInt(index) + 5 < leng) {
                index = parseInt(index) + 5;
            }
            changeImg(1);
        }
    }
}
function favoriteKeyUp() {
    if (isleft) {
        changeImg(-1);
        if (leftindex > 0 && leftindex <= 3) {
            leftindex--;
        } else {
            leftindex = 3;
        }
        changeImg(1);
        leftSetTime();
    } else {
        if (!isTop) {
            if (leng > 5 && index >= 5) {
                changeImg(-1);
                index = index - 5;
                changeImg(1);
            } else {
                topFcous(1);
            }
        }
    }
}
function topFcous(flag) {
    if (flag == 1) {
        isTop = true;
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
        changeImg(-1);
    } else {
        isTop = false;
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
        changeImg(1);
    }
}
function favoriteKeyLeft() {
    if (!isleft) {
        if (isTop) {
            if (topindex > 0 && topindex <= 1) {
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                topindex--;
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
            } else {
                isTop = false;
                isleft = true;
                $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
                changeImg(1);
            }
        } else {
            if (index == 0 || index == 5) {
                leftindex=datetype;
                changeImg(-1);
                $("left" + leftindex).src = "images/portal/focus.png";
                isleft = true;
                leftSetTime();
            } else {
                if (index >= 0 && index < leng) {
                    changeImg(-1);
                    index--;
                    changeImg(1);
                }
            }
        }
    }
}
function favoriteKeyRight() {
    if (isleft == true && leng > 0) {
        isleft = false;
        changeImg(1);
        $("left" + leftindex).src = "images/btn_trans.gif";
        leftindex=datetype;
        $("left" + datetype).src = "images/vod/btv_column_focus.png";
        if (leftFocusTime) {
            window.clearTimeout(leftFocusTime);
        }
    } else {
        if (isTop) {
            $("top" + topindex).src = "images/vod/btv-02-add-bookmarkquit.png";
            if (topindex >= 0 && topindex < 1) {
                topindex++;
            } else {
                topindex = 0;
            }
            $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
        } else if(leng >0) {
            changeImg(-1);
            if (index >= 0 && index < leng - 1) {
                index++;
            } else {
                index = 0;
            }
            changeImg(1);
        }
    }
}
function favoriteBack() {
    document.location = "back.jsp";
}
function favoritepageNext() {
    if (pageCount > 1 && destpage < parseInt(pageCount)) {
        index = 0;
        destpage++;
        requestDataSource();
    }
}
function favoritepagePrev() {
    if (destpage > 1) {
        index = 0;
        destpage--;
        requestDataSource();
    }
}
function favoriteKeyOK() {
    if (isleft) {
        leftMenuOK();
    } else {
        if (isTop) {
            topOK();
        } else {
            favoriteRightOK();
        }
    }
}
function leftMenuOK() {
    if (leftindex == 0) {
        document.location = "favorite_portal.jsp?menuindex=0";
    } else if (leftindex == 1 || leftindex == 2) {
        index = 0;
        destpage = 1;
        pageCount = 1;
        leftstate = leftindex;
        datetype=leftindex;
        requestDataSource();
    }else if(leftindex==3){
        document.location = "favorite_service.jsp";
    }
}

function clearList() {
    if (leftindex == 1) { //清空收藏
        var requestUrl = "action/favorite_del.jsp?type=all";
        var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
    } else {//清空书签
        var requestUrl = "action/bookpoint_del.jsp?type=all";
        var laderSearch = new net.ContentLoader(encodeURI(encodeURI(requestUrl)), showdellFav);
    }
}

function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    clearTimeout(timer);
    refresh();
}
function refresh() {
    isTop = false;
    selectArr = new Array();
    index = 0;
    destpage = 1;
    init();
}
function favoriteRightOK() {
    if (isShow) {
        if($("f_img" + index).src != "images/channel/tv_Xico.png") {
            pushList();
            $("bg_x" + index).style.visibility = "visible";
            $("f_img" + index).src = "images/channel/tv_Xico.png";
            $("f_img" + index).width = "36";
            $("f_img" + index).height = "37";
            $("focus_x" + index).style.top+=20;
            $("focus_x" + index).style.left+=20;
        }else{
            pushList();
            $("bg_x" + index).style.visibility = "hidden";
            $("f_img" + index).src = "images/channel/btv-mytv-cancelclick.png";
            $("f_img" + index).width = "66";
            $("f_img" + index).height = "66";
            $("focus_x" + index).style.top-=20;
            $("focus_x" + index).style.left-=20;
        }
    } else {
       goVodDetail();
    }
}
function  goVodDetail(){
   if(arr[index].programid=="" || arr[index].programid==null || arr[index].programid=="null" || arr[index].programid=="undfined"){
        showDetailMsg();
   }else{
       var leefocus = leftstate + "_" + leftindex + "_" + destpage + "_" + index+"_"+isleft;
        if (arr[index].programtype == "0" || arr[index].programtype == "100") {
            var url = "vod_detail.jsp?columnid=" + arr[index].columnid
                    + "&programid=" + arr[index].programid
                    + "&programtype=" + arr[index].programtype
                    + "&contentid=" + arr[index].contentcode
                    + "&from=" + leftindex
                    + "&columnpath="
                    + "&programname=" + arr[index].programname + "&leefocus=" + leefocus;
            document.location = encodeURI(encodeURI(url));
        } else if (arr[index].programtype == "1") {
            var url = "vod_series_list.jsp?columnid=" + arr[index].columnid
                    + "&programid=" + arr[index].programid
                    + "&leefocus=" + leefocus
                    + "&from=" + leftindex
                    + "&columnpath="
                    + "&seriesnum=" + arr[index].Seriesnum
                    + "&programtype=" + arr[index].programtype
                    + "&contentid=" + arr[index].contentcode
                    + "&programname=" + arr[index].programname;
            +"&seriesprogramcode=" + arr[index].programid + "&vodtype=100";
            document.location = encodeURI(encodeURI(url));
        }
   }
}
function pushList() {
    var flag = true;
    for (var i = 0; i < selectArr.length; i++) {
        if (arr[index].selectIndex == selectArr[i].selectIndex) {//当前选择的已经在列表里面了
            selectArr.splice(i,1);
            flag = false;
        }
    }
    if (flag) {
        selectArr[selectArr.length] =
        {
            programid:arr[index].programid,
            selectIndex:arr[index].selectIndex,
            programname:arr[index].programname,
            columnid:arr[index].columnid,
            contentid:arr[index].contentcode,
            seriesid:arr[index].vSeriesprogramcode,
            curIndex:index
        };
    }
}
function changeImg(flag) {
    if (!isleft) {
        if (flag == 1) {
            $("vod_name" + index).style.visibility = "hidden";

            $("focus_bg" + index).style.visibility = "visible";
            //获取焦点背景图
            $("focus_img" + index).src = arr[index].normalposter;
            $("focus_name" + index).innerText = writeFitString(arr[index].programname, 20, 130);
            $("focus_name" + index).style.visibility = "visible";
            if (isShow) {
                $("focus_x" + index).style.visibility = "visible";
            }
        } else {
            $("focus_bg" + index).style.visibility = "hidden";  //失去焦点背景图
            $("focus_img" + index).src = "images/btn_trans.gif";
            $("focus_name" + index).style.visibility = "hidden";

            $("vod_name" + index).style.visibility = "visible";
            if (isShow) {
                $("focus_x" + index).style.visibility = "hidden";
            }
        }
    } else {
        if (flag == 1) {
            $("left" + leftindex).src = "images/portal/focus.png";
        } else {
            $("left" + leftindex).src = "images/btn_trans.gif";
        }
    }
}
function cancelKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    if (keyCode == 0x0028) { //onKeyDown

    } else if (keyCode == 0x0026) {//onKeyUp

    } else if (keyCode == 0x0025) { //onKeyLeft
        cancelKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        cancelKeyRight();
    } else if (keyCode == 0x0008) {///back

    } else if (keyCode == 0x000D) {  //OK
        cancelKeyOK();
    } else {
        commonKeyPress(evt);
        return true;
    }
    return false;
}
function cancelKeyLeft() {
    clearbar = true;
    $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
    $("doY").src = "images/vod/btv-02-add-bookmarkc.png";
}
function cancelKeyRight() {
    clearbar = false;
    $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
    $("doN").src = "images/vod/btv-02-add-bookmarkc.png";
}
function cancelKeyOK() {
    if (!clearbar) {
        $("clearInfo").style.visibility = "hidden";
        $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("top" + topindex).src = "images/vod/btv-02-add-bookmarkc.png";
    } else {
        $("clearInfo").style.visibility = "hidden";
        $("doN").src = "images/vod/btv-02-add-bookmarkquit.png";
        $("doY").src = "images/vod/btv-02-add-bookmarkquit.png";
        clearList();
    }
    document.onkeypress = favoriteKeyPress;
}
document.onkeypress = favoriteKeyPress;