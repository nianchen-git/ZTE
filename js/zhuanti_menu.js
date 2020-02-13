//Authentication.CTCSetConfig('SetEpgMode', '720P');
var $$ = {};

function $(id) {
    if (!$$[id]) {
        $$[id] = document.getElementById(id);
    }
    return $$[id];
}

var leftMenuCount = 9;
var rightMenuCount=4;
var upAction = false;
var downAction = false;
var pagecount = Math.ceil(Specalmenulist.length/leftMenuCount);
var columnArr = [];
var specialArr=[];
var totalCount=Specalmenulist.length;
var rtotalCount=0;
var startIndex=0;
var endIndex=0;
if(pagecount>1){
	endIndex = leftMenuCount;
}else{
	endIndex = totalCount;
}
var cfocus=0;
var isleft=0;//0为左侧标识，1为右侧标识
var rindex = 0;
var clength=0;
var rlength=0
var cpagetotal=0;
var rpagetotal=0;
var cpageseq =0;
var rpageseq=0;
var rstartIndex=0;
var rendIndex=4;


function  setPageInfo(){
	    top.mainWin.top.jsSetControl("focusNow", focusNow);
        top.mainWin.top.jsSetControl("startIndex", startIndex);
        top.mainWin.top.jsSetControl("endIndex", endIndex);
		top.mainWin.top.jsSetControl("cpageseq", cpageseq);
		top.mainWin.top.jsSetControl("cindex", cindex);
        top.mainWin.top.jsSetControl("isleft", isleft);
		top.mainWin.top.jsSetControl("rindex", rindex);
		top.mainWin.top.jsSetControl("rpageseq", rpageseq);
		top.mainWin.top.jsSetControl("rstartIndex", rstartIndex);
		top.mainWin.top.jsSetControl("rendIndex", rendIndex);
}
function clearPageInfo(){
	//alert("1111111111111==clearPageInfo");
	top.mainWin.top.jsSetControl("focusNow",null);
	top.mainWin.top.jsSetControl("startIndex",null);
	top.mainWin.top.jsSetControl("endIndex",null);
	top.mainWin.top.jsSetControl("cpageseq",null);
	top.mainWin.top.jsSetControl("isleft",null);
	top.mainWin.top.jsSetControl("rindex",null);
	top.mainWin.top.jsSetControl("rpageseq",null);
	top.mainWin.top.jsSetControl("rstartIndex",null);
	top.mainWin.top.jsSetControl("rendIndex",null);
	top.mainWin.top.jsSetControl("cindex",null);
	 
}
function getPageInfo(){
	if( top.mainWin.top.jsGetControl("focusNow")!="" &&  top.mainWin.top.jsGetControl("focusNow")!=null && top.mainWin.top.jsGetControl("focusNow")!="undefined" && top.mainWin.top.jsGetControl("focusNow")!="null" ){
		focusNow = parseInt(top.mainWin.top.jsGetControl("focusNow"),10);
	}
	if(top.mainWin.top.jsGetControl("startIndex")!="" && top.mainWin.top.jsGetControl("startIndex")!=null && top.mainWin.top.jsGetControl("startIndex")!="undefined" && top.mainWin.top.jsGetControl("startIndex")!="null" ){
		startIndex = parseInt(top.mainWin.top.jsGetControl("startIndex"),10);
	}
	if( top.mainWin.top.jsGetControl("endIndex")!="" && top.mainWin.top.jsGetControl("endIndex")!=null  && top.mainWin.top.jsGetControl("endIndex")!="undefined" && top.mainWin.top.jsGetControl("endIndex")!="null" ){
		endIndex = parseInt(top.mainWin.top.jsGetControl("endIndex"),10);
	}
	if( top.mainWin.top.jsGetControl("cpageseq")!="" && top.mainWin.top.jsGetControl("cpageseq")!=null && top.mainWin.top.jsGetControl("cpageseq")!="undefined"  && top.mainWin.top.jsGetControl("cpageseq")!="null" ){
		cpageseq = parseInt(top.mainWin.top.jsGetControl("cpageseq"),10);
	}
	if( top.mainWin.top.jsGetControl("isleft")!="" && top.mainWin.top.jsGetControl("isleft")!=null && top.mainWin.top.jsGetControl("isleft")!="undefined" && top.mainWin.top.jsGetControl("isleft")!="null"){
		
		isleft =parseInt(top.mainWin.top.jsGetControl("isleft"),10);
	}
	if( top.mainWin.top.jsGetControl("rindex")!="" &&  top.mainWin.top.jsGetControl("rindex")!=null && top.mainWin.top.jsGetControl("rindex")!="undefined"  && top.mainWin.top.jsGetControl("rindex")!="null"){
		rindex = parseInt(top.mainWin.top.jsGetControl("rindex"),10);
	}
	if( top.mainWin.top.jsGetControl("rpageseq")!="" &&  top.mainWin.top.jsGetControl("rpageseq")!=null  && top.mainWin.top.jsGetControl("rpageseq")!="undefined" && top.mainWin.top.jsGetControl("rpageseq")!="null"){
		rpageseq = parseInt(top.mainWin.top.jsGetControl("rpageseq"),10);
	}
	if( top.mainWin.top.jsGetControl("rstartIndex")!="" &&  top.mainWin.top.jsGetControl("rstartIndex")!=null && top.mainWin.top.jsGetControl("rstartIndex")!="undefined" && top.mainWin.top.jsGetControl("rstartIndex")!="null"){
		rstartIndex = parseInt(top.mainWin.top.jsGetControl("rstartIndex"),10);
	}
	if( top.mainWin.top.jsGetControl("rendIndex")!="" &&  top.mainWin.top.jsGetControl("rendIndex")!=null && top.mainWin.top.jsGetControl("rendIndex")!="undefined" && top.mainWin.top.jsGetControl("rendIndex")!="null"){
		rendIndex = parseInt(top.mainWin.top.jsGetControl("rendIndex"),10);
	}
	
	if( top.mainWin.top.jsGetControl("cindex")!="" &&  top.mainWin.top.jsGetControl("cindex")!=null  && top.mainWin.top.jsGetControl("cindex")!="undefined" && top.mainWin.top.jsGetControl("cindex")!="null"){
		cindex = parseInt(top.mainWin.top.jsGetControl("cindex"),10);
	}  
}


