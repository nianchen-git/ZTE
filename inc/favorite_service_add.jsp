<%@page contentType="text/html; charset=GBK" %>
<%
    UserInfo userInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
%>
<script type="text/javascript">
    var userid="<%=userInfo.getUserId()%>";
    var favObject = {};
    var favArr = [];
    var timer = -1;
    var $$ = {};

    function $(id) {
        if (!$$[id]) {
            $$[id] = document.getElementById(id);
        }
        return $$[id];
    }
    function isFav(url,cname) {
        var flag = 0;
        var str = ztebw.getAttribute(userid);
        if (!str){
            return 0;
        }
        favArr = eval("(" + str + ")");
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSScname="+cname);
//        alert("SSSSSSSSSSSSSSSSSSSSSSSSSfavArr="+favArr);
        if(favArr==null || favArr==undefined || favArr=="" || favArr=='undefined'){
//            alert("SSSSSSSSSSSSSSSSSSSSSSSSS1111111=");
            favArr = [];
            return 0;
        }
        for (var i = 0; i < favArr.length; i++) {
            if (favArr[i].curl == url && favArr[i].cname==cname) {
                return 1;
            }
        }
        return 0;
    }
    var doRed = function() {
       // alert("SSSSSSSSSSSSSSSSSSSSSSapplication_doRed_isZTEBW="+isZTEBW);
     if(favObject.invalid == 1){
           // alert("SSSSSSSSSSSSSSSSSSSSbulengjiale!!!");
            return;
        }
        if(isZTEBW == false){
            return ;
        }
        var tempUrl = favObject.curl + "";
        if (favObject != null && tempUrl.indexOf("http") ==0) {
            doFav(favObject);
        }
    }
    function doFav(arr) {
//        alert("SSSSSSSSSSSSSSSSSSSSSS2222");
        var flag = isFav(arr.curl,arr.cname);
//        alert("SSSSSSSSSSSSSSSSSSSSSS33333");
        if (flag == 0) {
            favArr.push(arr);
            ztebw.setAttribute(userid, favArr.toJSONString());
        }
        showMsg(flag);
    }
    function showMsg(flag) {
        dellflag = flag;
        if (dellflag == 0) {
            $("text").innerText = "收藏成功";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        } else if (dellflag == 1) {
            $("text").innerText = "该服务已经收藏";
            $("msg").style.visibility = "visible";
            $("closeMsg").style.visibility = "visible";
            clearTimeout(timer);
            timer = setTimeout(closeMessage, 2000);
        }
    }
    function closeMessage() {
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
        $("closeMsg").style.visibility = "hidden";
        clearTimeout(timer);
    }
</script>
 <div style="position:absolute; width:390px; height:38px; left:1050px; top:643px;font-size:22px;">
    <img src="images/vod/btv_Collection.png" alt="" style="position:absolute;left:20;top:0px;">
    <font style="position:absolute;left:100;top:4px;color:#FFFFFF">收藏</font>
</div>
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
    </div>
</div>
