<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController name="setting_cu.jsp"/>
<html>
<head>
    <title>order list</title>
    <script type="text/javascript">
        var setArr = [
            ["PAL制式","NTSC制式"],
            ["720P制式","1080I制式"],
            ["平滑切换","最后一帧","黑屏模式"],
            ["开机进入EPG","开机进入频道"],
            ["16:9","4:3","视频原始比例","全屏比例"],
            ["不透传方式","透传方式"]
        ];
        var setIndex = [
            [1,2],
            [4,6],
            [2,1,0],
            [0,1],
            [0,1,2,3],
            [0,1]
        ];
        var saveInfo = [];

        var $$ = {};
        function $(id) {
            if (!$$[id]) {
                return document.getElementById(id);
            }
            return $$[id];
        }
        var index = 0;
        var isBtn = false;
        var isShow = false;
        var showTimer=-1;
        var mindex=0;
        function KeyPress(evt) {
            var keyCode = parseInt(evt.which);
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
            } else if (keyCode == 0x000D) {  //OK
                keyOK();
            } else {
                commonKeyPress(evt);
                return true;
            }
            return false;
        }
        function keyDown() {
//            alert("SSSSSSSSSSSSSSkeyDown_isShow="+isShow);
//            alert("SSSSSSSSSSSSSSkeyDown_isBtn="+isBtn);
            if (!isShow) {
                if (isBtn) {
//                    moveBar(1);
//                    $("btn").src = "images/vod/btv-btn-cancel.png";
//                    isBtn = false;
                } else {
                    if (index >= 0 && index < 5) {
                        moveBar(-1);
                        index++;
                        moveBar(1);
                    } else {
                        moveBar(-1);
                        $("btn").src = "images/vod/btv-btn-cancelclick.png";
                        isBtn = true;
                    }
                }
            }
        }
        function keyUp() {
            if(!isShow){
                if (isBtn) {
                    moveBar(1);
                    $("btn").src = "images/vod/btv-btn-cancel.png";
                    isBtn = false;
                } else {
                    if (index > 0 && index <= 5) {
                        moveBar(-1);
                        index--;
                        moveBar(1);
                    }
                }
            }
        }
        function keyLeft() {
//            alert("SSSSSSSSSSSSSSSSSSSisShow="+isShow);
            if (isShow) {
                mindex=0;
               $("orderImg").style.left=70;
            }else if(!isBtn){
                var tempArr = setArr[index];
                var tempindex=getTempIndex(setIndex[index],saveInfo[index]);
                if (tempindex > 0 && tempindex <= tempArr.length - 1) {
                    tempindex--;
                } else {
                    tempindex = tempArr.length - 1;
                }
                saveInfo[index] = setIndex[index][tempindex];
                $("set" + index).innerText = tempArr[tempindex];
            }
        }
        function keyRight() {
//            alert("SSSSSSSSSSSSSSSSSSSisShow="+isShow);
            if (isShow) {
               mindex=1;
               $("orderImg").style.left=220;
            }else if(!isBtn){
                var tempArr = setArr[index];
                var tempindex=getTempIndex(setIndex[index],saveInfo[index]);
                if (tempindex >= 0 && tempindex < tempArr.length - 1) {
                    tempindex++;
                } else {
                    tempindex = 0;
                }
                saveInfo[index] = setIndex[index][tempindex];
                $("set" + index).innerText = tempArr[tempindex];
            }
        }

        function getTempIndex(arr,index){
           for(var i=0;i<arr.length;i++){
               if(arr[i]==index){
                   return i;
               }
           }
            return true;
        }
        function moveBar(flag) {
            $("movebar_" + index).style.visibility = flag == 1 ? "visible" : "hidden";
        }
        function back() {
            document.location = "back.jsp";
        }
        function keyOK() {
            if(isShow){
                hiddenSetMessage();
            }else{
                if (isBtn) {
                    saveSettingInfo();
                }
            }
        }

        document.onkeypress = KeyPress;

        function ioctrlWrite(attrName, value) {
            //alert("CUSetConfig  attrName ="+attrName+"_value="+value);
            Authentication.CUSetConfig(attrName,value);
        }

        function ioctrlRead(attrName) {
            var value =  Authentication.CUGetConfig(attrName);
            return value ;
        }
        function init() {
             /* 标清制式设置	 "1":PAL制式   "2":NTSC制式 */
            var str1 = ioctrlRead("standard");
            str1 = (str1 == undefined || str1 == "" || str1 == " ")?1:str1;
            /* 高清制式设置	 "4":"720P", "6": "1080I" */
            var str2 = ioctrlRead("hd_standard");
            str2 = (str2 == undefined || str2 == "" || str2 == " ")?4:str2;
            /* 频道切换方式	 "2":平滑切换 "1":最后一帧  "0":黑屏模式 */
            var str3 = ioctrlRead("stop_blank");
            str3 = (str3 == undefined || str3 == "" || str3 == " ")?2:str3;
            /* 开机进入方式	 "0":开机进入EPG   	"1":开机进入频道 */
            var str4 = ioctrlRead("channel_memory");
            str4 = (str4 == undefined || str4 == "" || str4 == " ")?0:str4;
            /*  视频宽高比	     "0":16:9比例  "1":4:3比例 "2":视频原始比例 "3":全屏比例 */
            var str5 = ioctrlRead("content_mode");
            str5 = (str5 == undefined || str5 == "" || str5 == " ")?0:str5;
            /*  SPDF音频模式	 "0":不透传方式（自解码）  "1":透传方式  */
            var str6 = ioctrlRead("spdif_format");
            str6 = (str6 == undefined || str6 == "" || str6 == " ")?0:str6;
            saveInfo = [str1,str2,str3,str4,str5,str6];
            selectItem(setIndex[0], 0, str1);
            selectItem(setIndex[1], 1, str2);
            selectItem(setIndex[2], 2, str3);
            selectItem(setIndex[3], 3, str4);
            selectItem(setIndex[4], 4, str5);
            selectItem(setIndex[5], 5, str6);
            $("movebar_0").style.visibility="visible";
        }
        function selectItem(arr, index, value) {
            for (var i = 0; i < arr.length; i++) {
                if (arr[i] == value) {
                    $("set" + index).innerText = setArr[index][i];
                }
            }
        }
        function saveSettingInfo() {
            for (var i = 0; i < saveInfo.length; i++) {
                if (i == 0) {
                    ioctrlWrite("standard", saveInfo[i]);
                }
                if (i == 1) {
                    ioctrlWrite("hd_standard", saveInfo[i]);
                }
                if (i == 2) {
                    ioctrlWrite("stop_blank", saveInfo[i]);
                }
                if (i == 3) {
                    ioctrlWrite("channel_memory", saveInfo[i]);
                }
                if (i == 4) {
                    ioctrlWrite("content_mode", saveInfo[i]);
                }
                if (i == 5) {
                    ioctrlWrite("spdif_format", saveInfo[i]);
                }
            }
			ioctrlWrite("endcfgsetting", "0");
            showSetMessage();
        }
        function showSetMessage() {
//            isShow = true;
            $("setmsg").style.visibility = "visible";
            window.clearTimeout(showTimer);
            showTimer=window.setTimeout(hiddenSetMessage,1000);
        }
        function hiddenSetMessage(){
//            if(mindex=0){
//
//            }else{
//                isShow = false;
//                mindex=0;
                $("setmsg").style.visibility = "hidden";
           window.clearTimeout(showTimer);
//            }
        }

    </script>