function commonKeyPress(evt) {
    var keycode = evt.which;
	//alert("keycode====="+keycode);
    if (keycode == 0x0101) { //????????
        _window.top.remoteChannelPlus();
    } else if (keycode == 0x0102) {
        _window.top.remoteChannelMinus();
    } else if (keycode == 0x0110) {
		clearPageInfo();
        Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keycode == 0x0008 || keycode==8) {
		//alert("goback======");
		clearPageInfo();
        _window.top.mainWin.document.location = "back.jsp";
    } else {
        _window.top.doKeyPress(evt);
    }
}

function doKeyPress(evt) {
    var keycode = evt.which;
	//alert("keycode===www==="+keycode);
    if (keycode == 0x0025) {
        goLeft();
    } else if (keycode == 0x0027) {
        goRight();
    } else if (keycode == 0x000D) {
            goOk();
    } else if (keycode == 0x0026) {
        goUp();
    } else if (keycode == 0x0028) {
        goDown();
    } else if (keycode == 0x0021) {
        pageUp();
    }  else if (keycode == 0x0022) {
        pageDown();
    }else if (keycode == 0x0008 || keycode==8) {
		//alert("goback======");
		clearPageInfo();
        top.mainWin.document.location = "back.jsp";
    }else{
		commonKeyPress(evt);
		}
    return false;
}
// function doKeyPress(evt) {
//    var keycode = evt.which;
//	 //alert("keycode:"+keycode);
//	// g_o.debug.print_log("*******keycode:"+keycode);
//    if (keycode == 97) {//左
//        goLeft();
//    } else if (keycode == 115) {//右
//        goRight();
//    } else if (keycode == 0) {//确认
//        goOK();
//    } else if (keycode == 119) {//上
//        goUp();
//    } else if (keycode == 113) {//下
//         goDown();
//    } else {
//        commonKeyPress(evt);
//    }
//    return false;
// }
function load_page(){
	
	getPageInfo();
	if(cindex==0 || cindex=="0" ){
		cindex=0;
	 $("specialmenubar0").src = "images/portal/focus.png";
   }
    if(focusNow==0 ||focusNow=="0" ){
		focusNow=0;
	}
	cindex = parseInt(cindex,10);
	focusNow = parseInt(focusNow,10);
	showSpecalmenulist();
	if(SpecalColumnlist[focusNow].length<4){
		rendIndex = SpecalColumnlist[focusNow].length;
	}
	showSpecalColumnlist(focusNow);
	showupdowicon();
	showScrollBar();
	if(totalCount>0){
	 if(isleft==1){
		clear_focus_menu(); 
	 }
	show_focus_menu();
	}
	
}
function showSpecalmenulist(){
   totalCount=Specalmenulist.length;
   columnArr=new Array();
    for (var i = startIndex; i < endIndex; i++) {
       columnArr.push(Specalmenulist[i]);
    }
    clength = columnArr.length;
	for(var i=0; i<leftMenuCount; i++){
	  if(i<clength){
		$('specialmenu_div' + i).innerHTML =columnArr[i].columnname;
	  }else{
		$('specialmenu_div' + i).innerHTML ="";  
	  }	
	}
	cpagetotal = Math.ceil(totalCount/leftMenuCount);
	if(columnArr[cindex].columnname!='undefined'){
	$("patha").innerHTML = columnArr[cindex].columnname;
	}else{
	$("patha").innerHTML = "";	
	}
}

   
function showSpecalColumnlist(left_focus) {
	rtotalCount=SpecalColumnlist[left_focus].length; 
    specialArr=new Array();
    for (var i = rstartIndex; i < rendIndex; i++) {
       specialArr.push(SpecalColumnlist[left_focus][i]);
    }
    rlength = specialArr.length;
    for (var j = 0; j < rightMenuCount; j++) {
        if (j < rlength) {
			//alert("rlength=="+rlength+"j==="+j+"left_focus ===="+left_focus);
            $('zhuanti_img_' + j).src = "images/special/"+specialArr[j].columnimg;
            $('zhuanti_' + j).style.visibility = 'visible';
           // $('zhuanti_name_' + i).innerHTML =columnArr[left_focus][i].columnname;
        } else {
            $('zhuanti_img_' + j).src = '';
            $('zhuanti_' + j).style.visibility = 'hidden';
			//$('zhuanti_name_' + i).innerHTML ="";
        }
    }
   rpagetotal = Math.ceil(rtotalCount/rightMenuCount); 
   showScrollBar();
}

