<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.content.ProgramInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController  />
<%
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String columnId = (String)param.get("columnid");
    String maxno = (String)param.get("mixno");
    String channelId = request.getParameter("channelid");
    SimpleDateFormat formater = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
    Date today = formater.parse(formater.format(new Date()));
    String strToday = sdf.format(new Date());
    Calendar calendar = Calendar.getInstance();
    calendar.add(5,1);
    String nextDay = ""+calendar.get(1)+"."+(calendar.get(2)+1)+"."+calendar.get(5);
    ProgramInfo curProgramInfo = null;  //The current program
    ProgramInfo nextProgramInfo = null; //The next program
    int position = -1;

    try {
        ChannelOneForeshowDataSource dataSource = new ChannelOneForeshowDataSource();
        ChannelForeshowQueryValueIn valueIn = (ChannelForeshowQueryValueIn) dataSource.getValueIn();
        valueIn.setUserInfo(userInfo);
        valueIn.setDate(strToday);
        valueIn.setChannelId(channelId);
        valueIn.setColumnId(columnId);
        EpgResult result = dataSource.getData();
        List programList = (Vector) result.getData();
        ProgramInfo programInfo = null;
        if(programList != null && programList.size() > 0) {
            for(int i = 0; i < programList.size(); i++) {
                programInfo = (ProgramInfo)programList.get(i);
                Date startTime = formater.parse(programInfo.getStartTime());
                Date endTime = formater.parse(programInfo.getEndTime());
                if(today.after(startTime) && today.before(endTime)) {
                    if(programInfo.getContentName().length() > 15) {
                        programInfo.setContentName(programInfo.getContentName().substring(0,15));
                    }
                    if(programInfo.getContentDescription().length()>80){
                        programInfo.setContentDescription(programInfo.getContentDescription().substring(0,80));
                    }
                    StringBuffer timeInfo=new StringBuffer(programInfo.getStartTime().substring(11,16));
                    timeInfo.append("-").append(programInfo.getEndTime().substring(11,16)).append(" ");
                    timeInfo.append((endTime.getTime() - startTime.getTime())/1000/60);
                    programInfo.setActiontime(timeInfo.toString());
                    curProgramInfo = programInfo;
                    position = i;
                    break;
                }
            }
            if(position != -1) {
                if(programList.size() - position > 1) {
                    nextProgramInfo = (ProgramInfo) programList.get(position+1);
                } else {
                    valueIn.setDate(nextDay);
                    result = dataSource.getData();
                    programList = (Vector) result.getData();
                    if(programList != null && programList.size() > 0) {
                        nextProgramInfo = (ProgramInfo) programList.get(0);
                    }
                }
            } else {
                programInfo = (ProgramInfo)programList.get(0);
                Date startTime = formater.parse(programInfo.getStartTime());
                if(today.before(startTime)) {
                    nextProgramInfo = programInfo;
                } else {
                    for(int i = 0; i < programList.size(); i++) {
                        programInfo = (ProgramInfo)programList.get(i);
                        Date endTime = formater.parse(programInfo.getEndTime());
                        if(today.after(endTime)) {
                            programInfo = (ProgramInfo)programList.get(i+1);
                            startTime = formater.parse(programInfo.getStartTime());
                            if(today.before(startTime)) {
                                nextProgramInfo = (ProgramInfo) programList.get(i+1);
                                break;
                            }
                        }
                    }
                }
            }
        } else {
            valueIn.setDate(nextDay);
            result = dataSource.getData();
            programList = (Vector) result.getData();
            if(programList != null && programList.size() > 0) {
                 nextProgramInfo = (ProgramInfo) programList.get(0);
            }
        }
    } catch(Exception e) {}

    StringBuffer curProgram = new StringBuffer("节目名称").append(":").append("无");
    StringBuffer nextProgram = new StringBuffer("节目名称").append(":").append("无");
    if(curProgramInfo != null) {
        curProgram = new StringBuffer("节目名称").append(":").append(curProgramInfo.getContentName()).append("<br/>");
        curProgram.append(curProgramInfo.getActiontime()).append("<br/>");

    }
    if(nextProgramInfo != null) {
        String nextProgramName = nextProgramInfo.getContentName();
        if(nextProgramName.length() > 16) {
            nextProgramName = nextProgramName.substring(0,16) + "...";
        }
        nextProgram = new StringBuffer("节目名称").append(":").append(nextProgramName);
    }           

%>
 <div id="curChannel" style="left:51;top:580;height:30;width:200;border:1px red solid">adfasdfasdfasdf</div>
<%--<div id="curTime" style="left:551;top:580;height:30;width:200;"  ><%=today%></div>--%>
   <%--<div id="curProgram" style="left:51;top:580;height:30;width:200;"  ><%=curProgram.toString()%></div>--%>
<%--<div id="nextProgram" style="left:351;top:580;height:30;width:200;"  ><%=nextProgram.toString()%></div>--%>
<%--<script type="text/javascript">--%>
    <%--document.getElementById("curChannel").innerHTML="<%=curProgramInfo.getChannelcode()%>";--%>
    <%--document.getElementById("curTime").innerHTML="<%=today%>";--%>
    <%--document.getElementById("curProgram").innerHTML="<%=curProgram.toString()%>";--%>
    <%--document.getElementById("nextProgram").innerHTML="<%=nextProgram.toString()%>";--%>
<%--</script>--%>
