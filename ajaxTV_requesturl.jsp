<%@ page contentType="text/html; charset=GBK" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.text.*" %>
<epg:PageController name="testdetail.jsp"/>
<%!
    public static HashMap returnMap(String[] strs, int num) {
        HashMap map = new HashMap();
        map.put("produc", strs);
        map.put("serial", num);
        return map;
    }

    public static ArrayList organize() {

        ArrayList producList = new ArrayList();

        /*String[] prod_activity = {};
        producList.add(returnMap(prod_activity, 10));*/



        String[] prod_2h = {"100332"};

        producList.add(returnMap(prod_2h, 199));

        String[] prod_24h = {"100334"};

        producList.add(returnMap(prod_24h, 299));

        String[] prod_15 = {"100356", "100360", "100364", "100371"};

        producList.add(returnMap(prod_15, 399));

        String[] prod_30 = {"100380","100383","100354", "100358", "100362", "100372", "100417","100441","100465","100467","100453"};

        producList.add(returnMap(prod_30, 499));

        String[] prod_90 = {"100355", "100359", "100363", "100373","100381","100384", "100418","100442"};

        producList.add(returnMap(prod_90, 599));

        String[] prod_365 = {"100357", "100361", "100365", "100374","100382","100385", "100419","100443","100466","100468","100455"};

        producList.add(returnMap(prod_365, 799));

        String[] prod_baoyue = {"100320", "100326", "100333", "100347", "100370", "100330", "100329", "100331","100398","100399","100327"};

        producList.add(returnMap(prod_baoyue, 899));

        return producList;
    }

    public static Object getSorting(String code) {

        ArrayList producList = organize();
        Object number = 9999;
        for (int i = 0; i < producList.size(); i++) {
            Map m = (Map) producList.get(i);
            String[] strs = (String[]) m.get("produc");
            for (String s : strs) {
                if (code.equals(s)) {
                    number = (Object) m.get("serial");
                    return number;
                }
            }
        }

        return number;

    }

    public static void comparator(ArrayList producList) {
        Collections.sort(producList, new Comparator() {
            public int compare(Object o1, Object o2) {
                Map m1 = (Map) o1;
                Map m2 = (Map) o2;
                Integer s1 = Integer.valueOf(m1.get("serial").toString());
                Integer s2 = Integer.valueOf(m2.get("serial").toString());
                return s1.compareTo(s2);
            }
        });
    }

    public static ArrayList transVector(Vector data) {
        ArrayList returnData = new ArrayList();

        for (int i = 0; i < data.size(); i++) {
            Map product = new HashMap();
            Map productInfo = (Map) data.get(i);
            product.put("ContentID", productInfo.get("ContentID"));//节目code
            product.put("ServiceID", productInfo.get("ServiceID"));//服务code
            product.put("ProductID", productInfo.get("ProductID"));//产品code
            product.put("ProductName", productInfo.get("ProductName"));//产品名称
            product.put("Fee", productInfo.get("Fee"));//价格
            product.put("ProductDesc", productInfo.get("ProductDesc"));//产品描述
            product.put("RentalTerm", productInfo.get("RentalTerm"));//租期
            product.put("RentalUnit", productInfo.get("RentalUnit"));//产品租期单位
            product.put("PurchaseType", productInfo.get("PurchaseType"));//产品类型
            product.put("strCategoryID", productInfo.get("CategoryID"));//栏目code
            product.put("serial", getSorting(productInfo.get("ProductID").toString()));
            returnData.add(product);
        }

        comparator(returnData);
        return returnData;
    }
%>
<%
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userToken = userInfo.getUserToken();//获取用户Tonken
    String channelsql = "telecomcode='" + request.getParameter("global_code") + "'";
    String channelType = "";
    String contentType = "2";
    String columnCode = "";
    String channelCode = "";
    String terminalflag = "1";
    String definition = "1";
    String authidsession = "";
    String mediaUrl = "";
    JSONObject obj = new JSONObject();
    JSONArray authArra = new JSONArray();
    StringBuffer sa = new StringBuffer();
    String results = "";
    int flag = 0;
    StringBuffer sb = new StringBuffer();
%>
<ex:search tablename="user_channel" fields="*" condition="<%=channelsql%>" var="channellist">
    <%
        List<Map> slist = (List<Map>) pageContext.getAttribute("channellist");
        if (slist.size() > 0) {
            for (Map VODS : slist) {
                obj.put("channelcode", VODS.get("channelcode"));
                obj.put("columncode", VODS.get("columncode"));
                obj.put("channeltype", VODS.get("channeltype"));
                channelType = (String) VODS.get("channeltype");
                columnCode = (String) VODS.get("columncode");
                channelCode = (String) VODS.get("channelcode");
            }
        } else {
            flag = 1;
            results = "1";
        }
    %>
