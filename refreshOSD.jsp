<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<html>
<meta name="page-view-size" content="1280*720">
<head>
</head>
<body bgcolor="transparent" onLoad="pageInit()">
<%--<div style="visibility:hidden;left:550; top:50; width:90; height:100; position:fixed" id="channelNumber">--%>
<%--4K��ʾ--%>
<div id="alert_text" style="position:absolute; left: 424px; top: 242px; width: 432px; height:234px; visibility:hidden;"><img src="images/4kjump.png" width="432" height="234"/></div>


<%!
    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }
%>
<%
        String path = getPath(request.getRequestURI());
%>

<div style="left:78%; top:7%; width:90; height:100; position:fixed" id="channelNumber"></div>

<!-- ������Ļ -->
<div id="marquee1" style="position:absolute; width:1280px; height:55px; top:0px; left:0px; font-size:28px;color:#FFFFFF; visibility:hidden;"><img src="images/scroll_bg.png" width="1280" height="55"></div>
<div id="scroll_text" style="position:absolute; width:1280px; height:50px; top:11px; left:3px; font-size:28px;color:#FFFFFF; visibility:hidden;">
	<marquee  direction='left' behavior='scroll' scrollamount='6' loop='5' width='1280'>
�𾴵��û������տ������ڸ������ݣ�����Կ�1���ӣ��Կ������󽫵���������ʾ����������Ч���ڿ������տ�����ϸ�ʷѼ�����ҳ�档</marquee>
</div>
<div id="scroll_text2" style="position:absolute; width:1280px; height:50px; top:11px; left:3px; font-size:28px;color:#FFFFFF; visibility:hidden;">    
<marquee  direction='left' behavior='scroll' scrollamount='6' loop='5' width='1280'>
��DOGTV���ֽ׶���ѹۿ�������2017��6��1����ʽ�շѣ�����ı�������һ�ݶ�ͯ�����</marquee>
</div>

<script language="javascript">
    function $(id){
        return document.getElementById(id);
    }

    //��������˵Ļ�����  ����Ҫƴ��h1��ʽ
    var tagHead = "<h1>";
    var tagTail = "</h1>";
    if (window.navigator.appName.indexOf("ztebw") == -1) {
        tagHead = "";
        tagTail = "";
    }
    var FONTHEAD = "<font color='00FF00' size='8' >" + tagHead;
    var FONTTAIL = tagTail + "</font>";

    var ch = "<%=request.getParameter("channelNumber")%>";
    var Channel_no = top.channelInfo.currentChannel;//��ȡ��ǰƵ����
	var authResult = (top.channelInfo.currentChannel > 0) ? top.channelIsExistInAuthList(parseInt(top.channelInfo.currentChannel, 10)) : -1;
//Ƶ���Ƿ񶩹����ؽ�� 0��Ȩʧ�� 1��Ȩͨ��
    
	//var timer1 = null;
	var disTime;
	var timer;
	function showmarquee(){	
	    // clearTimeout(timer1);
		if(authResult == 0){
			disTime = top.jsGetControl("preMillisecond");
			$("scroll_text").style.visibility="visible";
		 	$("marquee1").style.visibility="visible";
			//$("inversetime").style.visibility="visible";
			//timer = setTimeout("hidden_scorll()",disTime);
			timer = setTimeout("hidden_scorll()",parseInt(disTime));
		}	 
	}
    function hidden_scorll(){	
	   $("scroll_text").style.visibility="hidden";
	   $("marquee1").style.visibility="hidden";
	  // $("inversetime").style.visibility="hidden";
	   clearTimeout(timer);	 
	}	
    function hidden_scorll2(){   
       $("scroll_text2").style.visibility="hidden";
       $("marquee1").style.visibility="hidden";
      // $("inversetime").style.visibility="hidden";
       clearTimeout(timer);  
    }

    function setChannelNumPos() {
        top.mainWin.document.all.channelNumber.style.visibility = "visible";
    }

    function showChannelNumber(channelNum) {
        var temChannelNum = parseInt(channelNum);
        if (channelNum != null && channelNum != undefined && channelNum != "null")
        {
            top.mainWin.document.all.channelNumber.innerHTML = FONTHEAD + channelNum + FONTTAIL;
        }
    }

    function clearChannelNumber() {
        top.jsDebug(" clearChannelNumber ");
        top.mainWin.document.all.channelNumber.innerHTML = "";
    }
