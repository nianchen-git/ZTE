//Authentication.CTCSetConfig('SetEpgMode', '720P');
var $$ = {};

function $(id) {
    if (!$$[id]) {
        $$[id] = document.getElementById(id);
    }
    return $$[id];
}
top.jsSetControl("TelecomStandVersion","1");
var bottomMenuCount = 9;
var leftMenuCount = 7;
var upAction = false;
var downAction = false;
var pagecount = 1;
var columnArr = [];
var portal_third_arr = [];
portal_third_arr.push(portalArr[0]);
portal_third_arr.push(portalArr[1]);
portal_third_arr.push(portalArr[2]);
var length = 7;
var bottomMenuTimer;
var channelType = "column";
var curcolumnid;
var columnIndex = -1;
var cIndex = -1;
var isFirstCome = true;
var moveRight = false;
var tempArr = new Array();
var totalCount = 0;
var tempStartindex = 0;
var tempEndindex = 0;
var recommend_index = 0;
var recommend_length = 9;
//var leftFocusPosition = ['196','308','420','534','642','759','867','979'];
//var topFocusPosition = ['59','44','34','26','26','34','44','62'];
var topFocusPosition = [80, 57, 37, 24, 27, 37, 55, 87];
var obj_images_roll;
var ChannelNumPortal = top.channelInfo.currentChannel;//获取当前频道号
var stbType = Authentication.CTCGetConfig("STBType");//获取机顶盒型号
if (stbType == null || stbType == undefined || typeof stbType == "undefined") {
    stbType = Authentication.CUGetConfig("STBType");
}

function load_page() {

    obj_images_roll = new RollImages();
    var title_dom_ids = ["recommend_0", "recommend_1", "recommend_2", "recommend_3", "recommend_4", "recommend_5", "recommend_6", "recommend_7", "recommend_8"];
    var recommend_title = ['新闻专区','金鼠春晚合集','嗨皮乐园','一首歌一座城专区','雷神山现场直播','冰冻营救','4K专区','乡村爱情11','扫码缴费'];
    var recommend_focus_img = ['recommend_0.jpg', 'recommend_1.jpg', 'recommend_2.jpg', 'recommend_3.jpg', 'recommend_4.jpg', 'recommend_5.jpg', 'recommend_6.jpg', 'recommend_7.jpg', 'recommend_8.jpg'];
    var recommendzte_url = [
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=News&epgRecommendCntv=1',//0.新闻专区
        "vod_portal_pre.jsp?columnid=2011&topicindex=08&columnname=淘娱乐&leefocus=8_",//金鼠春晚合集
		portal_third_arr[0].curl,//2.嗨皮乐园
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=onesong&epgRecommendCntv=1',//3.壮丽70年
        "channel_play.jsp?mixno=358&leefocus=8_",//4.雷神山现场直播
        portal_third_arr[2].curl,//5.冰冻营救
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=i4k&epgRecommendCntv=1',//6.4K专区
        "vod_series_list.jsp?strADid=&strADid2=true&columnid=201709&programid=0000000030140000844235&programtype=1&contentid=00000020140005742171&columnpath=看吧>电视剧VIP>时代传奇&programname=&leefocus=8_",//7.乡村爱情11
        "zhuanti_saoma.jsp?leefocus=8_"//8.扫码缴费



        //   跳专题
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=7&recommend_flag=1',
        //跳节目单片
       // "vod_detail.jsp?strADid=&strADid2=true&columnid=20020C&programid=0000000030010000435273&programtype=0&programname=xx&vodtype=0&columnpath=看吧>健康百科>再活500年&programname=&leefocus=8_",//4.腰痛背后有隐情
        //跳栏目
        //"vod_portal_pre.jsp?columnid=1C&topicindex=04&columnname=星影秀&leefocus=8_"
        //跳频道
        //"channel_play.jsp?mixno=039&leefocus=8_"
        //跳爱上专区
        //'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=i4k&epgRecommendCntv=1',//6.4K专区



        /*'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=7&recommend_flag=1',//5.男性健康*/
       /* 'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=4&recommend_flag=1',//6.霜降之后化秋寒*/
       /* 'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=cartoon&epgRecommendCntv=1',//蓝猫大冒险*/
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=1&recommend_flag=1',//7.王者冠军杯门票抽奖活动
		//portal_third_arr[0].curl,//1.比比巴士
		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0U040M&programid=0000000030010000659772&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐>星光大道&programname=&leefocus=8_",//9.《三位小哥哥舞动《星光大道》你pick谁——张??
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=9&recommend_flag=1',//8.黑暗料理第四季special_topic_id=3
		//"channel_play.jsp?mixno=030&leefocus=8_",//8.摆脱老年的困扰
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=1&recommend_flag=1',//3.复联3电竞专题special_topic_id=3
		//"channel_play.jsp?mixno=038&leefocus=8_",//3.快餐车
		//"vod_series_list.jsp?strADid=&strADid2=true&columnid=0S07&programid=0000000030010000629231&programtype=1&contentid=00000020140002294452&columnpath=点播>爱看熊猫>全球秀场&programname=&leefocus=8_",//5.我是麻麻的跟屁熊
		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0U0306&programid=0000000030010000634596&programtype=0&programname=xx&vodtype=0&columnpath=点播>纪实>中国影像方志&programname=&leefocus=8_",//8.《中国影像方志》 广东连南篇
		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0S07&programid=0000000030010000629231&programtype=0&programname=xx&vodtype=0&columnpath=点播>爱看熊猫>全球秀场&programname=&leefocus=8_",//5.//5.我是麻麻的跟屁熊
		//portal_third_arr[1].curl,//穿越前线-火线冲突
		//跳爱上
        //'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=theme&epgRecommendCntv=1',
		//'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=spring&epgRecommendCntv=1',//9.2018爱上春晚
		//'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=spring&epgRecommendCntv=1',//3.2018爱上春晚
		//'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=winolympic&epgRecommendCntv=1',//3.2018冬奥会
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=&page=special_list&special_cat_id=4',//4.装修秘笈
		//portal_third_arr[1].curl,//5.穿越前线-火线冲突
		//"channel_play.jsp?mixno=030&leefocus=8_",//7.主食里的控糖秘笈
		//"vod_series_list.jsp?strADid=&strADid2=true&columnid=200A&programid=0000000030140000573537&programtype=1&contentid=00000020140004107087 &columnpath=点播>2018BTV狗年春晚&programname=&leefocus=8_",//7.BTV春晚
		//'http://210.13.3.137/epg_index.php?UserID='+top.user_id+'&page=cntvColumn&channel_num='+top.lastChannelNum+'&vender=zte&group=aishangkb&cntvColumnName=spring&epgRecommendCntv=1&ReturnURL='+encodeURIComponent(return_url)+'&epgstbType='+stbType,//爱上春晚
		//'http://210.13.3.137/epg_index.php?UserID='+top.user_id+'&page=cntvColumn&channel_num='+top.lastChannelNum+'&vender=zte&group=aishangkb&cntvColumnName=politics&epgRecommendCntv=1&ReturnURL='+encodeURIComponent(return_url)+'&epgstbType='+stbType,//单车围城
		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0A0708&programid=0000000030010000549050&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐综艺>搞笑幽默>我爱满堂彩 &programname=&leefocus=8_",//9.百年老店
		//"vod_series_list.jsp?strADid=&strADid2=true&columnid=0C0C&programid=0000000030140000537537&programtype=1&contentid=00000020140004013104&columnpath=点播>纪实频道>顶级放送&programname=&leefocus=8_",//1.创新中国-潮起
		//"channel_play.jsp?mixno=030&leefocus=8_",//5.巧运动 止疼痛
		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0A0300&programid=0000000030010000504489&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐综艺>选秀PK>星光大道&programname=&leefocus=8_",//8.那是青春吐芳华
		//跳直播频道
        //"channel_play.jsp?mixno=037&leefocus=8_",//
        //第三方
        //portal_third_arr[0].curl,//
        //portal_third_arr[1].curl,//
        //在线缴费
        //"zhuanti_saoma.jsp?leefocus=8_",//8
        //跳看吧
        //'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=2&recommend_flag=1',//2
		//'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=column&columnName=mangguo&recommend_flag=1',//2
        //跳爱上
        //'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=theme&epgRecommendCntv=1',
        //跳影片
        //"vod_detail.jsp?strADid=&strADid2=true&columnid=0A0317&programid=0000000030010000443377&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐综艺>选秀PK>出彩中国人&programname=&leefocus=8_",
        //跳电视剧
        //"vod_series_list.jsp?strADid=&strADid2=true&columnid=0C0C&programid=0000000030140000443526&programtype=1&contentid=00000020140003381296&columnpath=点播>纪实频道>顶级放送&programname=&leefocus=8_",
        //跳栏目
        //"vod_portal_pre.jsp?columnid=0C&topicindex=00&columnname=纪实频道&leefocus=8_",
        //"vod_portal_pre.jsp?columnid=0C&destpage=2&topicindex=00&columnname=纪实频道>历史&leefocus=8_",
        //"vod_Playy.jsp?columnid=0H00&programid=00000020140002265417&programtype=0&programname=xx&vodtype=0&leefocus=href5",
        //"vod_Playy.jsp?columnid=0H0A&programid=0000000030010000296066&programtype=0&programname=xx&vodtype=0&leefocus=href5",

    ];

    var recommend_url =[
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=News&epgRecommendCntv=1',//0.新闻专区
        "vod_portal_pre.jsp?columnid=2011&topicindex=08&columnname=淘娱乐&leefocus=8_",//金鼠春晚合集
		portal_third_arr[0].curl,//2.嗨皮乐园
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=onesong&epgRecommendCntv=1',//3.壮丽70年
        "channel_play.jsp?mixno=358&leefocus=8_",//4.雷神山现场直播
        portal_third_arr[2].curl,//5.冰冻营救
        'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=i4k&epgRecommendCntv=1',//6.4K专区
        "vod_series_list.jsp?strADid=&strADid2=true&columnid=201709&programid=0000000030140000844235&programtype=1&contentid=00000020140005742171&columnpath=看吧>电视剧VIP>时代传奇&programname=&leefocus=8_",//7.乡村爱情11
        "zhuanti_saoma.jsp?leefocus=8_"//8.扫码缴费




		//"vod_detail.jsp?strADid=&strADid2=true&columnid=0U040M&programid=0000000030010000659772&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐>星光大道&programname=&leefocus=8_",//9.《三位小哥哥舞动《星光大道》你pick谁——张??


		
		
	  //跳直播频道
        //"channel_play.jsp?mixno=037&leefocus=8_",//

        //第三方
        //portal_third_arr[0].curl,//
        //portal_third_arr[1].curl,//

        //在线缴费
        //"zhuanti_saoma.jsp?leefocus=8_",//8

        //跳看吧
        //'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=special_topic&special_topic_id=2&recommend_flag=1',//2
        //'http://210.13.3.184/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=YEWUZU30&ReturnURL='+ returnurl+'&epgstbType='+stbType+'&page=column&columnName=mangguo&recommend_flag=1',//2

        //跳爱上
        //'http://210.13.3.137/epg_index.php?UserID='+userid+'&channel_num='+now_channel_num+'&vender=zte&group=aishangkb&epgstbType='+stbTypezte+'&ReturnURL='+ returnurl+'&page=cntvColumn&cntvColumnName=theme&epgRecommendCntv=1',

        //跳影片
        //"vod_detail.jsp?strADid=&strADid2=true&columnid=0A0317&programid=0000000030010000443377&programtype=0&programname=xx&vodtype=0&columnpath=点播>娱乐综艺>选秀PK>出彩中国人&programname=&leefocus=8_",
        //跳电视剧
        //"vod_series_list.jsp?strADid=&strADid2=true&columnid=0C0C&programid=0000000030140000443526&programtype=1&contentid=00000020140003381296&columnpath=点播>纪实频道>顶级放送&programname=&leefocus=8_",

        //跳栏目
        //"vod_portal_pre.jsp?columnid=0C&topicindex=00&columnname=纪实频道&leefocus=8_",
        //"vod_portal_pre.jsp?columnid=0C&destpage=2&topicindex=00&columnname=纪实频道>历史&leefocus=8_",
        //"vod_Playy.jsp?columnid=0H00&programid=00000020140002265417&programtype=0&programname=xx&vodtype=0&leefocus=href5",
        //"vod_Playy.jsp?columnid=0H0A&programid=0000000030010000296066&programtype=0&programname=xx&vodtype=0&leefocus=href5",


    ];
    obj_images_roll.init_data(title_dom_ids, recommend_title, recommendzte_url, recommend_url, recommend_focus_img);
    obj_images_roll.refresh_images();
    //document.onkeypress = on_key_press;
}

