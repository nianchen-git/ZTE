<%@page contentType="text/html; charset=GBK" %>
<%@taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<%@page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="java.util.*" %>
<%@ include file="inc/getFitString1.jsp" %>
<%@ page import="java.util.Vector" %>
<%@ include file="inc/getchina.jsp" %>
<epg:PageController name="special.jsp"/>

<% 
    String title=request.getParameter("param");
    String path = PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path,"GBK");
    //String headname=(String)param.get(title);
     String headname=getChinese(param,title);
    int spe_sum = 0;
	try{
		spe_sum = Integer.parseInt(param.get(title+"_sum").toString());
	}catch(Exception e){
		spe_sum = 0;
	}
	Vector cUrl = new Vector(spe_sum);
    Vector cName = new Vector(spe_sum);
    Vector cImg = new Vector(spe_sum);
    for(int i=0;i<=spe_sum;i++){
        //String spe_name=(String)param.get(title+"_name"+i);
         String spe_name =  getChinese(param,title + "_name" + i);
        String spe_img=(String)param.get(title+"_img"+i);
        String spe_url=(String)param.get(title+"_url"+i);
        if(spe_name==null){
            break;
        }else{
        cName.add(i,spe_name);
        cUrl.add(i,spe_url);
        cImg.add(i,spe_img);
        }
    }
    
    
    int totalpage = 0;
	if(spe_sum%12==0){
		totalpage = spe_sum/12;
	}else{
		totalpage = spe_sum/12+1;
	}
		


	String nextPage = request.getParameter("nextPage");
	if(null==nextPage || nextPage.equals("")){
		nextPage = "1";
	}
	int next = Integer.parseInt(nextPage);
	if(next > totalpage){
		next = totalpage;
	}
	if(next <= 0){
		next = 1;
	}
	int starindex=0;
	int endindex=0;
	
	if(next <totalpage){
       starindex=0;
	   endindex=12;
	}else if(next ==totalpage){
	   starindex=0;
	   endindex=spe_sum-(totalpage-1)*12;
	}

