var loadProgram =1;
var loadColumn =1;
var loadColumnTime = null;
var lastvdestpage = 0;

var stbType= Authentication.CTCGetConfig("STBType");
var flag_jumplive = 0;

if(stbType==null||stbType==undefined||typeof stbType=="undefined"){
    stbType= Authentication.CUGetConfig("STBType");
}
if(stbType==null||stbType==undefined||typeof stbType=="undefined"){
	stbType= "";
}
function $(id) {
    if (!$$[id]) {
        $$[id]=document.getElementById(id);
    }
    return $$[id];
}
//初始化页面数据
function init(flag) {
    $("path").innerText="";
    if(flag != 'back'){
        pathstr = new Array();
    }
    initParam();
    loadPage();
}

function setLoadColumn(){
    loadColumn = 0;
    if(loadColumnTime){
        window.clearTimeout(loadColumnTime);
    }
    loadColumnTime = window.setTimeout(function(){
        loadColumn = 1;
    },1000);
}

//请求栏目数据
function loadPage() {
    setLoadColumn();
    if(tempDestpage!=1){
        cdestpage = tempDestpage;
        tempDestpage = 1;
    }
    var requestUrl = "action/vod_columnlist.jsp?columnid=" + columnid + "&destpage=" + cdestpage;
    var loaderSearch = new net.ContentLoader(requestUrl, showColumn);
    // alert("++clumeId_start=="+carr[cindex].columnid);
}

//请求右边的二级栏目数据
function loadChirld() {
    var requestUrl = "action/vod_columnlist.jsp?columnid=" + subcolumnid + "&destpage=" + subdestpage + "&numberperpage=8";
    var loaderSearch = new net.ContentLoader(requestUrl, showChirldColumn);
}
//展示左边栏目数据
function showColumn() {
   
    var results = this.req.responseText;
    catedata = eval("(" + results + ")");
    carr = catedata.columnData;
    cdestpage = catedata.destpage;
    cpagecount = catedata.pageCount;
    cleng = carr.length;
  if(topicindex !== 0){
        cindex = topicindex;
        topicindex = 0;
    }else if(action == "up"){
        cindex = cleng-1;
    }
    $("columnbar" + cindex).src = "images/btn_trans.gif";
    for (var i = 0; i < 9; i++) {
        if (i < cleng) {
            $("column_div" + i).innerText = writeFitString(carr[i].columnname, 18, 120);
			$("columnbar" + i).src = "images/btn_trans.gif";
        } else {
            $("column_div" + i).innerText = "";
            $("columnbar" + i).src = "images/btn_trans.gif";
        }
    }
    if (cleng > 0) {
        pathstr[pathstr.length] = carr[cindex].columnname.substr(0, 9);
        showColumnPath();
        /*
         *左边栏目子栏目，右侧展示该栏目的子栏目，否则展示vod
         */
        if (carr[cindex].subExist == "1") {
            stopVodScroll();
            subcolumnid = carr[cindex].columnid;
            if(isReallyZTE == true){
                $("sucolumn").style.visibility = "visible";
                $("vodDiv").style.visibility = "hidden";
                $("line_vodDiv").style.visibility = "hidden";
            }else{
                $("sucolumn").style.display = "block";
                $("vodDiv").style.display = "none";
                $("line_vodDiv").style.display = "none";
            }
            showChirld = true;
subdestpage = 1;
            loadChirld();
        } else {
            vcolumnid = carr[cindex].columnid;
//            $("sucolumn").style.visibility = "hidden";
//            $("vodDiv").style.visibility = "visible";
            testLineColumn(vcolumnid);
            if(lineColumn == ""){
                if(isReallyZTE == true){
                    $("sucolumn").style.visibility = "hidden";
                    $("line_vodDiv").style.visibility = "hidden";
                    $("vodDiv").style.visibility = "visible";
                }else{
                    $("sucolumn").style.display = "none";
                    $("line_vodDiv").style.display = "none";
                    $("vodDiv").style.display = "block";
                }
            }else{
                if(isReallyZTE == true){
                    $("sucolumn").style.visibility = "hidden";
                    $("vodDiv").style.visibility = "hidden";
                    $("line_vodDiv").style.visibility = "visible";
                }else{
                    $("sucolumn").style.display = "none";
                    $("vodDiv").style.display = "none";
                    $("line_vodDiv").style.display = "block";
                }
            }
            showChirld = false;
           if(lastvdestpage != 0){
                vdestpage = lastvdestpage;
                lastvdestpage = 0;
            }else{
                vdestpage = 1;
            }
            showVodList();
        }
    }
    $("listMsg").style.visibility = cleng > 0 ? "hidden" : "visible";
    if(cleng<=0)$("path").innerText =" ";
    showPage();
    document.onkeypress = cateKeyPress;
}



/*
展示子栏目数据，
 */
