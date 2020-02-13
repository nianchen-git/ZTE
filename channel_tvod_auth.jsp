<%@page contentType="text/html; charset=GBK"%>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg"%>
<%@page import="com.zte.iptv.epg.util.EpgConstants"%>
<%@page import="com.zte.iptv.epg.account.UserInfo"%>
<%@page import="com.zte.iptv.epg.util.CodeBook" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils"%>
<%@page import="java.util.HashMap" %>
<%@page import="com.zte.iptv.epg.util.STBKeysNew"%>
<%@page import="com.zte.iptv.newepg.datasource.EpgDataSource"%>
<%@page import="com.zte.iptv.newepg.datasource.EpgResult"%>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List" %>
<%@page import="com.zte.iptv.epg.util.CodeBookNew" %>
<%@include file="inc/ad_utils.jsp" %>
<%
  System.out.println("=========getQueryString=5555555=========" + request.getQueryString());
  String channelId = request.getParameter(EpgConstants.FATHER_CONTENT);
  String columnId = request.getParameter(EpgConstants.CATEGORY_ID);
  String contentcode = request.getParameter("contentCode");
  String prevueid = request.getParameter("prevueid");

  
  StringBuffer sb = new StringBuffer();
  sb.append("channel_tvod_play.jsp").append("?").append(EpgConstants.PROGRAM_ID).append("=").append(contentcode).
  append("&").append(EpgConstants.CONTENT_CODE).append("=").append(contentcode).
  append("&").append(EpgConstants.COLUMN_ID).append("=").append(columnId).
  append("&").append(EpgConstants.CHANNEL_ID).append("=").append(channelId).append("&prevueid=").append(prevueid);
  String tvodPlayUrl = sb.toString();
  session.setAttribute("tvod_playUrl",tvodPlayUrl);
  pageContext.setAttribute(EpgConstants.CHANNEL_OPERATION,EpgConstants.CHANNEL_AUTH,PageContext.REQUEST_SCOPE);
%>
<epg:PageController name="back.jsp"/>
<epg:operate datasource="com.zte.iptv.functionepg.decorator.AuthAndShowProductListDecorator" operator="CriteriaAuthOperator" success="<%=tvodPlayUrl%>" redirected="false" failure="message.jsp"/>
<html>
<head>
<title>Authorization</title>
  <epg:script/>
</head>
<script language="javascript" type="">
    top.productList =[];
<%




	EpgResult result = (EpgResult) pageContext.getAttribute("Result");
	if(result==null)
		return;

    if (result.isEmpty()) {
        return;
    }
    Map map = result.getDataOut();
    Map dataOut = (Map)map.get(EpgResult.DATA);

    Vector vContentId = getVParamFromField(dataOut, "ContentID");
    Vector vServiceId = getVParamFromField(dataOut, "ServiceID");
    Vector vProductId = getVParamFromField(dataOut, "ProductID");
    Vector vProductName = getVParamFromField(dataOut, "ProductName");
    Vector vListPrice = getVParamFromField(dataOut, "ListPrice");
    Vector vPurchaseType = getVParamFromField(dataOut, "PurchaseType");
    Vector vFee = getVParamFromField(dataOut, "Fee");
    Vector vStartTime= getVParamFromField(dataOut, "StartTime");
    Vector vEndTime=getVParamFromField(dataOut, "EndTime");
    Vector vRentalTerm=getVParamFromField(dataOut, "RentalTerm");
    Vector vLimitTimes=getVParamFromField(dataOut, "LimitTimes");
    Vector vFlag=getVParamFromField(dataOut, "flag");
    Vector vAutoContinueOption = getVParamFromField(dataOut, "AutoContinueOption");
    System.out.println("==========================channeltvodvAutoContinueOption="+vAutoContinueOption);
    if(vAutoContinueOption!= null){
        %>
        <%
        for(int i=0; i<vContentId.size();i++){
        %>
        top.jsAddProduct('<%=(String)vContentId.get(i)%>','<%=(String)vServiceId.get(i)%>',
                            '<%=(String)vProductId.get(i)%>','<%=(String)vProductName.get(i)%>',
                            '<%=""+vListPrice.get(i)%>','<%=""+vFee.get(i)%>',
                            '<%=""+vPurchaseType.get(i)%>','<%=""+vRentalTerm.get(i)%>',
                            '<%=""+vLimitTimes.get(i)%>','<%=""+vFlag.get(i)%>',
                            '<%=""+vStartTime.get(i)%>','<%=""+vEndTime.get(i)%>','<%=""+vAutoContinueOption.get(i)%>');
        <%
        }
    }else{
        %>
            //alert('==========================vAutoContinueOption==null');
        <%
        for(int i=0; i<vContentId.size();i++){
        %>
        top.jsAddProduct('<%=(String)vContentId.get(i)%>','<%=(String)vServiceId.get(i)%>',
                            '<%=(String)vProductId.get(i)%>','<%=(String)vProductName.get(i)%>',
                            '<%=""+vListPrice.get(i)%>','<%=""+vFee.get(i)%>',
                            '<%=""+vPurchaseType.get(i)%>','<%=""+vRentalTerm.get(i)%>',
                            '<%=""+vLimitTimes.get(i)%>','<%=""+vFlag.get(i)%>',
                            '<%=""+vStartTime.get(i)%>','<%=""+vEndTime.get(i)%>');
        <%
        }
    }
	if(1==1){
	   System.out.println("SSSSSSSSSSSSSSSSSSSSSSSSSSSS44444");
	   request.setAttribute("tips","?¨²?1??¨®D1o?¨°???¨²??(2003)");
       pageContext.forward("message1.jsp");
	   //response.sendRedirect("message1.jsp");
       return;
    }
%>
	top.jsAuthNotSubscribe();
</script>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<body bgcolor="transparent">
</body>
</html>