function RollImages() {
    this.base_idx = 4;
    this.curr_idx = 4;
    this.items_len = 0;
    this.picts_len = 0;
    this.url_len = 0;
    this.imgid_focus_len = 0;
    this.titleid_list = [];
    this.title_list = [];
    this.url_list = [];
    this.curr_url = '';
    this.imgid_focus_list = [];

    this.init_data = function (titleid_list, title_list, urlzte_list, url_list, imgid_focus_list) {
        this.base_idx = recommend_index;
        this.titleid_list = titleid_list;//title id
        this.title_list = title_list;//title name
        this.url_list = url_list;//url
        this.urlzte_list = urlzte_list;// zte url
        this.imgid_focus_list = imgid_focus_list;//focus img
        this.items_len = titleid_list.length; // id length
        this.picts_len = title_list.length;// title length
        this.url_len = url_list.length;// url length
        this.urlzte_len = urlzte_list.length;//zte url length
        this.imgid_focus_len = imgid_focus_list.length;//focus img length
    }
    this.refresh_images = function () {
        var real_i = 0;
        var title_name;
        var title_name_focus;
        recommend_index = parseInt(this.base_idx, 10);
        for (var i = 0; i < this.items_len; i++) {
            real_i = parseInt(this.get_real_idx(parseInt(this.base_idx, 10) + i), 10);
            title_name = this.title_list[real_i];
            if ((i == 0 || i == 8) && this.title_list[real_i].length > 4) {
                title_name = this.title_list[real_i].substr(0, 4) + "...";
            } else if ((i == 1 || i == 7) && this.title_list[real_i].length > 5) {
                title_name = this.title_list[real_i].substr(0, 5) + "...";
            } else if ((i == 2 || i == 6) && this.title_list[real_i].length > 6) {
                title_name = this.title_list[real_i].substr(0, 6) + "...";
            } else if ((i == 3 || i == 5) && this.title_list[real_i].length > 7) {
                title_name = this.title_list[real_i].substr(0, 7) + "...";
            } else if ((i == 4) && this.title_list[real_i].length > 8) {
                title_name = this.title_list[real_i].substr(0, 7) + "...";
            }
            $("" + this.titleid_list[i]).innerHTML = title_name;
            if (i == 4) {
                if (isZTEBW == true) {
                    if (this.urlzte_list[real_i].indexOf("http://") > -1) {

                        this.curr_url = this.urlzte_list[real_i];
                    } else this.curr_url = this.urlzte_list[real_i] + recommend_index + "_" + startIndex + "_" + endIndex + "_" + recommend_flag;
                } else {
                    if (this.url_list[real_i].indexOf("http://") > -1) {
                        this.curr_url = this.url_list[real_i];
                    } else this.curr_url = this.url_list[real_i] + recommend_index + "_" + startIndex + "_" + endIndex + "_" + recommend_flag;
                    ;
                }

                $("recommend_img").src = "images/recommend/" + this.imgid_focus_list[real_i];
                //$(""+this.titleid_list[i]).innerHTML =  "<strong>"+this.title_list[real_i]+"</strong>";
                if (bottomMenuIndex == 8 && this.title_list[real_i].length > 8) {
                    $("" + this.titleid_list[i]).innerHTML = "<marquee version='3' scrolldelay='250' width='172'>" + this.title_list[real_i] + "</marquee>";
                }


            }
        }
    }
    this.get_real_idx = function (idx) {
        var real_i = idx;
        while (real_i < 0) {
            real_i = real_i + this.picts_len;
        }
        if (idx >= this.picts_len) real_i = real_i % this.picts_len;
        return real_i;
    }
    this.list_up = function () {
        this.base_idx = parseInt(this.get_real_idx(parseInt(this.base_idx, 10) + 1), 10);//this.base_idx++;
        recommend_index = parseInt(this.base_idx, 10);
        this.refresh_images();
    }
    this.list_dn = function () {
        this.base_idx = parseInt(this.get_real_idx(parseInt(this.base_idx, 10) - 1), 10);//this.base_idx--;
        recommend_index = parseInt(this.base_idx, 10);
        this.refresh_images();
    }
    this.list_left = function () {
        this.refresh_images();
    }
    this.list_right = function () {
        this.refresh_images();
    }

    this.list_ok = function () {
        if (this.curr_url.indexOf("http://") > -1) {

            top.jsSetControl("isCheckPlay", "0");
            top.doStop();
            backurlparam += "?lastfocus=" + bottomMenuIndex + "_" + recommend_index + "_" + startIndex + "_" + endIndex + "_" + recommend_flag;
            top.jsSetControl("backurlparam", backurlparam);
            var lastChannelNum = top.channelInfo.currentChannel;
            Authentication.CUSetConfig("LastChannelNo", top.channelInfo.currentChannel);//记住频道 针对华为数码视讯
            if (isZTEBW == true) {
                ztebw.setAttribute("curMixno", lastChannelNum);
                //        Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
                if ("CTCSetConfig" in Authentication) {
                    Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
                } else {
                    Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
                }
            } else {
                Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
            }

            top.mainWin.document.location = this.curr_url;
            return;
        }
        top.mainWin.document.location = this.curr_url;
    }
}

