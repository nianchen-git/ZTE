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
<%@ page import="org.apache.http.client.methods.HttpPost"%>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient"%>
<%@ page import="org.apache.http.entity.StringEntity"%>

<%@ page import="org.apache.http.util.EntityUtils"%>
<%
request.setCharacterEncoding("utf-8");
%>
<%!
	public String HttpRequest(String transactionID,String userID,String productID,String serviceID,String contentID,String payDitch,String SeriesID,String notice_url) throws ClientProtocolException, IOException{      
       
		JSONArray jsonArr = new JSONArray();
		
		String url = "http://210.13.0.139:8080/iptv_tpp/order/epayOrder";
		HttpClient httpClient = new DefaultHttpClient();  
        HttpPost httpPost = new HttpPost(url);  
	
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("ditch","9999");
		jsonObj.put("transactionID",transactionID);
		jsonObj.put("userID",userID);
		jsonObj.put("productID",productID);
		jsonObj.put("serviceID",serviceID);
		jsonObj.put("seriesID",SeriesID);
		jsonObj.put("contentID",contentID);
		jsonObj.put("payDitch",payDitch);
		jsonObj.put("payFee","");
		jsonObj.put("notice_url",notice_url);
		StringEntity s = new StringEntity(jsonObj.toString());
		s.setContentEncoding("UTF-8");
		s.setContentType("application/json");
		httpPost.setEntity(s);
		HttpResponse result = httpClient.execute(httpPost);
        String json_str = EntityUtils.toString(result.getEntity());  
		return json_str;
	
    } 
	public String getFixLenthString(int strLength) {  
      
		Random rm = new Random();  
		  
		// 获得随机数  
		double pross = (1 + rm.nextDouble()) * Math.pow(10, strLength);  
	  
		// 将获得的获得随机数转化为字符串  
		String fixLenthString = String.valueOf(pross);  
	  
		// 返回固定的长度的随机数  
		return fixLenthString.substring(1, strLength + 1);  
	}     

%>
<%
   
 
    String contentid=request.getParameter("ContentID")==null?"":request.getParameter("ContentID");
  
    
    String ProductID=request.getParameter("ProductID")==null?"":request.getParameter("ProductID");
	String ServiceID=request.getParameter("ServiceID")==null?"":request.getParameter("ServiceID");
	String SeriesID=request.getParameter("SeriesID")==null?"":request.getParameter("SeriesID");
	String payDitch="1";

  StringBuffer sb = new StringBuffer();
 UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();
	String userToken = userInfo.getUserToken();
  UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String requestUrl = "";
 
	
   String[] randomarray = new String[2]; //新建一个int类型数组
   int i=0;
	while ( i < 2) {  
	  randomarray[i]= getFixLenthString(3); 
        i++;  
    }  
	Date date = new Date();
  SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
  String str = sdf.format(date);
	String transactionID="9999"+randomarray[0]+str+randomarray[1];	
	
	String result1 = HttpRequest(transactionID,userId,ProductID,ServiceID,contentid,payDitch,SeriesID,requestUrl);
	//JSONObject jsonresult = JSONObject.fromObject(result1.toString());
	
String callbackFn = request.getParameter("callback");
String jsonResult="";

	jsonResult = callbackFn + "("+result1+")";


sb.append(jsonResult);
JspWriter ot = pageContext.getOut();
   ot.write(sb.toString());
	

%> 

