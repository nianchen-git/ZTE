<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.STBKeysNew" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo"%>
<%@ page  import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelDataSource" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.zte.iptv.epg.util.*"%>
<meta http-equiv="pragma"   content="no-cache" />  
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate" />  
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT" />
<epg:PageController name="channel_onedetial_tvod.jsp"/>

<%
	String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String columnId = request.getParameter(EpgConstants.COLUMN_ID);
    String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
    String mixno = request.getParameter("mixno");
    //columnId = "0000";
    //channelId = "ch10111812502754910567";
    //System.out.println("start-------------------------mixno="+mixno);
    //System.out.println("start-------------------------channelId="+channelId);
    int destpage = 1;
    SimpleDateFormat df = new SimpleDateFormat("yyyy.MM.dd");
    SimpleDateFormat df1 = new SimpleDateFormat("yyyy.M.d");
    Date date = new Date();
    String dateStr = df.format(date);
    List list = new ArrayList();
    List list1 = new ArrayList();
    List showlist = new ArrayList();
    List showlist1 = new ArrayList();
    int pre= EpgUtility.checkString2int(String.valueOf(param.get("timeprev")),7)+1;
    int next=EpgUtility.checkString2int(String.valueOf(param.get("timenext")),7);
    //System.out.println("start-------------------------pre="+pre);
    //System.out.println("start-------------------------next="+next);
    String reldate = "";
    String reldate11 = df1.format(date);
    int topallpage = 0;
    int topcurpage = 0;
    int topfirstpage = 0;
    int toplastpage = 0;
   	if(pre%7==0)
   	{
   		topallpage=pre/7;
   		topcurpage=pre/7;
   		topfirstpage=pre/7;
    }else{
    	topallpage=pre/7+1;
    	topcurpage=pre/7+1;
    	topfirstpage=pre/7+1;
    }
    if(next%7==0){
    	topallpage+=next/7;
    	toplastpage=next/7;
    }else{
    	topallpage+=next/7+1;
    	toplastpage=next/7+1;
    }
    try
    {
        date = df.parse(dateStr);
        Calendar canlandar = Calendar.getInstance();
        canlandar.setTime(date);
        Calendar canlandar1 = Calendar.getInstance();
        canlandar1.setTime(date);
        for (int i = 0; i < next; i++)
        {
            canlandar1.add(canlandar1.DATE, +1);
            df.format(canlandar1 .getTime());
            list1.add(df.format(canlandar1 .getTime()));
            showlist1.add(df1.format(canlandar1 .getTime()));
        }
        for (int i = showlist1.size()-1; i >=0; i--)
        {
            showlist.add(showlist1.get(i));
            list.add(list1.get(i));
        }
        list.add(dateStr);
        showlist.add(df1.format(date));
        reldate = dateStr;
        for (int i = 0; i < pre-1; i++)
        {
            canlandar.add(canlandar.DATE, -1);
            df.format(canlandar .getTime());
            list.add(df.format(canlandar .getTime()));
            showlist.add(df1.format(canlandar .getTime()));
        }
    } catch (java.text.ParseException e)
    {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    String lastfocus = request.getParameter("lastfocus");
    String focusstr = null;
    Integer number1=0;
    String  reldate1="";
    if (lastfocus != "" && lastfocus != null) {
        String[] lastfocus1 = lastfocus.split("__");
        if (lastfocus1.length > 1) {
            focusstr = lastfocus1[0];
            reldate1 = lastfocus1[1];
            number1 = Integer.parseInt(lastfocus1[2]);
        }else{
           reldate1=reldate;   
        }
    }else{
       reldate1=reldate; 
    }
    Integer number=6-number1;
    System.out.println("==============focusstr================"+focusstr);

%>
<html>
  <head>
    <title></title>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <link rel="stylesheet" href="css/common.css" type="text/css" />
	<script language="javascript" type="">
var focustr="<%=focusstr%>";
var isfocus=false;
var curDate="<%=reldate1%>";
var curid = "";
var destpage1 = 1;
var pagecount1;
var dataArr1=[];
var dataIndex1 = 0;
var destpage2=1;
var pagecount2;
var dataArr2=[];
var dataIndex2 = 0;
var destpage3=1;
var pagecount3;
var dataArr3=[];
var dataIndex3 = 0;
var number = <%=number1%>;
var datearr=new Array();
var dateallarr=new Array();
var datearr1=new Array();
var dateallarr1=new Array();
var flagcontrl="false";
var focuscontrl="false";
var hidid ="";
var turnpage = 0;
var otherpage = 1;
var curMaxNo;
var favoriteTitle;
var curcolumnid="<%=columnId%>";
var curchannelid="<%=channelId%>";
var topmenucurrpage=<%=topcurpage%>;;
var topmenuallpage=<%=topallpage%>;
var controltopmenupage = 0;
var toplastpage = <%=toplastpage%>;
var topfirstpage = <%=topfirstpage%>;
var toplast = <%=next%7%>;
var topfirst = <%=pre%7%>;
var focuspage = 0;
window.onload=function init(){
	focuscontrl="false";
	var pagefirst = 1;
	var relDate = "<%=reldate1%>";
	$('img_a_1_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
	<%for(int i=showlist.size()-1,c=0;i>=0;i--,c++){%>
		dateallarr1[<%=c%>] = "<%=showlist.get(i)%>";
		datearr1[<%=c%>] = "<%=list.get(i)%>";
	<%}%>
	topmenupage(0);
	document.getElementById('sp_a_<%=number%>').style.color="red";
    if(<%=number%>==6){
      document.getElementById('sp_td').style.visibility = 'visible';
    }else{
      document.getElementById('sp_<%=number%>').style.visibility = 'visible';  
    }
	getthirdcol(pagefirst,relDate);
	getsecondcol(pagefirst,relDate);
	getfirstcol(pagefirst,relDate);
}
function topmenupage(page){
	if(topfirst==0){
		topfirst=7;
	}
	if(toplast==0){
		toplast=7;
	}
	for(var j=(<%=pre%>-page*7-1),m=6,y=0;j>=(<%=pre%>-(page+1)*7);j--,m--,y++){
		 dateallarr[m] = dateallarr1[j];
		 datearr[y] = datearr1[j];
	}
	focuspage = page;
	if(page==(topfirstpage-1)){
		for(var j=0;j<=6;j++){
			if(j<topfirst){
				if(dateallarr[6-j]=="<%=reldate11%>"){
					$('sp_a_'+(6-j)).innerText = "今天";
				}else{
					$('sp_a_'+(6-j)).innerText = dateallarr[6-j];
				}
			}else{
			    $('sp_a_'+(6-j)).innerText ='';
				$('sp_a_0').innerText = "";
			}

		}
	}else if(page==-toplastpage){
		for(var j=0;j<=6;j++){
			if(dateallarr[j]=="<%=reldate11%>"){
				$('sp_a_'+j).innerText = "今天";
			}else{
				if(j<toplast){
		 		    $('sp_a_'+j).innerText = dateallarr[j];
				}else{
					$('sp_a_'+j).innerText = "";
					$('sp_a_6').innerText = "";
				}
			}
		}
	}else{
		for(var j=0;j<dateallarr.length;j++){
			if(dateallarr[j]=="<%=reldate11%>"){
				$('sp_a_'+j).innerText = "今天";
			}else{
		 		$('sp_a_'+j).innerText = dateallarr[j];
			}
		}
	}
}
function $(id){
    return document.getElementById(id);
}
function getfirstcol(destpage,relDate){
	var requestUrl = "action/channel_onedetial_data.jsp?columnid=<%=columnId%>&channelid=<%=channelId%>&destpage="+destpage+"&starttiem=00:00&endtime=07:59&curdate="+relDate;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelcolumnlist);
}
function getsecondcol(destpage,relDate){
	var requestUrl = "action/channel_onedetial_data.jsp?columnid=<%=columnId%>&channelid=<%=channelId%>&destpage="+destpage+"&starttiem=08:00&endtime=15:59&curdate="+relDate;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelcolumnlistsec);
}
function getthirdcol(destpage,relDate){
	var requestUrl = "action/channel_onedetial_data.jsp?columnid=<%=columnId%>&channelid=<%=channelId%>&destpage="+destpage+"&starttiem=16:00&endtime=23:59&curdate="+relDate;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelcolumnlistthi);
}