/**
 * 4K
 */
    var stbType= Authentication.CTCGetConfig("STBType");
    if(stbType==null||stbType==undefined||typeof stbType=="undefined"){
		stbType= Authentication.CUGetConfig("STBType");
	}
	
    function pageInit() {
        top.enablekey();
        setChannelNumPos();
        showChannelNumber(ch);
		/*if(Channel_no == 36){
			disTime = 170000;
			//$("marquee").innerHTML="";
			//timer1 = setTimeout("showmarquee()",500);
			showmarquee();
		}*/
        /*if(Channel_no == 307){
            disTime = 170000;
            //timer1 = setTimeout("showmarquee()",500);
            disTime = top.jsGetControl("preMillisecond");
            $("scroll_text2").style.visibility="visible";
            $("marquee1").style.visibility="visible";
            //$("inversetime").style.visibility="visible";
            //timer = setTimeout("hidden_scorll()",disTime);
            timer = setTimeout("hidden_scorll2()",parseInt(disTime));
        }*/
		//��4K�����в���40Ƶ��ʱ��������ʾ������Ļ��
		if(stbType != "EC6108V9U_pub_bjjlt" && stbType != "Q1" && stbType != "B860A" && stbType != "HG680-JLGEH-52" && stbType != "Q5" && stbType != "EC5108" && stbType != "B860AV1.2" && stbType != "Q7" && stbType != "S-010W-A" && stbType != "DTTV100"&& stbType != "EC6108V9U_ONT_bjjlt"){
			if(Channel_no != 40){
				showmarquee(); 
			}
		}else{
			showmarquee(); 
		}
        
    }


    function onKeyOK() {//��ת��channal_mini.jsp  
        var currCh = parseInt(top.channelInfo.currentChannel, 10); 
        /*var del_tv_pro_num = [37,38,39];//����Ƶ��
        var isdel=0;
        for(var i=0;i<del_tv_pro_num.length;i++){
            if(parseInt(del_tv_pro_num[i],10) == parseInt(currCh,10)){
                isdel =1;
                break;
            }    
        }
        if(isdel == 0){ */
            top.mainWin.document.location = "<%=path%>channel_mini.jsp";
            top.showOSD(2, 0, 0);
            top.setBwAlpha(0);
       // }
    }
	
	function channelKeyPress(evt){
		var keyCode = parseInt(evt.which);
		if(keyCode == 0x0026 || keyCode==0x0101)//onKeyUp
		{       
            top.remoteChannelPlus();
    	} 
		else if(keyCode == 0x0028 || keyCode==0x0102)//onKeyDown
		{  
            top.remoteChannelMinus();
		}
		else if(keyCode == 0x000D)//onKeyOK
		{
			onKeyOK();  
		}
		else if(keyCode == 0x0110 || keycode == 36){
           /* if("CTCSetConfig" in Authentication)
            {
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CTC");
                Authentication.CTCSetConfig("KeyValue","0x110");
            }else{
               // alert("SSSSSSSSSSSSSSSSSSSSSSSS0x110_CU");
                Authentication.CUSetConfig("KeyValue","0x110");
            }*/
            top.mainWin.document.location = "portal.jsp";
            top.showOSD(2, 0, 0);
        }else if(keyCode == 36){
            top.mainWin.document.location = "portal.jsp";
            top.showOSD(2, 0, 0);
        }else{
            top.doKeyPress(evt);
            return true;  
        }
        return false;
    }
         document.onkeypress = channelKeyPress;
         focus();//��ȡ����

    if(stbType != "EC6108V9U_pub_bjjlt" && stbType != "Q1" && stbType != "B860A" && stbType != "HG680-JLGEH-52" && stbType != "Q5" && stbType != "EC5108" && stbType != "B860AV1.2" && stbType != "Q7" && stbType != "S-010W-A" && stbType != "EC6108V9U_ONT_bjjlt" && stbType != "DTTV100"){
        // top.doStop();//����
        // top.doLeaveChannel();
		if(Channel_no == 401 || Channel_no == 40) {
			 if(window.navigator.appName.indexOf("ztebw") >= 0){
          		top.doLeaveChannel();
       		 }
			$("alert_text").style.visibility = "visible";
		}
        // alert("into refreshOSD.jsp  & the STB channel is 4K!!!");
    }       
        
    
</script>

</body>
</html>