var specalpagecount = parseInt((specallength - 1) / leftMenuCount + 1);

//volumeosd.jsp add 
function showvolumeLeft() {
    top.mainWin.document.location = "volumeosd.jsp?type=leftVolume";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}

function showvolumeRight() {
    top.mainWin.document.location = "volumeosd.jsp?type=rightVolume";
    top.showOSD(2, 0, 0);
    top.setBwAlpha(0);
}

function showvolumeMute() {
    var muteState = top.doGetMuteState();
    if (muteState == 0) {
        top.doSetMuteState(1);
        top.showMuteOSD();
    } else {
        top.doSetMuteState(0);
        top.mainWin.document.location = "volumeosd.jsp";
        top.showOSD(2, 0, 0);
        top.setBwAlpha(0);
    }
}

//volumeosd.jsp add

function doKeyPress(evt) {
    var keycode = evt.which;
    if (keycode == 0x0025) {
        goLeft();
    } else if (keycode == 0x0027) {
        goRight();
    } else if (keycode == 0x000D) {
        if (hasGetData == 1) {
            goOk();
        }
    } else if (keycode == 0x0026) {
        goUp();
    } else if (keycode == 0x0028) {
        if (hasGetData == 1) {
            goDown();
        }
    } else if (keycode == 0x0110 || keycode == 36) { //36涓鸿??????棣?椤甸????
        /* if(keycode == 0x0110){
             //Authentication.CTCSetConfig("KeyValue","0x110");
             if("CTCSetConfig" in Authentication)
             {
                 Authentication.CTCSetConfig("KeyValue","0x110");
             }else{
                 Authentication.CUSetConfig("KeyValue","0x110");
             }
         }*/
        top.mainWin.document.location = portalUrl;
        //top.mainWin.document.location = portalUrl+"?tempno="+top.channelInfo.currentChannel;
    } else if (keycode == 0x0008 || keycode == 24) {
        if (bottomMenuIndex == 3 && channelType == 'channel') {
            curcolumnid = "";
            columnIndex = cIndex;
            startIndex = tempStartindex;
            endIndex = tempEndindex;
            showBottomMenu();
        } else {
            top.jsHideOSD();
        }
    } else if (keycode == 0x0021) {
        pageUp();
    } else if (keycode == 0x0113) {
        if (bottomMenuIndex >= 5 && hasGetData == 1) {
            doRed();
        }
    } else if (keycode == 0x0022) {
        pageDown();
    } else if (keycode == 0x0103) {//remoteVolumePlus
        showvolumeRight();
    } else if (keycode == 0x0104) {//remoteVolumeMinus
        showvolumeLeft();
    } else if (keycode == 0x0105) {//remoteVolumeMute
        showvolumeMute();
    } else {
        commonKeyPress(evt);
    }
    return false;
}


var currentChannel = top.channelInfo.currentChannel;
if (currentChannel == -1) {
    currentChannel = "";
}


var isFavs = 1;
var timer = -1;
var doRed = function () {
    if (columnArr[leftMenuIndex].invalid == 1) {
        return;
    }
    if (columnArr[leftMenuIndex].curl.indexOf("http") == 0) {
        doFav(columnArr[leftMenuIndex]);
    }
}


