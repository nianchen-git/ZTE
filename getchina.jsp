<%@ page import="java.util.HashMap" %>
<%@page contentType="text/html; charset=GBK" %>

<%!

    public  String loadConvert (char[] in, int off, int len, char[] convtBuf) {
      if (convtBuf.length < len) {
          int newLen = len * 2;
          if (newLen < 0) {
              newLen = Integer.MAX_VALUE;
         }
          convtBuf = new char[newLen];
      }
      char aChar;
      char[] out = convtBuf;
      int outLen = 0;
      int end = off + len;

     while (off < end) {
          aChar = in[off++];
          if (aChar == '\\') {
             aChar = in[off++];
              if(aChar == 'u') {
                 // Read the xxxx
                  int value=0;
                  for (int i=0; i<4; i++) {
                      aChar = in[off++];
                     switch (aChar) {
                       case '0': case '1': case '2': case '3': case '4':
                        case '5': case '6': case '7': case '8': case '9':
                           value = (value << 4) + aChar - '0';
                           break;
                        case 'a': case 'b': case 'c':
                        case 'd': case 'e': case 'f':
                          value = (value << 4) + 10 + aChar - 'a';
                           break;
                        case 'A': case 'B': case 'C':
                        case 'D': case 'E': case 'F':
                          value = (value << 4) + 10 + aChar - 'A';
                           break;
                        default:
                            throw new IllegalArgumentException(
                                         "Malformed \\uxxxx encoding.");
                      }
                   }
                  out[outLen++] = (char)value;
              } else {
                  if (aChar == 't') aChar = '\t';
                  else if (aChar == 'r') aChar = '\r';
                  else if (aChar == 'n') aChar = '\n';
                  else if (aChar == 'f') aChar = '\f';
                  out[outLen++] = aChar;
              }
          } else {
              out[outLen++] = (char)aChar;
          }
      }
      return new String (out, 0, outLen);
    }

    String getChinese(HashMap param, String name){
        String value = (String)param.get(name);
        if(value != null ){
           value = loadConvert(value.toCharArray(),0,value.length(),new char[0]);
        }
        return value;
    }

%>
<%

    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();
%>

<script type="text/javascript">
            function setBackParam(index,title) {
            //对华为盒子的处理，首页键交由机顶盒
	        var ua = window.navigator.userAgent;
	       //alert("=====getchina ua==1111=="+ua);
          if(ua.indexOf("Ranger/3.0.0")>-1){
              //alert("this is hw get key to stb");
             keySTBPortal(thirdbackUrl);
          }
            var backurlparam = document.location.href;
            var suindex = parseInt(backurlparam.indexOf("leefocus"));
            var suindex1 = parseInt(backurlparam.indexOf("lastfocus"));

            var subindex = suindex > 0 ? suindex : suindex1;
            backurlparam = backurlparam.substr(0, subindex++);

            backurlparam += "lastfocus=llinker" + index+"&param="+title;
            top.jsSetControl("backurlparam", backurlparam);
            var lastChannelNum = top.channelInfo.currentChannel;
          //  alert("SSSSSSSSSSSSSSSSSSSSfavorite_service_lastChannelNum="+lastChannelNum);
            if(isZTEBW == true){
                ztebw.setAttribute("curMixno", lastChannelNum);
                <%--Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");--%>
                if("CTCSetConfig" in Authentication){
                    Authentication.CTCSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
                }else{
                    Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
                }
            }else{
                Authentication.CUSetConfig('EPGDomain', "<%=timeFrameUrl%>/thirdback.jsp");
            }
        }
        
     function keySTBPortal(serviceUrl)
     {
var xml = '';
xml += "<?xml version='1.0' encoding='UTF-8'?>";
xml += '<global_keytable>';
xml += '<response_define>';
xml += '<key_code>KEY_PORTAL</key_code>';
xml += '<response_type>2</response_type>';
xml += '<service_url>'+serviceUrl+'</service_url>';
xml += '</response_define>';
xml += '</global_keytable>';
Authentication.CUSetConfig("GlobalKeyTable", xml);
}
</script>