function show_focus_menu(){
	//alert("cindexaaaa======"+isNaN(cindex));
	  if(isleft==0){
		  //alert("totalCount==="+totalCount+"columnArr[cindex].columnname=="+columnArr[cindex].columnname+"====="+columnArr[0].columnname);
        $("specialmenubar" + cindex).src = "images/portal/focus.png";
    }else{
        $("zhuanti_" + rindex).style.border="4px solid red";
    }
}
function clear_focus_menu(){
	 $("specialmenubar" + cindex).src = "images/vod/btv_column_bar.png";
}
function hide_focus_menu(){
	//alert("rindex=====b="+rindex);
	 if(isleft==0){
        $("specialmenubar" + cindex).src = "images/btn_trans.gif";
    }else{
        $("zhuanti_" + rindex).style.border="0px solid red";
    }
}


function showupdowicon() {
   $("up").style.visibility=startIndex>0 ? "visible":"hidden";
   $("down").style.visibility=endIndex<totalCount ? "visible":"hidden";
}


function goLeft() {
	//alert("goLeft====="+isleft);
   if(isleft==1){
	 hide_focus_menu();
	 if(rindex==1 ||rindex==3){
		// alert("goleft=rindex==="+rindex);
		rindex--; 
	 }else if(rindex==0 || rindex==2){
		// alert("11111111");
		 isleft=0;
	 }
	 show_focus_menu();
   } 
}

function goRight() {
   hide_focus_menu();
   if(isleft==0){
	 if(rlength>0){
	isleft=1; 
	clear_focus_menu();
	rindex=0;
	 }
   }else{
	 rindex++;
	 if(rindex>=rlength || rindex>=rightMenuCount){
		 rindex=0;
	 }
   }
   show_focus_menu();
}



function goOk() {
	//alert("goOk==="+(isleft==1));
  if(isleft==1){
	 // alert("sdsdsd");
	  setPageInfo();
	  top.mainWin.document.location = specialArr[rindex].columnposter; 
  }
}

