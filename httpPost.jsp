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
            conn.setRequestProperty("User-Agent", "openwave (compatible; MSIE 7.0;)");
            conn.setConnectTimeout(10 * 1000);
            conn.setReadTimeout(180 * 1000);
            conn.setUseCaches(false);
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json;charset=utf-8");
            conn.setRequestProperty("ContentEncoding", encoding);
            Writer writer = new OutputStreamWriter(conn.getOutputStream(),encoding);
            writer.write(jsonStr);
            writer.flush();
            writer.close();

            StringBuilder retVal = new StringBuilder();
            BufferedReader l_reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
            String sCurrentLine = "";
            while ((sCurrentLine = l_reader.readLine()) != null) {
                retVal.append(sCurrentLine.trim());
            }
            result = retVal.toString();
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return  result;
    }
    public String getRandomString(int leng) {
        StringBuffer buffer = new StringBuffer();
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyymmdd");
        String dateStr = sdf.format(date);
        buffer.append(dateStr);
        Random rm = new Random();
        Double pross = (1 + rm.nextDouble()) * Math.pow(10, leng);
        String formatmatStr = String.format("%20.3f", pross);
        formatmatStr = formatmatStr.substring(0, leng);
        buffer.append(formatmatStr);
        return buffer.toString();
    }
%>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();//获取用户账号
    String userToken = userInfo.getUserToken();//获取用户Tonken
    String seqno = getRandomString(15);//15位随机数
    String activation = request.getParameter("activation");
    String retro = "{\"seqno\":\""+ seqno +"\",\"ditch\":\"4\",\"usercode\":\""+userId+"\",\"activation\":\"" + activation + "\",\"usertoken\":\""+userToken+"\"}";
    retro = postJson("http://210.13.0.139:8080/iptv_code/order/usercodeBond ", retro);
					
	out.print( retro );
%>
