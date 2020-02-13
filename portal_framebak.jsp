<%@	page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtils" %>
<%@ page import="com.zte.iptv.platformepg.account.CriteriaChannelInfo" %>
<%@ page import="com.zte.iptv.platformepg.content.PlatformepgCacheManager" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnOneDataSource" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<meta name="page-view-size" content="1280*720"/>
<epg:PageController name="portal_frame.jsp"/>
<%!

    public  String loadConvert (char[] in, int off, int len, char[] convtBuf) {
      if (convtBuf.length < len) {
          int newLen = len * 2;
          if (newLen < 0) {
              newLen = Integer.MAX_VALUE;
         }
          convtBuf = new char[newLen];
      }
      char aChar;
      char[] out = convtBuf;
      int outLen = 0;
      int end = off + len;

     while (off < end) {
          aChar = in[off++];
          if (aChar == '\\') {
             aChar = in[off++];
              if(aChar == 'u') {
                 // Read the xxxx
                  int value=0;
                  for (int i=0; i<4; i++) {
                      aChar = in[off++];
                     switch (aChar) {
                       case '0': case '1': case '2': case '3': case '4':
                        case '5': case '6': case '7': case '8': case '9':
                           value = (value << 4) + aChar - '0';
                           break;
                        case 'a': case 'b': case 'c':
                        case 'd': case 'e': case 'f':
                          value = (value << 4) + 10 + aChar - 'a';
                           break;
                        case 'A': case 'B': case 'C':
                        case 'D': case 'E': case 'F':
                          value = (value << 4) + 10 + aChar - 'A';
                           break;
                        default:
                            throw new IllegalArgumentException(
                                         "Malformed \\uxxxx encoding.");
                      }
                   }
                  out[outLen++] = (char)value;
              } else {
                  if (aChar == 't') aChar = '\t';
                  else if (aChar == 'r') aChar = '\r';
                  else if (aChar == 'n') aChar = '\n';
                  else if (aChar == 'f') aChar = '\f';
                  out[outLen++] = aChar;
              }
          } else {
              out[outLen++] = (char)aChar;
          }
      }
      return new String (out, 0, outLen);
    }

    String getChinese(HashMap param, String name){
        String value = (String)param.get(name);
        if(value != null ){
           value = loadConvert(value.toCharArray(),0,value.length(),new char[0]);
        }
        return value;
    }

    String toXml(String key, String value) {
        String rt = "<" + key + ">" + value + "</" + key + ">";
        return rt;
    }

    String replaceUrl(HttpServletRequest req,String url,HashMap param)throws Exception{
        UserInfo userInfo = (UserInfo)req.getSession().getAttribute(EpgConstants.USERINFO);
        String tempUrl = url;
        if(tempUrl == null){
            return "";
        }

        tempUrl = tempUrl.replaceAll("\\{userid\\}", userInfo.getUserId());
        if(url.indexOf("EPG_INFO")>-1){
            String timeBasePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath() + "/";
            String returnUrl = timeBasePath + userInfo.getUserModel()+"/thirdback.jsp";

            String epginfo = "";
            epginfo+=toXml("server_ip",req.getServerName());
            epginfo+=toXml("group_name",String.valueOf(param.get("EPG_INFO_group_name")));
            epginfo+=toXml("group_path",String.valueOf(param.get("EPG_INFO_group_path")));
            epginfo+=toXml("oss_user_id",userInfo.getUserId());
            epginfo+=toXml("page_url",returnUrl);
            epginfo+=toXml("partner","ZTE");
            epginfo = java.net.URLEncoder.encode(epginfo, "UTF-8");
            url = url.replaceAll("EPG_INFO", epginfo);
        }
        return url;
    }

%>
<html>
<head>
    <title>portal</title>