function showchannelcolumnlist(){
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     destpage1 = eval(data.destpage)+0;
     pagecount1 = eval(data.pageCount)+0;
	 var mixno = data.mixno;
     var channelname = data.channelname;
	 if(channelname.length>10){
		channelname = channelname.substring(0,10);
	 }
     var columnArr = data.channelData;
     dataArr1 = data.channelData;
     var length = 0;
     if(eval(columnArr.length)+0>0){
		length = eval(columnArr.length)+0;
	 }
	 $('lefttopinfo').innerText ="回看  >  "+mixno+" "+channelname;
	 curMaxNo = mixno;
	 favoriteTitle = channelname;
     for(var i=0; i<9; i++){
		if(i<length){
			$('img_a_1_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
            $('divinfo1_'+i).innerText = "  "+columnArr[i].startime+"-"+columnArr[i].endtime+" "+columnArr[i].curProgramName.substr(0,11);
            $('img_a_1_'+i).href=columnArr[i].playUrl+"&leefocus=img_b_1_"+i+"__"+curDate+"__"+number;
            $('divinfo1_'+i).style.visibility = 'visible';
         }else{
            $('divinfo1_'+i).innerText ='';
            $('divinfo1_'+i).style.visibility = 'hidden';
			$('img_a_1_'+i).innerHTML = '';
         }
     }
	if(length>0){
		$('pic01a').style.visibility = 'visible';
		$('pic01b').style.visibility = 'visible';
		//$('backpic01').style.visibility = 'visible';
		flagcontrl = "true";
        if(focustr !="" && focustr!="null"  && focustr.indexOf("img_b_1") >-1){
            document.getElementById(focustr).focus();
            isfocus=true;
            focustr="";
        }else if(isfocus==false){
            if(focuscontrl=="true"){
                document.getElementById("img_b_1_8").focus();
            }else{
                document.getElementById("img_b_1_0").focus();
                $('img_1_0').style.visibility = 'visible';
            }
        }
		if(destpage1==1){
			$('pic01a').style.visibility = 'hidden';
		}
		if(destpage1==pagecount1){
			$('pic01b').style.visibility = 'hidden';
		}
	}else{
		$('pic01a').style.visibility = 'hidden';
		$('pic01b').style.visibility = 'hidden';
		//$('backpic01').style.visibility = 'hidden';
	}
}
function refleshLeft(flag){
    var startIndex = dataIndex2;
    var endIndex = dataIndex2+9;
    if(dataIndex1 > dataArr1.length){
        dataIndex1 --;
        return;
    }
    if(dataIndex1 < 0){
        dataIndex1 ++;
        return;
    }
    if(dataIndex1+9 > dataArr1.length){
//        endIndex = dataIndex2.length -1;
        return;
    }
    var tempArr = dataArr1.slice(dataIndex1,dataIndex1+9);
     for(var i=0; i<9; i++){
        $('img_a_1_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
        $('divinfo1_'+i).innerText = "  "+tempArr[i].startime+"-"+tempArr[i].endtime+" "+tempArr[i].curProgramName.substr(0,11);
        $('img_a_1_'+i).href=tempArr[i].playUrl+"&leefocus=img_b_1_"+i+"__"+curDate+"__"+number;
        $('divinfo1_'+i).style.visibility = 'visible';
     }
    if(flag == -1){
        document.getElementById("img_b_1_0").focus();
        $('img_1_0').style.visibility = 'visible';
    } else if(flag == 1){
        document.getElementById("img_b_1_8").focus();
    }
    if(dataIndex1 >0){
		$('pic01a').style.visibility = 'visible';
    }else{
        $('pic01a').style.visibility = 'hidden';
    }
    if(dataArr1.length < 9){
		$('pic01b').style.visibility = 'hidden';
    }else if(dataIndex1 == dataArr1.length - 9){
        $('pic01b').style.visibility = 'hidden';
    } else {
        $('pic01b').style.visibility = 'visible';
    }
}
function showchannelcolumnlistsec(){
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     destpage2 = eval(data.destpage)+0;
     pagecount2 = eval(data.pageCount)+0;
	 var mixno = data.mixno;
     var channelname = data.channelname;
	 if(channelname.length>10){
		channelname = channelname.substring(0,10);
	 }
     var columnArr = data.channelData;
     dataArr2 = data.channelData;
     var length = 0;
     if(eval(columnArr.length)+0>0){
		length = eval(columnArr.length)+0;
	 }
     for(var i=0; i<9; i++){
		if(i<length){
			$('img_a_2_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
            $('divinfo2_'+i).innerText = "  "+columnArr[i].startime+"-"+columnArr[i].endtime+" "+columnArr[i].curProgramName.substr(0,11);
            $('img_a_2_'+i).href=columnArr[i].playUrl+"&leefocus=img_b_2_"+i+"__"+curDate+"__"+number;
            $('divinfo2_'+i).style.visibility = 'visible';
         }else{
            $('divinfo2_'+i).innerText ='';
            $('divinfo2_'+i).style.visibility = 'hidden';
			$('img_a_2_'+i).innerHTML = '';
         }
     }
	if(length>0){
		$('pic02a').style.visibility = 'visible';
		$('pic02b').style.visibility = 'visible';
		//$('backpic02').style.visibility = 'visible';
		flagcontrl = "true";
        if(focustr !="" && focustr!="null" && focustr.indexOf("img_b_2") >-1){
            document.getElementById(focustr).focus();
            isfocus=true;
            focustr="";
        }else if(isfocus==false){
            if (focuscontrl == "true") {
                document.getElementById("img_b_2_8").focus();
            } else {
                document.getElementById("img_b_2_0").focus();
                $('img_2_0').style.visibility = 'visible';
            }
        }
		if(destpage2==1){
			$('pic02a').style.visibility = 'hidden';
		}
		if(destpage2==pagecount2){
			$('pic02b').style.visibility = 'hidden';
		}
	}else{
		$('pic02a').style.visibility = 'hidden';
		$('pic02b').style.visibility = 'hidden';
		//$('backpic02').style.visibility = 'hidden';
	}
}
function refleshMiddle(flag){
    var startIndex = dataIndex2;
    var endIndex = dataIndex2+9;
    if(dataIndex2 > dataArr2.length){
        dataIndex2 --;
        return;
    }
    if(dataIndex2 < 0){
        dataIndex2 ++;
        return;
    }
    if(dataIndex2+9 > dataArr2.length){
//        endIndex = dataIndex2.length -1;
        return;
    }
    var tempArr = dataArr2.slice(startIndex,endIndex);
     for(var i=0; i<9; i++){
        $('img_a_2_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
        $('divinfo2_'+i).innerText = "  "+tempArr[i].startime+"-"+tempArr[i].endtime+" "+tempArr[i].curProgramName.substr(0,11);
        $('img_a_2_'+i).href=tempArr[i].playUrl+"&leefocus=img_b_2_"+i+"__"+curDate+"__"+number;
        $('divinfo2_'+i).style.visibility = 'visible';
     }
    if(flag == -1){
        document.getElementById("img_b_2_0").focus();
        $('img_2_0').style.visibility = 'visible';
    } else if(flag == 1){
        document.getElementById("img_b_2_8").focus();
    } 
    if(dataIndex2 >0){
		$('pic02a').style.visibility = 'visible';
    }else{
        $('pic02a').style.visibility = 'hidden';
    }
    if(dataArr2.length < 9){
		$('pic02b').style.visibility = 'hidden';
    }else if(dataIndex2 == dataArr2.length - 9){
        $('pic02b').style.visibility = 'hidden';
    } else {
        $('pic02b').style.visibility = 'visible';
    }
}
function showchannelcolumnlistthi(){
     var results = this.req.responseText;
     var data = eval("(" + results + ")");
     destpage3 = eval(data.destpage)+0;
     pagecount3 = eval(data.pageCount)+0;
	 var mixno = data.mixno;
     var channelname = data.channelname;
	 if(channelname.length>10){
		channelname = channelname.substring(0,10);
	 }
     var columnArr = data.channelData;
     dataArr3 = data.channelData;
     var length = 0;
     if(eval(columnArr.length)+0>0){
		length = eval(columnArr.length)+0;
	 }
     for(var i=0; i<9; i++){
		if(i<length){
			$('img_a_3_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
            $('divinfo3_'+i).innerText = "  "+columnArr[i].startime+"-"+columnArr[i].endtime+" "+columnArr[i].curProgramName.substr(0,11);
            $('img_a_3_'+i).href=columnArr[i].playUrl+"&leefocus=img_b_3_"+i+"__"+curDate+"__"+number;
            $('divinfo3_'+i).style.visibility = 'visible';
         }else{
            $('divinfo3_'+i).innerText ='';
            $('divinfo3_'+i).style.visibility = 'hidden';
			$('img_a_3_'+i).innerHTML = '';
         }
     }
	if(length>0){
		 $('pic03a').style.visibility = 'visible';
		 $('pic03b').style.visibility = 'visible';
		 //$('backpic03').style.visibility = 'visible';
		 flagcontrl = "true";
		if(focustr !="" && focustr!="null"  && focustr.indexOf("img_b_3") >-1){
            document.getElementById(focustr).focus();
            isfocus=true;
            focustr="";
        }else if(isfocus==false){
            if (focuscontrl == "true") {
                document.getElementById("img_b_3_8").focus();
            } else {
                document.getElementById("img_b_3_0").focus();
                $('img_3_0').style.visibility = 'visible';
            }
        }
		if(destpage3==1){
			$('pic03a').style.visibility = 'hidden';
		}
		if(destpage3==pagecount3){
			$('pic03b').style.visibility = 'hidden';
		}
	}else{
		$('pic03a').style.visibility = 'hidden';
		$('pic03b').style.visibility = 'hidden';
		//$('backpic03').style.visibility = 'hidden';
	}
}
function refleshRight(flag){
    var startIndex = dataIndex3;
    var endIndex = dataIndex3+9;
    if(dataIndex3 > dataArr3.length){
        dataIndex3 --;
        return;
    }
    if(dataIndex3 < 0){
        dataIndex3 ++;
        return;
    }
    if(dataIndex3+9 > dataArr3.length){
//        endIndex = dataIndex2.length -1;
        return;
    }
    var tempArr = dataArr3.slice(dataIndex3,dataIndex3+9);
     for(var i=0; i<9; i++){
        $('img_a_3_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
        $('divinfo3_'+i).innerText = "  "+tempArr[i].startime+"-"+tempArr[i].endtime+" "+tempArr[i].curProgramName.substr(0,11);
        $('img_a_3_'+i).href=tempArr[i].playUrl+"&leefocus=img_b_3_"+i+"__"+curDate+"__"+number;
        $('divinfo3_'+i).style.visibility = 'visible';
     }
    if(flag == -1){
        document.getElementById("img_b_3_0").focus();
        $('img_3_0').style.visibility = 'visible';
    } else if(flag == 1){
        document.getElementById("img_b_3_8").focus();
    }
    if(dataIndex3 >0){
		$('pic03a').style.visibility = 'visible';
    }else{
        $('pic03a').style.visibility = 'hidden';
    }
    if(dataArr3.length < 9){
		$('pic03b').style.visibility = 'hidden';
    }else if(dataIndex3 == dataArr3.length - 9){
        $('pic03b').style.visibility = 'hidden';
    } else {
        $('pic03b').style.visibility = 'visible';
    }
}
function changemenu(id,flag){
//	alert('id------------reldate------->'+"<%=reldate%>");
	//alert('id------------curDate------->'+curDate);
	if(flag==1){
		 if(curDate=="<%=reldate%>"){
			$('sp_td').style.visibility = 'visible';
		 }else{
		 	$('sp_'+id).style.visibility = 'visible';
			$('sp_td').style.visibility = 'hidden';
		 }
      	 document.getElementById('sp_a_'+id).style.color="red";
    }else{
		 $('sp_'+id).style.visibility = 'hidden';
         document.getElementById('sp_a_'+id).style.color="white";
    }
}
function changeImg(id,flag){
	 curid = eval(id.substring(4,5))+0;
	 hidid = id;
	 turnpage = eval(id.substring(6,7))+0;
	 if(flag==1&&flagcontrl=="true"){
      	 $(id).style.visibility = 'visible';
     }else{
         $(id).style.visibility = 'hidden';
     }
}
function doRed() {
	//alert('----------------------->curcolumnid='+curcolumnid);
	//alert('----------------------->curMaxNo='+curMaxNo);
	//alert('----------------------->curchannelid='+curchannelid);
	//alert('----------------------->favoriteTitle='+favoriteTitle);
    var requestUrl = "action/channel_favorite_add.jsp?SubjectID=" + curcolumnid + "&ContentID=" + curMaxNo + "&FavoriteTitle=" + encodeURI(encodeURI(favoriteTitle)) + "&channelid=" + curchannelid;
    var loaderSearch = new net.ContentLoader(requestUrl, showaddFav);
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
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    } else if (dellflag == 2) {
         $("text").innerText = "节目已收藏";
         $("msg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    } else if(dellflag==3){
         $("text").innerText = "收藏已达上线 ";
         $("msg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    }else {
         $("text").innerText = "收藏失败";
         $("msg").style.visibility = "visible";
         clearTimeout(timer);
         timer = setTimeout(closeMessage, 2000);
    }
}
function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
}
function goNext(){
	//alert('--------------------->curid='+curid);
	focuscontrl="false";
	curDate = datearr[eval(number)+0];
	if(curid==1){
		if(destpage1<pagecount1){
//			var pagecur= destpage1+1;
//			getfirstcol(pagecur,curDate);
            destpage1++;
            dataIndex1 = (destpage1-1)*9;
            /*
            * 不足一页。补全
            * */
            if(dataIndex1 + 9>dataArr1.length){
                var bet1 = dataIndex1 + 9 - dataArr1.length;
                dataIndex1 = dataIndex1 - bet1;
            }
            refleshLeft(-1);
		}
	}else if(curid==2){
      //  alert(">>>>>>>>>>mark>>>>>destpage2>>>>" + destpage2);
       // alert(">>>>>>>>>>mark>>>>>destpage2>>>>" + destpage2);
        //alert(">>>>>>>>>>mark>>>>>pagecount2>>>>" + pagecount2);
		if(destpage2<pagecount2){
//			var pagecur= destpage2+1;
//			getsecondcol(pagecur,curDate);
            destpage2++;
            dataIndex2 = (destpage2-1)*9;
            /*
            * 不足一页。补全
            * */
            if(dataIndex2 + 9>dataArr2.length){
                var bet2 = dataIndex2 + 9 - dataArr2.length;
                dataIndex2 = dataIndex2 - bet2;
            }
            refleshMiddle(-1);
           // alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
            //alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
            //alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
		}
	}else if(curid==3){
		if(destpage3<pagecount3){
//			var pagecur= destpage3+1;
//			getthirdcol(pagecur,curDate);
            destpage3++;
            dataIndex3 = (destpage3-1)*9;
            /*
            * 不足一页。补全
            * */
            if(dataIndex3 + 9>dataArr3.length){
                var bet3 = dataIndex3 + 9 - dataArr3.length;
                dataIndex3 = dataIndex3 - bet3;
            }
            refleshRight(-1);
		}
	}
}
function goLast(){
	//alert('--------------------->curid='+curid);
	curDate = datearr[eval(number)+0];
	if(curid==1){
        dataIndex1 = dataIndex1 - 9;
		if(destpage1>1){
//			var pagecur= destpage1-1;
//			getfirstcol(pagecur,curDate);
            destpage1--;
		}
        if(dataIndex1 < 0)dataIndex1 = 0;
        refleshLeft(1);
    }else if(curid==2){
        dataIndex2 = dataIndex2 - 9;
		if(destpage2>1){
//			var pagecur= destpage1-1;
//			getfirstcol(pagecur,curDate);
            destpage2--;
		}
        if(dataIndex2 < 0)dataIndex2 = 0;
        refleshMiddle(1);
	}else if(curid==3){
        dataIndex3 = dataIndex3 - 9;
		if(destpage3>1){
//			var pagecur= destpage1-1;
//			getfirstcol(pagecur,curDate);
            destpage3--;
		}
        if(dataIndex3 < 0)dataIndex3 = 0;
        refleshRight(1);
	}
}
function goForword(){
	if(number-1>=0){
		//alert("--------------------->goForword="+goForword);
		//alert("-------------------->focuspage="+focuspage);
		//alert("-------------------->toplastpage="+toplastpage);
		//alert("------------------->toplast="+toplast);
		if(focuspage==-toplastpage){
			if(number-1>(6-toplast)){
				number--;
				curDate = datearr[eval(number)+0];
				changemenu(6-number,1);
				changemenu(6-number-1,0);
				if(bottomMenuTimer){
        			window.clearTimeout(bottomMenuTimer)
    			}
				bottomMenuTimer = window.setTimeout('controlTime();',600);
			}
		}else{
			number--;
			curDate = datearr[eval(number)+0];
			changemenu(6-number,1);
			changemenu(6-number-1,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
			bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}else if(number-1<0){
		//curDate = datearr[6];
		//number=6;
		if(topmenucurrpage+1<=topmenuallpage){
			topmenucurrpage++;
			controltopmenupage--;
			topmenupage(controltopmenupage);
			number=6;
			curDate = datearr[number];
			changemenu(0,1);
			changemenu(6,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}
}
function goRewind(){
	//alert("-------------------------->goRewind"+topmenucurrpage);
	if(number+1<=6){
		if(focuspage==(topfirstpage-1)){
			if(number+1<topfirst){
				number++;
				curDate = datearr[eval(number)+0];
				changemenu(6-number,1);
				changemenu(6-number+1,0);
				if(bottomMenuTimer){
        			window.clearTimeout(bottomMenuTimer)
    			}
    			bottomMenuTimer = window.setTimeout('controlTime();',600);
			}
		}else{
			number++;
			curDate = datearr[eval(number)+0];
			changemenu(6-number,1);
			changemenu(6-number+1,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}else if(number+1==7){
		//curDate = datearr[0];
		//number=0;
		//if(bottomMenuTimer){
        //	window.clearTimeout(bottomMenuTimer)
    	//}
    	//bottomMenuTimer = window.setTimeout('controlTime();',600);
		if(topmenucurrpage-1>0){
			topmenucurrpage--;
			controltopmenupage++;
			topmenupage(controltopmenupage);
			number=0;
			curDate = datearr[number];
			changemenu(6,1);
			changemenu(0,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}
}

function controlTime(){
	$(hidid).style.visibility = 'hidden';
	focuscontrl="false";
	flagcontrl = "false";
    isfocus=false;
	getthirdcol(otherpage,curDate);
	getsecondcol(otherpage,curDate);
	getfirstcol(otherpage,curDate);
}
function doKeyPress(evt){
    var keycode = evt.which;
    if (keycode == <%=STBKeysNew.onKeyLeft%>){
		return true;
    }else if (keycode == <%=STBKeysNew.onKeyRight%>){
		return true;
    }else if (keycode == <%=STBKeysNew.onKeyOK%>){
		return true;
    }else if (keycode == <%=STBKeysNew.onKeyUp%>){
		if(turnpage==0){
			 focuscontrl = "true";
//			 goLast();
            if(curid == 1){
                if(dataIndex1 > 0){
                    dataIndex1--;
                    refleshLeft(-1);
                }
            } else if(curid == 2){
                if(dataIndex2 > 0){
                    dataIndex2--;
                    refleshMiddle(-1);
                }
            } else if(curid == 3){
                if(dataIndex3 > 0){
                    dataIndex3--;
                    refleshRight(-1);
                }
            }
		}else{
			return true;
		}
    }else if (keycode == <%=STBKeysNew.onKeyDown%>){
		if(turnpage==8){
//			goNext();
            if(curid == 1){
                if(dataIndex1 <dataArr1.length - 1){
                    dataIndex1++;
                    refleshLeft(1);
                }
            } else if(curid == 2){
                if(dataIndex2 <dataArr2.length - 1){
                    dataIndex2++;
                    refleshMiddle(1);
                }
            } else if(curid == 3){
                if(dataIndex3 <dataArr3.length - 1){
                    dataIndex3++;
                    refleshRight(1);
                }
            }
		}else{
			return true;
		}
    }else if (keycode == <%=STBKeysNew.remotePlayNext%>){
        goNext();
    }else if (keycode == <%=STBKeysNew.remotePlayLast%>){
        goLast();
    }else if (keycode == <%=STBKeysNew.remoteFastForword%>){
        goForword();
    }else if (keycode == <%=STBKeysNew.remoteFastRewind%>){
		goRewind();
    }else if (keycode == <%=STBKeysNew.onKeyBlue%>){
		document.location = "vod_search.jsp?columnpath=";
    }else if (keycode == <%=STBKeysNew.onKeyRed%>){
		doRed();
    }else if(keycode == 0x0110 ||keycode == 36 ){
        //Authentication.CTCSetConfig("KeyValue","0x110");
        top.mainWin.document.location = "portal.jsp";
    }else if (keycode == <%=STBKeysNew.remoteBack%>){
        top.mainWin.document.location = "back.jsp";
    }else{
        commonKeyPress(evt);
    }
    return false;
}

document.onkeypress = doKeyPress;
</script>
  </head>

  <body bgcolor="transparent">
  <div id="div0" style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
   <img src="images/vod/btv_bg.png" height="720" width="1280" alt="" border="0">
</div>
   <div  style="position:absolute; width:1280px; height:65px; left: 0px; top: 0px; color:black;font-size:26px;"></div>
   <div  style="position:absolute; width:1236px; height:65px; left: 44px; top: 80px; color:black;font-size:26px;">
       <img src="images/tvod/btv-replay-list.png" width="1192" height="54" alt="">
   </div>
   <%--<div  style="position:absolute;width:24; height:35px; left: 40px; top: 25px;">--%>
       <%--<img src="images/tvod/btv-replay-ico.png" alt="" width="60" height="30" border="0" />--%>
   <%--</div>--%>
   <%--<div  id="lefttopinfo" style="position:absolute;width:500; height:26px; left: 120px; top: 25px; 0px;font-size:24px;color: white"></div>--%>
    <div class="topImg" style="font-size:26px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
        <div style="background:url('images/tvod/btv-replay-ico.png'); left:13; top:12px; width:41px; height:30px; position:absolute; ">
        </div>
        <div id="lefttopinfo" align="left" style="font-size:26px;line-height:50px; left:62; top:4px; width:420px; height:0px; position:absolute; ">

        </div>
    </div>
   <div style="position:absolute;width:1234px; height:55px; left: 23px; top: 80px; color:white; font-size:26px;">
  <%for(int j=0;j<7;j++){
  		int topdaypos = 49+j*170;
  		if(j==6){
  %>
  		<div id="sp_a_<%=j %>"  style="position:absolute; text-align:left; width:167px; height:30px; left: <%=topdaypos%>px; top: 12px; color:white; font-size:24px;"></div>
	  	<div id="sp_<%=j %>"  style="visibility:hidden; position:absolute; text-align:left; width:177px; height:30px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="110" height="2"/> </div>
	 	<div id="sp_td"  style="visibility:hidden; position:absolute; text-align:left; width:177px; height:30px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="50" height="2"/> </div>
	  <%}else{ %>
	   <div id="sp_a_<%=j %>"  style="position:absolute; text-align:left; width:167px; height:30px; left: <%=topdaypos%>px; top: 12px; color:white; font-size:24px;"></div>
  		<div id="sp_<%=j %>" style="visibility:hidden; position:absolute; text-align:left; width:177px; height:30px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="110" height="2"/> </div>
  <%} %>
   <%} %>
   </div>


   <div id="backpic01" style="position:absolute; height: 480px; width:382px; text-align: left; left: 43px; top: 139px; font-size:22px;">
   		<img  src="images/tvod/btv-replay-bg01.png" alt="" height="480px" width="382px"/>
   </div>
   <div id="backpic02" style="position:absolute; height: 480px; width:382px; text-align: left; left: 449px; top: 139px; font-size:22px;">
   		<img  src="images/tvod/btv-replay-bg01.png" alt="" height="480px" width="382px"/>
   </div>
   <div id="backpic03" style="position:absolute; height: 480px; width:382px; text-align: left; left: 855px; top: 139px; font-size:22px;">
   		<img  src="images/tvod/btv-replay-bg01.png" alt="" height="480px" width="382px"/>
   </div>

  		<div id="pic01a" style="position:absolute; height: 24px;color: white;text-align: center; left: 246px; top: 149px; font-size:22px;">
			<img src="images/vod/btv_up.png" alt="" width="20" height="10" border="0" >
		</div>

		<div id="img_1_0" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white; text-align: left; left: 43px; top: 164px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:220; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_0" id="img_a_1_0" name="img_b_1_0" onfocus="changeImg('img_1_0',1);" onblur="changeImg('img_1_0',0);">
		       </a>
		</div>
		<div id="img_1_1" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 212px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:230; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_1" id="img_a_1_1" name="img_b_1_1" onfocus="changeImg('img_1_1',1);" onblur="changeImg('img_1_1',0);">
		       </a>
		</div>
		<div id="img_1_2" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 260px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:240; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_2" id="img_a_1_2" name="img_b_1_2" onfocus="changeImg('img_1_2',1);" onblur="changeImg('img_1_2',0);">
		       </a>
		</div>
		<div id="img_1_3" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 308px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:250; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_3" id="img_a_1_3" name="img_b_1_3" onfocus="changeImg('img_1_3',1);" onblur="changeImg('img_1_3',0);">
		       </a>
		</div>
		<div id="img_1_4" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 356px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:260; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_4" id="img_a_1_4" name="img_b_1_4" onfocus="changeImg('img_1_4',1);" onblur="changeImg('img_1_4',0);">
		       </a>
		</div>
		<div id="img_1_5" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 404px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:270; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_5" id="img_a_1_5" name="img_b_1_5" onfocus="changeImg('img_1_5',1);" onblur="changeImg('img_1_5',0);">
		       </a>
		</div>
		<div id="img_1_6" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 452px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:280; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_6" id="img_a_1_6" name="img_b_1_6" onfocus="changeImg('img_1_6',1);" onblur="changeImg('img_1_6',0);">
		       </a>
		</div>
		<div id="img_1_7" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 500px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:290; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_7" id="img_a_1_7" name="img_b_1_7" onfocus="changeImg('img_1_7',1);" onblur="changeImg('img_1_7',0);">
		       </a>
		</div>
		<div id="img_1_8" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 43px; top: 548px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div style=" position:absolute; left:100px;top:300; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_1_8" id="img_a_1_8" name="img_b_1_8" onfocus="changeImg('img_1_8',1);" onblur="changeImg('img_1_8',0);">
		       </a>
		</div>
		<div id="divinfo1_0" style="position:absolute; height: 48px; width:382px; color: white; text-align: left; left:53; left: 53px; top: 174px; font-size:22px;">
		</div>
		<div id="divinfo1_1" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 222px; font-size:22px;">
		</div>
		<div id="divinfo1_2" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 270px; font-size:22px;">
		</div>
		<div id="divinfo1_3" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 318px; font-size:22px;">
		</div>
		<div id="divinfo1_4" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 366px; font-size:22px;">
		</div>
		<div id="divinfo1_5" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 414px; font-size:22px;">
		</div>
		<div id="divinfo1_6" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 462px; font-size:22px;">
		</div>
		<div id="divinfo1_7" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 510px; font-size:22px;">
		</div>
		<div id="divinfo1_8" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 53px; top: 558px; font-size:22px;">
		</div>

		<div id="pic01b" style="position:absolute; height: 24px;color: white;text-align: center; left: 246px; top: 600px; font-size:22px;">
			<img src="images/vod/btv_down.png" alt="" width="20" height="10" border="0" >
		</div>





		<div id="pic02a" style="position:absolute; height: 24px;color: white;text-align: center; left: 652px; top: 149px; font-size:22px;">
			<img src="images/vod/btv_up.png" alt="" width="20" height="10" border="0" >
		</div>

		<div id="img_2_0" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white; text-align: left; left: 449px; top: 164px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_1" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 212px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_2" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 260px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_3" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 308px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_4" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 356px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_5" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 404px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_6" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 452px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_7" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 500px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_2_8" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 449px; top: 548px; font-size:22px;">
			    <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
       <div id="divinfo2_0" style="position:absolute; height: 48px; width:382px; color: white; text-align: left; left: 459px; top: 174px; font-size:22px;">
		</div>
		<div id="divinfo2_1" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 222px; font-size:22px;">
		</div>
		<div id="divinfo2_2" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 270px; font-size:22px;">
		</div>
		<div id="divinfo2_3" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 318px; font-size:22px;">
		</div>
		<div id="divinfo2_4" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 366px; font-size:22px;">
		</div>
		<div id="divinfo2_5" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 414px; font-size:22px;">
		</div>
		<div id="divinfo2_6" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 462px; font-size:22px;">
		</div>
		<div id="divinfo2_7" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 510px; font-size:22px;">
		</div>
		<div id="divinfo2_8" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 459px; top: 558px; font-size:22px;">
		</div>

		<div style=" position:absolute; left:200px;top:220; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_0" id="img_a_2_0"  name="img_b_2_0" onfocus="changeImg('img_2_0',1);" onblur="changeImg('img_2_0',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:230; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_1" id="img_a_2_1" name="img_b_2_1" onfocus="changeImg('img_2_1',1);" onblur="changeImg('img_2_1',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:240; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_2" id="img_a_2_2" name="img_b_2_2" onfocus="changeImg('img_2_2',1);" onblur="changeImg('img_2_2',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:250; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_3" id="img_a_2_3" name="img_b_2_3" onfocus="changeImg('img_2_3',1);" onblur="changeImg('img_2_3',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:260; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_4" id="img_a_2_4" name="img_b_2_4" onfocus="changeImg('img_2_4',1);" onblur="changeImg('img_2_4',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:270; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_5" id="img_a_2_5" name="img_b_2_5" onfocus="changeImg('img_2_5',1);" onblur="changeImg('img_2_5',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:280; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_6" id="img_a_2_6" name="img_b_2_6" onfocus="changeImg('img_2_6',1);" onblur="changeImg('img_2_6',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:290; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_7" id="img_a_2_7" name="img_b_2_7" onfocus="changeImg('img_2_7',1);" onblur="changeImg('img_2_7',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:200px;top:300; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_2_8" id="img_a_2_8" name="img_b_2_8" onfocus="changeImg('img_2_8',1);" onblur="changeImg('img_2_8',0);">
		       </a>
		</div>
		<div id="pic02b" style="position:absolute; height: 24px;color: white;text-align: center; left: 652px; top: 600px; font-size:22px;">
			<img src="images/vod/btv_down.png" alt="" width="20" height="10" border="0" >
		</div>




		<div id="pic03a"  style="position:absolute; height: 24px;color: white;text-align: center; left: 1058px; top: 149px; font-size:22px;">
			<img src="images/vod/btv_up.png" alt="" width="20" height="10" border="0" >
		</div>

		<div style=" position:absolute; left:300px;top:220; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_0" id="img_a_3_0" name="img_b_3_0" onfocus="changeImg('img_3_0',1);" onblur="changeImg('img_3_0',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:230; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_1" id="img_a_3_1" name="img_b_3_1" onfocus="changeImg('img_3_1',1);" onblur="changeImg('img_3_1',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:240; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_2" id="img_a_3_2" name="img_b_3_2" onfocus="changeImg('img_3_2',1);" onblur="changeImg('img_3_2',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:250; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_3" id="img_a_3_3" name="img_b_3_3" onfocus="changeImg('img_3_3',1);" onblur="changeImg('img_3_3',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:260; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_4" id="img_a_3_4" name="img_b_3_4" onfocus="changeImg('img_3_4',1);" onblur="changeImg('img_3_4',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:270; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_5" id="img_a_3_5" name="img_b_3_5" onfocus="changeImg('img_3_5',1);" onblur="changeImg('img_3_5',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:280; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_6" id="img_a_3_6" name="img_b_3_6" onfocus="changeImg('img_3_6',1);" onblur="changeImg('img_3_6',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:290; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_7" id="img_a_3_7" name="img_b_3_7" onfocus="changeImg('img_3_7',1);" onblur="changeImg('img_3_7',0);">
		       </a>
		</div>
		<div style=" position:absolute; left:300px;top:300; width:24px; height:14px;">
		       <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_3_8" id="img_a_3_8" name="img_b_3_8" onfocus="changeImg('img_3_8',1);" onblur="changeImg('img_3_8',0);">
		       </a>
		</div>
        <div id="img_3_0" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white; text-align: left; left: 855px; top: 164px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_1" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 212px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_2" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 260px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_3" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 308px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_4" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 356px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_5" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 404px; font-size:22px;">
			   		<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_6" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 452px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_7" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 500px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
		<div id="img_3_8" style="visibility:hidden; position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 855px; top: 548px; font-size:22px;">
			    	<img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
		</div>
          r<div id="divinfo3_0" style="position:absolute; height: 48px; width:382px; color: white; text-align: left; left: 865px; top: 174px; font-size:22px;">
          </div>
          <div id="divinfo3_1" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 222px; font-size:22px;">
          </div>
          <div id="divinfo3_2" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 270px; font-size:22px;">
          </div>
          <div id="divinfo3_3" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 318px; font-size:22px;">
          </div>
          <div id="divinfo3_4" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 366px; font-size:22px;">
          </div>
          <div id="divinfo3_5" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 414px; font-size:22px;">
          </div>
          <div id="divinfo3_6" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 462px; font-size:22px;">
          </div>
          <div id="divinfo3_7" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 510px; font-size:22px;">
          </div>
          <div id="divinfo3_8" style="position:absolute; height: 48px; width:382px; color: white;text-align: left; left: 865px; top: 558px; font-size:22px;">
          </div>

		<div id="pic03b" style="position:absolute; height: 24px;color: white;text-align: center; left: 1058px; top: 600px; font-size:22px;">
			<img src="images/vod/btv_down.png" alt="" width="20" height="10" border="0" >
		</div>
        <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
 		</div>
       <div style="position:absolute;width:1250px; height:40px; left: 0px; top: 640px; color:black;font-size:22px;">
   			<div  style="position:absolute;width:60px; height:32px; left: 200px; top: -1px; color:black;font-size:22px;">
		 		<img src="images/tvod/btv-btn-page_left.png" alt="" style="position:absolute;left:0;top:0px;">
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 260px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;前一天
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 380px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/tvod/btv_page_right.png" alt="" style="position:absolute;left:0px;top:0px;">
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 440px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;后一天
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 560px; top: -1px; color:black;font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 620px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;上一页
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 740px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 800px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;下一页
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 920px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 980px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;收藏
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 1100px; top: -2px; color:black;font-size:22px;">
		 		<img src="images/vod/btv_Search.png" alt="" width=60px height="32" border="0" >
		 	</div>
		 	<div  style="position:absolute;width:90px; height:30px; left: 1160px; top: 0px; color:white; font-size:22px;">
		 		&nbsp;搜索
		 	</div>
		</div>

<div style="left:443px; top:229px;width:568px;height:215px; position:absolute;z-index:2000">
        <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
            <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
                <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
            </div>
            <div id="text" style="left:0px;top:100px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">

            </div>
            <div style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
                 2秒自动关闭
            </div>
        </div>
    </div>
<%@ include file="inc/goback.jsp" %>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/time.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
  </body>
</html>
