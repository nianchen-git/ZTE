var play_flag=1;//0�ǲ���ǰ��Ƭ��1�ǲ���
var play_flag_pic=0;//0���й��λ��1û�й��λ
//��ǰ��Ƭ���á�
//�ؿ�ǰ��Ƭ����
var tvod_gc="01010001000000010000000026834264";//01010001000000010000000011300964//01010001000000010000000026390358//01010001000000010000000023379328
var tvod_time=15;
//�㲥ǰ��Ƭ����
var codelist=[
		//{category_id:"0H",global_code:"01010001000000010000000016442466",inverse_time:15},//2016ŷ�ޱ�HD
		{category_id:"16",global_code:"01010001000000010000000026834264",inverse_time:15},//HIFIӰԺ
		{category_id:"08",global_code:"01010001000000010000000026834264",inverse_time:15},//���Ӿ糡
		{category_id:"05",global_code:"01010001000000010000000026834264",inverse_time:15},//��Ӱ���
		{category_id:"09",global_code:"01010001000000010000000026834264",inverse_time:15},//�ٶ�����
		{category_id:"0A",global_code:"01010001000000010000000026834264",inverse_time:15},//��������
		{category_id:"0D",global_code:"01010001000000010000000026834264",inverse_time:15},//��������
		//{category_id:"1C",global_code:"",inverse_time:},//���Ѹ���
		{category_id:"0B",global_code:"01010001000000010000000026834264",inverse_time:15},//��һ����
		{category_id:"03",global_code:"01010001000000010000000026834264",inverse_time:15},//����Ƶ��
		{category_id:"0C",global_code:"01010001000000010000000026834264",inverse_time:15},//��ʵƵ��
		{category_id:"15",global_code:"01010001000000010000000026834264",inverse_time:15}//�����ӳ�
		
];

var secondclonm=[
	{secclonm_id:"090C"},//baby�����
	//{secclonm_id:"0C0C"}//��ʵƵ��>��������
];
//�����λ���á�
//����Ŀ���ֵĹ��λ����
var column_pic=[
		{category_id:"default",info_pic:"taojuchang_330X110.jpg"},//���λĬ��ֵ�����±�0��ȡ���뱣����Ԫ��λ�á�
		//{category_id:"05",info_pic:""},//��Ӱ

];
//��Ƶ�����ֵĹ��λ����
var channel_pic=[
		{channel_id:"default",info_pic:"taojuchang_330X110.jpg"},//���λĬ��ֵ�����±�0��ȡ���뱣����Ԫ��λ�á�
		//{channel_id:"350",info_pic:""},
];
//���λͨͶ����
var advert_pic=[
		{areaName:"speed",picName:"220X110.jpg",picName1:"220X1101.jpg"},//����--�������
		{areaName:"volume",picName:"220X110.jpg",picName1:"220X1102.jpg"},//������
	 	{areaName:"tvodInfo",picName:"taojuchang_330X110.jpg"},//�㲥��Ϣ��
		{areaName:"quit",picName:"306X230.jpg"}
];

//������ʾ
var off_line_hint=[
	{category_id:"1C02",hint:
		["Ϊ�����û��ṩ������Ƭ��ÿ��1�ա�11�ա�21�ս��Ա�Ŀ¼��ӰƬ��������",
			"��������������ʱ�ۿ���"]
	},
	{category_id:"1C01",hint:
		["Ϊ�����û��ṩ������Ƭ������ӰƬ����ǰ���������������ߡ�������֪����"]
	},
	{category_id:"1C06",hint:
		["�����������Լ���ȫ��һ��ƴIQ�����ذ��Ƽ����������ּ����������ɷ�","׷�١�������ָ������ǡ�����·����̽����Ӣ����������硶�ʼ���ʦ����"]
	}
];

//�㲥����4K������
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
	{name:'������è2��HD��',id:'0000000030010000274453'},
	{name:'������',id:'0000000030010000274790'}
];

