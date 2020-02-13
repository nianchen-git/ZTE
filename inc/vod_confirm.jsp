<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%
    if(strProgramid==null){
     strProgramid="";}
%>
<html>
<head>
    <title>music_video_playlist</title>
    <script type="text/javascript">
        var moveindex = 0;
        var programtype;
        var playurl;
        var point;
        var isOrder = false;
        //产品相关
        var proIndex = 0;
        var isPro = false;
        var maxindex=0;
        var urlArr=new Array();
        var bgImg = ["images/btn_trans.gif","images/btn_trans.gif","images/vod/btv-02-add-bookmarkquit.png"];
        var focusImg = ["images/vod/btv-02-bookmarkplaybg.png","images/vod/btv-02-bookmarkplaybg.png","images/vod/btv-02-bg-playclick.png"];
        var $$ = {};
        var $ = function(id) {
            if (!$$[id]) {
                $$[id] = document.getElementById(id);
            }
            return $$[id];
        }
        var doMusicAuth = function(columnid, programid, programType, contentid, leefocus,programnamea,strADid,strADid2) {
            programtype = programType;
            var url = "";
			//var programnamea = encodeURI(programname);
            if (programType ==10) {
                     url = "vod_auth_orderlist.jsp?columnid=" + columnid
                        + "&programid="+programid+"&programtype=10"
                        + "&FatherContent=<%=contentcode%>&ContentType=14&ContentID=<%=strProgramid%>"
                        + "&CategoryID=" + columnid +"&seriesProgramId=" + programid+ "&seriesprogramcode="+contentid+"&leefocus=" + leefocus+"&programname=" + programnamea
						+ "&strADid="+strADid+ "&strADid2="+strADid2;
//                url = "vod_auth_orderlist.jsp?columnid=" + columnid
//                        + "&programid=" + programid + "&programtype=1"
//                        + "&FatherContent=" + contentid + "&ContentType=10&ContentID=" + programid
//                        + "&CategoryID=" + columnid + "&leefocus=" + leefocus;
            } else {
                url = "vod_auth_orderlist.jsp?columnid=" + columnid
                        + "&programid=" + programid + "&programtype=1&FatherContent=" + programid
                        + "&ContentType=1&ContentID=" + programid
                        + "&CategoryID=" + columnid + "&leefocus=" + leefocus+"&programname=" + programnamea+"&strADid="+strADid+ "&strADid2="+strADid2;
            }
            top.mainWin.frames["hiddenFrame"].document.location = url;
		     // top.mainWin.document.location = url;
        }
        var showOrder = function(index, url, strProductName, strprice,leng) {
              var tempProductName = strProductName;
			if(tempProductName.length>20){
			    tempProductName = tempProductName.substr(0,20)+"...";
			    			}           
		$("product_" + index).innerText = tempProductName;
            $("price_" + index).innerText = strprice;
            urlArr[urlArr.length] = url;
            isOrder = true;
            maxindex=leng-1;
            proIndex=0;
            $("detail").style.visibility = "hidden";
            $("orderlist").style.visibility = "visible";
            $("move_bar"+proIndex).style.visibility = "visible";
            document.onkeypress = tipKeyPress;
        }
        var showTips = function(playUrl, breakpoint) {
            playurl = playUrl;
            point = breakpoint;
            $("authmsg").style.visibility = "visible";
            document.onkeypress = tipKeyPress;
        }
        var tipKeyPress = function (evt) {
            var keyCode = parseInt(evt.which);
            if (keyCode == 0x0028) { //Down
                tipkeyDown();
            } else if (keyCode == 0x0026) { //Up
                tipkeyUp();
            } else if (keyCode == 0x0008 || keyCode == 24) {///back
                cancle();
            } else if (keyCode == 0x000D) {  //OK
                tipOK();
            } else if (keyCode == 0x0025) { //onKeyLeft
                tipLeft();
            } else if (keyCode == 0x0027) { //onKeyRight
                tipRight();
            } else {
                commonKeyPress(evt);
                return true;
            }
            return false;
        }

        var cancle = function() {
            $("authmsg").style.visibility = "hidden";
            $("orderlist").style.visibility = "hidden";
            $("move_bar"+proIndex).style.visibility = "hidden";
            initPage();
            $("detail").style.visibility = "visible";
                document.onkeypress = mykeypres;
            
        }
        var tipkeyDown = function() {
            if (isOrder) {
                if(proIndex >=0 && proIndex<maxindex){
                    moveBar(1);
                    proIndex++;
                    moveBar(-1);
                }else{
					urlArr = new Array();
                    top.mainWin.frames["hiddenFrame"].donext();//翻页
                }
            } else {
                if (moveindex >= 0 && moveindex < 2) {
                    changeTipImg(-1);
                    moveindex++;
                    changeTipImg(1);
                }
            }
        }
        var tipkeyUp = function() {
            if (isOrder) {
                if (proIndex > 0 && proIndex <= maxindex) {
                    moveBar(1);
                    proIndex--;
                    moveBar(-1);
                } else {
					urlArr = new Array();
                    top.mainWin.frames["hiddenFrame"].dolast();//翻页
                }
            } else if (parseInt(moveindex)>0 && parseInt(moveindex) <= 2)
            {
                changeTipImg(-1);
                moveindex--;
                changeTipImg(1);
            }
        }
       var clearDiv=function(){
           for(var i=0;i<5;i++){
               $("move_bar"+i).style.visibility="hidden";
               $("product_"+i).innerText="";
               $("price_"+i).innerText="";
           }
       }
        var tipLeft = function() {
            cancle();
            if (programtype !=0) {
                 //$("detail").style.visibility = "visible";
                //document.onkeypress = detailKeyPress;
                detailKeyLeft();
            } else {
                 //$('favorite_linker').focus();
                //$("detail").style.visibility = "visible";
                //document.onkeypress = top.doKeyPress;
            }
        }
        var tipRight = function() {
            cancle();
            if (programtype !=0) {
                 //$("detail").style.visibility = "visible";
                //document.onkeypress = detailKeyPress;
                detailKeyRight();
            } else {
                 $('favorite_linker').focus();
                //$("detail").style.visibility = "visible";
                //document.onkeypress = top.doKeyPress;
            }
        }
        var changeTipImg = function (flag) {
            if (flag == 1) {
                $("img" + moveindex).src = focusImg[moveindex];
            } else {
                $("img" + moveindex).src = bgImg[moveindex];
            }
        }
        var initPage = function() {
            moveindex = 0;
            urlArr = new Array();
            playurl = "";
            proIndex = 0;
            isOrder = false;
            $("img0").src = focusImg[0];
            $("img1").src = bgImg[1];
            $("img2").src = bgImg[2];
        }
        var tipOK = function() {
            if (isOrder) {
                $("orderlist").style.visibility="hidden";
                $("detail").style.visibility="visible";
                isOrder=false;
                moveindex=0;
                top.mainWin.frames["hiddenFrame"].document.location = urlArr[proIndex];
            } else {
                if (moveindex == 0) {
                    play(point);
                } else if (moveindex == 1) {
                    play(0);
                } else if (moveindex == 2) {
                    cancle();
                }
            }
        }
        var play = function(breakpoint) {
          //  alert("SSSSSSSSSSSSSSSSSSSSSSSplay!!!!!!");
			top.doStop();//停掉直播流
        top.jsStopList();
		top.jsHideOSD();
            document.location = encodeURI(encodeURI(playurl)) + breakpoint;
            cancle();
        }
        function doNathing(){
            
        }
        var showError = function(type) {
            document.onkeypress=doNathing;
            if (type == 9203) {
                $("textMsg").innerText = "很抱歉，您所选择的是付费内容，您暂无访问权限";
            } else if (type == -1){
                $("textMsg").innerText = "鉴权失败！";
            }else{
                $("textMsg").innerText = "订购失败！";
            }
            $("errormsg").style.visibility = "visible";
            var timeer = window.setTimeout(hiddenMsg, 6000);
        }
        function hiddenMsg() {
            $("errormsg").style.visibility = "hidden";
            cancle();
        }
        function moveBar(flag) {
            $("move_bar" + proIndex).style.visibility = flag == 1 ? "hidden" : "visible";
        }
    </script>
