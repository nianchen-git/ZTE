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

<%
    String isnewopen = request.getParameter("isnewopen");
//        System.out.println("SSSSSSSSSSSSSSSSSSSSisnewopen="+isnewopen);
    if((isnewopen!=null && isnewopen.equals("1")) || (isnewopen!=null && isnewopen.equals("2"))){
        System.out.println("SSSSSSSSSSSSSSSSSSSSSSmeiyouyazhan!!!!");
%>
<%
}else{
%>
<meta http-equiv="pragma"   content="no-cache" />  
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate" />  
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT" />
<epg:PageController name="channel_onedetail_tvod.jsp"/>
<%
    }
%>

<%
	String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String columnId = request.getParameter(EpgConstants.COLUMN_ID);
    String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
    String mixno = request.getParameter("mixno");
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
    String  datefocuspage= "0";
    if (lastfocus != "" && lastfocus != null) {
        String[] lastfocus1 = lastfocus.split("__");
        if (lastfocus1.length > 1) {
            focusstr = lastfocus1[0];
            reldate1 = lastfocus1[1];
            number1 = Integer.parseInt(lastfocus1[2]);
            datefocuspage = lastfocus1[3];
        }else{
           reldate1=reldate;   
        }
    }else{
       reldate1=reldate; 
    }
    Integer number=6-number1;
    System.out.println("=========focusstr================"+focusstr+"  number = "+number +"  number1 = "+number1);

%>
<html>
  <head>
    <title></title>
    <%
        String isAjaxCache = String.valueOf(param.get("isAjaxCache"));
        if(isAjaxCache!=null && isAjaxCache.equals("1")){
    %>
    <script type="text/javascript" src="js/contentloader.js"></script>
    <%
    }else{
    %>
    <script type="text/javascript" src="js/contentloader_nocache.js"></script>
    <%
        }
    %>
    <link rel="stylesheet" href="css/common.css" type="text/css" />
	<script type="text/javascript" src="js/advertisement_manager.js"></script>
	<script language="javascript" type="">

var isfocus=false;
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
var datearr=new Array();
var dateallarr=new Array();
var datearr1=new Array();
var dateallarr1=new Array();
var flagcontrl="false";
var focuscontrl="false";
var hidid ="";
var curMaxNo;
var favoriteTitle;
//*************************获取当前的年月日和时分
var now_time=new Date();
var now_year=now_time.getFullYear();
var now_mon=now_time.getMonth()+1;
var now_day=now_time.getDate();
if(now_mon<10)
{
now_mon="0"+now_mon;
}
if(now_day<10)
{
now_day="0"+now_day;
}
var now_year_mon_date=now_year+"."+now_mon+"."+now_day;
var current_time;
var current_hours;
var current_minutes;
var cur_hour_min;

function get_time()
{
	var now_tim=new Date();
	current_hours=now_tim.getHours();
	current_minutes=now_tim.getMinutes();
	current_time=current_hours*3600+current_minutes*60;
	if(current_hours<10)
	{
	current_hours="0"+current_hours;
	}
	if(current_minutes<10)
	{
	current_minutes="0"+current_minutes;
	}
	cur_hour_min=current_hours+":"+current_minutes;	
	window.setTimeout("get_time()",120000);
}
//----------------nirui---------
var topmenucurrpage=<%=topcurpage%>;
var topmenuallpage=1;//<%=topallpage%>;
var toplastpage = <%=toplastpage%>;
var topfirstpage = 0;//<%=topfirstpage%>;
var toplast = 7;//<%=next%7%>;
var topfirst = 0;//<%=pre%7%>;
var number_java = <%=number%>;
var pre_java = <%=pre%>;
var reldate11_java = "<%=reldate11%>";
var curcolumnid="<%=columnId%>";
var curchannelid="<%=channelId%>";
var reldate = "<%=reldate%>";
var focustr="<%=focusstr%>";
var curDate="<%=reldate1%>";
var number = <%=number1%>;
var controltopmenupage = 0;
var focuspage = <%=datefocuspage%>;
var turnpage = 0;
var otherpage = 1;

var bottomMenuTimer = null;
var _window = window;
if(window.opener){
    _window = window.opener;
}

