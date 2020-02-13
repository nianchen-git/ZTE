// JavaScript Docum:ent

function GAME(name,id){
	this.name=name;
	this.gameid=id;
	this.download='http://61.135.89.201/';
    //this.download="http://192.168.1.3/officialweb/broadcom/";   
     this.suffixes = ".tar.gz";
}
//set
GAME.prototype.ENTERHALL=function(){
	Authentication.CTCSetConfig('Game.EnterHall','test');
}

//Service Entry
GAME.prototype.ServiceEntry=function(Url,Hotkey,Desc){
	Authentication.CTCSetConfig("ServiceEntry",'URL=\"'+Url+'\",HotKey=\"'+Hotkey+'\",Desc=\"'+Desc+'\"');
//var str='ServiceEntry'+'Url="'+Url+'"'+'HotKey="'+Hotkey+'"'+'Desc="'+Desc+'"';
//alert(str);
}

//Down_load Start
GAME.prototype.Download_Start=function(){
	//var url=[this.download+this.name+this.suffixes];
	var url=this.GetDownLoadURL();
         var data='{"gameID":"'+this.gameid+'","gameName":"'+this.name+'","gameURL":"'+url+'"}';
	Authentication.CTCSetConfig("Game.Download.Start",'"'+data+'"');
	}
//Down_load Stop
GAME.prototype.Download_Stop=function(){
	Authentication.CTCSetConfig("Game.Download.Stop",this.gameid);
		//var jsonstr=eval(" (" + data + ") ");
	       //  alert('"'+this.gameid+'"');
	}
//Play
GAME.prototype.Play=function(){
	var stbid=GetSTBID();
	var userid=GetUSERID();
	var pass=GetPwd();
	var serverip='61.135.89.201';
	var port='10000';
    //var data='{"gameID":"'+this.gameid+'","stbid":"'+stbid+'","userid":"'+userid+'"}';
    var data='{"gameID":"'+this.gameid+'","-s":"'+serverip+'","-stbid":"'+stbid+'","-port":"'+port+'","-n":"'+userid+'","-p":"'+pass+'"}';
	Authentication.CTCSetConfig("Game.Play",'"'+data+'"');
}

//GET
//get DOWNLOAD SUPPORT
GAME.prototype.Download_Support=function(){
  return Authentication.CTCGetConfig("Game.Download.Support");
}

//GET STATE
GAME.prototype.Download_GetState=function(){
	//alert("Game.Download.GetState,"+this.gameid+'"');
	var state=Authentication.CTCGetConfig('Game.Download.GetState,'+this.gameid);
	return state;
    //return 1;
}


//GET disk info
GAME.prototype.GetDiskInfo=function(){
    return Authentication.CTCGetConfig("Game.GetDiskInfo");	
}

GAME.prototype.GetDownLoadURL=function(){
        var hardwareType=this.GetHardwareType();
  if(hardwareType=='EC5108B_pub'){
        var platform='his3716c/';
     //   var URL=this.download+'/'+platform+this.name+this.suffixes;
 }else{
        var platform='broadcom/';
 }
var URL=this.download+platform+this.name+this.suffixes;
        return URL;
}

GAME.prototype.GetHardwareType=function(){
       return Authentication.CUGetConfig("hardware_type");
}


var game=null;
var fake=null;
var settime;
//function start game
function start(name,id){
	//var urlreturn=getCookie(urlreturn);
//	ret('http://61.135.89.201/webhall/games.php?act=getGametype&type=game',502,'GAMEEPGURL');
 ret('http://61.135.89.201/webhall/gamesdetail.php?gamename='+name+'&urlreturn='+urlreturn+'&back',502,'GAMEEPGURL');
    game=new GAME(name,id);
   // show_error();
   // var _value=1
	/*var _value=game.Download_Support();
	if(_value==1){
	//	setTimeout(get_state,200);
          get_state_first();	
	}
	else{
	showerror('不支持下载,请查看是否插入U盘。','error_');
//var url=game.GetDownLoadURL();
//var harware=game.GetHardwareType();
//showerror('不支持下载,请查看是否插入U盘。'+url+harware,'error_');

	}
	*/
    GetSupport();
}
function GetSupport(){
	var _value=game.Download_Support();
	if(_value==1){
	//	setTimeout(get_state,200);
          get_state_first();	
	}
	else{
	showerror('不支持下载,请查看是否插入U盘。','error_');
	setTimeout(GetSupport,5000);
	}
}

function clearerror(){
	$('error').innerHTML='';
}
function showerror(str,obj){
	$(obj).innerHTML=str;
}


