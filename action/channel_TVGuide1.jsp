<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page isELIgnored="false" %>
<%--<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>--%>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.zte.iptv.epg.web.FavoriteQueryValueIn_3S" %>
<%@ page import="com.zte.iptv.epg.account.FavoriteInfo_3S" %>
<%@ page import="java.awt.Font" %>
<%@ page import="java.awt.FontMetrics" %>
<%@ page import="java.awt.geom.Rectangle2D" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ProgramInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.content.ChannelForeshowInfo" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.decorator.ChannelOneForeshowDecorator" %>

<%!
    public String getJsonObject(String[] param,String[] value)
    {
        String result = null;
        try
        {
            if(param!=null && value!=null && param.length==value.length)
            {
                result = "{";
                for(int i=0;i<param.length;i++)
                {
                    if(param[i]!="ProgramList")
                    {
//                        value[i] = value[i].replaceAll("\"", "\\\\\"");
                        value[i] = formatName(value[i]);
                        result += param[i]+":"+"\""+value[i]+"\"";
                    }
                    else
                    {
                        result += param[i]+":"+value[i];
                    }
                    if(i!=param.length-1)
                    {
                        result+=",";
                    }
                }
                result += "}";
            }
        }
        catch(Exception e)
        {
            System.out.println("getJsonObject==========="+e);
        }
        return result;
    }

    public String getJsonArray(String[] jsonObjectArr)
    {
        String result = null;
        if(jsonObjectArr!=null)
        {
            result = "[";
            for(int i=0;i<jsonObjectArr.length;i++)
            {
                result += jsonObjectArr[i];
                if(i!=jsonObjectArr.length-1)
                {
                    result+=",";
                }
            }

            result += "]";
        }
        return result;
    }

    public String addZeroNum(int number) {
        String showNo = String.valueOf(number);
        if (number < 10) {
            showNo = "0" + showNo;
        }
        return showNo;
    }

    public String formatName(Object oldName) {
        String newName = String.valueOf(oldName);
        if (!"null".equals(newName)) {
            newName = newName.replaceAll("\\\\", "\\\\\\\\");
            newName = newName.replaceAll("\"", "\\\\\"");
            newName = newName.replaceAll("\'", "\\\\\'");
        } else {
            newName = "";
        }
        return newName;
    }


    public FontMetrics getFontObject(int px)
    {
        if(metrics == null)
        {
            Font font = new Font("Verdana", Font.PLAIN, px);
            FontMetrics metrics = new FontMetrics(font) {};
            return metrics;
        }else
        {
            return metrics;
        }
    }
    int px = 22;      //页面字体像素
    FontMetrics metrics = getFontObject(px);

    /*
    *获取字符串长度
    * programName节目名称
    * px 字体大小
    * length  字符串长度
    */
    public int getNameLength(String programName) {
        int length = 0;
        Rectangle2D bounds = metrics.getStringBounds(programName, null);
        length = (int) bounds.getWidth();
        return length;
    }

    /*
    *取截取后的字符串
    * length当前字符串长度
    */
    public String getShowName(String programName, int Width, int px) {
        int length = 0;
        int maxWordlegth = 2*Width/px;
        if(maxWordlegth < programName.length())
        {//预截取字符串长度
            programName = programName.substring(0,maxWordlegth);
        }
        if(Width >= getNameLength(programName))
        {
            return programName;
        }
        char[] nameArray = programName.toCharArray();
        for (int i = 0; i < nameArray.length; i++) {
            if (length > Width ) {
                programName = programName.substring(0, i - 1);
                break;
            } else {
                length += getNameLength(String.valueOf(nameArray[i]));
            }
        }
        return programName;
    }

    /*'
    *   获取预展示的节目单名称
    *   picWidth   图片长度
    *   dotWidth   省略号长度
    *   stylelength  图片展示用长度
    *   px 字体大小
    */
    public ArrayList showFocusName(String programName, int tdWidth) {
        int hasBreak = 0;
        String _name = "";
        ArrayList breakName = new ArrayList();
        if (tdWidth > 0 && !"".equals(programName) && programName.length() > 0) {
            int dotWidth = 26;           //省略号长度
            int wordWIdthPX = getNameLength(programName);
            if (tdWidth <= dotWidth) {
                _name = "...";
                hasBreak = 1;
            } else if (tdWidth > wordWIdthPX) {
                _name = programName;
                hasBreak = 0;
            } else {
//                字符串长度需要截取  截取长度为 tdWidth - dotWidth - stylelength
                _name = getShowName(programName, (tdWidth - dotWidth), px) + "...";
//                _name = programName;

                hasBreak = 1;
            }
        }
//        System.out.println("SSSSSSSSSSSSSSSSSSSSStdWidth="+tdWidth+"_programName="+programName+"__name="+_name);
        breakName.add(hasBreak);
        breakName.add(_name);
        return breakName;
    }

