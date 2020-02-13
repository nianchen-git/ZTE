<%@page contentType="text/html; charset=GBK" %>
<script type="text/javascript">
    var timer_favorite_msg;

    function showMsg() {
        var results = this.req.responseText;
        var tempData = eval("(" + results + ")");
        dellflag = tempData.requestflag;
        if (dellflag == 0) {
            $("text").innerText = "收藏成功";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer_favorite_msg);
            timer_favorite_msg = setTimeout(closeMessage, 2000);
        } else if (dellflag == 2) {
            $("text").innerText = "节目已收藏";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer_favorite_msg);
            timer_favorite_msg = setTimeout(closeMessage, 2000);
        } else if (dellflag == 3) {
            $("text").innerText = "您的收藏已达上限，请在我的收藏中整理收藏后继续收藏";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "hidden";
            $("favMax").style.visibility = "visible";
            clearTimeout(timer_favorite_msg);
            showFavMsg();
        } else {
            $("text").innerText = "收藏失败";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer_favorite_msg);
            timer_favorite_msg = setTimeout(closeMessage, 2000);
        }
    }

    function showFavMsg() {
        $("fav_0").src = "images/vod/btv-btn-cancelclick.png";
        favIndex = 0;
        document.onkeypress = cancelKeyPress;
    }

    function cancelKeyPress(evt) {
        var keyCode = parseInt(evt.which);
    //    alert("SSSSSSSSSSSSSSScancelKeyPress");
        if (keyCode == 0x0028) { //onKeyDown

        } else if (keyCode == 0x0026) {//onKeyUp

        } else if (keyCode == 0x0025) { //onKeyLeft
            cancelKeyLeft();
        } else if (keyCode == 0x0027) { //onKeyRight
            cancelKeyRight();
        } else if (keyCode == 0x0008 || keyCode == 24) {///back

        } else if (keyCode == 0x000D) {  //OK
            cancelKeyOK();
        } else {
            commonKeyPress(evt);
            return true;
        }
        return false;
    }
    var favIndex=0;
    function cancelKeyLeft() {
//        alert("SSSSSSSSSSSSSSSSSSScancelKeyLeftfavIndex="+favIndex);
        if (favIndex == 1) {
            favIndex = 0;
            $("fav_1").src = "images/vod/btv-btn-cancel.png";
            $("fav_0").src = "images/vod/btv-btn-cancelclick.png";
        }
    }
    function cancelKeyRight() {
//        alert("SSSSSSSSSSSSSSSSSSScancelKeyRightfavIndex="+favIndex);
        if (favIndex == 0) {
            favIndex = 1;
            $("fav_0").src = "images/vod/btv-btn-cancel.png";
            $("fav_1").src = "images/vod/btv-btn-cancelclick.png";
        }
    }
</script>
<!---收藏提示信息-->
<div style="left:460px; top:300px;width:568px;height:215px; position:absolute;z-index:2000">
    <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
        <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
            <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
        </div>
        <div id="text"
             style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">

        </div>


        <div id="closeMsg"
             style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;visibility:hidden;"
             align="center">
            2秒自动关闭
        </div>

        <div id="favMax"
             style="left:0px;top:160px;width:392px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;visibility:hidden">
            <div style="left:40px;top:0px;width:140px;height:36px;z-index:6;position:absolute;">
                <img id="fav_0" src="images/vod/btv-btn-cancel.png" width="136" height="36">
            </div>
            <div style="left:40px;top:5px;width:140px;height:36px;z-index:6;position:absolute;" align="center">
                立即整理
            </div>

            <div style="left:220px;top:0px;width:140px;height:36px;z-index:6;;position:absolute;">
                <img id="fav_1" src="images/vod/btv-btn-cancel.png" width="136" height="36">
            </div>
            <div style="left:220px;top:5px;width:140px;height:36px;z-index:6;;position:absolute;" align="center">
                下次再说
            </div>
        </div>
    </div>
</div>