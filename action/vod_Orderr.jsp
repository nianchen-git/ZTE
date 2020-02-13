<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.util.CodeBook" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.*" %>
<%@ page import="com.zte.iptv.epg.web.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@page isELIgnored="false"%> 
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex"%> 
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@page import="net.sf.json.*"%>
<%@page import="java.text.*" %>
<%
    String playUrl = "";
    String categoryIda = request.getParameter("CategoryID").toString();
    String contentIda=request.getParameter("ContentID").toString();
    String puchaseTypea=request.getParameter("PurchaseType").toString();
    String productIDa =request.getParameter("ProductID").toString();
	
	
    String programtype=request.getParameter("programtype");
	String columnid = request.getParameter("CategoryID");
    String strADid = request.getParameter("strADid");
    String strADid2 = request.getParameter("strADid2");
    String programid = request.getParameter("programid");
	String fathercontent=request.getParameter("FatherContent");
	String seriesProgramId=request.getParameter("seriesProgramId");
	String authprogramtype=request.getParameter("programtype");
    int flag=0;
	int error_code=0;
	//String results="";
	//StringBuffer sb = new StringBuffer();
	if(programtype.equals("10")){
		authprogramtype="14";	
	}
	JSONObject jsonObj = new JSONObject();
%> 

<ex:params var="orderParams">
	<ex:param name="action"    value="1"/>
	<ex:param name="contenttype"    value="<%=authprogramtype%>"/>
	<ex:param name="isautocontinue"     value="1"/>
	<ex:param name="productid"    value="<%=productIDa%>"/>
	<ex:param name="contentid"    value="<%=programid%>"/>
	<ex:param name="categoryid"    value="<%=categoryIda%>"/>
	<ex:param name="purchasetype"   value="<%=puchaseTypea%>"/>
</ex:params>

<ex:action name="subscribe" inputparams="${orderParams}" var="authMap">
	<%
		Map authResult = (Map) pageContext.getAttribute("authMap");
	    flag = Integer.parseInt(authResult.get("_flag").toString());
		error_code = Integer.parseInt(authResult.get("_error_code").toString());
		
		if(flag == 0){//auth success
		
			if(programtype.equals("10")){
				playUrl=  "vod_order_success.jsp?columnid=" + columnid + "&programid=" + seriesProgramId +"&"
					+EpgConstants.CONTENT_ID+"="+contentIda+ "&FatherContent="+ fathercontent
					+"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" +CodeBook.VOD_TYPE_SERIES_Single+"&strADid="+strADid+"&strADid2="+strADid2;
			} else{
				playUrl = "vod_order_success.jsp?columnid=" + columnid + "&programid=" + programid +"&"
					 +EpgConstants.CONTENT_ID+"="+contentIda+ "&FatherContent="+ fathercontent
					 +"&programtype="+programtype+"&" + EpgConstants.VOD_TYPE + "=" + CodeBook.PLAY_TYPE_VOD+"&strADid="+strADid+"&strADid2="+strADid2; 
			}			
		}else{
			playUrl="";
			
		}
	%>
</ex:action>
				
<%	
	//sb.append("{returncode:"+error_code+",");
	//sb.append("{playUrl:\""+playUrl+"\",");
    //sb.append("orderFlag:"+flag);
	//sb.append("}");
	jsonObj.put("returncode",error_code);
	jsonObj.put("playUrl",playUrl);
	jsonObj.put("orderFlag",flag);
		
	JspWriter ot = pageContext.getOut();
	ot.write(jsonObj.toString());	
%>	
