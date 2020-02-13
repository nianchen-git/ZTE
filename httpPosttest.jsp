<%@page import="java.net.URLConnection" %>
<%@page import="java.net.HttpURLConnection" %>
<%@page import="java.io.*" %>
<%@page import="java.net.URL" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@page import="net.sf.json.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>

<%!
    public static String postJson(String url, String jsonStr) {
        String encoding = "utf-8";
        String result = null;
        HttpURLConnection conn;
        try {
            URL urlAddr = new URL(url);
            conn = (HttpURLConnection) urlAddr.openConnection();
            conn.setRequestProperty("User-Agent", "openwave(compatible;MSIE7.0;)");
            conn.setConnectTimeout(10 * 1000);
            conn.setReadTimeout(180 * 1000);
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json;charset=GBK");
            conn.setRequestProperty("ContentEncoding", encoding);
            Writer writer = new OutputStreamWriter(conn.getOutputStream(), encoding);
            writer.write(jsonStr);
            writer.flush();
            writer.close();

            StringBuilder retVal = new StringBuilder();
            BufferedReader l_reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "GBK"));
            String sCurrentLine = "";
            while ((sCurrentLine = l_reader.readLine()) != null) {
                retVal.append(sCurrentLine.trim());
            }
            result = retVal.toString();
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
%>
<%
    /*接收js页面传过来的参数*/

    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userToken = userInfo.getUserToken();
    String userId = userInfo.getUserId();//获取用户账号
    String falg = request.getParameter("falg");
    String retro = null;
    long date = new Date().getTime();
    String transactionID = "" + userId + date;
    if(falg == "1" || falg.equals("1")){
        String timeStamp = "" + date;
        String productListStr = request.getParameter("ProductID");
        String productStr = productListStr.replace(",", "\",\"");
        String productID = "\"" + productStr + "\"";
        retro = "{\"transactionID\":\""+transactionID +"\",\"userID\":\"" + userId +
        "\",\"ditch\":\"6\",\"userToken\":\""+userToken+"\",\"ProductID\":[" + productID + "],\"timeStamp\":\"" + timeStamp + "\"}";
        retro = postJson("http://210.13.0.139:8801/iptv_service/service/auth/subAuth", retro);
    }else if(falg == "2" || falg.equals("2")){

        String TransactionID = request.getParameter("TransactionID");//订购的事务编号
        String ProductID = request.getParameter("ProductID");//需要订购的产品ID
        String OrderType = request.getParameter("OrderType");//订购方式[1：升级订购 2：独立订购]
        String upgradeSeq = request.getParameter("upgradeSeq");//升级序号[升级订购必传]
        String Action = request.getParameter("Action");//操作类型[1：表示订购 2：表示退订]
        String upgradeType = request.getParameter("upgradeType");//升级结余金额处理方式,组合产品必传[1：转时间 2：转余额]

        retro = "{\"TransactionID\":\""+TransactionID +"\",\"UserID\":\"" + userId +
                "\",\"Ditch\":\"6\",\"UserToken\":\""+userToken+"\",\"ProductID\":\"" + ProductID + "\",\"OrderType\":\"" + OrderType +"\",\"Action\":\""+Action+"\",\"upgradeSeq\":\""+upgradeSeq+"\",\"upgradeType\":\""+upgradeType+"\"}";
        retro = postJson("http://210.13.0.139:8801/iptv_service/service/order/subjectOrder", retro);
    }else if(falg == "3" || falg.equals("3")){

        String TransactionID = request.getParameter("TransactionID");//订购的事务编号
        String ProductID = request.getParameter("ProductID");//需要订购的产品ID
        String OrderType = request.getParameter("OrderType");//订购方式[1：升级订购 2：独立订购]
        String upgradeSeq = request.getParameter("upgradeSeq");//升级序号[升级订购必传]
        String Action = request.getParameter("Action");//操作类型[1：表示订购 2：表示退订]
        String upgradeType = request.getParameter("upgradeType");//升级结余金额处理方式,组合产品必传[1：转时间 2：转余额]


        UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
        String timePath1 = request.getContextPath();
        String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
        String notice_url = timeBasePath + timeUserInfo.getUserModel()+"/HttpResponse_vod.jsp?userToken="+userToken;
        retro = "{\"transactionID\":\""+ transactionID +"\",\"userID\":\"" + userId +
                "\",\"ditch\":\"6\",\"productID\":\"" + ProductID +
                "\",\"upgradeSeq\":\""+upgradeSeq+"\",\"payDitch\":\"1\",\"notice_url\":\""+notice_url+"\"}";
        retro = postJson("http://210.13.0.139:8080/iptv_tpp/order/epayOrder", retro);

    }else if(falg == "4" || falg.equals("4")){
        String timeStamp = "" + date;
        String productListStr = request.getParameter("ProductID");
        String productStr = productListStr.replace(",", "\",\"");
        String productID = "\"" + productStr + "\"";
        retro = "{\"transactionID\":\""+transactionID +"\",\"userID\":\"" + userId +
                "\",\"ditch\":\"6\",\"userToken\":\""+userToken+"\",\"ProductID\":[" + productID + "],\"timeStamp\":\"" + timeStamp + "\"}";
        retro = postJson("http://210.13.0.139:8801/iptv_service/service/auth/subAuth", retro);

    }else if(falg == "5" || falg.equals("5")){

        String TransactionID = request.getParameter("TransactionID");//订购的事务编号
        String ProductID = request.getParameter("ProductID");//需要订购的产品ID
        String OrderType = request.getParameter("OrderType");//订购方式[1：升级订购 2：独立订购]
        String upgradeSeq = request.getParameter("upgradeSeq");//升级序号[升级订购必传]
        String Action = request.getParameter("Action");//操作类型[1：表示订购 2：表示退订]
        String upgradeType = request.getParameter("upgradeType");//升级结余金额处理方式,组合产品必传[1：转时间 2：转余额]

        retro = "{\"TransactionID\":\""+TransactionID +"\",\"UserID\":\"" + userId +
                "\",\"Ditch\":\"6\",\"UserToken\":\""+userToken+"\",\"ProductID\":\"" + ProductID + "\",\"OrderType\":\"" + OrderType +"\",\"Action\":\""+Action+"\",\"upgradeSeq\":\""+upgradeSeq+"\",\"upgradeType\":\""+upgradeType+"\"}";
        retro = postJson("http://210.13.0.139:8801/iptv_service/service/order/subjectOrder", retro);
    }else if(falg == "6" || falg.equals("6")){

        String TransactionID = request.getParameter("TransactionID");//订购的事务编号
        String ProductID = request.getParameter("ProductID");//需要订购的产品ID
        String OrderType = request.getParameter("OrderType");//订购方式[1：升级订购 2：独立订购]
        String upgradeSeq = request.getParameter("upgradeSeq");//升级序号[升级订购必传]
        String Action = request.getParameter("Action");//操作类型[1：表示订购 2：表示退订]
        String upgradeType = request.getParameter("upgradeType");//升级结余金额处理方式,组合产品必传[1：转时间 2：转余额]


        UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
        String timePath1 = request.getContextPath();
        String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
        String notice_url = timeBasePath + timeUserInfo.getUserModel()+"/HttpResponse_vod.jsp?userToken="+userToken;
        retro = "{\"transactionID\":\""+ transactionID +"\",\"userID\":\"" + userId +
                "\",\"ditch\":\"6\",\"productID\":\"" + ProductID +
                "\",\"upgradeSeq\":\""+upgradeSeq+"\",\"payDitch\":\"1\",\"notice_url\":\""+notice_url+"\"}";
        retro = postJson("http://210.13.0.139:8080/iptv_tpp/order/epayOrder", retro);

    }


    if(falg == "4" || falg.equals("4") || falg == "5" || falg.equals("5")|| falg == "6" || falg.equals("6")){
        String callbackFn = request.getParameter("callback");
        String ret = callbackFn + "(["+retro+"])";
        JspWriter ot = pageContext.getOut();
        ot.write(ret.toString());
    }else{
        out.print(retro);
    }
%>
