<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Vector" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<epg:PageController/>
<%
      String timepath = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
      timepath = timepath.replace("action/", "");
//     String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
     HashMap param = com.zte.iptv.epg.util.PortalUtils.getParams(timepath, "GBK");
  int fav_scfw_sum=0;
  try{
		fav_scfw_sum = Integer.parseInt(param.get("fav_scfw_sum").toString());
	}catch(Exception e){
		fav_scfw_sum = 0;
	}
      System.out.println("endindex===starindex"+fav_scfw_sum);
	Vector cUrl = new Vector(fav_scfw_sum);
    Vector cName = new Vector(fav_scfw_sum);
    Vector cImg = new Vector(fav_scfw_sum);

    for(int i=0;i<=fav_scfw_sum-1;i++){
        String fav_scfw_name=(String)param.get("fav_scfw_name"+i);
        String fav_scfw_img=(String)param.get("fav_scfw_img"+i);
        String fav_scfw_url=(String)param.get("fav_scfw_url"+i);
        cName.add(i,fav_scfw_name);
        cUrl.add(i,fav_scfw_url);
        cImg.add(i,fav_scfw_img);
        System.out.println(fav_scfw_img+"endindex===starindex"+fav_scfw_url);

          }

    int destPage=1;
    if(request.getParameter("destpage")!=null){
        destPage=Integer.parseInt(request.getParameter("destpage"));
    }
    int totalpage = 0;
     int pagecoutn=18;
	if(fav_scfw_sum%pagecoutn==0){
		totalpage = fav_scfw_sum/pagecoutn;
	}else{
		totalpage = fav_scfw_sum/pagecoutn+1;
	}
    StringBuffer sb = new StringBuffer();
       sb.append("{pageCount:\"" + totalpage + "\",destpage:\"" + destPage + "\", FsData:[");
	int starindex=(destPage-1)*pagecoutn;
	int endindex=0;
    if(destPage==totalpage){
         endindex=fav_scfw_sum;
    }else if(destPage+1 <=totalpage){
	   endindex=starindex+pagecoutn;
	}else if(destPage+1 >totalpage){
	   endindex=fav_scfw_sum;
	}
    System.out.println(endindex+"endindex===starindex"+starindex);


    try {
     for(int i=starindex;i<endindex;i++){
           sb.append("{urlName:\"" + cName.get(i) + "\",");
           sb.append("urlPath:\"" + cUrl.get(i) + "\",");
           sb.append("urlImg:\"" + cImg.get(i) + "\"},");
     }
       sb.append("]}");
        JspWriter ot = pageContext.getOut();
        ot.write(sb.toString());
        System.out.println("+===============sv"+sb.toString());
     } catch (Exception e) {
        e.printStackTrace();
    }
%>