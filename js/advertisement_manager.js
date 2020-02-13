var play_flag=1;//0是播放前贴片，1是不播
var play_flag_pic=0;//0是有广告位，1没有广告位
//《前贴片配置》
//回看前贴片配置
var tvod_gc="01010001000000010000000026834264";//01010001000000010000000011300964//01010001000000010000000026390358//01010001000000010000000023379328
var tvod_time=15;
//点播前贴片配置
var codelist=[
		//{category_id:"0H",global_code:"01010001000000010000000016442466",inverse_time:15},//2016欧洲杯HD
		{category_id:"16",global_code:"01010001000000010000000026834264",inverse_time:15},//HIFI影院
		{category_id:"08",global_code:"01010001000000010000000026834264",inverse_time:15},//电视剧场
		{category_id:"05",global_code:"01010001000000010000000026834264",inverse_time:15},//电影天地
		{category_id:"09",global_code:"01010001000000010000000026834264",inverse_time:15},//少儿动画
		{category_id:"0A",global_code:"01010001000000010000000026834264",inverse_time:15},//娱乐综艺
		{category_id:"0D",global_code:"01010001000000010000000026834264",inverse_time:15},//健康生活
		//{category_id:"1C",global_code:"",inverse_time:},//付费高清
		{category_id:"0B",global_code:"01010001000000010000000026834264",inverse_time:15},//第一体育
		{category_id:"03",global_code:"01010001000000010000000026834264",inverse_time:15},//新闻频道
		{category_id:"0C",global_code:"01010001000000010000000026834264",inverse_time:15},//纪实频道
		{category_id:"15",global_code:"01010001000000010000000026834264",inverse_time:15}//高清视场
		
];

var secondclonm=[
	{secclonm_id:"090C"},//baby淘奇包
	//{secclonm_id:"0C0C"}//纪实频道>顶级放送
];
//《广告位配置》
//按栏目区分的广告位配置
var column_pic=[
		{category_id:"default",info_pic:"taojuchang_330X110.jpg"},//广告位默认值。以下标0获取，请保持其元素位置。
		//{category_id:"05",info_pic:""},//电影

];
//按频道区分的广告位配置
var channel_pic=[
		{channel_id:"default",info_pic:"taojuchang_330X110.jpg"},//广告位默认值。以下标0获取，请保持其元素位置。
		//{channel_id:"350",info_pic:""},
];
//广告位通投部分
var advert_pic=[
		{areaName:"speed",picName:"220X110.jpg",picName1:"220X1101.jpg"},//播控--快进快退
		{areaName:"volume",picName:"220X110.jpg",picName1:"220X1102.jpg"},//音量条
	 	{areaName:"tvodInfo",picName:"taojuchang_330X110.jpg"},//点播信息条
		{areaName:"quit",picName:"306X230.jpg"}
];

//下线提示
var off_line_hint=[
	{category_id:"1C02",hint:
		["为向广大用户提供更多新片，每月1日、11日、21日将对本目录的影片进行下线",
			"处理，请您订购后及时观看。"]
	},
	{category_id:"1C01",hint:
		["为向广大用户提供更多新片，部分影片下线前将移至“即将下线”，望您知晓。"]
	},
	{category_id:"1C06",hint:
		["天天美剧烧脑季，全民一起拼IQ！【重磅推荐】超高评分佳作——《疑犯","追踪》；烧脑指数五颗星——《路德侦探》；英伦最佳律政剧《皇家律师》。"]
	}
];

//点播区分4K机顶盒
var model_4K=[
	{model:'EC6108V9U_pub_bjjlt'},
	{model:'Q1'},
	{model:'B860A'},
	{model:'HG680-JLGEH-52'}, 
	{model:'Q5'},
	{model:'EC5108'},
	{model:'B860AV1.2'},
	{model:'Q7'},
	{model:'S-010W-A'},
	{model:'EC6108V9U_ONT_bjjlt'},
	{model:'DTTV100'}
];

var vodId_4k = [
	{name:'功夫熊猫2（HD）',id:'0000000030010000274453'},
	{name:'阿凡达',id:'0000000030010000274790'}
];