function showChirldColumn() {
	for(var q=0; q<8 ; q++){
		 $("column_img" + q).src = "images/btn_trans.gif";
            $("column_bg" + q).style.visibility = "hidden";
            $("sub_column" + q).innerText = "";

            $("fcolumn_img" + q).src = "images/btn_trans.gif";
            $("fcolumn_bg" + q).style.visibility = "hidden";
            $("fcolumn_bgb" + q).style.visibility = "hidden";
            $("fsub_column" + q).innerHTML = "";
            $("fsub_column" + q).style.visibility = "hidden";
	}
	top.jsDebug("==showChirldColumn 333==");
    loadProgram = 1;
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    subarr = data.columnData;
    subdestpage = data.destpage;
	top.jsDebug("==subdestpage 111=="+subdestpage);
    subpagecount = data.pageCount;
	top.jsDebug("==subpagecount 111=="+subpagecount);
    subleng = subarr.length;
    top.jsDebug("==subleng 111=="+subleng);
    for (var i = 0; i < 8; i++) {
		top.jsDebug("==i+ 111=="+i);
        if (i < subleng) {
		   top.jsDebug("==columnname=="+subarr[i].columnid);	
            $("column_img" + i).src = subarr[i].columnposter;
            $("sub_column" + i).innerText = writeFitString(subarr[i].columnname, 18, 180);
            $("fcolumn_img" + i).src = subarr[i].columnposter;
            $("fsub_column" + i).innerText = writeFitString(subarr[i].columnname, 18, 180);
            $("column_bg" + i).style.visibility = "visible";
            $("sub_column" + i).style.visibility = "visible";

            $("fcolumn_pos" + i).style.visibility = "hidden";
            $("fcolumn_bg" + i).style.visibility = "hidden";
            $("fcolumn_bgb" + i).style.visibility = "hidden";
            $("fsub_column" + i).style.visibility = "hidden";
        } else {
            $("column_img" + i).src = "images/btn_trans.gif";
            $("column_bg" + i).style.visibility = "hidden";
            $("sub_column" + i).innerText = "";

            $("fcolumn_img" + i).src = "images/btn_trans.gif";
            $("fcolumn_bg" + i).style.visibility = "hidden";
            $("fcolumn_bgb" + i).style.visibility = "hidden";
            $("fsub_column" + i).innerHTML = "";
            $("fsub_column" + i).style.visibility = "hidden";
        }
    }
    if (subleng <= 0) {
        isleft = true;
    }
    $("listMsg").style.visibility=subleng>0 ? "hidden":"visible";
    if(isleft){
        textScroll(1);
        $("columnbar" + cindex).src = "images/portal/focus.png";
    }else{
        textScroll(-1);
        $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
        changeSubColumn(1);
    }
    showScrollBar(1);
}




/*
请求vod数据
 */
function showVodList() {
//  testLineColumn(vcolumnid);
    var requestUrl = "action/vod_datalist.jsp?columnid=" + vcolumnid + "&destpage=" + vdestpage;
    var loaderSearch = new net.ContentLoader(requestUrl, vodRequestData);
    //下线提示循环播放
    if(showTime){
        clearTimeout(showTime);
    }
    showHint();


}
//下线提示循环播放
var hinti=0;
var showTime=0;
function showHint(){
    for(var j=0; j<off_line_hint.length; j++){
        if(off_line_hint[j].category_id==vcolumnid){
            $("hint").style.visibility="visible";
            if(off_line_hint[j].hint.length==1){
                $("hint").innerHTML=off_line_hint[j].hint[0];
            }else{
                if(hinti<(off_line_hint[j].hint.length-1)){
                    $("hint").innerHTML=off_line_hint[j].hint[hinti];
                    hinti++;
                }else{
                    $("hint").innerHTML=off_line_hint[j].hint[hinti];
                    hinti=0;
                }
                showTime=setTimeout("showHint()",10000);
            }
            break;
        }else{
            //hinti=0;
            $("hint").innerHTML="";
            $("hint").style.visibility="hidden";
        }
    }
}

/**
 * 4K提示
 */
function alert4K(){

     //判断分类
    if( "1604"==carr[cindex].columnid ||"1602"==carr[cindex].columnid){

	   for(var i=0;i<model_4K.length;i++){
            //判断机顶盒型号
            if( model_4K[i].model.toLowerCase()==stbType.toLowerCase() ){
                
                return false;

            }
            
        }

        $("alert_4K").style.visibility ="visible";
                
        $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";

        loadColumn=0;

        return true;
        
    }else{
            $("alert_4K").style.visibility ="hidden";

    }
    
}


function hideAlert(){
   
    $("columnbar" + cindex).src = "images/portal/focus.png";
    $("alert_4K").style.visibility ="hidden";
    loadColumn=1;
}
/*
展示vod数据
 */
