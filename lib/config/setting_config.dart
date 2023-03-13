import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

bool isNew = true; //最新版
bool isDebug = false; //调试信息
bool isNewImage = false; //AI图鉴
bool waitOffline = true; //是否等待下线
bool waitTyping = true; //打字时间
int nowMikoAvater = 1; //miko当前头像
String playerAvatarSet = '默认'; //玩家头像
int playerNowAvater = 0; //玩家头像下拉框默认值
bool backgroundMusicSwitch = true; //音乐
bool isOldBgm = false; //新旧BGM
final bgmplayer = AudioPlayer();
bool buttonMusicSwitch = true; //音效
double sliderValue = 10; //语音音量
bool voiceIsStop = true;
bool IsOnChatPage = true;
final buttonplayer = AudioPlayer();
bool isChange = false; //监听设置修改
double topHeight = ScreenUtil().statusBarHeight; //状态栏高度

//Miko头像更换
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
//玩家头像更换
List playerDropdownList = [
  {'label': '默认头像', 'value': 0},
  {'label': '上传图片', 'value': 1}
];

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

///按钮音效设置
buttonMusic() {
  buttonplayer.setAsset('assets/music/选项音效.mp3');
  buttonplayer.setVolume(1);
  buttonplayer.setLoopMode(LoopMode.off);
}

///保存设置
setting_config_save() async {
  local = await SharedPreferences.getInstance();
  await local?.setBool('isNewImage', isNewImage);
  await local?.setInt('nowMikoAvater', nowMikoAvater);
  await local?.setBool('waitOffline', waitOffline);
  await local?.setBool('waitTyping', waitTyping);
  await local?.setString('playerAvatarSet', playerAvatarSet);
  await local?.setInt('playerNowAvater', playerNowAvater);
  await local?.setBool('backgroundMusicSwitch', backgroundMusicSwitch);
  await local?.setBool('buttonMusicSwitch', buttonMusicSwitch);
  await local?.setBool('isOldBgm', isOldBgm);
  await local?.setDouble('sliderValue', sliderValue);
}

///读取设置
setting_config_load() async {
  local = await SharedPreferences.getInstance();
  isNewImage = local?.getBool('isNewImage') ?? false;
  nowMikoAvater = local?.getInt('nowMikoAvater') ?? 1;
  waitOffline = local?.getBool('waitOffline') ?? true;
  waitTyping = local?.getBool('waitTyping') ?? true;
  playerAvatarSet = local?.getString('playerAvatarSet') ?? '默认';
  playerNowAvater = local?.getInt('playerNowAvater') ?? 0;
  backgroundMusicSwitch = local?.getBool('backgroundMusicSwitch') ?? true;
  buttonMusicSwitch = local?.getBool('buttonMusicSwitch') ?? true;
  isOldBgm = local?.getBool('isOldBgm') ?? false;
  sliderValue = local?.getDouble('sliderValue') ?? 10;
}
