<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%--<%@ page import="com.zte.iptv.epg.content.QueryPagesImpApp" %>--%>
<%@page import="java.util.*"%>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneDataSource" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.newepg.decorator.ChannelOneForeshowDecorator" %>
<%@ page import="com.zte.iptv.epg.util.EpgServiceAccess" %>
<%!
    public int playUrl(String startime, String endtime) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
        int pvrState = 2;
        try {
            Date sTime = sdf.parse(startime.toString());
            Date eTime = sdf.parse(endtime.toString());
            Date nTime = new Date();
            if (nTime.after(eTime)) pvrState = 3;
            if (sTime.after(nTime)) pvrState = 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pvrState;
    }
%>
<%
    int pageCount ;
    int totalCount ;
    int numberperpage1 = 9;
	SimpleDateFormat sdfhm = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
    UserInfo userInfo = (UserInfo)pageContext.getSession().getAttribute(EpgConstants.USERINFO);
	String columnId = request.getParameter(EpgConstants.COLUMN_ID);
    String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
    String startTime = request.getParameter("starttiem");
    String endTime = request.getParameter("endtime");
    String dateString = request.getParameter("curdate");
    String destpage = request.getParameter("destpage");
    String index = request.getParameter("index");
    int dataIndex = 0;
    if(index != null && !"".equals(index)){
         dataIndex = Integer.parseInt(index);
    }
    int destpage1=1 ;
    if(destpage != null && !"".equals(destpage)){
        try{
             destpage1 = Integer.parseInt(destpage);
        }catch (Exception e){
            System.out.println("destpage youwenti!!!!!");
            e.printStackTrace();
        }
    }
    //System.out.println("---------------------->columnId="+columnId);
    //System.out.println("---------------------->channelId="+channelId);
    //System.out.println("---------------------->destpage="+destpage);
    //out.println("---------------------->startTime="+startTime);
    //out.println("---------------------->endTime="+endTime);
    //out.println("---------------------->dateString="+dateString);
	
