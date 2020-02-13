<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodOneDataSource" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodSeriesDataSource" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.DoCheckFavoritedVod3SDataSource" %>
<%@ page import="com.zte.iptv.epg.content.*" %>
<%@include file="inc/ad_utils.jsp" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ include file="action/get_columnPath.jsp" %>
<%!
    public String formatName(Object oldName) {
        String newName = String.valueOf(oldName);
        if (!"null".equals(newName)) {
//            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\\\\", "\\\\\\\\");
            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\'", "\\\\\'");
        } else {
            newName = "";
        }
        return newName;
    }
	
	 public  String format(String price,String rate){

		double priceInt = Double.valueOf(price);
		double rateInt = Double.valueOf(rate);
		double pricedb = (double) (priceInt/rateInt);
		String priceStr =  String.valueOf(pricedb);
		if(priceStr.endsWith(".0")){
			priceStr = priceStr.substring(0,priceStr.length()-2);
		}

		return priceStr;
	}
%>
<%
    String lastfocus = request.getParameter("lastfocus");
    if(lastfocus == null){
%>
<epg:PageController name="vod_series_list.jsp" recurrent="true" />
<%
    }else{
%>
<epg:PageController name="vod_series_list.jsp"  />
<%
  }
%>
<%

    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
	String strADid = request.getParameter("strADid");
	String strADid2 = request.getParameter("strADid2");
    String strColumnid = request.getParameter("columnid");
    String strProgramid = request.getParameter("programid");
    String contentcode = request.getParameter("contentid");
 //  System.out.println("strProgramidstrProgramidstrProgramidstrProgramid"+strProgramid);
    // 获取连续剧单集号
    String seriesnum = String.valueOf(request.getParameter("seriesnum"));
 if(lastfocus !=null && !lastfocus.equals("")){
        seriesnum = "0";
    }
    String programname = request.getParameter("programname");
 if(programname == null){
        programname = "";
    }
    programname = URLDecoder.decode(programname, "UTF-8");
    //获取栏目路径
    String isFromFav=request.getParameter("from");
    String columnpath =  request.getParameter("columnpath");
 if(columnpath == null){
        columnpath = "";
    }
    columnpath= URLDecoder.decode(columnpath, "UTF-8");
    String titleImg="images/vod/btv-02-demand.png";
     Integer menuLeft=110;
    Integer menuTop=22;
    Integer menuWidth=22;

    if ("1".equals(isFromFav)) {
        menuLeft=menuLeft+18;
        menuTop=menuTop+4;
        menuWidth=37;
        columnpath = "应用 > 我的收藏 > 收藏影视";
        titleImg = "images/application/btv-app-ico.png";
    } else if ("2".equals(isFromFav)) {
        menuLeft=menuLeft+18;
        menuTop=menuTop+4;
        menuWidth=37;
        columnpath = "应用 > 我的收藏> 我的书签";
        titleImg = "images/application/btv-app-ico.png";
    }
    if(seriesnum.equals("") || seriesnum=="null" || seriesnum==null ){
        seriesnum="0";
    }
 if(columnpath == null){
        columnpath = "";
    }
    String tempColumnPath = columnpath;
    if(tempColumnPath.length()>32){
        tempColumnPath = "<marquee version='3' scrolldelay='250' width='590'>"+tempColumnPath+"</marquee>";
    }

    VodOneDataSource ds=new VodOneDataSource();
    VoDQueryValueIn valueIn=(VoDQueryValueIn)ds.getValueIn();
    valueIn.setColumnId(strColumnid);
    valueIn.setProgramId(strProgramid);
    valueIn.setVoDType(CodeBook.VOD_TYPE_SERIES_Head);
    valueIn.setUserInfo(userInfo);

    EpgResult result=ds.getData();
    Vector vector=(Vector)result.getData();
    VoDContentInfo vodInfo = null;
    if(vector!=null && vector.size()>0){
        vodInfo = (VoDContentInfo)vector.get(0);
        contentcode = vodInfo.getContentId();
        programname = vodInfo.getProgramName();
    }
	
	programname = formatName(programname);
