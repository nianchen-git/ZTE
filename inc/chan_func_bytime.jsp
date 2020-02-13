<%@page import="java.text.*, java.util.*,javax.servlet.http.HttpServlet" %>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%@page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@page import="com.zte.iptv.newepg.datasource.* "%>
<%@page import="com.zte.iptv.epg.util.*" %>
<%@page import="com.zte.iptv.epg.web.*" %>
<%@page import="com.zte.iptv.epg.content.*" %>
<%@page import="com.zte.iptv.newepg.html.*" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="com.zte.iptv.functionepg.datasource.AuthAndShowProductListDataSource"%>
<%@page import="com.zte.iptv.functionepg.web.AuthQueryValueIn"%>
<%@ page import="java.net.URLEncoder" %>
<%@page import="com.zte.iptv.volcano.epg.account.User" %>
<%@ page import="com.zte.iptv.volcano.data.QueryResult"%>
<%@ page import="com.zte.iptv.volcano.epg.constants.NameConstants"%>
<%!
    /**
     * Date formate
     */
    Date parseDate(String inputDate, DateFormat format) {
        Date ret = null;
        do {
            if (null != inputDate && !"".equals(inputDate)) {
                try {
                    ret = format.parse(inputDate);
                    break;
                } catch (Exception e) {
                    System.out.println(e);
                }
            }
            ret = new Date();
        } while (false);

        return ret;
    }


    String formatDate(String inputDate, String patternSrc, String patternDst) {
        SimpleDateFormat format = new SimpleDateFormat(patternSrc);
        Date thisDate = parseDate(inputDate, format);

        format.applyPattern(patternDst);
        return format.format(thisDate);
    }


    String formatDate(String inputDate, int dayOffset, String pattern) {
        SimpleDateFormat formatReq = new SimpleDateFormat(pattern);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(parseDate(inputDate, formatReq));

        calendar.add(Calendar.DAY_OF_MONTH, dayOffset);
        String formatDest = formatReq.format(calendar.getTime());

        return formatDest;
    }

    String formatDate(String pattern) {
        SimpleDateFormat format = new SimpleDateFormat(pattern);

        return format.format(Calendar.getInstance().getTime());
    }

    /**
     * Channel & TV lookback
     **/
