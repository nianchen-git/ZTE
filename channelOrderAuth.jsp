<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="java.util.*" %>
 <%@include file="inc/words.jsp" %>

<epg:PageController checkusertoken="false"/>
<html>
<head>
    <title></title>
</head>
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

		String[] prod_hb = {"666666"};

		producList.add(returnMap(prod_hb, 99));

		
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

		String[] prod_baoyue = {"100320", "100326","100333","100370","100347","100330","100329","100331","100398","100399","100327"};

		producList.add(returnMap(prod_baoyue, 899));
		
        return producList;
    }

    public static Object getSorting (String code) {

        ArrayList producList = organize();
        Object number = 9999;
        for(int i=0;i<producList.size();i++) {
            Map m = (Map)producList.get(i);
            String[] strs = (String[])m.get("produc");
            for(String s : strs) {
                if(code.equals(s)){
                    number = (Object)m.get("serial");
                    return number;
                }
            }
        }

        return number;

    }
	public static void comparator(ArrayList producList) {
		Collections.sort(producList,new Comparator () {
			public int compare(Object o1, Object o2) {
				Map m1 = (Map)o1;
				Map m2 = (Map)o2;
				Integer  s1 = Integer.valueOf(m1.get("Serial").toString());
	   			Integer  s2 = Integer.valueOf(m2.get("Serial").toString());
				return s1.compareTo(s2);
			}
    	 });
	}
	
	public static Map addSerial(Map dataOut){
		Vector serial = new Vector();
		Vector vProductId = getVParamFromField(dataOut, "ProductID");
			for(int i=0;i<vProductId.size();i++){
				serial.add(getSorting(vProductId.get(i).toString()));
			}
		
		dataOut.put("Serial",serial);
		return dataOut;
	}
	
	public static ArrayList reorganize(Map dataOut) {
		ArrayList productList = new ArrayList();
		
		Vector vProductDesc = getVParamFromField(dataOut, "ProductDesc");
		Vector vContentId  = getVParamFromField(dataOut, "ContentID");
		Vector vServiceId  = getVParamFromField(dataOut, "ServiceID");
		Vector vProductId  = getVParamFromField(dataOut, "ProductID");
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
		Vector vSerial = getVParamFromField(dataOut, "Serial");
		
		for(int i=0;i<vContentId.size();i++) {
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
		    productList.add(map);
		}

		return productList;
	}
	
    public static Vector getVParamFromField(Map fieldData, String name) {
        if (fieldData == null) {
            return null;
        }
        Vector vector = null;
        Object value = fieldData.get(name);
        if (value instanceof Vector) {
            vector = (Vector) value;
        } else {
            return null;
        }
        return vector;
    }


%>
<%
    pageContext.setAttribute(EpgConstants.CHANNEL_OPERATION,EpgConstants.CHANNEL_AUTH,PageContext.REQUEST_SCOPE);
	String successUrl = "authSuccess.jsp";
	String failureUrl = "authFailure.jsp";

    System.out.println("=========================channelOrderAuth=1");

%>
<epg:operate datasource="com.zte.iptv.functionepg.decorator.AuthAndShowProductListDecorator"
             operator="CriteriaAuthOperator" success="<%=successUrl%>" redirected="false" failure="<%=failureUrl%>"/> 
             