//���λ��ת
var advert_pic_jump=[
	{name:'live1',url:'channel_play.jsp?mixno=037&isforjump=1'},
	{name:'live2',url:'channel_play.jsp?mixno=038&isforjump=1'},
	{name:'live6',url:'channel_play.jsp?mixno=039&isforjump=1'},
	{name:'live4',url:'channel_play.jsp?mixno=040&isforjump=1'},
	{name:'live5',url:'channel_play.jsp?mixno=030&isforjump=1'},
	{name:'live3',url:'channel_play.jsp?mixno=035&isforjump=1'},
	{name:'pic',url:'zhuanti_picture.jsp'}
];
//����������תֱ��
var cat_live_jump=[
	{columnIdSecond:'0803',url:'channel_play.jsp?mixno=37',pic:'JP_TaoJuchang.jpg',focuspic:'JP_focupic.png'},//--�Ծ糡
	{columnIdSecond:'0509',url:'channel_play.jsp?mixno=38',pic:'JP_Taodianying.jpg',focuspic:'JP_focupic.png'},//--�Ե�Ӱ
	{columnIdSecond:'0D0J',url:'channel_play.jsp?mixno=30',pic:'JP_Dajiankang.jpg',focuspic:'JP_focupic.png'},//--�󽡿�
	{columnIdSecond:'0Q06',url:'channel_play.jsp?mixno=40',pic:'JP_4kchaoqing.jpg',focuspic:'JP_focupic.png'},//--4k����
	{columnIdSecond:'0Q02',url:'channel_play.jsp?mixno=36',pic:'JP_TaoBady.jpg',focuspic:'JP_focupic.png'},//��Bady
	{columnIdSecond:'0Q03',url:'channel_play.jsp?mixno=37',pic:'JP_TaoJuchang.jpg',focuspic:'JP_focupic.png'},//�Ծ糡
	{columnIdSecond:'0Q04',url:'channel_play.jsp?mixno=38',pic:'JP_Taodianying.jpg',focuspic:'JP_focupic.png'},//�Ե�Ӱ
	{columnIdSecond:'0Q05',url:'channel_play.jsp?mixno=39',pic:'JP_Taoyuanle.jpg',focuspic:'JP_focupic.png'},//������
	{columnIdSecond:'0Q01',url:'channel_play.jsp?mixno=35',pic:'JP_DOGTV.png',focuspic:'JP_focupic.png'},//DOGTV
	{columnIdSecond:'0Q00',url:'channel_play.jsp?mixno=30',pic:'JP_Dajiankang.jpg',focuspic:'JP_focupic.png'},//�󽡿�
	
];

//��ע��ID��ʾ����
var remark_id=[
	{productid:"100321",productremark:"��ֵ�Ƽ��ײͣ����Ե�Ӱ+�Ծ糡����3.99Ԫ��"},
	{productid:"100322",productremark:"�Ե�Ӱ"},
  	{productid:"100323",productremark:"�Ծ糡"},
	{productid:"100320",productremark:"��һ�����ȵ�Ǯ����һ�ָ�Ʒ�ʵ������������Լ��õ�ɣ�"},
	{productid:"100326",productremark:"�������Ȳ����� ��ѧ�׽���ϵ һ��ֻΪͯ��"},
	{productid:"100331",productremark:"�Ƽ���������ֵ�����ײͣ����Ե�Ӱ+�Ծ糡��"},
	//{productid:"100329",productremark:"һ��ơ��Ǯ��ȫ�ҿ���Ƭ��"},
	{productid:"100329",productremark:""},
  	{productid:"100330",productremark:"һ��������Ǯ���þ����쿴��"},
	{productid:"100333",productremark:"�衰����ǳ��Լ���ÿ�첻��һ��Ǯ��ÿ�������һ�ݰ���"}
];

var order_id=[
	{productid:"100320",truepri:"39.9Ԫ"},//4K����
	{productid:"100326",truepri:"19.9Ԫ"},//��baby
];

