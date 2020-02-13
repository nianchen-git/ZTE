      <%	   
           Integer curpage = (Integer) pageContext.getAttribute("curpage");
           Integer  pagecount = (Integer) pageContext.getAttribute("pagecount");
		   if(curpage == null || curpage == 0){
			   curpage = new Integer(1);
		   }
			if(pagecount == null || pagecount == 0){
			   pagecount = new Integer(1);
		   }		
		   curNum = curpage.intValue(); 
		   sumNum = pagecount.intValue();
		   //System.out.println("=========curNum==========" + curNum);
		   //System.out.println("=========sumNum==========" + sumNum);	
        %>
        <div style="left:163; top:296;position:absolute">
            <img src="<%=imagesPath%>/liveTV/Previous.png" width="0" height="0" border="0" alt="">
        </div>

        

      