%>
<%
    boolean  favFlag=false;
        //检查此vod是否已经收藏
    DoCheckFavoritedVod3SDataSource checkds = new DoCheckFavoritedVod3SDataSource();
    IsFavorited3SQueryValueIn checkvalueIn = (IsFavorited3SQueryValueIn) checkds.getValueIn();
    checkvalueIn.setColumnId(strColumnid);
    checkvalueIn.setContent_Code(contentcode);
    checkvalueIn.setContent_Type("PROGRAM");
    checkvalueIn.setsDauserId(userInfo.getUserId());
    checkvalueIn.setUserInfo(userInfo);
    Result rs = checkds.execute();
    FavoriteInfo_3S favorite_3S = (FavoriteInfo_3S) rs.getInfo();
    String favIcon = "images/vod/btv-02-Collectionno.png";
    if (favorite_3S != null) {//已经收藏过了
        favFlag=true;
        favIcon = "images/vod/btv-02-Collection.png";
    }
%>
<%
   
%>
<html>
<head>
<title></title>
<epg:script/>
<%--<style type="text/css">--%>
    <%--div{--%>
       <%--border:1px solid red; --%>
    <%--}--%>
<%--</style>--%>
<script language="javascript">
    function showDescripton(description) {
        var des = description;
        if (des.length > 100) {
            des = des.substr(0, 100) + "...";
        }
        document.write("<font  style=' word-break:break-all; ' >" + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + des + "</font>");
    }
    function getLength(contentlength)
    {
        var hours = contentlength.split(':');
        var strhours = "";
        if (hours[0] > 0) {
            strhours = hours[0] + "hours";
        }
        if (hours[1] > 0) {
            if (hours[1].substring(0, 1) > 0) {
                strhours += hours[1] + "minutes";
            } else {
                strhours += hours[1].substring(1, 2) + "minutes";
            }
        }
        if (hours[2] > 0) {
            strhours += hours[2] + "seconds";
        }
        document.write(contentlength);
    }
</script>
<script type="text/javascript" src="js/contentloader.js"></script>
<%@include file="inc/vod_confirm.jsp" %>
<script type="text/javascript">

    var $$ = {};
    var index = 0;
    var destpage = 1;
    var data;
    var arr;
    var pagecount;
    var leng;
    var dellflag="";
    var isFav = false;
    var favFlag=<%=favFlag%>;
