<%@page contentType="text/html; charset=utf-8" %>
<%@page import="com.cuntv.epg.util.ViewUtils"%>
<%@page import="com.cuntv.epg.service.IEpgDataSource"%>
<%@page import="java.util.*"%>
<%@page import="net.sf.json.*"%>
<%@page import="javax.xml.parsers.*"%>
<%@page import="org.w3c.dom.*"%>
<%@page import="java.io.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel=stylesheet href="css/public.css" type="text/css">
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="cache-control" content="no-cache"/>
<meta http-equiv="expires" content="0"/>
<%
  if(!request.isRequestedSessionIdValid()){
      %>
      <jsp:forward page= "session_invalid.jsp">
          <jsp:param name="session_invalid" value="1" />
      </jsp:forward>
<%
    }
	
	//定位焦点位置
int focus_channel=0;
if(request.getParameter("focus_channel")!= null  && ""!=request.getParameter("focus_channel").trim()){
focus_channel=Integer.parseInt(request.getParameter("focus_channel"));
}
//out.println("focus_channel:"+focus_channel);
/*
*回放节目单里没有UserChannelID，必须从频道节目单获取
*/
ViewUtils viewUtils=new ViewUtils();
IEpgDataSource dataSource=viewUtils.getDataSource();//获取数据源
//通过节目单获取有节目单的频道
//String sql1="select distinct on (\"ChannelCode\") \"ChannelCode\" , \"ChannelName\",\"ChannelID\" from V_EPG_I_CHANL_GETCHANLSCHLIST";
//String categorylist1=dataSource.getBaseList(sql1,new Object[]{});
//JSONArray tempjson3 =JSONArray.fromObject(categorylist1);

String sqlb="select * from V_EPG_I_CHANNEL_GETCHANNELLIST where  \"IsTVOD\"=1";
String categorylistb=dataSource.getBaseList(sqlb,new Object[]{});
JSONArray tempjsonb =JSONArray.fromObject(categorylistb);
//out.println("shum u"+tempjsonb);

String sqlc="select count(*) from V_EPG_I_CHANNEL_GETCHANNELLIST where  \"IsTVOD\"=1";
String categorylistc=dataSource.getBaseList(sqlc,new Object[]{});
JSONArray tempjsonc =JSONArray.fromObject(categorylistc);

//获取频道号
String url = session.getAttribute("channelUserList").toString();
JSONArray tempjson1 =JSONArray.fromObject(url);
int size=0;
List <String> channelName = new ArrayList<String>();
List <String> userChannelID = new ArrayList<String>();
List <String> ChannelID = new ArrayList<String>();
for(int j=0; j<tempjson1.size(); j++){
JSONObject channellist0 = tempjson1.getJSONObject(j);
String channelid = channellist0.getString("UserChannelID").toString();
//out.println("channellist0:"+channellist0.getString("UserChannelID"));
//out.close();
for(int i=0; i<tempjsonb.size();i++){
  JSONObject channellist1 = tempjsonb.getJSONObject(i);
  String channelid1 = channellist1.getString("UserChannelID").toString();
  if(channelid.equals(channelid1)){
  userChannelID.add(channellist1.getString("UserChannelID"));
  channelName.add(channellist1.getString("ChannelName"));
  ChannelID.add(channellist1.getString("ChannelID"));
 }
}
}
double pagesize=20.0;
double pagecount1=tempjsonb.size();//总条数
int page_total=(int)Math.ceil(pagecount1/pagesize);//总页数
%>
<script src="js/page_flow.js" type="text/javascript"></script>
<script type="text/javascript">
<%@include file="js/keydefine.js" %>
<%@include file="js/common_lib.js" %>

//全局变量
var focus_channel = <%=focus_channel%>;
var page_seq=Math.floor(focus_channel / 20);	  
var focus_now=focus_channel % 20 +10;


var page_total=<%=page_total%>;//总页数
var pagecount=<%=pagecount1%>;//总条数
var pagesize=20;//每页显示条数
//var page_seq=0;//当前页数
var start_seq=0;
var channel=['userChannelID','channelName','ChannelID'];//0：频道号； 1:频道名； 2频道ID
channel['userChannelID']=[];
channel['channelName']=[];
channel['ChannelID']=[];

