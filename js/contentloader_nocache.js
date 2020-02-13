/*
url-loading object and a request queue built on top of it
*/

/* namespacing object */
var net=new Object();

net.READY_STATE_UNINITIALIZED=0;
net.READY_STATE_LOADING=1;
net.READY_STATE_LOADED=2;
net.READY_STATE_INTERACTIVE=3;
net.READY_STATE_COMPLETE=4;


/*--- content loader object for cross-browser requests ---*/
net.ContentLoader=function(url,onload,onerror,method,params,contentType){
  this.req=null;
  this.onload=onload;
  this.onerror=(onerror) ? onerror : this.defaultError;
  this.loadXMLDoc(url,method,params,contentType);
}

/*
update nirui
 */
var objPool = [];
//objPool[0] = createXMLHttpRequest();

function createXMLHttpRequest(){
	var xmlh = null;
	if(window.XMLHttpRequest){
		xmlh = new XMLHttpRequest();
	}else if(window.ActiveXObject){
		xmlh = new ActiveXObject("Microsoft.XMLHTTP");
	}
  //  alert('======new XMLHttpRequest_nocache====');
	return xmlh;
}

net.ContentLoader.prototype.getInstance = function(){
//    alert('========ContentLoader.getInstance===');
    if(true){
       return createXMLHttpRequest();
    }
	for (var i = 0; i < objPool.length; i ++)
	{
		if ( objPool[i].readyState == 4||objPool[i].readyState == 0)
		{
			return objPool[i];
		}
	}
	objPool[objPool.length] = createXMLHttpRequest();
	return objPool[objPool.length - 1];
}

net.ContentLoader.prototype.loadXMLDoc=function(url,method,params,contentType){
  if (!method){
    method="GET";
  }
  if (!contentType && method=="POST"){
    contentType='application/x-www-form-urlencoded';
  }
//  if (window.XMLHttpRequest){
//    this.req=new XMLHttpRequest();
//  } else if (window.ActiveXObject){
//    this.req=new ActiveXObject("Microsoft.XMLHTTP");
//  }
  this.req = this.getInstance();
  if (this.req){
    try{
      var loader=this;
      this.req.onreadystatechange=function(){
        net.ContentLoader.onReadyState.call(loader);
      }
      this.req.open(method,url,true);
      if (contentType){
        this.req.setRequestHeader('Content-Type', contentType);
      }
	  this.req.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      this.req.send(params);
    }catch (err){
      this.onerror.call(this);
    }
  }
}


net.ContentLoader.onReadyState=function(){
    try{
        var req=this.req;
        var ready=req.readyState;
        var httpStatus=req.status;

        if (ready==net.READY_STATE_COMPLETE){
            if (httpStatus==200 || httpStatus==0){
                this.onload.call(this);
            }else{
                this.onerror.call(this);
            }
        }
    }catch(e){
       debug("SSSSSSSSSSSSSSSSSSSSSajax_error??");
    }
}

net.ContentLoader.prototype.defaultError=function(){
//  alert("error fetching data!"
//    +"\n\nreadyState:"+this.req.readyState
//    +"\nstatus: "+this.req.status
//    +"\nheaders: "+this.req.getAllResponseHeaders());
}

var isZTEBW = false;
var isReallyZTE = false;
if(window.navigator.appName.indexOf("ztebw")>=0){
    isZTEBW = true;
    isReallyZTE = true;
}

//isZTEBW = false;
//isReallyZTE = false;

function debug(str){
    if(isReallyZTE == false){
        iSTB.evt.debug(str);
    }else{
     //   alert(str);
	 break;
    }
}