</head>
<%!
   public String getColumnList(UserInfo userinfo,String columnid,HashMap param){
       StringBuffer sb = new StringBuffer("[");
       try{
            String isFathercolumn = String.valueOf(param.get("isFathercolumn"));
            String Fathercolumn = String.valueOf(param.get("Fathercolumn"));
            List vColumnData=new ArrayList();
            List tempList=new ArrayList();
            if (isFathercolumn != null && Fathercolumn != null && isFathercolumn.equals("1")) {//读取N个一级栏目分支
                String[] columnlist = Fathercolumn.split(",");
                int columnLength = columnlist.length;
                for (int i = 0; i < columnLength; i++) {
                        ColumnOneDataSource vodDs = new ColumnOneDataSource();
                        ColumnValueIn valueIn = (ColumnValueIn) vodDs.getValueIn();
                        valueIn.setUserInfo(userinfo);
                        valueIn.setColumnId(columnlist[i]);
                        EpgResult result = vodDs.getData();
                        tempList=result.getDataAsVector();
                        if(tempList!=null){
                         vColumnData.addAll(tempList);
                        }
                }
            } else {
                ColumnDataSource columnDs = new ColumnDataSource();
                ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
                valueIn.setUserInfo(userinfo);
                valueIn.setColumnId(columnid);
                EpgResult result = columnDs.getData();
                vColumnData = (Vector) result.getData();
            }
            String oColumnid = "";
            String oColumnName = "";
            String columnposter="";
            int length = vColumnData.size();
            ColumnInfo columnInfo = null;
            for(int i=0; i<length; i++){
                if(i>0){
                   sb.append(",");
                }

             columnInfo = (ColumnInfo)vColumnData.get(i);
             columnposter=columnInfo.getNormalPoster();
             oColumnid  = columnInfo.getColumnId();
             oColumnName  = columnInfo.getColumnName();
//                 System.out.println("==============oColumnid=========="+oColumnid);
             sb.append("{columnid:\""+oColumnid+"\",");
             sb.append("columnposter:\""+columnposter+"\",");
             sb.append("columnname:\""+oColumnName+"\"}");
            }


       }catch (Exception e){
           System.out.println("+++++++++栏目列表数据源出错++++");
       }
       sb.append("]");
       return sb.toString();
   }
%>

<%
     session.setAttribute("pushportal","0");
     String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
     HashMap param = PortalUtils.getParams(path, "GBK");
     String TIME_COUNT=String.valueOf(param.get("TIME_COUNT"));
     String INTERVAL=String.valueOf(param.get("INTERVAL"));
     String channelColumnid=String.valueOf(param.get("column00"));
     String vodColumnid = String.valueOf(param.get("column01"));
     String isCugConfig = String.valueOf(param.get("isCugConfig"));

     String name0=getChinese(param,"app_0_name");
     String name1=getChinese(param,"app_1_name");
     String name2=getChinese(param,"app_2_name");
     String name3=getChinese(param,"app_3_name");

     String lastfocus = request.getParameter("lastfocus");
    System.out.println("fanhui de bushi lastfocus===="+lastfocus);
     int bottomMenuIndex = 0;
     int leftMenuIndex = 0;
     int startIndex=0;
     int endIndex=7;
     int rem_flag=0;
     int destpage=1;
     if(lastfocus != null && !"".equals(lastfocus)){
         try{
             String[] indexs = lastfocus.split("_");
             if(indexs!=null && indexs.length>0){
                   bottomMenuIndex=Integer.parseInt(indexs[0]);
                   leftMenuIndex =Integer.parseInt(indexs[1]);
                   if(indexs.length > 2){
                      startIndex=Integer.parseInt(indexs[2]);
                      endIndex=Integer.parseInt(indexs[3]);
		      if(indexs.length > 4){
		      rem_flag=Integer.parseInt(indexs[4]);
		      }
                   }
             }
             //bottomMenuIndex = Integer.parseInt(lastfocus);
         }catch(Exception e){
             System.out.println("fanhui de bushi bottomMenuIndex");
         }
     }

    //将开机频道混排号取出来

    UserInfo userInfo = (UserInfo) pageContext.getSession().getAttribute(EpgConstants.USERINFO);
    String channelid = userInfo.getCrtChannelID();

    Hashtable criHash = null;
    criHash = PlatformepgCacheManager.getSingleton().getchannelInfoHash();
    int tempno = -1;

    if (criHash != null) {
        Vector v_fun = (Vector) criHash.get(userInfo.getVendorid());
        CriteriaChannelInfo chInfo_fun = null;

        if (v_fun != null && v_fun.size() > 0) {
            for (int i = 0; i < v_fun.size(); i++) {
                chInfo_fun = (CriteriaChannelInfo) v_fun.get(i);

                if (null != chInfo_fun && chInfo_fun.getChannelid().equals(channelid)) {
                    tempno = EpgUtils.toInt(chInfo_fun.getUserchannelid(), -1);
                    break;
                }
            }
        }
    }

    //专题子栏目列表数据源
    String column02=(String)param.get("column02");
    String columnStr = getColumnList(userInfo,column02,param);

    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();
