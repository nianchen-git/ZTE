    var FONTHEAD = "<font color='00FF00' size='8' ><h1>";
    var FONTTAIL = "</h1></font>";

    function showChannelNumber(channelNum)
    {
        if (channelNum != null && channelNum != undefined)
        {
            top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
    }

    function clearChannelNumber()
    {
        top.mainWin.document.all.channelNumber.innerHTML = "";
    }
	top.jsEnableNumKey();

	function hideOsd(){
		top.hideOSD();
	}


    function do_nothing() {
        return false;
    }

   function commonKeyPress(evt){
        var keycode = evt.which;
        if(keycode==0x0101){ //ÆµµÀ¼Ó¼õ¼ü
              top.remoteChannelPlus();
        }else if(keycode==0x0102){
              top.remoteChannelMinus();
        }else if(keycode == 0x0110){
            //Authentication.CTCSetConfig("KeyValue","0x110");
            top.mainWin.document.location = "portal.jsp";
        }else if (keycode == 0x0008){
            top.mainWin.document.location = "back.jsp";
        }else{
            top.doKeyPress(evt);
        }
   }

    top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0105);
    top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0103);
    top.jsSetupKeyFunction("top.mainWin.do_nothing", 0x0104);

//    alert("+++++++++++++++lastfocus++++");
    top.setBwAlpha(0);