<%

for(int i=0; i<tempjsonb.size(); i++){
%>
channel['userChannelID'][<%=i%>]="<%=userChannelID.get(i)%>";
channel['channelName'][<%=i%>]="<%=channelName.get(i)%>";
channel['ChannelID'][<%=i%>]="<%=ChannelID.get(i)%>";

<%
}
%>

function go_to_page (page_url)
{	
    if(page_url == '')
    return false;
    document.forms[0].action = page_url;
    document.forms[0].submit();
}
function page_change(start_seq1,pagesize){

      for(var m=0; m<20; m++){
	     var response0 ="response_bg_"+m; 
	     $("response_bg_"+m).innerHTML="";
		 var response1="response_id_"+m;
		 $(response1).innerHTML="";
	     var response2="response_channel_"+m;
        $(response2).innerHTML="";
	   }
	   var start_seqM = start_seq1;
	   for(var i=0; i<pagesize; i++){
       
	    var response0 ="response_bg_"+i; 
		var response2="response_channel_"+i;
		strScheduleName= channel['channelName'][start_seq1]; 
		var focusa=start_seqM+i;
	  $(response0).innerHTML= "<a href=\"javascript:;\" onClick=document.forms[0].focus_channel.value='"+focusa+"';click_product("+start_seq1+")  onFocus=focus_channel_schedules('menu_bg_"+i+"','"+encodeURI(strScheduleName)+"','"+response2+"',7) onBlur=blur_channel_schedules('menu_bg_"+i+"','"+encodeURI(strScheduleName)+"','"+response2+"',7) ><img id=\"menu_bg_"+i+"\" src=\"images/ui_focus.gif\" width=\"350\" height=\"42\">"+"</a>";
	   var response1="response_id_"+i;
	    if(channel['userChannelID'][start_seq1].length==1){
	   channel['userChannelID'][start_seq1]="00"+channel['userChannelID'][start_seq1];
	   }else if(channel['userChannelID'][start_seq1].length==2){
	   channel['userChannelID'][start_seq1]="0"+channel['userChannelID'][start_seq1];
	   }
	   $(response1).innerHTML=channel['userChannelID'][start_seq1];
	  
	   
        var strScheduleNameA = cut_string(strScheduleName,7);
	   $(response2).innerHTML=strScheduleNameA;
       start_seq1+=1;
}
}

//onfcous事件
function focus_channel_schedules(bg,titlea,title_name,cut_long){
change_img(bg,'selected_effect.png'); 
focus_title(titlea,title_name,cut_long);
}

function blur_channel_schedules(bg,titlea,title_name,cut_long){
return_img(bg);
blur_title(titlea,title_name,cut_long);
}

/*
* titlea 要滚动的文字
* title_name div抱歉的id名
* cut_long 截取的字符串长度
*/
function focus_title(titlea,title_name,cut_long){
var titlem=decodeURI(titlea);
if(titlem.length>cut_long){
$(title_name).innerHTML="<marquee>"+titlem+"</marquee>";
}
}

function blur_title(titlea,title_name,cut_long){
var titlem=decodeURI(titlea);
if((titlem.length>cut_long)){
$(title_name).innerHTML= cut_string(titlem,cut_long);
}
}

function click_product(index){
    document.forms[0].channel_id.value=channel['ChannelID'][index];
    document.forms[0].channel_name.value=channel['channelName'][index];
    document.forms[0].userChannelID.value=channel['userChannelID'][index];
    go_to_page('tv_one_channel_schedules.jsp');
}
//翻页
function custom_page_prev()
{
	page_seq=page_seq-1;
	if(page_seq<=0)
	   page_seq=0;
	start_seq=page_seq*20;
	if(page_seq<(page_total-1)){
	pagesize=20;
	}
	page_change(start_seq,pagesize);
	page_left_up_down();
	document.links[10].focus();

}