//广告位跳转
var advert_pic_jump=[
	{name:'live1',url:'channel_play.jsp?mixno=037&isforjump=1'},
	{name:'live2',url:'channel_play.jsp?mixno=038&isforjump=1'},
	{name:'live6',url:'channel_play.jsp?mixno=039&isforjump=1'},
	{name:'live4',url:'channel_play.jsp?mixno=040&isforjump=1'},
	{name:'live5',url:'channel_play.jsp?mixno=030&isforjump=1'},
	{name:'live3',url:'channel_play.jsp?mixno=035&isforjump=1'},
	{name:'pic',url:'zhuanti_picture.jsp'}
];
//二级分类跳转直播
var cat_live_jump=[
	{columnIdSecond:'0803',url:'channel_play.jsp?mixno=37',pic:'JP_TaoJuchang.jpg',focuspic:'JP_focupic.png'},//--淘剧场
	{columnIdSecond:'0509',url:'channel_play.jsp?mixno=38',pic:'JP_Taodianying.jpg',focuspic:'JP_focupic.png'},//--淘电影
	{columnIdSecond:'0D0J',url:'channel_play.jsp?mixno=30',pic:'JP_Dajiankang.jpg',focuspic:'JP_focupic.png'},//--大健康
	{columnIdSecond:'0Q06',url:'channel_play.jsp?mixno=40',pic:'JP_4kchaoqing.jpg',focuspic:'JP_focupic.png'},//--4k超清
	{columnIdSecond:'0Q02',url:'channel_play.jsp?mixno=36',pic:'JP_TaoBady.jpg',focuspic:'JP_focupic.png'},//淘Bady
	{columnIdSecond:'0Q03',url:'channel_play.jsp?mixno=37',pic:'JP_TaoJuchang.jpg',focuspic:'JP_focupic.png'},//淘剧场
	{columnIdSecond:'0Q04',url:'channel_play.jsp?mixno=38',pic:'JP_Taodianying.jpg',focuspic:'JP_focupic.png'},//淘电影
	{columnIdSecond:'0Q05',url:'channel_play.jsp?mixno=39',pic:'JP_Taoyuanle.jpg',focuspic:'JP_focupic.png'},//淘娱乐
	{columnIdSecond:'0Q01',url:'channel_play.jsp?mixno=35',pic:'JP_DOGTV.png',focuspic:'JP_focupic.png'},//DOGTV
	{columnIdSecond:'0Q00',url:'channel_play.jsp?mixno=30',pic:'JP_Dajiankang.jpg',focuspic:'JP_focupic.png'},//大健康
	
];

//备注按ID显示内容
var remark_id=[
	{productid:"100321",productremark:"超值推荐套餐！含淘电影+淘剧场，仅3.99元！"},
	{productid:"100322",productremark:"淘电影"},
  	{productid:"100323",productremark:"淘剧场"},
	{productid:"100320",productremark:"花一杯咖啡的钱，换一种高品质的生活，对辛苦的自己好点吧！"},
	{productid:"100326",productremark:"国内外热播动画 科学幼教体系 一切只为童心"},
	{productid:"100331",productremark:"推荐订购！超值纯享套餐，含淘电影+淘剧场！"},
	//{productid:"100329",productremark:"一听啤酒钱，全家看大片！"},
	{productid:"100329",productremark:""},
  	{productid:"100330",productremark:"一根冰棍儿钱，好剧天天看！"},
	{productid:"100333",productremark:"宠“物”就是宠自己！每天不到一块钱，每天给它多一份爱！"}
];

var order_id=[
	{productid:"100320",truepri:"39.9元"},//4K超清
	{productid:"100326",truepri:"19.9元"},//淘baby
];