</head>
<body bgcolor="transparent">
<div id="div0" style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="" border="0">
</div>
<!--顶部信息-->
<div class="topImg" style="font-size:24px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('images/channel/icon_5.png'); left:13; top:8px; width:53px; height:36px; position:absolute; ">
		<img></img>
    </div>
    <div align="left" style="font-size:24px; line-height:50px; left:67px; top:4px; width:260px; height:35px; position:absolute; ">
          应用 > 用户设置    </div>
</div>

<%@include file="inc/time.jsp" %>

<div style="position:absolute; width:600px; height:480px; left:350px; top:160px;font-size:24px;color:#FFFFFF;"
     align="center">
    <%
        for(int i=0;i<6;i++){
    %>
    <div id="movebar_<%=i%>" style="position:absolute; width:600px; height:40px; left:0px; top:<%=60*i-3%>px;visibility:hidden">
        <div style="position:absolute;left:0;top:0; width:400;height:32"><img src="images/vod/btv-02-bookmarkplaybg.png"alt="" width="600" height="40"></div>
        <div style="position:absolute;left:302;top:6; width:32;height:32"><img src="images/down_left.png" alt=""width="14"height="24"></div>
        <div style="position:absolute;left:500;top:6; width:32;height:32"><img src="images/down_right.png" alt="" width="14"  height="24"></div>
    </div>
    <%
        }
    %>

    <div style="position:absolute; width:165px; height:32px; left:70px; top:5px;" align="left">标清制式设置</div>
    <div id="set0" style="position:absolute; width:170px; height:32px; left:330px; top:5px;" align="center"></div>

    <div style="position:absolute; width:165px; height:32px; left:70px; top:65px; " align="left">高清输出设置</div>
    <div id="set1" style="position:absolute; width:170px; height:32px; left:330px; top:65px;" align="center">
    </div>

    <div style="position:absolute; width:165px; height:32px; left:70px; top:125px;" align="left">频道切换方式</div>
    <div id="set2" style="position:absolute; width:170px; height:32px; left:330px; top:125px;" align="center"></div>

    <div style="position:absolute; width:165px; height:32px; left:70px; top:185px;" align="left">开机进入方式</div>
    <div id="set3" style="position:absolute; width:170px; height:32px; left:330px; top:185px;" align="center"></div>

    <div style="position:absolute; width:165px; height:32px; left:70px; top:245px;" align="left">视频宽高比</div>
    <div id="set4" style="position:absolute; width:170px; height:32px; left:330px; top:245px;" align="center"></div>

    <%--<div style="position:absolute; width:165px; height:32px; left:70px; top:305px;" align="left">SPDIF音频模式</div>--%>
    <div style="position:absolute; width:165px; height:32px; left:70px; top:305px;" align="left">杜比功能</div>
    <div id="set5" style="position:absolute; width:170px; height:32px; left:330px; top:305px;" align="center"></div>


    <div style="position:absolute; width:600px; height:40px; left:0px; top:400px;">
        <img id="btn" src="images/vod/btv-btn-cancel.png" alt=""/>
    </div>
    <div style="position:absolute; width:600px; height:40px; left:0px; top:403px;">
        确定修改
    </div>