//    var isZTEBW = false;
//    if (window.navigator.appName == "ztebw") {
//        isZTEBW = true;
//    }
    //isZTEBW = false;
    var favoriteUrl = "";
    if (isZTEBW == true) {
        favoriteUrl = "vod_favorite_pre.jsp?leftstate=1&leefocus=xx";
    } else {
        favoriteUrl = "vod_favorite.jsp?leftstate=1&leefocus=xx";
    }
    function init() {
        initParam();
        var requestUrl = "action/vod_series_data.jsp?columnid=<%=strColumnid%>&programid=<%=strProgramid%>&destpage=" + destpage;
        var loaderSearch = new net.ContentLoader(requestUrl, showseriesList);
    }
    function showseriesList() {
        clearListiv();
        var results = this.req.responseText;
        data = eval("(" + results + ")");
        arr = data.seriesdata;
        destpage = data.destpage;
        pagecount = data.pageCount;
//        $('series_count').innerText = "集数: "+data.totalCount+"集";
        leng = arr.length;
        if (leng > 0) {
            for (var i = 0; i < leng; i++) {
                $("num_" + i).innerText = "第" + getSeriesnum(arr[i].seriesnum) + "集";
                if("<%=seriesnum%>" ==arr[i].seriesnum)index=i;
            }
            changeImg(1);
            isFav = false;
        } else {
            isFav = true;
            changebarImg(1);
        }
        showPage();
        document.onkeypress = mykeypres;

    }
    function clearListiv() {
        for (var i = 0; i < 40; i++) {
            $("num_" + i).innerText = "";
        }
    }
    function getSeriesnum(num) {
        var str = "";
        if (num.length < 3) {
            for (var i = 0; i < 3 - num.length; i++) {
                str += "0";
            }
//            return str += num;
        }
        return str += num;
    }
    function changeImg(flag) {
index = isNaN(index)?index:parseInt(index,10);
        if (flag == 1) {
            $("num_bg" + index).src = "images/vod/btv-02-bookmarkplaybg.png";
        } else {
            $("num_bg" + index).src = "images/btn_trans.gif";
        }

    }
    function changebarImg(flag) {
        if (flag == 1) {
            $("favimg0").style.visibility="hidden";
            $("favimg1").style.visibility="visible";
        } else {
            $("favimg0").style.visibility="visible";
            $("favimg1").style.visibility="hidden";
        }
    }
    function $(id) {
        if (!$$[id]) {
            return document.getElementById(id);
        }
        return $$[id];
    }
    function blueSearch() {
        var url= "vod_search.jsp?columnpath=<%=columnpath%>&leefocus=xx";
        document.location = encodeURI(encodeURI(url));
    }

    var doFavoriteFlag =1;

    function favoritedo() {
        if(doFavoriteFlag !=1){
            alert("SSSSSSSSSSSSSSSnoaction!!!");
            return;
        }
        doFavoriteFlag = 0;
         if(favFlag){
               var favUrl = "action/favorite_add.jsp?SubjectID=<%=strColumnid%>"
                        + "&ContentID=<%=contentcode%>"
                        + "&type=dell"
                        + "&FavoriteTitle=<%=programname%>";
                var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showDellMsg);
         }else{
            var favUrl = "action/favorite_add.jsp?SubjectID=<%=strColumnid%>"
                    + "&ContentID=<%=contentcode%>"
                    + "&type=add"
                    + "&FavoriteTitle=<%=programname%>";
            var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showMsg);
         }
    }
    function cancelKeyOK() {
        if (favIndex==0) {
            //进入TV收藏
            document.location =favoriteUrl;
        } else {
            favIndex=0;
            $("fav_0").src = "images/vod/btv-btn-cancel.png";
            $("fav_1").src = "images/vod/btv-btn-cancel.png";
            closeMessage();
            document.onkeypress=mykeypres;
        }
    }
    function closeMessage() {
        doFavoriteFlag = 1;
        $("text").innerText = "";
        $("msg").style.visibility = "hidden";
        $("closeMsg").style.visibility = "hidden";
        if(dellflag==0){
            $("favstate").src="images/vod/btv-02-Collection.png";
            favFlag=true;
        }
    }
     function showDellMsg(){
            var timer;
            var results = this.req.responseText;
            var tempData = eval("(" + results + ")");
            dellflag = tempData.requestflag;
            if (dellflag == 0) {
                $("text").innerText = "取消收藏成功";
                $("msg").style.visibility = "visible";
                $("closeMsg").style.visibility = "visible";
                clearTimeout(timer);
                timer = setTimeout(closeDellMsg, 2000);
            } else {
                $("text").innerText = "取消收藏失败";
                $("msg").style.visibility = "visible";
                $("closeMsg").style.visibility = "visible";
                clearTimeout(timer);
                timer = setTimeout(closeDellMsg, 2000);
            }
        }
        function closeDellMsg(){
            doFavoriteFlag = 1;
            $("text").innerText = "";
            $("msg").style.visibility = "hidden";
            $("closeMsg").style.visibility = "hidden";
            if (dellflag == 0){
                $("favstate").src = "images/vod/btv-02-Collectionno.png";
                favFlag=false;
            }else{
                $("favstate").src = "images/vod/btv-02-Collection.png";
                favFlag=true;
            }
        }
