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
     * �ж��ַ��Ƿ�Ϊ����
     *
     * @param str
     *            ָ�����ַ�
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
     * ��ȡ�ַ����ĳ��ȣ���������ģ���ÿ�������ַ���Ϊ2λ
     *
     * @param value
     *            ָ�����ַ���
     * @return �ַ����ĳ���
     */
    public int length(String value) {
        int valueLength = 0;
        String chinese = "[\u0391-\uFFE5]";
        /* ��ȡ�ֶ�ֵ�ĳ��ȣ�����������ַ�����ÿ�������ַ�����Ϊ2������Ϊ1 */
        for (int i = 0; i < value.length(); i++) {
            /* ��ȡһ���ַ� */
            String temp = value.substring(i, i + 1);
            /* �ж��Ƿ�Ϊ�����ַ� */
            if (isChinese(temp)) {
                /* �����ַ�����Ϊ2 */
                valueLength += 2;
            } else {
                /* �����ַ�����Ϊ1 */
                valueLength += 1;
            }
        }
        return valueLength;
    }

    /**
     * ���������ַ����������С��div�Ŀ�ȣ���ȡ�������е��ַ���������div��ȵĺ����".."
     * @param text  ԭʼ�ַ���
     * @param px  �����С����pxΪ��λ
     * @param divwidth  div�Ŀ�ȣ���pxΪ��λ
     * @return �ʺϿ�ȵ��ַ���
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
			programInfo.put("programname","�޽�Ŀ");
			channelPrevueList.add(programInfo);
		}

		StringBuffer curProgram = new StringBuffer("��Ŀ����").append(":").append("��");
		StringBuffer nextProgram = new StringBuffer("��Ŀ����").append(":").append("��");
		StringBuffer thirdProgram = new StringBuffer("��Ŀ����").append(":").append("��");
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
		if(curProgram.toString().startsWith("�޽�Ŀ")){
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

