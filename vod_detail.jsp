<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.epg.EpgException" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.IsFavorited3SQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@include file="inc/ad_utils.jsp" %>
<%@ include file="inc/getFitString.jsp" %>
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
<epg:PageController name="vod_detail.jsp" recurrent="true" />
<%
    }else{
%>
<epg:PageController name="vod_detail.jsp"  />
<%
  }
%>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
	String strADid = request.getParameter("strADid");
	String strADid2 = request.getParameter("strADid2");
    String columnid = request.getParameter("columnid");
    String programid = request.getParameter("programid");
    String contentcode = request.getParameter("contentid");
   String programname = request.getParameter("programname");
    if(programname == null){
        programname = "";
    }
    programname = URLDecoder.decode(programname, "UTF-8");
        String isFromFav = request.getParameter("from");
    String columnpath =  request.getParameter("columnpath");
    String strProgramid="";
 if(columnpath == null){
        columnpath = "";
    }
    columnpath= URLDecoder.decode(columnpath, "UTF-8");
    Integer menuLeft=110;
    Integer menuTop=22;
    Integer menuWidth=22;
    String titleImg = "images/vod/btv-02-demand.png";
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
        columnpath = "应用 > 我的收藏 > 我的书签";
        titleImg = "images/application/btv-app-ico.png";
    }
 String tempColumnPath = columnpath;
    if(tempColumnPath.length()>32){
        tempColumnPath = "<marquee version='3' scrolldelay='250' width='590'>"+tempColumnPath+"</marquee>";
    }

    VodOneDataSource ds=new VodOneDataSource();
    VoDQueryValueIn valueIn=(VoDQueryValueIn)ds.getValueIn();
    valueIn.setColumnId(columnid);
    valueIn.setProgramId(programid);
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
    boolean isFav=false;
    //检查此vod是否已经收藏
    DoCheckFavoritedVod3SDataSource checkds = new DoCheckFavoritedVod3SDataSource();
    IsFavorited3SQueryValueIn checkvalueIn = (IsFavorited3SQueryValueIn) checkds.getValueIn();
    checkvalueIn.setColumnId(columnid);
    checkvalueIn.setContent_Code(contentcode);
    checkvalueIn.setContent_Type("PROGRAM");
    checkvalueIn.setsDauserId(userInfo.getUserId());
    checkvalueIn.setUserInfo(userInfo);
    Result rs = checkds.execute();
    FavoriteInfo_3S favorite_3S = (FavoriteInfo_3S) rs.getInfo();
    String favIcon = "images/vod/btv-02-Collectionno.png";
    if (favorite_3S != null) {//已经收藏过了
        favIcon = "images/vod/btv-02-Collection.png";
        isFav=true;
    }

%>
<html>
<head>
    <title></title>
    <epg:script/>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <script language="javascript">
//        var isZTEBW = false;
//        if (window.navigator.appName == "ztebw") {
//            isZTEBW = true;
//        }
        //isZTEBW = false;
        var favoriteUrl = "";
        if (isZTEBW == true) {
            favoriteUrl = "vod_favorite_pre.jsp?leftstate=1&leefocus=xx";
        } else {
            favoriteUrl = "vod_favorite.jsp?leftstate=1&leefocus=xx";
        }
        var dellflag = "";
        var isFav=<%=isFav%>;
        function getLength(contentlength) {
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
        function changeImg(index) {
            if (index == "0") {
                document.getElementById("favimg").style.visibility = "visible";
                document.getElementById("playimg").style.visibility = "hidden";
            } else {
                document.getElementById("playimg").style.visibility = "visible";
                document.getElementById("favimg").style.visibility = "hidden";
            }
        }
        function blueSearch() {
            var url= "vod_search.jsp?columnpath=<%=columnpath%>&leefocus=xx";
            document.location = encodeURI(encodeURI(url));
        }

        var doFavoriteFlag =1;

        function favoritedo() {
            if(doFavoriteFlag !=1){
//                alert("SSSSSSSSSSSSSSSnoaction!!!");
                return;
            }
            doFavoriteFlag = 0;
            if(isFav){
               var favUrl = "action/favorite_add.jsp?SubjectID=<%=columnid%>"
                        + "&ContentID=<%=contentcode%>"
                        + "&type=dell"
                        + "&FavoriteTitle=<%=programname%>";
                var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showDellMsg);
            }else{
                var favUrl = "action/favorite_add.jsp?SubjectID=<%=columnid%>"
                        + "&ContentID=<%=contentcode%>"
                        + "&type=add"      
                        + "&FavoriteTitle=<%=programname%>";
                var loaderSearch = new net.ContentLoader(encodeURI(favUrl), showMsg);
            }
        }
        function cancelKeyOK() {
//            alert("SSSSSSSSSSSSSSSSSSSSSSSSSScancelKeyOK_favIndex="+favIndex);
            if (favIndex==0) {
                //进入TV收藏
                document.location = favoriteUrl;
            } else {
                favIndex=0;
                $("fav_0").src = "images/vod/btv-btn-cancel.png";
                $("fav_1").src = "images/vod/btv-btn-cancel.png";
                closeMessage();
                document.onkeypress = mykeypres;
            }
        }
        function closeMessage() {
            doFavoriteFlag = 1;
            $("text").innerText = "";
            $("msg").style.visibility = "hidden";
            $("closeMsg").style.visibility = "hidden";
            if (dellflag == 0){
                $("favstate").src = "images/vod/btv-02-Collection.png";
                isFav=true;
            }
        }
        function showDellMsg(){
            doFavoriteFlag = 1;
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
           $("text").innerText = "";
            $("msg").style.visibility = "hidden";
            $("closeMsg").style.visibility = "hidden";
            if (dellflag == 0){
                $("favstate").src = "images/vod/btv-02-Collectionno.png";
                isFav=false;
            }else{
                $("favstate").src = "images/vod/btv-02-Collection.png";
                isFav=true; 
            }
        }

