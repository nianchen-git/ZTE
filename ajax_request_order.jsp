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


<%
String productIDa =request.getParameter("productID").toString();
String puchaseTypea =request.getParameter("puchaseType").toString();
String contentIda=request.getParameter("contentid").toString();
String categoryIda=request.getParameter("categoryid").toString();

String contenttypeIda=request.getParameter("contenttype") == null ?"1":request.getParameter("contenttype").toString();
int flag=0;
int error_code=0;
String results="";
StringBuffer sb = new StringBuffer();
%>
	    <ex:params var="orderParams">
				<ex:param name="action"    value="1"/>
				<ex:param name="contenttype"    value="<%=contenttypeIda%>"/>
				<ex:param name="isautocontinue"     value="1"/>
				<ex:param name="productid"    value="<%=productIDa%>"/>
				<ex:param name="contentid"    value="<%=contentIda%>"/>
				<ex:param name="categoryid"    value="<%=categoryIda%>"/>
				<ex:param name="purchasetype"   value="<%=puchaseTypea%>"/>
				</ex:params>
				<ex:action name="subscribe" inputparams="${orderParams}" var="authMap">
				<%
				Map authResult = (Map) pageContext.getAttribute("authMap");
				 flag = Integer.parseInt(authResult.get("_flag").toString());
				  error_code = Integer.parseInt(authResult.get("_error_code").toString());
				if(flag == 0){//auth success
					results="0";
				}else{
					results=authResult.get("_return_message").toString();
			    }
				%>
				</ex:action>
<%
String callbackFn = request.getParameter("callback");
String jsonResult=callbackFn + "("+"[{flag:\"" + flag + "\",error_code:\"" + error_code +"\",product:\"0\"}]"+")";

sb.append(jsonResult);
JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>