function vodRequestData() {
	top.jsDebug("===vodrequestData====");
    loadProgram = 1;
    var results = this.req.responseText;
    catedata = eval("(" + results + ")");
    varr = catedata.vodData;
    vdestpage = catedata.destpage;
    vpagecount = catedata.pageCount;
    vleng = varr.length;
    var templineColumn = lineColumn;
  //  alert("SSSSSSSSSSSSSSSSSSSSSSSSSSlineColumn="+lineColumn+"===length==="+vleng);
    for (var i = 0; i < 8; i++) {		
        if(i<vleng){
		//	alert("====i===="+i);
            $(templineColumn+"vod_img" + i).src = varr[i].normalposter;
            $(templineColumn+"vod_poster" + i).style.visibility = "visible";
            if(templineColumn == ""){
                $(templineColumn+"vod_name" + i).innerText = writeFitString(varr[i].programname, 20, 140);
            }else{
                $(templineColumn+"vod_name" + i).innerText = writeFitString(varr[i].programname, 20, 160);
            }
            $(templineColumn+"line_" + i).style.visibility = "visible";
        }else{
            $(templineColumn+"focus_bg" + i).style.visibility = "hidden";
            $(templineColumn+"line_" + i).style.visibility = "hidden";
            $(templineColumn+"fline_" + i).style.visibility = "hidden";
//            $("focus_img" + i).src = "images/btn_trans.gif";
            $(templineColumn+"focus_name" + i).innerHTML = "";

            $(templineColumn+"vod_img" + i).src = "images/btn_trans.gif";
            $(templineColumn+"vod_name" + i).innerText = "";
        }
    }
	//alert("=====finish====");

    $("listMsg").style.visibility = vleng > 0 ? "hidden" : "visible";

    /*弹出图片--跳直播
    根据二级分类ID判断
    */
    columnIdSecondArray();

    if (vleng <= 0) {
        isleft = true;
    }

    if (isleft) {
        textScroll(1);
        if(flag_jumplive == 1){
            $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
        }else{
            $("columnbar" + cindex).src = "images/portal/focus.png";
        }
    } else {
        textScroll(-1);
        $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
        clearTimeout(infotimer);
        infotimer = setTimeout('starVodScroll();', 200);
        changeVodImg(0);
    }
    showScrollBar(-1);
}

function commonKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0101) { //????????
        _window.top.remoteChannelPlus();
    } else if (keycode == 0x0102) {
        _window.top.remoteChannelMinus();
    } else if (keycode == 0x0110) {
       // Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 36) {
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008 || keycode == 24) {
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        _window.top.doKeyPress(evt);
    }
}

function cateKeyPress(evt) {
    var keyCode = parseInt(evt.which);
    action = "";
    if (keyCode == 0x0028) { //onKeyDown
        if(loadColumn!=1){
            return;
        }
        cateKeyDown();
    } else if (keyCode == 0x0026) {//onKeyUp
        if(loadColumn!=1){
            return;
        }
        cateKeyUp();
    } else if (keyCode == 0x0025) { //onKeyLeft
        cateKeyLeft();
    } else if (keyCode == 0x0027) { //onKeyRight
        cateKeyRight();
    } else if (keyCode == 0x0008 || keyCode == 24) {///back
        cateBack();
    } else if (keyCode == 0x0022) {  //page down
      if(loadColumn!=1){
            return;
        }
        pageNext();
    } else if (keyCode == 0x0021) { //page up
          if(loadColumn!=1){
            return;
        }
        pagePrev();
    } else if (keyCode == 0x0113) { //yellow
        favoritedo();
    } else if (keyCode == 0x0116) {  //green
        goSearch();
    } else if (keyCode == 0x000D) {  //OK
        cateKeyOK();
    } else {
        clearStack();
        closeMessage();
        _window.top.mainWin.commonKeyPress(evt);
        return true;
    }
    return false;
}