//        top.jsSetupKeyFunction("top.mainWin.favoritedo", 0x0113);
        top.jsSetupKeyFunction("top.mainWin.blueSearch", 0x0116);


function mykeypres(evt) {
    var keyCode = parseInt(evt.which);
    debug("SSSSSSSSSSSSSSSSSSSSSSkeyCode="+keyCode);
 if(top.currState == 2){
      top.OSDInfo.state = 2;
    }
    if (keyCode == 0x0028) { //onKeyDown
        return false;
    }else if (keyCode == 0x0113) { //onKeyDown
        favoritedo();
        return false;
    }else if(keyCode == 24){
        document.location = "back.jsp";
        return false;
    }else if (keyCode == 0x0110) {
        //Authentication.CTCSetConfig("KeyValue", "0x110");
        _window.top.mainWin.document.location = "portal.jsp";
    } else if (keyCode == 36) {
        _window.top.mainWin.document.location = "portal.jsp";
    } else {
        top.doKeyPress(evt);
    }
}
document.onkeypress = mykeypres;
    </script>
</head>
<body bgcolor="transparent">
<div id="detail_bg" style="position:absolute; width:1280px; height:720px; left:0px; top:0px; display:block" >
<div style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
</div>
<%--<!--顶部信息-->--%>
<div class="topImg" style="font-size:20px; top:15px; width:600px; height:45px; position:absolute; color:#ffffff;">
    <div style="background:url('<%=titleImg%>'); left:13; top:8px; width:<%=menuWidth%>px; height:35px; position:absolute; ">
    </div>
    <div id="path" style="position:absolute; width:760px; height:51px; left:<%=menuLeft-62%>; top:<%=menuTop-10%>;font-size:24px;color:#FFFFFF"><%=columnpath%>
    </div>
</div>

<%@ include file="inc/time.jsp" %>
<%
    String description = vodInfo.getDescription();
//System.out.println("SSSSSSSSSSSSSSSSlength="+vodInfo.getContentLength());
//description ="中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我";
//    description ="中国人是我<br/>中国人是我<br/>中国人是我<br/>中国人是我<br/>中国人是我<br/>";
    if(description !=null && description.length()>90){
        description = description.substring(0,90)+"...";
    }

