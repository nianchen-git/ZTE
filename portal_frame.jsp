<%@page contentType="text/html; charset=GBK" %>
<%@ page import="com.zte.iptv.epg.util.PortalUtils" %>
<%@ page import="com.zte.iptv.epg.util.EpgUtils" %>
<%@ page import="com.zte.iptv.platformepg.content.PlatformepgCacheManager" %>
<%@ page import="com.zte.iptv.epg.account.UserInfo" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnDataSource" %>
<%@ page import="com.zte.iptv.epg.web.ColumnValueIn" %>
<%@ page import="com.zte.iptv.newepg.datasource.EpgResult" %>
<%@ page import="com.zte.iptv.epg.content.ColumnInfo" %>
<%@page import="com.zte.iptv.volcano.epg.account.User" %>
<%@ page import="com.zte.iptv.volcano.data.QueryResult" %>
<%@ page import="com.zte.iptv.volcano.epg.constants.NameConstants" %>
<%@ page import="java.util.*" %>
<%@ page import="com.zte.iptv.newepg.datasource.ColumnOneDataSource" %>
<%@ include file="inc/getFitString.jsp" %>
<%@ taglib uri="/WEB-INF/epgtag.tld" prefix="epg" %>
<meta http-equiv="pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"/>
<meta http-equiv="expires" content="Wed,26 Feb 1997 08:21:57 GMT"/>
<meta name="page-view-size" content="1280*720"/>

<epg:PageController name="portal_frame.jsp"/>
<%!

    public String loadConvert(char[] in, int off, int len, char[] convtBuf) {
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
                if (aChar == 'u') {
                    // Read the xxxx
                    int value = 0;
                    for (int i = 0; i < 4; i++) {
                        aChar = in[off++];
                        switch (aChar) {
                            case '0':
                            case '1':
                            case '2':
                            case '3':
                            case '4':
                            case '5':
                            case '6':
                            case '7':
                            case '8':
                            case '9':
                                value = (value << 4) + aChar - '0';
                                break;
                            case 'a':
                            case 'b':
                            case 'c':
                            case 'd':
                            case 'e':
                            case 'f':
                                value = (value << 4) + 10 + aChar - 'a';
                                break;
                            case 'A':
                            case 'B':
                            case 'C':
                            case 'D':
                            case 'E':
                            case 'F':
                                value = (value << 4) + 10 + aChar - 'A';
                                break;
                            default:
                                throw new IllegalArgumentException(
                                        "Malformed \\uxxxx encoding.");
                        }
                    }
                    out[outLen++] = (char) value;
                } else {
                    if (aChar == 't') aChar = '\t';
                    else if (aChar == 'r') aChar = '\r';
                    else if (aChar == 'n') aChar = '\n';
                    else if (aChar == 'f') aChar = '\f';
                    out[outLen++] = aChar;
                }
            } else {
                out[outLen++] = (char) aChar;
            }
        }
        return new String(out, 0, outLen);
    }

    String getChinese(HashMap param, String name) {
        String value = (String) param.get(name);
        if (value != null) {
            value = loadConvert(value.toCharArray(), 0, value.length(), new char[0]);
        }
        return value;
    }

    String toXml(String key, String value) {
        String rt = "<" + key + ">" + value + "</" + key + ">";
        return rt;
    }

    String replaceUrl(HttpServletRequest req, String url, HashMap param) throws Exception {
        UserInfo userInfo = (UserInfo) req.getSession().getAttribute(EpgConstants.USERINFO);
        String tempUrl = url;
        if (tempUrl == null) {
            return "";
        }

        tempUrl = tempUrl.replaceAll("\\{userid\\}", userInfo.getUserId());
        if (url.indexOf("EPG_INFO") > -1) {
            String timeBasePath = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath() + "/";
            String returnUrl = timeBasePath + userInfo.getUserModel() + "/thirdback.jsp";

            String epginfo = "";
            epginfo += toXml("server_ip", req.getServerName());
            epginfo += toXml("group_name", String.valueOf(param.get("EPG_INFO_group_name")));
            epginfo += toXml("group_path", String.valueOf(param.get("EPG_INFO_group_path")));
            epginfo += toXml("oss_user_id", userInfo.getUserId());
            epginfo += toXml("page_url", returnUrl);
            epginfo += toXml("partner", "ZTE");
            epginfo = java.net.URLEncoder.encode(epginfo, "UTF-8");
            url = url.replaceAll("EPG_INFO", epginfo);
        }
        return url;
    }

%>
<html>
<head>
    <title>portal</title>