function showMsg(flag) {
    dellflag = flag;
    if (dellflag == 0) {
        $("text").innerText = sus;
        $("msg").style.visibility = "visible";
        $("closeMsg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
    } else if (dellflag == 1) {
        $("text").innerText = alsus;
        $("msg").style.visibility = "visible";
        $("closeMsg").style.visibility = "visible";
        clearTimeout(timer);
        timer = setTimeout(closeMessage, 2000);
    }
}

function closeMessage() {
    $("text").innerText = "";
    $("msg").style.visibility = "hidden";
    clearTimeout(timer);
}


var favArr = [];

function isFav(url, cname) {
    var flag = 0;
    var str = ztebw.getAttribute(userid);
    if (str == "null" || str == "" || str == "undefined") return 0;
    favArr = eval("(" + str + ")");
    for (var i = 0; i < favArr.length; i++) {
        if (favArr[i].curl == url && favArr[i].cname == cname) {
            return 1;
        }
    }
    return 0;
}

function doFav(arr) {
    if (isZTEBW == false) {
        return;
    }
    var flag = isFav(arr.curl, arr.cname);
    if (flag == 0) {
        favArr.push(arr);
        ztebw.setAttribute(userid, favArr.toJSONString());
    }
    showMsg(flag);
}

var hasGetData = 1;

function showBottomMenuTimer() {
//if(bottomMenuIndex==0){
//	$("worldcup_dec").style.display="block";
//	}else{$("worldcup_dec").style.display="none";}
    if (bottomMenuIndex <= 7) {
        $("left_menua").style.display = "block";
        $('bottom_menu_focus' + bottomMenuIndex).style.visibility = 'visible';
        $('bottom_menu_text_' + bottomMenuIndex).style.color = '#ff0000';
        $("buttom_" + bottomMenuIndex).style.top = (topFocusPosition[bottomMenuIndex] - 15) + "px";
        if (bottomMenuTimer) {
            window.clearTimeout(bottomMenuTimer);
        }
        hasGetData = 0;
        bottomMenuTimer = window.setTimeout('showBottomMenu();', 400);
    } else {
        recommend_index = 0;
        $("rec_focus").style.visibility = "visible";
        $("rec_img_bg").style.visibility = "visible";
        $("rec_img").style.visibility = "visible";
        $("left_menua").style.display = "none";
        // $('left_focus_img').style.visibility="hidden";
        // if(recommend_flag == 0){
        // if($('recommend_focus_'+recommend_index+'_0')!= null){
        // $('recommend_focus_'+recommend_index+'_0').style.visibility = "visible";
        // }else{
        // $('recommend_focus_'+recommend_index).style.visibility='visible';
        // }
        // }else{
        // $('recommend_focus_'+recommend_index).style.visibility='visible';
        // }

    }
}


function showBottomMenu() {
    if (bottomMenuIndex == 0) {//
        hasGetData = 1;
        showMyTvColumn();
    } else if (bottomMenuIndex == 1) {//锟?
        showTvodChannel();
    } else if (bottomMenuIndex == 2) {//
        showVodColumn();
    } else if (bottomMenuIndex == 3) {//
        showChannelColumn();
    } else {
        loadSpecalColumn();
    }
}

function loadSpecalColumn() {
    hasGetData = 1;
    if (bottomMenuIndex == 4) {
        totalCount = SpecalColumnlist.length;
    } else if (bottomMenuIndex == 5) {
        totalCount = appArr.length;
    } else if (bottomMenuIndex == 6) {
        totalCount = commarr.length;
    } else if (bottomMenuIndex == 7) {
        totalCount = lifeArr.length;
    }
    if (endIndex > totalCount) endIndex = totalCount;
    showSpecalColumnlist();
}

function showSpecalColumnlist() {
    columnArr = new Array();
    var tempColumnname = null;
    for (var i = startIndex; i < endIndex; i++) {
        if (bottomMenuIndex == 4) {
            columnArr.push(SpecalColumnlist[i]);
        } else if (bottomMenuIndex == 5) {
            columnArr.push(appArr[i]);
        } else if (bottomMenuIndex == 6) {
            columnArr.push(commarr[i]);
        } else if (bottomMenuIndex == 7) {
            columnArr.push(lifeArr[i]);
        }
    }
    length = columnArr.length;

    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {

            tempColumnname = writeFitStringNirui(columnArr[i].columnname, 175, 24, 14.6, 12);
            if (tempColumnname != columnArr[i].columnname) {
                columnArr[i].hasBreak = '1';

            }
            $("left_menu_" + i).style.textAlign = "center";
            $('left_menu_' + i).innerText = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            if (columnArr[i].invalid == '1') {
                $('left_menu_' + i).style.color = "gray";
            } else {
                $('left_menu_' + i).style.color = "white";
            }
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function showMyTvColumn() {
    //leftMenuIndex = 1;
    if (startIndex == 0) {
        endIndex = 7;
    }
    var tempColumnname = null;
    length = mytvArr.length;
    totalCount = length;
    if (isFirstCome) {
        isFirstCome = false;
    } else {
        leftMenuIndex = 0;
        //leftMenuIndex = 1;
    }
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            tempColumnname = writeFitStringNirui(mytvArr[i].tvname, 192, 24, 14.6, 12);
            if (tempColumnname != mytvArr[i].tvname) {
                mytvArr[i].hasBreak = '1';
            }
            $("left_menu_" + i).style.textAlign = "center";
            $('left_menu_' + i).innerText = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            if (mytvArr[i].invalid == "true") {
                $('left_menu_' + i).style.color = "gray";
            } else if (mytvArr[i].tvname == "疫情权威解读") {
                $('left_menu_' + i).style.color = "gold";
                //$('left_menu_' + i).style.fontWeight = "bold";
            } else {
                $('left_menu_' + i).style.color = "white";
            }
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
    //灏?涓や釜????
    // length = length-2;
    totalCount = length;
}

function showTvodChannel() {
    var requestUrl = "action/allchannellistData.jsp?istvod=1&columnid=" + channelColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showtvodchannelsResponse);
}

function showtvodchannelsResponse() {
    hasGetData = 1;
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.channelData;
    var channelObj = {channelname: tvodchannelname, columnid: channelColumnid, tvodflag: 0};
    tempArr.unshift(channelObj);
    if (startIndex == 0) {
        endIndex = 7;
    }
    totalCount = tempArr.length;
    if (endIndex > totalCount) {
        endIndex = totalCount;
    }
    showTvodList();
}

function showTvodList() {
    columnArr = new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            //$('left_menu_' + i).innerText = columnArr[i].channelname.substr(0, 8);
            var mixno = columnArr[i].mixno;
            if (mixno == undefined) {
                mixno = "";
            } else if (mixno.length == 1) {
                mixno = "00" + mixno;
            } else if (mixno.length == 2) {
                mixno = "0" + mixno;
            }

            tempColumnname = writeFitStringNirui(columnArr[i].channelname, 170, 24, 14.6, 12);
            if (tempColumnname != columnArr[i].channelname) {
                columnArr[i].hasBreak = '1';
                columnArr[i].columnname = mixno + " " + columnArr[i].channelname;
            }
            if (columnArr[i].tvodflag == 0) {
                $("left_menu_" + i).style.textAlign = "center";
            } else {
                $("left_menu_" + i).style.textAlign = "left";
            }

            $('left_menu_' + i).innerText = mixno + " " + tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function showVodColumn(destapage) {
    var requestUrl = "action/vod_columnlist_update.jsp?columnid=" + vodColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showvodcolumnlist);
}

function showChannelColumn() {
    var requestUrl = "action/zhuanti_columnlist.jsp?columnid=" + channelColumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, loadChannelColumn);
}

function loadChannelColumn() {
    hasGetData = 1;
    channelType = "column";
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.columnData;
    var columnObj = {columnname: channelname1, columnid: channelColumnid};
    tempArr.unshift(columnObj);
    totalCount = tempArr.length;
    if (startIndex == 0) {
        endIndex = 7;
    }
    if (endIndex > totalCount) endIndex = totalCount;
    showchannelcolumnlist();
}

var isFirstChannel = true;

function showchannelcolumnlist() {
    columnArr = new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    if (isFirstChannel) {
        isFirstChannel = false;
    }
//    if (isFirstCome) {
//        isFirstCome = false;
//    } else {
//        leftMenuIndex = 0;
//    }

    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            //$('left_menu_'+i).innerHTML = columnArr[i].columnname+"&nbsp;&nbsp;&nbsp;&nbsp;<img style='' width='30' height='19' src='images/liveTV/btv-channel-right.png'/>";
            //$('left_menu_' + i).innerHTML = columnArr[i].columnname; writeFitStringNirui(columnArr[i].columnname,205,24,14.6,12);
            tempColumnname = writeFitStringNirui(columnArr[i].columnname, 205, 24, 14.6, 12);
            if (tempColumnname != columnArr[i].columnname) {
                columnArr[i].hasBreak = '1';
            }
            $("left_menu_" + i).style.textAlign = "center";
            $('left_menu_' + i).innerHTML = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    if (columnIndex != -1) {
        leftMenuIndex = columnIndex;
        columnIndex = -1;
    }


    showupdowicon();
    changeLeftMenuFocus();
}

function showupdowicon() {
    $("up").style.visibility = startIndex > 0 ? "visible" : "hidden";
    $("down").style.visibility = endIndex < totalCount ? "visible" : "hidden";
}

function showvodcolumnlist() {
    hasGetData = 1;
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.columnData;
    totalCount = tempArr.length;
    if (startIndex == 0) {
        endIndex = 7;
    }
    if (endIndex > totalCount) endIndex = totalCount;
    showVodList();
}

function showVodList() {
    columnArr = new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    for (var i = 0; i < leftMenuCount; i++) {
        if (i < length) {
            //$('left_menu_' + i).innerText = writeFitString(columnArr[i].columnname, 20, 180);
            tempColumnname = writeFitStringNirui(columnArr[i].columnname, 205, 24, 14.6, 12);
            if (tempColumnname != columnArr[i].columnname) {
                columnArr[i].hasBreak = '1';
            }
            $("left_menu_" + i).style.textAlign = "center";
            $('left_menu_' + i).innerText = tempColumnname;
            $('left_menu_' + i).style.visibility = 'visible';
            $('left_menu_' + i).style.color = "white";
        } else {
            $('left_menu_' + i).innerText = '';
            $('left_menu_' + i).style.visibility = 'hidden';
        }
    }
    showupdowicon();
    changeLeftMenuFocus();
}

function hiddenBottomMenuFocus() {
    if (bottomMenuIndex <= 7) {
        $('bottom_menu_focus' + bottomMenuIndex).style.visibility = 'hidden';
        $('bottom_menu_text_' + bottomMenuIndex).style.color = '#ffffff';
        //}else{
        // $('recommend_focus_'+recommend_index).style.visibility='hidden';
        $("rec_focus").style.visibility = "hidden";
        $("rec_img_bg").style.visibility = "hidden";
        $("rec_img").style.visibility = "hidden";
    }
}

var tempChannelName = null;

function changeLeftMenuFocus(flag) {
//    if (bottomMenuIndex == 4) { //涓?棰?
//        $('left_focus_img').style.top = 89 + 90 * leftMenuIndex + 'px';
//    } else {
//        $('left_focus_img').style.top = 89 + 51 * leftMenuIndex + 'px';
//    }
    if (leftMenuIndex >= 7) {
        leftMenuIndex = 6;
    }

    if (bottomMenuIndex <= 7) {

        if ("0406" == curcolumnid) {
            var leftMenuIndexm = leftMenuIndex - 1;
            if (flag == -1) {
                if (bottomMenuIndex == 1 || bottomMenuIndex == 2 || bottomMenuIndex == 3 || bottomMenuIndex == 4) {
                    if (columnArr[leftMenuIndexm].hasBreak == '1') {
                        $('left_menu_' + leftMenuIndex).innerHTML = tempChannelName;
                    }
                }
            } else {
                if (bottomMenuIndex == 1 || bottomMenuIndex == 2 || bottomMenuIndex == 3 || bottomMenuIndex == 4) {

                    if (columnArr[leftMenuIndexm].hasBreak == '1') {
                        tempChannelName = $('left_menu_' + leftMenuIndex).innerHTML;
                        $('left_menu_' + leftMenuIndex).innerHTML = "<marquee version='3' scrolldelay='250' width='185'>" + columnArr[leftMenuIndexm].columnname + "</marquee>";
                    }
                }
            }

        } else {
            if (flag == -1) {
                if (bottomMenuIndex == 1 || bottomMenuIndex == 2 || bottomMenuIndex == 3 || bottomMenuIndex == 4 || bottomMenuIndex == 5 || bottomMenuIndex == 6 || bottomMenuIndex == 7) {
                    if (columnArr[leftMenuIndex].hasBreak == '1') {
                        $('left_menu_' + leftMenuIndex).innerHTML = tempChannelName;
                    }
                } else if (bottomMenuIndex == 0) {
                    if (mytvArr[leftMenuIndex].hasBreak == '1') {
                        $('left_menu_' + leftMenuIndex).innerHTML = tempChannelName;
                    }
                }
            } else {
                if (bottomMenuIndex == 1 || bottomMenuIndex == 2 || bottomMenuIndex == 3 || bottomMenuIndex == 4 || bottomMenuIndex == 5 || bottomMenuIndex == 6 || bottomMenuIndex == 7) {
                    if (columnArr[leftMenuIndex].hasBreak == '1') {
                        tempChannelName = $('left_menu_' + leftMenuIndex).innerHTML;
                        $('left_menu_' + leftMenuIndex).innerHTML = "<marquee version='3' scrolldelay='250' width='185'>" + columnArr[leftMenuIndex].columnname + "</marquee>";
                    }
                } else if (bottomMenuIndex == 0) {
                    if (mytvArr[leftMenuIndex].hasBreak == '1') {
                        tempChannelName = $('left_menu_' + leftMenuIndex).innerHTML;
                        $('left_menu_' + leftMenuIndex).innerHTML = "<marquee version='3' scrolldelay='250' width='185'>" + mytvArr[leftMenuIndex].tvname + "</marquee>";
                    }
                }
            }
        }
        $('left_focus_img').style.top = 89 + 51 * leftMenuIndex + 'px';
        $('left_focus_img').style.visibility = "visible";
    }
}

function goLeft() {
    curcolumnid = "";
    startIndex = 0;
    endIndex = 7;
    totalCount = 0;
    leftMenuIndex = 0;

    hiddenBottomMenuFocus();
    recommend_flag = 0;
    // $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex]+"px";
    if (bottomMenuIndex == bottomMenuCount - 1) {

        // if($('recommend_focus_'+recommend_index+'_0')!= null && $('recommend_focus_'+recommend_index+'_0').style.visibility=="visible"){
        // control_recommend_blur();
        // }else{
        // $('recommend_focus_'+recommend_index).style.visibility="hidden";
        $("left_menua").style.display = "none";
        $("rec_focus").style.visibility = "hidden";
        $("rec_img_bg").style.visibility = "hidden";
        $("rec_img").style.visibility = "hidden";
        bottomMenuIndex = (--bottomMenuIndex + bottomMenuCount) % 9;
        showBottomMenuTimer();
        obj_images_roll.list_left();//left	// }
    } else {
        $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex] + "px";
        if ($("left_menua").style.display == "none") {
            $("left_menua").style.display = "block";
        }
        bottomMenuIndex = (--bottomMenuIndex + bottomMenuCount) % 9;
        if (bottomMenuIndex == 8) {
            obj_images_roll.list_right();
        }
        showBottomMenuTimer();
    }
}

