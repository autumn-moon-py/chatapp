import 'dart:convert';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import 'send.dart';
import 'trend.dart';

SharedPreferences? local; //本地存储数据
bool isNewImage = true; //AI图鉴
bool scrolling = true; //自动滚屏
bool waitTyping = false; //打字时间
bool waitOffline = true; //是否等待下线
int nowMikoAvater = 1; //miko当前头像
String playerAvatarSet = '默认'; //玩家头像
int playerNowAvater = 0; //玩家头像下拉框默认值
String choose_one = ''; //选项一
String choose_two = ''; //选项二
List messages = []; //消息容器列表
List<String> messagesInfo = []; //消息信息列表
List trends = []; //动态容器列表
List<String> trendsInfo = []; //动态信息列表
String chatName = "Miko"; //聊天对象名称
List<String> imageList = imageList1; //图鉴列表
bool backgroundMusicSwitch = false; //音乐
bool isOldBgm = false; //新旧BGM
final bgmplayer = AudioPlayer();
bool buttonMusicSwitch = true; //音效
double sliderValue = 10; //语音音量
final buttonplayer = AudioPlayer();
final voiceplayer = AudioPlayer();
late String version; //应用发布版本号
List<List<dynamic>> story = []; //剧本列表
String nowChapter = '第一章'; //当前章节

///Miko头像更换
List mikoDropdownList = [
  {'label': '头像1', 'value': 1},
  {'label': '头像2', 'value': 2},
  {'label': '头像3', 'value': 3},
  {'label': '头像4', 'value': 4},
  {'label': '头像5', 'value': 5},
  {'label': '头像6', 'value': 6},
  {'label': '头像7', 'value': 7},
  {'label': '头像8', 'value': 8}
];
List playerDropdownList = [
  {'label': '默认头像', 'value': 0},
  {'label': '上传图片', 'value': 1}
];

///旧图鉴
const List<String> imageList1 = [
  'S1-01',
  'S1-02',
  'S1-03',
  'S1-04',
  'S1-05',
  'E1-01',
  'E1-02',
  'E1-03',
  'S2-01',
  'S2-02',
  'S2-03',
  'S2-04',
  'S2-05',
  'S2-06',
  'S2-07',
  'S2-08',
  'E2-01',
  'E2-02',
  'E2-03',
  'E2-04',
  'S3-01',
  'S3-02',
  'S3-03',
  'S3-04',
  'E3-01',
  'E3-02',
  'E3-03',
  'S4-01',
  'S4-02',
  'S4-03',
  'S4-04',
  'S4-05',
  'S4-06',
  'S5-01',
  'S5-02',
  'S5-03',
  'S5-04',
  'S5-05',
  'S5-06',
  'S6-01',
  'S6-02',
  'S6-03',
  'S6-04',
  'S6-05',
  'S6-06',
  'S6-07',
  'W1-01',
  'W1-02',
  'W1-03',
  'W1-04',
  'W1-05',
  'W1-06',
  'W1-07',
  'W1-08',
  'W1-09',
];

///新图鉴
const List<String> imageList2 = [
  'S1-01-n',
  'S1-02',
  'S1-03',
  'S1-04',
  'S1-05-n',
  'E1-01-n',
  'E1-02',
  'E1-03-n',
  'S2-01-n',
  'S2-02',
  'S2-03',
  'S2-04',
  'S2-05',
  'S2-06',
  'S2-07',
  'S2-08',
  'E2-01',
  'E2-02',
  'E2-03',
  'E2-04',
  'S3-01-n',
  'S3-02',
  'S3-03-n',
  'S3-04-n',
  'E3-01',
  'E3-02',
  'E3-03',
  'S4-01-n',
  'S4-02',
  'S4-03-n',
  'S4-04',
  'S4-05-n',
  'S4-06-n',
  'S5-01-n',
  'S5-02-n',
  'S5-03-n',
  'S5-04-n',
  'S5-05',
  'S5-06',
  'S6-01',
  'S6-02',
  'S6-03',
  'S6-04',
  'S6-05',
  'S6-06',
  'S6-07',
  'W1-01',
  'W1-02',
  'W1-03',
  'W1-04',
  'W1-05',
  'W1-06',
  'W1-07',
  'W1-08',
  'W1-09',
];

///图鉴解锁
Map imageMap = {
  '0': false,
  'E1-01-n': false,
  'E1-01': false,
  'E1-02': false,
  'E1-03-n': false,
  'E1-03': false,
  'E2-01': false,
  'E2-02': false,
  'E2-03': false,
  'E2-04': false,
  'E3-01': false,
  'E3-02': false,
  'E3-03': false,
  'S1-01-n': true,
  'S1-01': true,
  'S1-02': false,
  'S1-03': false,
  'S1-04': false,
  'S1-05-n': false,
  'S1-05': false,
  'S2-01-n': false,
  'S2-01': false,
  'S2-02': false,
  'S2-03': false,
  'S2-04': false,
  'S2-05': false,
  'S2-06': false,
  'S2-07': false,
  'S2-08': false,
  'S3-01-n': false,
  'S3-01': false,
  'S3-02': false,
  'S3-03-n': false,
  'S3-03': false,
  'S3-04-n': false,
  'S3-04': false,
  'S4-01-n': false,
  'S4-01': false,
  'S4-02': false,
  'S4-03-n': false,
  'S4-03': false,
  'S4-04': false,
  'S4-05-n': false,
  'S4-05': false,
  'S4-06-n': false,
  'S4-06': false,
  'S5-01-n': false,
  'S5-01': false,
  'S5-02-n': false,
  'S5-02': false,
  'S5-03-n': false,
  'S5-03': false,
  'S5-04-n': false,
  'S5-04': false,
  'S5-05': false,
  'S5-06': false,
  'S6-01': false,
  'S6-02': false,
  'S6-03': false,
  'S6-04': false,
  'S6-05': false,
  'S6-06': false,
  'S6-07': false,
  'W1-01': false,
  'W1-02': false,
  'W1-03': false,
  'W1-04': false,
  'W1-05': false,
  'W1-06': false,
  'W1-07': false,
  'W1-08': false,
  'W1-09': false
};

///章节列表
const List chapterList = [
  '第一章',
  '番外一',
  '第二章',
  '番外二',
  '第三章',
  '番外三',
  '第四章',
  '第五章',
  '第六章'
];

