<%@	page contentType="text/html; charset=GBK" %>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants"%>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*"%>
<%@page import="com.zte.iptv.epg.util.STBKeysNew"%>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelDataSource" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.content.ChannelForeshowInfo" %>
<%@ page import="com.zte.iptv.epg.content.ProgramInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%!
	public String castNum(String str)
	{
		String temp = str;
		Integer intTemp = 0;
		try
		{
			intTemp = Integer.parseInt(str);
			if(intTemp < 10)
			{
				temp = "0" + intTemp;
			}
			else
			{
				temp = "" + intTemp;
			}
		}
		catch(Exception e)
		{
			intTemp = 0;
			temp = "01";
		}
		return temp;
	}
%>
<%
//    System.out.println("+++++++++++++channel_bytime_pre.jsp+++++");

    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
	
	 SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd");
     SimpleDateFormat formatDate = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

     String todayTime = formatOutput.format(new Date());
     String TIME_COUNT=String.valueOf(param.get("TIME_COUNT"));
     String INTERVAL=String.valueOf(param.get("INTERVAL"));

     int totalMin = Integer.parseInt(TIME_COUNT) * Integer.parseInt(INTERVAL);
     Calendar time = Calendar.getInstance();
     String starthour = String.valueOf(time.get(Calendar.HOUR_OF_DAY));
     String startMin = String.valueOf(time.get(Calendar.MINUTE));
     int istartMin = Integer.parseInt(startMin);
     int istarthour = Integer.parseInt(starthour);
     if(istartMin>30){
         istarthour ++;
     }

     istarthour = istarthour-(totalMin/60)/2;
     if(istarthour<0){
        istarthour =0;
     }

	 int iendhour = istarthour + totalMin / 60;
	 if (iendhour > 24) {
		iendhour = 24;
		istarthour = 24 - totalMin / 60;
	 }
	 starthour = String.valueOf(istarthour);
	 if (starthour.length() < 2) {
		starthour = "0" + starthour;
	 }
	 String endhour = String.valueOf(iendhour);
	 if (endhour.length() < 2) {
		endhour = "0" + endhour;
	 }

    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String columnid = request.getParameter("columnid");
    String channelid = request.getParameter("channelid1");
    channelid = (channelid == null)? "" : channelid;

    ChannelInfo channelInfo = null;
    String tempchannelid ="";
//    int length =  vChannelData.size();
    ColumnDataSource columnDs = new ColumnDataSource();
    ColumnValueIn columnValue = (ColumnValueIn) columnDs.getValueIn();
    columnValue.setUserInfo(userInfo);
    columnValue.setColumnId(columnid);
    EpgResult result = columnDs.getData();
    List vColumnData = (Vector) result.getData();
    int length1 =vColumnData.size();

    ColumnInfo columnInfo = null;
    String oColumnid = "";
    ChannelForeshowDataSource dataSource = null;
    List multiChans = new ArrayList();
    ChannelForeshowQueryValueIn valueIn = null;

//    System.out.println("============length1="+length1);
    if(length1 >0 ){
        for(int i=0; i<length1; i++){
             columnInfo = (ColumnInfo)vColumnData.get(i);
             oColumnid  = columnInfo.getColumnId();
             dataSource = new ChannelForeshowDataSource();
             valueIn = (ChannelForeshowQueryValueIn)dataSource.getValueIn();
             valueIn.setColumnId(oColumnid);
             valueIn.setDate(todayTime);
             valueIn.setStartTime(starthour);
             valueIn.setEndTime("23:59");
             valueIn.setUserInfo(userInfo);
                //valueIn.setLangType(langType);
             EpgResult resulti = dataSource.getData();
             multiChans.addAll((Vector)resulti.getData());
        }
    }else if(length1 == 0){
              dataSource = new ChannelForeshowDataSource();
             valueIn = (ChannelForeshowQueryValueIn)dataSource.getValueIn();
             valueIn.setColumnId(columnid);
             valueIn.setDate(todayTime);
             valueIn.setStartTime(starthour);
             valueIn.setEndTime("23:59");
             valueIn.setUserInfo(userInfo);
                //valueIn.setLangType(langType);
             EpgResult resulti = dataSource.getData();
             multiChans.addAll((Vector)resulti.getData());
    }

//    System.out.println("============channel_bytime_pre.jsp="+multiChans.size());

//    Vector multiChans = (Vector)result.getData();
    int length = multiChans.size();

    int curchannelIndex = -1;
    Vector programVector = null;
    String prevueid ="";

    ChannelForeshowInfo channelForeshowInfo = null;
    if(!"".equals(channelid)){
        for(int i=0; i<length; i++){
             channelForeshowInfo = (ChannelForeshowInfo) multiChans.get(i);//sunmofei
             if(channelForeshowInfo!=null){
         //tempchannelid = channelInfo.getChannelId();
                //tempchannelid = channelForeshowInfo.getChannelId();
                 tempchannelid = channelForeshowInfo.getMixNo()+"";
    //            System.out.println("+++++++++="+channelInfo.getChannelName());
                if(tempchannelid.equals(channelid)){
                     curchannelIndex = i;
                     programVector = (Vector)channelForeshowInfo.getItemList();
                     for(int j=0; j<programVector.size(); j++){
                         ProgramInfo programInfo = (ProgramInfo)programVector.get(j);
//                         System.out.println("+++++++++++++programInfo.getEndTime()="+programInfo.getEndTime());
                         if(formatDate.parse(programInfo.getEndTime()).compareTo(new Date())>0){
//                             System.out.println("++++++++true+++");
                             prevueid = String.valueOf(programInfo.getPrevueid());
                             break;
                         }

                     }
                     break;
                }
             }

        }
    }


//    System.out.println("===============curchannelIndex="+curchannelIndex);

    int destpage = (curchannelIndex/10)+1;
    curchannelIndex = curchannelIndex -(destpage-1)*10;

//    System.out.println("===============destpage="+destpage);



     String requestString = request.getQueryString();

     requestString = requestString+"&starthour="+starthour+"&endhour="+endhour+"&"+EpgConstants.DATE+"="+todayTime+"&destpage="+destpage+"&prevueid="+prevueid+"&rowindex="+curchannelIndex;
     String forwardUrl = "channel_bytime.jsp?"+requestString;

//     System.out.println("######  channel_bychannel_pre.jsp  ############  requestString=" + requestString);

     pageContext.forward(forwardUrl);

//     return ;
%>