//    String programName = "中国人是我中国人是我中国人是我中国人是我中国人是我中国人是我";
    String programName = vodInfo.getProgramName();
    if(programName!=null && programName.length()>25){
        programName = programName.substring(0,24)+"...";
    }
	String director = vodInfo.getDirector();
	
	if(director!=null && director.length()>30){
        director = director.substring(0,30)+"...";
    }
	
	String actor = vodInfo.getActor();
	
	if(actor!=null && actor.length()>30){
        actor = actor.substring(0,30)+"...";
    }

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
                    if(columnid.indexOf(columnone) ==0){
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
                if(columnid.indexOf(columnone) ==0){
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
%>

<%--<epg:div left="130" width="220" top="102" height="325" type="image" field="NormalPoster" datasource="VodOneDecorator">--%>
<%--<epg:formatter pattern="220x325" />--%>
<%--</epg:div>--%>

<div id="detail_img" style=" position:absolute; width:<%=width%>px; height:<%=height%>px; left:<%=left%>px; top:102px;">
    <img src="<%=vodInfo.getNormalPoster()%>" height="<%=height%>" width="<%=width%>" alt="">
</div>
</div>
<%@ include file="inc/vod_confirm.jsp" %>
<div id="detail"  style=" visibility:visible;">
    <!--片名-->
    <div  style="position:absolute; width:850; height:36px; left: 380; top: 100;color:#FFFFFF;font-size:30px ;color:#FF0000">
        片名: <%=programName%>
    </div>
    <!--price-->
    <div style="position:absolute; width:770px; height:36px; left: 380; top: 160;color:#FFFFFF;font-size:26px ;">
        <%
        if(isActorDirector){
            out.print("导演");
        } else{
            out.print("主持人");
        }
        %>: <%=director%>
    </div>
     <!--导演-->
   <%--<div style="position:absolute; width:770px; height:36px; left: 380; top: 190;color:#FFFFFF;font-size:26px ;">
        价格: --%><%--<%=format(vodInfo.getPrice(),"100")%>--%> <%--元
    </div>--%>
        <!--主演-->
    <div style="position:absolute; width:770px; height:36px; left: 380; top: 190;color:#FFFFFF;font-size:26px ;">
        <%
            if(isActorDirector){
                out.print("主演");
            } else{
                out.print("受访者");
            }
        %>: <%=actor%>
    </div>
    <!--时长-->
    <div style="position:absolute; width:770px; height:36px; left: 380; top: 220;color:#FFFFFF;font-size:26px ;">
        时长: <%=vodInfo.getContentLength()%>
    </div>
        <!--介绍-->
    <div style="position:absolute; width:870px; height:130px; left: 380px; top: 250; color:#FFFFFF;font-size:26px ;">
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
           <%--getLength("<%=vodInfo.getContentLength()%>"); --%>
        <%--</script>--%>
    <%--</div>--%>
    <%--<div style="position:absolute;width:700;height:36;left:450;top:220;font-size:26px;color:#FFFFFF;overflow:hidden">--%>
        <%--<%=vodInfo.getActor()%>--%>
    <%--</div>--%>
    <%--<div id="description" style="position:absolute;width:850;height:36;left:380;top:255;font-size:26px;color:#FFFFFF"> </div>--%>
    <%--<script type="text/javascript">--%>
        <%--document.getElementById("description").innerHTML ="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+ writeFitStringNirui("<%=vodInfo.getDescription()%>", 2000, 24, 14.6, 12);--%>
    <%--</script>--%>


    <!--播放-->
<div style="position:absolute; width:1px; height:1px; left: 435px; top: 420; color:#FFFFFF;font-size:26px ;">
    <a href="javascript:doMusicAuth('<%=vodInfo.getColumnId()%>','<%=vodInfo.getProgramId()%>','0','<%=vodInfo.getContentId()%>','llinkerplay','<%=programName%>','<%=strADid%>','<%=strADid2%>');"
       name="llinkerplay"
       onfocus="changeImg('1');" onBlur="changeImg('1');">
        <img src="images/btn_trans.gif" width="1" height="1" border="0"/>
    </a>
</div>
<div style="position:absolute; width:100px; height:36px; left: 380px; top: 385;">
    <img src="images/vod/btv-02-bg-play.png" border="0"/>
</div>
<div style="position:absolute; width:100px; height:36px; left: 379px; top: 384;">
    <img id="playimg" src="images/vod/btv-02-bg-playclick.png" border="0"/>
</div>

<div style="position:absolute; width:152px; height:36px; left: 410px; top: 392; color:#FFFFFF;font-size:24px ;">
    <img src="images/vod/btv_play.png" alt="">
    <font style="position:absolute; width:152px; height:36px; left: 28px; top: 0;">播放</font>
</div>

<!--收藏-->
<div style="position:absolute; width:1px; height:1px; left: 600px; top: 420; color:#FFFFFF;font-size:24px ;">
    <a id='favorite_linker' href="javascript:favoritedo();"
       onfocus="changeImg('0');"
       onblur="changeImg('0');">
        <img src="images/btn_trans.gif" width="1" height="1" border="0"/> </a>
</div>
<div style="position:absolute; width:100px; height:36px; left: 550px; top: 385; color:#FFFFFF;font-size:24px ;">
    <img src="images/vod/btv-02-bg-play.png" border="0"/>
</div>
<div style="position:absolute; width:100px; height:36px; left: 549px; top: 384; color:#FFFFFF;font-size:24px ;">
    <img id="favimg" src="images/vod/btv-02-bg-playclick.png" border="0"/>
</div>
<div style="position:absolute; width:152px; height:36px; left: 588px; top: 395; color:#FFFFFF;font-size:24px ;">
    <img id="favstate" src="<%=favIcon%>" alt="">&nbsp;
    <font style="position:absolute; width:152px; height:36px; left: 34px; top: -3;">收藏</font>
</div>

<%--下方提示--%>
<div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
</div>
<div style="position:absolute;width:1280px; height:40px; left: -30px; top: 640px; color:black;font-size:22px;">
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
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
</body>
</html>