</ex:search>
<%
    if (flag == 0) {
%>
<ex:params var="params">
    <ex:param name="terminalflag" value="<%=terminalflag%>"/>
    <ex:param name="contenttype" value="<%=contentType%>"/>
    <ex:param name="columncode" value="<%=columnCode%>"/>
    <ex:param name="definition" value="<%=definition%>"/>
    <ex:param name="programcode" value="<%=channelCode %>"/>
</ex:params>

<ex:action name="auth" inputparams="${params}" var="authResult">
    <%
        Map vodResult = (Map) pageContext.getAttribute("authResult");
        flag = Integer.parseInt(vodResult.get("_flag").toString());
        results = vodResult.get("_flag").toString();
        if (flag == 0) {//auth success
            JSONObject authObj = new JSONObject();
            Vector vodData = (Vector) vodResult.get("data");
            Map productInfo = (HashMap) vodData.get(0);
            authidsession = (String) productInfo.get("AuthorizationID");
        } else if (flag == 5 || flag == 98) {

            ArrayList data = transVector((Vector) vodResult.get("data"));


            Map productInfo = null;
            if (data != null && data.size() > 0) {
                sa.append("[");
                for (int i = 0; i < data.size(); i++) {
                    JSONObject product = new JSONObject();
                    productInfo = (Map) data.get(i);
                    //看吧直播产品屏蔽
                    if (!"100321".equals(productInfo.get("ProductID")) && !"100322".equals(productInfo.get("ProductID")) && !"100323".equals(productInfo.get("ProductID")) && !"100345".equals(productInfo.get("ProductID")) && !"100332".equals(productInfo.get("ProductID")) && !"100360".equals(productInfo.get("ProductID")) && !"100359".equals(productInfo.get("ProductID")) && !"100421".equals(productInfo.get("ProductID")) && !"100424".equals(productInfo.get("ProductID")) && !"100427".equals(productInfo.get("ProductID")) && !"100430".equals(productInfo.get("ProductID")) && !"100433".equals(productInfo.get("ProductID")) && !"100439".equals(productInfo.get("ProductID")) && !"100442".equals(productInfo.get("ProductID")) && !"100448".equals(productInfo.get("ProductID")) && !"100451".equals(productInfo.get("ProductID")) && !"100454".equals(productInfo.get("ProductID")) && !"100418".equals(productInfo.get("ProductID")) && !"100381".equals(productInfo.get("ProductID")) && !"100384".equals(productInfo.get("ProductID")) && !"100356".equals(productInfo.get("ProductID")) && !"100355".equals(productInfo.get("ProductID")) && !"100364".equals(productInfo.get("ProductID")) && !"100363".equals(productInfo.get("ProductID")) && !"100371".equals(productInfo.get("ProductID")) && !"100373".equals(productInfo.get("ProductID")) && !"100457".equals(productInfo.get("ProductID"))) {
                        product.put("strContentid", productInfo.get("ContentID"));//节目code
                        product.put("strServiceid", productInfo.get("ServiceID"));//服务code
                        product.put("strProductID", productInfo.get("ProductID"));//产品code
                        product.put("strProductName", productInfo.get("ProductName"));//产品名称
                        product.put("strPrice", productInfo.get("Fee"));//价格
                        product.put("strProductDesc", productInfo.get("ProductDesc"));//产品描述
                        product.put("strRentalTerm", productInfo.get("RentalTerm"));//租期
                        product.put("strRentalUnit", productInfo.get("RentalUnit"));//产品租期单位
                        product.put("strPurchaseType", productInfo.get("PurchaseType"));//产品类型
                        product.put("strCategoryID", productInfo.get("CategoryID"));//栏目code
                        authArra.add(product);

                        sa.append("{strContentid:\"" + productInfo.get("ContentID") + "\",strServiceid:\"" + productInfo.get("ServiceID") + "\",strProductID:\"" + productInfo.get("ProductID") + "\",strProductName:\"" + productInfo.get("ProductName") + "\",strPrice:\"" + productInfo.get("Fee") + "\",strProductDesc:\"" + productInfo.get("ProductDesc") + "\",strRentalTerm:\"" + productInfo.get("RentalTerm") + "\",strRentalUnit:\"" + productInfo.get("RentalUnit") + "\",strPurchaseType:\"" + productInfo.get("PurchaseType") + "\",strCategoryID:\"" + productInfo.get("CategoryID") + "\",strprogramcode:\"" + channelCode + "\"}");
                        if (i < (data.size() - 1)) {
                            sa.append(",");
                        }
                    }

                }
                sa.append("]");
            }

        } else if (flag == -1) {//黑名单用户
            flag = -1;
            results = "-1";
        } else {
            flag = 1;
            results = "1";//未找到节目数据
        }

    %>

</ex:action>
<%
    }

%>


<%
    String callbackFn = request.getParameter("callback");
//out.print("ajaxTV_requesturl.jsp  callbackFnsa=" + sa );
    String jsonResult = "";
    if (sa.length() > 0) {
        jsonResult = callbackFn + "(" + "[{flag:\"" + flag + "\",result:\"" + results + "\",product:" + sa + ",userToken:\"" + userToken + "\"}]" + ")";
    } else {
        jsonResult = callbackFn + "(" + "[{flag:\"" + flag + "\",result:\"" + results + "\",product:\"0\",userToken:\"" + userToken + "\"}]" + ")";
    }

    sb.append(jsonResult);
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>