%>


<%
    System.out.println("SSSSSSSSSSSSSSSSSSSSSchannel_TVGuide11111.jsp="+request.getQueryString());
    UserInfo userInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String date = (String)request.getParameter("begintime");//"2010.12.16";
    String columnId = (String)request.getParameter("columnid");
    String destPage = request.getParameter("destpage");
    String numPerpage = request.getParameter("numperpage");
    String flag = "0";//判断的标志

    int startTime = Integer.parseInt(request.getParameter("starttime"));
    String starttime = addZeroNum(startTime);
    String endtime = addZeroNum(startTime+2);
    int _mixno = -1;
    if (request.getParameter("currentchannel") != null && request.getParameter("currentchannel") != "") {
        _mixno = Integer.parseInt(request.getParameter("currentchannel"));
    }
    int pageno = (destPage == null) ? 1 : Integer.parseInt(destPage);
    int numperpage = (numPerpage == null) ? 10 : Integer.parseInt(numPerpage);

    String[] channelObjectArr = null;
    String finalChannelObjectArr = null;
    String[] programObjectArr = null;

    int pageStartTime_minute = startTime * 60;
    int leftPX = 314;
    int tableWidth = 880;
    int channelTotal = 0;
    try{
        ColumnDataSource columnDs = new ColumnDataSource();
        ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setColumnId(columnId);

        EpgResult result = columnDs.getData();
        List vColumnData = (Vector) result.getData();

        String oColumnid = "";
        int length = vColumnData.size();
        int size = 0;
        ChannelDataSource channelDs = null;
        ColumnInfo columnInfo = null;
        ChannelInfo channelInfo = null;

//         channelInfo.
        List ChannelInfoList = new ArrayList();
//        System.out.println("-----------------------length="+length);
        if(length>0){
            for(int i=0; i<length; i++){
                columnInfo = (ColumnInfo)vColumnData.get(i);
                oColumnid  = columnInfo.getColumnId();
				if("0400".equals(oColumnid) || "0401".equals(oColumnid) || "0402".equals(oColumnid) ||"0403".equals(oColumnid) || "0405".equals(oColumnid) || "0407".equals(oColumnid)){
                channelDs = new ChannelDataSource();
                ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
                valuesIn.setUserInfo(userInfo);
                valuesIn.setColumnId(oColumnid);
                EpgResult resultTV = channelDs.getData();
                List vChannelData = (Vector) resultTV.getData();
                ChannelInfoList.addAll(vChannelData);
				}
            }
        }else{
            channelDs = new ChannelDataSource();
            ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
            valuesIn.setUserInfo(userInfo);
            valuesIn.setColumnId(columnId);
            EpgResult resultTV = channelDs.getData();
            List vChannelData = (Vector) resultTV.getData();
            ChannelInfoList.addAll(vChannelData);
        }
        size = ChannelInfoList.size();

        String channelName = "";
        String channelColumnId = "";
        Integer channelMixNo = 0;
        Integer channelevel=0;
		Integer focusa = -1;//索引值
        String[] channleObjectParam = {"TvodEnable","Rowid","isBreak","CurPage","Pagecount","ChannelId","ChannelName","ShowChannelName","MixNo","ProgramList","ColumnId","ColumnCode","TotalCount","ChanLevel"};
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
        String channelId = null;
        String tvodenable = "1";
        int programTimeStart = 0;            //节目有效开始时间
        int programTimeEnd = 0;              //节目有效结束时间
        int divWidth = 0;
        int left = 0;
        int rowid = -1;
        List tempbreak = null;
        String[] programObjectParam = {"playable","PrevueId","Prevuecode","PrevueName","showProgramName","StartTime","EndTime","ContentDescription","ContentId","Systemrecord","startTime_minute","endTime_minute","hasBreak","programfocus","left","divWidth"};
        String[] programObjectValue;
        if(size>0){
					for(int i=0; i<size; i++){
						ChannelInfo channelInfo1 = (ChannelInfo)ChannelInfoList.get(i);
						channelMixNo = channelInfo1.getMixNo();
						String mixn=String.valueOf(channelMixNo);
						if(!"6".equals(mixn)){//屏蔽频道20131218
							if(_mixno == channelMixNo && channelMixNo!=-1){
								rowid++;
							//rowid=i;
								pageno = rowid / numperpage + 1;
								rowid = rowid % numperpage;
								break;
							}
						}
						else{
						flag = "1";
						}//屏蔽频道20131218
					}

					int startIndex = 0;
					int endIndex = 0;
					Integer curPage = pageno;
					Integer totalCount = size;
					Integer pageCount = ((size-1)/numperpage)+1;

					
					startIndex = numperpage*(curPage-1);
					endIndex = numperpage*curPage+1;
					if(curPage>1){
						startIndex = numperpage*(curPage-1)+1;
					}else{
					totalCount = size-1;//屏蔽频道20131218（原Integer totalCount = size：）
					pageCount = ((size-2)/numperpage)+1;//屏蔽频道20131218（原:Integer pageCount = ((size-1)/numperpage)+1）
					}
						
					if("1".equals(flag))
					{
						if(curPage>1){
						startIndex = numperpage*(curPage-1)+1;
						}
						endIndex = numperpage*curPage+1;
					        totalCount = size-1;//屏蔽频道20131218（原Integer totalCount = size：）
						pageCount = ((size-2)/numperpage)+1;//屏蔽频道20131218（原:Integer pageCount = ((size-1)/numperpage)+1）
					}
					if(endIndex>totalCount){
						endIndex = totalCount;
					}
		//            Vector multiChans = (Vector)result.getData();
		            channelTotal = endIndex - startIndex;
		           
					
					channelObjectArr = new String[channelTotal];

					int startTime_minute = 0;
					int endTime_minute = 0;
					SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
		//            System.out.println("channelTotal================================================="+channelTotal);

		//            for(int i=0;i<channelTotal;i++)
					ChannelOneForeshowDataSource dataSource = null;
					ChannelForeshowQueryValueIn valueIn1 = null;
					
					for(int i=startIndex;i<endIndex;i++){
						
						ChannelInfo channelInfos = (ChannelInfo)ChannelInfoList.get(i);
						String mixnom = String.valueOf(channelInfos.getMixNo());
                                                if(!"6".equals(mixnom)){
						ChannelInfo channelInfo1 = (ChannelInfo)ChannelInfoList.get(i);
						channelName = (String)channelInfo1.getChannelName();//
						channelId = (String)channelInfo1.getChannelId();//
						channelColumnId = (String)channelInfo1.getFcolumnid();//
						channelMixNo = (Integer)channelInfo1.getMixNo();
			
						focusa++;
						channelevel = (Integer)channelInfo1.getLevelvalue();
						tvodenable = String.valueOf(channelInfo1.getTvodenable());

						if(channelInfo1!=null){
							dataSource = new ChannelOneForeshowDataSource();
							valueIn1 = (ChannelForeshowQueryValueIn)dataSource.getValueIn();
							valueIn1.setColumnId(channelInfo1.getFcolumnid());
							valueIn1.setDate(date);
							valueIn1.setStartTime(starttime);
							valueIn1.setEndTime(endtime);
							valueIn1.setUserInfo(userInfo);
							valueIn1.setChannelId(channelInfo1.getChannelId());
			//                EpgResult result1 = dataSource.getData();
			//                Vector multiChans = (Vector)result1.getData();

							EpgResult result1=dataSource.getData();
							ChannelOneForeshowDecorator oneDs=new ChannelOneForeshowDecorator();
							EpgResult trueResult=oneDs.decorate(result1);
							Map dataOut = (Map) trueResult.getDataOut().get(EpgResult.DATA);

							if (dataOut != null) {
									List oneProgramNameV= (Vector)dataOut.get("Programname");
									List oneStartTimeV=(Vector)dataOut.get("StartTimeF");
									List oneEndTimeV=(Vector)dataOut.get("EndTimeF");
									List oneStartTime=(Vector)dataOut.get("StartTime");
									List oneEndTime=(Vector)dataOut.get("EndTime");
									List onePrevueidV = (Vector)dataOut.get("Prevueid");
									List onePrevueCodeV = (Vector)dataOut.get("Prevuecode");
									List oneContentId = (Vector)dataOut.get("ContentId");
									List oneContentDescription = (Vector)dataOut.get("ContentDescription");
									List oneRecordsystem = (Vector)dataOut.get("Recordsystem");
									List onePlayable = (Vector)dataOut.get("IsPlayable");

									programVector = oneProgramNameV;
									programObjectArr = new String[programVector.size()];

									if(programVector!=null && programVector.size()>0){
										for(int j=0;j<programVector.size();j++){

												programStartTime = String.valueOf(oneStartTime.get(j));
												programEndTime = String.valueOf(oneEndTime.get(j));
												Date curDate = formatOutput.parse(date+" 00:00:00");
												Date startDate = formatOutput.parse(programStartTime);
												Date endDate = formatOutput.parse(programEndTime);

												long curTimes = Math.abs((long)curDate.getTime()/1000/60);
												long startTimes = Math.abs((long)startDate.getTime()/1000/60);
												long endTimes = Math.abs((long)endDate.getTime()/1000/60);

												startTime_minute = (int)(startTimes - curTimes);
												endTime_minute = (int)(endTimes - curTimes);

												if (pageStartTime_minute >= startTime_minute) {
													programTimeStart = pageStartTime_minute;
													left = leftPX;
												} else {
													programTimeStart = startTime_minute;
													left = leftPX + tableWidth * (startTime_minute - pageStartTime_minute) / 120;
												}
												if (pageStartTime_minute + 120 >= endTime_minute) {
													programTimeEnd = endTime_minute;
												} else {
													programTimeEnd = pageStartTime_minute + 120;
												}
												divWidth = tableWidth * (programTimeEnd - programTimeStart) / 120;


												programPrevueId = (Integer)onePrevueidV.get(j);
												String programPrevueCode = String.valueOf(onePrevueCodeV.get(j));
												programName = (String)oneProgramNameV.get(j);
												contentDescription = (String)oneContentDescription.get(j);
												String progContentId = (String)oneContentId.get(j);
												Integer recordsystem = (Integer)oneRecordsystem.get(j);
												String playable = String.valueOf(onePlayable.get(j));
				//                                if(divWidth>40){
				//                                    tempbreak = showFocusName(programName,divWidth-40);
				//                                }else{
				//                                    tempbreak = showFocusName(programName,divWidth);
				//                                }
												int tempWidth = 0;

												if(divWidth<28){
													tempWidth = -1;
												}else if(divWidth<75){
													tempWidth = divWidth*4/5;
												}else{
													tempWidth = divWidth*14/20;
												}
												tempbreak = showFocusName(programName,tempWidth);
												programObjectValue = new String[]{playable,programPrevueId+"",programPrevueCode+"",programName,String.valueOf(tempbreak.get(1)),programStartTime,programEndTime,contentDescription,progContentId,recordsystem+"",startTime_minute+"",endTime_minute+"",String.valueOf(tempbreak.get(0)),"0",left+"",divWidth+""};
												programObject = (String)getJsonObject(programObjectParam,programObjectValue);
											programObjectArr[j] = programObject;
										}
									}

										tempbreak = showFocusName(channelName,135);
				//                    System.out.println("SSSSSSSSSSSSSSSSSSSS"+tempbreak.get(1));
										channleObjectValue = new String[]{tvodenable,String.valueOf(rowid),String.valueOf(tempbreak.get(0)),String.valueOf(curPage),String.valueOf(pageCount), channelId,channelName,String.valueOf(tempbreak.get(1)),String.valueOf(channelMixNo),getJsonArray(programObjectArr),channelColumnId,channelColumnId,totalCount+"",channelevel+""};
										channelObject = (String)getJsonObject(channleObjectParam,channleObjectValue);
										channelObjectArr[focusa] = channelObject;
										 //channelObjectArr[i-startIndex] = channelObject;
								}
						}}
					}
			}
        
        finalChannelObjectArr = (String)getJsonArray(channelObjectArr);

    }catch (Exception e){
          e.printStackTrace();
    }

//    System.out.println("SSSSSSSSSSSSSSSSSSfinalChannelObjectArr="+finalChannelObjectArr);
    JspWriter ot = pageContext.getOut();
    ot.write(finalChannelObjectArr.toString());
%>