</head>
<%!
    public String getColumnList(UserInfo userinfo, String columnid, HashMap param) {
        StringBuffer sb = new StringBuffer("[");
        try {
            String isFathercolumn = String.valueOf(param.get("isFathercolumn"));
            String Fathercolumn = String.valueOf(param.get("Fathercolumn"));
            List vColumnData = new ArrayList();
            List tempList = new ArrayList();
            if (isFathercolumn != null && Fathercolumn != null && isFathercolumn.equals("1")) {//读取N个一级栏目分支
                String[] columnlist = Fathercolumn.split(",");
                int columnLength = columnlist.length;
                for (int i = 0; i < columnLength; i++) {
                    ColumnOneDataSource vodDs = new ColumnOneDataSource();
                    ColumnValueIn valueIn = (ColumnValueIn) vodDs.getValueIn();
                    valueIn.setUserInfo(userinfo);
                    valueIn.setColumnId(columnlist[i]);
                    EpgResult result = vodDs.getData();
                    tempList = result.getDataAsVector();
                    if (tempList != null) {
                        vColumnData.addAll(tempList);
                    }
                }
            } else {
                ColumnDataSource columnDs = new ColumnDataSource();
                ColumnValueIn valueIn = (ColumnValueIn) columnDs.getValueIn();
                valueIn.setUserInfo(userinfo);
                valueIn.setColumnId(columnid);
                EpgResult result = columnDs.getData();
                vColumnData = (Vector) result.getData();
            }
            String oColumnid = "";
            String oColumnName = "";
            String columnposter = "";
            int length = vColumnData.size();
            ColumnInfo columnInfo = null;
            for (int i = 0; i < length; i++) {
                if (i > 0) {
                    sb.append(",");
                }

                columnInfo = (ColumnInfo) vColumnData.get(i);
                columnposter = columnInfo.getNormalPoster();
                oColumnid = columnInfo.getColumnId();
                oColumnName = columnInfo.getColumnName();

                sb.append("{columnid:\"" + oColumnid + "\",");
                sb.append("columnposter:\"" + columnposter + "\",");
                sb.append("columnname:\"" + oColumnName + "\"}");
            }


        } catch (Exception e) {
            System.out.println("+++++++++栏目列表数据源出错++++");
        }
        sb.append("]");
        return sb.toString();
    }

    /**
     * 根据channelcode查询用户混排号、全局混排号
     * @param pageContext 页面上下文
     * @param channelCode 频道code
     * @return List  返回结果
     */
    public static Map<String, String> getChannelMixno(PageContext pageContext, String channelCode) {
        Map<String, String> result = new HashMap<String, String>();
        User user = (User) pageContext.getAttribute("user", PageContext.SESSION_SCOPE);
        String selectExp = "usermixno,mixno";
        String conditionExp = new StringBuilder().append(" channelcode = '")
                .append(channelCode)
                .append("'")
                .toString();
        QueryResult queryResult = user.query(NameConstants.VIEWNAME_USER_CHANNEL, selectExp, conditionExp, "", 1, 1);
        if (queryResult != null) {
            List resultList = queryResult.getResultList();
            if (resultList.size() > 0) {
                result = (Map) resultList.get(0);
            }
        }
        return result;
    }
%>

