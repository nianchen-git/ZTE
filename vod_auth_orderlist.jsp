<%@page contentType="text/html; charset=GBK" %>
<%@page isELIgnored="false" %>
<%@taglib uri="/WEB-INF/extendtag.tld" prefix="ex" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.log.Logger" %>
<%@ page import="com.zte.iptv.epg.log.LoggerFactory" %>
<%@ page import="com.zte.iptv.epg.log.LoggerModel" %>
<%@ page import="com.zte.iptv.epg.util.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgDataSource" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%--<%@ page import="com.zte.iptv.epg.content.QueryPagesImpApp" %>--%>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ include file="inc/ad_utils.jsp" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@page import="net.sf.json.*" %>
<%@page import="java.text.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="org.apache.http.client.ClientProtocolException" %>
<%@ page import="org.apache.http.client.HttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpPost" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.entity.StringEntity" %>
<%@ page import="org.apache.http.util.EntityUtils" %>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"/>
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT"/>
<epg:PageController/>
<%
    request.setCharacterEncoding("utf-8");
%>
<%!
    /*public String subString(String string, int length) {
        if (null != string) {
            if (string.length() > length) {
                string = string.substring(0, length) + "...";
            }
            return string;
        } else {
            return "";
        }
    }*/
    public String substring(String str, int length) {
        String string = str;
        if (null != string) {
            if (string.length() > length) {
                string = string.substring(0, length);
            }
            return string;
        } else {
            return "";
        }
    }

    public String getDetailPrice(String price) {
        String temp = price + "";
        int index = temp.indexOf(".");
        if (index < 0) {
            temp += ".00";
        } else if (index == temp.length() - 1) {
            temp += "00";
        } else if (index == 0) {
            temp = "0" + temp;
        } else if (index == temp.length() - 2) {
            temp += "0";
        } else if (index < temp.length() - 2) {
            temp = temp.substring(0, index + 3);
        }
        return temp;
    }

    public String format(String price, String rate) {
        double priceInt = Double.valueOf(price);
        double rateInt = Double.valueOf(rate);
        double pricedb = (double) (priceInt / rateInt);
        String priceStr = String.valueOf(pricedb);
        if (priceStr.endsWith(".0")) {
            priceStr = priceStr.substring(0, priceStr.length() - 2);
        }
        return priceStr;
    }

    /*
     * 产品列表排序方法
     * */
    //创建一个新的HashMap集合方法，增加产品的序列字段
    public HashMap returnMap(String[] strs, int num) {
        HashMap map = new HashMap();
        map.put("produc", strs);
        map.put("serial", num);
        return map;
    }

    //创建ArrayList集合，创建产品对象数组，并按照HashMap的键值对的数据结构放到该集合中单点产品、包月产品
    public ArrayList organize() {
        ArrayList producList = new ArrayList();

        String[] prod_baoyue1 = {"100402"};
        producList.add(returnMap(prod_baoyue1,90));


        String[] prod_dandian = {"100101", "100102" , "100105", "100110", "100349", "100201", "100202", "100205", "100350", "100351", "100352", "100336", "100337", "100338", "100339", "100340", "100341", "100342", "100343"};
        producList.add(returnMap(prod_dandian, 199));

        String[] prod_30 = {"100417", "100420", "100423","100426","100429", "100432","100435","100438","100441","100444","100447","100450","100453","100456","100459","100462","100465","100467","100470","100475","100483","100488","100486"};

        producList.add(returnMap(prod_30, 299));

        String[] prod_90 = {"100418", "100421", "100424", "100427", "100430", "100433","100436","100439","100442","100445","100448","100451","100454","100457","100460","100463"};

        producList.add(returnMap(prod_90, 399));

        String[] prod_365 = {"100468", "100466", "100464", "100461", "100458", "100455","100452","100449","100446","100443","100440","100437","100434","100431","100428","100425","100422","100419","100472","100476","100484","100490","100487"};

        producList.add(returnMap(prod_365, 499));

        String[] prod_baoyue = {"100325", "100316", "100348", "100370", "100353", "100346", "100335", "100328", "100324", "100327", "100386", "100379", "100315","100400","100469","100474","100482","100488","100485"};
        producList.add(returnMap(prod_baoyue, 599));

        return producList;
    }

    //遍历产品，根据产品code绑定产品的序列
    public Object getSorting(String code) {
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

    //根据产品序列的大小排序，从小到大，此方法是通用的，排序用的是list集合
    public void comparator(ArrayList producList) {
        Collections.sort(producList, new Comparator() {
            public int compare(Object o1, Object o2) {
                Map m1 = (Map) o1;
                Map m2 = (Map) o2;
                Integer s1 = Integer.valueOf(m1.get("Serial").toString());
                Integer s2 = Integer.valueOf(m2.get("Serial").toString());
                return s1.compareTo(s2);
            }
        });
    }

    //为获取的数据添加序列字段
    public Map addSerial(Map dataOut) {
        Vector serial = new Vector();
        Vector vProductId = getVParamFromField(dataOut, "ProductID");
        for (int i = 0; i < vProductId.size(); i++) {
            serial.add(getSorting(vProductId.get(i).toString()));
        }
        dataOut.put("Serial", serial);
        return dataOut;
    }

    //重组ArrayList集合，为了方便调用后面的排序方法
    public ArrayList reorganize(Map dataOut) {
        ArrayList productList = new ArrayList();
        Vector vProductDesc = getVParamFromField(dataOut, "ProductDesc");
        Vector vContentId = getVParamFromField(dataOut, "ContentID");
        Vector vServiceId = getVParamFromField(dataOut, "ServiceID");
        Vector vProductId = getVParamFromField(dataOut, "ProductID");
        Vector vProductName = getVParamFromField(dataOut, "ProductName");
        Vector vListPrice = getVParamFromField(dataOut, "ListPrice");
        Vector vPurchaseType = getVParamFromField(dataOut, "PurchaseType");
        Vector vFee = getVParamFromField(dataOut, "Fee");
        Vector vStartTime = getVParamFromField(dataOut, "StartTime");
        Vector vEndTime = getVParamFromField(dataOut, "EndTime");
        Vector vRentalTerm = getVParamFromField(dataOut, "RentalTerm");
        Vector vLimitTimes = getVParamFromField(dataOut, "LimitTimes");
        Vector vFlag = getVParamFromField(dataOut, "flag");
        Vector vAutoContinueOption = getVParamFromField(dataOut, "AutoContinueOption");
        Vector vSerial = getVParamFromField(dataOut, "Serial");
        Vector vRentalUnit = getVParamFromField(dataOut, "RentalUnit");
        for (int i = 0; i < vContentId.size(); i++) {
            HashMap map = new HashMap();
            map.put("ProductDesc", vProductDesc.get(i));
            map.put("ContentID", vContentId.get(i));
            map.put("ServiceID", vServiceId.get(i));
            map.put("ProductID", vProductId.get(i));
            map.put("ProductName", vProductName.get(i));
            map.put("ListPrice", vListPrice.get(i));
            map.put("PurchaseType", vPurchaseType.get(i));
            map.put("Fee", vFee.get(i));
            map.put("StartTime", vStartTime.get(i));
            map.put("EndTime", vEndTime.get(i));
            map.put("RentalTerm", vRentalTerm.get(i));
            map.put("LimitTimes", vLimitTimes.get(i));
            map.put("flag", vFlag.get(i));
            map.put("AutoContinueOption", vAutoContinueOption.get(i));
            map.put("Serial", vSerial.get(i));
            map.put("RentalUnit", vRentalUnit.get(i));

            //点播产品屏蔽
            if(!"100435".equals(vProductId.get(i)) && !"100436".equals(vProductId.get(i)) && !"100437".equals(vProductId.get(i)) && !"100445".equals(vProductId.get(i)) && !"100421".equals(vProductId.get(i))&& !"100424".equals(vProductId.get(i)) && !"100427".equals(vProductId.get(i))&& !"100430".equals(vProductId.get(i))&& !"100433".equals(vProductId.get(i))&& !"100439".equals(vProductId.get(i)) && !"100442".equals(vProductId.get(i))&& !"100448".equals(vProductId.get(i))&& !"100451".equals(vProductId.get(i)) && !"100454".equals(vProductId.get(i))&& !"100418".equals(vProductId.get(i))&& !"100381".equals(vProductId.get(i))&& !"100384".equals(vProductId.get(i))&& !"100356".equals(vProductId.get(i))&& !"100355".equals(vProductId.get(i))&& !"100364".equals(vProductId.get(i))&& !"100363".equals(vProductId.get(i))&& !"100371".equals(vProductId.get(i))&& !"100373".equals(vProductId.get(i))&& !"100457".equals(vProductId.get(i)) && !"100359".equals(vProductId.get(i)) && !"100432".equals(vProductId.get(i)) && !"100434".equals(vProductId.get(i)) && !"100477".equals(vProductId.get(i)) && !"100478".equals(vProductId.get(i)) && !"100479".equals(vProductId.get(i)) && !"100377".equals(vProductId.get(i)) && !"100459".equals(vProductId.get(i)) && !"100461".equals(vProductId.get(i)) && !"100411".equals(vProductId.get(i)) && !"100412".equals(vProductId.get(i))&& !"100423".equals(vProductId.get(i)) && !"100425".equals(vProductId.get(i)) && !"100444".equals(vProductId.get(i)) && !"100446".equals(vProductId.get(i))){
                productList.add(map);
            }


        }
        return productList;
    }
%>
<%
    String message = "";
    String tipType = "";
    String telno = "";
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    UserInfo userInfo = (UserInfo) session.getAttribute(EpgConstants.USERINFO);
    String userId = userInfo.getUserId();
    String fatherParam = request.getQueryString();
    String global_contentID = "";

    String strADid = request.getParameter("strADid");
    String strADid2 = request.getParameter("strADid2");
    String columnid = request.getParameter("columnid");
    String CategoryID = request.getParameter("CategoryID");
    String contentid = request.getParameter("ContentID");
    String contenttype = request.getParameter("ContentType");
    String fathercontent = request.getParameter("FatherContent");
    String programid = request.getParameter("programid");
    String programname = request.getParameter("programname");
    String programtype = request.getParameter("programtype");
    String leefocus = request.getParameter("leefocus");
    String seriesProgramId = request.getParameter("seriesProgramId");
    String seriesProgramcode = request.getParameter("seriesprogramcode");
    String procontentcod = request.getParameter("ContentID");
    String authprogramid = request.getParameter("programid");
    String authprogramtype = request.getParameter("programtype");
    String global_seriesID = "";
    String terminalflag = "1";
    String definition = "1";
    JSONObject obj = new JSONObject();
    JSONArray authArra = new JSONArray();
    int flag = 0;
    int errorcode = 0;
    String results = "";
    String errorUrl = "";
    if (null == seriesProgramId) {
        seriesProgramId = "";
    }
    String playUrl = "";
    if (programtype.equals("10")) {
        authprogramid = seriesProgramcode;
        authprogramtype = contenttype;
        playUrl = "vod_order_success.jsp?columnid=" + columnid +
                "&programid=" + programid + "&" + EpgConstants.CONTENT_ID + "=" + contentid + "&FatherContent=" + fathercontent + "&programtype=" + programtype +
                "&" + EpgConstants.VOD_TYPE + "=" + CodeBook.VOD_TYPE_SERIES_Single + "&leefocus=" + leefocus + "&strADid=" + strADid + "&strADid2=" + strADid2;
    } else if (programtype.equals("1")) {
        playUrl = "vod_order_success.jsp?columnid=" + columnid +
                "&programid=" + programid + "&" + EpgConstants.CONTENT_ID + "=" + contentid + "&FatherContent=" + fathercontent + "&programtype=" + programtype +
                "&" + EpgConstants.VOD_TYPE + "=0" + "&leefocus=" + leefocus + "&strADid=" + strADid + "&strADid2=" + strADid2;
    }
%>
<%
    if ((programtype).equals("10")) {
        StringBuffer sql = new StringBuffer();
        sql.append("programcode=" + seriesProgramcode);
%>
<ex:search tablename="user_series" fields="*" condition="<%=sql.toString()%>" var="detaillist">
    <%
        List<Map> slist = (List<Map>) pageContext.getAttribute("detaillist");
        if (slist.size() > 0) {
            for (Map VODS : slist) {
                global_contentID = (String) VODS.get("telecomcode");
                global_seriesID = global_contentID;
                // out.print(global_contentID+"global_contentID");
            }
        } else {
            int codeflag = 1;
            String coderesults = "1";//未找到节目数据
            //out.print("global_contentIDeee");
        }
    %>
</ex:search>
<%
} else {
%>
<ex:params var="inputparam">
    <ex:param name="programcodeavailable" value="<%=procontentcod%>"/>
</ex:params>
<ex:search tablename="user_vod_detail" fields="*" inputparams="${inputparam}" pagecount="100" var="detaillist">
    <%
        List<Map> slist = (List<Map>) pageContext.getAttribute("detaillist");
        if (slist.size() > 0) {
            for (Map VODS : slist) {
                global_contentID = (String) VODS.get("telecomcode");
                // out.print("global_contentIDddd"+global_contentID);
            }
        } else {
            int codeflag = 1;
            String coderesults = "1";//未找到节目数据
        }
    %>
</ex:search>
<%
    }
%>
<ex:params var="authParams">
    <ex:param name="contenttype" value="<%=authprogramtype%>"/>
    <ex:param name="columncode" value="<%=columnid%>"/>
    <ex:param name="programcode" value="<%=authprogramid%>"/>
    <ex:param name="terminalflag" value="<%=terminalflag%>"/>
    <ex:param name="definition" value="<%=definition%>"/>
</ex:params>
<ex:action name="auth" inputparams="${authParams}" var="authMap">
    <%
        JSONArray authArr = new JSONArray();
        Map authResult = (Map) pageContext.getAttribute("authMap");
        flag = Integer.parseInt(authResult.get("_flag").toString());
        errorcode = Integer.parseInt(authResult.get("_error_code").toString());
        results = authResult.get("_flag").toString();
        errorUrl = (errorcode == 9203) ? "message.jsp?type=9203" : "message.jsp?type=-1";
        if (flag == 0) {//鉴权成功
            pageContext.forward(playUrl);
            return;
        } else if (flag == -1) {//鉴权失败或黑名单用户
            pageContext.forward(errorUrl);
            return;
        }
    %>
</ex:action>
<html>
<head>
    <title></title>
    <style>
        .font_22 {
            color: #ffffff;
            font-size: 22px;
            font-family: "黑体";
        }

        .font_26 {
            color: #ffffff;
            font-size: 26px;
        }

        .font_36 {
            color: #ffffff;
            font-size: 28px;
        }

        .center {
            text-align: center;
        }

        .line_height {
            line-height: 22px;
        }
    </style>
</head>
<body bgcolor="transparent">
<%
    List<String> order_urla = new ArrayList<String>();
    List<String> third_urla = new ArrayList<String>();
    List<String> strProductNamea = new ArrayList<String>();
    List<String> strPricea = new ArrayList<String>();
    List<String> strProductDesca = new ArrayList<String>();
    List<String> strEndTimea = new ArrayList<String>();
    List<String> strRentalTerma = new ArrayList<String>();//租期
    List<String> strRentalUnita = new ArrayList<String>();//租期单位
    List<String> strProductIDa = new ArrayList<String>();//产品id
    List<String> strPurchaseTypea = new ArrayList<String>();//产品包类型：按次还是包月
    String order_url = "";
    String third_url = "";
    String strContentid = "";
    String strServiceid = "";
    String strProductID = "";
    String strProductName = "";
    String strPurchaseType = "";
    String strPrice = "";
    String strFree = "";
    String strProductDesc = "";
    String strEndTime = "";
    String strRentalTerm = "";
    String strRentalUnit = "";
    int iDestPage = 1;
    int pageCount = 1;
    int pageIndex = 0;
    int leng = 0;
    try {
        //out.println("============00000===========");
        //鉴权不通过把第一个产品包数据拿出??
        String autoContinue = "";
        Map dataOut = getData(getEpgResult("com.zte.iptv.functionepg.decorator.AuthAndShowProductListDecorator", pageContext));
        //getVParamFromField 这个方法在 ad_utils.jsp页面
        dataOut = addSerial(dataOut);
        ArrayList producList = reorganize(dataOut);
        comparator(producList);
        //out.println("============111111===========");
//        Vector vContentid = getVParamFromField(dataOut, "ContentID");
//        Vector vServiceid = getVParamFromField(dataOut, "ServiceID");
//        Vector vProductID = getVParamFromField(dataOut, "ProductID");
//        Vector vProductName = getVParamFromField(dataOut, "ProductName");
//        Vector vPurchaseType = getVParamFromField(dataOut, "PurchaseType");
//        Vector vListPrice = getVParamFromField(dataOut, "ListPrice");
//        Vector vFee = getVParamFromField(dataOut, "Fee");
//        Vector vProductDesc = getVParamFromField(dataOut, "ProductDesc");
//        Vector vEndTime = getVParamFromField(dataOut, "EndTime");
//        Vector vRentalTerm = getVParamFromField(dataOut, "RentalTerm");
//        Vector vRentalUnit = getVParamFromField(dataOut, "RentalUnit");

//        leng = vContentid.size();
        leng = producList.size();
        int index = 0;
        int pageNum = 5;
        if (leng > 0) {
            pageCount = (int) (leng - 0.1) / pageNum + 1;
            String strDestPage = request.getParameter("destpage");
            if (null != strDestPage && !strDestPage.equals("")) iDestPage = Integer.parseInt(strDestPage);
            // int iStart = (iDestPage-1) * pageNum;
            // int iEnd = iDestPage * pageNum;
            // if(iEnd > leng) iEnd = leng;
            // pageIndex=iEnd-iStart;
            Map productInfo = null;
            //out.println("============2222222===========");
            for (int i = 0; i < leng; i++) {
                productInfo = (Map) producList.get(i);
                //out.println("============33333===========");
//                strContentid = (String) vContentid.get(i);
                strContentid = (String) productInfo.get("ContentID");
//                strServiceid = (String) vServiceid.get(i);
                strServiceid = (String) productInfo.get("ServiceID");
//                strProductID = (String) vProductID.get(i);
                strProductID = (String) productInfo.get("ProductID");
//                strProductName = (String) vProductName.get(i);
                strProductName = (String) productInfo.get("ProductName");
//                strPurchaseType = String.valueOf(vPurchaseType.get(i));
                strPurchaseType = String.valueOf(productInfo.get("PurchaseType"));
//                strProductDesc = (String) vProductDesc.get(i);
                strProductDesc = (String) productInfo.get("ProductDesc");
//                strEndTime = (String) vEndTime.get(i);
                strEndTime = (String) productInfo.get("EndTime");
//                strRentalTerm = String.valueOf(vRentalTerm.get(i));
                strRentalTerm = String.valueOf(productInfo.get("RentalTerm"));
//                strRentalUnit = String.valueOf(vRentalUnit.get(i));
                strRentalUnit = String.valueOf(productInfo.get("RentalUnit"));
                if (strPurchaseType.equals("3")) {
//                    strPrice = String.valueOf(vFee.get(i));
                    strPrice = String.valueOf(productInfo.get("Fee"));
                } else {
//                    strPrice = String.valueOf(vListPrice.get(i));
                   // strPrice = String.valueOf(productInfo.get("ListPrice"));
                    strPrice = String.valueOf(productInfo.get("Fee"));

                }
                String sprice = format(strPrice, "100");
                strPrice = getDetailPrice(sprice);
//                strFree = String.valueOf(vFee.get(i));
                //order_url = "vod_Orderr.jsp?ContentID=" + strContentid
                order_url = "action/vod_Orderr.jsp?ContentID=" + contentid
                        + "&ServiceID=" + strServiceid
                        + "&ProductID=" + strProductID
                        + "&PurchaseType=" + strPurchaseType
                        + "&Action=1&ContentType=" + contenttype
                        + "&FatherContent=" + fathercontent
                        + "&CategoryID=" + columnid
                        + "&programtype=" + programtype
                        + "&programid=" + authprogramid
                        + "&seriesProgramId=" + seriesProgramId
                        + "&strADid=" + strADid + "&strADid2=" + strADid2;
                third_url = "action/vod_third_erweima.jsp?ContentID=" + global_contentID
                        + "&ServiceID=" + strServiceid
                        + "&ProductID=" + strProductID
                        + "&PurchaseType=" + strPurchaseType
                        + "&Action=1&ContentType=" + contenttype
                        + "&FatherContent=" + fathercontent
                        + "&CategoryID=" + columnid
                        + "&programtype=" + programtype
                        + "&programid=" + authprogramid
                        + "&seriesProgramId=" + global_seriesID
                        + "&strADid=" + strADid + "&strADid2=" + strADid2;
                order_urla.add(order_url);
                third_urla.add(third_url);
                strProductNamea.add(strProductName);
                strPricea.add(strPrice);
                strProductDesca.add(strProductDesc);
                strEndTimea.add(strEndTime);
                strRentalTerma.add(strRentalTerm);
                strRentalUnita.add(strRentalUnit);
                strPurchaseTypea.add(strPurchaseType);//产品类型数组添加内容
                strProductIDa.add(strProductID);
%>
<script type="text/javascript">
    //  top.mainWin.showOrder("<%=index%>","<%=order_url%>", "<%=strProductName%>", "<%=strPrice%>","<%=pageIndex%>");
</script>
<%
                index++;
            }
        }
    } catch (Exception ex) {
    }
%>
<div id="big_bg" style="position:absolute; width:1280px; height:720px; left:0px; top:0px; display:none;">
    <div id="order_bg" style="position:absolute; width:1280px; height:720px; left:0px; top:0px;"><img
            src="images/order/vod_order_wxpay.png" width="1280" height="720"></div>
    <%
        for (int i = 0; i < 5; i++) {
            int topa = 330 + i * 53;
            int topb = 340 + i * 55;
    %>
    <div style="position:absolute; width:312px; height:55px; left:155px; top:<%=topa%>px;"><img
            id="select_order_product_<%=i%>" src="images/btn_trans.gif" width="312" height="55"></div>
    <div id="order_product_name_<%=i%>" class="font_36 center"
         style="position:absolute; width:299px; height:55px; left:165px; top:<%=topb%>px;"></div>
    <%
        }
    %>
    <div id="product_program_name" class="font_26"
         style="position:absolute; width:578px; height:34px; left:660px; top:285px;"></div>
    <div id="product_name" class="font_26"
         style="position:absolute; width:365px; height:32px; left:660px; top:337px;"></div>
    <div id="product_price" class="font_26"
         style="position:absolute; width:300px; height:32px; left:660px; top:385px;"></div>
    <div id="current_price" class="font_26"
         style="position:absolute; width:300px; height:32px; left:780px; top:385px;"></div>
    <div id="product_endtime" class="font_26"
         style="position:absolute; width:300px; height:32px; left:660px; top:435px;"></div>
    <div id="product_discribe" class="font_26"
         style="position:absolute; width:400px; height:32px; left:660px; top:482px;"></div>
    <div id="order_button"
         style="position:absolute; width:111px; height:38px; left:876px; top:555px; visibility:hidden"><img
            src="images/order/price_onfocus_wx.png" width="111" height="38"></div>
    <div id="order_button_wx"
         style="position:absolute; width:111px; height:38px; left:758px; top:555px; visibility:hidden"><img
            src="images/order/price_onfocus_wx.png" width="111" height="38"></div>
    <div id="remove_button"
         style="position:absolute; width:111px; height:38px; left:993px; top:555px; visibility:hidden"><img
            src="images/order/price_onfocus_wx.png" width="111" height="38"></div>
    <!--上下按钮-->
    <div id="button_up" style="position:absolute; width:53px; height:37px; left:285px; top:300px; visibility:hidden">
        <img src="images/vod/arrow_up.png" width="53" height="37"></div>
    <div id="button_down" style="position:absolute; width:53px; height:37px; left:285px; top:605px; visibility:hidden">
        <img src="images/vod/arrow_down.png" width="53" height="37"></div>

    <!--海报订购-->
    <div id="poster" style="display: none; position:absolute; width:963px; height:96px; left:150px; top:166px;">
        <img id="poster_img" style="position:absolute; top: 0px; left: 0px;" src="images/vod/poster_img.jpg" width="963" height="96">
        <img id="poster_focus" style="position:absolute; top: 0px; left: 0px; visibility:hidden" src="images/vod/poster.png" width="963" height="96">
    </div>

    <!--订购-->
    <div id="dialog_order"
         style="position:absolute; width:837px; height:306px; left:226px; top:193px; visibility:hidden">
        <div style="position:absolute; width:837px; height:306px;left:0px; top:0px; "><img id="order_img" src=""
                                                                                           width="837" height="306">
        </div>
        <div id="dialog_order_button"
             style="position:absolute; width:158px; height:45px; left:156px; top:237px; visibility:hidden"><img
                src="images/order/price_onfocus.png" width="158" height="45"></div>
        <div id="dialog_remove_button"
             style="position:absolute; width:158px; height:45px; left:512px; top:237px; visibility:hidden"><img
                src="images/order/price_onfocus.png" width="158" height="45"></div>


    </div>
    <!--订购二维码显示-->
    <div id="dialog_erweima"
         style="position:absolute; width:912px; height:585px; left:184px; top:66px; visibility:hidden">
        <div id="product_name_wx" class="font_26"
             style="position:absolute; width:365px; height:32px; left:140px; top:20px;z-index:99;"></div>
        <div id="product_price_wx" class="font_26"
             style="position:absolute; width:300px; height:32px; left:140px; top:60px;z-index:99;"></div>
        <div id="product_endtime_wx" class="font_26"
             style="position:absolute; width:495px; height:64px; line-height:32px; left:55px; top:103px; text-indent:4em;z-index:99;"></div>
        <div style="position:absolute; width:912px; height:585px; left:0px; top:0px; "><img id="erweima_img" src="">
        </div>
        <div id="dialog_order_button_wx"
             style="position:absolute; width:181px; height:50px; left:275px; top:440px; visibility:hidden"><img
                src="images/order/price_onfocus_wx.png" width="181" height="50"></div>
        <div id="dialog_remove_button_wx"
             style="position:absolute; width:181px; height:50px; left:478px; top:440px; visibility:hidden"><img
                src="images/order/price_onfocus_wx.png" width="181" height="50"></div>
    </div>
    <div id="qrcode"
         style="position:absolute; width:200px; height:200px; top:166px;left:809px; z-index:99;visibility:hidden"></div>
    <!--微信订购成功单次-->
    <div id="weix_dialog_ordered"
         style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/weix_ordered.png" width="551" height="235"></div>
    <!--微信订购成功包月-->
    <div id="weix_dialog_ordered_all"
         style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/weix_ordered.png" width="551" height="235"></div>
    <!--微信订购失败-->
    <div id="weix_dialog_ordered_failed"
         style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/weix_ordered_failed.png" width="551" height="235"></div>
    <!--微信订购未支付提示-->
    <div id="weix_dialog_ordered_notice"
         style="position:absolute; width:551px; height:235px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/weix_ordered_notice.png" width="551" height="235"></div>
    <!--订购成功单次-->
    <div id="dialog_ordered"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/dialog_ordered.png" width="609" height="250"></div>
    <!--订购成功包月-->
    <div id="dialog_ordered_all"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/dialog_ordered_all.png" width="609" height="250"></div>
    <!--订购失败-->
    <div id="dialog_ordered_failed"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/order_failed.png" width="609" height="250"></div>
    <!--已订购提示-->
    <div id="dialog_ordered_second"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/ordered_second_tips.png" width="609" height="250">
    </div>
    <!--已订购提示倒计时-->
    <div id="ordered_sec_time"
         style="position:absolute; width:609px; height:250px; left:540px; top:363px; visibility:hidden; color:#ffffff;font-size:28px;"></div>
    <!--二维码请求失败的提示-->
    <div id="wx_req_failed_tips"
         style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/order_failed.png" width="609" height="250"/></div>
    <div id="timeout_msg"
         style="position:absolute; width:553px; height:237px; left:344px; top:223px; visibility:hidden;"><img
            src="images/order/timeout_msg.png" width="553" height="237"></div>
    <div id="test_firehome4k"
         style="position:absolute; width:200px; height:250px; left:100px; top:100px; border:3px solid red; visibility:hidden;"></div>
</div>
<%--关闭宽带支付--%>
<div id="broadband_error" style="position: absolute; width: 554px; height: 299px; left: 363px; top: 210px; visibility:hidden;">
    <img src="images/order/broadband_error.png" width="554" height="299">
</div>
<%--关闭宽带支付，去微信--%>
<div id="broadband_error_gowx" style="position: absolute; width: 554px; height: 299px; left: 363px; top: 210px;
visibility:hidden;">
    <img src="images/order/broadband_error_gowx.png" width="554" height="299">
</div>
<!--不支持微信支付的提示-->
<div id="no_wxpay_tips" style="position:absolute; width:609px; height:250px; left:344px; top:223px; visibility:hidden;">
    <img src="images/order/select_wxpay_notice.png" width="609" height="250"/></div>
<form name="iptv" method="get" action="vod_auth_orderlist.jsp">
    <input type="hidden" name="destpage" value="<%=iDestPage%>">
    <input type="hidden" name="columnid" value="<%=columnid%>">
    <input type="hidden" name="strADid" value="<%=strADid%>">
    <input type="hidden" name="strADid2" value="<%=strADid2%>">
    <input type="hidden" name="CategoryID" value="<%=CategoryID%>">
    <input type="hidden" name="ContentType" value="<%=contenttype%>">
    <input type="hidden" name="ContentID" value="<%=contentid%>">
    <input type="hidden" name="FatherContent" value="<%=fathercontent%>">
    <input type="hidden" name="programid" value="<%=programid%>">
    <input type="hidden" name="programtype" value="<%=programtype%>">
</form>
<script type="text/javascript">
    var _window = window;
    if (window.opener) {
        _window = window.opener;
    }

    function donext() {
        if (<%=iDestPage<pageCount%>) {
            top.mainWin.clearDiv();
            document.iptv.destpage.value = "<%=iDestPage+1%>";
            document.iptv.submit();
        }
    }

    function dolast() {
        if (<%=iDestPage<=pageCount%> &&
        <%=iDestPage >1%>)
        {
            top.mainWin.clearDiv();
            document.iptv.destpage.value = "<%=iDestPage-1%>";
            document.iptv.submit();
        }
    }

    window.parent.document.getElementById("detail").style.visibility = "hidden";
    if (window.parent.document.getElementById("playimg") != null) {
        window.parent.document.getElementById("playimg").style.visibility = "hidden";
    }
    window.parent.document.getElementById("detail_bg").style.display = "none";
    document.getElementById("big_bg").style.display = "block";
    window.parent.document.getElementById("fdiv").style.width = "1280px";
    window.parent.document.getElementById("fdiv").style.height = "720px";
    window.parent.document.getElementById("hiddenFrame").style.width = "1280px";
    window.parent.document.getElementById("hiddenFrame").style.height = "720px";
    var length = parseInt("<%=leng%>", 10);
    var programname = decodeURI("<%=programname%>");
    var product = ['order_urla', 'third_urla', 'strProductNamea', 'strPricea', 'strProductDesca', 'strEndTimea', 'strRentalTerma', 'strRentalUnita', 'strPurchaseTypea', 'strProductIDa'];
    product['order_urla'] = [];
    product['third_urla'] = [];
    product['strProductNamea'] = [];
    product['strPricea'] = [];
    product['strProductDesca'] = [];
    product['strEndTimea'] = [];
    product['strRentalTerma'] = [];
    product['strRentalUnita'] = [];
    product['strPurchaseTypea'] = [];
    product['strProductIDa'] = [];
    var istart = 0;
    var iend = 5;
    var focus_index = 0;//产品内容索引id\
    var pageSeq = 0;
    var pageCount = parseInt("<%=pageCount%>", 10);
    var userId = "<%=userId%>";
    if (iend > length) {
        iend = length;
    }
    <%
    for(int i=0; i<leng; i++){
    %>
    product['order_urla'][<%=i%>] = "<%=order_urla.get(i)%>";
    product['third_urla'][<%=i%>] = "<%=third_urla.get(i)%>";
    product['strProductNamea'][<%=i%>] = "<%=strProductNamea.get(i)%>";
    product['strPricea'][<%=i%>] = "<%=strPricea.get(i)%>";
    product['strProductDesca'][<%=i%>] = "<%=strProductDesca.get(i)%>";
    product['strEndTimea'][<%=i%>] = "<%=strEndTimea.get(i)%>";
    product['strRentalTerma'][<%=i%>] = "<%=strRentalTerma.get(i)%>";
    product['strRentalUnita'][<%=i%>] = "<%=strRentalUnita.get(i)%>";
    product['strPurchaseTypea'][<%=i%>] = "<%=strPurchaseTypea.get(i)%>";
    product['strProductIDa'][<%=i%>] = "<%=strProductIDa.get(i)%>";
    <%
    }
    %>
    var play_url_wx_str = "<%=playUrl%>";
</script>
<script type="text/javascript" src="js/qrcode.min.js"></script>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/contentloader.js"></script>
<script type="text/javascript" src="js/vod_auth_orderlist.js"></script>
</body>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/time_order.jsp" %>
</html>