function goRight() {
    curcolumnid = "";
    startIndex = 0;
    endIndex = 7;
    totalCount = 0;
    leftMenuIndex = 0;

    hiddenBottomMenuFocus();
    recommend_flag = 7;
    // $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex]+"px";

    if (bottomMenuIndex == 8) {
        // if($('recommend_focus_'+recommend_index+'_0')!= null){
        // control_recommend_focus();
        // }else{

        $("rec_focus").style.visibility = "hidden";
        $("rec_img_bg").style.visibility = "hidden";
        $("rec_img").style.visibility = "hidden";
        // $('recommend_focus_'+recommend_index).style.visibility="hidden";
        bottomMenuIndex = (++bottomMenuIndex + bottomMenuCount) % 9;
        showBottomMenuTimer();
        obj_images_roll.list_right();//right
        // }
    }

    else {
        $("buttom_" + bottomMenuIndex).style.top = topFocusPosition[bottomMenuIndex] + "px";
        if ($("left_menua").style.display == "none") {
            $("left_menua").style.display = "block";
        }
        bottomMenuIndex = (++bottomMenuIndex + bottomMenuCount) % 9;
        if (bottomMenuIndex == 8) {
            obj_images_roll.list_right();
        }
        showBottomMenuTimer();
    }
}

