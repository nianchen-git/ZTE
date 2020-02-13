<%@page contentType="text/html; charset=GBK" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.zte.iptv.epg.web.Result" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnOneDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%!
   public String getColumnPath(String columnid, UserInfo userInfo){
//       System.out.println("==============columnid==============="+columnid);
//       List columnList=new ArrayList();
//       int index=0;
//       int leng=columnid.length()/2;
//       for(int i=0;i<leng;i++){
//          index=i*2;
//          columnList.add(columnid.substring(0,index+2));
//       }
       String columnpath="µã²¥>";
//       for(int i=0;i<columnList.size();i++){
//           ColumnOneDataSource ds=new ColumnOneDataSource();
//           ColumnValueIn valueIn=(ColumnValueIn)ds.getValueIn();
//           valueIn.setColumnId(columnList.get(i).toString());
//           valueIn.setUserInfo(userInfo);
//           valueIn.setNumPerPage(4);
//           valueIn.setPage(1);
//           try{
//               EpgResult result = ds.getData();
//               List vColumnData = (List) result.getData();
//               for(int j=0;j<vColumnData.size();j++){
//                   ColumnInfo info=(ColumnInfo)vColumnData.get(j);
//                   columnpath+=info.getColumnName();
//                   columnpath+=">";
//               }
//           }catch(Exception e){
//               e.printStackTrace();
//           }
//       }
//       columnpath=columnpath.substring(0,columnpath.length()-1);
       return columnpath;
   }
%>