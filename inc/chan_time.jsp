<%
	int userLimited_1 = ui.getLevelvalue();
     //begin add by zt at 2010-5-20 for modify ղƵб
    //String channelistmode = ui.getChannelListMode();//USERINFOлȡƵбģʽ
    String channelistmode = "0";
    //String channleDatasource = "ChannelDecorator";
//    if(channelistmode.equals("1"))
//    {
//        channleDatasource="ChannelFavoriteDecorator";
//    }
     //end  add by zt at 2010-5-20 for modify ղƵб
	String channelId = request.getParameter(EpgConstants.CHANNEL_ID);
	channelId = channelId == null ? "" : channelId;
	SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd");
	SimpleDateFormat formatOutputHour = new SimpleDateFormat("HH:mm");
	SimpleDateFormat formatOutputMM = new SimpleDateFormat("MM");
	SimpleDateFormat formatOutputDD = new SimpleDateFormat("dd");
	SimpleDateFormat formaterAll = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	String todayTime = formatOutput.format(date);
	String dateString = request.getParameter(EpgConstants.DATE);
	dateString = dateString == null ? todayTime : dateString;
	String todayTimeHour = formatOutputHour.format(date);
    String todayMM= dateString.substring(5,7);
    String todayDD =  dateString.substring(8,10);
	String curTime = formaterAll.format(date);
//	String timeString = "";
//	if("01".equals(todayMM)){
//		timeString = W_January;
//	}else if("02".equals(todayMM)){
//		timeString = W_February;
//	}else if("03".equals(todayMM)){
//		timeString = W_March;
//	}else if("04".equals(todayMM)){
//		timeString = W_April;
//	}else if("05".equals(todayMM)){
//		timeString = W_May;
//	}else if("06".equals(todayMM)){
//		timeString = W_June;
//	}else if("07".equals(todayMM)){
//		timeString = W_July;
//	}else if("08".equals(todayMM)){
//		timeString = W_August;
//	}else if("09".equals(todayMM)){
//		timeString = W_September;
//	}else if("10".equals(todayMM)){
//		timeString = W_October;
//	}else if("11".equals(todayMM)){
//		timeString = W_November;
//	}else if("12".equals(todayMM)){
//		timeString = W_December;
//	}
//	if(dateString.equals(todayTime)){
//		timeString = W_Today + "," + timeString;
//	}
	if(!"".equals(dateString)){
		todayDD = dateString.substring(8,10);
	}
