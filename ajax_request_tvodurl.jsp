<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.text.*" %>
<epg:PageController name="ajax_request_tvodurl.jsp"/>

<%
String scheduleCode =request.getParameter("global_code");
//String scheduleCode ="00000001000000070000000014683096";
String channelCode = "";
String prevueName="";
String columnCode = "";
String programType="4";//4：TVOD
String terminalflag = "1";
String definition = "1";
String mediaUrl="";
String authidsession="";
String prevuecode="";
JSONObject obj = new JSONObject();
int flag =0; 
String results = "";
StringBuffer sb = new StringBuffer();
%>
<%
        StringBuffer nextTvodSql = new StringBuffer();
        nextTvodSql.append(" mediacode = '").append(scheduleCode).append("'");
%>
<c:set var="nextTvodSqlcon" value="<%=nextTvodSql.toString()%>"/>
<ex:search tablename="user_channelprevue" fields="*" condition="${nextTvodSqlcon}" var="detaillist">
    <%
	List<Map> list = (List<Map>)pageContext.getAttribute("detaillist");
	if(list.size()>0){
	    Map detailMap = (Map)(list.get(0));
		channelCode=detailMap.get("channelcode").toString();	
		prevuecode=detailMap.get("prevuecode").toString();					
	}else{
		flag=1;
		results ="1";//未找到节目数据
	}																
    %>
</ex:search>
<%
if(flag==0){
%> 
<ex:params var="input">
 <ex:param name="channelcode" value="<%=channelCode%>"/>
</ex:params>
<ex:search tablename="user_sub_channel" fields="*" inputparams="${input}" pagecount="1" curpagenum="1" var="channellist">
<%
            List<Map> list = (List<Map>)pageContext.getAttribute("channellist");
            if(list.size() > 0){
                Map detailMap = (Map)(list.get(0));
                columnCode=detailMap.get("columncode").toString();
            }else{
				flag=1;
				results ="1";//未找到节目数据
			}
%>
</ex:search>
<%
}
if(flag==0){
%>
<ex:params var="authParams">
   <ex:param name="terminalflag" value="<%=terminalflag%>"/>
   <ex:param name="contenttype" value="<%=programType%>"/>
   <ex:param name="columncode" value="<%=columnCode%>"/>
   <ex:param name="definition"  value="<%=definition%>"/>
   <ex:param name="programcode" value="<%=prevuecode%>"/>
</ex:params>
<ex:action name="auth" inputparams="${authParams}" var="authMap">
<%
        JSONArray authArr = new JSONArray();
        Map authResult = (Map) pageContext.getAttribute("authMap");
        flag = Integer.parseInt(authResult.get("_flag").toString());
        if(flag == 0){//auth success
            JSONObject authObj = new JSONObject();
            Vector vodData = (Vector) authResult.get("data");
            Map productInfo = (HashMap) vodData.get(0);
            authidsession = (String)productInfo.get("AuthorizationID");
        }else{
			flag=1;
			results ="1";//未找到节目数据
		}
        
%>
</ex:action>
<%
}
if(flag==0){
%>
<ex:params var="inputPlayParams">
 <ex:param name="authidsession"  value="<%=authidsession%>"/>
 <ex:param name="prevuecode"     value="<%=prevuecode%>"/>
 <ex:param name="channelcode"    value="<%=channelCode%>"/>
</ex:params>
<ex:action name="tvod_play" inputparams="${inputPlayParams}" var="playMap">
<%
        Map result = (Map) pageContext.getAttribute ("playMap");
        String playurl = String.valueOf (result.get("playurl"));
        String result_flag=result.get("_flag").toString();
        obj.put("mediaUrl",playurl);
		results = playurl;
%>
</ex:action>
<%
}
%>
<%
//sb.append("{flag:\"" + flag + "\",result:\"" + results +"\"}");
String callbackFn = request.getParameter("callback");
String jsonResult = callbackFn + "("+"[{flag:\"" + flag + "\",result:\"" + results +"\"}]"+")";
sb.append(jsonResult);
JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>



