<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtility" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@	page contentType="text/html; charset=GBK" %>

<%
	String queryString = request.getQueryString();
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
    Calendar canlandar2 = Calendar.getInstance();
//    canlandar2.add(Calendar.DAY_OF_WEEK,1);
    Date date= canlandar2.getTime();
    String dateStr = df.format(date);
    List list = new ArrayList();
    List list1 = new ArrayList();
    List showlist = new ArrayList();
    List showlist1 = new ArrayList();
    int pre= EpgUtility.checkString2int(String.valueOf(param.get("timeprev")), 7)+1;
    int next=EpgUtility.checkString2int(String.valueOf(param.get("timenext")),7);
    //System.out.println("start-------------------------pre="+pre);
    //System.out.println("start-------------------------next="+next);
    String reldate = "";
    String reldate11 = df1.format(date);

//    System.out.println("SSSSSSSSSSSSSSSSSSSSSSSreldate11="+reldate11);

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


//    System.out.println("SSSSSSSSSSSSSSSSSSSSSSchannel_onedetail_tvod_pre.jsp="+queryString);
%>
<html>
<head>
	<meta http-equiv="pragma"   content="no-cache" />  
	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate" />  
	<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT" />
    <epg:PageController name="channel_onedetail_tvod_pre.jsp"/>
    <title>portal</title>
    <script language="javascript" type="">
        var _windowframe = window.getWindowByName("tvod");
        var  dateallarr=[];
        var  datearr=[];
        <%for(int i=showlist.size()-1,c=0;i>=0;i--,c++){%>
        dateallarr[<%=c%>] = "<%=showlist.get(i)%>";
        datearr[<%=c%>] = "<%=list.get(i)%>";
        <%}%>
        function _showWindow(){
			if(typeof(_windowframe) != "object"){
                _windowframe = window.open('channel_onedetail_tvod.jsp?isnewopen=1&<%=queryString%>','tvod','width=1280,height=720,top=0,left=0, toolbar=no, menubar=no, scrollbars=auto, resizable=no, location=no,depended=no, status=no');
                _windowframe.setWindowFocus();
                top.showOSD(2,0,0);
                top.setBwAlpha(0);
			}else{
                _windowframe.show();
                _windowframe.setWindowFocus();
                _windowframe._window = top;
				top.showOSD(2,0,0);
                top.setBwAlpha(0);
                <%
                if (lastfocus != "" && lastfocus != null){

                }else{
                %>
                _windowframe.topmenucurrpage=<%=topcurpage%>;
                _windowframe.topmenuallpage=<%=topallpage%>;
                _windowframe.toplastpage = <%=toplastpage%>;
                _windowframe.topfirstpage = <%=topfirstpage%>;
                _windowframe.dateallarr1 = dateallarr;
                _windowframe.datearr1 = datearr;
                _windowframe.toplast = <%=next%7%>;
                _windowframe.topfirst = <%=pre%7%>;
                _windowframe.number_java = <%=number%>;
                _windowframe.pre_java = <%=pre%>;
                _windowframe.reldate11_java = "<%=reldate11%>";
                _windowframe.now_year_mon_date = "<%=df.format(new Date())%>";
                _windowframe.curcolumnid="<%=columnId%>";
                _windowframe.curchannelid="<%=channelId%>";
                _windowframe.reldate = "<%=reldate%>";
                _windowframe.focustr="<%=focusstr%>";
                _windowframe.curDate="<%=reldate1%>";
                _windowframe.number = <%=number1%>;
                _windowframe.controltopmenupage=0;
                _windowframe.focuspage=0;
                _windowframe.turnpage = 0;
                _windowframe.otherpage = 1;
                _windowframe.init();
                <%
                }
                %>

                clearChannelNumber();
			}
		}
    </script>
</head>

<body bgcolor="transparent" onunload="hidePortal();">
<%@include file="inc/lastfocus_window.jsp" %>
</body>
</html>