function pagePrev() {
    if (isleft == true) {  //左边栏目翻页
       if (cpagecount > 1) {
        loadColumn = 0;
        if (cdestpage > 1) {
          cdestpage--;
            }else{
                cdestpage = cpagecount;
            }
            $("columnbar" + cindex).src = "images/btn_trans.gif";
            pathstr.splice(pathstr.length - 1, 1);
          //  cdestpage--;
            vindex = 0;
            cindex = 0;
            loadPage();
        }
    } else {
        if (showChirld) {  //右侧子栏目翻页
         if (subpagecount > 1) {
            if (subdestpage > 1) {
                subdestpage--;
                }else if(subdestpage == 1){
                    subdestpage = subpagecount;
                }
                $("sub_column" + subindex).style.visibility = "visible";
                changeSubColumn(0);
                subindex = 0;
               // subdestpage--;
                loadChirld();
            }
        } else { //右侧vod翻页
            if(vpagecount > 1){
            if (vdestpage > 1) {
                  vdestpage--;
                }else if(vdestpage == 1){
                    vdestpage = vpagecount;
                }
                changeVodImg(1);
                vindex = 0;
             //   vdestpage--;
                showVodList();
            }
        }
    }
}
function pageNext() {
    // alert("SSSSSSSSSSSSSSSSSSSSSisleft="+isleft+"_"+showChirld);
    // alert("SSSSSSSSSSSSSSSSSSSSSisleft="+vpagecount+"_"+vdestpage);
    if (isleft == true) {
//        if (cpagecount > 1 && cdestpage < cpagecount) {
        if (cpagecount > 1) {
//            loadColumn = 0;
            $("columnbar" + cindex).src = "images/btn_trans.gif";
            pathstr.splice(pathstr.length - 1, 1);
            cindex = 0;
            vindex = 0;
            if(cdestpage < cpagecount){
                cdestpage++;
            }else{
                cdestpage = 1;
            }
            loadPage();
        }
    } else {
		//alert("fan======showChirld=="+showChirld);
        if (showChirld) {
			//top.jsDebug("==showChirld 1111=="+subpagecount);
            if (subpagecount > 1) {
                if(subdestpage < parseInt(subpagecount,10)){
                    subdestpage++;
                } else if(subdestpage == parseInt(subpagecount,10)){
                    subdestpage = 1;
                }
			//	top.jsDebug("==subdestpage 1111=="+subdestpage);
                $("sub_column" + subindex).style.visibility = "visible";
                changeSubColumn(0);
                subindex = 0;
     //           subdestpage++;
                loadChirld();
            }
        } else {
            if(vpagecount > 1){
                if(vdestpage < parseInt(vpagecount)){
                    vdestpage++;
                }else if(vdestpage == parseInt(vpagecount)){
                    vdestpage = 1;
                }
                changeVodImg(1);
                vindex = 0;
               // vdestpage++;
                showVodList();
            }
        }
    }
}
//
function pushValue(fcolumnid, destpage, cindex,subindex) {
    statckIndex[statckIndex.length] = fcolumnid;
    statckdestpage[statckdestpage.length] = destpage;
    arrcindex[arrcindex.length] = cindex;
    statcksubIndex[statcksubIndex.length]=subindex;
}
function savePageInfo() {
    //保存现场数据，以便返回时恢复现场
    var columnstr = "";
    var tempdestpage = "";
    var tempindex = "";
    var subcoumnindex="";
    if (statckIndex.length > 0) {
        for (var i = 0; i < statckIndex.length; i++) {
            columnstr = columnstr+statckIndex[i] + "-";
            tempdestpage = tempdestpage+statckdestpage[i] + "-";
            tempindex = tempindex+arrcindex[i] + "-";
            subcoumnindex=subcoumnindex+statcksubIndex[i]+"-";
        }
        _window.top.mainWin.top.jsSetControl("columnstr", columnstr.substring(0, columnstr.length - 1));
        _window.top.mainWin.top.jsSetControl("tempdestpage", tempdestpage.substring(0, tempdestpage.length - 1));
        _window.top.mainWin.top.jsSetControl("tempindex", tempindex.substring(0, tempindex.length - 1));
        _window.top.mainWin.top.jsSetControl("subindex", subcoumnindex.substring(0, subcoumnindex.length - 1));
    }
    var catestr = columnid + "-" + cindex + "-" + cdestpage + "-" + vcolumnid + "-" + vindex + "-" + vdestpage+ "-" + subindex+ "-" + subdestpage+"-"+isleft;
    _window.top.mainWin.top.jsSetControl("cachestr", catestr);
    //保存左上角栏目路径
    savePath(1);
}
function savePath(flag) {
    if (flag == 1) {
        for (var i = 0; i < pathstr.length ; i++) {
//            alert("SSSSSSSSSSSSSSSSflag=1==="+i+"="+pathstr[i]);
            _window.top.jsSetControl("temppath" + i, pathstr[i]);
        }
        _window.top.jsSetControl("pathleng", pathstr.length - 1);
    } else {
        pathleng = parseInt(_window.top.jsGetControl("pathleng"));
        pathstr = new Array();
        if (pathleng > 0) {
            for (var i = 0; i < pathleng; i++) {
                pathstr[i] = _window.top.jsGetControl("temppath" + i);
//                alert("SSSSSSSSSSSSSSSSflag=-1==="+i+"="+pathstr[i]);
            }
        } else {
            temparr = "pathleng";
        }
    }
}
function initArray() {
    var columnstr = _window.top.mainWin.top.jsGetControl("columnstr");
    var tempdestpage =  _window.top.mainWin.top.jsGetControl("tempdestpage");
    var tempindex =  _window.top.mainWin.top.jsGetControl("tempindex");
    var subindex =  _window.top.mainWin.top.jsGetControl("subindex");
    if (columnstr != "" && columnstr != null && columnstr != "undefined" && columnstr != "null") {
        statckIndex = columnstr.split("-");
        statckdestpage = tempdestpage.split("-");
        arrcindex = tempindex.split("-");
        statcksubIndex=subindex.split("-");
    }
    savePath(-1);
}
function initParam() {
    cachestr =  _window.top.jsGetControl("cachestr");
    if (cachestr != "" && cachestr != null && cachestr != "undefined" && cachestr != "null") {
        var cateparam = cachestr.split("-");
        columnid = cateparam[0];
        cindex = parseInt(cateparam[1]);
        cdestpage = cateparam[2];
        vcolumnid = cateparam[3];
        vindex = parseInt(cateparam[4]);
        vdestpage = cateparam[5];
        lastvdestpage = vdestpage;
        subindex = parseInt(cateparam[6]);
        subdestpage= parseInt(cateparam[7]);
        isleft=eval(cateparam[8]);
        initArray();
        clearStack();
    }
}