</script>
<script type="text/javascript">
    function mykeypres(evt) {
        var keyCode = parseInt(evt.which);
        if (keyCode == 0x0028) { //onKeyDown
            detailKeyDown();
        } else if (keyCode == 0x0026) {//onKeyUp
            detailKeyUp();
        } else if (keyCode == 0x0025) { //onKeyLeft
            detailKeyLeft();
        } else if (keyCode == 0x0027) { //onKeyRight
            detailKeyRight();
        } else if (keyCode == 0x0008  || keyCode == 24) {///back
            detailBack();
        } else if (keyCode == 0x0022) {  //page down
            pageNext();
        } else if (keyCode == 0x0021) { //page up
            pagePrev();
        } else if (keyCode == 0x0113) { //yellow
            favoritedo();
        } else if (keyCode == 0x0116) {  //green
            blueSearch();
        } else if (keyCode == 0x000D) {  //OK
            detailKeyOK();
        } else {
            clearStack();
            commonKeyPress(evt);
            return true;
        }
        return false;
    }
    function detailKeyDown() {
        if (isFav && leng > 0) {
            isFav = false;
            changebarImg(-1);
            changeImg(1);
        } else if (leng > 10) {
            changeImg(-1);
            if (index + 10 < leng) {
                index += 10;
            } else {
                var row=parseInt(index/10);
                index = index - 10*row;
            }
            changeImg(1);
        }
    }
    function detailKeyUp() {
        if (index - 10 >= 0) {
            changeImg(-1);
            index -= 10;
            changeImg(1);
        } else {
            isFav = true;
            changeImg(-1);
            changebarImg(1);
        }
    }
    function detailKeyLeft() {
        if (isFav && leng > 0) {
            isFav = false;
            changebarImg(-1);
            changeImg(1);
        } else if (leng > 0) {
            changeImg(-1);
            if (index > 0 && index <= leng - 1) {
                index--;
            } else {
                index = leng - 1;
            }
            changeImg(1);
        }
    }
    function detailKeyRight() {
        if (isFav && leng > 0) {
            isFav = false;
            changebarImg(-1);
            changeImg(1);
        } else if (leng > 0) {
            changeImg(-1);
            if (index >= 0 && index < leng - 1) {
                index++;
            } else {
                index = 0;
            }
            changeImg(1);
        }
    }
    function detailBack() {
        clearStack();
        document.location = "back.jsp";
    }
    function pageNext() {
        if (pagecount > destpage) {
            destpage++;
            changeImg(-1);
            index = 0;
            init();
        }
    }
    function pagePrev() {
        if (destpage <= pagecount && destpage > 1) {
            destpage--;
            changeImg(-1);
            index = 0;
            init();
        }
    }
    function detailKeyOK() {
        if (isFav) {
            favoritedo();
        } else {
            saveParam();
            doMusicAuth(arr[index].columnid, arr[index].programid, 10, arr[index].SeriesProgramCode, "linker_" + index,'<%=programname%>','<%=strADid%>','<%=strADid2%>');
        }
    }
    function clearStack() {
        top.jsSetControl("paramstr", "");
    }
    function saveParam() {
        var paramstr = index + "|" + destpage;
        top.jsSetControl("paramstr", paramstr);
    }
    function initParam() {
        var paramstr = top.jsGetControl("paramstr");
        if (paramstr != "" && paramstr != null && paramstr != "undefined" && paramstr != "null") {
            var paramArr = paramstr.split("|");
            index = paramArr[0];
            destpage = paramArr[1];
        }
    }
    function showPage(){
            $("up").style.visibility=destpage>1 ? "visible":"hidden";
            $("down").style.visibility=destpage<pagecount ? "visible":"hidden";
    }

  
</script>
</head>
<body bgcolor="transparent" onLoad="init();">
<div id="detail_bg" style="position:absolute; width:1280px; height:720px; left:0px; top:0px; display:block" >
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<!--顶部信息-->
<div class="topImg" style="font-size:20px; top:15px; width:600px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('<%=titleImg%>'); left:13; top:8px; width:<%=menuWidth%>px; height:35px; position:absolute; ">
    </div>
    <div id="path" style="position:absolute; width:760px; height:51px; left:<%=menuLeft-62%>; top:<%=menuTop-10%>;font-size:24px;color:#FFFFFF"><%=columnpath%>
    </div>
</div>

<%@ include file="inc/time.jsp" %>
<%--<epg:div left="130" width="220" top="102" height="325" type="image" field="NormalPoster"--%>
     <%--datasource="VodOneDecorator">--%>
<%--<epg:formatter pattern="220x325"/>--%>
<%--</epg:div>--%>


<%
    String description = vodInfo.getDescription();
    //System.out.println("SSSSSSSSSSSSSSSSlength="+vodInfo.getContentLength());
    //description ="中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我";
    if(description !=null && description.length()>90){
        description = description.substring(0,90)+"...";
    }

//    String programName = "中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我";
    String programName = vodInfo.getProgramName();
    if(programName!=null && programName.length()>25){
        programName = programName.substring(0,24)+"...";
    }