///词典列表
const List dictionaryList = [
  '软件',
  '西武百货',
  '悠哈盐味奶糖',
  'flash',
  '跳步侧踢',
  '跆拳道蓝带',
  '蓝带厨艺学院',
  '红丝绒蛋糕',
  '蒙德里安',
  'Miko',
  '摸木头',
  'Coquille',
  'JK制服',
  '炮姐',
  '抖M',
  '女贞',
  '威士忌酱烤肋排',
  '《美的历史》',
  '42',
  '摩斯密码',
  '425A',
  '莫西莫西',
  '《傅科摆》',
  '《玫瑰的名字》',
  'dirndl裙',
  'ky',
  'lo娘茶会',
  '艾丽丝',
  '本乡奏多',
  '锦户亮',
  '纽约重芝士蛋糕',
  '皮尔斯',
  '皮卡丘',
  '屁股',
  '圣心教堂',
  '夏尔',
  'Tango One',
  'uno',
  '变色牌',
  '色牌',
  '万能牌',
  '修仙',
  '熵',
  '门房',
  '波斯王子时之砂',
  'NPC',
  'Italian Job',
  '西奥科技',
  '思泰基金',
  '清盘',
  '注会',
  '创伤心理',
  'Simulacra',
  '白学现场',
  '苏菲',
  '尬聊',
  '42街',
  'DeStijl',
  '克莱因瓶',
  '傅科摆',
  '神秘海域',
  '平行宇宙',
  '成田机场',
  '银联',
  '豚骨拉面',
  '全家',
  '上野',
  '玉子烧',
  '关东煮',
  '神社',
  '五重塔',
  '上野公园',
  '绘马',
  '东京国立博物馆',
  '东京旧音乐学院',
  '回转寿司',
  '中二',
  '2014',
  '都市传说',
  'Eric',
  'Mark',
  '生物效应',
  '时序保护',
  '闭合时曲线',
  '12只猴子',
  'Dva',
  '管风琴',
  '群青组',
  '藤校',
  '约拿',
  '米仓凉子',
  '天海佑希',
  'lily',
  '六分仪',
  '维特鲁威人',
  'GNOS',
  'loft',
  '包豪斯',
  '蔓越莓',
  '哥特金属',
  '夜晚蜘蛛乃凶兆',
  '地雷亚',
  '剧院魅影',
  '朋克',
  'Gnosis',
  '长城小白猪',
  '实验音乐',
  '戚风蛋糕',
  '圣文森特大道',
  '次声波',
  '塞尔提',
  '中枢神经',
  '《咒怨》',
  '梅尔克修道院',
  '巴洛克风格',
  'MiuMiu',
  'Gansta',
  '穿越时空的少女',
  '《布达佩斯大饭店》',
  '杨超越',
  '裙撑',
  '大丈夫',
  '柯南',
  '《美丽新世界》'
];

