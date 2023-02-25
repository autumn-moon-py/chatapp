import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import '../function/bubble.dart';
import 'dictionary_config.dart';
import 'image_config.dart';

FocusNode userFocusNode = FocusNode(); //输入框焦点控件
final TextEditingController textController = TextEditingController(); //输入框状态控件
late ScrollController scrollController; //动态列表控件
bool isComposing = false; //输入状态
bool switchValue = false; //自娱自乐切换左右
bool isPaused = false; //是否在后台
List messages = []; //消息容器列表
List<String> messagesInfo = []; //消息信息列表
List<List<dynamic>> story = []; //剧本列表
String nowChapter = '第一章'; //当前章节
String chatName = "Miko"; //聊天对象名称
int line = 0; //当前下标
int startTime = 0; //等待,时间戳
int jump = 0; //跳转
int be_jump = 0; //分支,被跳转
int reast_line = 0; //BE时回到这行
String choose_one = ''; //选项一
String choose_two = ''; //选项二
int choose_one_jump = 0; //选项一跳转
int choose_two_jump = 0; //选项二跳转

///保存播放器配置
story_save() async {
  local = await SharedPreferences.getInstance();
  local?.setStringList('messagesInfo', messagesInfo);
  local?.setInt('line', line);
  local?.setInt('startTime', startTime);
  local?.setInt('jump', jump);
  local?.setInt('be_jump', be_jump);
  local?.setInt('reast_line', reast_line);
  local?.setString('nowChapter', nowChapter);
}

///读取播放器配置
story_load() async {
  local = await SharedPreferences.getInstance();
  line = local?.getInt('line') ?? 0;
  startTime = local?.getInt('startTime') ?? 0;
  jump = local?.getInt('jump') ?? 0;
  be_jump = local?.getInt('be_jump') ?? 0;
  reast_line = local?.getInt('reast_line') ?? 0;
  nowChapter = local?.getString('nowChapter') ?? '第一章';
}

///保存历史消息
message_save() async {
  local = await SharedPreferences.getInstance();
  local?.setStringList('messagesInfo', messagesInfo);
  story_save();
  image_map_save();
  dictionary_map_save();
}

///读取历史消息
message_load() async {
  story_load();
  local = await SharedPreferences.getInstance();
  messagesInfo = local?.getStringList('messagesInfo') ?? [];
  Map _messagesInfo = {};
  int num = 0;
  if (messagesInfo != []) {
    for (int i = 0; i < messagesInfo.length; i++) {
      _messagesInfo[i] = fromJsonString(messagesInfo[i]);
    }
    // if (_messagesInfo.length >= 60) {
    //   num = _messagesInfo.length - 60;
    // }
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
        if (messageMap['位置'] == '语音') {
          VoiceMsg message = VoiceMsg(voice: messageMap['voice']);
          messages.add(message);
          i++;
        }
        if (messageMap['位置'] == '中') {
          MiddleMsg message = MiddleMsg(text: messageMap['text']);
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