programName = formatName(programName);

    String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String vodDetailColumnlist=String.valueOf(param.get("vodDetailColumnlist"));
    String linePosterColumnlist=String.valueOf(param.get("linePosterColumnlist"));

    boolean isActorDirector = true;
    boolean islinePoster = false;

    if(vodDetailColumnlist!=null && !vodDetailColumnlist.equals("null")){
        String [] columnlist = vodDetailColumnlist.split(",");
        if(columnlist.length>0){
            for(String columnone : columnlist){
                if(strColumnid.indexOf(columnone) ==0){
                    isActorDirector = false;
                    break;
                }
            }
        }
    }

    if(linePosterColumnlist!=null && !linePosterColumnlist.equals("null")){
        String [] columnlist = linePosterColumnlist.split(",");
        if(columnlist.length>0){
            for(String columnone : columnlist){
                if(strColumnid.indexOf(columnone) ==0){
                    islinePoster = true;
                    break;
                }
            }
        }
    }

    int left = 132;
    int top =0;
    int width = 225;
    int height = 325;

    if(islinePoster){
        width = 300;
        height = 240;
        left = 60;
    }
	String director = vodInfo.getDirector();
	
	if(director!=null && director.length()>30){
        director = director.substring(0,30)+"...";
    }
	
	String actor = vodInfo.getActor();
	
	if(actor!=null && actor.length()>30){
        actor = actor.substring(0,30)+"...";
    }

//    System.out.println("SSSSSSSSSSSSSSSSSvod_series_list="+vodInfo.getSeriesnum());

%>

<%--<epg:div left="130" width="220" top="102" height="325" type="image" field="NormalPoster" datasource="VodOneDecorator">--%>
<%--<epg:formatter pattern="220x325" />--%>
<%--</epg:div>--%>

<div id="detail_img" style=" position:absolute; width:<%=width%>px; height:<%=height%>px; left:<%=left%>px; top:102px;">
    <img src="<%=vodInfo.getNormalPoster()%>" height="<%=height%>" width="<%=width%>" alt="">
</div>
</div>
<div id="detail" style="visibility:visible;">
    <!--片名-->
    <div style="position:absolute; width:850; height:36px; left: 380; top: 100;color:#FFFFFF;font-size:30px ;color:#FF0000">
        片名: <%=programName%>
    </div>
    <!--导演-->
    <div style="position:absolute; width:770px; height:36px; left: 380; top: 145;color:#FFFFFF;font-size:26px ;">
        <%
            if(isActorDirector){
                out.print("导演");
            } else{
                out.print("主持人");
            }
        %>: <%=director%>
    </div>
     <!--price-->
    <%--<div style="position:absolute; width:770px; height:36px; left: 380; top: 175;color:#FFFFFF;font-size:26px ;">
        价格:--%><%--<%=format(vodInfo.getPrice(),"100")%>--%><%-- 元
    </div>--%>
    <!--集数-->
    <div  style="position:absolute; width:770px; height:36px; left: 380; top: 205;color:#FFFFFF;font-size:26px ;">
        集数: <%=vodInfo.getSeriesnum()%>集
    </div>
        <!--主演-->
    <div style="position:absolute; width:770px; height:36px; left: 380; top: 175;color:#FFFFFF;font-size:26px ;">
        <%
            if(isActorDirector){
                out.print("主演");
            } else{
                out.print("受访者");
            }
        %>: <%=actor%>
    </div>
    <%--<!--时长-->--%>
    <%--<div style="position:absolute; width:770px; height:36px; left: 380; top: 265;color:#FFFFFF;font-size:26px ;">--%>
    <%--时长: <%=vodInfo.getContentLength()%>--%>
    <%--</div>--%>
        <!--介绍-->
    <div style=" position:absolute; width:870px; height:80px; left: 380px; top: 235; color:#FFFFFF;font-size:26px ;">
        介绍: <%=description%>
    </div>
    <%--<div style="position:absolute;left:450;top:100; width:700;height:34;font-size:30px;color:#FF0000;overflow:hidden">--%>
         <%--<%=vodInfo.getProgramName()%>--%>
    <%--</div>--%>
    <%--<div style="position:absolute;width:700;height:36;left:450;top:130;font-size:26px;color:#FFFFFF;overflow:hidden">--%>
        <%--<%=vodInfo.getPrice()%>--%>
    <%--</div>--%>
    <%--<div style="position:absolute;width:700;height:36;left:450;top:160;font-size:26px;color:#FFFFFF;overflow:hidden">--%>
        <%--<%=vodInfo.getDirector()%>--%>
    <%--</div>--%>
    <%--<div style="position:absolute;width:700;height:36;left:450;top:190;font-size:26px;color:#FFFFFF;overflow:hidden">--%>
        <%--<script type="text/javascript">--%>
           <%--getLength("<%=vodInfo.getContentLength()%>");--%>
        <%--</script>--%>
    <%--</div>--%>
    <%--<div style="position:absolute;width:700;height:36;left:450;top:220;font-size:26px;color:#FFFFFF;overflow:hidden">--%>
        <%--<%=vodInfo.getActor()%>--%>
    <%--</div>--%>
    <%--<div style=" position:absolute;width:850;height:36;left:380;top:255;font-size:26px;color:#FFFFFF">--%>
        <%--<%--%>
            <%--String description = vodInfo.getDescription();--%>
            <%--System.out.println("SSSSSSSSSSSSSSSSlength="+vodInfo.getContentLength());--%>
