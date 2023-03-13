import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import "package:get/get.dart";
import 'package:spring_button/spring_button.dart';
import 'dart:math' as math;
import 'dart:async';

import '../config/chat_config.dart';
import '../config/dictionary_config.dart';
import '../config/setting_config.dart';
import '../config/image_config.dart';
import '../function/chat_function.dart';
import '../function/notification_service.dart';
import '../function/setting_funvtion.dart';
import 'myAppInfo.dart';
import 'setting.dart';
import 'trend.dart';
import 'menu.dart';
import '../function/bubble.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

//聊天页面布局
class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  String _chatName = "Miko";
  String download = '';

  @override
  initState() {
    super.initState();
    FlutterBackground.hasPermissions; //申请后台服务权限
    WidgetsBinding.instance.addObserver(this); //增加监听者
    message_load().then((_) {
      setting_config_load();
      // waitOffline = false;
      // nowChapter = '第一章';
      // imageList = imageList2;
      // line = 42;
      // be_jump = 328;
      // isDebug = true;
      // waitTyping = false;
      // isAutoUpgrade = false;
      pushSetup();
      buttonMusic();
      packageInfoList();
      backgroundMusic();
      backSetup();
      IsOnChatPage = true;
      Upgrade();
      loadCVS(nowChapter).then((_) async {
        await storyWhile();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //页面销毁时，移出监听者
    WidgetsBinding.instance.removeObserver(this);
    message_save();
  }

//监听程序进入前后台的状态改变的方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //前台
      case AppLifecycleState.resumed:
        isPaused = false;
        if (backgroundMusicSwitch) {
          bgmplayer.play();
        }
        break;
      // 切换前后台
      case AppLifecycleState.inactive:
        message_save();
        if (backgroundMusicSwitch) {
          bgmplayer.pause();
        }
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        message_save();
        break;
      // 后台
      case AppLifecycleState.paused:
        isPaused = true;
        message_save();
        if (backgroundMusicSwitch) {
          bgmplayer.pause();
        }
        break;
    }
  }

  //聊天窗口布局
  @override
  Widget build(BuildContext context) {
    AzhonAppUpdate.listener((map) {
      download = map['type'];
      setState(() {});
    });
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: topHeight),
            child: Stack(children: [
              Container(
                  color: Colors.black,
                  child: Center(
                    child: Text('加载中...',
                        style: TextStyle(color: Colors.white, fontSize: 40.r)),
                  )),
              Image.asset('assets/images/聊天背景.png',
                  height: 1.sh, fit: BoxFit.cover),
              Column(children: [
                Flexible(
                    child: messages.length == 0
                        ? Center(
                            child:
                                CircularProgressIndicator(color: Colors.white))
                        : SizeCacheWidget(
                            estimateCount: 60,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10.h,
                                    bottom: choose_one.isEmpty ? 10.h : 80.h),
                                child: ListView.builder(
                                  controller: scrollController,
                                  scrollDirection: Axis.vertical,
                                  reverse: false,
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (_, int index) =>
                                      messages[index],
                                  itemCount: messages.length,
                                ))))
              ]),
              Center(
                  child: Wrap(children: [
                Text(
                    !isDebug
                        ? ''
                        : '当前行: $line 跳转: $jump \r\n分支: $be_jump 章节: $nowChapter',
                    style: TextStyle(color: Colors.red, fontSize: 40.r))
              ])),
              //顶部状态栏
              Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 10.h),
                color: Colors.black,
                width: 1.sw,
                height: 50.h,
                child: GestureDetector(
                    onDoubleTap: () {
                      if (choose_one.isEmpty) {
                        EasyLoading.showToast('开始播放',
                            toastPosition: EasyLoadingToastPosition.top);
                        startTime = 0;
                        storyWhile();
                      } else {
                        EasyLoading.showToast('有选项时无法触发',
                            toastPosition: EasyLoadingToastPosition.top);
                      }
                    },
                    onTap: () {
                      if (isDebug) {
                        setState(() {
                          if (choose_one.isNotEmpty) {
                            choose_one = '';
                            choose_two = '';
                            line -= 2;
                          }
                          message_save();
                        });
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return RenameDialog(
                                contentWidget: RenameDialogContent(
                                  cancelBtnTitle: '取消',
                                  okBtnTitle: '确定',
                                  title: "请输入跳转行号(数字),有概率失败",
                                  okBtnTap: () {},
                                  vc: TextEditingController(),
                                  cancelBtnTap: () {},
                                ),
                              );
                            });
                      }
                    },
                    child: Text(
                      _chatName,
                      style: TextStyle(fontSize: 30.sp, color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
              ),
              //选项按钮
              Align(alignment: FractionalOffset(0.5, 1), child: chooseButton()),
              //菜单按钮
              GestureDetector(
                  onTap: () {
                    image_map_load();
                    dictionary_map_load();
                    IsOnChatPage = false;
                    if (choose_one.isNotEmpty) {
                      setState(() {
                        choose_one = '';
                        choose_two = '';
                        line -= 2;
                        message_save();
                      });
                    }
                    Get.to(MenuPage());
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.h, left: 10.w),
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.menu, color: Colors.white, size: 40.r),
                  )),
              //设置按钮
              GestureDetector(
                  onTap: () {
                    IsOnChatPage = false;
                    Get.to(SettingPage('chat'));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.h, right: 10.w),
                    alignment: Alignment.topRight,
                    child:
                        Icon(Icons.settings, color: Colors.white, size: 40.r),
                  )),
              download == 'downloading'
                  ? Stack(children: [
                      Container(color: Color.fromARGB(150, 0, 0, 0)),
                      Align(
                          alignment: Alignment.center,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Text(
                                        '更新时禁止操作\r\n下载时剧情暂停\r\n更新完重进\r\n或双击顶部名称即可继续播放',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.r),
                                        textAlign: TextAlign.center))
                              ]))
                    ])
                  : Container()
            ])));
  }

  //选项按钮布局
  chooseButton() {
    if (choose_one.isEmpty && choose_two.isEmpty) {
      return Container();
    }
    try {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    } catch (_) {}
    return FadeInUp(
        child: Container(
      width: 1.sw,
      height: 80.h,
      color: Colors.black,
      child: Row(children: [
        //选项一按钮
        SpringButton(
          SpringButtonType.OnlyScale,
          Container(
            width: 250.w,
            height: 60.h,
            margin: EdgeInsets.only(left: 13.w, right: 13.w),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  choose_one.toString(),
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                )),
          ),
          onTap: () {
            if (buttonMusicSwitch) {
              buttonplayer.play();
            } else {
              buttonplayer.pause();
            }
            jump = choose_one_jump;
            sendRight(choose_one.toString());
          },
        ),
        //选项二按钮
        SpringButton(
          SpringButtonType.OnlyScale,
          Container(
            width: 250.w,
            height: 60.h,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  choose_two.toString(),
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                )),
          ),
          onTap: () {
            if (buttonMusicSwitch) {
              buttonplayer.play();
            } else {
              buttonplayer.pause();
            }
            jump = choose_two_jump;
            sendRight(choose_two.toString());
          },
        ),
      ]),
    ));
  }

  //发送右消息
  sendRight(String choose_text) async {
    if (choose_text.isEmpty) {
      return;
    }
    RightMsg message = RightMsg(text: choose_text);
    choose_one = "";
    choose_two = "";
    messages.add(message);
    messagesInfo.add(message.toJsonString());
    message_save();
    setState(() {});
    Future.delayed(Duration(milliseconds: waitTyping ? 1000 : 200))
        .then((_) async => await storyWhile());
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //发送中消息
  sendMiddle(String text) {
    if (text.isEmpty) {
      return;
    }
    MiddleMsg message = MiddleMsg(text: text);
    messages.add(message);
    messagesInfo.add(message.toJsonString());
    message_save();
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //发送左文本消息
  sendTextLeft(String text, String who) async {
    if (text.isEmpty) {
      return;
    }
    LeftTextMsg message = LeftTextMsg(text: text, who: who);
    messages.add(message);
    messagesInfo.add(message.toJsonString());
    message_save();
    if (isPaused) {
      await NotificationService().newNotification(who, text, false);
    }
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //发送左图片消息
  sendImgLeft(String img) async {
    LeftImgMsg message = LeftImgMsg(img: img);
    messages.add(message);
    messagesInfo.add(message.toJsonString());
    message_save();
    image_map_save();
    if (isPaused) {
      await NotificationService().newNotification('Miko', '[图片]', false);
    }
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //发送动态
  sendTrend(String trendText, String trendImg) async {
    Trend trend = Trend(trendText: trendText, trendImg: trendImg);
    trends.add(trend);
    trendsInfo.add(trend.toJsonString());
    image_map_save();
    trend_save();
    if (isPaused) {
      await NotificationService().newNotification('Miko', '对方发布了一条动态', false);
    }
    message_save();
  }

  //发送语音
  sendVoice(String voice) async {
    VoiceMsg message = VoiceMsg(voice: voice);
    messages.add(message);
    messagesInfo.add(message.toJsonString());
    message_save();
    if (isPaused) {
      await NotificationService().newNotification('Miko', '[语音]', false);
    }
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  //播放器
  storyWhile() async {
    String msg = ''; //消息
    List tag_list = []; //多标签
    String tag = ''; //单标签
    do {
      if (choose_one.isNotEmpty && choose_two.isNotEmpty) {
        break;
      }
      if (startTime > 0 && DateTime.now().millisecondsSinceEpoch > startTime) {
        startTime = 0;
        continue;
      } else if (startTime > 0 &&
          DateTime.now().millisecondsSinceEpoch < startTime) {
        await Future.delayed(Duration(
            milliseconds: (startTime - DateTime.now().millisecondsSinceEpoch)));
        continue;
      }
      List line_info = story[line];
      line++;
      setState(() {});
      //空行继续
      if (line_info[0] == '' && line_info[1] == '' && line_info[2] == '') {
        continue;
      }
      String name = line_info[0].toString();
      msg = line_info[1].toString();
      tag = line_info[2];
      if (tag.length > 1) {
        tag_list = tag.split(',');
        tag = '';
      }
      //单标签
      if (!tag.isEmpty && jump == 0) {
        if (tag == '无') {
          reast_line = line;
          continue;
        }
        if (tag == '中') {
          if (name != '') {
            _chatName = name;
          }
          sendMiddle(msg);
          await Future.delayed(Duration(milliseconds: waitTyping ? 500 : 200));
          continue;
        }
        if (tag == '左') {
          sendTextLeft(msg, name);
          _chatName = '对方输入中...';
          await Future.delayed(
              Duration(seconds: waitTyping ? (msg.length / 4).ceil() : 1));
          _chatName = name;
          continue;
        }
        if (tag == '右') {
          sendRight(msg);
          await Future.delayed(Duration(milliseconds: waitTyping ? 500 : 200));
          continue;
        }
      }
      //多标签
      if (tag_list != []) {
        if (tag_list[0] == '语音') {
          sendVoice(msg);
          await Future.delayed(
              Duration(seconds: waitTyping ? (msg.length / 4).ceil() : 1));
          continue;
        }
        if (tag_list[0] == '词典' && jump == 0) {
          try {
            List _dt = dictionaryMap[msg];
            _dt[1] = 'true';
            dictionaryMap[msg] = _dt;
            EasyLoading.showToast('解锁新词典',
                toastPosition: EasyLoadingToastPosition.bottom);
            dictionary_map_save();
            continue;
          } catch (error) {
            EasyLoading.showToast('解锁$msg失败,报错$error',
                toastPosition: EasyLoadingToastPosition.bottom);
          }
        }
        if (tag_list[0] == 'BE' && jump == 0) {
          line = reast_line;
          messages = [];
          messagesInfo = [];
          message_save();
          setState(() {});
          continue;
        }
        if (tag_list[0] == '图鉴' && jump == 0) {
          if (msg.substring(5, 7) != '-n' && msg.substring(0, 1) != 'W') {
            sendImgLeft(msg);
          }
          await Future.delayed(Duration(milliseconds: waitTyping ? 500 : 200));
          imageMap[msg] = true;
          EasyLoading.showToast('解锁新图鉴$msg',
              toastPosition: EasyLoadingToastPosition.bottom);
          continue;
        }
        if (tag_list[0] == '动态' && jump == 0) {
          sendTrend(msg, name);
          imageMap[name] = true;
          try {
            imageMap['$name-n'] = true;
          } catch (e) {
            print('$e');
          }
          EasyLoading.showToast('解锁新图鉴$name',
              toastPosition: EasyLoadingToastPosition.bottom);
          sendMiddle('对方发布了一条新动态');
          await Future.delayed(Duration(milliseconds: waitTyping ? 500 : 200));
          continue;
        }
        if (tag_list[0] == '左') {
          if (tag_list.length == 2) {
            //左,分支XX
            String str = tag_list[1];
            if (str.substring(0, 2) == '分支') {
              be_jump = int.parse(str.substring(2, str.length));
              if (be_jump == jump) {
                _chatName = '对方输入中...';
                jump = 0;
                sendTextLeft(msg, name);
                await Future.delayed(Duration(
                    seconds: waitTyping ? (msg.length / 4).ceil() : 1));
                _chatName = name;
                continue;
              }
            } else if (jump == 0) {
              //左,XX
              jump = int.parse(tag_list[1]);
              _chatName = '对方输入中...';
              sendTextLeft(msg, name);
              await Future.delayed(
                  Duration(seconds: waitTyping ? (msg.length / 4).ceil() : 1));
              _chatName = name;
              bool needToNewLine = false;
              for (int j = math.max(0, line - 100); j < line; j++) {
                List li = story[j];
                if (li[0] == '' && li[1] == '' && li[2] == '') {
                  continue;
                }
                String tg = li[2];
                if (tg.length > 1) {
                  List tl = tg.split(',');
                  if (tl.isNotEmpty && tl.length == 2) {
                    //左/中,分支XX
                    String tlStr = tl[1];
                    if (tlStr.substring(0, 2) == '分支') {
                      String tlBeJump = tl[1];
                      int tlJp =
                          int.parse(tlBeJump.substring(2, tlBeJump.length));
                      if (tl[0] == tag_list[0] && tlJp == jump) {
                        line = j;
                        needToNewLine = true;
                        break;
                      }
                    }
                  }
                }
              }
              if (needToNewLine) {
                continue;
              }
            }
          }
          if (tag_list.length == 3) {
            //左,XX,分支XX
            _chatName = '对方输入中...';
            String str = tag_list[2];
            be_jump = int.parse(str.substring(2, str.length));
            if (be_jump == jump) {
              jump = int.parse(tag_list[1]);
              sendTextLeft(msg, name);
              await Future.delayed(
                  Duration(seconds: waitTyping ? (msg.length / 4).ceil() : 1));
              _chatName = name;
              bool needToNewLine = false;
              for (int j = math.max(0, line - 100); j < line; j++) {
                List li = story[j];
                if (li[0] == '' && li[1] == '' && li[2] == '') {
                  continue;
                }
                String tg = li[2];
                if (tg.length > 1) {
                  List tl = tg.split(',');
                  if (tl.isNotEmpty && tl.length == 2) {
                    String tlStr1 = tl[1]; //分支
                    int tlJp = int.parse(tlStr1.substring(2, tlStr1.length));
                    if (tl[0] == tag_list[0] && tlJp == jump) {
                      line = j;
                      needToNewLine = true;
                      break;
                    }
                  }
                }
              }
              if (needToNewLine) {
                continue;
              }
            }
          }
        }
        if (tag_list[0] == '右' && jump == 0 && tag_list.length == 3) {
          //右,选项,XX
          if (tag_list[1] == '选项' && choose_one.isEmpty) {
            choose_one = msg;
            choose_one_jump = int.parse(tag_list[2]);
            continue;
          }
          if (tag_list[1] == '选项' && choose_two.isEmpty) {
            choose_two = msg;
            choose_two_jump = int.parse(tag_list[2]);
            setState(() {});
            break;
          }
        }
        if (tag_list[0] == '中') {
          if (tag_list.length == 4) {
            //中,XX,等待,XX
            if (tag_list[1] != 0 && jump == 0) {
              jump = int.parse(tag_list[1]);
              bool needToNewLine = false;
              for (int j = math.max(0, line - 100); j < line; j++) {
                List _line = story[j];
                String _tag = _line[2];
                if (_tag.length > 1) {
                  List _tag_list = _tag.split(',');
                  if (_tag_list.length == 2) {
                    String tlStr1 = _tag_list[1];
                    if (tlStr1.substring(0, 2) == '分支') {
                      //左/中,分支XX
                      int tlJp = int.parse(tlStr1.substring(2, tlStr1.length));
                      if (_tag_list[0] == tag_list[0] && tlJp == jump) {
                        line = j;
                        needToNewLine = true;
                        break;
                      }
                    }
                  }
                }
              }
              if (needToNewLine) {
                continue;
              }
            }
            startTime = waitOffline
                ? DateTime.now().millisecondsSinceEpoch +
                    int.parse(tag_list[3]) * 60000
                : -1;
            EasyLoading.showToast('如果上线时间到了仍未上线则双击顶部名称',
                toastPosition: EasyLoadingToastPosition.bottom);
            if (waitOffline) {
              Future.delayed(
                  Duration(milliseconds: int.parse(tag_list[3]) * 60000),
                  () async {
                await storyWhile();
              });
              break;
            }
            continue;
          }
        }
        if (tag_list.length == 2) {
          //中,分支XX
          String str = tag_list[1];
          be_jump = int.parse(str.substring(2, str.length));
          if (be_jump == jump) {
            jump = 0;
            sendMiddle(msg);
            await Future.delayed(
                Duration(microseconds: waitTyping ? 500 : 200));
            continue;
          }
        }
        if (tag_list.length == 3) {
          //中,XX,分支XX
          String str = tag_list[2];
          be_jump = int.parse(str.substring(2, str.length));
          if (jump == be_jump) {
            str = tag_list[1];
            jump = int.parse(str);
            sendMiddle(msg);
            await Future.delayed(
                Duration(microseconds: waitTyping ? 500 : 200));
            bool needToNewLine = false;
            for (int j = math.max(0, line - 100); j < line; j++) {
              List li = story[j];
              if (li[0] == '' && li[1] == '' && li[2] == '') {
                continue;
              }
              String tg = li[2];
              if (tg.length > 1) {
                List tl = tg.split(',');
                if (tl.isNotEmpty && tl.length == 2) {
                  String tlStr1 = tl[1]; //分支
                  int tlJp = int.parse(tlStr1.substring(2, tlStr1.length));
                  if (tl[0] == tag_list[0] && tlJp == jump) {
                    line = j;
                    needToNewLine = true;
                    break;
                  }
                }
              }
            }
            if (needToNewLine) {
              continue;
            }
          }
        }
      }
    } while (line < story.length);
  }
}