<%
    System.out.println("YUAN--------------------------portal_frame-----1");
    session.setAttribute("pushportal", "0");
    String path = com.zte.iptv.epg.util.PortalUtils.getPath(request.getRequestURI(), request.getContextPath());
    HashMap param = PortalUtils.getParams(path, "GBK");
    String TIME_COUNT = String.valueOf(param.get("TIME_COUNT"));
    String INTERVAL = String.valueOf(param.get("INTERVAL"));
    String channelColumnid = String.valueOf(param.get("column00"));
    String vodColumnid = String.valueOf(param.get("column01"));
    String isCugConfig = String.valueOf(param.get("isCugConfig"));

    String name0 = getChinese(param, "app_0_name");
    String name1 = getChinese(param, "app_1_name");
    String name2 = getChinese(param, "app_2_name");
    String name3 = getChinese(param, "app_3_name");

    String lastfocus = request.getParameter("lastfocus");
    System.out.println("YUAN------fanhui de bushi lastfocus====" + lastfocus);
    int bottomMenuIndex = 0;
    int leftMenuIndex = 0;

    int startIndex = 0;
    int endIndex = 7;
    int rem_flag = 0;
    int destpage = 1;
    if (lastfocus != null && !"".equals(lastfocus)) {
        try {
            String[] indexs = lastfocus.split("_");
            if (indexs != null && indexs.length > 0) {
                bottomMenuIndex = Integer.parseInt(indexs[0]);
                leftMenuIndex = Integer.parseInt(indexs[1]);
                if (indexs.length > 2) {
                    startIndex = Integer.parseInt(indexs[2]);
                    endIndex = Integer.parseInt(indexs[3]);
                    if (indexs.length > 4) {
                        rem_flag = Integer.parseInt(indexs[4]);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println("fanhui de bushi bottomMenuIndex");
        }
    }
    System.out.println("YUAN--------------------------portal_frame----2");
    //将开机频道混排号取出来

    UserInfo userInfo = (UserInfo) pageContext.getSession().getAttribute(EpgConstants.USERINFO);
    String channelid = userInfo.getCrtChannelID();
    int tempno = -1;
    Map channelInfo = getChannelMixno(pageContext, channelid);
    if (channelInfo != null) {
        tempno = Integer.parseInt(String.valueOf(channelInfo.get("usermixno")));
    }

    //专题子栏目列表数据源
    String column02 = (String) param.get("column02");
    String columnStr = getColumnList(userInfo, column02, param);

    UserInfo timeUserInfo = (UserInfo) request.getSession().getAttribute(EpgConstants.USERINFO);
    String timePath1 = request.getContextPath();
    String timeBasePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + timePath1 + "/";
    String timeFrameUrl = timeBasePath + timeUserInfo.getUserModel();


    String fromplay = request.getParameter("fromplay");
    if (fromplay == null) {
        fromplay = "";
    }
    System.out.println("YUAN--------------------------portal_frame----4");
    String userid_1 = userInfo.getUserId();
    String userToken_1 = userInfo.getUserToken();
    String TokenExpireTime_1 = userInfo.getUserTokenExpiretime();
    String areacode_1 = userInfo.getAreaNo();
    String Groupid_1 = userInfo.getUserGrpId();
    String epginfo = "<oss_user_id>" + userid_1 + "</oss_user_id><userToken>" + userToken_1 + "</userToken><TokenExpireTime>" + TokenExpireTime_1 + "</TokenExpireTime><areacode>" + areacode_1 + "</areacode><Groupid>" + Groupid_1 + "</Groupid><partener>ZTE</partener>";
    epginfo = java.net.URLEncoder.encode(epginfo, "utf-8");
    System.out.println("YUAN--------------------------portal_frame----5");
%>

<body bgcolor="transparent">
<%--4K提示--%>
<div id="alert_text" style="position:absolute; left: 424px; top: 242px; width: 432px; height:234px; visibility:hidden;">
    <img src="images/4kjump.png" width="432" height="234"/></div>
<script type="text/javascript" src="js/contentloader.js"></script>
<script language="javascript" type="">
    var del_tvod_pro_num = [3, 5, 6, 8, 13, 16, 19, 20, 23, 25, 27, 28, 31, 32, 33, 34, 49, 54, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 103, 105, 106, 108, 118, 119, 120, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 322, 323, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600];//删除频道的频道号xiaojun,379,30,35,39


    var tem_tvodList = [];//xiaojun
    var k = 0;//xiaojun
    function update_data()//更新直播频道由+、-控制的数组的数据xiaojun
    {
        tem_tvodList = top.channelList;
        top.channelList = [];
        for (var i = 0; i < tem_tvodList.length; i++) {
            var isDel = 0;
            for (var j = 0; j < del_tvod_pro_num.length; j++) {
                if (parseInt(tem_tvodList[i], 10) == del_tvod_pro_num[j]) {
                    isDel = 1;
                    break;
                }
            }
            if (isDel == 0) {
                top.channelList[k] = tem_tvodList[i];
                k++;
            }
        }//用来过滤所有的频道
        update_data_all();
    }

    function update_data_all()//更新直播频道由+、-控制的数组的数据xiaojun
    {
        tem_tvodList = [];
        tem_tvodList = top.allChannelList;
        top.allChannelList = [];
        k = 0;
        for (var i = 0; i < tem_tvodList.length; i++) {
            var isDel = 0;
            for (var j = 0; j < del_tvod_pro_num.length; j++) {
                if (parseInt(tem_tvodList[i], 10) == del_tvod_pro_num[j]) {
                    isDel = 1;
                    break;
                }
            }
            if (isDel == 0) {
                top.allChannelList[k] = tem_tvodList[i];
                k++;
            }
        }//用来过滤所有的频道
    }

    update_data();


    var stbTypezte = Authentication.CTCGetConfig("STBType");
    if (stbTypezte == null || stbTypezte == undefined || typeof stbTypezte == "undefined") {
        stbTypezte = Authentication.CUGetConfig("STBType");
    }
    if (navigator.userAgent.indexOf('Ranger') != -1) {
        var fromthirdback = "0";
        fromthirdback = iPanel.getGlobalVar("fromthirdback");
        if (fromthirdback == "1") {
            var curMixno = iPanel.ioctlRead("lastchannelid");
            top.jsRedirectChannel(curMixno);
            iPanel.setGlobalVar("fromthirdback", "0");//设置全局变量fromthirdback=0
            top.setTimeout(function () {
                top.mainWin.document.location = '<%=timeFrameUrl+"/portal.jsp?fromplay=1"%>';
                top.showOSD(2, 0, 25);
                top.setBwAlpha(0);
            }, 2000);
        }
    }
    else {
        var fromthirdback = "0";
        if (isZTEBW == true) {
            fromthirdback = ztebw.getAttribute("fromthirdback");
        }
        if (fromthirdback == "1") {
            var curMixno = ztebw.getAttribute("curMixno");
            if (fromthirdback == "1") {
                ztebw.setAttribute("fromthirdback", '0');
            } else {
                curMixno = top.channelInfo.currentChannel;
                if ((!curMixno && curMixno != 0) || curMixno < 0 || curMixno == "") {
                    curMixno = top.channelInfo.lastChannel;
                }
                if (curMixno == -1) {
                    curMixno = ztebw.getAttribute("curMixno");
                }
            }
            if (stbTypezte == "B860A") {
                LastChannelNo = Authentication.CUGetConfig("LastChannelNo");
            }
            if (LastChannelNo > -1) {
                if (LastChannelNo == curMixno) {
                    curMixno = curMixno;
                } else {
                    curMixno = LastChannelNo;
                }
            }
            top.jsRedirectChannel(curMixno);
            top.setTimeout(function () {
                top.mainWin.document.location = '<%=timeFrameUrl+"/portal.jsp?fromplay=1"%>';
                top.showOSD(2, 0, 25);
                top.setBwAlpha(0);
            }, 2000);
        }
    }
</script>
<%@ include file="inc/chan_addjsset.jsp" %>

<div id="marquee1"
     style="position:absolute; width:1280px; height:55px; top:0px; left:0px; font-size:28px;color:#FFFFFF;"><img src="images/scroll_bg.png" width="1280" height="55"></div>
 <div id="marquee"
     style="position:absolute; width:1280px; height:50px; top:11px; left:3px; font-size:28px;color:#FFFFFF;">
    <marquee direction="left" behavior="scroll" scrollamount="6" loop="5">
        &nbsp;&nbsp;&nbsp;&nbsp;为防控新型冠状病毒感染的肺炎和流感，建议市民少聚会，少旅行，不去或少去人员密集场所，乘坐公交地铁航班等全程戴口罩，室内常通风，勤洗手；如有不适，及时就诊，如发热，速到发热门诊就诊。&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </marquee>
</div>

<%--左侧的大的div--%>
<div id="left_menua" style="position:absolute; width:227px; height:483px; left:80px; top:113px; z-index:-100;">
    <div style="background:url('images/portal/bg_portal_left.png') no-repeat; position:absolute; width:227px; height:483px; left:0px; top:0px; font-size:22px;color:#FFFFFF; line-height:51px;"
         align="center">

        <div id="logo_jing" class="" width="170" height="41" style="position:absolute;top:14px;left:16px;"><img
                src="images/logo13.png" width="190" height="49"/></div>
        <div id="logo_dong" class="" width="99" height="41" style="position:absolute;top:16px;left:102px;"><img
                src="images/logo14.gif" width="104" height="44"/></div>
        <div id='up'
             style="background:url('images/vod/btv_up.png') no-repeat; position:absolute; width:24px; height:14px; left:95px; top:73px; ">
        </div>
        <div id='down'
             style="background:url('images/vod/btv_down.png')no-repeat; position:absolute; width:24px; height:14px; left:95px; top:456px; ">
        </div>

        <%--春节换肤  推荐位左侧焦点--%>
        <div id="left_focus_img"
             style="position:absolute; width:205px; height:51px; left:6px; top:89px;visibility:hidden ">

            <%--<img id="left_focus_img11" height="51" width="210" src="images/portal/focus2.png"/>--%>
            <img id="left_focus_img11" height="51" width="210" src="images/portal/focus.png"/>
        </div>
        <div id="chanel_info" style="position:absolute;width:197px; height:51px; left:16px; top:90px; display:none">
            限时免费频道
        </div>
        <%
            for (int i = 0; i < 7; i++) {
                int topIndex = 90 + 51 * i;
        %>
        <div id="left_menu_<%=i%>"
             style="background:url('images/portal/line2.png') no-repeat bottom; position:absolute; width:197px; height:51px; left:16px; top:<%=topIndex%>px;">

        </div>
        <%
            }
        %>

    </div>
</div>

<div style="position:absolute; width:262px; height:471px; left:1016px; top:108px"><img
        src="images/recommend/recommend_bg.png" width="262" height="471"></div>
<div id="rec_focus" style="position:absolute;width:194px; height:44px; left:1062px; top:319px; visibility:hidden"><img
        src="images/recommend/recommend_focus.png" width="194" height="44"></div>
<div id="recommend_0"
     style="position:absolute; width:121px; height:30px; left:1133px; top:141px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_1"
     style="position:absolute; width:146px; height:30px; left:1108px; top:188px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_2"
     style="position:absolute; width:165px; height:30px; left:1088px; top:236px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_3"
     style="position:absolute; width:182px; height:30px; left:1076px; top:284px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_4"
     style="position:absolute; width:185px; height:30px; left:1068px; top:332px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_5"
     style="position:absolute; width:177px; height:30px; left:1076px; top:381px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_6"
     style="position:absolute; width:166px; height:30px; left:1088px; top:426px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_7"
     style="position:absolute; width:145px; height:30px; left:1108px; top:473px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="recommend_8"
     style="position:absolute; width:122px; height:30px; left:1133px; top:521px; font-size:22px;color:#FFFFFF;"
     align="left"></div>
<div id="rec_img_bg" style="position:absolute;width:289px; height:166px; left:764px; top:263px;visibility:hidden;"><img
        src="images/recommend/recommend_img.png" width="289" height="166"></div>
<div id="rec_img" style="position:absolute;width:205px; height:114px; left:801px; top:290px;visibility:hidden;"><img
        id="recommend_img" src="" width="206" height="115"></div>
<div id="logo" style="display: none; position:absolute; width: 120px; height: 25px; left: 1110px; top: 90px; font-size: 22px; color: yellow; border: 2px solid red; text-align: center "></div>
<%--下方菜单展示--%>
<div style="position:absolute; width:1279px; height:183px; left:0px; top:537px; ">
    <img src="images/portal/bg_portal_down.png" width="1279" height="183"/>
</div>
<div style="position:absolute; width:1280px; height:200px; left:0px; top:485px; font-size:28px;" align="center">
    <div style="left:-590px; top: 100px; width: 1px; height: 1px; position: absolute">
        <a href="javascript:dotest();">
            <img alt="" src="images/btn_trans.gif" width="30" height="30" border="0"/>
        </a>
    </div>

    <div id="bottom_menu_focus0"
         style=" position:absolute; width:116px; height:116px; left:196px; top:59px; visibility:hidden">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus1"
         style=" position:absolute; width:116px; height:116px; left:308px; top:36px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus2"
         style=" position:absolute; width:116px; height:116px; left:420px; top:16px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus3"
         style=" position:absolute; width:116px; height:116px; left:534px; top:4px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus4"
         style=" position:absolute; width:116px; height:116px; left:642px; top:8px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus5"
         style=" position:absolute; width:116px; height:116px; left:759px; top:16px; visibility:hidden">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus6"
         style=" position:absolute; width:116px; height:116px; left:867px; top:38px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>


    <div id="bottom_menu_focus7"
         style=" position:absolute; width:116px; height:116px; left:979px; top:62px;visibility:hidden ">
        <img width="116" height="116" src="images/portal/focus_bottom.png"/>
    </div>

    <%--我的tv--%>

    <div id="buttom_0"
         style="background:url('images/portal/icons/myTV.png'); position:absolute; width:100px; height:100px; left:204px; top:80px; ">
    </div>


    <div id="bottom_menu_text_0"
         style=" position:absolute; width:116px; height:30px; left:204px; top:175px; color:#ffffff;">
        看吧
    </div>

    <%--回看--%>

    <div id="buttom_1"
         style="background:url('images/portal/icons/tvod.png'); position:absolute; width:100px; height:100px; left:316px; top:57px;">
    </div>


    <div id="bottom_menu_text_1"
         style=" position:absolute; width:116px; height:30px; left:308px; top:160px; color:#ffffff;">
        回看
    </div>

    <%--点播--%>

    <div id="buttom_2"
         style="background:url('images/portal/icons/vod.png'); position:absolute; width:100px; height:100px; left:428px; top:37px; ">
    </div>


    <div id="bottom_menu_text_2"
         style=" position:absolute; width:116px; height:30px; left:420px; top:150px; color:#ffffff;">
        点播

    </div>
    <%--频道--%>

    <div id="buttom_3"
         style="background:url('images/portal/icons/channel.png'); position:absolute; width:100px; height:100px; left:542px; top:24px; ">
    </div>


    <div id="bottom_menu_text_3"
         style=" position:absolute; width:116px; height:30px; left:534px; top:140px; color:#ffffff;">
        直播
    </div>

    <%--专题--%>

    <div id="buttom_4"
         style="background:url('<%=getChinese(param,"app_0_img")%>'); position:absolute; width:100px; height:100px; left:650px; top:27px; ">
    </div>


    <div id="bottom_menu_text_4"
         style=" position:absolute; width:116px; height:30px; left:642px; top:140px; color:#ffffff;">
        <%=name0%>
    </div>

    <%--应用--%>

    <div id="buttom_5"
         style="background:url('<%=getChinese(param,"app_1_img")%>'); position:absolute; width:100px; height:100px; left:767px; top:37px; ">
    </div>


    <div id="bottom_menu_text_5"
         style=" position:absolute; width:116px; height:30px; left:759px; top:150px; color:#ffffff;">
        <%=name1%>
    </div>

    <%--社区--%>

    <div id="buttom_6"
         style="background:url('<%=getChinese(param,"app_2_img")%>'); position:absolute; width:100px; height:100px; left:875px; top:55px; ">
    </div>


    <div id="bottom_menu_text_6"
         style=" position:absolute; width:116px; height:30px; left:867px; top:158px; color:#ffffff;">
        <%=name2%>
    </div>

    <%--生活--%>

    <div id="buttom_7"
         style="background:url('<%=getChinese(param,"app_3_img")%>'); position:absolute; width:100px; height:100px; left:987px; top:87px; ">
    </div>


    <div id="bottom_menu_text_7"
         style="position:absolute; width:116px; height:30px; left:979px; top:175px; color:#ffffff;">
        <%=name3%>
    </div>

</div>


<div style="left:460px; top:300px;width:568px;height:215px; position:absolute;z-index:2000">
    <div id="msg" style="left:0px; top:0px;width:394px;height:215px; position:absolute;visibility:hidden;">
        <div style="left:0px;top:0px;width:394px;height:200px;position:absolute;">
            <img src="images/vod/btv10-2-bg01.png" alt="" width="394" height="215" border="0"/>
        </div>
        <div id="text"
             style="left:0px;top:70px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;"
             align="center">
        </div>


        <div id="closeMsg"
             style="left:0px;top:160px;width:394px;height:34px;z-index:6;font-size:20px;color:#FFFFFF;position:absolute;visibility:hidden;"
             align="center">
            2秒自动关闭
        </div>
    </div>
</div>


<script language="javascript" type="">

    var l1 = new Date().getTime();

    var backurlparam = "<%=timeFrameUrl%>/portal.jsp";
    var userid = "<%=userInfo.getUserId()%>";
    var bottomMenuIndex = <%=bottomMenuIndex%>;
    var leftMenuIndex = <%=leftMenuIndex%>;
    var recommend_indexa = <%=leftMenuIndex%>;
    var destpage = <%=destpage%>;
    var channelColumnid = "<%=channelColumnid%>";
    var vodColumnid = "<%=vodColumnid%>";
    var tempno = "<%=tempno%>";
    var startIndex =<%=startIndex%>;
    var endIndex =<%=endIndex%>;
    var channelname1 = '导航列表';
    var tvodchannelname = '回看导航';
    var favoriteUrl = "";
    var tvguideUrl = "";
    var orderUrl = "selfcare_record_ppv.jsp";
    var now_channel_num = top.channelInfo.currentChannel;
    var returnurl = "<%=timeFrameUrl%>/thirdback.jsp";
    returnurl = encodeURIComponent(returnurl);


    var gour0 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&page=portal&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl;//点击进入看吧

    var gour1 = 'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=NewYears&epgRecommendCntv=1';  //2020新春专区

    var gour2 = "vod_portal_pre.jsp?columnid=200217&topicindex=01&columnname=防疫专区";

    var gour3 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&ReturnURL=' + returnurl + '&epgstbType=' + stbType + '&page=column&columnName=pureEnjoymenyVIP&recommend_flag=1'; //VIP首页

    var gour4 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=special_topic&special_topic_id=3&recommend_flag=1';//真·劲爆4K

    //专题
    //var gour4 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=8&recommend_flag=1';


    //专区
    // var gour1 = 'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=70years&epgRecommendCntv=1';

    //活动
    //var gour2 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=13&recommend_flag=1'; //醇享VIP送送送

	//var gour5 = 'http://ggly.iptv.bbn.com.cn:8484/ggly-epg/index_mxlyActivity.jsp?epg_info=<%=epginfo%>';//抓熊大赢好礼
    //var gour5 = 'http://ggly.iptv.bbn.com.cn:8484/ggly-epg/index_activity.jsp?epg_info=<%=epginfo%>';//最强狙击手

    // var gour2 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=special_topic&special_topic_id=10&recommend_flag=1';


    /*var gour5 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&page=portal&channel_num=' + now_channel_num + '&vender=zte&group=epg20&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl;//看吧功能组

    var gour6 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&page=portal&channel_num=' + now_channel_num + '&vender=zte&group=epg10&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl;//看吧审核组*/



   //var gour5 = 'http://ggly.iptv.bbn.com.cn:8484/ggly-epg/index_activity.jsp?epg_info=<%=epginfo%>';//我的世界海底寻宝



    /*var gour2 = "vod_series_list.jsp?strADid=&strADid2=true&columnid=2010&programid=0000000030140000743697&programtype=1&contentid=00000020140005238098&columnpath=点播>看吧>回看&programname=&leefocus=8_";//北京卫视2019春节联欢晚会*/

    /*var gour3 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num +
        '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl +
        '&page=special_topic&special_topic_id=10&recommend_flag=1';//新春七折礼包*/

    /*var gour6 = 'http://61.149.51.19:81/month_hall_two/index.jsp?epg_info=<%=epginfo%>';//突出重围赢大奖*/


    //var gour1 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num +'&vender=zte&group=YEWUZU30&ReturnURL=' + returnurl + '&epgstbType=' + stbType +'&page=column&columnName=E-sportsWorld&recommend_flag=1';  //电竞世界


    //var gour10 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=special_topic&special_topic_id=8&recommend_flag=1';//最新大片
   /* var gour3 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&page=portal&channel_num=' + now_channel_num + '&vender=zte&group=epg10&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl;
    var gour4 = "http://ktly.iptv.bbn.com.cn:8400/hw_BaoYue/Default.aspx?epg_info=<%=epginfo%>";//动漫乐斗

    var gour7 = (isZTEBW == true) ? "vod_portal_pre.jsp?columnid=0W&topicindex=00&columnname=纪实频道" : "vod_portal.jsp?columnid=0W&topicindex=00&columnname=纪实频道";
    var gour11 = 'http://ggly.iptv.bbn.com.cn:8484/ggly-epg/index_activity.jsp?epg_info=<%=epginfo%>';//汪汪队爱自拍
    var gour2 = 'channel_play.jsp?mixno=379';//跳频道
    var gour12 = "http://kalaok.iptv.bbn.com.cn:9191/bj-cu-sd-zte-20/goIndexYl2.jsp?epg_info=<%=epginfo%>";*/
    //var gour2='http://kalaok.iptv.bbn.com.cn:9191/bj-cu-sd-zte-20/goIndex.jsp?epg_info=EPG_INFO';
    //var gour2 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&page=see_zongyi&channel_num='+now_channel_num+'&vender=zte&group=epg10&ReturnURL='+returnurl;
    //var gour2 = 'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=tiaoshi1&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=theme&epgRecommendCntv=1';
    //var gour2 = 'http://210.13.3.137/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=aishangkb&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=cntvColumn&cntvColumnName=theme&epgRecommendCntv=1';
    //var gour3 = //'http://210.13.3.184/epg_index.php?UserID='+userid+'&page=portal&channel_num='+now_channel_num+'&vender=zte&group=epg20&epgstbType='+stbTypezte+'&ReturnURL='+returnurl;
    //var gourla = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=epg10&page=see_child&ReturnURL='+returnurl;
    //var gour4 ="http://mcsj.iptv.bbn.com.cn:8484/mengchong-epg/index.jsp?epg_info=<%=epginfo%>";//萌宠世界
    //var gour4 ="http://czly.iptv.bbn.com.cn:8088/education/tv/login.action?entrance=1&order=1&epg_info=<%=epginfo%>";//成长乐园
    //var gour4 = "http://mcsj.iptv.bbn.com.cn:9191/mengchong-zte/index_game_tjw.jsp?epg_info=<%=epginfo%>";//我们的游戏世界
    /*var returnurlyb;
    if(returnurl.indexOf("?")!=-1){
    returnurlyb=returnurl+'&yb_flag=1';
    }else{returnurlyb=returnurl+'?yb_flag=1';}
    var gour5 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&page=yuebing&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+returnurlyb;*/
    //var gour5 = "zhuanti_kuanianfulipaisong.jsp";
    //var gour5 = "zhuanti_4kcs.jsp";-----看吧4k
    //var gour6 = "http://mcsj.iptv.bbn.com.cn:9191/mengchong-zte/index_activity_tjw.jsp?epg_info=<%=epginfo%>";
    // var gour8 = "http://mcsj.iptv.bbn.com.cn:9191/mengchong-zte/index.jsp?epg_info=<%=epginfo%>";
    //var gour9 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&ReturnURL=' + returnurl + '&epgstbType=' + stbType + '&page=column&columnName=qie&recommend_flag=1';//企鹅TV-----专区
    //var gour9 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl +'&page=special_list&special_cat_id=manguo';//跳专题二级页
    //var gour10 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=special_topic&special_topic_id=8&recommend_flag=1';//寂静之地----最新大片
    //var gour10 = 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=column&columnName=shaoer&recommend_flag=1';
    //var gour11 = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=special_topic&special_topic_id=5&recommend_flag=1';//拼手气，拿权益----专题DOGTV一周年免费看special_topic_id=4
    //var gour11='http://xfjst.iptv.bbn.com.cn:8484/health-epg-v2/index_activity.jsp?epg_info=<%=epginfo%>';//海洋漂流瓶活动
    //var gour2 = 'http://bbbs.iptv.bbn.com.cn/client/index_zxj.jsp?action=login&epg_info=<%=epginfo%> ';//捉小鸡,送大礼
    //var gour9 = 'channel_play.jsp?mixno=001';//中阿合作论坛直播
    //var gour2 = 'http://210.13.3.137/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=aishangkb&epgstbType=' + stbTypezte + '&ReturnURL=' + returnurl + '&page=cntvColumn&cntvColumnName=worldcup&epgRecommendCntv=1';
    //var gour2 = 'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=asiangames&epgRecommendCntv=1';//2018亚运会---爱上
    //var gour8='http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=worldcup&epgRecommendCntv=1',//5.2018俄罗斯世界杯

    if(backurlparam.indexOf("frame99") > -1){
        document.getElementById("logo").style.display = "block";
        document.getElementById("logo").innerHTML = "中兴上线组";
    }else if(backurlparam.indexOf("frame105") > -1){
        document.getElementById("logo").style.display = "block";
        document.getElementById("logo").innerHTML = "中兴开发组";
    }else if(backurlparam.indexOf("frame112") > -1){
        document.getElementById("logo").style.display = "block";
        document.getElementById("logo").innerHTML = "中兴功能组";
    }else if(backurlparam.indexOf("frame101") > -1){
        document.getElementById("logo").style.display = "block";
        document.getElementById("logo").innerHTML = "中兴业务组";
    }

    if (isZTEBW == true) {
        favoriteUrl = "vod_favorite_pre.jsp";
        tvguideUrl = "channel_pre.jsp";
    } else {
        favoriteUrl = "vod_favorite.jsp";
        tvguideUrl = "channel.jsp";
    }

    var isCugConfig = "<%=isCugConfig%>";

    var setUrl = "setting.jsp";
    if (isCugConfig == "1" || isCugConfig == 1) {
        setUrl = "setting_cu.jsp";
    }

    var currentChannel = top.channelInfo.currentChannel;
    //社区相关
    var commarr = [];
    <%
      int i=0;
      while(param.get("app_2_"+i+"_name")!=null){
    %>
    commarr[commarr.length] = {
        invalid: '<%=String.valueOf(param.get("app_2_"+i+"_invalid"))%>',
        columnname: '<%=String.valueOf(param.get("app_2_"+i+"_name"))%>',
        cname: '<%=String.valueOf(param.get("app_2_"+i+"_name"))%>',
        curl: '<%=replaceUrl(request,String.valueOf(param.get("app_2_"+i+"_url")),param)%>',
        cimg: '<%=String.valueOf(param.get("app_2_"+i+"_img"))%>',
        gosd: '<%=String.valueOf(param.get("app_2_"+i+"_gosd"))%>'
    };
    <%
        i++;
    }
    %>

    //生活相关
    var lifeArr = [];
    <%
      i=0;
      while(param.get("app_3_"+i+"_name")!=null){
    %>
    lifeArr[lifeArr.length] = {
        invalid: '<%=String.valueOf(param.get("app_3_"+i+"_invalid"))%>',
        columnname: '<%=String.valueOf(param.get("app_3_"+i+"_name"))%>',
        cname: '<%=String.valueOf(param.get("app_3_"+i+"_name"))%>',
        curl: '<%=replaceUrl(request,String.valueOf(param.get("app_3_"+i+"_url")),param)%>',
        cimg: '<%=String.valueOf(param.get("app_3_"+i+"_img"))%>',
        gosd: '<%=String.valueOf(param.get("app_3_"+i+"_gosd"))%>'
    };
    <%
        i++;
    }
    %>
    //应用
    var appArr = [];
    <%
      i=0;
      while(param.get("app_1_"+i+"_name")!=null){
    %>
    appArr[appArr.length] = {
        invalid: '<%=String.valueOf(param.get("app_1_"+i+"_invalid"))%>',
        columnname: '<%=String.valueOf(param.get("app_1_"+i+"_name"))%>',
        cname: '<%=String.valueOf(param.get("app_1_"+i+"_name"))%>',
        curl: '<%=replaceUrl(request,String.valueOf(param.get("app_1_"+i+"_url")),param)%>',
        cimg: '<%=String.valueOf(param.get("app_1_"+i+"_img"))%>',
        gosd: '<%=String.valueOf(param.get("app_1_"+i+"_gosd"))%>'
    };
    <%
        i++;
    }
    %>
    appArr[appArr.length] = {invalid: '', columnname: '我的收藏', cname: '我的收藏', curl: favoriteUrl, cimg: '', gosd: ''};
    appArr[appArr.length] = {invalid: '', columnname: '我的自服务', cname: '我的自服务', curl: orderUrl, cimg: '', gosd: ''};
    if (isReallyZTE != false) {
        appArr[appArr.length] = {invalid: '', columnname: '用户设置', cname: '用户设置', curl: setUrl, cimg: '', gosd: ''};
    }
    //首页推荐位第三方应用

    var portalArr = [];
    <%
      i=0;
      while(param.get("app_4_"+i+"_name")!=null){
    %>
    portalArr[portalArr.length] = {
        invalid: '<%=String.valueOf(param.get("app_4_"+i+"_invalid"))%>',
        columnname: '<%=String.valueOf(param.get("app_4_"+i+"_name"))%>',
        cname: '<%=String.valueOf(param.get("app_4_"+i+"_name"))%>',
        curl: '<%=replaceUrl(request,String.valueOf(param.get("app_4_"+i+"_url")),param)%>',
        cimg: '<%=String.valueOf(param.get("app_4_"+i+"_img"))%>',
        gosd: '<%=String.valueOf(param.get("app_4_"+i+"_gosd"))%>'
    };
    <%
        i++;
    }
    %>
    //看吧
    var mytvArr = [
        {tvname: '点击进入看吧', tvurl: gour0},
        {tvname: '2020新春专区', tvurl: gour1},
        {tvname: '疫情权威解读', tvurl: gour2},
        {tvname: 'VIP首页', tvurl: gour3},
        {tvname: '真·劲爆4K', tvurl: gour4}
    ];

    var SpecalColumnlist = <%=columnStr%>;
    <%

      for(int j=100; j>=0; j--){
      if(param.get("app_0_"+j+"_name")!=null){
    %>
    SpecalColumnlist[SpecalColumnlist.length] = {
        columnid: "0",
        columnname: "<%=String.valueOf(param.get("app_0_"+j+"_name"))%>",
        columnposter: "<%=replaceUrl(request,String.valueOf(param.get("app_0_"+j+"_url")),param)%>"
    };
    <%

      }
      }
    %>
    var specallength = SpecalColumnlist.length;
    var alsus = "该服务已经收藏";
    var sus = "收藏成功";

    var portalUrl = "<%=timeFrameUrl%>/portal.jsp";
    var thirdbackUrl = "<%=timeFrameUrl%>/thirdback.jsp";
</script>
<script type="text/javascript" src="js/portal.js"></script>
<script language="javascript" type="">

    <%@ include file="js/json.js" %>
    var l2 = new Date().getTime();
    //判断是否为华为盒子，如果是，则获取首页键处理权
    var ua = window.navigator.userAgent;

    if (ua.indexOf("Ranger/3.0.0") > -1) {

        keyEPGPortal(portalUrl);
    }
</script>

<%@ include file="inc/lastfocus.jsp" %>

</body>
</html>