function clearStack() {
     _window.top.mainWin.top.jsSetControl("cachestr", null);
     _window.top.mainWin.top.jsSetControl("columnstr", null);
     _window.top.mainWin.top.jsSetControl("tempdestpage", null);
     _window.top.mainWin.top.jsSetControl("tempindex", null);
     _window.top.mainWin.top.jsSetControl("subindex", null);
     _window.top.mainWin.top.jsSetControl("pathstr", null);
     for (var i = 0; i < pathleng; i++) {
         _window.top.jsSetControl("temppath" + i, null);
     }
//     pathstr=new Array();
     _window.top.jsSetControl("pathleng", 0);
}
function refreshRight() {
    pathstr.splice(pathstr.length - 1, 1);
    pathstr[pathstr.length] = carr[cindex].columnname.substr(0,9);
    if (carr[cindex].subExist == "1") { //有子栏目获取子栏目
        subcolumnid = carr[cindex].columnid;
        showChirld = true;
        subindex = 0;
        subdestpage = 1;
        if(isReallyZTE == true){
            $("sucolumn").style.visibility = "visible";
            $("vodDiv").style.visibility = "hidden";
            $("line_vodDiv").style.visibility = "hidden";
        }else{
            $("sucolumn").style.display = "block";
            $("vodDiv").style.display = "none";
            $("line_vodDiv").style.display = "none";
        }
        loadChirld();
    } else {   //没有子栏目获取vod
        showChirld = false;
        vcolumnid = carr[cindex].columnid;
        testLineColumn(vcolumnid);
        if(lineColumn == ""){
            if(isReallyZTE == true){
                $("sucolumn").style.visibility = "hidden";
                $("line_vodDiv").style.visibility = "hidden";
                $("vodDiv").style.visibility = "visible";
            }else{
                $("sucolumn").style.display = "none";
                $("line_vodDiv").style.display = "none";
                $("vodDiv").style.display = "block";
            }
        }else{
            if(isReallyZTE == true){
                $("sucolumn").style.visibility = "hidden";
                $("vodDiv").style.visibility = "hidden";
                $("line_vodDiv").style.visibility = "visible";
            }else{
                $("sucolumn").style.display = "none";
                $("vodDiv").style.display = "none";
                $("line_vodDiv").style.display = "block";
            }
        }

        vindex = 0;
        vdestpage = 1;
        showVodList();
        changeBarImg();
    }
    showColumnPath();
}
function cateKeyOK() {

    if (isleft == true) {
        hideAlert();
        //以下为处理跳直播返回后的代码
		if(flag_jumplive == 1){
		  $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
		  isleft = false;
		  live_jump();
        	  savePageInfo(); 
		}
        
    } else {//vod
        if(flag_jumplive == 1){
            live_jump();
            savePageInfo(); 
            return;
        }
        if (showChirld) {
            columnid = subarr[subindex].fcolumnid;
            $("columnbar" + cindex).src = "images/btn_trans.gif";
            fcolumnid = carr[cindex].fcolumnid;
            pushValue(fcolumnid, cdestpage, cindex,subindex);
            /*
            if(subindex==0 && subdestpage >1){
                cindex=8;
            }else{
                cindex=subindex;
            }
            if (subindex > 0 && subdestpage > 1){
                subdestpage++;
                cdestpage=subdestpage;
                subindex--;
                cindex=subindex;
            }else{
                cdestpage=1;
            }
            */
            var totalIndex = subindex+ (subdestpage-1)*8;
            cindex = totalIndex%9;
            cdestpage = parseInt((totalIndex/9))+1;
//            alert("SSSSSSSSSSSSSScindex_cdestpage="+cindex+"_"+cdestpage);

            subindex=0;
            showChirld = false;
            vindex = 0;
            vdestpage = 1;
            isleft=true;
            loadPage();
        } else {
            savePageInfo();
            if (varr[vindex].programtype == "1") {
                var url = "vod_detail.jsp?columnid=" + varr[vindex].columnid
                        + "&programid=" + varr[vindex].programid
                        + "&programtype=" + varr[vindex].programtype
                        + "&contentid=" + varr[vindex].contentcode
                        + "&columnpath=" + $("path").innerText
                        + "&programname=" + varr[vindex].programname;
                 _window.top.mainWin.document.location = encodeURI(encodeURI(url));
            } else if (varr[vindex].programtype == "14") {
                var url = "vod_series_list.jsp?columnid=" + varr[vindex].columnid
                        + "&programid=" + varr[vindex].programid
                        + "&programtype=" + varr[vindex].programtype
                        + "&contentid=" + varr[vindex].contentcode
                        + "&columnpath=" + $("path").innerText
                        + "&programname=" + varr[vindex].programname;
                 _window.top.mainWin.document.location = encodeURI(encodeURI(url));
            }
        }
    }
}
function changeBarImg() {
    for (var i = 0; i < 9; i++) {
        if (i == cindex) {
            $("columnbar" + i).src = "images/portal/focus.png";
        } else {
            $("columnbar" + i).src = "images/btn_trans.gif";
        }
    }
}
function goback() {
    hideAlert();
    clearStack();
    _window.top.mainWin.document.location = 'back.jsp';
}
function cateBack() {

        hideAlert();

    if (statckIndex.length == 0) {
        goback();
    } else {
        $("columnbar" + cindex).src = "images/btn_trans.gif";
        columnid = statckIndex[statckIndex.length - 1]; //栏目
        statckIndex.splice(statckIndex.length - 1, 1);

        cdestpage = statckdestpage[statckdestpage.length - 1];//栏目页码
        statckdestpage.splice(statckdestpage.length - 1, 1);

        cindex = arrcindex[arrcindex.length - 1]; //栏目下标
        arrcindex.splice(arrcindex.length - 1, 1);

        if(statcksubIndex.length>0){
            subindex = statcksubIndex[statcksubIndex.length - 1]; //右边子栏目下标
            statcksubIndex.splice(statcksubIndex.length - 1, 1);
        }else{
            subindex=0;
        }

        pathstr.splice(pathstr.length - 2, 2);
        isleft=false;

        changeSubColumn(-1);
        changeVodImg(1);
        init("back");
    }
}
function cateKeyLeft() {
	if(flag_jumplive == 1){
		for(var i=0;i<cat_live_jump.length;i++){
			
			flag_jumplive = 0;
			$("livefocus_img"+i).style.visibility = "hidden";
			$("livefocus_img"+i).style.border = "0px";
			$("columnbar" + cindex).src = "images/portal/focus.png";
			isleft = true;
		 }
		 return;
	}

    if (!isleft) {
        if (showChirld) {
            if (subindex == 0 || subindex == 4) {
                isleft = true;
                changeSubColumn(-1);
                $("columnbar" + cindex).src = "images/portal/focus.png";
                textScroll(1);
            } else {
                if (subindex >= 0 && subindex < subleng) {
                    changeSubColumn(-1);
                    subindex--;
                    changeSubColumn(1);
                }
            }
        } else {
            if (vindex == 0 || vindex == 4) {
                isleft = true;
                stopVodScroll();
                changeVodImg(1);
                $("columnbar" + cindex).src = "images/portal/focus.png";
                textScroll(1);
            } else {
                if (vindex >= 0 && vindex < vleng) {
                    stopVodScroll();
                    changeVodImg(1);
                    vindex--;
                    changeVodImg(0);
                    clearTimeout(infotimer);
                    infotimer = setTimeout('starVodScroll();', 600);
                }
            }
        }
    }
}
function cateKeyRight() {
    if(loadProgram == 0){
        return ;
    }
    if (isleft == true) { //焦点在左边栏目上
        // alert("clumeId=="+carr[cindex].columnid); 
        if(alert4K()){
            return;
        };
        for(var i=0;i<cat_live_jump.length;i++){
			if( $("channel_jump"+i).style.visibility == "visible" ){
            $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
		   if(cat_live_jump[i].columnIdSecond.toLowerCase()==carr[cindex].columnid.toLowerCase()){
			   //if(i == 0){
				// $("livefocus_img"+i).style.visibility = "visible";
				 //$("livefocus_img"+i).style.border = "4px solid red";
				//}else{
				 $("livefocus_img"+i).style.visibility = "visible";
		   		 $("live_img"+i).src = "images/"+cat_live_jump[i].focuspic;
				//}  	 
		   }
            flag_jumplive = 1;
            isleft = false;
            return;
        }
		}

        if (showChirld && subleng > 0) {
            isleft = false;
            changeSubColumn(1);
            $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
            textScroll(-1);
        } else if (!showChirld && vleng > 0) {
            isleft = false;
            changeVodImg(0);
            $("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
            textScroll(-1);
            clearTimeout(infotimer);
            infotimer = setTimeout('starVodScroll();', 600);
        }
    } else { //焦点在右边
        if (showChirld && subleng > 0) {  //右边展示的是子栏目
            changeSubColumn(-1);
            if (subindex >= 0 && subindex < subleng - 1) {
                subindex++;
            } else {
                subindex = 0;
            }
            changeSubColumn(1);
        } else if (vleng > 0) {
            changeVodImg(1);
            stopVodScroll();
            if (vindex >= 0 && vindex < vleng - 1) {
                vindex++;
            } else {
                vindex = 0;
            }
            changeVodImg(0);
            clearTimeout(infotimer);
            infotimer = setTimeout('starVodScroll();', 600);
        }
    }
}

//var loadProgram =1;

function cateKeyUp() {
    if(flag_jumplive == 1){
        return;
    }
	
	for(var i=0;i<cat_live_jump.length;i++){
		$("channel_jump"+i).style.visibility = "hidden";
		$("livefocus_img"+i).style.visibility = "hidden";
		$("livefocus_img"+i).style.border = "0px";
	}
    
    if (isleft) {//栏目移动
        if (cleng > 0) {
            clearTimeout(lefttime);
            if ((cindex > 0 && cindex <= 8 && cindex < cleng)|| (cindex==0 && cpagecount ==1)) {
                loadProgram =0;
                textScroll(-1);
                $("columnbar" + cindex).src = "images/btn_trans.gif";
               if(cindex==0 && cpagecount ==1){
                    cindex = cleng-1;
                }else{
                    cindex--;
                }
                $("columnbar" + cindex).src = "images/portal/focus.png";
                textScroll(1);
              //  clearTimeout(lefttime);
                lefttime=setTimeout("refreshRight();",600);
            } else {
                action="up";
                pagePrev();
            }
        }
    } else {
        if (showChirld) {
            if ((subindex - 4) >= 0) {
                changeSubColumn(-1);
                subindex = subindex - 4;
                changeSubColumn(1);
            }else{
                pagePrev();
            }
        } else {
            if (vleng > 0) {//vod移动
//                alert("SSSSSSSSSSSSSSSSSS11111");
                if (vindex - 4 >= 0) {
//                    alert("SSSSSSSSSSSSSSSSSS22222");
                    changeVodImg(1);
                    vindex = vindex - 4;
                    changeVodImg(0);
                    clearTimeout(infotimer);
                    infotimer = setTimeout('starVodScroll();', 600);
                }else{
//                    alert("SSSSSSSSSSSSSSSSSS233333");
                    pagePrev();
                }
            }
        }
    }
}
function cateKeyDown() {

    if(flag_jumplive == 1){
        return;
    }
	for(var i=0;i<cat_live_jump.length;i++){
		$("channel_jump"+i).style.visibility = "hidden";
		$("livefocus_img"+i).style.visibility = "hidden";
		$("livefocus_img"+i).style.border = "0px";
	}
	
    if (isleft) { //栏目移动
        if (cleng > 0) {
         clearTimeout(lefttime);
            if ((cindex >= 0 && cindex < cleng - 1) || (cindex ==(cleng - 1) && cpagecount ==1)) {
                loadProgram =0;
                textScroll(-1);
                $("columnbar" + cindex).src = "images/btn_trans.gif";
               if(cindex ==(cleng - 1) && cpagecount ==1){
                    cindex =0;
                }else{
                    cindex++;
                }
                $("columnbar" + cindex).src = "images/portal/focus.png";
                textScroll(1);
   //             clearTimeout(lefttime);
                lefttime=setTimeout("refreshRight();",600);
            } else {
                pageNext();
            }
        }
    } else {
        if (showChirld) {
            if ((subindex + 4) < subleng) {
                changeSubColumn(-1);
                subindex = subindex + 4;
                changeSubColumn(1);
            }else{
                var tempIndexDestpage = parseInt(parseInt(subindex)/4+1);
                var tempLengthDestpage = parseInt((subleng-1)/4 +1);
                if((tempIndexDestpage%2) != (tempLengthDestpage%2)){
					// alert("fana======1111");
                    changeSubColumn(-1);
                    subindex = 4;
                    changeSubColumn(1);
                }else{
					// alert("fana=====22222");
                    pageNext();
                }
            }
        } else {
//            alert("SSSSSSSSSSSSSSSSSS11111");
            if ((vindex + 4) < vleng) {
//                alert("SSSSSSSSSSSSSSSSSS22222");
                changeVodImg(1);
                stopVodScroll();
                vindex = vindex + 4;
                changeVodImg(0);
                clearTimeout(infotimer);
                infotimer = setTimeout('starVodScroll();', 600);
            }else{
//                alert("SSSSSSSSSSSSSSSSSS333333");
               var tempIndexDestpage = parseInt(parseInt(vindex)/4+1);
                var tempLengthDestpage = parseInt((vleng-1)/4 +1);
                if((tempIndexDestpage%2) != (tempLengthDestpage%2)){
                    changeVodImg(1);
                    stopVodScroll();
                    vindex = 4;
                    changeVodImg(0);
                    clearTimeout(infotimer);
                    infotimer = setTimeout('starVodScroll();', 600);
                    return;
                }
                pageNext();
            }
        }
    }
}
function goSearch() {
    hideAlert();
    savePageInfo();
    var url = "vod_search.jsp?columnpath=" + $("path").innerText;
    _window.top.mainWin.document.location = encodeURI(encodeURI(url));
}
//收藏，每个页面不同处理的代码
function favoritedo() {
    if (!isleft && vleng > 0) {
        if(carr[cindex].subExist == "1"){
            return;
        }
        var favUrl = "action/favorite_add.jsp?SubjectID=" + varr[vindex].columnid
                + "&ContentID=" + varr[vindex].contentcode
                + "&FavoriteTitle=" + varr[vindex].programname;
        var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showMsg);
    }
}
function cancelKeyOK() {
    if (favIndex == 0) {
        //进入TV收藏
        closeMessage();
        savePageInfo();
        document.onkeypress=cateKeyPress;
        _window.top.mainWin.document.location = favoriteUrl;
    } else {
        favIndex=0;
        $("fav_0").src = "images/vod/btv-btn-cancel.png";
        $("fav_1").src = "images/vod/btv-btn-cancel.png";
        closeMessage();
        document.onkeypress = cateKeyPress;
    }
}
function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    $("closeMsg").style.visibility = "hidden";
    $("favMax").style.visibility="hidden";
}

