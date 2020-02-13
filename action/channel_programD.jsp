<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelOneForeshowDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ChannelForeshowQueryValueIn" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.newepg.decorator.ChannelOneForeshowDecorator" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<epg:PageController/>
<%!
    /**
     * 判断字符是否为中文
     *
     * @param str
     *            指定的字符
     * @return true or false
     */
    public boolean isChinese(String str) {
        boolean value = false;
        String chinese = "[\u0391-\uFFE5]";
        if (str.matches(chinese)) {
            value = true;
        }
        return value;
    }


    /**
     * 获取字符串的长度，如果有中文，则每个中文字符计为2位
     *
     * @param value
     *            指定的字符串
     * @return 字符串的长度
     */
    public int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1 */
        for (int i = 0; i < value.length(); i++) {
            /* 获取一个字符 */
            String temp = value.substring(i, i + 1);
            /* 判断是否为中文字符 */
            if (isChinese(temp)) {
                /* 中文字符长度为2 */
                valueLength += 2;
            } else {
                /* 其他字符长度为1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }

    /**
     * 根据输入字符串的字体大小和div的宽度，截取不会折行的字符串，超过div宽度的后面加".."
     * @param text  原始字符串
     * @param px  字体大小，以px为单位
     * @param divwidth  div的宽度，以px为单位
     * @return 适合宽度的字符串
     */
    public String getFitString(String text, int px, int divwidth) {
        int curwidth = 0;
        String distext = "";
        int stringwidth = length(text) * px / 2;
        divwidth = divwidth - (divwidth % px);
        if (divwidth >= stringwidth) {
            distext = text;
        } else {
            for (int i = 0; i < text.length(); i++) {
                String chartemp = text.substring(i, i + 1);
                if (isChinese(chartemp)) {
                    curwidth = curwidth + px;
                } else {
                    curwidth = curwidth + px / 2;
                }
                if (curwidth > divwidth - px) {
                    break;
                }
                distext = distext + chartemp;
            }
            distext = distext + "..";
        }
        return distext;
    }
%>
<%!
    public String formatDate(String str) {
        StringBuffer sb = new StringBuffer();

        sb.append(str.substring(0, 4)).append(str.substring(5, 7)).append(str.substring(8, 10)).append(str.substring(11, 13)).append(str.substring(14, 16)).append(str.substring(17, 19));
        return sb.toString();
    }

    public String getPath(String uri) {
        String path = "";
        int begin = 0;
        int end = uri.lastIndexOf('/');
        if (end > 0) {
            path = uri.substring(begin, end + 1) + path;
        }
        return path;
    }
  public String getFitStringNew(String text) {
        if(text!=null && text.length()>9){
            text = text.substring(0,9)+"...";
        }
        return text;
    }
%>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    SimpleDateFormat formatOutputHour = new SimpleDateFormat("HH:mm");
    SimpleDateFormat formatOutput = new SimpleDateFormat("yyyy.MM.dd");
    String dateString = formatOutput.format(new Date());
    String columnId = request.getParameter("columnid");
    String channelId = request.getParameter("channelid");

    String startTime = formatOutputHour.format(new Date());
    startTime = startTime == null ? "" : startTime;
	
    String startTimeStr = dateString+" 00:00:00";
    String curTimeStr = dateString+" "+startTime+":00";
    Calendar calendar = new GregorianCalendar();
    calendar.setTime(new Date());
    calendar.add(calendar.DAY_OF_YEAR, 1);
    String endTimeStr = formatOutput.format(calendar.getTime())+" 23:59:59";
    String prevueSql = " channelcode='"+channelId+"' and begintime>'"+startTimeStr+"' and endtime<'"+endTimeStr+"'";
    String prevueOrder="begintime asc";
    Map programInfo = null;
    List channelPrevueList = new ArrayList();
%>	
<ex:search tablename="user_channelprevue" fields="*" order="<%=prevueOrder%>" condition="<%=prevueSql%>" var="prevuelist">
    <%
		List<Map> prevueList = (List<Map>)pageContext.getAttribute("prevuelist");
		//out.print("777777prevueList.size()="+prevueList.size());
		//out.print("*****66666prevueList="+prevueList); 
		for(int i=0;i<prevueList.size();i++){
			Map prevueInfo = (Map)prevueList.get(i);
			String prevueCode = (String)prevueInfo.get("prevuecode");
			String prevueName = (String)prevueInfo.get("prevuename");
			String beginTime = (String)prevueInfo.get("begintime");
			String endTime = (String)prevueInfo.get("endtime");
			if(curTimeStr.compareTo(endTime)<0){                       
				programInfo = new HashMap();
				programInfo.put("startime",beginTime.substring(11,16)+"-");
				programInfo.put("endtime",endTime.substring(11,16));
				programInfo.put("programname",prevueName);
				//out.println("6666666programInfo="+programInfo.toString());
				channelPrevueList.add(programInfo);
				if(channelPrevueList.size() >= 3){
					break;
				}
			}
		}
		while(channelPrevueList.size()<3){
			//out.print("***channelPrevueList.size()="+channelPrevueList.size());
			programInfo = new HashMap();
			programInfo.put("startime","  ");
			programInfo.put("endtime","   ");
			programInfo.put("programname","无节目");
			channelPrevueList.add(programInfo);
		}

		StringBuffer curProgram = new StringBuffer("节目名称").append(":").append("无");
		StringBuffer nextProgram = new StringBuffer("节目名称").append(":").append("无");
		StringBuffer thirdProgram = new StringBuffer("节目名称").append(":").append("无");
		String Proname="";
		programInfo = (HashMap)channelPrevueList.get(0);
		Proname=programInfo.get("programname").toString();
	  //  Proname=getFitString(Proname, 18, 180);
		Proname=getFitStringNew(Proname);
		curProgram = new StringBuffer("").append(Proname).append("<br/>");
		curProgram.append(programInfo.get("startime")).append(programInfo.get("endtime")).append("<br/>");
		
		programInfo = (HashMap)channelPrevueList.get(1);
		Proname=programInfo.get("programname").toString();
	  //  Proname=getFitString(Proname, 18, 180);
		Proname=getFitStringNew(Proname);
		nextProgram = new StringBuffer("").append(Proname).append("<br/>");
		nextProgram.append(programInfo.get("startime")).append(programInfo.get("endtime")).append("<br/>");

		programInfo = (HashMap)channelPrevueList.get(2);
		Proname=programInfo.get("programname").toString();
	  //  Proname=getFitString(Proname, 18, 180);
	    Proname=getFitStringNew(Proname);
		thirdProgram = new StringBuffer("").append(Proname).append("<br/>");
		thirdProgram.append(programInfo.get("startime")).append(programInfo.get("endtime")).append("<br/>");

		StringBuffer sb = new StringBuffer();
		String HasCurProgram = "1";
		if(curProgram.toString().startsWith("无节目")){
			HasCurProgram = "0";
		}
		sb.append("{curprogram:\"" + curProgram + "\",");
		sb.append("HasCurProgram:\"" + HasCurProgram + "\",");
		sb.append("nextprogram:\"" + nextProgram + "\",");
		sb.append("thirdprogram:\"" + thirdProgram + "\"}");
		JspWriter ot = pageContext.getOut();
		ot.write(sb.toString());
	%>
</ex:search>