///词典解锁
Map dictionaryMap = {
  '软件': [
    '第一章',
    'true',
    '这里特指异次元通讯，是睿果工作室出品的一款手机app，用于即时通讯，经大量用户反馈，相连接的用户之间似乎存在着某种未知的羁绊，原理不明'
  ],
  '西武百货': [
    '第一章',
    'false',
    'Seibu，著名高端百货商场，Seibu以商品顶级、地段优越、体量巨大、格局复杂而著称，东京池袋西口的西武本店号称用10小时也逛不完'
  ],
  '悠哈盐味奶糖': ['第一章', 'false', '日本味觉糖株式会社出品的UHA悠哈系列奶糖之一，好吃!'],
  'flash': [
    '第一章',
    'false',
    'Adobe公司的一种矢量图和web动画标准，Adobe公司的一种矢量图和web动画标准Adobe宣布在2020年度彻底淘汰flash，动画《疯狂动物城》中的角色名，车管所的树懒，也叫这个名字'
  ],
  '跳步侧踢': [
    '第一章',
    'false',
    '跆拳道术语，jumpsidekick，侧踢动作的主要攻击部位有膝部、腹部、肋部、胸部和头面部，而跳步侧踢动作幅度大，被击中者受到的伤害十分大'
  ],
  '跆拳道蓝带': ['第一章', 'false', '跆拳道的等级，级别由低到高是10级到1级，蓝带属于第4级'],
  '蓝带厨艺学院': [
    '第一章',
    'false',
    '法国蓝带厨艺学院(LeCordonBleuCulinaryArtsInstitute)，1895年创建于巴黎，是世界知名的西餐西点人才专业培训学校'
  ],
  '红丝绒蛋糕': [
    '第一章',
    'false',
    'RedVelvetCake，一种美式甜品，起源于纽约的Waldorf-Astoria酒店，红丝绒蛋糕是酸、甜、咸几种强烈的滋味完美融合，对甜品师的技艺要求很高'
  ],
  '蒙德里安': [
    '第一章',
    'false',
    '荷兰画家，以几何图形为基本元素，他认为艺术应脱离外在、表现抽象精神，追求人与神统一的绝对境界，他创立的风格派，对绘画、音乐、建筑、装饰都有巨大影响，传闻蒙德里安还沉迷于精神学与灵学，以及神秘主义某个流派'
  ],
  'Miko': ['第一章', 'false', '女性名字，日文罗马音，平假名みこ，片假名ミコ，有巫女、神女等意思'],
  '摸木头': [
    '第一章',
    'false',
    'Touch Wood，直译敲木头，指接触木制品能保持好运，驱邪避灾，起源于宗教信仰和迷信，最早刊登在1908年的《威斯敏斯特公报》，老一辈常在自己和教训年轻人说错话时摸摸木头'
  ],
  'Coquille': ['第一章', 'false', '法语，扇贝，奶油煸扇贝，是一种法国经典特色菜'],
  'JK制服': [
    '第一章',
    'false',
    'JK指日本女高中生，JK制服是女高中生的校服，JK也是种服饰文化，一般以西式制服(衬衣+制服裙)和日式制服(水手服+制服裙)为主'
  ],
  '炮姐': [
    '第一章',
    'false',
    '御坂美琴(bilibili)，《魔法禁书目录》和《科学超电磁炮》的角色，性格好胜、正义感强，有着男孩子般的爽朗性格，但却没有耐心'
  ],
  '抖M': ['第一章', 'false', '抖源于日语，意指严重，抖M指严重受虐倾向，与抖S相反，在ACGN文化中常用于互相吐槽和开玩笑'],
  '女贞': ['第一章', 'false', '亚热带常绿灌木，品种繁多，园林中常用的观赏树种，多产于长江以南'],
  '威士忌酱烤肋排': ['第一章', 'false', '经典的美式家常菜，浓郁多汁，威士忌酱一般为独家调制，美剧《纸牌屋》中也曾出现这款菜式'],
  '《美的历史》': [
    '第一章',
    'false',
    '意大利哲学家、文学家翁贝托艾柯(UmbertoEco)的著作，描述人类文明史上美学观点的演变史，涉及文学、艺术等各方面'
  ],
  '42': ['第一章', 'false', '生命，宇宙和万事万物的终极答案'],
  '摩斯密码': [
    '第一章',
    'false',
    'Morsecode，又称作摩尔斯密码，这是一种时通时断的信号代码，通过不同的排列顺序来表达不同的英文字母、数字和标点符号，多用于海事通讯，童子军培训也会有这种训练'
  ],
  '425A': ['第一章', 'false', '美国警察专用事件代码，425A指代Suspiciousperson可疑人员'],
  '莫西莫西': ['番外一', 'false', '日语电话用语，平假名もしもし，片假名モシモシ'],
  '《傅科摆》': [
    '第二章',
    'false',
    '意大利哲学家、文学家翁贝托·艾柯（UmbertoEco）的作品，《傅科摆》中含有大量关于史学、哲学和因果逻辑的推理小说。小说中三个知识分子研究古代资料，推理出一个本部粗在的神秘团体，一次卷入了一个巨大的阴谋，最后被自己编造的故事吸引到了里面，至死不悔。'
  ],
  '《玫瑰的名字》': [
    '第二章',
    'false',
    '意大利哲学家、文学家翁贝托·艾柯（UmbertoEco）的作品，这是一部侦探、哲理、历史小说，充盈着“符号学”、“编码”、“解码”元素。讲述修道院中发生一连串离奇的死亡事件，一个博学多闻的圣方济各教士负责调查真相，却卷入恐怖的犯罪中。'
  ],
  'dirndl裙': [
    '第二章',
    'false',
    '德国巴伐利亚地区女性服饰吗，由衬衣、连衣裙和围裙组成，腰带蝴蝶结的装饰很精致，有着不同含义。Dirndl有点很想女仆装，而很多动漫角色的服饰又有着dirndl的元素。'
  ],
  'ky': ['第二章', 'false', 'KY是日语““空気が読めない"的罗马音，多指不看气氛场合说话。'],
  'lo娘茶会': [
    '第二章',
    'false',
    '指Lolita洋装爱好者的聚会，lo娘茶会是她们聚会的一种方式，类似于闺蜜下午茶，服饰和餐饮风格偏洛可可和维多利亚。'
  ],
  '艾丽丝': [
    '第二章',
    'false',
    '女性名字，读音相近的主要有Alice和Iris，Alice来自古法语Adelais，最著名的有《爱丽丝梦游仙境》的主角和《生化危机》的主角。Iris来自拉丁语，有彩虹、虹膜、鸢尾花的意思。'
  ],
  '本乡奏多': [
    '第二章',
    'false',
    '日本演员，现实生活中是个完全的死宅，有深度洁癖，不喜欢出门，私人的主要生活就是躺在床上一边吃零食一边打游戏，他曾在某节目中表示：”运动没有意义。“、”紫外线真的不是好东西。“'
  ],
  '锦户亮': [
    '第二章',
    'false',
    '日本演员，为人真实不做作，性格比较宅，对不感兴趣的东西可以一句话不说，但对熟悉的人却会撒娇和吐槽毒舌。'
  ],
  '纽约重芝士蛋糕': [
    '第二章',
    'false',
    'NewYorkCheesecake，一种美式甜品，没有多余的辅料和装饰却拥有浓厚有丝滑的口感。'
  ],
  '皮尔斯': [
    '第二章',
    'false',
    'Miko指的应该是圣叙皮尔斯教堂（St.Sulpice），位于巴黎第六区的一座天主教教堂，因教堂内的玫瑰线而著称。《达芬奇密码》中有提到。'
  ],
  '皮卡丘': [
    '第二章',
    'false',
    '日本任天堂公司开发的掌机游戏《口袋妖怪》中登场的虚拟角色，皮卡丘也出现在改编的动画《神奇宝贝》中登场。”去吧！皮卡丘“是在动画中主人公每次放出皮卡丘的必喊台词，代表皮卡丘进入战斗模式了。'
  ],
  '屁股': [
    '第二章',
    'false',
    '暴雪游戏《守望先锋》的代称，Miko曾表示沉迷这款游戏，并且是大师接近宗师段位的Dva玩家，Miko的战网帐号未知。'
  ],
  '圣心教堂': [
    '第二章',
    'false',
    '天主教教堂，建筑风格华丽繁复，由教堂改造的图书馆既增加了现代化元素又保留了原有建筑的神秘色彩。西方又把宗教建筑改成图书馆的传统，中世纪的修道院也一直是只是保存的重要地点。'
  ],
  '夏尔': [
    '第二章',
    'false',
    '夏尔·凡多姆海威（CielPhantomhive）漫画作品《黑执事》中的角色，个性傲娇，为实现愿望，他与恶魔塞巴斯蒂安达成契约，以灵魂作为交换，从此改变自己的性格。夏尔还喜欢白玫瑰'
  ],
  'Tango One': [
    '第二章',
    'false',
    'Tango One《探戈一号》是一部快节奏的犯罪惊悚片，讲述的是一个人为了拯救自己的女儿、拯救自己的犯罪帝国铤而走险的故事。三名秘密警察被派去执行一项不可能的任务，要干掉世界上最臭名昭著的毒贩丹·多诺万'
  ],
  'uno': [
    '番外二',
    'false',
    '一种牌类游戏，于1971年由MerleRobbins发明，现由游戏公司Mattel生产，适合多人聚会共玩，由于对抗激烈也有“友谊终结器”的称号'
  ],
  '变色牌': ['番外二', 'false', '功能牌的一种，可以改变下家出牌颜色'],
  '色牌': [
    '番外二',
    'false',
    '普通牌分为四种颜色，中文统称为色牌，分别为Blue、Green、Red、 Yellow，下家出牌只能跟随上家的颜色'
  ],
  '万能牌': ['番外二', 'false', 'uno牌戏中的一种很厉害的功能牌，分为Wild (变色)和WildDraw4 (摸四张)'],
  '修仙': [
    '第三章',
    'false',
    '修仙，网络流行词，该词的意思是喜欢熬夜的人不睡觉不猝死反而要修仙，然后就被广大的网友们互相调侃玩坏了，熬夜都不叫熬夜了，新潮的说法就是修仙，熬夜不会猝死啊，会增强法力。'
  ],
  '熵': [
    '第三章',
    'false',
    '泛指某些物质系统状态的一种量度，某些物质系统状态可能出现的程度。亦被社会科学用以借喻人类社会某些状态的程度'
  ],
  '门房': ['第三章', 'false', '门卫住的房间'],
  '波斯王子时之砂': [
    '第三章',
    'false',
    '由育碧蒙特利尔工作室主导开发，并由育碧发行的一款动作冒险游戏，《时之沙》是对1989年的苹果游戏《波斯王子》的一次重启，采用了全新的3D视野和游戏模式。这是《时之沙》系列的第一部，讲述了一位年轻的王子在一次灾难后的冒险'
  ],
  'NPC': [
    '第三章',
    'false',
    'NPC是non-player character的缩写，是游戏中一种角色类型，意思指的是电子游戏中不受真人玩家操纵的游戏角色，这个概念最早源于单机游戏，后来这个概念逐渐被应用到其他游戏领域中'
  ],
  'Italian Job': [
    '第三章',
    'false',
    'Italian Job，《偷天换日》是由F·加里·格瑞执导，马克·沃尔伯格、查理兹·塞隆、爱德华·诺顿和唐纳德·萨瑟兰主演的一部抢劫题材电影，影片是根据1969年英国同名电影翻拍，讲述了一群人抢劫黄金的故事。影片于2003年5月30日在美国上映。\n仅北美票房收入就超过1亿7600万美元。'
  ],
  '西奥科技': [
    '第三章',
    'false',
    'Theotechnology， - 家私人 控股的科技公司，据公开的资料显示，业务范围涉及生物科技、基础物理应用、智能化科技等领域，目前经营状况已告解散。'
  ],
  '思泰基金': ['第三章', 'false', 'StijlCapital， -家私募基金，命名来历不详，资金来源不详，公司构成不详，公开资料很少。'],
  '清盘': [
    '第三章',
    'false',
    '清盘是一种法律程序，公司的生产运作停止，所有资产（包括生财工具的机械、工厂、办公室及物业），在短期内出售，变回现金，然后按先后次序偿还（分派给）未付的债项，之后按法律程序，宣布公司解散的一连串过程'
  ],
  '注会': ['第三章', 'false', '注册会计师，是指通过注册会计师执业资格考试并取得注册会计师证书在会计师事务所执业的人员'],
  '创伤心理': [
    '第三章',
    'false',
    '心理创伤在精神病学上创伤被定义为“超出一般常人经验的事件，创伤通常会让人感到无能为力或是无助感。创伤的发生都是突然的、无法抵抗的'
  ],
  'Simulacra': [
    '第三章',
    'false',
    '“拟像理论”是鲍德里亚最重要的理论之一，他认为，正是传媒的推波助澜加速了从现代生产领域向后现代拟像(Simulacra)社会的堕落。而当代社会，则是由大众媒介营造的一个仿真社会'
  ],
  '白学现场': [
    '第三章',
    'false',
    '网络用语的“白学”一词起源于最早对游戏《白色相簿2》的讨论，正如同我国四大名著之一的《红楼梦》被许多学者进行研究，渐渐的就有了“红学”的说法一样，《白色相簿2》也被许多粉丝拿去深入研究其中主人公们的情感轨迹，渐渐的也被一些人笑称之为“白学”。游戏中男主春希和两位女主角雪菜和冬马的关系，自觉划分成两大阵营，两党派之争使得“白学现场”一词走红网络。'
  ],
  '苏菲': ['第三章', 'false', '可能是Sophia或者Sophy，都源于希腊语，同一词源，含义是智慧，Sophia多用于女性名字。'],
  '尬聊': ['第三章', 'false', '尬聊，网络流行语，意思是尴尬的聊天，气氛陷入冰点'],
  '42街': [
    '第三章',
    'false',
    '美国纽约市曼哈顿有一条主要街道叫42街(42ndStreet)，这条街上从东到西依次排列着联合国总部、克莱斯勒大厦、大中央车站、时报广场和纽新航港局客运总站等重要建筑。同名的《42街》还是一部美国百老汇音乐剧，讲述"人们只要具备才能并辛勤努力，就能将梦想变为现实的故事。'
  ],
  'DeStijl': [
    '第三章',
    'false',
    '荷兰风格派运动，主张纯抽象和纯朴，外形上缩减到几何形状，而且颜色只使用黑与白的原色\n也被称为新塑造主义(neoplasticism)。 运动中最有名的艺术家皮耶·蒙德利安(Piet Mondrian，荷兰人，1872年-1944年)，在1920年出版了一本宣言名为“新塑造主义”(Neo-Plasticism)。画家凡·杜斯堡(Theo van Doesburg，荷兰人，1883年-1931年)在1917年至1928年出版了名为《De Stijl》的期刊，传播风格派的理论'
  ],
  '克莱因瓶': [
    '第三章',
    'false',
    '克莱因瓶，在数学领域中是指一种无定向性的平面，比如二维平面，就没有“内部”和“外部”之分。克莱因瓶在拓扑学中是一个不可定向的拓扑空间。克莱因瓶最初由德国几何学大家菲立克斯·克莱因 (Felix Klein) 提出'
  ],
  '傅科摆': [
    '第三章',
    'false',
    '傅科摆是一个单摆，底板有一个量角器。单摆振动时，振动面依理应保持不变，但因地球在自转，在地面上的观察者，不能发觉地球在转，但在相当长的时期内，却发现摆的振动面不断偏转。从力学的观点来看，这也是由于受到了科里奥利力影响的缘故。这项显示地球自转的装置，是1851年傅科在巴黎首先制成的，虽然早在1650年，已有人观察到摆的振动面在缓慢地旋转，但却未能对此现象作出正确的解释。所以我们现在把用来显示地球自转的这种装置叫傅科摆'
  ],
  '神秘海域': [
    '第三章',
    'false',
    '《神秘海域》（英文：Uncharted）是SCE发行的动作冒险游戏系列，游戏设定在原始丛林、热带雨林、沙漠腹地、雪山高原、古代遗迹等地，以电影方式呈现。主人公内森·德雷克要面对各种各样的敌人，最终找到宝藏'
  ],
  '平行宇宙': [
    '第三章',
    'false',
    '多元宇宙是一个理论上的无限个或有限个可能的宇宙的集合，包括了一切存在和可能存在的事物：所有的空间、时间、物质、能量以及描述它们的物理定律和物理常数。\n多元宇宙所包含的各个宇宙被称为平行宇宙'
  ],
  '成田机场': [
    '番外三',
    'false',
    '成田国际机场，中国常称东京成田国际机场，位于日本国千叶县成田市，西距东京都中心63.5千米，为4F级国际机场、国际航空枢纽、日本国家中心机场。'
  ],
  '银联': [
    '番外三',
    'false',
    '银联成立于2002年3月，是经国务院同意，中国人民银行批准，在合并18家银行卡信息交换中心的基础上，85家机构共同出资成立的中国银行卡联合组织，总部设于上海。'
  ],
  '豚骨拉面': [
    '番外三',
    'false',
    '日本豚骨拉面是由面加汤底制成的一道美食。豚在文言文与日语里就是猪的意思，日本豚骨拉面的这个汤也就是用猪大骨等熬制出来的汤。'
  ],
  '全家': [
    '番外三',
    'false',
    '全家，便利店品牌，1972年成立于日本。1988年8月18日，全家便利店进入中国台湾地区，在台北市中山区成立，由日本FamilyMart与台湾禾丰企业集团合资成立。自FamilyMart母公司授权引进便利商店管理技术进入中国台湾市场，成立时就以加盟店为主要经营方式。'
  ],
  '上野': [
    '番外三',
    'false',
    '上野是位于东京都台东区以上野站为中心的一块区域的名称，行政上由以下几个町名组成：台东区上野、北上野、东上野、上野公园等，这里有上野恩赐公园（日本最早的公园），还有许多商店街。'
  ],
  '玉子烧': [
    '番外三',
    'false',
    '玉子烧是由鸡蛋、牛奶、 盐 、 味淋、日本柴鱼酱油组成，并且很有营养价值，鸡蛋能够润燥、增强免疫力、护眼明目，牛奶富含蛋白质。此外，牛奶的部份也可使用水或是柴鱼高汤替代，水的多少 ，与厚蛋烧的绵密程度有很大的关系 。'
  ],
  '关东煮': ['番外三', 'false', '关东煮是日本人喜爱的小吃，本名御田，是一种源自日本关东地区的料理。'],
  '神社': [
    '番外三',
    'false',
    '神社是崇奉与祭祀神道教中各神灵的社屋，是日本宗教建筑中最古老的类型。由于神道教与日本人民生活密切联系，神社十分普遍。神社自7世纪起实行“造替”制度，即每隔几十年就重建一次。神社现在一般都不设香火，不知是传统的规矩，还是现代化的演变。人们到神社去，一般是先在神社前的水池边用一个长柄木勺净手，然后到屋脊两边翘起的神社拜殿前，往带木条格的善款箱里扔点零钱，把手拍几下，合十祈祷。有的拜殿前还挂有很粗的麻绳，祈祷者摇动两下，撞得麻绳上的风铃发出响声。'
  ],
  '五重塔': [
    '番外三',
    'false',
    '五重塔是唐朝时日本学习模仿大唐建筑的产物，反映了中国唐朝时的木结构宗教建筑的模式。坐落在富士山附近，是日本风景图片里经常可以看到的古塔，它与飘舞的樱花或满山的枫叶组成一幅独特的风景！散发着着日本特有的古朴和优雅！'
  ],
  '上野公园': [
    '番外三',
    'false',
    '上野公园位于日本东京市台东区，面积有53万平方米。上野公园是日本的第一座公园，历史文化深厚，景色秀美。在上野公园门内，便可看到明治时代大将军西乡隆盛的铜像。1650年修建供奉德川家康的东照宫，建筑宏伟，参道两旁还有95座石灯笼和195座青铜灯笼。园内最大的湖泊不忍池是无数鸟类迁徒停靠的地方，湖旁分布有大佛宝塔、五条神社、民俗资料馆、博物馆等。每当春季，樱花盛开时，这里是最佳的赏樱地点。'
  ],
  '绘马': [
    '番外三',
    'false',
    '绘马是日本人许愿的一种形式。大致产生在日本的奈良时代。绘马有大绘马和小绘马两种。大绘马类似匾额，比较少见。一般所说的是民间常用的小绘马。在一个长约15厘米高约10厘米的木牌上写上自己的愿望、供在神前，祈求得到神的庇护。 绘马，绘马，顾名思义，上面画的是马。不过这是绘马最初的形式，后来的绘马图案就越来越丰富了，画上了和自己的愿望相关的内容。绘马图案的变化，反映日本民众的生活的变化和各地风俗，充满了机智与乐天的情趣。'
  ],
  '东京国立博物馆': [
    '番外三',
    'false',
    '东京国立博物馆始于明治5年（1872）在汤岛圣堂大成殿举办的博览会，是日本历史最为悠久的博物馆。其事业包括日本以及东方美术与考古等在内的各种文化遗产的收集、保管、修理、管理、展览、调查研究和教育普及等活动。馆内共收藏文物约12万件（其中国宝89件，重要文化财648件），无论是文物的品质或数目都是日本首屈一指的（截至2021年3月底）。综合文化展（常设展）展出的文物数量始终在3000件左右。'
  ],
  '东京旧音乐学院': ['番外三', 'false', '旧东京音乐学院?位于东京都台东区，是日本近代的历史建筑物。日本最初建设的西洋式音乐学院'],
  '回转寿司': [
    '番外三',
    'false',
    '回转寿司是寿司餐厅的一种。师傅把制作好的寿司放在盘子后摆在运输带上，运输带围绕餐厅的坐台而行，顾客可随意食用，用膳后，店员依照顾客桌上的盘子而结算帐单。'
  ],
  '中二': [
    '第四章',
    'false',
    '即“中二病”，“中二”即初中二年级。“中二病”指青春期特有的自以为是、爱幻想的行为和价值观。伊集院光于1999年1月11日在广播节目《伊集院光：深夜的马鹿力》中首度提出此概念。'
  ],
  '2014': ['第四章', 'false', '异次元通讯“里世界”中较为重要的一个时间节点，即《异体时间线详见く异次元通讯-年表》。'],
  '都市传说': [
    '第四章',
    'false',
    'Urban Legend， 指当代都市间广为流传的不明故事， 经过多次传播 夸张、 变异 融合最终形成无法证实也无法证伪的故事。这种现象被称为FOAF (friend of a friend， 即口口相传）。美国民俗学家Jan Brunvand在1981年的著 作《消失的搭车客：美国都会传奇及意义》中最早使用这个概念。'
  ],
  'Eric': [
    '第四章',
    'false',
    '英文男子名， 源于爱尔兰，意为欧石楠花， 花语孤独。又写作Erik， 源于北欧， 意为领导者。黑执事舞台剧中的一个死神名为Eric， 为拯救朋友而死亡。 《X战警》中的万磁王在亲人被杀害后曾用化名Erik。'
  ],
  'Mark': ['第四章', 'false', '英文男子名， 源于拉丁语ManCus， 意为战神Mars，含义为狂暴的 侵略性的。'],
  '生物效应': ['第四章', 'false', '指研究电磁辐射对生物系统的运作影响效应 包措机理、防护和应用等等。'],
  '时序保护': [
    '第四章',
    'false',
    '时序保护猜想（Chronology protection conjecture）是由霍金提出的关于时间旅行的猜想。认为自然定律不允许任何除亚微观尺度外的时间旅行。霍金在一个1992年的文件中说：“似乎有一个时序保护机制，防止闭合类时曲线的生成，从历史学家手上保护了宇宙的安全”这个点子似乎是来源于科幻作品中的时间警察等机构。'
  ],
  '闭合时曲线': [
    '第四章',
    'false',
    '在一洛伦兹流形中，一条封闭类时曲线（closed timelike curve， CTC）是一物质粒子于时空中的一种世界线，其为“封闭”，亦即会返回起始点。闭合类时曲线这种可能性是由Willem Jacob van Stockum于1937年以及库尔特·哥德尔（Kurt G?del）于1949年开启研究风潮。若CTC存在，则似乎隐射时间机器理论上可行，如此也引出了祖父悖论（grandfather paradox）的梦靥。CTC与参考系拖曳（frame dragging）以及提普勒柱体（Tipler Cylinder）有关。这是广义相对论带来的众多有趣的“副作用”其中一者。'
  ],
  '12只猴子': [
    '第四章',
    'false',
    '电影《12只猴子》，由特瑞·吉列姆（Terry Gilliam）执导，布鲁斯·威利斯、布拉德·皮特、玛德琳·斯托主演的科幻片。\n影片讲述了在公元1996年，世界被一种致命病毒侵袭之后，剩余的少数人类只能在地下苟且偷生。为了改变这一情况，科学家们设计出一个计划去改变这一切并最终找到了释放病毒的“罪魁祸首”。'
  ],
  'Dva': [
    '第四章',
    'false',
    'Dva是网络游戏《守望先锋》以及衍生作品中的英雄角色，（前）职业玩家、机甲驾驶员。隶属于韩国陆军特别机动部队。Dva拥有一部强大的机甲，它具有两台全自动的无限弹药近距离聚变机炮、可以使机甲飞跃敌人或障碍物的推进器、 还有可以抵御来自正面的远程攻击的防御矩阵。'
  ],
  '管风琴': [
    '第四章',
    'false',
    '管风琴（pipe organ），属于气鸣式键盘乐器（参见“乐器”词条），流传于欧洲的历史悠久的大型键盘乐器，距今已有2200余年的历史（至2018年），且从未中断过。管风琴是风琴的一种，不同的是一般的脚踏风琴是通过脚踏鼓风装置吹动簧片使簧片振动来发音，而管风琴是靠铜制或木制音管来发音。管风琴音量洪大，气势雄伟，音色优美、庄重，并有多样化对比、能模仿管弦乐器效果，能演奏丰富的和声。'
  ],
  '群青组': [
    '第四章',
    'false',
    '群青， Ultramarine Blue， 种鲜艳浓郁的蓝色。古代的群青颜料来自青金石，昂贵珍稀多用干宗教绘画中圣母玛利亚的服饰着色。'
  ],
  '藤校': [
    '第四章',
    'false',
    '常春藤联盟学校的简称。常春藤联盟由美国东北部8所大学联合而成，均为建校很早的顶尖大学，学术水准、教学质量均一流，学生文化团体也相当多元化和精英化。传闻中的骷髅会即为藤校之一耶鲁大学'
  ],
  '约拿': [
    '第四章',
    'false',
    '约拿，是古以色列国的先知，前往亚述帝国首都尼尼微城传天谴警告，当世的亚述腐败不堪，就觉得亚述人很坏没有必要救，就不太愿意去传道，想借机逃跑但上帝的旨意不是人一时所能完全明白的。最后在上帝管教下，知道自己的过犯才继续前往，等到达之时传道完毕，就坐等尼尼微城灭亡结果人们却出乎意料地悔改蒙恩，为此羞愧不已。'
  ],
  '米仓凉子': ['第四章', 'false', '模特出身的女演员，曾以松本清张小说改编的“恶女三部曲而著称， 是御姐范的典型代表。'],
  '天海佑希': ['第四章', 'false', '宝冢剧团红极一时的主役，身材颀长、英姿飒爽，是颇具统御力的女王型女演员。'],
  'lily': [
    '第四章',
    'false',
    'lily，英语单词，名词、形容词，作名词时意为“ 百合花，百合；类似百合花的植物；洁白之物，人名；(罗)莉莉”，作形容词时意为“洁白的，纯洁的”。'
  ],
  '六分仪': [
    '第四章',
    'false',
    '六分仪用来测量远方两个目标之间夹角的光学仪器。通常用它测量某一时刻太阳或其他天体与海平线或地平线的夹角﹐以便迅速得知海船或飞机所在位置的经纬度。六分仪的原理是牛顿首先提出的。六分仪具有扇状外形﹐其组成部分包括一架小望远镜，一个半透明半反射的固定平面镜即地平镜﹐一个与指标相联的活动反射镜即指标镜。六分仪的刻度弧为圆周的1/6。使用时﹐观测者手持六分仪﹐转动指标镜﹐使在视场里同时出现的天体与海平线重合。根据指标镜的转角可以读出天体的高度角﹐其误差约为±0.2°～±1°。在航空六分仪的视场里﹐有代替地平线的水准器。这种六分仪一般还有读数平均机构。六分仪的特点是轻便﹐可以在摆动着的物体如船舶上观测。缺点是阴雨天不能使用。二十世纪四十年代以后﹐虽然出现了各种无线电定位法，但六分仪仍在广泛应用。'
  ],
  '维特鲁威人': [
    '第四章',
    'false',
    '《维特鲁威人》（意大利语：Uomo vitruviano）是列奥纳多·达·芬奇在1487年前后创作的素描作品。它是钢笔和墨水绘制的手稿，规格为34.4 cm× 25.5 cm。根据约1500年前维特鲁威在《建筑十书》中的描述，达芬奇努力绘出了完美比例的人体。这幅由钢笔和墨水绘制的手稿，描绘了一个男人在同一位置上的“十”字型和“火”字型的姿态，并同时被分别嵌入到一个矩形和一个圆形当中。这幅画有时也被称作卡侬比例或男子比例。维特鲁威人现被收藏于意大利威尼斯的学院美术馆中，和大部分纸质作品一样，它只会偶尔被展出。'
  ],
  'GNOS': [
    '第四章',
    'false',
    '应为Gnosticism，希腊语 γνωστικ??，中文译名灵知派，是诺斯替主义的基本概念，诺思底主义者相信“灵知”可使他们脱离无知及现世。是一种企图中和物质和精神的二元论的世界观。'
  ],
  'loft': [
    '第五章',
    'false',
    'LOFT在牛津词典上的解释是“在屋顶之下、存放东西的阁楼”。但所谓LOFT所指的是那些“由旧工厂或旧仓库改造而成的，少有内墙隔断的高挑开敞空间”。LOFT户型通常是小户型，高举架，面积在30-50平米，层高在3.6-5.2米左右。 虽然销售时按一层的建筑面积计算，但实际使用面积却可达到销售面积的近2倍；高层高空间变化丰富'
  ],
  '包豪斯': [
    '第五章',
    'false',
    '包豪斯的风格就是构成艺术。由几何形体以及特定的排列形式（重复、渐变、特异等等）。简约是包豪斯沙发的最高设计原则，摒弃了多余装饰，线条明朗，造型简洁利落但是变化却很多，设计简约但不简单，比不锈钢架就经常运用于沙发设计中，作为扶手或支架显露出来，搭配冷静的色调来突出现代风格的独特美感，给人新奇的居家体验。'
  ],
  '蔓越莓': [
    '第五章',
    'false',
    '蔓越莓又称蔓越橘，是杜鹃花科越橘属（Vacinium macrocarpon）的常绿小灌木矮蔓藤植物，整体看起来很像鹤，花朵就像鹤头和嘴，因此蔓越莓又称“鹤莓”。它的果实是长2～5cm的卵圆形浆果，由白色变深红色，吃起来有重酸微甜的口感。'
  ],
  '哥特金属': [
    '第五章',
    'false',
    '哥特金属（Goth Metal，港台地区译：哥德金属）是一种揉合了重金属音乐及哥特风格音乐的混合物，其发源时间始于九十年代初的欧美。某种程度上，哥特金属是难于确认和肯定的，有些乐迷及音乐人对于曲式分类有强烈的理念，但另外的人则认为这些曲式分类是没有用的。歌特金属是中世纪风格，单纯的歌特就是忧郁悲情的格调，其可不强调乐器的使用，不可与交响金属混为一体。'
  ],
  '夜晚蜘蛛乃凶兆': ['第五章', 'false', '《银魂》177集标题：夜晚蜘蛛乃凶兆'],
  '地雷亚': [
    '第五章',
    'false',
    '地雷亚。日本漫画《银魂》及其衍生作品中的男性角色。原名鸢田段藏（参照加藤段藏 又名鸢法师），御庭番史上最强忍者，百华初代首领，月咏的师傅。地雷亚自小就是伊贺忍术神童，忍术高深莫测，身手江户第一。过去曾一己之力灭掉御庭番全体激进派忍者。因妹妹的死使内心扭曲，为忘却自己而舍弃了这个名字；为了能更隐蔽自己的行动和踪迹，用烙铁把自己的脸烧毁。'
  ],
  '剧院魅影': [
    '第五章',
    'false',
    '《The Phantom Of the Opera》（剧院魅影/歌剧魅影/歌剧院幽灵）是音乐剧大师安德鲁·劳埃德·韦伯的代表作之一，以精彩的音乐、浪漫的剧情、完美的舞蹈，成为音乐剧中永恒的佳作。它改编自法国作家加斯东·路易·阿尔弗雷德·勒鲁的同名哥特式爱情小说。'
  ],
  '朋克': [
    '第五章',
    'false',
    '朋克（Punk），又译为庞克，诞生于七十年代中期，一种源于六十年代车库摇滚和前朋克摇滚的简单摇滚乐。它是最原始的摇滚乐——由一个简单悦耳的主旋律和三个和弦组成，经过演变，朋克已经逐渐脱离摇滚，成为一种独立的音乐。朋克音乐不太讲究音乐技巧，更加倾向于思想解放和反主流的尖锐立场，这种初衷在二十世纪七十年代特定的历史背景下在英美两国都得到了积极效仿，最终形成了朋克运动。同时，朋克音乐在年轻人中十分流行，为世界多地青年所喜爱。'
  ],
  'Gnosis': [
    '第五章',
    'false',
    'Gnosis，意为灵知或真知，一般代指灵知派，即诺斯替主义，是一种存于各个宗教的较为极端的思想，广为人知的是存于基督教的《犹大的福音》一书。'
  ],
  '长城小白猪': ['第五章', 'false', '长城牌小白猪火腿猪肉罐头，一种午餐肉罐头'],
  '实验音乐': [
    '第五章',
    'false',
    '通常所理解的音乐，无论是浪漫派、古典派或是非学院派的民族音乐，无一不在“表达”某种情绪或是信仰，换言之，作曲家的“自我”是在场的；而实验音乐意在追求一种高度纯粹的、不负载任何意义的聆听。比如森林中的鸟兽鱼虫所发出的声音，比如电脑音乐家制作的“听程式逻辑在跑的声音”，甚至像某个城市里某个路段的录音，在实验音乐人看来，其本质都是对声音的最高礼拜。“让声音自己说话”是实验音乐与一切传统音乐的最大不同。'
  ],
  '戚风蛋糕': [
    '第五章',
    'false',
    'Chiffon Cake的音译：戚风蛋糕，是一款甜点，属海绵蛋糕类型，制作原料主要有菜油、鸡蛋、糖、面粉、发粉等。但是由于缺乏牛油蛋糕的浓郁香味，戚风蛋糕通常需要味道浓郁的汁、或加上巧克力、水果等配料。由于菜油不像牛油（传统蛋糕都是用牛油的）那样容易打泡，因此需要靠把鸡蛋清打成泡沫状，来提供足够的空气以支撑蛋糕的体积。戚风蛋糕含足量的菜油和鸡蛋，因此质地非常的湿润，不像传统牛油蛋糕那样容易变硬。戚风蛋糕也含较少的饱和脂肪。（MIKO妈妈的最爱）'
  ],
  '圣文森特大道': [
    '第五章',
    'false',
    '这里应指涅瓦大街。涅瓦大街是圣彼得堡最热闹最繁华的街道，聚集了该市最大的书店、食品店、最大的百货商店和最昂贵的购物中心。而且还可以欣赏到各种教堂、名人故居以及历史遗迹。'
  ],
  '次声波': [
    '第五章',
    'false',
    '次声波是频率小于20Hz（赫兹）的声波。次声波不容易衰减，不易被水和空气吸收。次声波的波长往往很长，因此能绕开某些大型障碍物发生衍射。某些次声波能绕地球2至3周。某些频率的次声波由于和人体器官的振动频率相近，容易和人体器官产生共振，对人体有很强的伤害性。'
  ],
  '塞尔提': [
    '第五章',
    'false',
    '塞尔提·史特路尔森，轻小说《无头骑士异闻录》及其衍生作品中的重要角色之一，年龄不详（推测应有数百岁），原本是来自爱尔兰的无头骑士，因为头颅被盗走而失去了在爱尔兰的记忆，是池袋的都市传说之一。虽然身为非人类，性格却温和善良（是本作为数不多的“正常人”之一），给人一种非常容易亲近的感觉。平时穿着黑色的机车夹克骑着黑色摩托（爱马克修达?巴瓦所变）戴着摩托车头盔（因为没有头会引人注目）穿行于池袋。打开头盔面罩或取下摩托车头盔会散发黑烟。'
  ],
  '中枢神经': [
    '第六章',
    'false',
    '中枢神经系统（英文名称：Central Nervous System，中文名称中枢神经）是由脑和脊髓组成（脑和脊髓是各种反射弧的中枢部分），是人体神经系统的最主体部分。中枢神经系统接受全身各处的传入信息，经它整合加工后成为协调的运动性传出，或者储存在中枢神经系统内成为学习、记忆的神经基础。人类的思维活动也是中枢神经系统的功能。'
  ],
  '《咒怨》': ['第六章', 'false', '清水崇担任导演和编剧的恐怖电影。讲述了德勇一家被诅咒缠身，受到残害的故事。'],
  '梅尔克修道院': [
    '第六章',
    'false',
    '梅尔克修道院(StiftMelk)是一座本笃会修道院，成立于1089年，堪称巴洛克式建筑的杰作，由雅格布·普兰陶尔(Jakob Prandtauer)在1702年至1738年间建造。穿过主教庭院，登上装饰豪华的皇帝台阶，有着长约200米的长廊 ，长廊两边挂着奥地利统治者的画像。'
  ],
  '巴洛克风格': ['第六章', 'false', 'Baroque是欧洲的典型艺术风格，繁复扭曲、情感热烈，常用于宗教和宫廷内饰。'],
  'MiuMiu': ['第六章', 'false', 'Prada的副线品牌，年轻化设计，注重优雅精致且不乏趣味，率性且充满实验风格。'],
  'Gansta': ['第六章', 'false', '《GANGSTA.》，是日本漫画家コースケ所著的青年漫画。'],
  '穿越时空的少女': ['第六章', 'false', '日本动画电影，改编自筒井康隆的小说。女主角绀野真琴拥有了穿越时空的能力，来解决身边发生的事。'],
  '《布达佩斯大饭店》': [
    '第六章',
    'false',
    '美国导演韦·安德森的电影作品，一位看门人、一个盗贼、一幅文艺复兴时期油画、大家族的财富争夺战，颇具奇幻色彩。'
  ],
  '杨超越': ['第六章', 'false', '2018年的大热选秀节目《创造101》中的季军，话题人物，网络热门现象。'],
  '裙撑': ['第六章', 'false', '能使外裙蓬松鼓起的内衬，主要用于晚礼服长裙。日文写做“パ二エ”，是法语洛可可式横向裙撑的音译。'],
  '大丈夫': ['第六章', 'false', '源于日语词汇“だいじょうぶ＂的汉字写法，是“没有问题”、“没关系”的意思。'],
  '柯南': ['第六章', 'false', '日本动画《名侦探柯南》，改编自青山刚昌创作的、连载于《周刊少年Sunday》上的漫画《名侦探柯南》。'],
  '《美丽新世界》': [
    '第六章',
    'false',
    '《美丽新世界》是英国作家阿道司·赫胥黎创作的长篇小说。该作主要刻画了一个距今600年的未来世界，物质生活十分丰富，科学技术高度发达，人们接受着各种安于现状的制约和教育，所有的一切都被标准统一化，人的欲望可以随时随地得到完全满足，享受着衣食无忧的日子，不必担心生老病死带来的痛苦，然而在机械文明的社会中却无所谓家庭、个性、情绪、自由和道德，人与人之间根本不存在真实的情感，人性在机器的碾磨下灰飞烟灭。'
  ]
};

