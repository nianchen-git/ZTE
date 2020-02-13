<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="java.util.*" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelDataSource" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="java.util.ArrayList" %>
<epg:PageController name="channel_all_tvod.jsp"/>
 <%@ include file="inc/getString_java.jsp" %>

<%!
    /**
     * 获取字符串的长度，如果有中文，则每个中文字符计为2位
     *
     * @param value
     *            指定的字符串
     * @param value
     *            最多能容纳的最多的中文长度
     * @return 截取过后的字符串
     */
    public String  subStr(String value,double subLeng) {
        double valueLength = 0;
//        String chinese = "[\u0391-\uFFE5]";

        int length = 0;

        if(value!=null){
            length = value.length();
        }

        for(int i=0; i<length; i++){
//            System.out.println("SSSSSSSSSSSSSSS"+i+"="+value.charAt(i));
            char tempChar = value.charAt(i);
            if(isChinese(String.valueOf(tempChar))){
                /* 中文字符长度为1 */
                valueLength += 1;
            }else if(tempChar>='A' && tempChar<='Z'){
                valueLength += 0.8;
            }else{
                valueLength += 0.5;
            }
            if(valueLength>=subLeng){
                return  value.substring(0,i+1);
            }
        }
        return value;
    }
%>

<%
    //System.out.println("+++++++++channel_all_tvod.jsp="+request.getQueryString());
	String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String columnid= String.valueOf(param.get("column00"));
    String destpage = request.getParameter("destpage");
    //System.out.println("start---------------columnid="+columnid);
    //System.out.println("start---------------destpage="+destpage);
    //columnid="00";
    List <String> channelno = new ArrayList<String>();
	List <String> channelna = new ArrayList<String>();
    String lastfocus = request.getParameter("lastfocus");
    if(lastfocus == null || lastfocus.equals("")){
        lastfocus ="0";
    }

    try{
        Integer.parseInt(lastfocus);
    } catch (Exception e){
        System.out.println("SSSSSSSSSSSSSSSSSlastfocus_not_right!!!");
        lastfocus = "0";
    }
    
    int destpage1=1 ;
    int numberperpage1 = 50;
    if(destpage != null && !"".equals(destpage)){
        try{
             destpage1 = Integer.parseInt(destpage);
        }catch (Exception e){
            System.out.println("destpage youwenti!!!!!");
            e.printStackTrace();
        }
    }
    //System.out.println("after---------------columnid="+columnid);
    //System.out.println("after---------------destpage1="+destpage1);
%>
     <%
        int pageCount ;
        int totalCount ;
        UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
        ColumnDataSource columnDs = new ColumnDataSource();
        ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnid);

        EpgResult result = columnDs.getData();
        HashMap hmPage = result.getDataOut();
        EpgPaging paging = (EpgPaging) hmPage.get("page");
        pageCount = paging.getPageCount();
        totalCount = paging.getTotalCount();
        List vColumnData = (Vector) result.getData();

        String oColumnid = "";
        int length = vColumnData.size();
        int size = 0;
        ChannelDataSource channelDs = null;
        ColumnInfo columnInfo = null;
        ChannelInfo channelInfo = null;

