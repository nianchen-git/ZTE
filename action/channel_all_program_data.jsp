<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.epg.web.VoDQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgPaging" %>
<%@ page import="com.zte.iptv.epg.content.VoDContentInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.datasource.VodSeriesDataSource" %>
<%@ page import="com.zte.iptv.epg.web.SearchResult" %>
<%@ page import="com.zte.iptv.epg.content.VoDQuery" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@ page import="com.zte.iptv.epg.web.ChannelQueryValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.ChannelDataSource" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="java.util.*" %>
<%
    String destpage = request.getParameter("destpage");
    int destpage1 = 1;
    if (destpage != null && !"".equals(destpage)) {
        try {
            destpage1 = Integer.parseInt(destpage);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<epg:PageController/>
<%
    List channelAllDs;
    UserInfo userInfo = (UserInfo) pageContext.getAttribute(EpgConstants.USERINFO, PageContext.SESSION_SCOPE);
    String strColumnid = request.getParameter("columnid");
    String isUpDown = "";
    int proIndex = 0;
    if (request.getParameter("proIndex") != null) {
      try{
        proIndex = Integer.parseInt(request.getParameter("proIndex"));
     }catch (Exception e){
            System.out.println("SSSSSSSSSSSproIndex_error!");
        }    
}
    if (request.getParameter("UpDown") != null) {
        isUpDown = request.getParameter("UpDown");
    }
    String curIndex = "0";
    if (request.getParameter("curIndex") != null) {
        curIndex = request.getParameter("curIndex");
    }


    int pageCount = 1;
	String flag="0";
    ChannelDataSource channelD = new ChannelDataSource();
    ChannelQueryValueIn valuesI = (ChannelQueryValueIn) channelD.getValueIn();
    valuesI.setUserInfo(userInfo);
    valuesI.setColumnId(strColumnid);
    EpgResult resultTVs = channelD.getData();
    List vChannelDatas = (Vector) resultTVs.getData();
	 for (int m = 0; m < vChannelDatas.size(); m++) {
            ChannelInfo ChannelInfom = (ChannelInfo) vChannelDatas.get(m);
			String noas = String.valueOf(ChannelInfom.getMixNo());
			if("301".equals(noas)||"303".equals(noas)||"49".equals(noas)||"54".equals(noas)){//判断频道为201，202，203，移除该频道
			 vChannelDatas.remove(m);
					m--;
			}
		    if("6".equals(noas)){
			 flag="1";
			}
	  }
	int totalchannelS =vChannelDatas.size();
	int totalchannelSa =0;
	
	if("0400".equals(strColumnid) && "1".equals(flag)){
	 totalchannelSa = vChannelDatas.size()-1;
	}else{
	 totalchannelSa = vChannelDatas.size();
	}
    

    ChannelDataSource channelDs = new ChannelDataSource();
    ChannelQueryValueIn valuesIn = (ChannelQueryValueIn) channelDs.getValueIn();
    valuesIn.setUserInfo(userInfo);
    valuesIn.setColumnId(strColumnid);
	if("0400".equals(strColumnid) && "1".equals(flag)){
	if (destpage != null) {
        valuesIn.setNumPerPage(8);
        valuesIn.setPage(destpage1);
    }
	}else{
    if (destpage != null) {
        valuesIn.setNumPerPage(7);
        valuesIn.setPage(destpage1);
    }
	}
    EpgResult resultTV = channelDs.getData();
    List vChannelData = (Vector) resultTV.getData();


    //分页相关数据
    HashMap hmPage = resultTV.getDataOut();
    EpgPaging paging = (EpgPaging) hmPage.get("page");
    pageCount = paging.getPageCount();
    
    StringBuffer sb = new StringBuffer();


    String MixNo = "";
    String programName = "";
    String channelId = "";

	  int length = vChannelDatas.size();
    channelAllDs = vChannelDatas;
    int j = 0;
    //channelAllDs = vChannelData;
    if (!isUpDown.equals("") && proIndex!=0) {
        j = proIndex;
		if("0400".equals(strColumnid)&& "1".equals(flag)){
		length = j + 8;
		}else{
		length = j + 7;
		}
        
        if (length > totalchannelS) {
            length = totalchannelS;
            destpage1 = pageCount;
        }
    }else{
		 j = (destpage1-1)*7;

		length = j + 7;
		
        if (length > totalchannelS) {
            length = totalchannelS;
            destpage1 = pageCount;
        }	
    }
//    System.out.println("===================length==============strColumnid=" + strColumnid);
    sb.append("{pageCount:\"" + pageCount + "\",destpage:\"" + destpage1 + "\",totalcountL:\"" + totalchannelSa + "\",curIndex:\"" + curIndex + "\", tvprogramdata:[");
    if (length > 0) {
//        Collections.sort(channelAllDs,new Comparator() {
//            public int compare(Object o1, Object o2) {
//               return ((ChannelInfo)o1).getMixNo() - ((ChannelInfo)o2).getMixNo();
//            }
//        });
        for (int i = j; i < length; i++) {
            ChannelInfo ChannelInfo = (ChannelInfo) channelAllDs.get(i);
			String noa = String.valueOf(ChannelInfo.getMixNo());
		    //if(!"6".equals(noa)){
            MixNo = ChannelInfo.getMixNo() + "";
            programName = ChannelInfo.getChannelName();
            channelId = ChannelInfo.getChannelId();
            sb.append("{MixNo:\"" + MixNo + "\",");
            sb.append("programName:\"" + programName + "\",");
            sb.append("channelId:\"" + channelId + "\"}");
            if (i < length - 1) {
                sb.append(",");
            }
		//	}
        }
    }
    sb.append("]}");

//    String str = "{pageCount:\"2\",destpage:\"1\", channelData:[{columnid:\"0000\",channelid:\"ch11122716302973821722\",channelname:\"yl\",mixno:\"3\"},{columnid:\"0000\",channelid:\"ch12041816284773227925\",channelname:\"bbbbbbbbbbb\",mixno:\"4\"},{columnid:\"0000\",channelid:\"ch12041816290136618562\",channelname:\"cccccccccccccccc\",mixno:\"5\"},{columnid:\"0000\",channelid:\"ch12040909475411182496\",channelname:\"hi man\",mixno:\"8\"},{columnid:\"0000\",channelid:\"ch12040909475411182496\",channelname:\"hi man\",mixno:\"8\"},{columnid:\"0000\",channelid:\"ch12040909475411182496\",channelname:\"hi man\",mixno:\"8\"},{columnid:\"0000\",channelid:\"ch12040909475411182496\",channelname:\"hi man\",mixno:\"8\"}]}";
//    sb = new StringBuffer(str);
//    System.out.println("=======SSSSSSSSchannel_all_program_data=" + sb.toString());
    JspWriter ot = pageContext.getOut();
    ot.write(sb.toString());
%>