// Constant variables declaration
    static final int FLAG_UNDEFINED = 0;
    static final int FLAG_BROADCASTING = 1;
    static final int FLAG_RECORDED = 3;

    static final String COLOR_FOCUS = "#CCFE9A";
    static final String PROGRAM_UNDEFINED_NAME = "\u65e0\u8282\u76ee"; //????
    static final DateFormat formater = new SimpleDateFormat("yyyy.MM.dd HH:mm");

    /**
     * Generate multiple channels' foreshow HTML table.
     *
     * @param    valueIns            the object contained the request parameters.
     * @param    multiChans        the list contained all the channels.
     * @param    userLimitedLevel    the limited channel level of this user.
     * @return a String array contained the HTML.
     **/
    String[] formForeshowTables(List valueIns,
                                List multiChans, int userLimitedLevel,HttpServletRequest req,int totalMin,int programTop,String channelnameTop) {	
        String[] programList = new String[multiChans.size()];
        ChannelForeshowQueryValueIn valueIn = null;
        for (int i = 0; multiChans != null && i < multiChans.size(); i++) {
            ChannelForeshowInfo foreshowInfo = (ChannelForeshowInfo) multiChans.get(i);
            valueIn = (ChannelForeshowQueryValueIn)valueIns.get(i);
            programList[i] = formOneForeshowTable(valueIn, foreshowInfo, i,
                    multiChans.size() - 1 == i, userLimitedLevel,req,totalMin,programTop,channelnameTop);
        }
//        System.out.println("programList[0]="+programList[0]);
        return programList;
    }

  

    /**
     * Generate multiple channels' foreshow HTML table.
     *
     * @param    req            the request object.
     * @return a String array contained the HTML.
     **/
    String[] formForeshowTables(HttpServletRequest req,int number,int totalMin,int programTop,String channelnameTop) {
		try
		{
            UserInfo userInfo = (UserInfo) req.getSession().getAttribute(EpgConstants.USERINFO);
            ColumnDataSource columnDs = new ColumnDataSource();
            ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
            valueIn.setUserInfo(userInfo);
            valueIn.setColumnId(EpgUtils.getParamAsString(
                req.getParameter(EpgConstants.COLUMN_ID)));
            EpgResult result = columnDs.getData();
            List vColumnData = (Vector) result.getData();

            String oColumnid = "";
            int length = vColumnData.size();
            ColumnInfo columnInfo = null;
            List list = new ArrayList();
            ChannelForeshowQueryValueIn cvalueIn = null;
            List cvalueInList = new ArrayList();
            ChannelForeshowDataSource chanshowds = null;
            if(length>0){
                for(int i=0; i<length; i++){
                     columnInfo = (ColumnInfo)vColumnData.get(i);
                     oColumnid  = columnInfo.getColumnId();
                     chanshowds = new ChannelForeshowDataSource();
                     cvalueIn = getChanShowQueryValueIn(req,totalMin,chanshowds,oColumnid);
                     SearchResult sresult = (SearchResult)chanshowds.execute();
                     list.addAll(sresult.getItemList());
                     for(int j=0; j<sresult.getItemList().size(); j++){
                          cvalueInList.add(cvalueIn);
                     }
                }
            }else{
                     chanshowds = new ChannelForeshowDataSource();
                     cvalueIn = getChanShowQueryValueIn(req,totalMin,chanshowds,EpgUtils.getParamAsString(
                req.getParameter(EpgConstants.COLUMN_ID)));
                     SearchResult sresult = (SearchResult)chanshowds.execute();
                     list.addAll(sresult.getItemList());
                     for(int j=0; j<sresult.getItemList().size(); j++){
                          cvalueInList.add(cvalueIn);
                     }
            }
			//List list = trimPageItems(req, result.getItemList(),number);
            list = trimPageItems(req, list,number);
            cvalueInList = trimPageItems(req, cvalueInList,number);
            
			//UserInfo ui = (UserInfo) req.getSession().getAttribute(EpgConstants.USERINFO);
			int userLimited = userInfo.getLevelvalue();
			return formForeshowTables(cvalueInList, list, userLimited,req,totalMin,programTop,channelnameTop);

		}
		catch(Exception e)
		{
			e.printStackTrace();
			return null;
		}
    }

        /**
     * Generate multiple channels' favority foreshow HTML table.
     *
     * @param    req            the request object.
     * @return a String array contained the HTML.
     **/
