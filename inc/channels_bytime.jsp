<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page import="com.zte.iptv.newepg.datasource.*" %>
<%@page import="com.zte.iptv.epg.util.*" %>
<%@page import="com.zte.iptv.epg.web.*" %>
<%@page import="com.zte.iptv.epg.content.*" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="com.zte.iptv.functionepg.datasource.AuthAndShowProductListDataSource"%>
<%@page import="com.zte.iptv.functionepg.web.AuthQueryValueIn"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
//    System.out.println("===inc/channels_bytime  ***************************" + request.getQueryString());
	String date1 = (String)request.getParameter("date");//"2010.12.16";
    if(null == date1||"".equals(date1)){
        SimpleDateFormat formatOutput_1 = new SimpleDateFormat("yyyy.MM.dd");
        date1 = formatOutput_1.format(new Date());
    }
	//String columnId = (String)request.getParameter(EpgConstants.COLUMN_ID);//"02";
	//String langType = "en"; //(String)request.getParameter("langType");//"en";
	//String channelId =  (String)request.getParameter(EpgConstants.CHANNEL_ID);//"ch11011721071978071846"; //
	String strpage =(String)request.getParameter("destpage");//page
	//String numEverytime = (String)request.getParameter("numperpage");//page
    String numEverytime = channelNum;//page
	String isFavColumn = "channelColumn";//(String)request.getParameter("isFavColumn");//page
	String getAll = (String)request.getParameter("getAll");
	String tomoFullTime = (String)request.getParameter("tomoFullTime");
	String number2start_s = (String)request.getParameter("number2start");
    int number2start = 0;
    if(number2start_s !=null && !number2start_s.equals("")){
        number2start = Integer.parseInt(number2start_s);
    }
	UserInfo userInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);

	String[][] channelObjectArr = null; //new String[5][11];
	String finalChannelObjectArr = null;		
	String[] programObjectArr = null;
	String finalProgramObjectArr = null;
	String[] allProgramObjectArr = null;
	int channelTotal = 0;
	try {
		EpgPagingDataSource dataSource = null;
        List alllist = new ArrayList();

            ColumnDataSource columnDs = new ColumnDataSource();
            ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
            valueIn.setUserInfo(userInfo);
            valueIn.setColumnId(columnId);
            EpgResult result = columnDs.getData();
            List vColumnData = (Vector) result.getData();

            String oColumnid = "";
            int length = vColumnData.size();
            ColumnInfo columnInfo = null;
            Vector allmultiChans= null;
            ChannelForeshowQueryValueIn cvalueIn = null;
            List cvalueInList = new ArrayList();
            ChannelForeshowDataSource chanshowds = null;

            if(length>0){
                for(int i=0; i<length; i++){
                     columnInfo = (ColumnInfo)vColumnData.get(i);
                     oColumnid  = columnInfo.getColumnId();
                     dataSource = new ChannelForeshowDataSource();
                     ChannelForeshowQueryValueIn channelValueIn = (ChannelForeshowQueryValueIn)dataSource.getValueIn();
                     channelValueIn.setColumnId(oColumnid);
                     channelValueIn.setDate(date1);
                     channelValueIn.setStartTime("00:00");
                     channelValueIn.setEndTime("23:59");
                     channelValueIn.setUserInfo(userInfo);
                     EpgResult cResult = dataSource.getData();
                     if(allmultiChans == null){
                         allmultiChans = (Vector)cResult.getData();
                     }else{
                         allmultiChans.addAll((Vector)cResult.getData());
                     }
                }
            }else if(length == 0){
                     dataSource = new ChannelForeshowDataSource();
                     ChannelForeshowQueryValueIn channelValueIn = (ChannelForeshowQueryValueIn)dataSource.getValueIn();
                     channelValueIn.setColumnId(columnId);
                     channelValueIn.setDate(date1);
                     channelValueIn.setStartTime("00:00");
                     channelValueIn.setEndTime("23:59");
                     channelValueIn.setUserInfo(userInfo);
                     EpgResult cResult = dataSource.getData();
                     allmultiChans = (Vector)cResult.getData();
            }


        int strpage1=1;

		if(strpage != null && !"0".equals(strpage))
		{
			strpage1 = Integer.parseInt(strpage);
		}
//		if(numEverytime != null)
//		{
////            System.out.println("+++++++++++++numEverytime="+numEverytime);
//			valueIn.setNumPerPage(Integer.parseInt(numEverytime));
//		}

		//valueIn.setLangType(langType);



		String actorList = "";
		String channelName = "";
		String channelMarkURL = "";
		String channelColumnId = "";
        int level = 0;
		Integer channelMixNo = 0;
		//String[] channleObjectParam = {"CurPage","PageCount","ChannelId","ChannelName","MarkURL","MixNo","ProgramList","ColumnId","TotalCount","Pipenable","Channeltype","ChannelbasicID"};
		String[] channleObjectValue;
		String channelObject = null;
		List programVector = null;
		String programObject = null;
		ProgramInfo programInfo = null;
		Integer programPrevueId = null;
		String programName = null;
		String programStartTime = null;
		String programEndTime = null;
		String contentDescription = null;
		Integer channeltype = null;
        Integer channelBasicID = null;
        int isCanLock = 0;
        int isLock =0;
        //int rateId = 0;
		//String[] programObjectParam = {"PrevueId","PrevueName","StartTime","EndTime","ContentDescription","SeriesHeadId","IsArchive","State","LevelID","ContentId","Recordsystem","IsTimeshift","startTime_minute","endTime_minute","TimeshiftMode"};
		//String[] programObjectValue;

		if(allmultiChans!=null){
//            System.out.println("===============allmultiChans.size()="+allmultiChans.size());
            Integer totalCount = allmultiChans.size();
			Integer curPage = strpage1;
			Integer pageCount = (totalCount-1)/channelDisNum+1;
            curNum = curPage;
	        sumNum = pageCount;

//            System.out.println("===============pageCount="+pageCount);
            int startindex = (curPage-1)*channelDisNum;
            int endindex = curPage*channelDisNum;
            endindex = (endindex>totalCount)?totalCount:endindex;

//			EpgPaging paging = (EpgPaging)result.getDataOut().get("page");
//			Integer curPage = (Integer)paging.getCurPage();
//			Integer pageCount = (Integer)paging.getPageCount();
//			Integer totalCount = (Integer)paging.getTotalCount();
			//Vector multiChans = (Vector)result.getData();
            List multiChans = allmultiChans.subList(startindex,endindex);
			channelTotal = multiChans.size();
//            System.out.println(channelTotal+"============");
            channelObjectArr = new String[channelTotal][11];
			//channelObjectArr = new String[channelTotal][];
			//allProgramObjectArr = new String[channelTotal];
			int iBeginTime = 0;
			int iEndTime = 0;
			
			int startTime_minute = 0;
			int endTime_minute = 0;
			
			long ss = 0, se = 0, es = 0, ee = 0;
			Date proStartDate = null;
			Date proEndDate = null;
			//SimpleDateFormat formater = new SimpleDateFormat("yyyy.MM.dd HH:mm");
			//SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
			for(int i=0;i<channelTotal;i++)
			{
				ChannelForeshowInfo channelForeshowInfo = (ChannelForeshowInfo) multiChans.get(i);//sunmofei
				if(channelForeshowInfo!=null){
					channelName = (String)channelForeshowInfo.getChannelName();//Channelid
					channelId = (String)channelForeshowInfo.getChannelId();//MarkURL
					channelColumnId = (String)channelForeshowInfo.getFcolumnid();//MarkURL
					channelMarkURL = (String)channelForeshowInfo.getMarkURL();
					channelMixNo = (Integer)channelForeshowInfo.getMixNo();
                    level = channelForeshowInfo.getLevelvalue();
                    isCanLock = channelForeshowInfo.getIsCanLock();
                    isLock = channelForeshowInfo.getIsLock();
                    //rateId = channelForeshowInfo.getRateID();
                    rateId = 1;
					boolean getPipenable = (boolean)channelForeshowInfo.getPipenable();
					channeltype = (Integer)channelForeshowInfo.getChanneltype();
                    //channelBasicID = (Integer)channelForeshowInfo.getChannelbasicID();
                    channelBasicID = 1;
					programVector = (Vector)channelForeshowInfo.getItemList();
					String secondLangChannelName = "";//(String)channelForeshowInfo.getSecondLangChannelName();
					//programObjectArr = new String[programVector.size()];
                    channleObjectValue = new String[]{String.valueOf(curPage),String.valueOf(pageCount), channelId,
                            channelName,channelMarkURL,String.valueOf(channelMixNo),channelColumnId,totalCount+"",
                            getPipenable+"",channeltype + "",channelBasicID+"",
                            level+"",isCanLock+"",""+isLock,""+rateId};
					channelObjectArr[i] = channleObjectValue;
//                    System.out.println(">>>>"+channleObjectValue.toString()+"   "+rateId);
				}	
			}
		}
		//finalChannelObjectArr = (String)getJsonArray(channelObjectArr);
	}
	catch(Exception e)
	{
		System.out.println("------------------------"+e);
	}
    //System.out.println(finalChannelObjectArr);
	//out.print(finalChannelObjectArr);
%>