//         channelInfo.
        List ChannelInfoList = new ArrayList();
		System.out.println("-----------------------length="+length);
        if(length>0){
            for(int i=0; i<length; i++){
                columnInfo = (ColumnInfo)vColumnData.get(i);
                oColumnid  = columnInfo.getColumnId();
				if("0400".equals(oColumnid) || "0401".equals(oColumnid) || "0402".equals(oColumnid) ||"0403".equals(oColumnid) || "0405".equals(oColumnid)){
                channelDs = new ChannelDataSource();
                ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
                valuesIn.setUserInfo(userInfo);
                valuesIn.setColumnId(oColumnid);
                EpgResult resultTV = channelDs.getData();
                List vChannelData = (Vector) resultTV.getData();
               if(i>=1){
				 for (int m = 0; m < vChannelData.size(); m++) {
            		ChannelInfo ChannelInfof = (ChannelInfo) vChannelData.get(m);
					String noaf = String.valueOf(ChannelInfof.getMixNo());
					int channel_flag = 0;//0为无重复频道
					//System.out.println("fan----z-------noaf==="+noaf);
					for(int d =0; d<channelno.size(); d++){
						if((channelno.get(d)).equals(noaf)){
						   // channelna.add(noaf);
						   // ChannelInfoList.add(ChannelInfof);
						   channel_flag=1;
						   break;
						}
					}
					if(channel_flag==0){
						channelno.add(noaf);
						ChannelInfoList.add(ChannelInfof);
					}
		    
	  			 }
	 		 }else{
			    for(int s=0; s<vChannelData.size(); s++){
					ChannelInfo ChannelInfos = (ChannelInfo) vChannelData.get(s);	
					String noas = String.valueOf(ChannelInfos.getMixNo());
					channelno.add(noas);
				}
                ChannelInfoList.addAll(vChannelData);
				}
            }
			}
        }else{
                channelDs = new ChannelDataSource();
                ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
                valuesIn.setUserInfo(userInfo);
                valuesIn.setColumnId(columnid);
                EpgResult resultTV = channelDs.getData();
                List vChannelData = (Vector) resultTV.getData();
                ChannelInfoList.addAll(vChannelData);
        }
		//回看屏蔽频道
		for (int m = 0; m < ChannelInfoList.size(); m++) {
            ChannelInfo ChannelInfom = (ChannelInfo) ChannelInfoList.get(m);
            String noas = String.valueOf(ChannelInfom.getMixNo());
            
            if("301".equals(noas)||"302".equals(noas)||"303".equals(noas)||"3".equals(noas) ||"5".equals(noas)|| "6".equals(noas)||"8".equals(noas)||"75".equals(noas)||"76".equals(noas)||"77".equals(noas)){
                ChannelInfoList.remove(m);
                m--;
            }
        }
		//end


        List tempChanelInfoList = new ArrayList();
        size = ChannelInfoList.size();
        if(size >0){
            for(int i=0; i<size; i++){
                channelInfo = (ChannelInfo)ChannelInfoList.get(i);
//                if(channelInfo.getTvodenable() == 1){
                if(channelInfo.getUsertvodenable()){
                    tempChanelInfoList.add(channelInfo);
                }

//                System.out.println("SSSSSSSS000000SSSgetChannelName="+channelInfo.getChannelName()+"|SSSSSSSSSS|"+channelInfo.getTvodenable()+"|SSSSSSSSSS|"+channelInfo.getUsertvodenable());
            }
            ChannelInfoList = tempChanelInfoList;
        }
        //System.out.println("-----------------------totalLength="+ChannelInfoList.size());

        size = ChannelInfoList.size();

//         System.out.println("SSSSSSSSSSSSSSSSchannel_all_tvod_size="+size);
        int startIndex = 0;
        int endIndex = 0;
        startIndex = numberperpage1*(destpage1-1);
        endIndex = numberperpage1*destpage1-1;
        if(endIndex>(size-1)){
            endIndex = size-1;
        }

        int curPageCount =  endIndex-startIndex+1;
        pageCount = (size+numberperpage1-1)/numberperpage1;
		//System.out.println("----------------pageCount="+pageCount);
		//System.out.println("----------------destpage1="+destpage1);
    %>
<html>
  <head>
    <title></title>
	<style>
	.channel_size{
	font-size:24px;
	}
	</style>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <link rel="stylesheet" href="css/common.css" type="text/css" />
	<script language="javascript" type="">
var isGetData = true;
var channelList = [];
var curIndex = <%=lastfocus%>;
var curpageSize =0;
var destpage1 = <%=destpage1%>;

var $$ = {};
var $ = function(id){
    if(!$$[id]){
       $$[id] = document.getElementById(id);
    }
    return $$[id];
}

//var isZTEBW = false;
//if(window.navigator.appName == "ztebw"){
//    isZTEBW = true;
//}