//    System.out.println("+++portal_columnStr="+columnStr);

    String fromplay = request.getParameter("fromplay");
    if(fromplay==null){
        fromplay = "";
    }

%>

<body bgcolor="transparent" >
<script type="text/javascript" src="js/contentloader.js"></script>
<script language="javascript" type="">
	<%--if(top.jsGetControl("showNavigation")==1 ||top.jsGetControl("showNavigation")=="1" ){--%>
	    <%--top.setDefaulchannelNo();--%>
	    <%--top.jsRedirectChannel(3);--%>
		<%--//top.jsSetControl("showNavigation", "0");--%>
		 <%--top.setTimeout(function(){--%>
		   <%--top.jsSetControl("showNavigation", "0");--%>
           <%--top.mainWin.document.location='<%=timeFrameUrl+"/portal.jsp?fromplay=1"%>';--%>
            <%--top.showOSD(2, 0, 25);--%>
            <%--top.setBwAlpha(0);--%>
        <%--},100)--%>
    <%--}--%>
    var fromthirdback ="0";
    if(isZTEBW == true){
        fromthirdback  = ztebw.getAttribute("fromthirdback");
    }
    if (fromthirdback == "1") {
        var curMixno = ztebw.getAttribute("curMixno");
        if (fromthirdback == "1") {
            ztebw.setAttribute("fromthirdback", '0');
        } else {
            curMixno = top.channelInfo.currentChannel;
            if ((!curMixno && curMixno != 0) || curMixno < 0 || curMixno == "") {
                curMixno = top.channelInfo.lastChannel;
            }
            if (curMixno == -1) {
                curMixno = ztebw.getAttribute("curMixno");
            }
        }
        top.jsRedirectChannel(curMixno);
        top.setTimeout(function () {
            top.mainWin.document.location = '<%=timeFrameUrl+"/portal.jsp?fromplay=1"%>';
            top.showOSD(2, 0, 25);
            top.setBwAlpha(0);
        }, 2000);
    }

</script>
<%@ include file="inc/chan_addjsset.jsp" %>
<!--<div id="marquee1" style="position:absolute; width:1280px; height:55px; top:0px; left:0px; font-size:28px;color:#FFFFFF;"><img src="images/scroll_bg.png" width="1280" height="55
"></div>
<div id="marquee" style="position:absolute; width:1280px; height:50px; top:20px; left:0px; font-size:28px;color:#FFFFFF;">
<marquee  direction="left" behavior="scroll" scrollamount="6" loop="5"   width='1280'>尊敬的IPTV用户：为了给您提供更好的服务，北京电视台将于2013年6月14日00:00至08:00进行系统升级，由此给您带来的不便请您谅解。</marquee></div>-->
 <%--左侧的大的div--%>
 <div id="left_menua" style="position:absolute; width:227px; height:483px; left:80px; top:113px; z-index:-100;">
 <div  style="background:url('images/portal/bg_portal_left.png') no-repeat; position:absolute; width:227px; height:483px; left:0px; top:0px; font-size:22px;color:#FFFFFF; line-height:51px;" align="center">
 <div id="" class="" width="170" height="41" style="position:absolute;top:14px;left:16px;"><img src="images/btv_log.png" width="190" height="49"/></div>
	<!--<div id="" class="" width="99" height="41" style="position:absolute;top:14px;left:98px;"><img src="images/btv_log.png" width="104" height="44"/></div>-->
      <div id='up' style="background:url('images/vod/btv_up.png') no-repeat; position:absolute; width:24px; height:14px; left:95px; top:73px; " >
      </div>
      <div id='down' style="background:url('images/vod/btv_down.png')no-repeat; position:absolute; width:24px; height:14px; left:95px; top:456px; " >
      </div>


      <div id="left_focus_img" style="position:absolute; width:205px; height:51px; left:6px; top:89px;visibility:hidden " >
          <img id="left_focus_img11" height="51" width="210" src="images/portal/focus.png" />
      </div>