//iPanel.defaultalinkBgColor = "#FCFF05";//79FD21"; //设置文字链接焦点颜色
//iPanel.defaultFocusColor = "#FCFF05"; //设置图片链接焦点颜色
//iPanel.focusWidth = "4"; //焦点框宽度
function hid_words(index)
{
$('pic0'+index+'a').style.visibility='hidden';
$('pic0'+index+'b').style.visibility='hidden';
	for(i=0;i<9;i++)
	{
		$('divinfo'+index+'_'+i).innerHTML="";
		$('divinfo1'+index+'_'+i).innerHTML="";
		$('img_a_'+index+'_'+i).href="";	
	}

}
<%for(int i=showlist.size()-1,c=0;i>=0;i--,c++){%>
dateallarr1[<%=c%>] = "<%=showlist.get(i)%>";
datearr1[<%=c%>] = "<%=list.get(i)%>";
<%}%>
function init(){
	get_time();
 if(parseInt(focuspage) != 0 && !isNaN(focuspage) ) {   //todo gabe
        controltopmenupage = focuspage;
        if(focuspage < 0){
            topmenucurrpage = topmenuallpage;
        }else if(focuspage > 0){
            topmenucurrpage = 1;
        }
    }

    dataIndex1 =0;
    dataIndex2 =0;
    dataIndex3 =0;
	focuscontrl="false";
	var pagefirst = 1;
	var relDate = curDate;
	$('img_a_1_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';

	topmenupage(focuspage);
    $('sp_a_'+curtopmenuIndex).style.color="white";
    $('sp_'+curtopmenuIndex).style.visibility = 'hidden';
    $('sp_a_'+number_java).style.color="red";
    if(number_java==6){
        $('sp_td').style.visibility = 'visible';
    }else{
        $('sp_'+number_java).style.visibility = 'visible';
    }


    isgetfocus = 0;
//    getthirdcol(pagefirst,relDate);
//    getsecondcol(pagefirst,relDate);
//    getfirstcol(pagefirst,relDate);
//
//    window.setTimeout(function(){
//        getsecondcol(pagefirst,relDate);
//    },50);
//
//    window.setTimeout(function(){
//        getthirdcol(pagefirst,relDate);
//    },100);
//    isInit = true ;
    get3AjaxData(pagefirst,relDate);
}
function topmenupage(page){//刷新日期的数据
	if(topfirst==0){
		topfirst=7;
	}
	if(toplast==0){
		toplast=7;
	}
	// for(var j=(pre_java-page*7-1),m=6,y=0;j>=(pre_java-(page+1)*7);j--,m--,y++){
		 // dateallarr[m] = dateallarr1[j];
		 // datearr[y] = datearr1[j];
	// }
    for (var j = 7, m = 6, y = 0; m >= 0; j--, m--, y++) {//xiaojun
        dateallarr[m] = dateallarr1[j];
        datearr[y] = datearr1[j];
    }
	focuspage = page;
	//if(page==(topfirstpage-1)){
		for(var j=0;j<=6;j++){
			//if(j<topfirst){
				if(dateallarr[6-j]==reldate11_java && focuspage === 0){
					$('sp_a_'+(6-j)).innerText = "今天";
				}else{
                    dateallarr[6-j] = (dateallarr[6-j] == undefined )?"":dateallarr[6-j];
					$('sp_a_'+(6-j)).innerText = dateallarr[6-j];
				}
			// }else{
			    // $('sp_a_'+(6-j)).innerText ='';
				// $('sp_a_0').innerText = "";
			// }

		}
	// }else if(page==-toplastpage){
		// for(var j=0;j<=6;j++){
			// if(dateallarr[j]==reldate11_java){
				// $('sp_a_'+j).innerText = "今天";
			// }else{
				// if(j<toplast){
		 		    // $('sp_a_'+j).innerText = dateallarr[j];
				// }else{
					// $('sp_a_'+j).innerText = "";
					// $('sp_a_6').innerText = "";
				// }
			// }
		// }
	// }else{
		// for(var j=0;j<dateallarr.length;j++){
			// if(dateallarr[j]==reldate11_java){
				// $('sp_a_'+j).innerText = "今天";
			// }else{
		 		// $('sp_a_'+j).innerText = dateallarr[j];
			// }
		// }
	// }
}

var $$ = {};

function $(id) {
    if (!$$[id]) {
        $$[id] = document.getElementById(id);
    }
    return $$[id];
}


function getfirstcol(destpage,relDate){
    getcol(destpage,relDate,1);
}
function getsecondcol(destpage,relDate){
    getcol(destpage,relDate,2);
}
function getthirdcol(destpage,relDate){
    getcol(destpage,relDate,3);
}

function getcol(destpage,relDate,index){
    var timeparam = "&starttiem=00:00&endtime=07:59";
	var custom_start1=0;
	var custom_start2=8*3600;
	var custom_start3=16*3600;
	
	var custom_end1=7*3600+59*60;
	var custom_end2=15*3600+59*60;
	var custom_end3=23*3600+59*60;
	var requestUrl="";
	//alert("*******************************second------relDate："+relDate);
	//alert("*******************************second------now_year_mon_date:"+now_year_mon_date);
	//alert("========================now_year_mon_date == relDate:"+(now_year_mon_date == relDate));
	if(now_year_mon_date == relDate)
	{
	//alert("-----------------enter----------");
	if(index == 1){
		 hid_words(1);
		 hid_words(2);
		 hid_words(3);
	//alert("current_time>=custom_start1 && current_time<custom_end1:"+(current_time>=custom_start1 && current_time<custom_end1));
	//alert("current_time>=custom_end1:"+(current_time>=custom_end1));
	//alert("current_time>=custom_start2 && current_time<custom_end2"+(current_time>=custom_start2 && current_time<custom_end2));
	//alert("current_time>=custom_start2 && current_time<custom_end2"+(current_time>=custom_start2 && current_time<custom_end2));
	  if(current_time>=custom_start1 && current_time<custom_end1)
	  {
	 //alert("=====================index1==============1");
		timeparam = "&starttiem=00:00&endtime="+cur_hour_min;
		requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+"&destpage="+destpage+timeparam+"&curdate="+relDate;
		new net.ContentLoader(requestUrl, function (){
        var results = this.req.responseText;
        showchannelcolumnlist(results,index);
		 });
		$('img_a_2_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
		$('divinfo2_0').innerHTML="  08:00-15:59";
		$('divinfo12_0').innerHTML="暂无节目单";
		$('img_a_2_0').href="";
        $('divinfo2_0').style.visibility = 'visible';
        $('divinfo12_0').style.visibility = 'visible';
		$('img_a_3_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
		$('divinfo3_0').innerHTML="  16:00-23:59";
		$('divinfo13_0').innerHTML="暂无节目单";
		$('img_a_3_0').href="";
        $('divinfo3_0').style.visibility = 'visible';
        $('divinfo13_0').style.visibility = 'visible';
	  }
	  else if(current_time>=custom_end1)
	  {
	  //alert("=====================index1==============2");
        timeparam = "&starttiem=00:00&endtime=07:59";
	  
	  requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+"&destpage="+destpage+timeparam+"&curdate="+relDate;
	  new net.ContentLoader(requestUrl, function (){
        var results = this.req.responseText;
        showchannelcolumnlist(results,index);
            getcol(destpage,relDate,2);
          });
	  }
    }else if(index == 2){
		hid_words(2);
		hid_words(3);
		if(current_time<custom_start2)
		{
			//alert("=====================index2==============1");
			timeparam = "&starttiem=08:00&endtime=08:00";
			$('img_a_2_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
			$('divinfo2_0').innerHTML="  08:00-15:59";
			$('divinfo12_0').innerHTML="暂无节目单";
			$('img_a_2_0').href="";
			$('divinfo2_0').style.visibility = 'visible';
			$('divinfo12_0').style.visibility = 'visible';
			$('img_a_3_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
			$('divinfo3_0').innerHTML="  16:00-23:59";
			$('divinfo13_0').innerHTML="暂无节目单";
			$('img_a_3_0').href="";
			$('divinfo3_0').style.visibility = 'visible';
			$('divinfo13_0').style.visibility = 'visible';
		}
		else if(current_time>=custom_start2 && current_time<custom_end2)
		{
			// alert("=====================index2==============2");
			timeparam = "&starttiem=08:00&endtime="+cur_hour_min;
			requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+	"&destpage="+destpage+timeparam+"&curdate="+relDate;
			new net.ContentLoader(requestUrl, function (){
			var results = this.req.responseText;
			showchannelcolumnlist(results,index);
		});

		$('img_a_3_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
		$('divinfo3_0').innerHTML="  16:00-23:59";
		$('divinfo13_0').innerHTML="暂无节目单";
		$('img_a_3_0').href="";
        $('divinfo3_0').style.visibility = 'visible';
        $('divinfo13_0').style.visibility = 'visible';
	  }
	  else
	  {
	  	//alert("=====================index2==============3");
        timeparam = "&starttiem=08:00&endtime=15:59";
		requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+"&destpage="+destpage+timeparam+"&curdate="+relDate;
		new net.ContentLoader(requestUrl, function (){
        var results = this.req.responseText;
        showchannelcolumnlist(results,index);
            getcol(destpage,relDate,3);
          });
	  }
    }else if(index == 3){
	  hid_words(3);
	  if(current_time<custom_start3)
	  {
	  	 // alert("=====================index3==============1");
        timeparam = "&starttiem=16:00&endtime=16:00";
		$('img_a_3_0').innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
		$('divinfo3_0').innerHTML="  16:00-23:59";
		$('divinfo13_0').innerHTML="暂无节目单";
		$('img_a_3_0').href="";
        $('divinfo3_0').style.visibility = 'visible';
        $('divinfo13_0').style.visibility = 'visible';
	  }
	  else
	  {
	  	 // alert("=====================index3==============2");
        timeparam = "&starttiem=16:00&endtime="+cur_hour_min;
		requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+"&destpage="+destpage+timeparam+"&curdate="+relDate;
		new net.ContentLoader(requestUrl, function (){
        var results = this.req.responseText;
        showchannelcolumnlist(results,index);
		});
	  }

	}
	}
	else
	{
		if(index == 1){
			timeparam = "&starttiem=00:00&endtime=07:59";
		}else if(index == 2){
			timeparam = "&starttiem=08:00&endtime=15:59";
		}else if(index == 3){
			timeparam = "&starttiem=16:00&endtime=23:59";
		}
	 requestUrl = "action/channel_onedetial_data.jsp?columnid="+curcolumnid+"&channelid="+curchannelid+"&destpage="+destpage+timeparam+"&curdate="+relDate;
	 new net.ContentLoader(requestUrl, function (){
        var results = this.req.responseText;
        showchannelcolumnlist(results,index);
        if(index == 1){
            getcol(destpage,relDate,2);
        }else if(index == 2){
            getcol(destpage,relDate,3);
        }
    });
	}
   
    
}

function goUrl(url){
    _window.top.doStop();
    _window.top.jsStopList();
	_window.top.jsHideOSD();
    _window.top.jsSetControl("tvodcurdate",curDate);
    _window.top.mainWin.document.location = url;
	top.jsDebug("====status   liuwei==="+url);
}


function showchannelcolumnlist(results,index){
  // alert("SSSSSSSSSSSSSSSSSSSSSSindex="+index);
     var data = eval("(" + results + ")");
     var columnArr = data.channelData;
     var length = columnArr.length;
     if(index == 1){
         destpage1 = parseInt(data.destpage);
         pagecount1 = parseInt(data.pageCount);
         var mixno = data.mixno;
         var channelname = data.channelname;

         if(channelname && channelname.length>18){
             channelname = channelname.substring(0,18)+"...";
         }
         $('lefttopinfo').innerText ="回看  >  "+mixno+" "+channelname;
         curMaxNo = mixno;
         favoriteTitle = channelname;
         dataArr1 = data.channelData;
     }else if(index == 2){
         destpage2 = parseInt(data.destpage);
         pagecount2 = parseInt(data.pageCount);
         dataArr2 = data.channelData;
     }else if(index == 3){
         destpage3 = parseInt(data.destpage);
         pagecount3 = parseInt(data.pageCount);
         dataArr3 = data.channelData;
     }

     for(var i=0; i<9; i++){
		if(i<length){;
			$('img_a_'+index+"_"+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
            $('divinfo'+index+"_"+i).innerText = "  "+columnArr[i].startime+"-"+columnArr[i].endtime;
            if(columnArr[i].curProgramName.length>10){
                $('divinfo1'+index+"_"+i).innerText = columnArr[i].curProgramName.substr(0,10)+"...";
            }else{
                $('divinfo1'+index+"_"+i).innerText = columnArr[i].curProgramName;
            }
			var playurla = columnArr[i].playUrl+"&leefocus=img_b_"+index+"_"+i+"__"+curDate+"__"+number+"__"+focuspage;
			if(play_flag==0){
			playurla =playurla .replace(/&/g,"@");
			playurla =  "vod_player_simple.jsp?global_code="+tvod_gc+"&inverse_time="+tvod_time+"&playUrl="+encodeURI(encodeURI(playurla));
			}
			
            $('img_a_'+index+"_"+i).href="javascript:goUrl('"+playurla+"')";
            $('divinfo'+index+"_"+i).style.visibility = 'visible';
            $('divinfo1'+index+"_"+i).style.visibility = 'visible';
         }else{
            $('divinfo'+index+"_"+i).style.visibility = 'hidden';
            $('divinfo1'+index+"_"+i).style.visibility = 'hidden';
			$('img_a_'+index+"_"+i).innerHTML = '';
            $('img_a_'+index+"_"+i).href = '';
         }
         $('img_'+index+"_"+i).style.visibility = 'hidden';
     }
	if(length>0){
		$('pic0'+index+'a').style.visibility = 'visible';
		$('pic0'+index+'b').style.visibility = 'visible';
		flagcontrl = "true";
        if(focustr !="" && focustr!="null"  && focustr.indexOf("img_b_"+index) >-1){
            document.links[focustr].focus();
            isfocus=true;
            focustr="";
        }else if(isfocus==false){
            if(focuscontrl=="true"){
                document.links["img_b_"+index+"_8"].focus();
            }else if(isgetfocus == 0){
                isgetfocus = 1;
                if(length>0){
                    document.links["img_b_"+index+"_0"].blur();
                    document.links["img_b_"+index+"_0"].focus();
                    $('img_'+index+"_0").style.visibility = 'visible';
                }
            }
        }
		if(eval("destpage"+index+"==1")){
			$('pic0'+index+'a').style.visibility = 'hidden';
		}
		if(eval("destpage"+index+"==pagecount"+index)){
			$('pic0'+index+'b').style.visibility = 'hidden';
		}
	}else{
        $('pic0'+index+'a').style.visibility = 'hidden';
        $('pic0'+index+'b').style.visibility = 'hidden';
	}
}


function reflesh(index,flag){
    var tempDataIndex = dataIndex1;
    var tempDtaArrIndex = dataArr1;
    if(index == 1){

    }else if(index == 2){
        tempDataIndex = dataIndex2;
        tempDtaArrIndex = dataArr2;
    }else if(index == 3){
        tempDataIndex = dataIndex3;
        tempDtaArrIndex = dataArr3;
    }
    var startIndex = tempDataIndex;
    var endIndex = tempDataIndex+9;
    if(tempDataIndex > tempDtaArrIndex.length){
        tempDataIndex --;
        return;
    }
    if(tempDataIndex < 0){
        tempDataIndex ++;
        return;
    }
    if(tempDataIndex+9 > tempDtaArrIndex.length){
        return;
    }
    var tempArr = tempDtaArrIndex.slice(tempDataIndex,tempDataIndex+9);
    for(var i=0; i<9; i++){
        $('img_a_'+index+'_'+i).innerHTML = '<img src="images/btn_trans.gif" alt="" width="1" height="1"/>';
        $('divinfo'+index+'_'+i).innerText = "  "+tempArr[i].startime+"-"+tempArr[i].endtime;
        if(tempArr[i].curProgramName.length>10){
            $('divinfo1'+index+'_'+i).innerText = tempArr[i].curProgramName.substr(0,10)+"...";
        }else{
            $('divinfo1'+index+'_'+i).innerText = tempArr[i].curProgramName;
        }
//        $('img_a_'+index+'_'+i).href=tempArr[i].playUrl+"&leefocus=img_b_"+index+"_"+i+"__"+curDate+"__"+number;
		//var playurlB = tempArr[i].playUrl+"&leefocus=img_b_"+index+"_"+i+"__"+curDate+"__"+number;
		var playurlB = tempArr[i].playUrl+"&leefocus=img_b_"+index+"_"+i+"__"+curDate+"__"+number+"__"+focuspage;
		if(play_flag==0){
		playurlB =playurlB .replace(/&/g,"@");
			playurlB =  "vod_player_simple.jsp?global_code="+tvod_gc+"&inverse_time="+tvod_time+"&playUrl="+encodeURI(encodeURI(playurlB));
		}
			
        $('img_a_'+index+'_'+i).href="javascript:goUrl('"+playurlB+"')";
        $('divinfo'+index+'_'+i).style.visibility = 'visible';
        $('divinfo1'+index+'_'+i).style.visibility = 'visible';
    }
    if(flag == -1){
//        debug("SSSSSSSSSSSSSSSSSSSSrefresh_focus="+"img_b_"+index+"_0");
        document.links["img_b_"+index+"_0"].blur();
        document.links["img_b_"+index+"_0"].focus();
        $('img_'+index+'_0').style.visibility = 'visible';
    } else if(flag == 1){
//        debug("SSSSSSSSSSSSSSSSSSSSrefresh_focus="+"img_b_"+index+"_8");
        document.links["img_b_"+index+"_8"].blur();
        document.links["img_b_"+index+"_8"].focus();
    }
    if(tempDataIndex >0){
        $('pic0'+index+'a').style.visibility = 'visible';
    }else{
        $('pic0'+index+'a').style.visibility = 'hidden';
    }
    if(tempDtaArrIndex.length < 9){
        $('pic0'+index+'b').style.visibility = 'hidden';
    }else if(tempDataIndex == tempDtaArrIndex.length - 9){
        $('pic0'+index+'b').style.visibility = 'hidden';
    } else {
        $('pic0'+index+'b').style.visibility = 'visible';
    }

    if(index == 1){
        dataIndex1 = tempDataIndex;
    }else if(index == 2){
        dataIndex2 = tempDataIndex;
    }else if(index == 3){
        dataIndex3 = tempDataIndex;
    }
}

function refleshLeft(flag){
    reflesh(1,flag);
}

function refleshMiddle(flag){
    reflesh(2,flag);
}

function refleshRight(flag){
    reflesh(3,flag);
}

var curtopmenuIndex =0;

function changemenu(id,flag){//回看顶部日期的变化效果
//    alert("SSSSSSSSSSSSSSSSSSchangemenu_"+id+"_"+flag);
	if(flag==1){//显示红色字体
		 if(curDate==reldate){
			$('sp_td').style.visibility = 'visible';
		 }else{
		 	$('sp_'+id).style.visibility = 'visible';
			$('sp_td').style.visibility = 'hidden';
		 }
        curtopmenuIndex = id;
        $('sp_a_'+id).style.color="red";
    }else{
		 $('sp_'+id).style.visibility = 'hidden';
        $('sp_a_'+id).style.color="white";
    }
}
function changeImg(id,colindex,flag){
	 curid = id.substring(4,5);
	 hidid = id;
	 turnpage = id.substring(6,7);
	 if(flag==1&&flagcontrl=="true"){
      	 $(id).style.visibility = 'visible';
     }else{
         $(id).style.visibility = 'hidden';
     }

//    alert("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSchangeImg"+id+"_"+flag);

    var tempIndex = dataIndex1;
    var tempArr = dataArr1;
    if(colindex == '2'){
        tempIndex = dataIndex2;
        tempArr = dataArr2;
    }else if(colindex == '3'){
        tempIndex = dataIndex3;
        tempArr = dataArr3;
    }
    var tempIndex1 = parseInt(tempIndex)+parseInt(turnpage);
//    alert("SSSSSSSSSSSSSSSSSSS22turnpage====="+turnpage);
//    alert("SSSSSSSSSSSSSSSSSSS22tempIndex====="+tempIndex);
//    alert("SSSSSSSSSSSSSSSSSSS22tempIndex1====="+tempIndex1);
    var tempObj = tempArr[tempIndex1];

    if(tempObj && tempObj.curProgramName.length>10){
        if(flag == 1){
            $("divinfo1"+colindex+"_"+turnpage).innerHTML= "<marquee version='3' scrolldelay='250' width='245'>" + tempObj.curProgramName+ "</marquee>";
        }else{
            $("divinfo1"+colindex+"_"+turnpage).innerHTML= tempObj.curProgramName.substr(0,10)+"...";
        }
    }
}


function doRed() {
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
         $("text").innerText = "收藏已达上线 ";
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
	//alert('--------------------->curid='+curid);
	focuscontrl="false";
//	curDate = datearr[eval(number)+0];
	curDate = datearr[number];
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
//        alert(">>>>>>>>>>mark>>>>>destpage2>>>>" + destpage2);
//        alert(">>>>>>>>>>mark>>>>>destpage2>>>>" + destpage2);
//        alert(">>>>>>>>>>mark>>>>>pagecount2>>>>" + pagecount2);
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
//            alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
//            alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
//            alert(">>>>>>>>>>mark>>>>>dataIndex2>>>>" + dataIndex2);
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
//	curDate = datearr[eval(number)+0];
	curDate = datearr[number];
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
		if(focuspage==-toplastpage){
			if(number-1>(6-toplast)){
				number--;
				curDate = datearr[number];
				changemenu(6-number,1);
				changemenu(6-number-1,0);
				if(bottomMenuTimer){
        			window.clearTimeout(bottomMenuTimer)
    			}
				bottomMenuTimer = window.setTimeout('controlTime();',600);
			}
		}else{
			number--;
			curDate = datearr[number];
			changemenu(6-number,1);
			changemenu(6-number-1,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
			bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}else if(number-1<0){
		//if(topmenucurrpage+1<=topmenuallpage){
			//topmenucurrpage++;
			//controltopmenupage--;
			//topmenupage(controltopmenupage);
			number=6;
			curDate = datearr[number];
			changemenu(0,1);
			changemenu(6,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		//}
	}
}
function goRewind(){

//alert("goRewind");
	if(number+1<=6){
		if(focuspage==(topfirstpage-1)){
			if(number+1<topfirst){
				number++;
				curDate = datearr[number];
				changemenu(6-number,1);
				changemenu(6-number+1,0);
				if(bottomMenuTimer){
        			window.clearTimeout(bottomMenuTimer)
    			}
    			bottomMenuTimer = window.setTimeout('controlTime();',600);
			}
		}else{
			number++;
			curDate = datearr[number];
			changemenu(6-number,1);
			changemenu(6-number+1,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		}
	}else if(number+1==7){
		//if(topmenucurrpage-1>0){
			//topmenucurrpage--;
			//controltopmenupage++;
			//topmenupage(controltopmenupage);
			number=0;
			curDate = datearr[number];
			changemenu(6,1);
			changemenu(0,0);
			if(bottomMenuTimer){
        		window.clearTimeout(bottomMenuTimer)
    		}
    		bottomMenuTimer = window.setTimeout('controlTime();',600);
		//}
	}
}

var isgetfocus = 0;
function controlTime(){
    dataIndex1 =0;
    dataIndex2 =0;
    dataIndex3 =0;
	$(hidid).style.visibility = 'hidden';
	focuscontrl="false";
	flagcontrl = "false";
    isfocus=false;
    isgetfocus = 0;
    get3AjaxData(otherpage,curDate);
}

function get3AjaxData(pageindex,curdate){
    getfirstcol(pageindex,curdate);

}

function doKeyPress(evt){
    var keycode = evt.which;
    if (keycode == <%=STBKeysNew.onKeyLeft%>){
        if(curid>0){
            var obj1 = $('img_a_'+(curid-1)+"_"+turnpage);
            if(obj1.href.indexOf('goUrl')>-1){
                obj1.focus();
            }else{
                obj1 = $('img_a_'+(curid-1)+"_0");
                if(obj1.href.indexOf('goUrl')>-1){
                    obj1.focus();
                }
            }
        }
		return false;
    }else if (keycode == <%=STBKeysNew.onKeyRight%>){
        if(curid<3){
            var obj1 = $('img_a_'+(parseInt(curid)+1)+"_"+turnpage);
            if(obj1.href.indexOf('goUrl')>-1){
                obj1.focus();
            }else{
                obj1 = $('img_a_'+(parseInt(curid)+1)+"_0");
                if(obj1.href.indexOf('goUrl')>-1){
                    obj1.focus();
                }
            }
        }
        return false;
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
                if(dataIndex1 <dataArr1.length - 9){
                    dataIndex1++;
                    refleshLeft(1);
                }
            } else if(curid == 2){
                if(dataIndex2 <dataArr2.length - 9){
                    dataIndex2++;
                    refleshMiddle(1);
                }
            } else if(curid == 3){
                if(dataIndex3 <dataArr3.length - 9){
                    dataIndex3++;
                    refleshRight(1);
                }
            }
		}else{
            if(turnpage<8){
                var obj = $('img_a_'+curid+"_"+(parseInt(turnpage)+1));
                debug("SSSSSSSSSSSSSSSSSobj="+obj);
                if(obj.href.indexOf('goUrl')>-1){
                    debug("SSSSSSSSSSSSSSSSSSSSSSSyes!!!!");
                    obj.focus();
                }
                return false;
            }else{
                return true;
            }
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
        _window.top.mainWin.document.location = "vod_search.jsp?columnpath=&&leefocus=xx";
    }else if (keycode == <%=STBKeysNew.onKeyRed%>){
		doRed();
    }else if(keycode == 0x0110){
       /* if("CTCSetConfig" in Authentication)
        {
            //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
            Authentication.CTCSetConfig("KeyValue","0x110");
        }else{
            //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
            Authentication.CUSetConfig("KeyValue","0x110");
        }*/
        _window.top.mainWin.document.location = "portal.jsp";
    }else if(keycode == 36){
        _window.top.mainWin.document.location = "portal.jsp";
    }else if (keycode == <%=STBKeysNew.remoteBack%> || keycode ==24){
        _window.top.mainWin.document.location = "back.jsp";
    }else{
        _window.top.mainWin.commonKeyPress(evt);
    }
    return false;
}

document.onkeypress = doKeyPress;
</script>
  </head>

  <body bgcolor="transparent" class="body_bg">
    <div  style="position:absolute; width:1236px; height:65px; left: 44px; top: 80px; color:black;font-size:26px;">
       <img src="images/tvod/btv-replay-list.png" width="1192" height="54" alt="">
    </div>
    <div class="topImg" style="font-size:26px; top:11px; width:177px; height:45px; position:absolute; color:#ffffff;">
        <div style="background:url('images/tvod/btv-replay-ico.png'); left:13; top:12px; width:41px; height:30px; position:absolute; ">
        </div>
        <div id="lefttopinfo" align="left" style="font-size:26px;line-height:50px; left:62; top:4px; width:620px; position:absolute; ">
        </div>
    </div>

   <div style="position:absolute;width:1234px; height:55px; left: 23px; top: 80px; color:white; font-size:26px;">
  <%
      for(int j=0;j<7;j++){
  		int topdaypos = 49+j*170;
  		if(j==6){
  %>
  		<div id="sp_a_<%=j %>"  style=" position:absolute; text-align:left; width:167px; height:30px; left: <%=topdaypos%>px; top: 12px; color:white; font-size:24px;"></div>
	  	<div id="sp_<%=j %>"  style=" visibility:hidden; position:absolute; text-align:left; width:177px; height:10px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="110" height="2"/> </div>
	 	<div id="sp_td"  style=" visibility:hidden; position:absolute; text-align:left; width:177px; height:10px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="50" height="2"/> </div>
 <%
        }else{
 %>
	   <div id="sp_a_<%=j %>"  style=" position:absolute; text-align:left; width:167px; height:10px; left: <%=topdaypos%>px; top: 12px; color:white; font-size:24px;"></div>
  		<div id="sp_<%=j %>" style=" visibility:hidden; position:absolute; text-align:left; width:177px; height:10px; left: <%=topdaypos%>px; top: 38px; color:red; font-size:24px;"><img  src="images/tvod/btv-02-focus.png" alt="" width="110" height="2"/> </div>
  <%
        }
     }
  %>
   </div>

      <%
         for(int j=0; j <3; j++){
      %>
      <div id="backpic0<%=j+1%>" style=" position:absolute; height: 480px; width:386px; left: <%=43+j*406%>px; top: 139px; font-size:22px;">
          <img  src="images/tvod/btv-replay-bg01.png" alt="" height="480px" width="382px"/>
      </div>

      <div id="pic0<%=j+1%>a" style=" visibility: hidden;  background: url('images/vod/btv_up.png'); position:absolute; width: 25px; height: 14px; left: <%=246+406*j%>px; top: 149px; "></div>
      <div id="pic0<%=j+1%>b" style=" visibility: hidden; background: url('images/vod/btv_down.png'); position:absolute; width: 25px; height: 14px; left: <%=246+406*j%>px; top: 600px; "></div>
      <%
          for(int i=0; i<9; i++){
              int top3 = 48*i;
      %>
      <div style=" position:absolute; left:<%=100+j*300%>px;top:<%=2*i%>; width:24px; height:14px;">
          <a href="channel_play.jsp?mixno=<%=mixno %>&leefocus=img_a_<%=j+1%>_<%=i%>" id="img_a_<%=j+1%>_<%=i%>"  name="img_b_<%=j+1%>_<%=i%>" onFocus="changeImg('img_<%=j+1%>_<%=i%>','<%=j+1%>',1);" onBlur="changeImg('img_<%=j+1%>_<%=i%>','<%=j+1%>',0);">
          </a>
      </div>
      <div id="img_<%=j+1%>_<%=i%>" style="border:1px solid red; visibility:hidden; position:absolute; height: 48px; width:382px; color: white; text-align: left; left: <%=43+j*406%>px; top: <%=164+top3%>px; font-size:22px;">
          <img  src="images/tvod/btv-replay-focus.png" alt="" height="48px" width="382px"/>
      </div>
      <div id="divinfo<%=j+1%>_<%=i%>" style="position:absolute;  height: 48px; width:120px; color: white; text-align: left; left: <%=53+j*406%>px; top: <%=174+top3%>px; font-size:22px;">
      </div>
      <div id="divinfo1<%=j+1%>_<%=i%>" style="position:absolute;   height: 48px; width:262px; color: white; text-align: left; left: <%=173+j*406%>px; top: <%=174+top3%>px; font-size:22px;">
      </div>
      <%
          }
         }
      %>

      <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
 		</div>
      <div style="position:absolute;width:1250px; height:40px; left: 0px; top: 640px; color:black;font-size:22px;">
   			<div  style="position:absolute;width:60px; height:32px; left: 160px; top: -1px; color:black;font-size:22px;">
		 		<img src="images/tvod/btv-btn-page_left.png" alt="" style="position:absolute;left:0;top:0px;">
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 220px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;前一天
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 340px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/tvod/btv_page_right.png" alt="" style="position:absolute;left:0px;top:0px;">
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 400px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;后一天
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 520px; top: -1px; color:black;font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">上页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 580px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;上一页
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 700px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/tvod/btv_page.png" alt="" style="position:absolute;left:0px;top:0px;">
        		<font style="position:absolute;left:2;top:4px;color:#424242">下页</font>
		 	</div>
		 	<div  style="position:absolute;width:120px; height:30px; left: 760px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;下一页
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 860px; top: -2px; color:black; font-size:22px;">
		 		<img src="images/vod/btv_Collection.png" alt="" width="60px" height="32" border="0" >
		 	</div>
		 	<div  style="position:absolute;width:190px; height:30px; left: 920px; top: 2px; color:white; font-size:22px;">
		 		&nbsp;收藏
		 	</div>
		 	<div  style="position:absolute;width:60px; height:32px; left: 1120px; top: -2px; color:black;font-size:22px;">
		 		<img src="images/vod/btv_Search.png" alt="" width=60px height="32" border="0" >
		 	</div>
		 	<div  style="position:absolute;width:90px; height:30px; left: 1180px; top: 2px; color:white; font-size:22px;">
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
            <div id="closeMsg" style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;" align="center">
                 2秒自动关闭
            </div>
        </div>
    </div>
<%--<%@ include file="inc/goback.jsp" %>--%>
 <script type="text/javascript">
     <%
     if(isnewopen!=null && isnewopen.equals("1")){
     %>
     init();
     <%
     }
     %>

     if(isZTEBW == false){
         init();
     }
 </script>
<%@ include file="inc/lastfocus.jsp" %>
<%@ include file="inc/time.jsp" %>
<%@ include file="inc/mailreminder.jsp" %>
  </body>
</html>