%>
<epg:PageController />
<%
    ChannelOneDataSource cod = new ChannelOneDataSource();
    ChannelQueryValueIn oneValueIn = (ChannelQueryValueIn)cod.getValueIn();
    oneValueIn.setUserInfo(userInfo);
    oneValueIn.setColumnId(columnId);
    oneValueIn.setChannelId(channelId);
    EpgResult es =cod.getData();
    ChannelInfo ci = (ChannelInfo)es.getDataAsInfo();

    String ChannelNo = ci.getMixNo()+"";
    String ChannelCode =ci.getChannelId();
    String ChannelName = ci.getChannelName();

	ChannelOneForeshowDataSource oneFs=new ChannelOneForeshowDataSource();
	ChannelForeshowQueryValueIn valueIn= (ChannelForeshowQueryValueIn)oneFs.getValueIn();
	valueIn.setUserInfo(userInfo);
	valueIn.setDate(dateString);
    valueIn.setStartTime(startTime);
	valueIn.setEndTime(endTime);
	valueIn.setColumnId(columnId);
	valueIn.setChannelId(channelId);



	String endtime = "";
	String prevueidTemp = "";
	String sTimeTemp = "";
	String eTimeTemp = "";
    String state="";
    String date="";
    String curProgramName ="";
    String startime = "";
    String contentid="";
    String playurl="";
    String playable ="";
    String recordsystem = "";
	String strCurTime = sdfhm.format(new Date());
	String strEndTime = "";
    int size = 0;
    List ChannelInfoList = new ArrayList();

	try{
		EpgResult result=oneFs.getData();
		ChannelOneForeshowDecorator oneDs=new ChannelOneForeshowDecorator();
		EpgResult trueResult=oneDs.decorate(result);
		Map dataOut = (Map) trueResult.getDataOut().get(EpgResult.DATA);

		if (dataOut != null) {
			List oneProgramNameV= (Vector)dataOut.get("Programname");
			List oneStartTimeV=(Vector)dataOut.get("StartTimeF");
			List oneEndTimeV=(Vector)dataOut.get("EndTimeF");
            List oneStartTime=(Vector)dataOut.get("StartTime");
			List oneEndTime=(Vector)dataOut.get("EndTime");
			List onePrevueidV = (Vector)dataOut.get("Prevueid");
			List oneContentId = (Vector)dataOut.get("ContentId");
            List vplayable = (Vector)dataOut.get("IsPlayable");//IsPlayable_playable
            List isVrecordsystem=(Vector)dataOut.get("Recordsystem");
            size = oneProgramNameV.size();

	        int startIndex = 0;
	        int endIndex = 0;
//	        startIndex = numberperpage1*(destpage1-1);
//	        endIndex = numberperpage1*destpage1-1;

//	        if(endIndex>(size-1)){
//	            endIndex = size-1;
//	        }

//	        pageCount = (size+numberperpage1-1)/numberperpage1;
            if (size > 0) {
                pageCount = (size - 1) / numberperpage1 + 1;
            } else {
                pageCount = 0;
            }
	        StringBuffer sb = new StringBuffer();
	        sb.append("{pageCount:\""+pageCount+"\",destpage:\""+1+"\",mixno:\""+ChannelNo+"\",channelname:\""+ChannelName+"\", channelData:[");
//			for(int i=startIndex;i<=endIndex;i++) {
            for (int i = 0; i < size; i++) {
                startime = (String)oneStartTimeV.get(i);
				endtime = (String)oneEndTimeV.get(i);
				prevueidTemp = String.valueOf(onePrevueidV.get(i));
				curProgramName = (String)oneProgramNameV.get(i);
                contentid=(String)oneContentId.get(i);
                playable = String.valueOf(vplayable.get(i));
                recordsystem = String.valueOf(isVrecordsystem.get(i));
                /*
                try {
                    String sqlStr = "select * from channelprevue where state<>50 and prevueid=" + prevueidTemp;
                    Vector<Hashtable> rs = new Vector<Hashtable>();
                    rs = QueryPagesImpApp.doQuery(EpgServiceAccess.EPG_DB_ALIAS, sqlStr);
                    int totalSize = rs.size();
                    if (totalSize > 0) {
                        Hashtable ht = rs.get(0);
                        contentid = (String) ht.get("contentcode");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                */
                strEndTime = dateString+" "+endtime;
				if(strCurTime.compareTo(strEndTime) > 0 || strCurTime.compareTo(strEndTime) == 0){
					int flag=playUrl(String.valueOf(oneStartTime.get(i)),String.valueOf(oneEndTime.get(i)));
					if(flag==3 && "true".equals(playable) && "1".equals(recordsystem)){
					  playurl="channel_tvod_auth.jsp?"
							  +"columnid="+columnId
							  +"&prevueid="+prevueidTemp
							  +"&programid="+contentid
							  +"&contentCode="+contentid
							 // +"&ContentType=2"
							  +"&ContentType=4"
							  +"&CategoryID="+columnId
							  +"&ContentID="+ChannelCode
							  +"&FatherContent="+ChannelCode
							  +"&type=tvod"
							  +"&channelid="+ChannelCode;
					}else{
					  playurl="channel_play.jsp?mixno="+ChannelNo;
					}
				
					sb.append("{startime:\""+startime+"\",");
					sb.append("endtime:\""+endtime+"\",");
					sb.append("playUrl:\""+playurl+"\",");
					sb.append("curProgramName:\""+curProgramName+"\"}");
					if (i < size - 1) {
						sb.append(",");
					}
				}				
        	}
	        sb.append("]}");
//            System.out.println(">>>>>channel tvod>>>>>>size>>>>>>>>" + size);
//            System.out.println(">>>>>>channel tvod>>>>>sb.toString()>>>>>>>>" + sb.toString());
//            if(startTime!=null && startTime.equals("00:00")){
//                sb = new StringBuffer("{pageCount:\"1\",destpage:\"1\",mixno:\"3\",channelname:\"广东卫视\", channelData:[{startime:\"15:50\",endtime:\"16:00\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=357&programid=00000000040000000357&contentCode=00000000040000000357&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样23\"},{startime:\"16:10\",endtime:\"16:20\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=358&programid=00000000040000000358&contentCode=00000000040000000358&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样24\"},{startime:\"16:30\",endtime:\"16:40\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=359&programid=00000000040000000359&contentCode=00000000040000000359&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样25\"},{startime:\"16:50\",endtime:\"17:40\",playUrl:\"channel_play.jsp?mixno=3\",curProgramName:\"幸福的像花儿一样26\"}]}");
//            }else if(startTime!=null && startTime.equals("08:00")){
//                sb = new StringBuffer("{pageCount:\"3\",destpage:\"1\",mixno:\"3\",channelname:\"广东卫视\", channelData:[{startime:\"10:33\",endtime:\"10:38\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=333&programid=&contentCode=&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"雪山飞狐\"},{startime:\"10:40\",endtime:\"10:44\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=334&programid=00000000040000000334&contentCode=00000000040000000334&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"雪山飞狐\"},{startime:\"10:48\",endtime:\"10:52\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=335&programid=00000000040000000335&contentCode=00000000040000000335&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样1\"},{startime:\"10:54\",endtime:\"10:58\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=336&programid=00000000040000000336&contentCode=00000000040000000336&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样2\"},{startime:\"11:02\",endtime:\"11:08\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=337&programid=00000000040000000337&contentCode=00000000040000000337&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样3\"},{startime:\"11:10\",endtime:\"11:12\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=338&programid=00000000040000000338&contentCode=00000000040000000338&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样4\"},{startime:\"11:15\",endtime:\"11:18\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=339&programid=00000000040000000339&contentCode=00000000040000000339&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样5\"},{startime:\"11:21\",endtime:\"11:25\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=340&programid=00000000040000000340&contentCode=00000000040000000340&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样6\"},{startime:\"11:30\",endtime:\"11:40\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=341&programid=00000000040000000341&contentCode=00000000040000000341&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样7\"},{startime:\"11:42\",endtime:\"11:50\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=342&programid=00000000040000000342&contentCode=00000000040000000342&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样8\"},{startime:\"11:52\",endtime:\"11:58\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=343&programid=00000000040000000343&contentCode=00000000040000000343&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样9\"},{startime:\"12:12\",endtime:\"12:15\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=344&programid=00000000040000000344&contentCode=00000000040000000344&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样10\"},{startime:\"12:18\",endtime:\"12:25\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=345&programid=00000000040000000345&contentCode=00000000040000000345&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样11\"},{startime:\"12:30\",endtime:\"12:35\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=346&programid=00000000040000000346&contentCode=00000000040000000346&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样12\"},{startime:\"12:42\",endtime:\"12:52\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=347&programid=00000000040000000347&contentCode=00000000040000000347&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样13\"},{startime:\"12:55\",endtime:\"13:00\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=348&programid=00000000040000000348&contentCode=00000000040000000348&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样14\"},{startime:\"13:05\",endtime:\"13:10\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=349&programid=00000000040000000349&contentCode=00000000040000000349&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样15\"},{startime:\"13:15\",endtime:\"14:00\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=350&programid=00000000040000000350&contentCode=00000000040000000350&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样16\"},{startime:\"14:10\",endtime:\"14:15\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=351&programid=00000000040000000351&contentCode=00000000040000000351&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样17\"},{startime:\"14:17\",endtime:\"14:20\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=352&programid=00000000040000000352&contentCode=00000000040000000352&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样18\"},{startime:\"14:26\",endtime:\"14:36\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=353&programid=00000000040000000353&contentCode=00000000040000000353&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样19\"},{startime:\"14:40\",endtime:\"14:50\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=354&programid=00000000040000000354&contentCode=00000000040000000354&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样20\"},{startime:\"15:10\",endtime:\"15:20\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=355&programid=00000000040000000355&contentCode=00000000040000000355&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样21\"},{startime:\"15:30\",endtime:\"15:40\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=356&programid=00000000040000000356&contentCode=00000000040000000356&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样22\"},{startime:\"15:50\",endtime:\"16:00\",playUrl:\"channel_tvod_auth.jsp?columnid=0900&prevueid=357&programid=00000000040000000357&contentCode=00000000040000000357&ContentType=2&CategoryID=0900&ContentID=ch12042316504954674723&FatherContent=ch12042316504954674723&type=tvod&channelid=ch12042316504954674723\",curProgramName:\"幸福的像花儿一样23\"}]}");
//            }else{
//                sb = new StringBuffer("{pageCount:\"0\",destpage:\"1\",mixno:\"3\",channelname:\"广东卫视\", channelData:[]}");
//            }

//            System.out.println("SSSSSSSSSSSSSSSSSSSSsb="+sb.toString());
	        JspWriter ot = pageContext.getOut();
		    ot.write(sb.toString());
	    }
    }catch (Exception e){
        System.out.println("channel play for show programinfo error!!!");
        e.printStackTrace();
    }
%>