function doRed() {
    if(channelList[curIndex]){
//    var requestUrl = "action/channel_favorite_add.jsp?SubjectID=" + curcolumnid + "&ContentID=" + curMaxNo + "&FavoriteTitle=" + encodeURI(encodeURI(favoriteTitle)) + "&channelid=" + curchannelid;
    var requestUrl = "action/channel_favorite_add.jsp?SubjectID=" + channelList[curIndex].columnid + "&ContentID=" + channelList[curIndex].mixno + "&FavoriteTitle=" + encodeURI(encodeURI(channelList[curIndex].channelName)) + "&channelid=" + channelList[curIndex].channelid;
    var loaderSearch = new net.ContentLoader(requestUrl, showaddFav);
    }

}
function showaddFav() {
	//alert('--------------------------->showaddFav');
    var timer;
    var results = this.req.responseText;
    var tempData = eval("(" + results + ")");
    var dellflag = tempData.requestflag;
    if (dellflag == 0) {
         $("text").innerText = "收藏成功";
         $("msg").style.visibility = "visible";
         $("closeMsg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    } else if (dellflag == 2) {
         $("text").innerText = "节目已收藏";
         $("msg").style.visibility = "visible";
          $("closeMsg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    } else if(dellflag==3){
         $("text").innerText = "收藏已达上限 ";
         $("msg").style.visibility = "visible";
         $("closeMsg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    }else {
         $("text").innerText = "收藏失败";
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
}
function goNext(){
	<%if(destpage1<pageCount){%>
		window.location="channel_all_tvod.jsp?destpage=<%=destpage1+1%>";
	<%}else if(pageCount>1&&destpage1 == pageCount){%>
        window.location="channel_all_tvod.jsp?destpage=1";
	<%}%>
}
function goLast(){
	<%if(destpage1>1){%>
		window.location="channel_all_tvod.jsp?destpage=<%=destpage1-1%>";
	<%}else if(destpage1 == 1 && pageCount>1){%>
	    window.location="channel_all_tvod.jsp?destpage=<%=pageCount%>";
	<%}%>
}

function doPosition(flag){
  // alert("SSSSSSSSSSSSdoPosition!!!flag="+flag);
   var tempindex = 0;
   if(flag == "left"){
      tempindex = curIndex-10;
   }else if(flag == "right"){
      tempindex = curIndex+10;
   }else if(flag == "up"){
      tempindex = curIndex-1;
   }else if(flag == "down"){
      tempindex = curIndex+1;
   }else if(flag == "ok"){
       if(channelList[curIndex]){
//           if(channelList[curIndex].mixno == 11){
//               document.location = "channel_onedetial_tvod_bak.jsp?channelid="+channelList[curIndex].channelid+"&columnid="+channelList[curIndex].columnid+"&mixno="+channelList[curIndex].mixno+"&leefocus="+curIndex;
//           }else{
//              document.location = "channel_onedetial_tvod.jsp?channelid="+channelList[curIndex].channelid+"&columnid="+channelList[curIndex].columnid+"&mixno="+channelList[curIndex].mixno+"&leefocus="+curIndex;
//           }
           if(isZTEBW == true){
               document.location = "channel_onedetail_tvod_pre.jsp?channelid="+channelList[curIndex].channelid+"&columnid="+channelList[curIndex].columnid+"&mixno="+channelList[curIndex].mixno+"&leefocus="+curIndex;
           }else{
               document.location = "channel_onedetail_tvod.jsp?channelid="+channelList[curIndex].channelid+"&columnid="+channelList[curIndex].columnid+"&mixno="+channelList[curIndex].mixno+"&leefocus="+curIndex;
           }
       }
       return;
   }
   if(tempindex>=0 && tempindex<curpageSize){
       getFocus(false);
       curIndex = tempindex;
       getFocus(true);
  }else{
       if(flag == "up"){
           goLast();
       }else if(flag == "down"){
           goNext();
       }
   }
}

var tempChannelName = null;

function getFocus(flag){
    if(flag == true){
        $("img_"+curIndex).style.visibility = "visible";
//        alert("SSSSSSSSSSSSSSSSchannelList[curIndex].channelName="+channelList[curIndex].channelName);
//        alert("SSSSSSSSSSSSSSSSchannelList[curIndex].channelName.length="+channelList[curIndex].channelName.length);
        if(channelList[curIndex].hasBreak =='1'){
            tempChannelName = $('name_'+curIndex).innerHTML;
            $('name_'+curIndex).innerHTML="<marquee version='3' scrolldelay='250' width='188' class='channel_size'>" +channelList[curIndex].mixno+" "+channelList[curIndex].channelName+ "</marquee>";;
        }
    }else{
        $("img_"+curIndex).style.visibility = "hidden";
        if(channelList[curIndex].hasBreak =='1'){
            $('name_'+curIndex).innerHTML = tempChannelName;
        }
    }
}

function doKeyPress(evt){
    if(isGetData == true){
        return false;
    }
    var keycode = evt.which;
    if (keycode == <%=STBKeysNew.onKeyLeft%>){
		doPosition("left");
    }else if (keycode == <%=STBKeysNew.onKeyRight%>){
		doPosition("right");
    }else if (keycode == <%=STBKeysNew.onKeyOK%>){
		doPosition("ok");
    }else if (keycode == <%=STBKeysNew.onKeyUp%>){
		doPosition("up");
    }else if (keycode == <%=STBKeysNew.onKeyDown%>){
		doPosition("down");
    }else if (keycode == <%=STBKeysNew.remotePlayNext%>){
        goNext();
    }else if (keycode == <%=STBKeysNew.remotePlayLast%>){
        goLast();
    }else if (keycode == 0x0115){
        var url = "vod_portal.jsp?leefocus="+curIndex;
        if(isZTEBW == true){
            url = "vod_portal_pre.jsp?leefocus="+curIndex;
        }
        document.location = url;
    }else if (keycode == <%=STBKeysNew.onKeyBlue%>){
		document.location = "vod_search.jsp?columnpath=&leefocus="+curIndex;
    }else if (keycode == <%=STBKeysNew.onKeyRed%>){
		doRed();
    }else if(keycode == 0x0110){
     /*   if("CTCSetConfig" in Authentication)
        {
           // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
            Authentication.CTCSetConfig("KeyValue","0x110");
        }else{
         //   alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
            Authentication.CUSetConfig("KeyValue","0x110");
        }*/
        top.mainWin.document.location = "portal.jsp";
    }else if(keycode == 36){
        top.mainWin.document.location = "portal.jsp";
    }else if (keycode == <%=STBKeysNew.remoteBack%> || keycode == 24){
        top.mainWin.document.location = "back.jsp";
    }else{
        commonKeyPress(evt);
    }
    return false;
}

document.onkeypress = doKeyPress;
</script>
  </head>
 <%@ include file="inc/time.jsp" %> 
 <body bgcolor="transparent" class="body_bg" >
    <div class="topImg" style="font-size:20px;top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
        <div style="background:url('images/tvod/btv-replay-ico.png'); left:13; top:12px; width:41px; height:30px; position:absolute; ">
        </div>
        <div align="left" style="font-size:24px; line-height:50px; left:62; top:4px; width:260px; height:35px; position:absolute; ">
              回看 > 回看导航
        </div>
    </div>
    <%--<div id="img_focus" style="position:absolute; left:100px; top:98px; width:212px; height:40px;">--%>
        <%--<img  src="images/portal/focus1.png" height="40" width="205" alt="" />--%>
     <%--</div>--%>
		<%
            StringBuffer sb = new StringBuffer("[");
            int rowindex = 0;
            int colindex = 0;
//            System.out.println(charLength("中国AZ1234ttt"));
            int channelflag = 1 ;
            for(int i=startIndex; i<=endIndex; i++){
                 int j = i -numberperpage1*(destpage1-1);
                 rowindex = j%10;
                 colindex = j/10;
                 int leftpos = 110+colindex*220;
                 int toppos = 106+rowindex*54;
				int s = i;
                 if(1==channelflag){
                 channelInfo = (ChannelInfo)ChannelInfoList.get(s);  
				 int mixno = channelInfo.getMixNo();
				 String noa = String.valueOf(mixno);
		         if("200".equals(noa)){
		       
		      channelflag=0;
                  s=i+1;
				 }
		channelInfo = (ChannelInfo)ChannelInfoList.get(s);		
                  mixno = channelInfo.getMixNo();
                 String mixnoStr =String.valueOf(mixno);
				
                 if(String.valueOf(mixno).length()==1){
                    mixnoStr ="00"+String.valueOf(mixno);
                 }else if(String.valueOf(mixno).length()==2){
                    mixnoStr ="0"+String.valueOf(mixno);
                 }
                 String channelName = channelInfo.getChannelName();
//                 channelName = "黑龙江卫视高清1111";
//                if(rowindex == 0){
//                    channelName = "HDMWHDMWHDMW";
//                }else if(rowindex == 1){
//                    channelName = "中国中国中国中国中国中国中国中国中国中国中国中国";
//                }else if(rowindex == 2){
//                    channelName = "??????%$&&&&";
//                }else if(rowindex == 3){
//                    channelName = "abcdefgabcdefgabcdefg";
//                } else if(rowindex == 4){
//                    channelName = "123456789012345678901234567890";
//                }

                 channelName=mixnoStr+channelName;
                 String channelid = channelInfo.getChannelId();
                 String columnid1 = channelInfo.getFcolumnid();
//                 String textName=getFitString(channelName,24,200);
                 String textName = subStr(channelName,7.5);
//                 if(textName!=null && textName.length()>=10){
//                     textName = textName.substring(0,10);
//                 }
                 String hasBreak = "0";
                 if(!textName.equals(channelName)){
                     hasBreak = "1";
                 }
                 
                 sb.append("{channelid:\""+channelid+"\",");
                 sb.append("columnid:\""+columnid1+"\",");
                 sb.append("hasBreak:\""+hasBreak+"\",");
                 sb.append("channelName:\""+channelInfo.getChannelName()+"\",");
                 sb.append("mixno:\""+mixno+"\"},");

//                System.out.println("SSSSSSSS11111SSSgetChannelName="+channelInfo.getChannelName()+"|SSSSSSSSSS|"+channelInfo.getTvodenable()+"|SSSSSSSSSS|"+channelInfo.getUsertvodenable());
		%>
		     <%--<div style=" position:absolute; left:<%=leftpos-1280%>px; top:<%=toppos%>px; width:24px; height:14px;">--%>
		       <%--<a href="channel_onedetial_tvod.jsp?channelid=<%=channelid%>&columnid=<%=columnid1%>&mixno=<%=mixno%>&leefocus=lliker_<%=i%>"  name="lliker_<%=i%>" id="img_a_<%=j%>" onfocus="changeImg('img_<%=j%>',1,'<%=channelInfo.getChannelName()%>','<%=channelInfo.getChannelId()%>','<%=columnid1%>','<%=channelInfo.getMixNo()%>');" onblur="changeImg('img_<%=j%>',0);">--%>
		           <%--<img src="images/btn_trans.gif" alt="" width="1" height="1"/>--%>
		       <%--</a>--%>
		     <%--</div>--%>
             <div id="img_<%=j%>" style="visibility:hidden; position:absolute; left:<%=leftpos-10%>px; top:<%=toppos-8%>px; width:212px; height:40px;">
		       	<img  src="images/portal/focus1.png" height="40" width="205" alt="" />
		     </div>
             <%--<div style="border-left:1px solid yellow; border-right:1px solid blue; position:absolute; left:<%=leftpos-2%>px; top:<%=toppos%>px; width:238px; height:54px;color:white;font-size:24px;">--%>
             <div id="name_<%=i-startIndex%>" style="position:absolute; left:<%=leftpos-2%>px; top:<%=toppos%>px; width:238px; height:54px;color:white;font-size:24px;">
		       <%=textName%>
		     </div>
			 
			 
			 <%
				 }
				 
				 else{
				 int m =i+1;
				  channelInfo = (ChannelInfo)ChannelInfoList.get(m);
				 int mixno = channelInfo.getMixNo();
				  String mixnoStr =String.valueOf(mixno);
                 if(String.valueOf(mixno).length()==1 ){
                    mixnoStr ="00"+String.valueOf(mixno);
                 }else if(String.valueOf(mixno).length()==2){
                    mixnoStr ="0"+String.valueOf(mixno);
                 }
                 String channelName = channelInfo.getChannelName();
//                 channelName = "黑龙江卫视高清1111";
//                if(rowindex == 0){
//                    channelName = "HDMWHDMWHDMW";
//                }else if(rowindex == 1){
//                    channelName = "中国中国中国中国中国中国中国中国中国中国中国中国";
//                }else if(rowindex == 2){
//                    channelName = "??????%$&&&&";
//                }else if(rowindex == 3){
//                    channelName = "abcdefgabcdefgabcdefg";
//                } else if(rowindex == 4){
//                    channelName = "123456789012345678901234567890";
//                }

                 channelName=mixnoStr+channelName;
                 String channelid = channelInfo.getChannelId();
                 String columnid1 = channelInfo.getFcolumnid();
//                 String textName=getFitString(channelName,24,200);
                 String textName = subStr(channelName,7.5);
//                 if(textName!=null && textName.length()>=10){
//                     textName = textName.substring(0,10);
//                 }
                 String hasBreak = "0";
                 if(!textName.equals(channelName)){
                     hasBreak = "1";
                 }

                 sb.append("{channelid:\""+channelid+"\",");
                 sb.append("columnid:\""+columnid1+"\",");
                 sb.append("hasBreak:\""+hasBreak+"\",");
                 sb.append("channelName:\""+channelInfo.getChannelName()+"\",");
                 sb.append("mixno:\""+mixno+"\"},");

//                System.out.println("SSSSSSSS11111SSSgetChannelName="+channelInfo.getChannelName()+"|SSSSSSSSSS|"+channelInfo.getTvodenable()+"|SSSSSSSSSS|"+channelInfo.getUsertvodenable());
		%>
		     <%--<div style=" position:absolute; left:<%=leftpos-1280%>px; top:<%=toppos%>px; width:24px; height:14px;">--%>
		       <%--<a href="channel_onedetial_tvod.jsp?channelid=<%=channelid%>&columnid=<%=columnid1%>&mixno=<%=mixno%>&leefocus=lliker_<%=i%>"  name="lliker_<%=i%>" id="img_a_<%=j%>" onfocus="changeImg('img_<%=j%>',1,'<%=channelInfo.getChannelName()%>','<%=channelInfo.getChannelId()%>','<%=columnid1%>','<%=channelInfo.getMixNo()%>');" onblur="changeImg('img_<%=j%>',0);">--%>
		           <%--<img src="images/btn_trans.gif" alt="" width="1" height="1"/>--%>
		       <%--</a>--%>
		     <%--</div>--%>
             <div id="img_<%=j%>" style="visibility:hidden; position:absolute; left:<%=leftpos-10%>px; top:<%=toppos-8%>px; width:212px; height:40px;">
		       	<img  src="images/portal/focus1.png" height="40" width="205" alt="" />
		     </div>
             <%--<div style="border-left:1px solid yellow; border-right:1px solid blue; position:absolute; left:<%=leftpos-2%>px; top:<%=toppos%>px; width:238px; height:54px;color:white;font-size:24px;">--%>
             <div id="name_<%=i-startIndex%>" style="position:absolute; left:<%=leftpos-2%>px; top:<%=toppos%>px; width:238px; height:54px;color:white;font-size:24px;">
		       <%=textName%>
		     </div>
			<%
				 }
				
		%>		  
            
		<%
		    }
            sb.append("]");
		%>
     <script language="javascript" type="">
         isGetData = false;
         channelList = eval('<%=sb.toString()%>');
         curpageSize = channelList.length;
         getFocus(true);
     </script>
    
	    <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
 		</div> 
		<div style="position:absolute;width:1280px; height:40px; left: -10px; top: 640px; color:black;font-size:22px;">
		 <div  style="position:absolute;width:60px; height:32px; left: 560px; top: -2px; color:black;font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 620px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;上一页
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 720px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 780px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;下一页
		 	</div>
		 	<%--<div  style="position:absolute;width:60px; height:32px; left: 920px; top: -2px; color:black; font-size:22px;">--%>
		 		<%--<img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >--%>
		 	<%--</div>--%>
		 	<%--<div  style="position:absolute;width:120px; border:1px solid red; height:30px; left: 980px; top: 0px; color:white; font-size:22px;">--%>
		 		<%--&nbsp;按红色按钮为收藏--%>
		 	<%--</div>--%>
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

<%--<div style="left:443px; top:229px;width:568px;height:215px; position:absolute;z-index:2000">--%>
        <div id="msg" style="left:443px; top:229px; width:394px;height:215px; position:absolute;visibility:hidden;">
            <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
                <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
            </div>
            <div id="text" style="left:0px;top:100px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">

            </div>
            <div id="closeMsg" style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
                 2秒自动关闭
            </div>
        </div>
    <%--</div>--%>
<%--<%@ include file="inc/goback.jsp" %>--%>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>

  </body>
</html>
