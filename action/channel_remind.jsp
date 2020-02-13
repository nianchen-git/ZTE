<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@page import="java.util.HashMap" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodDataSource" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="java.util.Vector" %>
<%@ page import="com.zte.iptv.newepg.datasource.DoPrecontractDataSource" %>
<%@ page import="com.zte.iptv.epg.newaccount.ParaConstants" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>


<epg:PageController/>
<%
    String Prevue_id = request.getParameter("Prevue_id");
    int flag = 0;
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    try{
        Map param=new HashMap();
        param.put(EpgConstants.USERINFO,userInfo);
    //    param.put(ParaConstants.Prevue_id,Prevue_id);
    //    param.put("ActionType","1");
        param.put(ParaConstants.Action,"1");
        param.put(ParaConstants.PREVUECODE ,Prevue_id);
        DoPrecontractDataSource datasource=new DoPrecontractDataSource();
        datasource.setParamValues(param);
        Result result = datasource.execute();
        flag = result.getFlag();
    }catch (Exception e){
//        e.printStackTrace();
        System.out.println("SSSSSSSSSSSSSSSSaction/add_reminder_error!!!!");
    }
    System.out.println("SSSSSSSSSSSSSSSSSflag="+flag);
    JspWriter ot = pageContext.getOut();
    ot.write("{flag:\""+flag+"\"}");
%>