var channel_order_bg=[
    {channel_id:"40",info_pic:"order_select_hbdg.png"},//4K超清
    {channel_id:"36",info_pic:"order_select_hbdg.png"},
    {channel_id:"37",info_pic:"order_select_hbdg.png"},
    {channel_id:"38",info_pic:"order_select_hbdg.png"},
    {channel_id:"307",info_pic:"order_select_dogtv.png"},
	{channel_id:"35",info_pic:"order_select_hbdg.png"},
	{channel_id:"39",info_pic:"order_select_hbdg.png"},
    {channel_id:"505",info_pic:"order_select_taojuchang.png"},
    {channel_id:"521",info_pic:"order_select_taodianying.png"},
    {channel_id:"515",info_pic:"order_select_taoyingshi.png"},
    {channel_id:"502",info_pic:"order_select_dianjingshijie.png"},
    {channel_id:"320",info_pic:"order_select_hbdg.png"},
    {channel_id:"321",info_pic:"order_select_hbdg.png"}

	/*{channel_id:"501",info_pic:"order_select_4k.png"},
	{channel_id:"502",info_pic:"order_select_4k.png"},
	{channel_id:"505",info_pic:"order_select_dogtv.png"},
	{channel_id:"520",info_pic:"order_select_4k.png"},
	{channel_id:"521",info_pic:"order_select_dogtv.png"}*/
];

