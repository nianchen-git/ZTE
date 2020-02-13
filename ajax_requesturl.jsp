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

		String[] prod_baoyue1 = {"100402"};
		producList.add(returnMap(prod_baoyue1,90));

		String[] prod_dandian = {"100101", "100102" , "100105", "100110", "100349", "100201", "100202", "100205", "100350", "100351", "100352", "100336", "100337", "100338", "100339", "100340", "100341", "100342", "100343"};
		producList.add(returnMap(prod_dandian, 199));

		String[] prod_30 = {"100417", "100420", "100423","100426","100429", "100432","100435","100438","100441","100444","100447","100450","100453","100456","100459","100462","100465","100467","100470","100475","100483","100489","100486"};

		producList.add(returnMap(prod_30, 299));

		String[] prod_90 = {"100418", "100421", "100424", "100427", "100430", "100433","100436","100439","100442","100445","100448","100451","100454","100457","100460","100463"};

		producList.add(returnMap(prod_90, 399));

		String[] prod_365 = {"100468", "100466", "100464", "100461", "100458", "100455","100452","100449","100446","100443","100440","100437","100434","100431","100428","100425","100422","100419","100472","100476","100484","100490","100487"};

		producList.add(returnMap(prod_365, 499));

		String[] prod_baoyue = {"100325", "100316", "100348", "100370", "100353", "100346", "100335", "100328", "100324", "100327", "100386", "100379", "100315","100400","100469","100474","100482","100488","100485"};
		producList.add(returnMap(prod_baoyue, 599));


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
//String contentCode = "01010001000000010000000001873574";
String contentCode =request.getParameter("global_code");
String programTypea = "";
String columnCodea="";
String programCode="";
String seriesprogramCode="";
String terminalflag = "1";
String definition = "1";
String authidsession="";
String mediaUrl="";
String mediaprogramCode="";
JSONObject obj = new JSONObject();
JSONArray authArra = new JSONArray();
StringBuffer sa = new StringBuffer();
int flag =0; 
String results = "";

StringBuffer sb = new StringBuffer();
%>
<ex:params var="input">
<ex:param name="telecomcodeavailable" value="<%=contentCode%>"/>
</ex:params>
<ex:search tablename="user_vod_detail" fields="*" inputparams="${input}" pagecount="100"  var="detaillist">
    <%
	List<Map> slist = (List<Map>)pageContext.getAttribute("detaillist");
	if(slist.size()>0){
										for (Map VODS : slist){
										obj.put("programCode",VODS.get("programcode"));
										obj.put("programName",VODS.get("programname"));
										obj.put("columnCode",VODS.get("columncode"));
										obj.put("programType",VODS.get("programtype"));
										obj.put("seriesprogramCode",VODS.get("seriesprogramcode"));
										programTypea =  (String)VODS.get("programtype");
										columnCodea = (String)VODS.get("columncode");
										programCode = (String)VODS.get("programcode");
										mediaprogramCode=(String)VODS.get("programcode");
										seriesprogramCode=(String)VODS.get("seriesprogramcode");
										}
										//out.print("seriesprogramCode"+seriesprogramCode+"programCode"+programCode);
	}else{
		flag=1;
		results ="1";//未找到节目数据
	}																
    %>
</ex:search>

<%
	if((programTypea).equals("10")){
		  StringBuffer sql = new StringBuffer();
        sql.append("programcode=" + seriesprogramCode);
%>
       <ex:search tablename="user_series" fields="*" condition="<%=sql.toString()%>"  var="detaillist">
     <%
	List<Map> serlist = (List<Map>)pageContext.getAttribute("detaillist");
	if(serlist.size()>0){
										for (Map VODS : serlist){
										obj.put("programCode",VODS.get("programcode"));
										obj.put("programName",VODS.get("programname"));
										obj.put("columnCode",VODS.get("columncode"));
										obj.put("programType",VODS.get("programtype"));
									
										programTypea =  (String)VODS.get("programtype");
										columnCodea = (String)VODS.get("columncode");
										programCode = (String)VODS.get("programcode");
										
										}
										//out.print("programTypea"+programTypea+"programCode"+programCode);
	}else{
		
		flag=1;
		results ="1";//未找到节目数据
	}	
	
															
    %> 
    </ex:search>
<%	
	}
	
%>