%>
<html>
    <head>
    <epg:script />
        <title>专题</title>
        <script type="" language="javascript">
         var linkindex;
		function toPrevPage(){
			document.location = "special.jsp?nextPage=<%=next-1%>&param=<%=title%>"
		}

		function toNextPage(){
			document.location = "special.jsp?nextPage=<%=next+1%>&param=<%=title%>"
		}
       function changeImg(index,state){
           linkindex=index;
            if(state==1){
              document.getElementById("img_"+index).src="images/community/btv-mytv-appbgc.png";
              document.getElementById("img_" + index).style.visibility="visible";
            }else{
              document.getElementById("img_"+index).src="images/btn_trans.gif";
              document.getElementById("img_" + index).style.visibility="hidden";
            }
        }

        <%
         UserInfo timeUserInfo = (UserInfo)request.getSession().getAttribute(EpgConstants.USERINFO);
         String timePath1 = request.getContextPath();
         String timeBasePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+timePath1+"/";
         System.out.println("SSSSSSSSSSSSSSSSSSSSStimeBasePath="+timeBasePath);
        %>

         function gotothrid(url,index){
           if(url){
              if(url.indexOf('?') > -1){
                  url = url+"&returnurl=<%=timeBasePath%>function/index.jsp";
              }else{
                  url = url+"?returnurl=<%=timeBasePath%>function/index.jsp";
              }
              top.doStop();
              top.mainWin.document.location=url;
           }else{
                document.location="thirdlink.jsp?leefocus=llinker"+index;
            }


        }
            function goRight(){
                  if(linkindex==5&&document.links["llinker"+6]){
                    document.links["llinker"+6].focus();
                  }else if(linkindex==17&&document.links["llinker"+18]){
                     document.links["llinker"+18].focus();
                  }else if(!document.links["llinker"+(++linkindex)]){
                  //    alert((++linkindex)+"==========comeuin"+document.links["llinker"+parseInt(linkindex+1)]);
                     document.links["llinker"+0].focus();
                  }
         }
         function goLeft(){
             if(linkindex==6&&document.links ["llinker"+5]){
                 document.links["llinker"+5].focus();
             }else if(linkindex==18&&document.links ["llinker"+17]){
                 document.links["llinker"+17].focus();
             }else if(linkindex==0){
                  document.links["llinker"+<%=endindex-1%>].focus();
             }
         }
         function  doKeyPress(evt){
             var keycode=evt.which;
             if(keycode==0x0027){
                  goRight();
             }else if(keycode==<%=STBKeysNew.onKeyLeft%>){
                  goLeft();
             }else{
                  top.doKeyPress(evt);
                  return true;
             }
             return true;
         }
        document.onkeypress = doKeyPress;
	 </script>
    </head>
    <body bgcolor="transparent" >
    <div  style="position:absolute; width:1280px; height:720px; left:0px; top:0px;">
    <img src="images/vod/btv_bg.png" height="720" width="1280" alt="">
    </div>
         <div style="background:url('images/bg_bottom.png'); position:absolute; width:1280px; height:43px; left:0px; top:634px;">
     </div>
    <% 
        int left=0;
        int top=0;
        for(int i=starindex;i<endindex;i++){
            if(i<cUrl.size()){
            int index=(next-1)*12+i;
            int row=i/6;//行
            int cow=i%6;//列
            left=cow*170+110;
            top=row*170+100;
               
             String url = "";
            if(cUrl.get(index) != null){
                url = (String)cUrl.get(index);
                 if(url.trim().equals("#") || url.trim().equals("")){
                      url = "";
                 }
            }
            
    %>
    <div style="position:absolute; width:22; height:35; left:33px; top:22px;">
	<img src="images/special/btv-topics-ico.png" border="0">
    </div>
    <div id="path" style="position:absolute; width:760px; height:51px; left:80px; top:25px;font-size:24px;color:#FFFFFF">专题 ><%=headname%>
    </div>
       <%
//           System.out.println("=================cUrl.get(index)="+cUrl.get(index));
       %>
       <div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;" align="center">
           <a name="llinker<%=index%>" href="javascript:gotothrid('<%=url%>','<%=index%>')" onfocus="changeImg('<%=index%>','1')" onblur="changeImg('<%=index%>','0')">
               <img src="images/btn_trans.gif" width="1" height="1" alt="" border="0">
           </a>
       </div>
        <div style="position:absolute;left:<%=left %>px; top:<%=top-5 %>px; width:150px;" align="center">
           <img id="img_<%=index%>" src="images/btn_trans.gif" width="116" height="116" alt="" border="0">
       </div>
       <!-- 图片信息 -->
       <div style="position:absolute;left:<%=left %>px; top:<%=top %>px; width:150px;" align="center">
           <img src="images/special/<%=cImg.get(index) %>" width="105" height="105" alt="" border="0">
       </div>
       <!-- 名称信息 -->
       <div style="position:absolute;left:<%=left+8 %>px; top:<%=top+110 %>px; width:150px; font-size:24px;color:#ffffff;" align="center">
            <%=String.valueOf(cName.get(index)) %>
       </div>
    <%
    
       }else{
         break;
       }
       }
    %>
       <%--<!-- 广告一 -->--%>
       <%--<div style="position: absolute;left: 65px;top: 528px;">--%>
               <%--<epg:FirstPage left="65" top="533" width="354" height="85" location="guanggao01"/>--%>
       <%--</div>--%>
       <%--<!-- 广告二 -->--%>
        <%--<div style="position: absolute;left: 449px;top: 528px;">--%>
               <%--<epg:FirstPage left="449" top="533" width="354" height="85" location="guanggao02"/>--%>
       <%--</div>--%>
       <%--<!-- 广告三 -->--%>
        <%--<div style="position: absolute;left: 833px;top: 528px;">--%>
              <%--<epg:FirstPage left="833" top="533" width="354" height="85" location="guanggao03"/>--%>
       <%--</div>--%>
 
    <!-- 底部按钮 -->
    <div style="position:absolute; width:350px; height:38px; left:805px; top:640px;font-size:18px;">
    <div id="pre" style="visibility:visible">
    <img src="images/vod/btv_page.png" alt="" style="position:absolute;left:0;top:0px;">
        <font style="position:absolute;left:2;top:4px;color:#000000">上一页</font>
        <font style="position:absolute;left:83;top:4px;color:#FFFFFF">上一页</font>
    </div>
    <div id="next" style="visibility:visible">
    <img src="images/vod/btv_page.png" alt="" style="position:absolute;left:200;top:0px;">
        <font style="position:absolute;left:202;top:4px;color:#000000">下一页</font>
        <font style="position:absolute;left:282;top:4px;color:#FFFFFF">下一页</font>
    </div>
    </div>
<script language="javascript" type="">
  top.jsSetupKeyFunction("top.mainWin.toPrevPage", 0x0021);
  top.jsSetupKeyFunction("top.mainWin.toNextPage",0x0022);
</script>  
    </body>
<%@ include file="inc/mailreminder.jsp" %>
<%@include file="inc/goback.jsp" %>
<%@include file="inc/lastfocus.jsp" %>
<%@include file="inc/time.jsp"%>
</html>