<div id="chanel_info" style="position:absolute; width:197px; height:51px; left:16px; top:90px; display:none">限时免费频道</div>
     <%
         for(int i=0; i<7; i++){
             int topIndex = 90+51*i;
     %>
      <div id="left_menu_<%=i%>" style="background:url('images/portal/line2.png') no-repeat bottom; position:absolute; width:197px; height:51px; left:16px; top:<%=topIndex%>px; " >

      </div>
     <%
         }
     %>
	 
<!--	 <div  id="worldcup_dec" style="position:absolute;width:197px;height:306px;left:14px;top:192px; display:none;">看吧全新上线<br>
	   聚合全方位内容<br>
     欢迎体验！</div>-->
 </div>
 </div>
<!--推荐-->
<!--<div   style="position:absolute; left:974px;  top:57px; width:220px; height:533px; font-size:22px;  color:#FFF; line-height:54px">
	<div id="recommend_bg" style="position:absolute;top:72px; left:5px; height:454px; width:211px;"><img src="images/recommend/recommend_bg.png" width="211" height="454" border="0" /></div>
	
	<div id="recommend_0" style="position:absolute;top:78px; left:12px; height:36px; width:197px;"><img id="recommend_img_1" src="images/recommend/recommend_6.jpg" width="197" height="36" border="0" /></div>
	<div id="recommend_1" style="position:absolute;top:118px; left:12px; height:77px; width:96px;"><img id="recommend_img_2" src="images/recommend/recommend_10.jpg" width="96" height="77" border="0" /></div>
	<div id="recommend_1_0" style="position:absolute;top:118px; left:112px; height:77px; width:97px;"><img id="recommend_img_2_0" src="images/recommend/recommend_11.jpg" width="97" height="77" border="0" /></div>	
	<div id="recommend_2" style="position:absolute;top:199px; left:12px; height:77px; width:197px;"><img id="recommend_img_3" src="images/recommend/recommend_2.jpg" width="197" height="77" border="0" /></div>
	<div id="recommend_3" style="position:absolute;top:280px; left:12px; height:77px; width:143px;"><img id="recommend_img_4" src="images/recommend/recommend_8.jpg" width="143" height="77" border="0" /></div>
	<div id="recommend_3_0" style="position:absolute;top:280px; left:159px; height:77px; width:50px;"><img id="recommend_img_4_0" src="images/recommend/recommend_9.jpg" width="50" height="77" border="0" /></div>
	<div id="recommend_4" style="position:absolute;top:361px; left:12px; height:77px; width:197px;"><img id="recommend_img_5" src="images/recommend/recommend_4.jpg" width="197" height="77" border="0" /></div>
	<div id="recommend_5" style="position:absolute;top:442px; left:12px; height:77px; width:197px;"><img id="recommend_img_6" src="images/recommend/recommend_5.jpg" width="197" height="77" border="0" /></div>
	

	<div id="recommend_focus_0" style="position:absolute;top:74px; left:8px; height:44px; visibility:hidden;"><img src="images/recommend/recommend_focus_shu_ban.png" width="205" height="44" border="0" /></div>
	<div id="recommend_focus_1" style="position:absolute;top:114px; left:8px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus_heng_ban.png" width="104" height="85" border="0" /></div>
	<div id="recommend_focus_1_0" style="position:absolute;top:114px; left:108px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus_heng_ban.png" width="104" height="85" border="0" /></div>
	<div id="recommend_focus_2" style="position:absolute;top:195px; left:8px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus.png" width="205" height="85" border="0" /></div>	
	<div id="recommend_focus_3" style="position:absolute;top:276px; left:8px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus_heng_da.png" width="151" height="85" border="0" /></div>
	<div id="recommend_focus_3_0" style="position:absolute;top:276px; left:155px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus_heng_xiao.png" width="58" height="85" border="0" /></div>	
	<div id="recommend_focus_4" style="position:absolute;top:357px; left:8px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus.png" width="205" height="85" border="0" /></div>
	<div id="recommend_focus_5" style="position:absolute;top:438px; left:8px; height:85px; visibility:hidden;"><img src="images/recommend/recommend_focus.png" width="205" height="85" border="0" /></div>	
	
