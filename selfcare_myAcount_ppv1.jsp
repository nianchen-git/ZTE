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
<epg:PageController name="selfcare_myAcount_ppv1.jsp"/>

<html>
<head>
    <epg:script/>
    <title>portal page</title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script type="text/javascript">
        var $$ = {};

        var index=0;
        var destpage=1;
        var pageCount;
        var data;
        var arr;
        var leng=0;
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
            if (keyCode == 0x0028)//onKeyDown
            {
               keyDown();
            }
            else if (keyCode == 0x0026)//onKeyUp
            {
                keyUp();
            } else if (keyCode == 0x0025) { //onKeyLeft
            }
            else if (keyCode == 0x0027) { //onKeyRight

            } else if (keyCode == 0x0008  || keyCode == 24) {///back
               back();
            }else if(keyCode == 0x0022){  //page down
               pageNext();
            } else if (keyCode == 0x0021) { //page up
                pagePrev();
            }else if (keyCode == 0x000D) {  //OK
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

        }
        function keyUp(){

        }
        function pageNext(){
            if(pageCount >1){
                if(destpage < pageCount){
                    destpage++;
                }else{
                    destpage=1;
                }
                index=0;
            }
        }
        function pagePrev(){
           if(pageCount >1){
               if(destpage >1 && destpage <=pageCount){
                   destpage--;
               }else{
                   destpage=pageCount;
               }
               index=0;
           }
        }
        function keyOK() {

        }

    </script>
    <script type="text/javascript">
        function init(){
            loadResult();
            document.onkeypress=KeyPress;
        }
        function loadResult(){
            var requestUrl = "action/selfcare_bill_data.jsp?columnid=02&month=8&destpage="+destpage;
            var loaderSearch = new net.ContentLoader(requestUrl, showResult);
        }
        function showResult(){
//            clearResultdiv() ;
//            var results = this.req.responseText;
//            data = eval("(" + results + ")");
//            arr = data.ppvData;
//            destpage = data.destpage;
//            pageCount = data.pageCount;
//            leng = arr.length;
//            if (leng > 0) {
//                for (var i = 0; i < leng; i++) {
//                    $("pack_").innerText="";
//                    $("name_").innerText="";
//                    $("price_").innerText="";
//                    $("date_").innerText="";
//                }
//            }
        }
        function clearResultdiv() {
            for (var i = 0; i < 10; i++) {
            }
        }
        function changeImg(flag){
            if(flag==1){
            }else{
            }
        }

        function goDetail(){
            saveParam();
            if(arr[index].programtype == "0"){
                    var url="vod_detail.jsp?<%=EpgConstants.COLUMN_ID%>="+arr[index].columnid
                        +"&<%=EpgConstants.PROGRAM_ID%>="+arr[index].programid
                        +"&<%=EpgConstants.PROGRAM_TYPE%>="+arr[index].programtype
                        +"&<%=EpgConstants.CONTENT_ID%>="+arr[index].contentcode
                        +"&programname="+arr[index].programname;
                document.location=encodeURI(encodeURI(url));
                }else if(arr[index].programtype == "1"){
                   var url="vod_series_list.jsp?<%=EpgConstants.COLUMN_ID%>="+arr[index].columnid
                        +"&<%=EpgConstants.PROGRAM_ID%>="+arr[index].programid
                        +"&<%=EpgConstants.PROGRAM_TYPE%>="+arr[index].programtype
                        +"&<%=EpgConstants.CONTENT_ID%>="+arr[index].contentcode
                        +"&programname="+arr[index].programname;
                        +"&<%=EpgConstants.SERIES_PROGRAMCODE%>="+arr[index].programid+"&vodtype=100";
                document.location=encodeURI(encodeURI(url));
                }

        }
        function saveParam(){

        }
    </script>
</head>

<body bgcolor="transparent" onload="init();">
<div id="div0" style="position:absolute; width:1145px; height:526px; left:59px; top:110px;">
    <img src="images/mytv/btv-mytv-consumerbg.png" height="526" width="1145" alt="" border="0">
</div>
<!--顶部信息-->
<div style="position:absolute; width:22; height:35; left:25px; top:18px;">
	<img src="images/search/TV.png" border="0">
</div>

<div id="path" style="position:absolute; width:760px; height:51px; left:80px; top:22px;font-size:24px;color:#FFFFFF">
    我的TV>消费记录
</div>

<div style="position:absolute; width:1145px; height:526px; left:59; top:110px;">
    <div style="position:absolute;  left:0; top:0;width:1145; height:526; ">
        <%
            for (int i = 0; i < 10; i++) {

        %>
        <div style="position:absolute;  left:0; top:<%=i*48+48%>;width:1140; height:48;" align="left">
            <img id="resultbar<%=i%>" src="images/btn_trans.gif" alt="" width="1140" height="49" border="0">
        </div>


        <div style="position:absolute;  left:0; top:<%=i*48+48%>;width:1140; height:48;color:#FFFFFF;font-size:24px">
             <div id="pack_<%=i%>"  style="position:absolute;  left:0;   top:0;width:380; height:48;border:1px solid red"> </div>
            <div id="name_<%=i%>"  style="position:absolute;  left:380; top:0;width:380; height:48;border:1px solid red"> </div>
            <div id="price_<%=i%>" style="position:absolute;  left:760; top:0;width:190; height:48;border:1px solid red"> </div>
            <div id="date_<%=i%>"  style="position:absolute;  left:950; top:0;width:190; height:48;border:1px solid red">  </div>
        </div>

        <%
            }
        %>
    </div>
</div>
<%@ include file="inc/lastfocus.jsp" %>
</body>
</html>
