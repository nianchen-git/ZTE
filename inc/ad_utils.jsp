<%@ page import="com.zte.iptv.epg.util.EpgConstants" %>
<%@ page import="com.zte.iptv.newepg.tag.PageController" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgDataSource" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.epg.utils.Utils" %>
<%@ page import="com.zte.iptv.epg.content.ChannelInfo" %>
<%@ page import="com.zte.iptv.epg.content.XbaseCacheManage" %>

<%!
    public EpgResult getEpgResult(String datasource, PageContext pageContext) {
        PageController pc = (PageController) pageContext.getAttribute(EpgConstants.CONTROLLER);
        if (pc == null) {
            return EpgResult.newInstance();
        }
        try {
            EpgDataSource eds = pc.getDataSource(datasource);
            EpgResult result = eds.getData();
            return result;
        }
        catch (Exception ex) {
            return EpgResult.newInstance();
        }
    }

    public Map getData(EpgResult result) {
        if (result.isEmpty()) {
            return null;
        }
        Map dataOut = result.getDataOut();
        Map data = (Map) dataOut.get(EpgResult.DATA);
        return data;
    }

    public String getParamFromField(Map fieldData, String name) {
        if (fieldData == null) {
            return "";
        }
        Object value = fieldData.get(name);
        if (value instanceof Vector) {
            Vector vector = (Vector) value;
            if (vector.size() > 0) {
                value = vector.get(0);
            } else {
                return "";
            }
        }
        return value == null ? "" : value.toString();
    }
	public String getParamFromField(String datasource, String name,PageContext pageContext) {
          return(getParamFromField(getData(getEpgResult(datasource,pageContext)),name));
    }
    public Vector getVParamFromField(Map fieldData, String name) {
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

    public String getSubString(String string, int length) {
        if (null != string) {
            if (string.length() > length) {
                string = string.substring(0, length);
            }
            return string;
        } else {
            return "";
        }
    }

   
    public void replacePara(PageContext pageContext, String paramName, String paramValue) {
        if (pageContext == null || paramName == null)
            return;
        Vector paramNames = new Vector();
        paramNames.add(paramName);
        Vector paramValues = new Vector();
        paramValues.add(paramValue);
        replaceParas(pageContext, paramNames, paramValues);
    }

    
    public void replaceParas(PageContext pageContext, Vector paramNames, Vector paramValues) {
        if (pageContext == null || paramNames == null)
            return;
        try {
            PageController pc = (PageController) pageContext.getAttribute(EpgConstants.CONTROLLER);
            if (pc == null) {
                pc = new PageController();
                pageContext.setAttribute(EpgConstants.CONTROLLER, pc);
            }
            Map paras = null;
            paras = pc.getParameter();
            if (paras == null)
                paras = new HashMap();
            String paramName = "";
            String paramValue = "";
            for (int i = 0; i < paramNames.size(); i++) {
                paramName = (String) paramNames.get(i);
                if (paramName == null)
                    continue;
                paramValue = (String) paramValues.get(i);
                paras.remove(paramName);
                paras.put(paramName, paramValue);
            }
            pc.setParameter(paras);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getSubString1(String string, int length) {
        if (null != string) {
            if (string.length() > length) {
                string = string.substring(0, length) + "...";
            }
            return string;
        } else {
            return "";
        }
    }
	
	 public String getPath(String uri) {


        String path = "";


        int begin = 0;


        int end = uri.lastIndexOf('/');


        if (end > 0) {


            path = uri.substring(begin, end + 1) + path;


        }


        return path;


    }

	public String getCurrency(String price)
	{
		if(Integer.parseInt(price)%100<10)
	    {
			
          price = String.valueOf(Integer.parseInt(price)/100)+".0"+String.valueOf(Integer.parseInt(price)%100);
		}
		else{
			price = String.valueOf(Integer.parseInt(price)/100)+"."+String.valueOf(Integer.parseInt(price)%100);
		}
		return price;
	}
	
	 public String getChannelNameInfo(String channelid) {
        String channelName = "";
        //int channelMIixNo=-1;
        try {
            Hashtable channelhash = XbaseCacheManage.getSingleton().
                    getcmschannelhash();
            Enumeration channelkeys2 = channelhash.keys();
            while (channelkeys2.hasMoreElements()) {
                Object currentKey = channelkeys2.nextElement();
                ChannelInfo channelinfo = (ChannelInfo) channelhash.get(
                        currentKey);
                if (channelinfo.getChannelId().equals(channelid)) {
                    channelName = channelinfo.getChannelName();
                    break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
        return channelName;
    }

	public String format(String price) {
        int priceInt = Integer.parseInt(price);
        String fmPrice = "0";
        if (priceInt > 99) {
            fmPrice = String.valueOf(priceInt / 100);
        }

        int fraction = priceInt % 100;
        if (fraction == 0) return fmPrice;

        if (fraction % 10 == 0) {
            fmPrice += "." + String.valueOf(fraction / 10);
        } else if (fraction < 10) {
            fmPrice += ".0" + String.valueOf(fraction);
        } else {
            fmPrice += "." + String.valueOf(fraction);
        }
        return fmPrice;
    }

	public String escapingQuotes(String str) {	
		if (str != null && !str.equals("")) {
			str = str.replaceAll("\\\\", "\\\\\\\\");
			str = str.replaceAll("\"", "\\\\\"");
			str = str.replaceAll("'", "\\\\\'");
			str = str.replaceAll("<", "&lt");
			str = str.replaceAll(">", "&gt");
		}
		return str;
	}
%> 