</div>-->
<!--推荐位-->
<!--<div style="position:absolute;width:500px;height:600px;left:20px;top:90px;">
<div id="recommend_0" style="position:absolute; width:129px; height:70px; left:1059px; top:58px; "><img id="dyn_img_0" src="" width="129" height="70"/></div>
<div id="recommend_1" style="position:absolute; width:129px; height:70px; left:1038px; top:115px; "><img id="dyn_img_1" src="" width="129" height="70"/></div>-->
<!--<div id="recommend_6" style="position:absolute; width:129px; height:70px; left:1059px; top:447px;"><img id="dyn_img_6" src="images/recommend/1.png" width="129" height="70"/></div>-->
<!--<div id="recommend_5" style="position:absolute; width:129px; height:70px; left:1080px; top:391px;"><img id="dyn_img_5" src="" width="129" height="70"/></div>
<div id="recommend_4" style="position:absolute; width:129px; height:70px; left:1059px; top:334px;"><img id="dyn_img_4" src="" width="129" height="70"/></div>
<div id="recommend_3" style="position:absolute; width:129px; height:70px; left:1038px; top:277px;"><img id="dyn_img_3" src="" width="129" height="70"/></div>
<div id="recommend_2" style="position:absolute; width:192px; height:108px; left:1006px; top:177px;"><img id="dyn_img_2" src="" width="192" height="108"/></div>
<div style="position:absolute; left:999px; top:171px;"><img id="red_focus" src="images/recommend/recom_onfocus.png" width="206" height="122" style="visibility:hidden;"/></div>
</div>-->
<div style="position:absolute; width:262px; height:471px; left:1016px; top:108px"><img src="images/recommend/recommend_bg.png" width="262" height="471"></div>
<div id="rec_focus" style="position:absolute;width:194px; height:44px; left:1062px; top:319px; visibility:hidden"><img src="images/recommend/recommend_focus.png" width="194" height="44"></div>
<div id="recommend_0" style="position:absolute; width:121px; height:30px; left:1133px; top:141px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_1" style="position:absolute; width:146px; height:30px; left:1108px; top:188px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_2" style="position:absolute; width:165px; height:30px; left:1088px; top:236px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_3" style="position:absolute; width:176px; height:30px; left:1076px; top:284px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_4" style="position:absolute; width:185px; height:30px; left:1068px; top:332px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_5" style="position:absolute; width:177px; height:30px; left:1076px; top:381px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_6" style="position:absolute; width:166px; height:30px; left:1088px; top:426px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_7" style="position:absolute; width:145px; height:30px; left:1108px; top:473px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="recommend_8" style="position:absolute; width:122px; height:30px; left:1133px; top:521px; font-size:22px;color:#FFFFFF;" align="left"></div>
<div id="rec_img_bg" style="position:absolute;width:289px; height:166px; left:764px; top:263px;visibility:hidden;"><img src="images/recommend/recommend_img.png" width="289" height="166"></div>
<div id="rec_img" style="position:absolute;width:205px; height:114px; left:801px; top:290px;visibility:hidden;"><img id="recommend_img" src="" width="206" height="115"></div>

 <%--下方菜单展示--%>
<div style="position:absolute; width:1279px; height:183px; left:0px; top:537px; ">
    <img src="images/portal/bg_portal_down.png" width="1279" height="183"/>