///保存设置
save() async {
  local = await SharedPreferences.getInstance();
  await local?.setBool('isNewImage', isNewImage);
  await local?.setBool('scrolling', scrolling);
  await local?.setInt('nowMikoAvater', nowMikoAvater);
  await local?.setBool('waitTyping', waitTyping);
  await local?.setBool('waitOffline', waitOffline);
  await local?.setString('playerAvatarSet', playerAvatarSet);
  await local?.setInt('playerNowAvater', playerNowAvater);
  await local?.setBool('backgroundMusicSwitch', backgroundMusicSwitch);
  await local?.setBool('buttonMusicSwitch', buttonMusicSwitch);
  await local?.setBool('isOldBgm', isOldBgm);
  await local?.setDouble('sliderValue', sliderValue);
}

///读取设置
load() async {
  local = await SharedPreferences.getInstance();
  isNewImage = local?.getBool('isNewImage') ?? false;
  scrolling = local?.getBool('scrolling') ?? true;
  nowMikoAvater = local?.getInt('nowMikoAvater') ?? 1;
  waitTyping = local?.getBool('waitTyping') ?? true;
  waitOffline = local?.getBool('waitOffline') ?? true;
  playerAvatarSet = local?.getString('playerAvatarSet') ?? '默认';
  playerNowAvater = local?.getInt('playerNowAvater') ?? 0;
  backgroundMusicSwitch = local?.getBool('backgroundMusicSwitch') ?? true;
  buttonMusicSwitch = local?.getBool('buttonMusicSwitch') ?? true;
  isOldBgm = local?.getBool('isOldBgm') ?? false;
  sliderValue = local?.getDouble('sliderValue') ?? 10;
}

