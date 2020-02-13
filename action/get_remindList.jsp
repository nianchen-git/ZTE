<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtility" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%--<%@ page import="com.zte.iptv.newepg.channel.Controller" %>--%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.zte.iptv.epg.exception.EpgException" %>
<%--<%@ page import="com.zte.iptv.epg.content.QueryPagesImpApp" %>--%>
<%@ page import="com.zte.iptv.epg.util.EpgServiceAccess" %>
<%@ page import="com.zte.iptv.epg.content.ChannelRemindInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.web.ChannelRemindQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelAllRemindDataSource" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page isELIgnored="false" %>
<%--<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>--%>

<%!
    public static int getUserTableIndex(String userID) throws EpgException {
        //Add by JTG 20080428
        int Districtnum = 0;
        if (null == userID || "".equals(userID)) {
            throw new EpgException("table district dispatch error");
        }
        String tempUserID = userID.trim();
        for (int i = 0; i < tempUserID.length(); i++) {
            Districtnum += tempUserID.charAt(i);
        }
        Districtnum = Districtnum % 10 + 1;
        if (Districtnum > 10 || Districtnum <= 0) {
            throw new EpgException("table district dispatch error");
        }
        return Districtnum;
    }
%>

<%
    //[{prevuename=The Sixth Sense, begintime=2012.04.17 08:00:01, channelcode=0, isRemindNow=0, timeValue=0}]
    String isReminderProgramPlay = "0";

    isReminderProgramPlay = request.getParameter("isReminderProgramPlay");
    if(isReminderProgramPlay == null || isReminderProgramPlay.equals("")){
        isReminderProgramPlay = "0";
    }
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    path = path.replace("action/", "");
    HashMap param = PortalUtils.getParams(path, "UTF-8");

    String aheadTimeMinute = String.valueOf(param.get("aheadTimeMinute"));
    //默认展示时间
    int iaheadTimeMinute = 5;
    try{
        if(aheadTimeMinute!=null){
            iaheadTimeMinute = Integer.parseInt(aheadTimeMinute);
        }
    }catch(Exception e){
        e.printStackTrace();
        System.out.println("SSSSSSSSSSSSaheadTimeMinute_error!!");
    }

    System.out.println("SSSSSSSSSSSSSSSSSiaheadTimeMinute_isReminderProgramPlay="+iaheadTimeMinute+"_"+isReminderProgramPlay);

    UserInfo userInfo = (UserInfo) pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);
    Date nowdate = new Date();
    String nowtime = com.zte.iptv.epg.util.EpgUtility.date2str(nowdate, "yyyy.MM.dd HH:mm:ss");
    DateFormat format=new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");

    int totalSize = 0;
    try {
        ChannelAllRemindDataSource columnDs = new ChannelAllRemindDataSource();
        ChannelRemindQueryValueIn valueIn = (ChannelRemindQueryValueIn) columnDs.getValueIn();
        valueIn.setUserInfo(userInfo);
//        valueIn.setNumPerPage(perPagecount);
//        valueIn.setPage(destPage);
        EpgResult result = columnDs.getData();
        List<ChannelRemindInfo> vColumnData = (Vector) result.getData();
        StringBuffer sb = new StringBuffer();
        sb.append("[");
        totalSize = vColumnData.size();
        ChannelRemindInfo channelRemindInfo = null;
        long timeValue = 0;
        String contentname = "";
        int isRemindNow =0;
        List prevueidList = new ArrayList();
        if (totalSize > 0) {
            for (int i = 0; i < totalSize ; i++) {
                channelRemindInfo = (ChannelRemindInfo)vColumnData.get(i);
                int channelcode = channelRemindInfo.getChannelNo();
                String begintime = channelRemindInfo.getStarttime();
                String endtime = channelRemindInfo.getEndtime();
                contentname = channelRemindInfo.getPrevuename();
                Date beginDate=format.parse(begintime);
                if(prevueidList.indexOf(channelRemindInfo.getPrevuecode())==-1){
                    prevueidList.add(channelRemindInfo.getPrevuecode());
                }else{
                    System.out.println("SSSSSSSSSSSSSSrepeat!!!!!=");
                    continue;
                }
                // 需要立即提醒
                System.out.println("SSSSSSSSSSSSSSprogram_endTime="+endtime);
                if (begintime.compareTo(nowtime) <= 0) {
                    if(endtime.compareTo(nowtime)<=0){//否则检查节目是否已经播放完，防止epg过期数据没有清除。
                        System.out.println("SSSSSSSSSSSSSSguoqi!!!!!=");
                        continue;
                    }else{ //节目正在播放应该立即提醒
                        isRemindNow = 1;
                        timeValue = 0;
                    }
                } else {
                    isRemindNow = 0;
                    timeValue=beginDate.getTime()-nowdate.getTime()-iaheadTimeMinute*60*1000;
                    if(timeValue<0){
                        timeValue = 0;
                    }
                }

                //如果非开机不需要提醒没有延迟的提醒，因为没有延迟的提醒肯定提醒过了。
                if(isReminderProgramPlay.equals("0") && timeValue<=0){
                    System.out.println("SSSSSSSSSSSSSSlijitixing!!!!!=");
                    continue;
                }

                if (i > 0 && i < totalSize && sb.length()!=1) {
                    sb.append(",");
                }

                sb.append("{channelcode:\"" + channelcode + "\",");
                sb.append("begintime:\"" + begintime + "\",");
                sb.append("isRemindNow:\"" + isRemindNow + "\",");
                sb.append("timeValue:\"" + timeValue + "\",");
                sb.append("prevuename:\"" + contentname + "\"}");
            }
        }

//test data
//        sb.append("{channelcode:\"5\",begintime:\"2012.04.17 08:00:01\",isRemindNow:\"1\",timeValue:\"1000\",prevuename:\"YEST111\"}");
//        sb.append(",{channelcode:\"6\",begintime:\"2012.04.17 08:22:01\",isRemindNow:\"0\",timeValue:\"0000\",prevuename:\"YEST222\"}");
        sb.append("]");
        System.out.println("==========sb111==========" + sb.toString());
        out.print(sb.toString());
    }catch (Exception e){
        e.printStackTrace();
        System.out.println("SSSSSSSSSSSSSSSSSSSquery_reminder_list_error!!!");
    }

%>