</div>
 <div style="position:absolute; width:1280px; height:200; left:0px; top:485px; font-size:28px;" align="center">
    <div style="left:-590; top: 100; width: 1; height: 1; position: absolute">
        <a href="javascript:dotest();" >
            <img alt="" src="images/btn_trans.gif" width="30" height="30" border="0"/>
        </a>
    </div>
    
        <div id="bottom_menu_focus0" style=" position:absolute; width:116px; height:116px; left:196px; top:59px; visibility:hidden">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
    
     
         <div id="bottom_menu_focus1" style=" position:absolute; width:116px; height:116px; left:308px; top:36px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
   
     
         <div id="bottom_menu_focus2" style=" position:absolute; width:116px; height:116px; left:420px; top:16px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>                                           
  
     
         <div id="bottom_menu_focus3" style=" position:absolute; width:116px; height:116px; left:534px; top:4px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
   
     
         <div id="bottom_menu_focus4" style=" position:absolute; width:116px; height:116px; left:642px; top:8px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
  
    
         <div id="bottom_menu_focus5" style=" position:absolute; width:116px; height:116px; left:759px; top:16px; visibility:hidden">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
  
    
         <div id="bottom_menu_focus6" style=" position:absolute; width:116px; height:116px; left:867px; top:38px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
    
    
         <div id="bottom_menu_focus7" style=" position:absolute; width:116px; height:116px; left:979px; top:62px;visibility:hidden ">
            <img width="116" height="116" src="images/portal/focus_bottom.png"/>
        </div>
   
    <%--我的tv--%>

        <div id="buttom_0" style="background:url('images/portal/icons/myTV.png'); position:absolute; width:100px; height:100px; left:204px; top:80px; ">
        </div>
  
   
        <div id="bottom_menu_text_0" style=" position:absolute; width:116px; height:30px; left:204px; top:175px; color:#ffffff; font-size:26">
            看吧
        </div>
  
    <%--回看--%>

        <div id="buttom_1" style="background:url('images/portal/icons/tvod.png'); position:absolute; width:100px; height:100px; left:316px; top:57px;" >
        </div>
	
    
        <div id="bottom_menu_text_1" style="position:absolute; width:116px; height:30px; left:308px; top:160px; color:#ffffff;">
             回看
        </div>
	
    <%--点播--%>

        <div id="buttom_2" style="background:url('images/portal/icons/vod.png'); position:absolute; width:100px; height:100px; left:428px; top:37px; ">
        </div>


        <div id="bottom_menu_text_2" style=" position:absolute; width:116px; height:30px; left:420px; top:150px; color:#ffffff;">
             点播
      
    </div>
    <%--频道--%>

        <div id="buttom_3" style="background:url('images/portal/icons/channel.png'); position:absolute; width:100px; height:100px; left:542px; top:24px; ">
        </div>

    
        <div id="bottom_menu_text_3" style=" position:absolute; width:116px; height:30px; left:534px; top:140px; color:#ffffff;">
             直播
        </div>
   
    <%--专题--%>

        <div id="buttom_4" style="background:url('<%=getChinese(param,"app_0_img")%>'); position:absolute; width:100px; height:100px; left:650px; top:27px; ">
        </div>

   
        <div id="bottom_menu_text_4" style=" position:absolute; width:116px; height:30px; left:642px; top:140px; color:#ffffff;">
            <%=name0%>
        </div>
   
    <%--应用--%>

        <div id="buttom_5" style="background:url('<%=getChinese(param,"app_1_img")%>'); position:absolute; width:100px; height:100px; left:767px; top:37px; ">
        </div>
  
   
        <div id="bottom_menu_text_5" style=" position:absolute; width:116px; height:30px; left:759px; top:150px; color:#ffffff;">
             <%=name1%>
        </div>
  
    <%--社区--%>
   
        <div id="buttom_6" style="background:url('<%=getChinese(param,"app_2_img")%>'); position:absolute; width:100px; height:100px; left:875px; top:55px; ">
        </div>
   
   
        <div id="bottom_menu_text_6"  style=" position:absolute; width:116px; height:30px; left:867px; top:158px; color:#ffffff;">
             <%=name2%>
        </div>
   
    <%--生活--%>

        <div id="buttom_7" style="background:url('<%=getChinese(param,"app_3_img")%>'); position:absolute; width:100px; height:100px; left:987px; top:87px; ">
        </div>
   
     
        <div id="bottom_menu_text_7" style="position:absolute; width:116px; height:30px; left:979px; top:175px; color:#ffffff;">
            <%=name3%>
        </div>
   
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


<script language="javascript" type="">

 var l1 = new Date().getTime();

