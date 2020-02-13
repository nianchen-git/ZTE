<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.log.Logger" %>
<%@ page import="com.zte.iptv.epg.log.LoggerFactory" %>
<%@ page import="com.zte.iptv.epg.log.LoggerModel" %>
<%@ page import="com.zte.iptv.epg.util.*" %>

<%@ page import="com.zte.iptv.newepg.tag.PageController" %>


<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Random" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>

<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.text.*" %>
<%--<%@ page import="com.zte.iptv.epg.content.QueryPagesImpApp" %>--%>
<%@ page import="java.io.IOException"%>
<%@ page import="org.apache.http.HttpResponse"%>
<%@ page import="org.apache.http.client.ClientProtocolException"%>
<%@ page import="org.apache.http.client.HttpClient"%>
<%@ page import="org.apache.http.client.methods.HttpGet"%>

<%@ page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@ page import="org.apache.http.entity.StringEntity"%>

<%@ page import="org.apache.http.util.EntityUtils"%>
<%
request.setCharacterEncoding("utf-8");
%>
<%!
	public String HttpRequest(String getUrl) throws ClientProtocolException, IOException{      
       
		JSONArray jsonArr = new JSONArray();
		
		
		HttpClient httpClient = new DefaultHttpClient();  
        HttpGet httpGet=  new HttpGet(getUrl);  
	
		
	
		HttpResponse result = httpClient.execute(httpGet);
	
        String json_str = EntityUtils.toString(result.getEntity());  
		return json_str;
	
    } 
	
%>
<%
   
 
    String transactionID=request.getParameter("transactionID")==null?"":request.getParameter("transactionID");
  
    String ditch = request.getParameter("ditch")==null?"9999":request.getParameter("ditch");

    String productID=request.getParameter("productID")==null?"":request.getParameter("productID");

	String payDitch="1";

  StringBuffer sb = new StringBuffer();  
 UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();
	String userToken = userInfo.getUserToken();
	String requestUrl="http://210.13.0.139:8080/iptv_tpp/order/checkEpayOrderState?ditch="+ditch+"&transactionID="+transactionID+"&productID="+productID+"&userID="+userId;
	String result1 = HttpRequest(requestUrl);
	//JSONObject jsonresult = JSONObject.fromObject(result1.toString());
	
String callbackFn = request.getParameter("callback");
String jsonResult="";

	jsonResult = callbackFn + "("+result1+")";


sb.append(jsonResult);
JspWriter ot = pageContext.getOut();
   ot.write(sb.toString());
	

%> 