///检查权限
checkPermission(Permission permission) async {
  PermissionStatus status = await permission.status;
  if (status.isGranted) {
    //权限通过
    return true;
  } else if (status.isDenied) {
    //权限拒绝， 需要区分IOS和Android，二者不一样
    requestPermission(permission);
    return false;
  } else if (status.isPermanentlyDenied) {
    //权限永久拒绝，且不在提示，需要进入设置界面，IOS和Android不同
    openAppSettings();
    return false;
  } else if (status.isRestricted) {
    //活动限制（例如，设置了家长控件，仅在iOS以上受支持。
    openAppSettings();
    return false;
  } else {
    //第一次申请
    requestPermission(permission);
    return false;
  }
}

///申请权限
requestPermission(Permission permission) async {
  //发起权限申请
  PermissionStatus status = await permission.request();
  // 返回权限申请的状态 status
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

///保存图鉴和词典
saveMap() async {
  local = await SharedPreferences.getInstance();
  //Map转jsonString
  final imageMapJson = jsonEncode(imageMap);
  //保存jsonString
  local?.setString('imageMap', imageMapJson);
  //Map转jsonString
  final dictionaryMapJson = jsonEncode(dictionaryMap);
  //保存jsonString
  local?.setString('dictionaryMap', dictionaryMapJson);
}

///读取图鉴和词典
loadMap() async {
  local = await SharedPreferences.getInstance();
  bool checkKey1 = local?.containsKey('imageMap') ?? false;
  bool checkKey2 = local?.containsKey('dictionaryMap') ?? false;
  if (checkKey1) {
    //读取jsonString
    final imageMapJson = await local?.getString('imageMap') ?? '';
    if (!imageMapJson.isEmpty) {
      //jsonString转Map
      imageMap = jsonDecode(imageMapJson);
    }
  }
  if (checkKey2) {
    //读取jsonString
    final dictionaryMapJson = await local?.getString('dictionaryMap') ?? '';
    if (!dictionaryMapJson.isEmpty) {
      //jsonString转Map
      dictionaryMap = jsonDecode(dictionaryMapJson);
    }
  }
}

///保存历史消息和动态
saveChat() async {
  local = await SharedPreferences.getInstance();
  local?.setStringList('messagesInfo', messagesInfo);
  local?.setStringList('trendsInfo', trendsInfo);
}

///读取动态
loadtrend() async {
  local = await SharedPreferences.getInstance();
  trendsInfo = await local?.getStringList('trendsInfo') ?? [];
  Map _trendsInfo = {};
  if (trendsInfo != []) {
    for (int i = 0; i < trendsInfo.length; i++) {
      _trendsInfo[i] = fromJsonString(trendsInfo[i]);
    }
    if (trends.length < _trendsInfo.length) {
      for (int i = 0; i < _trendsInfo.length;) {
        Trend trend = Trend(
            trendText: _trendsInfo[i]['trendText'],
            trendImg: _trendsInfo[i]['trendImg']);
        trends.add(trend);
      }
    }
  }
}

///清除缓存
delAll() async {
  local = await SharedPreferences.getInstance();
  List<String> keys = local?.getKeys().toList() ?? [];
  keys.forEach((key) {
    local?.remove(key);
  });
  messages = [];
  trends = [];
  messagesInfo = [];
  trendsInfo = [];
  // EasyLoading.showToast('已清除缓存',
  //     toastPosition: EasyLoadingToastPosition.bottom);
}

///读取历史消息
loadMessage() async {
  local = await SharedPreferences.getInstance();
  messagesInfo = await local?.getStringList('messagesInfo') ?? [];
  Map _messagesInfo = {};
  int num = 0;
  if (messagesInfo != []) {
    for (int i = 0; i < messagesInfo.length; i++) {
      _messagesInfo[i] = fromJsonString(messagesInfo[i]);
    }
    if (_messagesInfo.length >= 60) {
      num = _messagesInfo.length - 60;
    }
    if (messages.length < _messagesInfo.length) {
      for (int i = num; i < messagesInfo.length;) {
        Map messageMap = _messagesInfo[i];
        if (messageMap['位置'] == '左') {
          try {
            String text = messageMap['text'];
            LeftTextMsg message = LeftTextMsg(
              who: messageMap['who'],
              text: text,
            );
            messages.add(message);
            i++;
          } catch (err) {
            String img = messageMap['img'];
            LeftImgMsg message = LeftImgMsg(
              img: img,
            );
            messages.add(message);
            i++;
          }
        }
        if (messageMap['位置'] == '中') {
          MiddleMsg message =
              MiddleMsg(text: messageMap['text'], color: messageMap['text']);
          messages.add(message);
          i++;
        }
        if (messageMap['位置'] == '右') {
          RightMsg message = RightMsg(text: messageMap['text']);
          messages.add(message);
          i++;
        }
      }
    }
  }
}

fromJsonString(String jsonString) {
  final Info = jsonDecode(jsonString);
  return Info;
}

///播放背景音乐
backgroundMusic() {
  String bgmPath =
      isOldBgm ? 'assets/music/背景音乐-旧.mp3' : 'assets/music/背景音乐.mp3';
  bgmplayer.setAsset(bgmPath);
  bgmplayer.setVolume(0.5);
  bgmplayer.setLoopMode(LoopMode.all);
  if (backgroundMusicSwitch) {
    bgmplayer.play();
  } else {
    bgmplayer.pause();
  }
}

///播放按钮音效
buttonMusic() {
  buttonplayer.setAsset('assets/music/选项音效.mp3');
  buttonplayer.setVolume(1);
  buttonplayer.setLoopMode(LoopMode.off);
  if (buttonMusicSwitch) {
    buttonplayer.play();
  } else {
    buttonplayer.pause();
  }
}

//语音彩蛋
voice(double volume) {
  int res = Random().nextInt(2);
  voiceplayer.setLoopMode(LoopMode.off);
  voiceplayer.setVolume(volume / 10);
  if (res == 0) {
    voiceplayer.setAsset('assets/music/喂.mp3');
  }
  if (res == 1) {
    voiceplayer.setAsset('assets/music/我在哦.mp3');
  }
  if (res == 2) {
    voiceplayer.setAsset('assets/music/听得见吗.mp3');
  }
  voiceplayer.play();
}

///查询应用信息
packageInfoList() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
}

//读取剧本
loadCVS() async {
  final rawData = await rootBundle.loadString(
    "assets/story/$nowChapter.csv",
  );
  List<List<dynamic>> listData =
      const CsvToListConverter().convert(rawData, eol: '\r');
  story = listData;
}
