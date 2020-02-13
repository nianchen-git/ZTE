<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.*" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.content.EPGTree" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString.jsp" %>
<epg:PageController name="vod_search.jsp"/>
<%

    System.out.println("SSSSSSSSSSSSSSSSSSSSvod_search.jsp++++++++++++"+request.getQueryString());
    String columnid="";
    try {
        String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
        HashMap param = PortalUtils.getParams(path, "GBK");
        if (columnid == null || "".equals(columnid)) {
            columnid = (String) param.get("column01");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    String columnpath =  request.getParameter("columnpath");
    if(columnpath!=null){
        columnpath= URLDecoder.decode(columnpath, "UTF-8");
    }else{
        columnpath=" ";
    }
    String[] words = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "←", "U", "V", "W", "X", "Y", "Z", "空格"};
%>

<html>
<head>
    <epg:script/>
    <title>portal page</title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script type="text/javascript">
        var keyWord=["A","B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "←", "U", "V", "W", "X", "Y", "Z", "空格"];
        var iskey=true;
        var keyindex=0;
        var keyleng=keyWord.length;
        var inputfocus=false;
        var title;
        var $$ = {};

        //搜索结果相关参数
        var temparr=new Array();
        var startIndex=0;
        var endIndex=9;
        var totalCount=0;
        var vodindex=0;
        var data;
        var arr;
        var leng=0;
        var focus=false;
        var btnfocus=false;
        var destpage = 1;
        var pageCount=1;
		var action = "";
		
       function $(id) {
            if (!$$[id]) {
                return document.getElementById(id);
            }
            return $$[id];
        }
    </script>
    <script type="text/javascript">
        function KeyPress(evt) {
            var keyCode = parseInt(evt.which);
//            alert("SSSSSSSSSSSSSSSSSSSSkeyCode="+keyCode);
//            alert("SSSSSSSSSSSSSSSSSSSSisKey="+iskey);
//            alert("SSSSSSSSSSSSSSSSSSSSbtnfocus="+btnfocus);
            if (keyCode == 0x0028)//onKeyDown
            {
               keyDown();
            }
            else if (keyCode == 0x0026)//onKeyUp
            {
                keyUp();
            } else if (keyCode == 0x0025) { //onKeyLeft
                keyLeft();
            }
            else if (keyCode == 0x0027) { //onKeyRight
                keyRight();
            } else if (keyCode == 0x0008  || keyCode == 24) {///back
               back();
            }else if(keyCode == 0x0022){  //page down
               pageNext();
            } else if (keyCode == 0x0021) { //page up
                pagePrev();
            } else if (keyCode == 0x000D) {  //OK
                keyOK();
            }else {
                clearStack();
                commonKeyPress(evt);
                return true;
            }
            return false;
        }
        function clearStack(){
            top.jsSetControl("cache","");
        }
        function back(){
            clearStack();
            document.location="back.jsp";
        }
        function keyDown(){
            if (inputfocus) {
                inputfocus = false;
                $("focus").focus();
                $("img_" + keyindex).src = "images/search/button_foc.png";
            } else {
                if (iskey) {
                    if (keyindex <= 20) {
                        $("img_" + keyindex).src = "images/btn_trans.gif";
                        keyindex += 7;
                        $("img_" + keyindex).src = "images/search/button_foc.png";
                    } else {
                        $("img_" + keyindex).src = "images/btn_trans.gif";
                        btnfocus=true;
                        $("btn_ok").src="images/vod/btv-02-bg-playclick.png";
                    }
                } else {
                    if (vodindex >= 0 && vodindex < leng - 1) {
                        textScroll(-1);
                        changeImg(-1);
                        vodindex++;
                        changeImg(1);
                        textScroll(1);
                    }else{
                        /*
                        if (endIndex < totalCount) {
                            startIndex++;
                            endIndex++;
                            showSearchList();
                        }
                        */
                        pageNext();
                    }
                }
            }
        }
        function keyUp(){
            if(!inputfocus){
                if(iskey){
                  if(btnfocus){ //按钮有交点时候按向上键
                      $("img_" + keyindex).src = "images/search/button_foc.png";
                      $("btn_ok").src="images/search/search_button.png";
                      btnfocus=false;
                  }else{
                      if(keyindex >6){
                         $("img_" + keyindex).src = "images/btn_trans.gif";
                         keyindex-=7;
                         $("img_" + keyindex).src = "images/search/button_foc.png";
                      }else{
                          $("result").focus();
                          inputfocus=true;
                         $("img_" + keyindex).src = "images/btn_trans.gif";
                      }
                  }
               }else{
                  if(vodindex >0 && vodindex<=leng-1){
                      changeImg(-1);
                      textScroll(-1);
                      vodindex--;
                      changeImg(1);
                      textScroll(1);
                  }else{
                      /*
                      if (startIndex > 0) {
                          startIndex--;
                          if(leng==9)endIndex--;
                          showSearchList();
                      }
                      */
					  action = "up";
                      pagePrev();
                  }
               }
            }
        }
        function keyLeft(){
           if(!inputfocus){
               if(iskey){
                   if(btnfocus){ //按钮有交点时候按向上键
                       $("img_" + keyindex).src = "images/search/button_foc.png";
                       $("btn_ok").src="images/search/search_button.png";
                       btnfocus=false;
                   }
                   focus=false;
                   $("img_" + keyindex).src = "images/btn_trans.gif";
                   if(keyindex > 0 && keyindex <keyleng){
                       keyindex--;
                   }else{
                       keyindex=keyleng-1;
                   }
                   if(keyindex ==6 || keyindex ==13 || keyindex ==20 || keyindex ==27){
                      focus=true;
                   }
                   $("img_" + keyindex).src = "images/search/button_foc.png";
               }else{
                  toLeftFocus();
                  iskey=true;
                  focus=false;
                  $("img_" + keyindex).src = "images/search/button_foc.png";
                  $("resultbar" + vodindex).style.visibility = "hidden";                  
               }
           }
        }
        function toLeftFocus(){
            if(vodindex <2){
                 keyindex=6;
            }else if(vodindex >=2 && vodindex <4){
                 keyindex=13;
            }else if(vodindex >=4 && vodindex <6){
                 keyindex=20;
            }else if(vodindex >=6 && vodindex<9){
                 keyindex=27;
            }
        }
        function keyRight() {
            if (inputfocus) { //vod获取焦点
               inputfocus=false;
               $("focus").focus();
               if(leng >0){
                  iskey=false;
                  changeImg(1);
                  textScroll(1);
               }
            } else {
                if(btnfocus){ //按钮有交点时候按向上键
                    $("img_" + keyindex).src = "images/search/button_foc.png";
                    $("btn_ok").src="images/search/search_button.png";
                    btnfocus=false;
                }
                if (iskey && focus == false) {
                    if (leng == 0) { //搜索结果类表没有数据
                        $("img_" + keyindex).src = "images/btn_trans.gif";
                        if (keyindex >= 0 && keyindex < keyleng - 1) {
                            keyindex++;
                        } else {
                            keyindex = 0;
                        }
                        $("img_" + keyindex).src = "images/search/button_foc.png";
                    } else {//搜索结果列表有数据
                        if (keyindex != 6 && keyindex != 13 && keyindex != 20 && keyindex != 27) {
                            $("img_" + keyindex).src = "images/btn_trans.gif";
                            keyindex++;
                            $("img_" + keyindex).src = "images/search/button_foc.png";
                        } else {
                            $("img_" + keyindex).src = "images/btn_trans.gif";
                            focus = true;//焦点交给右边节目列表
                            iskey=false;
                            changeImg(1);
                            textScroll(1);
                        }
                    }
                }
            }
        }
        function pageNext(){
            /*
             if (endIndex < totalCount) {
                startIndex = endIndex;
                if ((endIndex + 9) <=totalCount) {
                    endIndex += 9;
                } else {
                    endIndex = totalCount;
                }
                changeImg(-1);
                vodindex = 0;
                showSearchList();
            }
            */
            if(destpage<pageCount){
                destpage++;
            }else{
                destpage = 1;
            }
            changeImg(-1);
            vodindex = 0;
            loadResult();
        }
        function pagePrev() {
            /*
            if (startIndex > 0) {
                if (startIndex>= 0 && endIndex>19) {
                    startIndex -= 9;
                    endIndex =startIndex+9;
                } else {
                    startIndex =0;
                    endIndex = 9;
                }
                changeImg(-1);
                vodindex = 0;
                showSearch();
            }
            */
            if(destpage >1){
                destpage --;
            }else{
                destpage = pageCount;
            }
            changeImg(-1);
            vodindex = 0;
            loadResult();
        }
        function keyOK() {
            if (inputfocus || btnfocus) {
               searchClick();
            }else if(iskey==false){
                goDetail();
            }else {
              inputValue(); 
            }
        }
        function inputValue(){
            if (keyindex == 20) {
                var str = $("result").value;
                $("result").value = str.substring(0, str.length - 1);
            } else if (keyindex == 27) {
                $("result").value = $("result").value + " ";
            } else {
                var result = keyWord[keyindex];
                $("result").value += result;
            }
        }
    </script>
    <script type="text/javascript">
        function searchClick(){
            startIndex=0;
            endIndex=9;
            vodindex=0;
			destpage = 1;
            var temptitle=$("result").value;
            if(temptitle.length>0){
			    title = temptitle;
                loadResult();
            }
        }
        function loadResult(){
            var requestUrl = "action/vod_search_data.jsp?columnid=<%=columnid%>&destpage="+destpage+"&title=" + title;
            var loaderSearch = new net.ContentLoader(requestUrl, showResult);
        }
        function showResult(){
            var results = this.req.responseText;
            data = eval("(" + results + ")");
//            temparr = data.vodData;
//            totalCount=temparr.length;
            arr = data.vodData;
            totalCount=parseInt(data.totalCount);
            destpage =parseInt(data.destpage);
            pageCount =parseInt(data.pageCount);
           // alert("SSSSSSSSSSSSSSSSSSSStotalCount="+totalCount);
			
//            if(endIndex>totalCount) endIndex=totalCount;
            showSearchList();
        }
        function showSearchList(){
            clearResultdiv() ;
//            arr=new Array();
//            for (var i = startIndex; i < endIndex; i++) {
//                arr.push(temparr[i]);
//            }
            leng = arr.length;
			if(action == "up"){
			   vodindex = leng-1;
			   action = "";
			}
		//	alert("SSSSSSSSSSSSSSSSSSSSleng="+leng);
            if (leng > 0) {
                for (var i = 0; i <leng; i++) {
                    $("result_div" + i).innerText = writeFitString(arr[i].programname, 18, 270);
                }
                inputfocus=false;
                $("focus").focus();
                $("btn_ok").src="images/search/search_button.png";
                btnfocus=false;
                iskey=false;
                changeImg(1);
                textScroll(1);
            }
            showPage();
        }
        function clearResultdiv() {
            for (var i = 0; i < 9; i++) {
                $("result_div" + i).innerText = "";
                $("resultbar" + i).style.visibility = "hidden";                
            }
        }
        function changeImg(flag){
            if(flag==1){
                $("resultbar" + vodindex).style.visibility = "visible";
            }else{
                $("resultbar" + vodindex).style.visibility = "hidden";
            }
        }
        function textScroll(doi) {                            
            if (doi == 1) {
                scrollString("result_div" + vodindex, arr[vodindex].programname, 18, 270);
            }
            if (doi == -1) {
                stopscrollString("result_div" + vodindex, arr[vodindex].programname, 18, 270);
            }
        }
        function showPage() {
		    if(pageCount>1){
				$("pre").style.visibility = "visible";
				$("next").style.visibility = "visible";		
			}else{
				$("pre").style.visibility = "hidden";
				$("next").style.visibility = "hidden";				
			}

            if (totalCount > 0) {
                $("count").innerText = "共找到" + totalCount + "个搜索结果";
				$("pageinfo").innerText = destpage+"/"+pageCount;
            } else {
                $("count").innerText = "共找到0个搜索结果";
				$("pageinfo").innerText = "";
            }
        }
        function goDetail(){
            saveParam();
            if(arr[vodindex].programtype == "1"){
                    var url="vod_detail.jsp?<%=EpgConstants.COLUMN_ID%>="+arr[vodindex].columnid
                        +"&<%=EpgConstants.PROGRAM_ID%>="+arr[vodindex].programid
                        +"&<%=EpgConstants.PROGRAM_TYPE%>="+arr[vodindex].programtype
                        +"&<%=EpgConstants.CONTENT_ID%>="+arr[vodindex].contentcode
                        +"&columnpath=<%=columnpath%>"
                        +"&programname="+arr[vodindex].programname;
                document.location=encodeURI(encodeURI(url));
                }else if(arr[vodindex].programtype == "14"){
                   var url="vod_series_list.jsp?<%=EpgConstants.COLUMN_ID%>="+arr[vodindex].columnid
                        +"&<%=EpgConstants.PROGRAM_ID%>="+arr[vodindex].programid
                        +"&<%=EpgConstants.PROGRAM_TYPE%>="+arr[vodindex].programtype
                        +"&<%=EpgConstants.CONTENT_ID%>="+arr[vodindex].contentcode
                        +"&columnpath=<%=columnpath%>"
                        +"&programname="+arr[vodindex].programname;
                        +"&<%=EpgConstants.SERIES_PROGRAMCODE%>="+arr[vodindex].programid+"&vodtype=100";
                document.location=encodeURI(encodeURI(url));
                }

        }
        function saveParam(){
            var title=$("result").value;;
            var cache=title+"|"+destpage+"|"+endIndex+"|"+vodindex;
            top.jsSetControl("cache",cache);
        }
        function init(){
            var cache=top.jsGetControl("cache");
            if (cache != "" && cache != null && cache != "undefined" && cache != "null") {
                var paramarr = cache.split("|");
                title = paramarr[0];
                destpage = parseInt(paramarr[1]);
                endIndex = parseInt(paramarr[2]);
                vodindex = paramarr[3];
                clearStack();
                //初始化相关参数
                inputfocus = false;//输入框失去焦点
                $("focus").focus();
                //输入框还原关键字
               $("result").value=title;
                //焦点控制在右边
                iskey = false;
                loadResult();
            } else {
                $("img_" + keyindex).src = "images/search/button_foc.png";
            }
            document.onkeypress = KeyPress;
        }

        function donothing(){
//            alert("SSSSSSSSSSSSSSSSSdonothing");
        }

        function disableNumKey() {
//            alert("SSSSSSSSSSSSSSSSSSSSSSSdisableNumKey!!!!");
            top.jsSetupKeyFunction("top.mainWin.donothing", 280);
            for (var j = 0; j < 10; j++) {
                top.keyFuncArray[top.keyCodeArray["onKeyNumChar"] + j] = "top.mainWin.donothing";
            }
        }

        function enableNumKey() {
            top.jsEnableNumKey();
        }
    </script>
</head>

<body bgcolor="transparent" onLoad="init();">

<div id="div0" style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
   <img src="images/vod/btv_bg.png" height="720" width="1280" alt="" border="0">
</div>
<!--顶部信息-->
<%@ include file="inc/time.jsp" %>
<%--<div style="position:absolute; width:22; height:35; left:39px; top:18px;">--%>
	<%--<img src="images/search/TV.png" border="0">--%>
<%--</div>--%>

<%--<div id="path" style="position:absolute; width:760px; height:51px; left:90px; top:22px;font-size:24px;color:#FFFFFF">--%>
    <%--我的TV>导视--%>
<%--</div>--%>
<div class="topImg" style="font-size:20px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/channel/btv-mytv-ico.png'); left:13; top:8px; width:41px; height:38px; position:absolute; ">
    </div>
    <div align="left" style="font-size:24px; line-height:50px; left:58; top:4px; width:260px; height:35px; position:absolute; ">
          搜索
    </div>
</div>

<div id="s_text" style="position:absolute; width:700px; height:34px; left:75px; top:91px;font-size:26px;color:#FFFFFF">
请输入影片名称的首字母组合</div>
<div style="position:absolute; width:500px; height:34px; left:49px; top:1px">
    <a href="#" id="focus"><img src="images/btn_trans.gif" width="1" height="1" border="0"/></a>
</div>

<div  style="position:absolute; background-image:url(images/search/input.png); width:700px; height:68px; left:75px; top:142px;"></div>
<div  style=" position:absolute; width:683px; height:53px; left:82px; top:149;">
    <input onFocus="disableNumKey();" onBlur="enableNumKey();" id="result" type="text" size="45" height="53" onClick="searchClick();" style="width:685px; height: 53px; font-size:32px;border-style:none;border-bottom-style: none; background-color:#999999">
</div>
<div id="div" style="position:absolute; width:700px; height:400px; left:74px; top:230px;">
<%
        for (int i = 0; i < words.length; i++) {
            int frow = i / 7;
            int fcol = i % 7;
            int left = 5+fcol * 103;
            int top =  5+frow * 82;
            int fontSize=34;
            if(i==27){
               fontSize=30;
            }
    %>
    <div style="position:absolute; width:90px; height:90px; left:<%=left-10%>px; top:<%=top-11%>px;">
        <img id="img_<%=i%>" src="images/btn_trans.gif" width="90" height="90" alt="">
    </div>
    <div style="position:absolute;width:70px; height:70px; left:<%=left%>px; top:<%=top%>px;">
        <img id="img_<%=i%>" src="images/search/button_nor.png" width="70" height="70" alt="">
    </div>
    <div id="keynum_<%=i%>" style="position:absolute; width:70px; height:70px; left:<%=left+5%>px; top:<%=top+16%>px;color:#000000;font-size:<%=fontSize%>px" align="center">
        <%=words[i]%>
    </div>
    <%
        }
    %>
</div>

 <div style="position:absolute; width:395px; height:553px; left:820; top:85px">
       <img src="images/search/bg_right.png" alt="" border="0" height="545" width="395">
 </div>
<div style="position:absolute; width:393px; height:553px; left:820; top:85px;">
    <div id="count" style="position:absolute;  left:0; top:10;width:393; height:50;font-size:24px;color:#FFFFFF" align="center"></div>
    <!--翻页图标 -->
    <div id="pre" style="position:absolute; width:25px; height:14px; left:190px; top:60px;visibility:hidden">
        <img   src="images/vod/btv_up.png" height="14" width="25" alt="" border="0">
    </div>

    <div id="next" style="position:absolute; width:25px; height:14px; left:190px; top:520px;visibility:hidden">
        <img  src="images/vod/btv_down.png" height="14" width="25" alt="" border="0">
    </div>
	
	<div id="pageinfo" style=" position:absolute; width:65px; height:14px; left:330px; top:515px; font-size:20px; color:#FFFFFF;">    
    </div>

    <div style="position:absolute;  left:0; top:0;width:393; height:530;">
        <%
            for (int i = 0; i < 9; i++) {

        %>
        <div id="resultbar<%=i%>" style="background:url('images/search/focus.png');position:absolute;left:0; top:<%=i*48+80%>;width:394; height:43;visibility:hidden;">
        </div>
        <div id="result_div<%=i%>" style="position:absolute;  left:28; top:<%=87+i*48%>;width:365; height:30;color:#FFFFFF;font-size:24px" align="left"></div>
        <%
            }
        %>
    </div>
</div>

 <div style="position:absolute;  left:326px; top:574px;width:136; height:40px;">
 	<img id="btn_ok" src="images/search/search_button.png" width="136" height="36" border="0">
 </div>
  <div  style="position:absolute;  left:326px; top:579px;width:135px; height:28px;font-size:24px;color:#FFFFFF" align="center">
 	搜索
 </div>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
</html>