</head>
<body bgcolor="transparent" >
<!--book Mark--->
<div style="left:430px; top:300px;width:300px;height:200px; position:absolute;z-index:2000">
    <div id="authmsg" style="left:0px; top:0px;width:300px;height:200px; position:absolute; visibility:hidden">
        <div style="left:0px;top:0px;width:250px;height:200px;position:absolute;">
            <img src="images/vod/btv10-2-bg01.png" alt="" width="300" height="200" border="0"/>
        </div>

        <div style="left:0px;top:30px;width:300px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
            <img id="img0" src="images/vod/btv-02-bookmarkplaybg.png" alt="" width="200" height="41" border="0"/>
        </div>
        <div style="left:0px;top:37px;width:300px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
            从书签处播放
        </div>

        <div style="left:0px;top:90px;width:300px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
            <img id="img1" src="images/btn_trans.gif" alt="" width="200" height="41" border="0"/>
        </div>
        <div style="left:0px;top:97px;width:300px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
            从头播放
        </div>

        <div style="left:0px;top:155px;width:300px;height:34px;z-index:6;position:absolute;" align="center">
            <img id="img2" src="images/vod/btv-btn-cancel.png" alt="" width="100" height="36" border="0"/>
        </div>
        <div style="left:0px;top:160px;width:300px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
            取消
        </div>
    </div>