var channel_order_bg=[
    {channel_id:"40",info_pic:"order_select_hbdg.png"},//4K����
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
	{productid:"100320",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_0.png"},//4K�������
	{productid:"100326",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby.png"},//��baby����
	{productid:"100331",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi.png"},//��Ӱ��
    {productid:"100417",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_30.png"},//��Ӱ��-30��
    {productid:"100418",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_90.png"},//��Ӱ��-90��
    {productid:"100419",info_pic:"order_select_taoyingshi.png",focus_pic:"select_left_taoyingshi_365.png"},//��Ӱ��-365��
	{productid:"100330",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang.png"},//�Ծ糡
	{productid:"100329",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying.png"},//�Ե�Ӱ
	{productid:"100333",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv.png"},//DOGTV
	{productid:"100347",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule.png"},//������
	{productid:"100334",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_24wx.png"},//4K����-24Сʱ����
	{productid:"100356",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_15.png"},//��baby-15��
	{productid:"100360",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_15.png"},//4K����-15��
	{productid:"100364",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_15.png"},//DOGTV-15��
	{productid:"100371",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_15.png"},
	
	{productid:"100354",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_30.png"},//��baby-30��
	{productid:"100355",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_90.png"},//��baby-90��
	{productid:"100357",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_365.png"},//��baby-365��
	{productid:"100358",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_30.png"},//4K����-30��
	{productid:"100359",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_90.png"},//4K����-90��
	{productid:"100361",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_365.png"},//4K����-365��
	{productid:"100362",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_30.png"},//DOGTV-30��
	{productid:"100363",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_90.png"},//DOGTV-90��
	{productid:"100365",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_365.png"},//DOGTV-365��
	//{productid:"100343",info_pic:"order_select_test_activity_product.png",focus_pic:"select_left_test_activity_product.png"},//ר��ר�����
	{productid:"100372",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_30.png"},//������-30��
	{productid:"100373",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_90.png"},//������-90��
	{productid:"100374",info_pic:"order_select_taoyule.png",focus_pic:"select_left_taoyule_365.png"},//������-365��
	//9��21���²�Ʒ����
    {productid:"100380",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_30.png"},//�Ե�Ӱ-30��
    {productid:"100381",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_90.png"},//�Ե�Ӱ-90��
    {productid:"100382",info_pic:"order_select_taodianying.png",focus_pic:"select_left_taodianying_365.png"},//�Ե�Ӱ-3650��
    {productid:"100383",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_30.png"},//�Ծ糡-30��
    {productid:"100384",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_90.png"},//�Ծ糡-90��
    {productid:"100385",info_pic:"order_select_taojuchang.png",focus_pic:"select_left_taojuchang_365.png"},//�Ծ糡-365��

    {productid:"100441",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_30.png"},//190228����
    {productid:"100442",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_90.png"},//190228����
    {productid:"100443",info_pic:"order_select_dianjingshijie.png",focus_pic:"select_left_dianjingshijie_365.png"},//190228����

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
  {productid:"100354",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_30.png"},//��baby-30��
  {productid:"100355",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_90.png"},//��baby-90��
  {productid:"100357",info_pic:"order_select_taobaby.png",focus_pic:"select_left_taobaby_365.png"},//��baby-365��
  {productid:"100358",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_30.png"},//4K����-30��
  {productid:"100359",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_90.png"},//4K����-90��
  {productid:"100361",info_pic:"order_select_4k.png",focus_pic:"select_left_4k_365.png"},//4K����-365��
  {productid:"100362",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_30.png"},//DOGTV-30��
  {productid:"100363",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_90.png"},//DOGTV-90��
  {productid:"100365",info_pic:"order_select_dogtv.png",focus_pic:"select_left_dogtv_365.png"},//DOGTV-365��
  {productid:"100372",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_30.png"},//������-30��
  {productid:"100373",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_90.png"},//������-90��
  {productid:"100374",info_pic:"order_select_4k.png",focus_pic:"select_left_taoyule_365.png"},//������-365��*/
];


/*
����ֱ�����Ѳ�Ʒ
��һ��Ϊ���²�Ʒ 1:���֧����2:ȡ��
�ڶ���Ϊ�����Ʒ 1:΢��֧����2:ȡ��
������Ϊ��ʱ�β�Ʒ 1:΢��֧����2:���֧����3:ȡ��

*/
var channel_product_arr=[
	{productid:['100320','100326','100331','100330','100329','100333','100347','100399','100398','100327'],btn_pic:['pay_kd_btn.png','quit.png'],func_ok:['pay_kd()','doback()']},
	{productid:['100356','100360','100364','100371','100354','100355','100357','100358','100359','100361','100362','100363','100365','100372','100373','100374','100380','100381','100382','100383','100384','100385','100417','100418','100419','100441','100442','100443','100465','100466','100467','100468','100453','100455'],btn_pic:['pay_wx_btn.png','quit.png'],func_ok:['pay_wx()','doback()']},
	{productid:['100334'],btn_pic:['pay_wx_btn.png','pay_kd_btn.png','quit.png'],func_ok:['pay_wx()','pay_kd()','doback()']},
	{productid:['666666'],btn_pic:['pay_hbdg.png','quit.png'],func_ok:['pay_hb()','doback()']}
];

/*//����Ƶ������ʾ��ͬ���Ƽ�ͼƬ
var channel_order_rec = 0;//0Ϊ�Զ�����Ƶ������ʾͼƬ��1���� 
var channel_order_bg=[
		{channel_id:"default",info_pic:"order_live_goods.png"},//��ͼĬ��ֵ�����±�0��ȡ���뱣����Ԫ��λ�á�
		{channel_id:"36",info_pic:"order_live_baby.png"}
];
var channel_order_icon=[
		{channel_id:"40",info_pic:"4k_icon.jpg"},//�Ƽ�СͼĬ��ֵ�����±�0��ȡ���뱣����Ԫ��λ�á�
		{channel_id:"36",info_pic:"taobaby_icon.jpg"},
		{channel_id:"37",info_pic:"taojuchang_icon.jpg"},
		{channel_id:"38",info_pic:"taodianying_icon.jpg"},
		{channel_id:"307",info_pic:"dogtv_icon.png"}
];
var channel_order_poster=[
		{channel_id:"40",info_pic:"4k_poster.jpg"},//����Ĭ��ֵ�����±�0��ȡ���뱣����Ԫ��λ�á�
		{channel_id:"36",info_pic:"taobaby_poster.jpg"},
		{channel_id:"37",info_pic:"taojuchang_poster.jpg"},
		{channel_id:"38",info_pic:"taodianying_poster.jpg"},
		{channel_id:"307",info_pic:"dogtv_poster.jpg"}
];*/

/*
	�㲥�������ã�
	��һ��Ϊ���²�Ʒ
	�ڶ���Ϊ�����Ʒ
	������Ϊ��ʱ�β�Ʒ������һ������Ĳ��ԣ�

var vod_product_arr=[
	{productid:['100325','100316','100313','100315'],btn_pic:['vod_kd_btn.png','vod_quit_btn.png'],func_ok:['pay_kd()','doback()']},
	{productid:['100102','100205'],btn_pic:['vod_wx_btn.png','vod_quit_btn.png'],func_ok:['pay_wx()','doback()']},
	{productid:['100318'],btn_pic:['vod_wx_btn.png','vod_kd_btn.png','vod_quit_btn.png'],func_ok:['pay_wx()','pay_kd()','doback()']}
];*/