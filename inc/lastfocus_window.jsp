<script language="javascript" type="">
    //    iPanel.focusWidth = "0";
    var FONTHEAD = "<font color='00FF00' size='8' ><h1>";
    var FONTTAIL = "</h1></font>";

    function hidePortal(){
        if(typeof(_windowframe) == "object"){
            if(_windowframe.clearPage){
                _windowframe.clearPage();
            }
            _windowframe.hide();
            window.setWindowFocus();
        }
    }

    function reshowReminderWindow(){
        var reminderWindow = window.getWindowByName("reminderWindow");
        if (typeof(reminderWindow) == "object") {
            reminderWindow.hide();
            reminderWindow.show();
        }
        _windowframe.setWindowFocus();
    }

    function commonKeyPress(evt){
        var keycode = evt.which;
        if(keycode==0x0101){ //????????
            top.remoteChannelPlus();
        }else if(keycode==0x0102){
            top.remoteChannelMinus();
        }else if(keycode == 0x0110){
            //Authentication.CTCSetConfig("KeyValue","0x110");
           /* if("CTCSetConfig" in Authentication)
            {
             //   alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            top.mainWin.document.location = "portal.jsp";
        }else if(keycode == 36){
            top.mainWin.document.location = "portal.jsp";
        }else if (keycode == 0x0008 || keycode == 24){
            top.mainWin.document.location = "back.jsp";
        }else if (keycode == 0x0113){
            if(window.navigator.appName.indexOf("ztebw")>=0){
                top.mainWin.document.location = "channel_all_pre.jsp";
            }else{
                top.mainWin.document.location = "channel_all.jsp";
            }
        }else if (keycode == 0x0114){
            top.mainWin.document.location =  "channel_all_tvod.jsp";
        }else if (keycode == 0x0115){
            if(window.navigator.appName.indexOf("ztebw")>=0){
                top.mainWin.document.location = "vod_portal_pre.jsp?leefocus=xx";
            }else{
                top.mainWin.document.location = "vod_portal.jsp?leefocus=xx";
            }
        }else if (keycode == 0x0116){
            top.mainWin.document.location = "vod_search.jsp";
        }else{
            top.doKeyPress(evt);
        }
    }
    function showChannelNumber(channelNum)
    {
        if (channelNum != null && channelNum != undefined)
        {
            if(typeof(_windowframe) == "object"){
                _windowframe.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
            }else{
                top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
            }
        }
    }
    function enableNumKey(){
        for(var j = 0; j < 10; j++){
            top.keyFuncArray[top.keyCodeArray["onKeyNumChar"] + j] = "onKeyNumChar";
        }
    }

    function clearChannelNumber(){
        if(typeof(_windowframe) == "object"){
            _windowframe.document.all.channelNumber.innerHTML = "";
        }else{
            top.mainWin.document.all.channelNumber.innerHTML = "";
        }
    }

    function keypress(evt){
        var keycode = evt.which;
        if(keycode == 0x0110){
          /*  if("CTCSetConfig" in Authentication)
            {
                //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
                //alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            top.mainWin.document.location = "portal.jsp";
        }else if(keycode == 36){;
            top.mainWin.document.location = "portal.jsp";
        }else{
            top.doKeyPress(evt);
        }
    }

    document.onkeypress = keypress;
    _showWindow();//首次进入
    reshowReminderWindow();

    enableNumKey();
</script>