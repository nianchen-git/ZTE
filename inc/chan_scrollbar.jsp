<%
	int scrollBarLength = 237;
	int barHeight = scrollBarLength/sumNum;
	String chineseToday = "";
	if(dateString.equals(todayTime)){
		chineseToday = W_Today + ",";
	}
	String langTypeSession = String.valueOf(session.getAttribute("langType"));
	langTypeSession = langTypeSession == null ? "" : langTypeSession;
%>
	<%-- Program  Info --%>
	<%--<div id="showProgramInfo" style="left:170px;top:140px;width:950px;height:150px;position:absolute;" class="BigStyle">--%>
	<%--</div>--%>

	<%-- scroll bar --%>
<div style="left:1112px; top:<%=125+ barHeight*(curNum-1)%>;position:absolute">
	<img src="<%=imagesPath %>/liveTV/liveTV_scrolling_bar.png" width="17" height="<%=barHeight %>" alt="" border="0"/>
</div>

<div style="left:163;top:94;width:200;position:absolute;" align="center" class="BlackFontStyle">
    <%=timeString %><%-- 时间显示，左上角 ---%>
</div>