function changeVodImg(flag) {
//    alert("SSSSSSSSSSSSSSSSSSSSchange111222VodImg="+flag);
    var vindex1 = vindex;
    var templineColumn = lineColumn;
    if (flag == 0) {
        $(templineColumn+"line_" + vindex1).style.visibility = "hidden";
        $(templineColumn+"vod_poster" + vindex1).style.visibility = "hidden";
        $(templineColumn+"vod_name" + vindex1).style.visibility = "hidden";

        $(templineColumn+"focus_bg" + vindex1).style.visibility = "visible"; //获取焦点背景图
        $(templineColumn+"focus_img" + vindex1).src = varr[vindex].normalposter;
//        $("focus_img" + vindex).style.visibility = "visible";
        $(templineColumn+"focus_name" + vindex1).innerText = writeFitString(varr[vindex1].programname, 22, 160);
        $(templineColumn+"focus_name" + vindex1).style.visibility = "visible";
        $(templineColumn+"fline_" + vindex1).style.visibility = "visible";
    } else {
        $(templineColumn+"focus_bg" + vindex1).style.visibility = "hidden";   //失去焦点背景图
        $(templineColumn+"focus_img" + vindex1).src = "images/btn_trans.gif";
//        $("focus_img" + vindex).style.visibility = "hidden";
        $(templineColumn+"focus_name" + vindex1).style.visibility = "hidden";
        $(templineColumn+"fline_" + vindex1).style.visibility = "hidden";

        $(templineColumn+"line_" + vindex1).style.visibility = "visible";
        $(templineColumn+"vod_poster" + vindex1).style.visibility = "visible";
        $(templineColumn+"vod_name" + vindex1).style.visibility = "visible";
    }
}
function changeSubColumn(flag) {
    if (flag == 1) {
        $("column_pos" + subindex).style.visibility = "hidden";
        $("column_bg" + subindex).style.visibility = "hidden";
        $("sub_column" + subindex).style.visibility = "hidden";

        $("fcolumn_pos" + subindex).style.visibility = "visible";
        $("fcolumn_bg" + subindex).style.visibility = "visible";
        $("fcolumn_bgb" + subindex).style.visibility = "visible";
        $("fsub_column" + subindex).style.visibility = "visible";
    } else {
        $("fcolumn_pos" + subindex).style.visibility = "hidden";
        $("fcolumn_bg" + subindex).style.visibility = "hidden";
        $("fcolumn_bgb" + subindex).style.visibility = "hidden";
        $("fsub_column" + subindex).style.visibility = "hidden";

        $("column_pos" + subindex).style.visibility = "visible";
        $("column_bg" + subindex).style.visibility = "visible";
        $("sub_column" + subindex).style.visibility = "visible";

    }
}
function textScroll(doi) {
    try{
        if (doi == 1) {
            scrollString("column_div" + cindex, carr[cindex].columnname, 32, 200);
        }
        if (doi == -1) {
            stopscrollString("column_div" + cindex, carr[cindex].columnname, 32, 200);
        }
    }catch(e){
        //alert("SSSSSSSSSSSSSSStextScroll!!!");
    }
}
function stopVodScroll() {
    if (vleng > 0) {
        if(lineColumn==""){
            stopscrollString(lineColumn+"focus_name" + vindex, varr[vindex].programname, 18, 140);
        }else{
//            alert("SSSSSSSSSSSSSSSSSSS1111stopVodScroll_lineColumn="+lineColumn);
            stopscrollString(lineColumn+"focus_name" + vindex, varr[vindex].programname, 18, 180);
        }
    }
}