function setBackParam() {
    backurlparam += "?lastfocus="+bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
    top.jsSetControl("backurlparam", backurlparam);
    var lastChannelNum = top.channelInfo.currentChannel;
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


function goUp() {
	
	if(isleft==0){
		
	hide_focus_menu();
	cindex--;
	if(cindex<0){
	 pageUp();
	}
	focusNow = cindex+startIndex;
	$("patha").innerHTML = columnArr[cindex].columnname;
	show_focus_menu();	
	 rpageseq=0;
	 rtotalCount=SpecalColumnlist[focusNow].length;
	 if(rtotalCount>4){
		 rendIndex =4;
	 }else{
		rendIndex = rtotalCount;
	 }
	 rstartIndex = 0;
	setTimeout("showSpecalColumnlist(focusNow)",1000);
	//showScrollBar();
 }else{
	hide_focus_menu();
	if(rindex<2){
	 pageUp();
	}else{
	rindex = rindex-2;
	}
	show_focus_menu();
 }
}

function goDown() {
 if(isleft==0){
	hide_focus_menu();
	cindex++;
	if(cindex+1>clength || cindex+1>leftMenuCount){
	//alert("pageDown======");
	 pageDown();
	}
	
	 focusNow = cindex+startIndex;
	 $("patha").innerHTML = columnArr[cindex].columnname;
	 show_focus_menu()
	 rpageseq=0;
	 rtotalCount=SpecalColumnlist[focusNow].length;
	 if(rtotalCount>4){
		 rendIndex =4;
	 }else{
		rendIndex = rtotalCount;
	 }
	 rstartIndex = 0;
	setTimeout("showSpecalColumnlist(focusNow)",1000);
	//showScrollBar();
	 
 }else{
	hide_focus_menu();
	if(rindex<2 && rlength>(rindex+2)){
		rindex = rindex+2;
	}else{
		pageDown();
	}
	show_focus_menu();
 }

}
function pageUp(){
   if(isleft==0){
	   cindex=0;
	   cpageseq--;
	   if(cpageseq>=0){
		  startIndex =cpageseq*leftMenuCount;
		  endIndex=(cpageseq+1)*leftMenuCount;
		    cindex=leftMenuCount-1;
	   }else {
		   cpageseq=cpagetotal-1;
		   startIndex =cpageseq*leftMenuCount; 
		   endIndex=totalCount;
		     cindex=endIndex-startIndex-1;
	   }
	   showupdowicon();
	   showSpecalmenulist();
   }else{
	   rindex=0;
	   rpageseq--;
	  if( rpageseq>=0){
		  rstartIndex =rpageseq*rightMenuCount;
		  rendIndex=(rpageseq+1)*rightMenuCount;
	   }else {
		   rpageseq=rpagetotal-1;
		   rstartIndex =rpageseq*rightMenuCount; 
		   rendIndex=rtotalCount;
	   }
	   
	   showSpecalColumnlist(focusNow);
	   //showScrollBar();
   }
}
function pageDown(){
   if(isleft==0){
	   cindex=0;
	   if(cpagetotal>1){
	   cpageseq++;
	   if( cpageseq<cpagetotal-1){
		  startIndex =cpageseq*leftMenuCount;
		  endIndex=(cpageseq+1)*leftMenuCount;
	   }else if(cpageseq==cpagetotal-1){
		   startIndex =cpageseq*leftMenuCount; 
		   endIndex=totalCount;
	   }else{
		 cpageseq=0;
		 startIndex =cpageseq*leftMenuCount;
		 endIndex=(cpageseq+1)*leftMenuCount;
	   }
	   }
	  // alert("startIndex="+startIndex+"===endIndex="+endIndex+"===cpagetotal="+cpagetotal);
	   showSpecalmenulist();
	   showupdowicon();
	   
   }else{
	   rindex=0;
	   rpageseq++;
	  if(rpagetotal>1){
	  if( rpageseq<rpagetotal-1){
		  rstartIndex =rpageseq*rightMenuCount;
		  rendIndex=(rpageseq+1)*rightMenuCount;
	   }else if(rpageseq==rpagetotal-1){
		   rstartIndex =rpageseq*rightMenuCount; 
		   rendIndex=rtotalCount;
	   }else{
		 rpageseq=0;
		 rstartIndex =rpageseq*rightMenuCount;
		 rendIndex=(rpageseq+1)*rightMenuCount;
	   }  
	   
	    showSpecalColumnlist(focusNow);
		//showScrollBar();
	  }else{
		show_focus_menu();   
	  }
   }
}


function showScrollBar() {
        if (rlength > 0) {
            var heightX = parseInt(504 / rpagetotal);//每页的高度
            var topX = 3 + heightX *rpageseq;
            $("scrollbar2").height = heightX;
            $("scroll").style.top = topX;
            $("pageBar").style.visibility = "visible";
        } else {
            $("pageBar").style.visibility = "hidden";
        }
}


document.onkeypress = doKeyPress;

load_page();