//    String[] formFavorForeshowTables(HttpServletRequest req,int number,int totalMin,int programTop,String channelnameTop) {
//		try
//		{
//
//			ChannelFavoriteForeshowDataSource chanfavorshowds = new ChannelFavoriteForeshowDataSource();
//			ChannelForeshowQueryValueIn valueIn = getChanFavoriteShowQueryValueIn(req,totalMin,chanfavorshowds);
//             //System.out.println("-----------0000========valueIn========"+valueIn);
//
//			SearchResult result = (SearchResult)chanfavorshowds.execute();
//
//			//System.out.println("-----------0000========valueIn========"+result);
//			List list = trimPageItems(req, result.getItemList(),number);
//
//			UserInfo ui = (UserInfo) req.getSession().getAttribute(EpgConstants.USERINFO);
//			int userLimited = ui.getLevelvalue();
//			return formForeshowTables(valueIn, list, userLimited,req,totalMin,programTop,channelnameTop);
//
//		}
//		catch(Exception e)
//		{
//			e.printStackTrace();
//			return null;
//		}
//    }


    List trimPageItems(HttpServletRequest req, List inList,int number) {
        // Compute the start/end index
        int numPerPage = getNumPerPage(req,number).intValue();
        int fromIndex = getPageStartIndex(getDestPage(req), numPerPage);
        int toIndex = fromIndex + numPerPage > inList.size()
                ? inList.size() : fromIndex + numPerPage;

        return inList.subList(fromIndex, toIndex);
    }


    /**
     * Generate a channel foreshow HTML table.
     *
     * @param    valueIn            the object with the query parameters.
     * @param    chanForeshow    the channel foreshow object.
     * @param    rowIndex        the row index in the channel list.
     * @param    isLast            whether this row is the last one in the list.
     * @param    userLimitedLevel    the limited channel level of this user.
     * @return the HTML table content.
     **/
    String formOneForeshowTable(ChannelForeshowQueryValueIn valueIn,
                                ChannelForeshowInfo chanForeshow, int rowIndex, boolean isLast,
                                int userLimitedLevel,HttpServletRequest req,int totalMin,int programTop,String channelnameTop) {

        double totalMind = totalMin;
        String curDate = valueIn.getDate(); //"yyyy.MM.dd"
        String curStart = curDate + " " + valueIn.getStartTime();
        String curEnd = curDate + " " + valueIn.getEndTime();
        StringBuffer returnString = new StringBuffer(300);


        Date curStartDate = parseDate(curStart, formater);
        Date curEndDate = parseDate(curEnd, formater);
        try {
            if (curStartDate.compareTo(curEndDate) > 0) {
                Calendar cal = Calendar.getInstance();
                cal.setTime(curEndDate);
                cal.add(Calendar.DAY_OF_MONTH, 1);
                curEndDate = cal.getTime();
                curEnd = formater.format(curEndDate);
            }
        } catch (Exception ex) {
            System.out.println("***** error in Calendar func!");
        }

        List foreshow = filterPrograms(chanForeshow.getItemList(), curStartDate,
                curEnd, formater);

//        EltTable table = new EltTable(100, 100, true);
        if (foreshow.size() == 0) {
            ProgramInfo info = createNAProgram(chanForeshow.getChannelId(), formater,
                    curEnd,totalMind);
            foreshow.add(info);
        }

//        Element tr = table.add(new EltTr());
        int iLastTime = 0;
        double widthSpan = 0;
        Date proStartDate = null;
        Date proEndDate = null;
        //int totalWidth = 732;
        int totalWidth = 881;
        String channelName = chanForeshow.getChannelName();

        ProgramInfo programInfo =null;
        String startTime =null;
        String endTime = null;
        int iBeginTime =0;
        int iEndTime =0;

        for (int j = 0; j < foreshow.size(); j++) {
//            long l11 = System.currentTimeMillis();
            programInfo = (ProgramInfo) foreshow.get(j);
            startTime = programInfo.getStartTime();
            endTime = programInfo.getEndTime();
            iBeginTime = EpgUtils.toInt(startTime.substring(14, 16), 0);

            iEndTime = EpgUtils.toInt(endTime.substring(14, 16), 0);



            long ss = 0, se = 0, es = 0, ee = 0;
            try {
                proStartDate = formater.parse(startTime);
                proEndDate = formater.parse(endTime);

                iBeginTime= (int)(proStartDate.getTime()- curStartDate.getTime())/60000;
                iEndTime = (int)(proEndDate.getTime()- proStartDate.getTime())/60000;             
                ss = proStartDate.compareTo(curStartDate);
                se = proStartDate.compareTo(curEndDate);
                es = proEndDate.compareTo(curStartDate);
                ee = proEndDate.compareTo(curEndDate);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            if (ss < 0) {  
                if (es < 0) 
                    continue;
                else if (es >= 0) {    
                    iBeginTime = 0;
                    if (ee >= 0) {       
                        iEndTime = totalMin;
                    } else {
                        iEndTime = (int) ((proEndDate.getTime() - curStartDate.getTime()) / 60000);
                    }
                }
            } else {              
                if (se >= 0) {     
                    continue;
                } else {
                    if (ss == 0) {   
                        iBeginTime = 0;
                        if (ee >= 0) {      
                            iEndTime = totalMin;
                        }
                    } else {          
                        iBeginTime = (int) ((proStartDate.getTime() - curStartDate.getTime()) / 60000);
                        if (ee >= 0) {    
                            iEndTime = totalMin;
                        } else {
                            iEndTime = (int) ((proEndDate.getTime() - curStartDate.getTime()) / 60000);
                        }
                    }
                }
            }
            if (iBeginTime > iLastTime) {
                widthSpan = (iBeginTime - iLastTime) * 100 / totalMind;
                //tr.addElement(new EltTd(widthSpan, true));
                returnString.append(creatProgramDivs((float )(totalWidth*(widthSpan/100.0)),true,"","left"));
            }
            widthSpan = (iEndTime - iBeginTime) * 100 / totalMind;
			//System.out.println("==========widthSpan111====" + widthSpan);
			//widthSpan -= 1;
//			System.out.println("==========widthSpan====" + widthSpan);
//            System.out.println("==========widthSpan====" + (iEndTime - iBeginTime));
            if (widthSpan <= 0) {
                continue;
            }
            // Set the bgcolor and item name
            int statusFlag = FLAG_UNDEFINED;
            String tdBgcolor = "#9de2ff";
            String anId = (0 == rowIndex && FLAG_BROADCASTING == statusFlag) ? "me" : getAnchorId(rowIndex, j);
            int chanLevel = chanForeshow.getLevelvalue();
            int recordprivate = programInfo.getRecordprivate();
			int state = programInfo.getState();
			int prevueid = programInfo.getPrevueid();


			String contentid = programInfo.getContentId();
			String img = "TVprogram_line.png";
            String onfocusImg= "#";
			int programeLevel = 1111;
			int divWidth = (int)(totalWidth*(widthSpan/100.0));
			
//			String columnId = valueIn.getColumnId();
//			String channelId = chanForeshow.getChannelId();
			UserInfo ui = (UserInfo) req.getSession().getAttribute(EpgConstants.USERINFO);
			//String isInProductList = getIsInProductList(ui, columnId, channelId);
            String isInProductList ="0";
			//System.out.println("==========isInProductList====" + isInProductList);

//            long l22 = System.currentTimeMillis();
//            System.out.println("l22-l11="+(l22-l11));

            String tagBody = getTagBody(rowIndex, j, programInfo, valueIn.getColumnId(),
                    statusFlag, anId, widthSpan,
                    getAnchorAttribs(chanForeshow.getMixNo()+"",divWidth,programTop,chanLevel,state, anId, rowIndex, tdBgcolor,programInfo.getChannelcode(), valueIn.getColumnId(),
                            0 == rowIndex, isLast, 0 == j, foreshow.size() - 1 == j,channelName,programInfo.getContentDescription(),programInfo.getStartTime(),programInfo.getEndTime(),img,onfocusImg,programeLevel,recordprivate, prevueid, contentid),img,req,recordprivate,programTop,channelnameTop);
            iLastTime = iEndTime;
            String align = (iLastTime >= totalMin)?"right":"left";
            if (FLAG_UNDEFINED == statusFlag) {
                //tr.addElement(new EltTd(widthSpan, true).addElement(tagBody));
                returnString.append(creatProgramDivs((float)(totalWidth*(widthSpan/100.0)),true,tagBody,align));
            } else {
				//tr.addElement(new EltTd(widthSpan, true).addElement(tagBody));
                returnString.append(creatProgramDivs((float)(totalWidth*(widthSpan/100.0)),true,tagBody,align));
            }
            if (iLastTime >= totalMin)
                break;
        }

        if (iLastTime < totalMin && iLastTime != 0 && (totalMin - iLastTime) > 1) {
            widthSpan = (totalMind - iLastTime) * 100 / totalMind;
            //tr.addElement(new EltTd(widthSpan, true));
            returnString.append(creatProgramDivs((float)(totalWidth*(widthSpan/100.0)),true,"","left"));
        }
        return returnString.toString();
    }


    /**
     * Construct a ValueIn query object from the request parameters .
     *
     * @param    req        the object with the query parameters.
     **/
//    ChannelForeshowQueryValueIn getChanFavoriteShowQueryValueIn(HttpServletRequest req,int totalMin, ChannelFavoriteForeshowDataSource chanfavorshowds) {
//        UserInfo userInfo = (UserInfo) req.getSession()
//                .getAttribute(EpgConstants.USERINFO);
//
//        String sColumnId = EpgUtils.getParamAsString(
//                req.getParameter(EpgConstants.COLUMN_ID));
//        String date = EpgUtils.getParamAsString(
//                req.getParameter(EpgConstants.DATE));
//        if (date.equals("")) {
//            date = EpgUtils.dateFormat(new Date(), "yyyy.MM.dd");
//        }
//        String starthour = EpgUtils.getParamAsString(
//                req.getParameter(EpgConstants.START_HOUR));
//        String endhour = EpgUtils.getParamAsString(
//                req.getParameter(EpgConstants.END_HOUR));
//        if (starthour.equals("")) {
//            starthour = EpgUtils.dateFormat(new Date(), "HH:00");
//        } else {
//            starthour += ":00";
//        }
//        if (endhour.equals("")) {
//            Calendar cal = new GregorianCalendar();
//            cal.setTime(new Date());
//            //cal.add(Calendar.HOUR_OF_DAY, totalMin/30);
//            cal.add(Calendar.MINUTE, totalMin);
//			//System.out.println("=-========endhour========" + cal.getTime());
//            endhour = EpgUtils.dateFormat(cal.getTime(), "HH:mm");
//        } else {
//            //endhour += ":30";
//            int mins = totalMin%60;
//            if(mins < 10){
//            endhour += ":0"+ mins;
//            }else{
//                endhour += ":" + mins;
//            }
//        }
//		//System.out.println("=-========starthour========" + starthour);
//		//System.out.println("=-========endhour========" + endhour);
//
//        ChannelForeshowQueryValueIn valueIn = (ChannelForeshowQueryValueIn)chanfavorshowds.getValueIn();
//        valueIn.setColumnId(sColumnId);
//        valueIn.setDate(date);
//        valueIn.setStartTime(starthour);
//        valueIn.setEndTime(endhour);
//        valueIn.setUserInfo(userInfo);
//
//        rectifyEndTime(valueIn);
//        return valueIn;
//    }

    /**
     * Retrieve the program list between a time period, and the formate
     * of the inputed time string is "yyyy.MM.dd HH:mm".
     * Note :
     * If the time part of the end time of a program is "**:00:**", it
     * will escape this filter but filtered by the "formOneForeshowTable()",
     * This will cause the function "formOneForeshowTable()" generates
     * a HTML table without any "td" tag. Because that the computed
     * width is 0%. To avoid this, let the time part of  the start time
     * compare to "**:01:00".
     *
     * @param    items        the total program list.
     * @param    startTime    start time.
     * @param    endTime        end time string.
     * @param    format        date format.
     * @return the program list between the "startTime" and the "endTime".
     **/
    List filterPrograms(List items, Date startTime, String endTime, DateFormat format) {
        List result = new ArrayList();
        Calendar calStart = Calendar.getInstance();
        calStart.setTime(startTime);
        calStart.set(Calendar.MINUTE, 1);
        calStart.set(Calendar.SECOND, 0);

        for (int i = 0; items != null && i < items.size(); i++) {
            ProgramInfo programInfo = (ProgramInfo) items.get(i);
            if (programInfo.getStartTime().compareTo(endTime) >= 0 ||
                    programInfo.getEndTime().compareTo(
                            format.format(calStart.getTime())) < 0) {
                continue;
            }
            result.add(programInfo);
        }

        return result;
    }


    ProgramInfo createNAProgram(String chanCode, DateFormat formater, String endTime,double totalMin) {
        ProgramInfo info = new ProgramInfo();
        info.setContentName(PROGRAM_UNDEFINED_NAME);
        info.setChannelcode(chanCode);
        info.setEndTime(endTime);
        Calendar cal = Calendar.getInstance();
        cal.setTime(parseDate(endTime, formater));
        cal.add(Calendar.MINUTE, -(int)totalMin);

        info.setStartTime(formater.format(cal.getTime()));

        return info;
    }

    String trimTitle(String contentName, double widthSpan) {
        StringBuffer buf = new StringBuffer();
        int iNum = 0;
        // divided by 4 to let multibytes characters display properly
//        System.out.println("SSSSSSSSSSSSSSSSScontentName="+contentName);
//        System.out.println("SSSSSSSSSSSSSSSSSwidthSpan="+widthSpan);
        if (contentName.length() > 40) {
            iNum = (int)(widthSpan / 2);
        }else if(contentName.length() > 0){
            iNum = (int)(widthSpan / 3);
        }else if (widthSpan > 40) {
            iNum = (int)widthSpan / 2 + 2;
        } else if (widthSpan < 30) {
            iNum = (int)widthSpan / 2 ;
        } else if (widthSpan < 33) {
            iNum = (int)widthSpan / 2 - 1;
        } else {
            iNum = (int)widthSpan / 2;
        }

//        System.out.println("SSSSSSSSSSSSSSSSSiNum="+iNum);

        int delta = iNum - contentName.length() - 4;
        if (1 == widthSpan) {
            buf.append(".");
        } else if (contentName.length() > iNum) {
//            buf = (iNum > 2)
//                    ? buf.append(contentName.substring(0, iNum)).append("..") :
//                    buf.append("..");
            buf.append(contentName.substring(0, iNum)).append("..");
        } else if (delta > 0) {
            //int splitIndex = delta / 2;
            //for (int i = 0; i < delta; i++) {
               // if (i == splitIndex) buf.append(contentName);
               // buf.append("&nbsp;");
            //}
			buf.append(contentName);
        } else {
            buf.append(contentName);
        }

        return buf.toString();
    }


    String getAnchorId(int row, int col) {
        return new StringBuffer(15).append("an_")
                .append(row).append(col).toString();
    }


    String getAnchorAttribs(String mixno,int divWidth, int programTop,int chanLevel,int state, String anchorId, int rowIndex,String bgColor, String chanCode, String columnId, boolean up, boolean down,boolean left, boolean right,String programName,String programInfo,String startTime,String endTime,String img,String onfocusImg,int programeLevel,int channelName, int prevueid, String contentid) {
         if(programName.length()>20){
             programName = programName.substring(0,19);
         }
        return new StringBuffer(200)
                .append(" onfocus=\"anFocus(").append(divWidth)
                .append(",").append(programTop)
				.append(",'").append(columnId)
                .append("','").append(anchorId)
                .append("', '").append(rowIndex)
                .append("','").append(chanCode)
                .append("',").append(up)
                .append(", ").append(down)
                .append(", ").append(left)
                .append(", ").append(right)
                .append(", '").append(programName)
                .append("', '").append(startTime)
                .append("', '").append(endTime)
                .append("', '").append(img)
                .append("', '").append(onfocusImg)
                .append("', '").append(channelName)
                .append("', '").append(mixno)
                .append("', '").append(prevueid)
                .append("', '").append(contentid).append("'); ")
                .append("\"  onblur=\"anBlur('")
                .append(anchorId).append("','")
                .append(rowIndex)
                .append("');\" ").toString();
    }
    /**
     * 根据channelcode查询用户混排号、全局混排号
     * @param pageContext 页面上下文
     * @param channelCode 频道code
     * @return List  返回结果
     */
    Map<String,String> getChannelMixno(PageContext pageContext,String channelCode)
    {
        Map<String,String> result = new HashMap<String,String>();
        User user = (User) pageContext.getAttribute("user", PageContext.SESSION_SCOPE);
        String selectExp = "usermixno,mixno";
        String conditionExp =  new StringBuilder().append(" channelcode = '")
                .append(channelCode)
                .append("'")
                .toString();
        QueryResult queryResult = user.query(NameConstants.VIEWNAME_USER_CHANNEL, selectExp, conditionExp, "", 1, 1);
        if (queryResult != null) {
            List resultList = queryResult.getResultList();
            if (resultList.size() > 0) {
                result = (Map)resultList.get(0);
            }
        }
        return result;
    }
    String getTagBody(int rowIndex, int j,ProgramInfo programInfo, String colId, int statusFlag, String anchorId, double widthSpan, String effectAttr,String img,HttpServletRequest req,int recordprivate,int programTop,String channelnameTop) {
		boolean isLimited = false;
		//int totalWidth = 732;
        int totalWidth = 881;
		
		int leftValue = -3000 + 100*j;
		int topValue = -3000 + 100*rowIndex;
		float divWidth = (float)(totalWidth*(widthSpan/100.0)) ;
        divWidth = (int)(divWidth*100);
        divWidth = divWidth/100;

        if(divWidth>0){
            divWidth = divWidth-1;
        }
//        System.out.println("divWidth="+divWidth);
//		int divWidthTemp = divWidth - 2;
        String itemName = trimTitle(programInfo.getContentName(), widthSpan);
        StringBuffer anchorBuf = new StringBuffer(470);
		String imgId = "img"+anchorId;
        /*anchorBuf.append("<div>").append("<img src=\"images/btn_trans.gif").append("\" width=\"").append(divWidthTemp).append("\" id=\"").append(imgId).append("\" ")
                        .append("height=\"").append(programTop).append("\" alt=\"\" border=\"0\" />").append("<img src=\"images1/liveTV/TVprogram_line.png").append("\" width=\"").append(2).append("\" ")
                        .append("height=\"").append(46).append("\" alt=\"\" border=\"0\" />").append("</div><div  style=\"top:").append(topValue).append(";left:").append(leftValue).append(";position: absolute\">");
        */
        anchorBuf.append("<div style=\"top:").append(topValue).append(";left:").append(leftValue).append(";position: absolute\">");
        SimpleDateFormat format = new SimpleDateFormat("yyyy.MM.dd");
        String today = format.format(Calendar.getInstance().getTime());

        String contentName = programInfo.getContentName();
        if (null == contentName) {
            contentName = "";
        }

        try {
            contentName = URLEncoder.encode(contentName, "GBK");
        } catch (Exception e) {
            e.printStackTrace();
        }
		
		//int mixNo = getChannelMixNo(programInfo.getChannelcode(),req);
        int mixNo = -1;
        System.out.println("YUAN----------chan----programInfo.getChannelcode()="+programInfo.getChannelcode());
        Map channelInfo =  getChannelMixno(pageContext, programInfo.getChannelcode());
        if(channelInfo != null){
            mixNo = Integer.parseInt(String.valueOf(channelInfo.get("usermixno")));
        }
        System.out.println("YUAN---------chan----mixNo="+mixNo);
		int state = programInfo.getState();
		if(state == 1){
			anchorBuf.append("<a href=\"javascript:recordedAction('"+programInfo.getContentId()+"','"+programInfo.getChannelcode()+"','"+isLimited+"','"+colId+"','111','"+anchorId+"')");
		}else{
			anchorBuf.append("<a href=\"javascript:channelPlay('"+mixNo+"','"+programInfo.getChannelcode()+"','"+anchorId+"')");
		}
        channelnameTop ="0";

		anchorBuf.append("\" id=\"").append(anchorId).append("\" ")
                .append("name=\"").append("an"+programInfo.getPrevueid()).append("\" ")
//				.append("columnid=\"").append(EpgConstants.COLUMN_ID).append("\" ")
//                .append("title=\"").append(programInfo.getContentName())
//                .append("\" ")
                .append(effectAttr).append(">")
                .append(".")
                .append("</a>")
                .append("</div><div align=\"left\" class=\"programtext\" id=\"text"+anchorId+"\" style=\"").append("width:").append(divWidth).append(";\">").append(itemName).append("</div>");
        return anchorBuf.toString();
    }

    /**
     * Construct a ValueIn query object from the request parameters .
     *
     * @param    req        the object with the query parameters.
     **/
    ChannelForeshowQueryValueIn getChanShowQueryValueIn(HttpServletRequest req,int totalMin, ChannelForeshowDataSource chanshowds,String columnid) {
        UserInfo userInfo = (UserInfo) req.getSession()
                .getAttribute(EpgConstants.USERINFO);

//        String sColumnId = EpgUtils.getParamAsString(
//                req.getParameter(EpgConstants.COLUMN_ID));
        String sColumnId = columnid;
        String date = EpgUtils.getParamAsString(
                req.getParameter(EpgConstants.DATE));
        if (date.equals("")) {
            date = EpgUtils.dateFormat(new Date(), "yyyy.MM.dd");
        }
        String starthour = EpgUtils.getParamAsString(
                req.getParameter(EpgConstants.START_HOUR));
        String endhour = EpgUtils.getParamAsString(
                req.getParameter(EpgConstants.END_HOUR));
        if (starthour.equals("")) {
            starthour = EpgUtils.dateFormat(new Date(), "HH:00");
        } else {
            starthour += ":00";
        }
        if (endhour.equals("")) {
            Calendar cal = new GregorianCalendar();
            cal.setTime(new Date());
            //cal.add(Calendar.HOUR_OF_DAY, totalMin/30);
            cal.add(Calendar.MINUTE, totalMin);
			//System.out.println("=-========endhour========" + cal.getTime());
            endhour = EpgUtils.dateFormat(cal.getTime(), "HH:mm");
        } else {
            //endhour += ":30";
            if(endhour.length()<2){
              endhour="0"+endhour;
            }
            int mins = totalMin%60;
            if(mins < 10){
            endhour += ":0"+ mins;
            }else{
                endhour += ":" + mins;
            }
        }
		//System.out.println("=-========starthour========" + starthour);
		//System.out.println("=-========endhour========" + endhour);
       
        ChannelForeshowQueryValueIn valueIn = (ChannelForeshowQueryValueIn)chanshowds.getValueIn();
        valueIn.setColumnId(sColumnId);
        valueIn.setDate(date);
        valueIn.setStartTime(starthour);
        valueIn.setEndTime(endhour);
        valueIn.setUserInfo(userInfo);

        rectifyEndTime(valueIn);
        return valueIn;
    }

    void rectifyEndTime(ChannelForeshowQueryValueIn valueIn) {
        if ("23:00".equals(valueIn.getStartTime())
                && "00:00".equals(valueIn.getEndTime())) {
            valueIn.setEndTime("24:00");
        }
    }

    int getPageStartIndex(Integer curPage, int numPerPage) {
        return (curPage.intValue() - 1) * numPerPage;
    }

    Integer getDestPage(HttpServletRequest req) {
        return getIntParam(req, "destpage");
    }

    Integer getNumPerPage(HttpServletRequest req,int number) {
        
        return getIntParam(req, "numperpage", number);
    }

    Integer getIntParam(HttpServletRequest req, String paramName) {
        return getIntParam(req, paramName, 1);
    }

    Integer getIntParam(HttpServletRequest req, String paramName, int defaultValue) {
        Integer result = new Integer(defaultValue);
        String tmp = req.getParameter(paramName);
        if (tmp != null && !"".equals(tmp)) {
            result = new Integer(tmp);
        }

        return result;
    }



	String getIsInProductList(UserInfo ui, String columnId, String channelId){
		String isInProductList = "0";
		try {
			AuthAndShowProductListDataSource cds = new AuthAndShowProductListDataSource();
			AuthQueryValueIn valueInAuth =(AuthQueryValueIn)cds.getValueIn();			
			valueInAuth.setUserInfo(ui);
			valueInAuth.setsCategoryID(columnId);
			valueInAuth.setsContentID(channelId);
			valueInAuth.setiContentType(2);
			valueInAuth.setsFatherContent(channelId);
			EpgResult result = cds.getData();
			if(result != null){
				Boolean isOpSucc = (Boolean)result.isOpSucc();
				if(isOpSucc){
					isInProductList = "1";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return isInProductList;
	}
    String creatProgramDivs(float divWidth,boolean showOrHide,String divInnerText,String alignType){
        String align = (alignType.equals("right"))?"right":"left";
        StringBuffer sb = new StringBuffer(300);
//        System.out.println("SSSSSSSSSSSSSSSSSdivWidth="+divWidth);
        divWidth = (int)(divWidth*100);
        divWidth = divWidth/100;
        if(divWidth>0){
           divWidth = divWidth-1;
        }

        sb.append("<div class=\"program\" style=\"float:"+align+";width:");
        //sb.append(divWidth+1);
        sb.append(divWidth);
        sb.append("px;");
        sb.append(showOrHide?"":"visibility:hidden;");
        sb.append("\">");
        sb.append(divInnerText);
        sb.append("</div>");
        return sb.toString();
    }
%>