function goOk() {
    if (bottomMenuIndex == 0) {//mytv
        if (mytvArr[leftMenuIndex].invalid == "true") {
        } else {
            // document.location = mytvArr[leftMenuIndex].tvurl;
            var url = mytvArr[leftMenuIndex].tvurl;
            if (url.indexOf('?') > -1) {
                url = url + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            } else {
                url = url + "?leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            }
//        if (url.indexOf('application.jsp') > -1 || url.indexOf('zhanti.jsp') > -1) {
//        } else {
//           savePlayChannel();
//        }
            //var a=leftMenuCount-leftMenuIndex+"_"+bottomMenuIndex
            var obj = mytvArr[leftMenuIndex];
//        for(var p in obj){
//        }
            if (mytvArr[leftMenuIndex].gosd == '1' && isZTEBW == true) {
                if ("CTCSetConfig" in Authentication) {
                    Authentication.CTCSetConfig('SetEpgMode', 'SD');
                } else {
                    Authentication.CUSetConfig('SetEpgMode', 'SD');
                }
            }
            var a = bottomMenuIndex + "_" + (startIndex + leftMenuIndex);
            if (url.indexOf("http://") > -1) {
                savePlayChannel();
                top.mainWin.document.location = mytvArr[leftMenuIndex].tvurl;
                return;
            }
            top.mainWin.document.location = url + "&param=" + a;
        }
//        window.location = mytvArr[leftMenuIndex].tvurl;
    } else if (bottomMenuIndex == 1) { //锟截匡拷
        if (startIndex == 0 && leftMenuIndex == 0) {//锟截匡拷
            top.mainWin.document.location = "channel_all_tvod.jsp?leefocus=1_0";
        } else { //锟?
            var columnid = columnArr[leftMenuIndex].columnid;
            var channelid = columnArr[leftMenuIndex].channelid;
            var mixno = columnArr[leftMenuIndex].mixno;
            if (isZTEBW == true) {
                top.mainWin.document.location = "channel_onedetail_tvod_pre.jsp?columnid=" + columnid + "&channelid=" + channelid + "&mixno=" + mixno + "&leefocus=1_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            } else {
                top.mainWin.document.location = "channel_onedetail_tvod.jsp?columnid=" + columnid + "&channelid=" + channelid + "&mixno=" + mixno + "&leefocus=1_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
            }
        }
    } else if (bottomMenuIndex == 2) { //锟姐播
        var curColumnid = columnArr[leftMenuIndex].columnid;
        var columnname = columnArr[leftMenuIndex].columnname;
        if (columnname.length > 15) {
            columnname = columnname.substr(0, 15) + "...";
        }
        if (isZTEBW == true) {
            top.mainWin.document.location = "vod_portal_pre.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex + "_" + endIndex + "&columnname=" + columnname;
        } else {
            top.mainWin.document.location = "vod_portal.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex + "_" + endIndex + "&columnname=" + columnname;
        }
        //top.mainWin.document.location = "vod_portal_pre.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
//        top.mainWin.document.location = "vod_portal.jsp?columnid=" + curColumnid + "&leefocus=2_" + leftMenuIndex + "_" + startIndex+"_"+endIndex;
    } else if (bottomMenuIndex == 3) { //
        if (channelType == 'column') { //
            if (startIndex == 0 && leftMenuIndex == 0) {//
                if (isZTEBW == true) {
                    top.mainWin.document.location = "channel_all_pre.jsp?leefocus=3_0";
                } else {
                    top.mainWin.document.location = "channel_all.jsp?leefocus=3_0";
                }
//                top.mainWin.document.location = "channel_all_pre.jsp?leefocus=3_0";
//                top.mainWin.document.location = "channel_all.jsp?leefocus=3_0";
            } else {
                curcolumnid = columnArr[leftMenuIndex].columnid;
                tempStartindex = startIndex;
                tempEndindex = endIndex;
                cIndex = leftMenuIndex;
                showChannelListByColumnid();
            }
        } else if (channelType == 'channel') {
            if ("0406" == curcolumnid) {
                leftMenuIndex = leftMenuIndex - 1;
                var mixno = columnArr[leftMenuIndex].mixno;
            } else {
                var mixno = columnArr[leftMenuIndex].mixno;
            }

            top.mainWin.document.location = "channel_play.jsp?mixno=" + mixno;
        }
    } else if (bottomMenuIndex == 4) {  //涓?棰?璺宠浆?炬?? 锛???绾㈡??娣诲??
        var columnid = columnArr[leftMenuIndex].columnid;
        var focus_zhuanti_index = startIndex + leftMenuIndex;
        // if (columnid == "0") { //?炬?ヤ负涓?棰???缃?椤?
        //   url = columnArr[leftMenuIndex].columnposter;
        // if (url.indexOf(".jsp?") >= 0 || url.indexOf(".html?") >= 0 || url.indexOf(".htm?") >= 0 || url.indexOf(".php?") >= 0) {
        //   url += "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        //} else {
        //  url += "?leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        //}
        //} else if (leftMenuIndex == 0 || leftMenuIndex == 1) {
        //  url = "zhuanti_portal.jsp?columnid=" + columnid + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        //} else {
        //  url = "zhuanti_portal_1.jsp?columnid=" + columnid + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        //}
        //url涓虹??涓??归〉??  ?抽??瑙?棰?
//url = "zhuanti_menu.jsp?columnid=" + columnid + "&focus_zhuanti_index="+focus_zhuanti_index+"&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        var leftMenuIndexa = leftMenuIndex + 1;
        url = 'http://210.13.3.184/epg_index.php?UserID=' + userid + '&channel_num=' + now_channel_num + '&vender=zte&group=YEWUZU30&epgstbType=' + stbType + '&ReturnURL=' + returnurl + '&page=special_list&special_cat_id=' + leftMenuIndexa;
        //url??o?????‰??C1é?μé?￠  ?…3é—-è§?é￠‘
        if (url.indexOf("http://") > -1) {
            savePlayChannel();
        }
        top.mainWin.document.location = url;
    } else if (bottomMenuIndex == 8) {
        obj_images_roll.list_ok();


    } else {
        if (columnArr[leftMenuIndex].invalid == 1) {
            return;
        }
        var url = columnArr[leftMenuIndex].curl;
        if (url.indexOf('?') > -1) {
            url = url + "&leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        } else {
            url = url + "?leefocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
        }
//        if (url.indexOf('application.jsp') > -1 || url.indexOf('zhanti.jsp') > -1) {
//        } else {
//           savePlayChannel();
//        }
        //var a=leftMenuCount-leftMenuIndex+"_"+bottomMenuIndex
        var obj = columnArr[leftMenuIndex];
        if (columnArr[leftMenuIndex].gosd == '1' && isZTEBW == true) {
            if ("CTCSetConfig" in Authentication) {
                Authentication.CTCSetConfig('SetEpgMode', 'SD');
            } else {
                Authentication.CUSetConfig('SetEpgMode', 'SD');
            }
        }

        var a = (bottomMenuIndex - 4) + "_" + (startIndex + leftMenuIndex);
        if (url.indexOf("http://") > -1) {
            savePlayChannel();
            top.mainWin.document.location = url;
            return;
        }
        top.mainWin.document.location = url + "&param=" + a;
    }
}

function savePlayChannel() {
    top.jsSetControl("isCheckPlay", "0");
    top.doStop();
    Authentication.CUSetConfig("LastChannelNo", top.channelInfo.currentChannel);//记住频道 针对华为数码视讯
//    var lastChannelNum = top.channelInfo.currentChannel;
//    ztebw.setAttribute("channelNO", lastChannelNum);
    setBackParam();
}

function setBackParam() {
    //对华为盒子的处理，首页键交由机顶盒
    var ua = window.navigator.userAgent;
    //alert("=====portal ua==111=="+ua);
    if (ua.indexOf("Ranger/3.0.0") > -1) {
        //alert("this is hw get key to stb");
        keySTBPortal(thirdbackUrl);
    }

    backurlparam += "?lastfocus=" + bottomMenuIndex + "_" + leftMenuIndex + "_" + startIndex + "_" + endIndex;
    top.jsSetControl("backurlparam", backurlparam);
    var lastChannelNum = top.channelInfo.currentChannel;
    if (isZTEBW == true) {
        ztebw.setAttribute("curMixno", lastChannelNum);
//        Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
        if ("CTCSetConfig" in Authentication) {
            Authentication.CTCSetConfig('EPGDomain', thirdbackUrl);
        } else {
            Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
        }
    } else {
        Authentication.CUSetConfig('EPGDomain', thirdbackUrl);
    }
}

function showChannelListByColumnid() {
    var requestUrl = "action/channellistbycolumnid.jsp?columnid=" + curcolumnid;
    var loaderSearch = new net.ContentLoader(requestUrl, showchannelbycolumnid);
}

function showchannelbycolumnid() {
    leftMenuIndex = 0;
    startIndex = 0;
    endIndex = 7;
    if ("0406" == curcolumnid) {
        leftMenuIndex = 1;
        endIndex = 6;
    }
    channelType = "channel";
    var results = this.req.responseText;
    var data = eval("(" + results + ")");
    tempArr = data.channelData;
    totalCount = tempArr.length;
    if (endIndex > totalCount) endIndex = totalCount;
    showChannelList();
}

function showChannelList() {
    columnArr = new Array();
    for (var i = startIndex; i < endIndex; i++) {
        columnArr.push(tempArr[i]);
    }
    length = columnArr.length;
    var tempColumnname = null;
    if ("0406" == curcolumnid) {
        $('left_menu_0').innerHTML = $("chanel_info").innerHTML;
        $('left_menu_0').style.visibility = 'visible';
        $('left_menu_0').style.color = "white";

        for (var i = 1; i < leftMenuCount; i++) {
            var m = i - 1;
            if (m < length) {

                var mixno = columnArr[m].mixno;
                if (mixno.length == 1) {
                    mixno = "00" + mixno;
                } else if (mixno.length == 2) {
                    mixno = "0" + mixno;
                }

                tempColumnname = writeFitString(columnArr[m].channelname, 20, 130);
                if (tempColumnname != columnArr[m].channelname) {
                    columnArr[m].hasBreak = '1';
                    columnArr[m].columnname = mixno + " " + columnArr[m].channelname;
                }
                $("left_menu_" + i).style.textAlign = "left";
                $('left_menu_' + i).innerText = mixno + " " + tempColumnname;
                $('left_menu_' + i).style.visibility = 'visible';
                $('left_menu_' + i).style.color = "white";
            } else {
                $('left_menu_' + i).innerText = '';
                $('left_menu_' + i).style.visibility = 'hidden';
            }

        }
        showupdowicon();
        changeLeftMenuFocus();
    } else {
        for (var i = 0; i < leftMenuCount; i++) {
            if (i < length) {
                var mixno = columnArr[i].mixno;
                if (mixno.length == 1) {
                    mixno = "00" + mixno;
                } else if (mixno.length == 2) {
                    mixno = "0" + mixno;
                }
                tempColumnname = writeFitString(columnArr[i].channelname, 20, 130);
                if (tempColumnname != columnArr[i].channelname) {
                    columnArr[i].hasBreak = '1';
                    columnArr[i].columnname = mixno + " " + columnArr[i].channelname;
                }
                $("left_menu_" + i).style.textAlign = "left";
                $('left_menu_' + i).innerText = mixno + " " + tempColumnname;
                $('left_menu_' + i).style.visibility = 'visible';
                $('left_menu_' + i).style.color = "white";
            } else {
                $('left_menu_' + i).innerText = '';
                $('left_menu_' + i).style.visibility = 'hidden';
            }
        }
        showupdowicon();
        changeLeftMenuFocus();
    }

}

function goUp() {
    if (bottomMenuIndex <= 7) {
        if ("0406" == curcolumnid) {
            if (leftMenuIndex > 1) {
                changeLeftMenuFocus(-1);
                leftMenuIndex--;
                changeLeftMenuFocus();
            } else if (leftMenuIndex == 1) {
                doLast();
            }
        } else {
            if (leftMenuIndex > 0) {
                changeLeftMenuFocus(-1);
                leftMenuIndex--
                changeLeftMenuFocus();
            } else if (leftMenuIndex == 0) {
                doLast();
            }
        }
    } else {
        //recommend_blur();
        // recommend_index--;
        obj_images_roll.list_dn();//up
        // if(recommend_index>=1){
        // recommend_focus();
        // }else{
        // recommend_index=recommend_length-1;
        // recommend_focus();
        // }
    }
}

function doLast() {
    if ("0406" == curcolumnid) {
        changeLeftMenuFocus(-1);
//    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) { //锟姐播
        if (bottomMenuIndex != 0) {
            if (startIndex > 0) {
                startIndex--;
                if (length == 6) endIndex--;
                goPage();
            } else if (startIndex == 0) {
                if (totalCount > 6) {
                    startIndex = totalCount - 6;
                    endIndex = totalCount;
                    leftMenuIndex = length;
                    goPage();
                } else {
                    leftMenuIndex = length;
                    changeLeftMenuFocus();
                }
            }
        } else {
            leftMenuIndex = length - 1;
            changeLeftMenuFocus();
        }
    } else {
        changeLeftMenuFocus(-1);
//    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) { //锟姐播
        if (bottomMenuIndex != 0) {
            if (startIndex > 0) {
                startIndex--;
                if (length == 7) endIndex--;
                goPage();
            } else if (startIndex == 0) {
                if (totalCount > 7) {
                    startIndex = totalCount - 7;
                    endIndex = totalCount;
                    leftMenuIndex = length - 1;
                    goPage();
                } else {
                    leftMenuIndex = length - 1;
                    changeLeftMenuFocus();
                }
            }
        } else {
            leftMenuIndex = length - 1;
            changeLeftMenuFocus();
        }
    }
}

function pageUp() {
    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) {
        if ("0406" == curcolumnid) {
            if (startIndex > 0) {
                if (startIndex >= 0 && endIndex > 15) {
                    startIndex -= 6;
                    endIndex = startIndex + 6;
                } else {
                    startIndex = 0;
                    endIndex = 6;
                }
                leftMenuIndex = 1;
                goPage();
            }

        } else {
            if (startIndex > 0) {
                if (startIndex >= 0 && endIndex > 15) {
                    startIndex -= 7;
                    endIndex = startIndex + 7;
                } else {
                    startIndex = 0;
                    endIndex = 7;
                }
                leftMenuIndex = 0;
                goPage();
            }
        }
    }
}