//下页
function custom_page_next(){
    page_seq=page_seq+1;
	if(page_seq>=page_total-1)
		page_seq=page_total-1;
	start_seq=page_seq*20;
	if(page_seq==(page_total-1)){
	pagesize= pagecount-page_seq*20;
	}else{
	pagesize=20;
	}
	page_change(start_seq,pagesize);
	page_left_up_down();
	document.links[10].focus();
	
}
function page_left_up_down(){
if(page_seq>0){
	$("img_id_njracc").setAttribute("src", "images/up2.png");
	}else{
	$("img_id_njracc").setAttribute("src", "images/up.png");
	}
	if(page_seq+1<page_total){
	$("img_id_wluegg").setAttribute("src", "images/down2.png");

	}else{
	$("img_id_wluegg").setAttribute("src", "images/down.png");
	}
	document.getElementById("page_show").innerHTML=(page_seq+1)+"/"+page_total;
}


function custom_key_back(){
go_to_page("portal.jsp");
}

function custom_on_load(){
enable_custom_page_jump(1);
enable_custom_key_back(1);
start_seq = page_seq*20;
if(page_total==(page_seq+1)){
 pagesize = pagecount-start_seq;
}else{
pagesize=20;
}
page_change(start_seq,pagesize);

page_left_up_down();
 if(focus_channel ==0 ||focus_channel =="0"){
setTimeout('custom_onfocus()',500);
 }else{
setTimeout('return_focus()',500);
	   
 }
//document.links[10].focus();
}
function return_focus(){
//focus_now-=1;
document.links[focus_now].focus();
}
function custom_onfocus(){
document.links[10].focus();
}
</script>


 <title>tv_channel_schedule</title>
</head>
<body style="background-color: transparent;" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" scroll="no"  background="images/vod_menu.jpg" marginheight="0" marginwidth="0" onLoad="custom_on_load()">


<!-- 看吧左侧菜单-->
<div  id="select" style="position:absolute;left:0px;top:320px;width:333px;height:55px" > 
<img id="img_id_wxvtxw" src="images/program_menu_focus.png" border="0" height="55" width="333"> </div>
<jsp:include page="portal_menu.jsp" flush="true"></jsp:include> 

<%
for(int i=0; i<20; i++){
int top=(int)(145+Math.floor(i%10)*49);
int left=(int)(380+Math.floor(i/10)*400);
%>
<div id="response_bg_<%=i%>"  style="position:absolute;left:<%=left-20%>px;top:<%=top-10%>px;width:350px;height:30px" ></div>
<div id="response_id_<%=i%>"  style="position:absolute;left:<%=left%>px;top:<%=top%>px;width:73px;height:26px" align="right" class="font_30"></div> 		  
<div id="response_channel_<%=i%>" style="position:absolute;left:<%=left+100%>px;top:<%=top%>px;width:230px;height:26px" align="left" class="font_30"></div> 
<%
}
%>
<div style="position:absolute; left:748px;top:96px;width:30px;height:17px;" align="left">
<img id="img_id_njracc" src="" border="0" height="17" width="30"></div>
<div style="position:absolute; left:790px;top:100px;width:430px;height:30px;" class="font_20" align="left">
按&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;翻页</div>
<div style="position:absolute; left:820px;top:98px;width:230px;height:30px;" align="top left">
<img src="images/up_page.png" width="55" height="30" border="0" style="top:136px"></div>
<div style="position:absolute; left:748px;top:635px;width:30px;height:17px;" align="left">
<img id="img_id_wluegg" src="" border="0" height="17" width="30"></div>
<div style="position:absolute; left:790px;top:639px;width:230px;height:17px;" class="font_20" align="left">
按&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;翻页</div>
<div style="position:absolute; left:820px;top:637px;width:230px;height:30px;"  align="top left">
<img src="images/down_page.png" width="55" height="30" border="0" style="top:136px"></div>
<div id="page_show" style="position:absolute;left:1202px;top:349px;width:43px;height:26px;color:#ffffff;font-size:25;" align="right"></div> 
</body>
<form  action="" method="POST">
<!--一级页面-->
<input type="hidden" name="page_menu_name" value="tv_channel_schedules.jsp">
<input type="hidden" name="channel_id" value="">
<input type="hidden" name="channel_name" value="">
<input type="hidden" name="focus_channel" value="">
<input type="hidden" name="userChannelID" value="">
</form>
<jsp:include page="marquee.jsp" flush="true"></jsp:include>
<jsp:include page="weather.jsp" flush="true"></jsp:include>
</html>