function get_state_first(){
	var getstate=game.Download_GetState();
	//showerror('get:'+getstate,'showtitle_');
	//var getstate='{"state":4,"rate":100}';
	if(typeof(getstate) == "undefined"){
		showerror('状态获取失败','error_');
	//	get();
	}
	else{
		getstate=eval("("+getstate+")");
		var code=getstate.state;
		switch(code){
		case 0:
			  showerror('未下载此游戏','error_');
			  showerror('<a href=\'javascript:download();\' id=download><img src=\"images/btn_download_1.png\"/></a>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_redownload_2.png\"/>','btn_');
			  //getdisk();
			  $('download').focus();
			  break;
		
		case 1:
			// showerror('','showtitle_');
			 showerror('','fake_');
			 showerror('已下载此游戏','error_');
			 showerror('<img src=\"images/btn_download_2.png\"/>&nbsp;&nbsp;<a href=\'javascript:run();\' id=start><img src=\"images/btn_start_1.png\"/></a>&nbsp;&nbsp;<a href=\'javascript:download();\'><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
	                 //setTimeout(clearerror,3000);
			 $('start').focus();
			  break;
		
		case 2:
			 showerror('已有部分游戏内容','error_');
			 showerror('<a href=\'javascript:download();\' id=download><img src=\"images/btn_download_1.png\"/></a>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_redownload_2.png\"/>','btn_');
			   //setTimeout(clearerror,3000);  
			 $('download').focus();
			break;
		case 3:
			var rate=getstate.rate;
			fake=new fakeProgress_webkit('fake_');
			fake.show(rate);
			var string='正在下载,'+rate+'%';
			//showerror('正在下载资源。。。。','showtitle_');
			showerror(string,'error_');
			settime=window.setInterval('get_state()',1000); 
			break;
		
		case 4:
			// 下载失败
			// showerror('','showtitle_');
			 showerror('','fake_');
			 showerror('下载失败','error_');
			 showerror('<img src=\"images/btn_download_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<a href=\'javascript:download();\' id=download><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
			 //  showerror('重新下载启动','error')；
			 $('download').focus();
			 
			 break;
		
		case 5:
			   //showerror('','showtitle_');
		       showerror('解压失败','error_');
			   showerror('<img src=\"images/btn_download_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<a href=\'javascript:download();\' id=download><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
			   $('download').focus();
		 	break;
		
		case 6:
			   //showerror('','showtitle_');
			   showerror('解压失败','error_');
			   showerror('<img src=\"images/btn_download_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<a href=\'javascript:download();\' id=download><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
			   $('download').focus();
			break;
		default:
			showerror('未知错误','error_');
			break;
		}
	}
}

function get_state(){
	var getstate=game.Download_GetState();
	//showerror('get:'+getstate,'showtitle_');
	//var getstate='{"state":4,"rate":100}';
	if(typeof(getstate) == "undefined"){
		showerror('状态获取失败','error_');
	//	get();
	}
	else{
		getstate=eval("("+getstate+")");
		var code=getstate.state;
		switch(code){
		case 0:
			  showerror('未下载此游戏','error_');
			  isevent=0;
			  //showerror('<a href=\'javascript:download();\' id=download><img src=\"images/btn_download_1.png\"/></a><img src=\"images/btn_start_2.png\"/><img src=\"images/btn_redownload_2.png\"/>','btn_');
			  //getdisk();
			 // $('download').focus();
			  window.clearInterval(settime);
			  close_error();
			  break;
		
		case 1:
			// showerror('','showtitle_');
			 isevent=0;
			 showerror('','fake_');
			 showerror('已下载此游戏','error_');
			 //showerror('<img src=\"images/btn_download_2.png\"/><a href=\'javascript:run();\' id=start><img src=\"images/btn_start_1.png\"/></a><a href=\'javascript:download();\'><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
	                 //setTimeout(clearerror,3000);
			 //$('start').focus();
			// custom_event();   
			 upload();
			// run();
			 window.clearInterval(settime);
			close_error();
			  break;
		
		case 2:
		     isevent=0;
			 showerror('已有部分游戏内容','error_');
			 //showerror('<a href=\'javascript:download();\' id=download><img src=\"images/btn_download_1.png\"/></a><img src=\"images/btn_start_2.png\"/><img src=\"images/btn_redownload_2.png\"/>','btn_');
			   //setTimeout(clearerror,3000);  
			// $('download').focus();
			   //getdisk();
			  // get_state();
			 window.clearInterval(settime);
			 close_error();
			break;
		case 3:
			var rate=getstate.rate;
			isevent=0;
			fake=new fakeProgress_webkit('fake_');
			fake.show(rate);
			var string='正在下载,'+rate+'%';
			//showerror('正在下载资源。。。。','showtitle_');
			showerror('<img src=\"images/btn_download_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_start_2.png\"/>&nbsp;&nbsp;<img src=\"images/btn_redownload_2.png\"/>','btn_');
			showerror(string,'error_');                   
			break;
		
		case 4:
			// 下载失败
			// showerror('','showtitle_');
			 isevent=0
			 showerror('','fake_');
			 showerror('下载失败','error_');
			// showerror('<img src=\"images/btn_download_2.png\"/><img src=\"images/btn_start_2.png\"/><a href=\'javascript:download();\' id=download><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
			 //  showerror('重新下载启动','error')；
			 //$('download').focus();
			 window.clearInterval(settime);
			 close_error();
			   //setTimeout(clearerror,3000);
			 break;
		
		case 5:
			   //showerror('','showtitle_');
			   isevent=1
			   showerror('','fake_');
			   showerror('解压中，请稍等。。。','error_');
		 	break;
		
		case 6:
			   //showerror('','showtitle_');
			   isevent=0
			   showerror('解压失败','error_');
			   //showerror('<img src=\"images/btn_download_2.png\"/><img src=\"images/btn_start_2.png\"/><a href=\'javascript:download();\' id=download><img src=\"images/btn_redownload_1.png\"/></a>','btn_');
			   //setTimeout(clearerror,3000);
			   //$('download').focus();
			   window.clearInterval(settime);
			   close_error();
			break;
		default:
			showerror('未知错误','error_');
			break;
		}
	}
}
function get(){
	// jj=jj+1;
	//get_state();
	setTimeout(get_state,1500);
}

function getdisk(){
		var _value=game.Download_Support();
if(_value==1)
{
	var disk=game.GetDiskInfo();
	 //var disk='{"FreeSpace":320,"TotalSpace":600}';
    disk=eval("("+disk+")");
    var freeSpace=disk.FreeSpace;
    var totalSpace=disk.TotalSpace;
    if(freeSpace<30){
    	showerror('空间不够,剩余/总容量'+freeSpace+'/'+totalSpace,'error_');
    	//setTimeout(clearerror,3000);
    	close_error();
    }else{
    	//showerror('剩余/总容量：'+freeSpace+'/'+totalSpace+'MB','error_');
		settime=window.setInterval('get_state()',1000); 
	    game.Download_Start();
        //download();
        // setTimeout(download,500);
        //setTimeout(get_state,2000);
    }
 }else{
     showerror('不支持下载,请查看是否插入U盘。','error_');
	 close_error();
 }
}

function run(){
	showerror('正在启动请稍等...','error_');
	game.Play();
	_startTotal();
}
function download(){
	getdisk();
}
function stop(){
	game.Download_Stop();
}

function ret(Url,Hotkey,Desc){
	//alert('Url="'+Url+'",'+'HotKey="'+Hotkey+'",'+'Desc="'+Desc+'"');
	Authentication.CTCSetConfig("ServiceEntry",'URL=\"'+Url+'\",HotKey=\"'+Hotkey+'\",Desc=\"'+Desc+'\"');
	//document.write('Url="'+Url+'"','HotKey="'+Hotkey+'"','Desc="'+Desc+'"');
	//Authentication.CTCSetConfig("ServiceEntry","URL=\"http://61.135.89.201/webhall/index.php\",HotKey=\"502\",Desc=\"GAMEEPGURL\"");
}

function clear(){
	//game=null;
	close_error();
}

function _hide(id){
	$(id).style.display='none';
}
function _show(id){
	$(id).style.display='block';
}

function show_error(){
	_show('shad');
    _show('tb_nlink');
    _hide('tb_link');
}
function close_error(){
	window.location.reload();
}
function upload(){
	var userid=GetUSERID();
	var gameid=game.gameid;
	var gamename=game.name;
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
	 var url='ajax_upload.php?act=upload&gameid='+gameid+'&userid='+userid+'&gamename='+gamename+'&target='+target+'&stbid='+stbid+"&tm="+new Date().getTime();
	 req.open("GET",url,true);
	 req.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
	 req.send(null);
	 req=null;
	 gameid=null;
}

function _startTotal(){
	
	var userid=GetUSERID();
	//var gameid=game.gameid;
	var gamename=game.name;
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
	 var url='ajax_upload.php?act=start&gamename='+gamename+'&userid='+userid+'&target='+target+'&stbid='+stbid+"&tm="+new Date().getTime();
	 req.open("GET",url,true);
	 req.send(null);
	 req.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
	 req=null;
	 gameid=null;
}