var select_bg_by_proid=[
	{productid:"100320",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_0.png"},//4K超清包月
	{productid:"100326",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby.png"},//淘baby包月
	{productid:"100331",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi.png"},//淘影视
    {productid:"100417",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_30.png"},//淘影视-30天
    {productid:"100418",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_90.png"},//淘影视-90天
    {productid:"100419",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_365.png"},//淘影视-365天
	{productid:"100330",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang.png"},//淘剧场
	{productid:"100329",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying.png"},//淘电影
	{productid:"100333",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv.png"},//DOGTV
	{productid:"100347",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule.png"},//淘娱乐
	{productid:"100334",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_24wx.png"},//4K超清-24小时乐享
	{productid:"100356",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_15.png"},//淘baby-15天
	{productid:"100360",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_15.png"},//4K超清-15天
	{productid:"100364",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_15.png"},//DOGTV-15天
	{productid:"100371",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_15.png"},
	
	{productid:"100354",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_30.png"},//淘baby-30天
	{productid:"100355",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_90.png"},//淘baby-90天
	{productid:"100357",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_365.png"},//淘baby-365天
	{productid:"100358",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_30.png"},//4K超清-30天
	{productid:"100359",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_90.png"},//4K超清-90天
	{productid:"100361",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_365.png"},//4K超清-365天
	{productid:"100362",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_30.png"},//DOGTV-30天
	{productid:"100363",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_90.png"},//DOGTV-90天
	{productid:"100365",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_365.png"},//DOGTV-365天
	//{productid:"100343",info_pic:"order_select_test_activity_product.png",focus_pic:"select_left_test_activity_product.png"},//专题专享测试
	{productid:"100372",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_30.png"},//淘娱乐-30天
	{productid:"100373",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_90.png"},//淘娱乐-90天
	{productid:"100374",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_365.png"},//淘娱乐-365天
	//9月21日新产品测试
    {productid:"100380",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_30.png"},//淘电影-30天
    {productid:"100381",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_90.png"},//淘电影-90天
    {productid:"100382",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_365.png"},//淘电影-3650天
    {productid:"100383",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_30.png"},//淘剧场-30天
    {productid:"100384",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_90.png"},//淘剧场-90天
    {productid:"100385",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_365.png"},//淘剧场-365天

    {productid:"100441",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_30.png"},//190228测试
    {productid:"100442",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_90.png"},//190228测试
    {productid:"100443",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_365.png"},//190228测试

    {productid:"100399",info_pic:"order_select_kuailechuidiao.png",focus_pic:"select_left_kuailechuidiao.png"},
    {productid:"100465",info_pic:"order_select_kuailechuidiao.png",focus_pic:"select_left_kuailechuidiao_30.png"},
    {productid:"100466",info_pic:"order_select_kuailechuidiao.png",focus_pic:"select_left_kuailechuidiao_365.png"},

    {productid:"100398",info_pic:"order_select_chapindao.png",focus_pic:"select_left_chapindao.png"},
    {productid:"666666",info_pic:"order_select_hbdg.png",focus_pic:"select_left_hbdg.jpg"},
    {productid:"100467",info_pic:"order_select_chapindao.png",focus_pic:"select_left_chapindao_30.png"},
    {productid:"100468",info_pic:"order_select_chapindao.png",focus_pic:"select_left_chapindao_365.png"},
	{productid:"100327",info_pic:"order_select_babytaoqibao.png",focus_pic:"select_left_babytaoqibao.png"},
	{productid:"100453",info_pic:"order_select_babytaoqibao.png",focus_pic:"select_left_babytaoqibao_30.png"},
	{productid:"100455",info_pic:"order_select_babytaoqibao.png",focus_pic:"select_left_babytaoqibao_365.png"}



  /* 
  {productid:"100354",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_30.png"},//淘baby-30天
  {productid:"100355",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_90.png"},//淘baby-90天
  {productid:"100357",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_365.png"},//淘baby-365天
  {productid:"100358",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_30.png"},//4K超清-30天
  {productid:"100359",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_90.png"},//4K超清-90天
  {productid:"100361",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_365.png"},//4K超清-365天
  {productid:"100362",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_30.png"},//DOGTV-30天
  {productid:"100363",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_90.png"},//DOGTV-90天
  {productid:"100365",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_365.png"},//DOGTV-365天
  {productid:"100372",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_30.png"},//淘娱乐-30天
  {productid:"100373",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_90.png"},//淘娱乐-90天
  {productid:"100374",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_365.png"},//淘娱乐-365天*/
];


/*
配置直播付费产品
第一行为包月产品 1:宽带支付，2:取消
第二行为包天产品 1:微信支付，2:取消
第三行为包时段产品 1:微信支付，2:宽带支付，3:取消

*/
var channel_product_arr=[
	{productid:['100320','100326','100331','100330','100329','100333','100347','100399','100398','100327'],btn_pic:['pay_kd_btn.png','quit.png'],func_ok:['pay_kd()','doback()']},
	{productid:['100356','100360','100364','100371','100354','100355','100357','100358','100359','100361','100362','100363','100365','100372','100373','100374','100380','100381','100382','100383','100384','100385','100417','100418','100419','100441','100442','100443','100465','100466','100467','100468','100453','100455'],btn_pic:['pay_wx_btn.png','quit.png'],func_ok:['pay_wx()','doback()']},
	{productid:['100334'],btn_pic:['pay_wx_btn.png','pay_kd_btn.png','quit.png'],func_ok:['pay_wx()','pay_kd()','doback()']},
	{productid:['666666'],btn_pic:['pay_hbdg.png','quit.png'],func_ok:['pay_hb()','doback()']}
];

/*//根据频道号显示不同的推荐图片
var channel_order_rec = 0;//0为自动根据频道号显示图片，1是无 
var channel_order_bg=[
		{channel_id:"default",info_pic:"order_live_goods.png"},//底图默认值。以下标0获取，请保持其元素位置。
		{channel_id:"36",info_pic:"order_live_baby.png"}
];
var channel_order_icon=[
		{channel_id:"40",info_pic:"4k_icon.jpg"},//推荐小图默认值。以下标0获取，请保持其元素位置。
		{channel_id:"36",info_pic:"taobaby_icon.jpg"},
		{channel_id:"37",info_pic:"taojuchang_icon.jpg"},
		{channel_id:"38",info_pic:"taodianying_icon.jpg"},
		{channel_id:"307",info_pic:"dogtv_icon.png"}
];
var channel_order_poster=[
		{channel_id:"40",info_pic:"4k_poster.jpg"},//海报默认值。以下标0获取，请保持其元素位置。
		{channel_id:"36",info_pic:"taobaby_poster.jpg"},
		{channel_id:"37",info_pic:"taojuchang_poster.jpg"},
		{channel_id:"38",info_pic:"taodianying_poster.jpg"},
		{channel_id:"307",info_pic:"dogtv_poster.jpg"}
];*/

/*
	点播订购配置：
	第一行为包月产品
	第二行为包天产品
	第三行为包时段产品（暂拿一个包年的测试）

var vod_product_arr=[
	{productid:['100325','100316','100313','100315'],btn_pic:['vod_kd_btn.png','vod_quit_btn.png'],func_ok:['pay_kd()','doback()']},
	{productid:['100102','100205'],btn_pic:['vod_wx_btn.png','vod_quit_btn.png'],func_ok:['pay_wx()','doback()']},
	{productid:['100318'],btn_pic:['vod_wx_btn.png','vod_kd_btn.png','vod_quit_btn.png'],func_ok:['pay_wx()','pay_kd()','doback()']}
];*/