function starVodScroll() {
    if(lineColumn==""){
        scrollString(lineColumn+"focus_name" + vindex, varr[vindex].programname, 22, 140);
    }else{
        scrollString(lineColumn+"focus_name" + vindex, varr[vindex].programname, 22, 180);
    }
    clearTimeout(infotimer);
}

function showScrollBar(flag) {
    if (flag == 1) {
        if (subleng > 0) {
            var heightX = parseInt(504 / subpagecount);//每页的高度
            var topX = 3 + heightX * (subdestpage - 1);
            $("scrollbar2").height = heightX;
            $("scroll").style.top = topX;
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
    } else {
        if (vleng > 0) {
            var heightX = parseInt(504 / vpagecount);
            var topX = 3 + heightX * (vdestpage - 1);
            $("scrollbar2").height = heightX;
            $("scroll").style.top = topX;
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
    }
}
function showPage() {
    $("up").style.visibility = cpagecount > 1 && cdestpage > 1 ? "visible" : "hidden";
    $("down").style.visibility = cpagecount > 1 && cdestpage < cpagecount ? "visible" : "hidden";
}

/*弹出图片--跳直播
    根据二级分类ID判断
*/
function columnIdSecondArray(){    
    
    
    for(var i=0;i<cat_live_jump.length;i++){
        //判断二级分类ID
        if( cat_live_jump[i].columnIdSecond.toLowerCase()==carr[cindex].columnid.toLowerCase() ){
				$("channel_jump"+i).style.visibility ="visible";
				//$("livefocus_img"+i).style.visibility = "visible";
            	$("liveJumpImg"+i).src = "images/"+ cat_live_jump[i].pic;
            	if(!isleft){
                	$("columnbar" + cindex).src = "images/vod/btv_column_focus.png";
					//if(i == 0){
					//	$("livefocus_img"+i).style.visibility = "visible";
					//	$("livefocus_img"+i).style.border = "4px solid red";
					//}else{
						$("livefocus_img"+i).style.visibility = "visible";
						$("live_img"+i).src = "images/"+cat_live_jump[i].focuspic;
					//}
               		flag_jumplive = 1;
            	}
            	$("listMsg").style.visibility = "hidden";
        }

    }
    
}

function live_jump(){
    for(var i=0;i<cat_live_jump.length;i++){
        //判断二级分类ID
        if( cat_live_jump[i].columnIdSecond.toLowerCase()==carr[cindex].columnid.toLowerCase() ){
            $("channel_jump"+i).style.visibility ="hidden";          
            top.mainWin.document.location = cat_live_jump[i].url;
        }
            
    }
}