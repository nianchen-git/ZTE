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
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>


<%
	String productIDa =request.getParameter("ProductID").toString();
	String puchaseTypea =request.getParameter("puchaseType").toString();
	String contentIda=request.getParameter("ContentID").toString();

	String startTime = (String)request.getAttribute(EpgConstants.START_TIME);
	String endTime = (String)request.getAttribute(EpgConstants.END_TIME);
	String playUrl = "";

	int flag=0;
	int error_code=0;
	String results="";
	//StringBuffer sb = new StringBuffer();
	JSONObject jsonObj = new JSONObject();
%>
<ex:params var="orderParams">
	<ex:param name="action"    value="1"/>
	<ex:param name="contenttype"    value="2"/>
	<ex:param name="isautocontinue"     value="1"/>
	<ex:param name="productid"    value="<%=productIDa%>"/>
	<ex:param name="contentid"    value="<%=contentIda%>"/>
	<ex:param name="purchasetype"   value="<%=puchaseTypea%>"/>
</ex:params>
<ex:action name="subscribe" inputparams="${orderParams}" var="authMap">
	<%
		Map authResult = (Map) pageContext.getAttribute("authMap");
		flag = Integer.parseInt(authResult.get("_flag").toString());
		error_code = Integer.parseInt(authResult.get("_error_code").toString());
		if(flag == 0){//auth success
			  playUrl="channelOrderSuccess.jsp";
		}else{
			  playUrl="";
		}
	%>
</ex:action>
<%
	//sb.append("{returncode:"+error_code+",");
	//sb.append("playUrl:\""+playUrl+"\",");
    //sb.append("orderFlag:"+flag);
	//sb.append("}");
	jsonObj.put("returncode",error_code);
	jsonObj.put("playUrl",playUrl);
	jsonObj.put("orderFlag",flag);
	JspWriter ot = pageContext.getOut();
    ot.write(jsonObj.toString());
%>