var backurlparam ="<%=timeFrameUrl%>/portal.jsp";
var userid="<%=userInfo.getUserId()%>";
var bottomMenuIndex = <%=bottomMenuIndex%>;
var leftMenuIndex = <%=leftMenuIndex%>;
var recommend_indexa = <%=leftMenuIndex%>;
var destpage = <%=destpage%>;
var channelColumnid = "<%=channelColumnid%>";
var vodColumnid = "<%=vodColumnid%>";
var tempno = "<%=tempno%>";
var startIndex=<%=startIndex%>;
var endIndex=<%=endIndex%>;
var channelname1 = '导航列表';
var tvodchannelname = '回看导航';
var favoriteUrl = "";
var tvguideUrl = "";
var now_channel_num = top.channelInfo.currentChannel;
var returnurl = "<%=timeFrameUrl%>/thirdback.jsp";
returnurl=encodeURIComponent(returnurl);
var gourl = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg10&page=portal&ReturnURL='+returnurl;
var gourl1 = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg20&page=portal&ReturnURL='+returnurl;
var gourl2 = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg20&page=see_child&ReturnURL='+returnurl;
var gourl3 = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg20&page=see_zongyi&ReturnURL='+returnurl;
var gourl4 = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg20&page=see_life&ReturnURL='+returnurl;
var gourl5 = 'http://61.135.89.195/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&page=portal&ReturnURL='+returnurl;
if(isZTEBW == true){
    favoriteUrl = "vod_favorite_pre.jsp";
    tvguideUrl = "channel_pre.jsp";
}else{
    favoriteUrl = "vod_favorite.jsp";
    tvguideUrl = "channel.jsp";
}

 var isCugConfig = "<%=isCugConfig%>";
 
 var setUrl = "setting.jsp";
 if(isCugConfig == "1" || isCugConfig == 1){
     setUrl = "setting_cu.jsp";
 }


//alert("SSSSSSSSSSSnavigator.appName="+window.navigator.appName+"__isZTEBW="+isZTEBW);

var currentChannel = top.channelInfo.currentChannel;
//社区相关
var commarr=[];
<%
  int i=0;
  while(param.get("app_2_"+i+"_name")!=null){
%>
commarr[commarr.length]={invalid:'<%=String.valueOf(param.get("app_2_"+i+"_invalid"))%>',columnname:'<%=String.valueOf(param.get("app_2_"+i+"_name"))%>',cname:'<%=String.valueOf(param.get("app_2_"+i+"_name"))%>',curl:'<%=replaceUrl(request,String.valueOf(param.get("app_2_"+i+"_url")),param)%>',cimg:'<%=String.valueOf(param.get("app_2_"+i+"_img"))%>',gosd:'<%=String.valueOf(param.get("app_2_"+i+"_gosd"))%>'};
<%
    i++;
}
%>

//生活相关
var lifeArr = [];
<%
  i=0;
  while(param.get("app_3_"+i+"_name")!=null){
%>
lifeArr[lifeArr.length]={invalid:'<%=String.valueOf(param.get("app_3_"+i+"_invalid"))%>',columnname:'<%=String.valueOf(param.get("app_3_"+i+"_name"))%>',cname:'<%=String.valueOf(param.get("app_3_"+i+"_name"))%>',curl:'<%=replaceUrl(request,String.valueOf(param.get("app_3_"+i+"_url")),param)%>',cimg:'<%=String.valueOf(param.get("app_3_"+i+"_img"))%>',gosd:'<%=String.valueOf(param.get("app_3_"+i+"_gosd"))%>'};
<%
    i++;
}
%>
//应用
var appArr = [];
<%
  i=0;
  while(param.get("app_1_"+i+"_name")!=null){
%>
appArr[appArr.length]={invalid:'<%=String.valueOf(param.get("app_1_"+i+"_invalid"))%>',columnname:'<%=String.valueOf(param.get("app_1_"+i+"_name"))%>',cname:'<%=String.valueOf(param.get("app_1_"+i+"_name"))%>',curl:'<%=replaceUrl(request,String.valueOf(param.get("app_1_"+i+"_url")),param)%>',cimg:'<%=String.valueOf(param.get("app_1_"+i+"_img"))%>',gosd:'<%=String.valueOf(param.get("app_1_"+i+"_gosd"))%>'};
<%
    i++;
}
%>
appArr[appArr.length] = {invalid:'',columnname:'我的收藏',cname:'我的收藏',curl:favoriteUrl,cimg:'',gosd:''};
 if(isReallyZTE != false){
appArr[appArr.length] = {invalid:'',columnname:'用户设置',cname:'用户设置',curl:setUrl,cimg:'',gosd:''};
}
//首页推荐位第三方应用