</div>

<!--error message-->
<div id="errormsg" style="left:485px; top:260px;width:310px;height:200px; position:absolute;z-index:2000;visibility:hidden;">
    <div style="left:0px;top:0px;width:310px;height:200px;position:absolute;">
        <img src="images/vod/blackname_bg.jpg" alt="" width="310" height="200" border="0"/>
    </div>
    <div id="textMsg"
         style="left:0px;top:30px;width:300px;height:34px;z-index:6;font-size:24px;color:#FFFFFF;position:absolute;"
         align="center">

    </div>
    <div style="left:0px;top:160px;width:300px;height:34px;z-index:6;font-size:24px;color:#FFFFFF;position:absolute;"
         align="center">
        6秒自动关闭
    </div>
</div>

<div id="orderlist" style="background:url('images/vod/vstore_bg.png'); left:380px; top:86px; width:500;height:295; position:absolute;font-size:20px;color:#FFFFFF;visibility:hidden">
    <div style="left:25px; top:100px; position:absolute;width:100;height:30">产品名称</div>
    <div style="left:360px; top:100px; position:absolute;width:80;height:30;">价格</div>
    <%
        for (int i = 0; i < 5; i++) {

    %>
    <div id="move_bar<%=i%>"
         style="left:15px; top:<%=i*30 +135%>px; position:absolute;width:380;height:30;visibility:hidden">
        <img src="images/vod/vstore_select.png" alt="" width="440" height="30">
    </div>

    <div id="product_<%=i%>" style="left:25px;top:<%=i*30 +135%>px; position:absolute;width:343;height:30"></div>
    <div id="price_<%=i%>" style="left:370px; top:<%=i*30 +135%>px; position:absolute;width:80;height:30;"></div>
    <%
        }
    %>
</div>

<div id="fdiv" style="left:0px; top:0px;width:1;height:1px;  position:absolute;">
    <iframe id="hiddenFrame" width="1" height="1" name="hiddenFrame" src="" border="0" scrolling="NO"
            style="background-color:transparent ">
    </iframe>
</div>
</body>
</html>