function pageDown() {
    if (bottomMenuIndex == 2 || bottomMenuIndex == 1 || (bottomMenuIndex == 3) || bottomMenuIndex == 4) {
        if ("0406" == curcolumnid) {
            if (endIndex < totalCount) {
                startIndex = endIndex;
                if ((endIndex + 6) <= totalCount) {
                    endIndex += 6;
                } else {
                    endIndex = totalCount;
                }
                leftMenuIndex = 1;
                goPage();
            }
        } else {
            if (endIndex < totalCount) {
                startIndex = endIndex;
                if ((endIndex + 7) <= totalCount) {
                    endIndex += 7;
                } else {
                    endIndex = totalCount;
                }
                leftMenuIndex = 0;
                goPage();
            }
        }
    }
}

function goPage() {
    switch (bottomMenuIndex) {
        case 1 :
            showTvodList();
            break;
        case 2 :
            showVodList();
            break;
        case 3 :
            showChannelPage();
            break;
        case 4 :
            showSpecalColumnlist();
            break;
        case 5 :
            showSpecalColumnlist();
            break;
        case 6 :
            showSpecalColumnlist();
            break;
        case 7 :
            showSpecalColumnlist();
            break;
        default :
            break;
    }
}

function showChannelPage() {
    if (channelType == "column") {
        showchannelcolumnlist();
    } else {
        showChannelList();
    }
}