<%
if(flag==0){
%>
	<ex:params var="authParams">
	   <ex:param name="contenttype"    value="<%=programTypea%>"/>
	   <ex:param name="columncode"   value="<%=columnCodea%>"/>
	   <ex:param name="programcode"  value="<%=programCode%>"/>
	   <ex:param name="terminalflag"   value="<%=terminalflag%>"/>
	   <ex:param name="definition"     value="<%=definition%>"/>
	</ex:params>
	<ex:action name="auth"  inputparams="${authParams}"  var="authMap">
	
	<%
	 JSONArray authArr = new JSONArray();
	 Map authResult = (Map) pageContext.getAttribute("authMap");
    flag = Integer.parseInt(authResult.get("_flag").toString());
	results=authResult.get("_flag").toString();

				if(flag == 0){//auth success
					JSONObject authObj = new JSONObject();
					Vector vodData = (Vector) authResult.get("data");
					Map productInfo = (HashMap) vodData.get(0);
					authidsession = (String)productInfo.get("AuthorizationID");
				}else if(flag==5 ||flag==98 ){
            ArrayList data = transVector((Vector) authResult.get("data"));
      				Map productInfo = null;
      				if(data != null && data.size()>0){
					   sa.append("[");
           	 			for(int i = 0; i < data.size();i++){
						    JSONObject product = new JSONObject();
							productInfo = (Map)data.get(i);

							//看吧点播产品屏蔽
							if(!"100435".equals(productInfo.get("ProductID")) && !"100436".equals(productInfo.get("ProductID")) && !"100437".equals(productInfo.get("ProductID")) && !"100445".equals(productInfo.get("ProductID"))&& !"100421".equals(productInfo.get("ProductID")) && !"100424".equals(productInfo.get("ProductID")) && !"100427".equals(productInfo.get("ProductID")) && !"100430".equals(productInfo.get("ProductID")) && !"100433".equals(productInfo.get("ProductID")) && !"100439".equals(productInfo.get("ProductID")) && !"100442".equals(productInfo.get("ProductID")) && !"100448".equals(productInfo.get("ProductID")) && !"100451".equals(productInfo.get("ProductID")) && !"100454".equals(productInfo.get("ProductID")) && !"100418".equals(productInfo.get("ProductID")) && !"100381".equals(productInfo.get("ProductID")) && !"100384".equals(productInfo.get("ProductID")) && !"100356".equals(productInfo.get("ProductID")) && !"100355".equals(productInfo.get("ProductID")) && !"100364".equals(productInfo.get("ProductID")) && !"100363".equals(productInfo.get("ProductID")) && !"100371".equals(productInfo.get("ProductID")) && !"100373".equals(productInfo.get("ProductID")) && !"100457".equals(productInfo.get("ProductID")) && !"100359".equals(productInfo.get("ProductID")) && !"100432".equals(productInfo.get("ProductID")) && !"100434".equals(productInfo.get("ProductID")) && !"100477".equals(productInfo.get("ProductID")) && !"100478".equals(productInfo.get("ProductID")) && !"100479".equals(productInfo.get("ProductID")) && !"100377".equals(productInfo.get("ProductID")) && !"100459".equals(productInfo.get("ProductID")) && !"100461".equals(productInfo.get("ProductID")) && !"100411".equals(productInfo.get("ProductID")) && !"100412".equals(productInfo.get("ProductID"))&& !"100423".equals(productInfo.get("ProductID")) && !"100425".equals(productInfo.get("ProductID")) && !"100444".equals(productInfo.get("ProductID")) && !"100446".equals(productInfo.get("ProductID")) ) {

								product.put("strContentid", productInfo.get("ContentID"));//节目code
								product.put("strServiceid", productInfo.get("ServiceID"));//服务code
								product.put("strProductID", productInfo.get("ProductID"));//产品code
								product.put("strProductName", productInfo.get("ProductName"));//产品名称
								product.put("strPrice", productInfo.get("Fee"));//价格
								product.put("strProductDesc", productInfo.get("ProductDesc"));//产品描述
								product.put("strRentalTerm", productInfo.get("RentalTerm"));//租期
								product.put("strRentalUnit", productInfo.get("RentalUnit"));//产品租期单位
								authArra.add(product);

								sa.append("{strContentid:\"" + productInfo.get("ContentID") + "\",strServiceid:\"" + productInfo.get("ServiceID") + "\",strProductID:\"" + productInfo.get("ProductID") + "\",strProductName:\"" + productInfo.get("ProductName") + "\",strPrice:\"" + productInfo.get("Fee") + "\",strProductDesc:\"" + productInfo.get("ProductDesc") + "\",strRentalTerm:\"" + productInfo.get("RentalTerm") + "\",strRentalUnit:\"" + productInfo.get("RentalUnit") + "\",strPurchaseType:\"" + productInfo.get("PurchaseType") + "\",strCategoryID:\"" + productInfo.get("CategoryID") + "\",contenttype:\"" + programTypea + "\",strprogramcode:\"" + programCode + "\"}");
								if (i < (data.size() - 1)) {
									sa.append(",");
								}
							}
					    }
						sa.append("]");
					}
				}else if(flag == -1){//黑名单用户
				   flag = -1;
				   results ="-1";	
				}else{
					  flag = 1;
				   results ="1";//未找到节目数据	
				}
					%>
	</ex:action>
	<%
}
		if(0==flag){
	%>
		 <ex:params var="inputPlayParams">
					<ex:param name="authidsession"  value="<%=authidsession%>"/>
				  <ex:param name="programcode"  value="<%=mediaprogramCode%>"/>
				</ex:params>
				<ex:action name="vod_play" inputparams="${inputPlayParams}" var="playMap">
						<%
				Map result = (Map) pageContext.getAttribute ("playMap");
				String playurl = String.valueOf (result.get("playurl"));
				obj.put("mediaUrl",playurl);
				results = playurl;
						%>
				</ex:action>
<%	
		}
%>
<%
//sb.append("{flag:\"" + flag + "\",result:\"" + results +"\"}");
String callbackFn = request.getParameter("callback");
String jsonResult="";
if(sa.length()>0){
	jsonResult = callbackFn + "("+"[{flag:\"" + flag + "\",result:\"" + results +"\",product:" + sa +"}]"+")";
}else{
	jsonResult = callbackFn + "("+"[{flag:\"" + flag + "\",result:\"" + results +"\",product:\"0\"}]"+")";
}

sb.append(jsonResult);
JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>