<script language="javascript" type="">
<%

    System.out.println("=========================channelOrderAuth=2");
	EpgResult result = (EpgResult) pageContext.getAttribute("Result");
	if(result==null)
		return;

    if (result.isEmpty()) {
        return;
    }
    Map map = result.getDataOut();
    Map dataOut = (Map)map.get(EpgResult.DATA);
	
	dataOut = addSerial(dataOut);
	ArrayList producList = reorganize(dataOut);
	
	
	//out.print("aaa====="+producList.size());
	
	comparator(producList);
    
	//out.print("bbbb====="+producList.size());
	
    Calendar today_ = Calendar.getInstance();
	
	for( int i=0;i<producList.size();i++ ){
		Map dataMap = (Map)producList.get(i);
		if(dataMap.get("AutoContinueOption")!= null){
			String productD = dataMap.get("ProductID").toString();
			if("0".equals(String.valueOf(dataMap.get("Fee")).trim())) {
                if(today_.after(dataMap.get("StartTime").toString())&&today_.before(dataMap.get("EndTime").toString())) {
                    pageContext.forward(successUrl+"?endTime="+dataMap.get("EndTime")+"&startTime="+dataMap.get("StartTime"));
                    return;
                }
            }
			//out.println( "ContentID=="+dataMap.get("ContentID")+"ServiceID=="+dataMap.get("ServiceID"));
			%>
			top.jsAddProduct('<%=(String)dataMap.get("ContentID")%>','<%=(String)dataMap.get("ServiceID")%>',
                                '<%=(String)dataMap.get("ProductID")%>','<%=(String)dataMap.get("ProductName")%>',
                                '<%=""+dataMap.get("ListPrice")%>','<%=""+dataMap.get("Fee")%>',
                                '<%=""+dataMap.get("PurchaseType")%>','<%=""+dataMap.get("RentalTerm")%>',
                                '<%=""+dataMap.get("LimitTimes")%>','<%=""+dataMap.get("flag")%>',
                                '<%=""+dataMap.get("StartTime")%>','<%=""+dataMap.get("EndTime")%>','<%=""+dataMap.get("AutoContinueOption")%>');
			<%
		}else{
			String productD = dataMap.get("ProductID").toString();
			if("0".equals(String.valueOf(dataMap.get("Fee")).trim())) {
                if(today_.after(dataMap.get("StartTime").toString())&&today_.before(dataMap.get("EndTime").toString())) {
                    pageContext.forward(successUrl+"?endTime="+dataMap.get("EndTime")+"&startTime="+dataMap.get("StartTime"));
                    return;
                }
            }
			//out.println( "ContentID=="+dataMap.get("ContentID")+"ServiceID=="+dataMap.get("ServiceID"));
			%>
			top.jsAddProduct('<%=(String)dataMap.get("ContentID")%>','<%=(String)dataMap.get("ServiceID")%>',
                                '<%=(String)dataMap.get("ProductID")%>','<%=(String)dataMap.get("ProductName")%>',
                                '<%=""+dataMap.get("ListPrice")%>','<%=""+dataMap.get("Fee")%>',
                                '<%=""+dataMap.get("PurchaseType")%>','<%=""+dataMap.get("RentalTerm")%>',
                                '<%=""+dataMap.get("LimitTimes")%>','<%=""+dataMap.get("flag")%>',
                                '<%=""+dataMap.get("StartTime")%>','<%=""+dataMap.get("EndTime")%>');
			<%
		}
	}
	
    
        
%>
	//top.jsAuthNotSubscribe();
	var Channel_no= top.channelInfo.currentChannel;
	var stbType= Authentication.CTCGetConfig("STBType");
	if(stbType==null||stbType==undefined||typeof stbType=="undefined"){
		stbType= Authentication.CUGetConfig("STBType");
	}
	//非4K机顶盒播放4K频道时，不再弹出直播订购页！
	if(Channel_no == 40){
		if(stbType == "EC6108V9U_pub_bjjlt" || stbType == "Q1" || stbType == "B860A" || stbType == "HG680-JLGEH-52" || stbType == "Q5" || stbType == "EC5108" || stbType == "B860AV1.2" || stbType == "Q7" || stbType == "S-010W-A" || stbType == "DTTV100"|| stbType == "EC6108V9U_ONT_bjjlt"){     
			top.jsAuthNotSubscribe();
		} 
	}else{
		top.jsAuthNotSubscribe();
	}
</script>

<body bgcolor="transparent">
</body>
</html>