function goDown() {
    if (bottomMenuIndex <= 7) {
        if ("0406" == curcolumnid) {

            changeLeftMenuFocus(-1);

            if (leftMenuIndex < length) {
                leftMenuIndex++;

                changeLeftMenuFocus();
            } else {

                doNext();
            }
        } else {
            changeLeftMenuFocus(-1);
            if (leftMenuIndex < length - 1) {
                leftMenuIndex++;
                changeLeftMenuFocus();
            } else {
                doNext();
            }
        }
//    else if (leftMenuIndex == leftMenuCount - 1) {
//        doNext();
//    }else{
//       leftMenuIndex=0;
//       changeLeftMenuFocus();
//    }
    } else {
        // recommend_blur();
        //recommend_index++;
        obj_images_roll.list_up();//down
        // if(recommend_index<recommend_length){
        // recommend_focus();
        // }else{
        // recommend_index=1;
        // recommend_focus();
        // }
    }

}

// function recommend_blur(){
// if($('recommend_focus_'+recommend_index+'_0')!=null && $('recommend_focus_'+recommend_index+'_0').style.visibility=="visible"){
// $('recommend_focus_'+recommend_index+'_0').style.visibility="hidden";
// }
// $('recommend_focus_'+recommend_index).style.visibility="hidden";
// }
// function recommend_focus(){
// $('recommend_focus_'+recommend_index).style.visibility="visible";
// }
function doNext() {

    if ("0406" == curcolumnid) {

        if (endIndex < totalCount) {
            startIndex++;
            endIndex++;
            //leftMenuIndex=1;
            goPage();
        } else {
            if (totalCount > 6) {
                startIndex = 0;
                endIndex = 6;
                leftMenuIndex = 1;
                goPage();
            } else {
                changeLeftMenuFocus(-1);
                leftMenuIndex = 1;
                changeLeftMenuFocus();
            }
        }
    } else {
        if (endIndex < totalCount) {
            startIndex++;
            endIndex++;
            goPage();
        } else {
            if (totalCount > 7) {
                startIndex = 0;
                endIndex = 7;
                leftMenuIndex = 0;
                goPage();
            } else {
                changeLeftMenuFocus(-1);
                leftMenuIndex = 0;
                changeLeftMenuFocus();
            }
        }
    }
}

function dotest() {
    return true;
}

function keyEPGPortal(serviceUrl) {
    var xml = '';
    xml += "<?xml version='1.0' encoding='UTF-8'?>";
    xml += '<global_keytable>';
    xml += '<response_define>';
    xml += '<key_code>KEY_PORTAL</key_code>';
    xml += '<response_type>1</response_type>';
    xml += '<service_url>' + serviceUrl + '</service_url>';
    xml += '</response_define>';
    xml += '</global_keytable>';
    Authentication.CUSetConfig("GlobalKeyTable", xml);
}

function keySTBPortal(serviceUrl) {
    var xml = '';
    xml += "<?xml version='1.0' encoding='UTF-8'?>";
    xml += '<global_keytable>';
    xml += '<response_define>';
    xml += '<key_code>KEY_PORTAL</key_code>';
    xml += '<response_type>2</response_type>';
    xml += '<service_url>' + serviceUrl + '</service_url>';
    xml += '</response_define>';
    xml += '</global_keytable>';
    Authentication.CUSetConfig("GlobalKeyTable", xml);
}

document.onkeypress = doKeyPress;


if (8 == bottomMenuIndex) {
    bottomMenuIndex = recommend_flag;
    showBottomMenu();
    $('left_focus_img').style.visibility = "hidden";
    bottomMenuIndex = 8;
    // if(leftMenuIndex>=2){
    // recommend_index = leftMenuIndex-2;
    // }
    recommend_index = recommend_indexa;
    load_page();
    $("rec_focus").style.visibility = "visible";
    $("rec_img_bg").style.visibility = "visible";
    $("rec_img").style.visibility = "visible";
    $("left_menua").style.display = "none";
    // if(recommend_focus_flag ==0){
    // $('recommend_focus_'+recommend_index).style.visibility='visible';
    // }else{
    // $('recommend_focus_'+recommend_index+'_0').style.visibility='visible';
    // }

} else {
    load_page();
    $("left_menua").style.display = "block";
    showBottomMenuTimer();
}

//4K STB_Check
if (stbType != "EC6108V9U_pub_bjjlt" && stbType != "Q1" && stbType != "B860A" && stbType != "HG680-JLGEH-52" && stbType != "Q5" && stbType != "EC5108" && stbType != "B860AV1.2" && stbType != "Q7" && stbType != "S-010W-A" && stbType != "DTTV100"&& stbType != "EC6108V9U_ONT_bjjlt") {
    if (ChannelNumPortal == 401 || ChannelNumPortal == 40) {
        $("alert_text").style.visibility = "visible";
    }
}