var portalArr = [];
<%
  i=0;
  while(param.get("app_4_"+i+"_name")!=null){
%>
portalArr[portalArr.length]={invalid:'<%=String.valueOf(param.get("app_4_"+i+"_invalid"))%>',columnname:'<%=String.valueOf(param.get("app_4_"+i+"_name"))%>',cname:'<%=String.valueOf(param.get("app_4_"+i+"_name"))%>',curl:'<%=replaceUrl(request,String.valueOf(param.get("app_4_"+i+"_url")),param)%>',cimg:'<%=String.valueOf(param.get("app_4_"+i+"_img"))%>',gosd:'<%=String.valueOf(param.get("app_4_"+i+"_gosd"))%>'};
<%
    i++;
}
%>
//看吧
var mytvArr = [{tvname:'看吧正式组',tvurl:gourl},{tvname:'看吧内容测试',tvurl:gourl1},{tvname:'看吧业务测试',tvurl:gourl5}];
//订制空间
//var mytvArr = [{tvname:'我的收藏',tvurl:favoriteUrl}
//                 ,{tvname:'节目导视',tvurl:tvguideUrl}
//				 ,{tvname:'淘电影',tvurl:'channel_play.jsp?mixno=350'}
//                 ,{tvname:'用户设置',tvurl:setUrl}
//                 ,{tvname:'我的信箱',tvurl:'mail_message.jsp?leefocus=0_5',invalid:'true'}
//                 ,{tvname:'消费记录',tvurl:'selfcare_myAcount_ppv.jsp?leefocus=0_6',invalid:'true'}
//                ];
////专题
// if(isReallyZTE == false){
//     mytvArr = [{tvname:'我的收藏',tvurl:favoriteUrl}
//         ,{tvname:'节目导视',tvurl:tvguideUrl}
//		 ,{tvname:'淘电影',tvurl:'channel_play.jsp?mixno=350'}
//         ,{tvname:'我的信箱',tvurl:'mail_message.jsp?leefocus=0_4',invalid:'true'}
//         ,{tvname:'消费记录',tvurl:'selfcare_myAcount_ppv.jsp?leefocus=0_5',invalid:'true'}
//     ];
// }
var SpecalColumnlist = <%=columnStr%>;
<%
//  i=0;
 // while(param.get("app_0_"+i+"_name")!=null){
  for(int j=100; j>=0; j--){
  if(param.get("app_0_"+j+"_name")!=null){
%>
SpecalColumnlist[SpecalColumnlist.length] = {columnid:"0",columnname:"<%=String.valueOf(param.get("app_0_"+j+"_name"))%>",columnposter:"<%=replaceUrl(request,String.valueOf(param.get("app_0_"+j+"_url")),param)%>"};
<%
   // i++;
  //}
  }
  }
%>
var specallength = SpecalColumnlist.length;
var alsus = "该服务已经收藏";
var sus = "收藏成功";

var portalUrl ="<%=timeFrameUrl%>/portal.jsp";
var thirdbackUrl="<%=timeFrameUrl%>/thirdback.jsp";
</script>

 <%--<%--%>
     <%--String jsDebugStatus=(String)param.get("jsDebugStatus");--%>
     <%--if(jsDebugStatus!=null && jsDebugStatus.equals("1")){--%>
 <%--%>--%>
 <script type="text/javascript" src="js/portal.js"></script>
    <script language="javascript" type="">
       
        <%@ include file="js/json.js" %>


        var l2 = new Date().getTime();
        //判断是否为华为盒子，如果是，则获取首页键处理权
        var ua = window.navigator.userAgent;
        //alert("=====ua===="+ua);
        if(ua.indexOf("Ranger/3.0.0")>-1){
           //alert("this is hw get key to epg");
           keyEPGPortal(portalUrl);
        }

    </script>
 <%--<%--%>
     <%--}else{--%>
 <%--%>--%>
    <%--<script type="text/javascript" src="js/portal.js"></script>--%>
    <%--<script type="text/javascript" src="js/json.js"></script>--%>
 <%--<%--%>
     <%--}--%>
 <%--%>--%>



 <%@ include file="inc/lastfocus.jsp" %>
 
</body>
</html>