//	timeString = timeString + " " + todayDD;

	String timeCount = String.valueOf(param.get("TIME_COUNT"));
    String interval = String.valueOf(param.get("INTERVAL"));
	String channelRateId = String.valueOf(param.get("channelRateId"));
	int rateId = Integer.parseInt(channelRateId);
	int channelDisNum = Integer.parseInt(channelNum);
	int totalMin = Integer.parseInt(timeCount) * Integer.parseInt(interval);
	String span="48";
	
	  String starthour = request.getParameter(EpgConstants.START_HOUR);
	  if (starthour == null) {
		starthour = "";
	  }
	  String endhour = request.getParameter(EpgConstants.END_HOUR);
	  if (endhour == null) {
		endhour = "";
	  }


	StringBuffer prevday = new StringBuffer(150);
	StringBuffer tempStr = new StringBuffer(150);
	//next day url
    StringBuffer nextday = new StringBuffer(150);
    prevday.append(pageName).append("?")
	.append(EpgConstants.COLUMN_ID).append("=").append(columnId)
	.append("&").append(EpgConstants.DATE).append("=").append("{prevdate}");

	nextday.append(pageName).append("?")
	.append(EpgConstants.COLUMN_ID).append("=").append(columnId)
	.append("&").append(EpgConstants.DATE).append("=").append("{nextdate}");
	
	if("channel_bytime.jsp".equals(pageName)){
		 tempStr.append("&").append(EpgConstants.TIME_COUNT).append("=").append(timeCount)
		.append("&").append(EpgConstants.INTERVAL).append("=").append(interval)
		.append("&").append(EpgConstants.START_HOUR).append("=").append(starthour)
		.append("&").append(EpgConstants.END_HOUR).append("=").append(endhour)
        .append("&isqucikmenu=").append(isqucikmenu);
	}else{
		tempStr.append("&").append(EpgConstants.CHANNEL_ID).append("=").append(channelId);
	}
	
   if(request.getParameter("destpage") != null){
	   tempStr.append("&destpage=").append(request.getParameter("destpage"))
		   .append("&numperpage=").append(request.getParameter("numperpage"))
		   .append("&pagecount=").append(request.getParameter("pagecount"));
   }

   prevday.append(tempStr);
   nextday.append(tempStr);

  prevday.append("&leefocus=preday").append("&fcolumnId=").append(request.getParameter("fcolumnId"))
        .append("&goNum=").append(request.getParameter("goNum"));
  String prevdayUrl = prevday.toString();

  nextday.append("&leefocus=nextday").append("&fcolumnId=").append(request.getParameter("fcolumnId"))
        .append("&goNum=").append(request.getParameter("goNum"));
  String nextdayUrl = nextday.toString();

	String destpage = request.getParameter("destpage");//curpage
	destpage = destpage == null ? "1" : destpage;
    String inputStrDate = request.getParameter("date");
    if (null==inputStrDate||inputStrDate.equals("")) {
        inputStrDate = todayTime;
    }
     String selectedChan= request.getParameter("selectedChan");  // represent current channel when change date

	int canNext = 1;
	int canPrex = 1; 

	int canLeft = 1;
	int canRight = 1;

	if(!"".equals(dateString) && "channel_bytime.jsp".equals(pageName))
	{
		try
		{
		String sYear = dateString.substring(0,4);
		String sMonth = dateString.substring(5,7);
		String sDay = dateString.substring(8,10);
		//System.out.println(date);
		//System.out.println(sYear+",sMonth="+sMonth+",sDay="+sDay);

		int year = Integer.parseInt(sYear);
		int month = Integer.parseInt(sMonth);
		int day = Integer.parseInt(sDay);

		String timeprev = String.valueOf(param.get("timeprev"));
		String timenext = String.valueOf(param.get("timenext"));
	
		int preMaxDay =Integer.parseInt(timeprev);
		int nextMaxDay = Integer.parseInt(timenext);

		Calendar now = Calendar.getInstance();
		now.set(Calendar.YEAR, year);
		now.set(Calendar.MONTH, month-1);
		now.set(Calendar.DAY_OF_MONTH, day);

		Calendar timePrevMax = Calendar.getInstance();
		timePrevMax.set(Calendar.DAY_OF_MONTH, timePrevMax.get(Calendar.DAY_OF_MONTH)+preMaxDay);


		Calendar timeNextMax = Calendar.getInstance();
		timeNextMax.set(Calendar.DAY_OF_MONTH, timeNextMax.get(Calendar.DAY_OF_MONTH)-nextMaxDay);
		
		int leftHour = 0;//timePrevMax.get(Calendar.HOUR_OF_DAY);
		int rightHour = 24;//timeNextMax.get(Calendar.HOUR_OF_DAY);

		int beginHour = 3;
		int endHour = 3 ;

		try
		{
			beginHour = Integer.parseInt(starthour);
			endHour = Integer.parseInt(endhour);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}

		if(now.before(timePrevMax))
		{
			canNext = 1;			
		}
		else
		{
			canNext = 0;
		}
		
		if(timeNextMax.before(now))
		{
			canPrex = 1;
		}
		else
		{
			canPrex = 0;
		}

		if(endHour <  rightHour || canNext == 1)
		{
			canRight = 1;
		}
		else
		{
			canRight = 0;
		}
		if(beginHour >  leftHour || canPrex == 1)
		{
			canLeft = 1 ;
		}
		else
		{
			canLeft = 0 ;
		}

		
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	//int mixNo = getChannelMixNo(channelId,request);
    int mixNo = -1;
    Map channelInfo =  getChannelMixno(pageContext, channelId);
    if(channelInfo != null){
        mixNo = Integer.parseInt(String.valueOf(channelInfo.get("usermixno")));
    }
	//String record_type = (String)application.getAttribute("RECORD_TYPE");
	String record_type = (String)session.getAttribute("RECORD_TYPE");
	record_type = record_type == null ? "NPVR" : record_type;
	//System.out.println("======7777777777777==========" + mixNo);
%>
<%--<script language="javascript" type="">--%>
	 <%--var prevdate = "";--%>
	 <%--var nextdate = "";--%>
	 <%--var prevDayURL = "";--%>
	 <%--var nextDayURL = "";--%>
<%--</script>--%>

	<!-- Yesterday/Tomorrow -->
    <epg:out datasource="DateDecorator">
	<div style="left:380; top:380;width:18;height:18; position:absolute">
		<a href="javascript:lastday();" name="preday"
		accesskey="a"></a>
	</div>
	<div style="left:490; top:380;width:18;height:18; position:absolute">
        <a href="javascript:nextday();" name="nextday"
		accesskey="s"></a>
	</div>
      <%--<script language="javascript" type="">--%>
         <%--prevdate = "{prevdate}";--%>
         <%--nextdate = "{nextdate}";--%>
		 <%--var currentdate = "{currentdate}";--%>
		 <%--prevDayURL = "<%=prevdayUrl%>";--%>
		 <%--nextDayURL = "<%=nextdayUrl%>";--%>
      <%--</script>--%>
	</epg:out>

<%--<script language="javascript" type="">--%>
<%--</script>--%>