</div>
<div id="setmsg" style="left:420px; top:229px;width:394px;height:215px; position:absolute;visibility:hidden;">
    <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
        <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
    </div>
    <div style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:24px;color:#FFFFFF;position:absolute;"
         align="center">
        修改成功！
    </div>
    <div style="left:120px;top:165px;width:150px;height:36px;z-index:6;font-size:24px;color:#FFFFFF;position:absolute;z-index:1" align="center">
        2秒自动消失
    </div>

    <%--<div id="orderImg" style="left:70px;top:159px;width:102px;height:38px;z-index:6;position:absolute;z-index:3"--%>
         <%--align="center">--%>
        <%--<img src="images/vod/btv-btn-cancelclick.png" alt="" width="102" height="38" border="0"/>--%>
    <%--</div>--%>
    <%--<div style="left:70px;top:160px;width:100px;height:36px;z-index:6;position:absolute;z-index:1" align="center">--%>
        <%--<img src="images/vod/btv-btn-cancel.png" alt="" width="100" height="36" border="0"/>--%>
    <%--</div>--%>
    <%--<div style="left:70px;top:165px;width:100px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;z-index:5" align="center">--%>
        <%--立即重启--%>
    <%--</div>--%>

    <%--<div style="left:220;top:160px;width:100px;height:36px;z-index:6;position:absolute;z-index:1" align="center">--%>
        <%--<img src="images/vod/btv-btn-cancel.png" alt="" width="100" height="36" border="0"/>--%>
    <%--</div>--%>
    <%--<div style="left:220px;top:165px;width:100px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;z-index:5" align="center">--%>
        <%--稍后重启--%>
    <%--</div>--%>
</div>
<script type="text/javascript">
    init();
</script>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
</body>
</html>
