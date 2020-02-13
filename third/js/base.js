// JavaScript Document
//iPanel.borderColor='#3399FF';
//iPanel.defaultFocusColor='#FFFFFF';

//document.onKeyPress=DealWithKey;
//function DealWithKey()
//{
//var nKeyCode=event.which;
//if(nKeyCode.EIS_IRKEY_NUM0=='0x0103'){
//home();
//}else if(nKeyCode.EIS_IRKEY_NUM0=='0x0103'){
//home();
//}
//}
//var i=0;
//var pic=new Array();
function home() {
	window.location.href = "index.php";
}

function exit() {
	window.location.href = "index.php";
}
function mouseover(obj){
	GetGamesdescribe('getgameinfo',obj);
}
function mouseout(){
document.getElementById('l_content').innerHTML='';
}

/*var req1=null;
//get ad
 function creat1Req() 
        {
        	
         // var url="http://192.168.1.6/gamecollection/gamecollection.php?requestType=1&gameName=zuma&userid=111"; 
          // var url='http://localhost/gamecollection_test/test.php?act=add';
		   if(window.XMLHttpRequest) 
            {
                req1=new XMLHttpRequest();
            }
            else if(window.ActiveXObject) 
            {
                req1=new ActiveXObject("Microsoft.XMLHttp");
            }
        }

function GetAD(act,content,isPost){
var url="http://192.168.1.6/gamecollection/test/ajax_manage.php?act="+act+"&Name="+content+"&tm="+new Date().getTime();
var url="http://192.168.1.6/gamecollection/gamecollection.php?requestType=1&gameName=zuma&userid=111";
var url="http://192.168.1.6/webhall/ajax_manage.php?act="+act+"&tm="+new Date().getTime();
			//var info="page="+escape(page);
			creat1Req();
			if(req1) 
            {
				if(isPost==1){
				req1.open("Post",url,true);	
                req1.send(info);
				}
			    else{
				req1.open("GET",url,true);
				req1.send(null);
			    }
			 req1.onreadystatechange = getADinfo;
				document.getElementById(content).setAttribute("class","active");
				document.getElementById(content).setAttribute("className","active"); 
            }
			else{
			alert('error');
			}
}
function getADinfo(){
	    	if(req1.readyState==4) 
            {
                if(req1.status==200) 
                {
					xmlDoc=req1.responseXML;
			      var x=xmlDoc.getElementsByTagName('ad');
        	     for(i=0;i<x.length;i++)
        	  {
        	  var att=x.item(i).attributes.getNamedItem("texture");
        	  //var name=x.item(i).attributes.getNamedItem("name");
        	  pic.push(att.value);
        		// html=html+'<a href=\'javascript:text();\' onClick=\'text();\'><img  width=\'128\' height=\'97\' src='+att.value+' class=\'point\' onclick=\'text();\'></a>';
        	  }	
			  
                	//alert(req1.responseText);
              var s=req1.responseText.split(',')
			   for(var j=0;j<s.length;j++){
			   pic.push(s[j]);	
                }
				document.getElementById('m2content').innerHTML="<a href=''><img src='"+pic[0]+"' width=461 height=45></a>";
				}
                else 
                {
					//alert('status error');
                }
            }
            else 
            {
             //  alert('readyState error')
            }
}*/
function GetSTBID(){
	
	return Authentication.CTCGetConfig("STBID");
}
function GetPwd(){
	return Authentication.CTCGetConfig("Pwd");
}
function GetUSERID(){
	return Authentication.CTCGetConfig("UserID");
}
function $(id) {
	return document.getElementById(id);
}
function ff(s)
{document.getElementById(s).className='Type_focus';
}
function ff_(s)
{document.getElementById(s).className='Type';
}
function fb(s)
{document.getElementById(s).className='board_focus';
}
function fb_(s)
{document.getElementById(s).className='board';
}

var i=0;
function ad_show(){
	var array_pic=['banner01.jpg','banner02.jpg','banner03.jpg','banner04.jpg','banner05.jpg']
if(i>1){
i=0;
}
//console.log(array_pic[i]);
//$("m2content").innerHTML='';
$("m2content").removeChild($("m2content").childNodes[0]);
//$("banner").src="../media_webkit/activities_hot/"+array_pic[i];
var tmp=document.createElement("img");
tmp.src="media_webkit/activities_hot/"+array_pic[i];
tmp.style["-webkit-animation"]="banner 1s ease-in-out";
$("m2content").appendChild(tmp);
//$("banner").style["-webkit-animation"]="banner 1s ease-in-out";
setTimeout(ad_show,7000);
i=i+1;
}

function button_focous(obj,type,page){
  $(obj).style["-webkit-animation"]="DivZoom1 0.6s ease-in-out";
  $(obj).style["-webkit-animation-delay"]= Math.random() + "ms";
  $(obj).style["-webkit-transition"] = "all";
  var href='gamesinfo.php?act=getGames&Name='+type+'&page='+page;
  //window.location.href=href;
  setTimeout("setTimelocation('"+href+"')",600);
  
}
function setTimelocation(href){
window.location.href=href;
}
function init(obj){
//$(obj).focus();
$(obj).focus();
}
function _loginTotal(){
	var userid=GetUSERID();
	//var gameid=game.gameid;
	var stbid=GetSTBID();
	var target=Authentication.CUGetConfig("hardware_type");
	 if(window.XMLHttpRequest) 
    {
        req=new XMLHttpRequest();
    }
    else if(window.ActiveXObject) 
    {
        req=new ActiveXObject("Microsoft.XMLHttp");
    }
	 var url='ajax_upload.php?act=login&stbid='+stbid+'&userid='+userid+'&target='+target+"&tm="+new Date().getTime();
	// console.log('1');
	// var url='ajax_test.php';
	 req.open("GET",url,true);
	 req.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
	// req_.send('&userid='+userid+'&target='+target+'&stbid'+stbid+"&tm="+new Date().getTime());
	 //alert(req_.responseText);
	 req.send(null);
	 req=null;
}