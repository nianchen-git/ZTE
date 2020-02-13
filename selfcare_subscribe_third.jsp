<%@ page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>

<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="java.text.DateFormat" %>

<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.text.*" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String purchasetype =request.getParameter("PurchaseType");
    String productid =request.getParameter("ProductID");
	String action =request.getParameter("Action");

	String  successUrl="";
	String  failedUrl="";
	int flag=0;
	int returncode=0;
	JSONObject jsonObj = new JSONObject();
%> 

<epg:PageController  checkusertoken="false"/>
  <ex:params var="orderParams">
        <ex:param name="action"    value="<%=action%>"/>
        <ex:param name="contenttype"    value="1"/>
        <ex:param name="productid"    value="<%=productid%>"/>
        <ex:param name="purchasetype"   value="<%=purchasetype%>"/>
 </ex:params>
    <ex:action name="subscribe" inputparams="${orderParams}" var="authMap">
    <%
    Map authResult = (Map) pageContext.getAttribute("authMap");
    flag = Integer.parseInt(authResult.get("_flag").toString());
    //out.print("aaaa"+authResult+"fffff"+flag);
    if(flag == 0){//ÍË¶©success
		  returncode = 1;
    }else if(flag == -1){//ÖØ¸´ÍË¶©
		  returncode = -1;
    }
    %>
    </ex:action>
	
	
<%
	jsonObj.put("subscribe_flag",returncode);
	JspWriter ot = pageContext.getOut();
    ot.write(jsonObj.toString());
%>