<%--//            description ="中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我<br/>中国人是我<br/>中国人是我<br/>中国人是我<br/>";--%>
            <%--if(description !=null && description.length()>120){--%>
                <%--description = description.substring(0,119)+"...";--%>
            <%--}--%>
        <%--%>--%>
        <%--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=description%>--%>
    <%--</div>--%>



<div style="position:absolute;  left:130; top:440;width:1100; height:200;">
    <div id="series" style="position:absolute;  left:0; top:0;width:1100; height:200;">
        <!--vod-->
        <%
            for (int i = 0; i < 40; i++) {
                int frow = i / 10;
                int fcol = i % 10;              
                int fleft = fcol * 110;
                int ftop = frow * 45;
        %>
        <div style="position:absolute;  left:<%=fleft%>; top:<%=ftop%>;width:105; height:40" align="left">
            <img id="num_bg<%=i%>" src="images/btn_trans.gif" alt="" width="105" height="40" border="0">
        </div>
        <div id="num_<%=i%>"
             style="position:absolute;left:<%=fleft%>; top:<%=ftop+8%>;width:100; height:30;font-size:22px;color:#FFFFFF;"
             align="center"></div>

        <%
            }
        %>
    </div>
</div>
<div id="up" style="position:absolute; width:25px; height:14px; left:622px; top:425px;visibility:hidden">
    <img src="images/vod/btv_up.png" height="14" width="25" alt="" border="0">
</div>
<div id="down" style="position:absolute; width:25px; height:14px; left:622px; top:620px;visibility:hidden">
    <img src="images/vod/btv_down.png" height="14" width="25" alt="" border="0" />
</div>

<!--收藏-->
<div  id="favimg0" style="position:absolute; width:155px; height:48px; left: 380px; top: 385; color:#FFFFFF;font-size:24px ;">
    <img src="images/vod/btv-02-bg-play.png" border="0"/>
</div>
<div id="favimg1" style="position:absolute; width:155px; height:48px; left: 380px; top: 385; color:#FFFFFF;font-size:24px ;visibility:hidden">
    <img  src="images/vod/btv-02-bg-playclick.png" border="0"/>
</div>
<div style="position:absolute; width:152px; height:36px; left: 420px; top: 395; color:#FFFFFF;font-size:24px ;">
    <img id="favstate" src="<%=favIcon%>" width="31" height="28" alt="">
    <font style="position:absolute; width:152px; height:36px; left: 40px; top: -1;">收藏</font>
</div>


<%--下方提示--%>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<div style="position:absolute;width:1280px; height:40px; left: -30px; top: 640px; color:black;font-size:22px;">
	<div  style="position:absolute;width:60px; height:32px; left: 560px; top: -2px; color:black;font-size:22px;">
        <img src="images/vod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 620px; top: 2px; color:white; font-size:22px;">
        &nbsp;上一页
    </div>
    <div  style="position:absolute;width:60px; height:32px; left: 720px; top: -2px; color:black; font-size:22px;">
        <img src="images/vod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 780px; top: 2px; color:white; font-size:22px;">
        &nbsp;下一页
    </div>
    <div  style="position:absolute;width:60px; height:32px; left: 870px; top: -2px; color:black; font-size:22px;">
        <img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >
    </div>
    <div  style="position:absolute;width:190px; height:30px; left: 930px; top: 2px; color:white; font-size:22px;">
        &nbsp;收藏
    </div>
    <div  style="position:absolute;width:60px; height:32px; left: 1130px; top: -2px; color:black;font-size:22px;">
        <img src="images/vod/btv_Search.png" alt="" width=60px height="32" border="0" >
    </div>
    <div  style="position:absolute;width:120px; height:30px; left: 1190px; top: 2px; color:white; font-size:22px;">
        &nbsp;搜索
    </div>
</div>
</div>
<%@include file="favorite_msg.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
</html>
