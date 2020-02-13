<%@page import="java.net.URLConnection" %>
<%@page import="java.io.*" %>
<%@page import="java.net.URL" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@page import="net.sf.json.*" %>
<%!
    public static String sendUrl(String url) {

        String result = "";
        try {

            URL realUrl = new URL(url);

            URLConnection connection = realUrl.openConnection();

            connection.setRequestProperty("accept", "*/*");

            connection.setRequestProperty("connection", "Keep-Alive");
            connection.setRequestProperty("Accept-Charset", "UTF-8");
            connection.connect();

            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));

            String line = "";

            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = null;

            System.out.println("数据连接超时");
        }

        return result;
    }
%>
<%

    String url = request.getParameter("url");
    url = URLDecoder.decode(url, "UTF-8");
    if (url.indexOf("getHistoryOrder") != -1) {
        String result = sendUrl(url);
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObj = jsonObject.fromObject(result);
        JSONArray jsonArray = new JSONArray();
        StringBuffer sb = new StringBuffer();
        jsonArray = (JSONArray) jsonObj.get("orderList");
        for (int i = 0; i < jsonArray.size(); i++) {
            for (int j = 0; j < jsonArray.getJSONArray(i).size(); j++) {
                JSONObject obj = (JSONObject) jsonArray.getJSONArray(i).get(j);
                if ("0".equals(obj.get("productID")) || "1".equals(obj.get("productID")) || "100375".equals(obj.get("productID"))) {
                    jsonArray.getJSONArray(i).remove(j);
                }
            }
            String str1 = jsonArray.getJSONArray(i).toString();
            if (i == jsonArray.size() - 1) {
                sb.append(str1);
            } else {
                sb.append(str1 + ",");
            }
        }
        String arrayStr = "[" + sb.toString() + "]";
        JSONObject jsonObject1 = new JSONObject();
        jsonObject1.put("orderList", arrayStr);
        String result1 = jsonObject1.toString();
        //System.out.println(jsonObject1.toString());
        if (result1 != null) {
            out.print(result1);
        } else {
            out.print("error3333");
        }
    } else {
        String result = sendUrl(url);
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObj = jsonObject.fromObject(result);
        JSONArray jsonArray = new JSONArray();
        jsonArray = (JSONArray) jsonObj.get("orderList");
        for (int i = 0; i < jsonArray.size(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            if ("0".equals(obj.get("productID")) || "1".equals(obj.get("productID")) || "100375".equals(obj.get("productID"))) {
                jsonArray.remove(i);
            }
        }
        String str = jsonArray.toString();
        JSONObject jsonObject1 = new JSONObject();
        jsonObject1.put("orderList", str);
        String result1 = jsonObject1.toString();
        if (result1 != null) {
            out.print(result1);
        } else {
            out.print("error3333");
        }
    }


%>
