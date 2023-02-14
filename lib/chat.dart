import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import "package:get/get.dart";
import 'package:spring_button/spring_button.dart';
import 'dart:math' as math;

import 'dart:async';
import 'config.dart';
import 'setting.dart';
import 'trend.dart';
import 'menu.dart';
import 'send.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

//聊天页面布局
class ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _textController =
      TextEditingController(); //输入框状态控件
  ScrollController _scrollController = ScrollController(); //动态列表控件
  FocusNode userFocusNode = FocusNode(); //输入框焦点控件
  bool isComposing = false; //输入状态
  String _chatName = "Miko";
  bool switchValue = false; //自娱自乐切换左右
  bool isPaused = false; //是否在后台

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); //增加监听者
    // loadMessage().then((_) {
    backgroundMusic();
    buttonplayer.setAsset('assets/music/选项音效.mp3');
    packageInfoList();
    loadCVS().then((_) async {
      await storyPlayer();
    });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    //页面销毁时，移出监听者
    WidgetsBinding.instance.removeObserver(this);
    saveChat();
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
        saveChat();
        if (backgroundMusicSwitch) {
          bgmplayer.pause();
        }
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        if (!choose_one.isEmpty && !choose_two.isEmpty) {
          line -= 3;
          jump = 0;
          be_jump = 0;
          choose_one = '';
          choose_two = '';
          choose_one_jump = 0;
          choose_two_jump = 0;
        }
        saveChat();
        break;
      // 后台
      case AppLifecycleState.paused:
        isPaused = true;
        saveChat();
        if (backgroundMusicSwitch) {
          bgmplayer.pause();
        }
        break;
    }
  }

  //聊天窗口布局
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    return Scaffold(
        //聊天窗口容器
        body: Stack(children: [
      // 点击监控
      GestureDetector(
        onTap: () {
          userFocusNode.unfocus(); //点击聊天窗口丢失焦点
        },
        //背景
        child: Platform.isAndroid
            ? Image.asset('assets/images/聊天背景.png',
                height: 1.sh, fit: BoxFit.cover)
            : CachedNetworkImage(
                height: 1.sh,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                imageUrl:
                    'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/聊天背景.png',
                errorWidget: (context, url, error) => Text(
                  '加载失败,请检查网络',
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
                ),
              ),
      ),

      GestureDetector(
          onTap: () {
            userFocusNode.unfocus(); //点击聊天窗口丢失焦点
          },
          child: Column(children: [
            Flexible(
                child: SizeCacheWidget(
                    estimateCount: 60,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: 40.h, bottom: choose_one.isEmpty ? 0 : 80.h),
                        child: ListView.builder(
                          controller: _scrollController, //绑定控件
                          scrollDirection: Axis.vertical, //垂直滑动
                          reverse: false, //正序显示
                          shrinkWrap: true, //内容适配
                          physics: BouncingScrollPhysics(), //内容超过一屏 上拉有回弹效果
                          itemBuilder: (_, int index) => messages[index],
                          itemCount: messages.length,
                        ))))
          ])),

      //顶部状态栏
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.only(top: 10.h),
          color: Colors.black,
          width: 1.sw,
          height: 50.h,
          child: Text(
            _chatName,
            style: TextStyle(fontSize: 30.sp, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      //选项按钮
      Align(alignment: FractionalOffset(0.5, 1), child: chooseButton()),
      //输入框
      Align(alignment: Alignment.bottomCenter, child: _buildTextComposer()),
      //菜单按钮
      GestureDetector(
          onTap: () {
            if (!choose_one.isEmpty) {
              EasyLoading.showToast('有选项时无法前往菜单页面',
                  toastPosition: EasyLoadingToastPosition.bottom);
            } else {
              loadMap();
              Get.to(MenuPage());
            }
          },
          child: Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w),
            alignment: Alignment.topLeft,
            child: Icon(Icons.menu, color: Colors.white, size: 40.r),
          )),
      //设置按钮
      GestureDetector(
          onTap: () async {
            if (!choose_one.isEmpty) {
              EasyLoading.showToast('有选项时无法前往设置页面',
                  toastPosition: EasyLoadingToastPosition.bottom);
            } else {
              load();
              Get.to(SettingPage('chat'));
            }
          },
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.only(top: 8.h, right: 5.w),
            alignment: Alignment.topRight,
            child: Icon(Icons.settings, color: Colors.white, size: 40.r),
          ))
    ]));
  }

  //选项按钮布局
  chooseButton() {
    if (choose_one.isEmpty && choose_two.isEmpty || scrolling) {
      return Container();
    }
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
                  choose_one,
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                )),
          ),
          onTap: () {
            buttonMusic();
            sendRight(choose_one);
            jump = choose_one_jump;
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
                  choose_two,
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 20.sp),
                )),
          ),
          onTap: () {
            buttonMusic();
            sendRight(choose_two);
            jump = choose_two_jump;
          },
        ),
      ]),
    ));
  }

//输入框和发送按钮布局
  Widget _buildTextComposer() {
    if (!scrolling) {
      return Container();
    }
    return Container(
        width: 1.sw, //底部宽
        height: 75.h, //底部高
        color: Colors.black, //底部背景颜色
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            //输入框容器
            Container(
              width: 370.w,
              height: 50.h, //输入框高
              margin: EdgeInsets.only(left: 10.w), //外边距
              decoration: BoxDecoration(
                  color: Color.fromRGBO(26, 26, 26, 1), //输入框背景色
                  borderRadius: BorderRadius.all(Radius.circular(5.0)) //圆角角度
                  ),
              child: TextField(
                //如果输入框字符大于0判断为输入中
                onChanged: (String text) {
                  setState(() {
                    isComposing = text.length > 0;
                  });
                },
                controller: _textController, //输入框控件
                onSubmitted: handleSubmitted, //回车调用发送消息
                focusNode: userFocusNode, //输入框焦点控制
                style: TextStyle(
                    height: 2.h,
                    fontSize: 25.sp,
                    color: Colors.white), //输入框内光标大小
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)), //输入框下划线颜色
                    contentPadding: EdgeInsets.only(bottom: 22.h, left: 10.w)),
              ),
            ),
            Switch(
              onChanged: (value) {
                switchValue = !switchValue;
                setState(() {});
              },
              value: switchValue,
              activeColor: Colors.white,
              activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
              inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
            ),
            GestureDetector(
                onTap: isComposing
                    ? () => handleSubmitted(_textController.text)
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    alignment: Alignment.center,
                    width: 68.w,
                    height: 40.h,
                    color: Color.fromRGBO(0, 101, 202, 1),
                    child: Text(
                      "发送",
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                )),
          ],
        ));
  }

  //发送右消息
  sendRight(String choose_text) {
    if (choose_text.isEmpty) {
      return;
    }
    RightMsg message = RightMsg(text: choose_text);
    choose_one = "";
    choose_two = "";
    setState(() {
      messages.add(message);
      messagesInfo.add(message.toJsonString());
      saveChat();
    });
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      storyPlayer();
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
    saveChat();
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
    saveChat();
    setState(() {});
    if (waitTyping) {}
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  //发送左图片消息
  sendImgLeft(String img) async {
    LeftImgMsg message = LeftImgMsg(img: img);
    setState(() {
      messages.add(message);
      messagesInfo.add(message.toJsonString());
      saveChat();
    });
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  //发送动态
  sendTrend(String trendText, String trendImg) async {
    Trend trend = Trend(trendText: trendText, trendImg: trendImg);
    trends.add(trend);
    trendsInfo.add(trend.toJsonString());
    saveChat();
  }

  //输入框发送消息
  Future<void> handleSubmitted(String text) async {
    if (text.isEmpty) {
      userFocusNode.unfocus(); //丢失输入框焦点,收起软键盘
      return null; //不发送空消息
    }
    _textController.clear(); //清除输入框
    setState(() {
      isComposing = false;
    }); //没有在输入
    userFocusNode.unfocus(); //丢失输入框焦点
    if (switchValue) {
      RightMsg message = RightMsg(text: text);
      setState(() {
        messages.add(message);
        messagesInfo.add(message.toJsonString());
        saveChat();
      });
      if (scrolling) {
        Future.delayed(Duration(milliseconds: 100), () {
          _chatName = chatName;
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    } else {
      LeftTextMsg message = LeftTextMsg(
        who: 'Miko',
        text: text,
      );
      setState(() {
        messages.add(message);
        messagesInfo.add(message.toJsonString());
      });
      //延迟自动滚屏
      if (scrolling) {
        Future.delayed(Duration(milliseconds: 100), () {
          _chatName = chatName;
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  //播放器
  storyPlayer() async {
    String msg = ''; //消息
    List tag_list = []; //多标签
    String tag = ''; //单标签
    do {
      if (startTime > 0 && DateTime.now().millisecondsSinceEpoch < startTime) {
        continue;
      }
      startTime = 0;
      List line_info = story[line];
      line++;
      //空行继续
      if (line_info[0] == '' && line_info[1] == '' && line_info[2] == '') {
        continue;
      }
      String name = line_info[0];
      msg = line_info[1];
      tag = line_info[2];
      if (tag.length > 1) {
        tag_list = tag.split(',');
        tag = '';
      }
      //单标签
      if (!tag.isEmpty && jump == 0) {
        if (tag == 'BE') {
          line = reast_line;
          messages = [];
          messagesInfo = [];
          saveChat();
          continue;
        }
        if (tag == '无') {
          reast_line = line;
          continue;
        }
        if (tag == '中') {
          sendMiddle(msg);
          continue;
        }
        if (tag == '左') {
          sendTextLeft(msg, name);
          continue;
        }
        if (tag == '右') {
          sendRight(msg);
          continue;
        }
        if (tag == '词典') {
          try {
            List _dt = dictionaryMap[msg];
            _dt[1] = 'true';
            dictionaryMap[msg] = _dt;
            EasyLoading.showToast('解锁新词典$msg',
                toastPosition: EasyLoadingToastPosition.bottom);
            continue;
          } catch (error) {
            EasyLoading.showToast('词典解锁失败,请截图反馈',
                toastPosition: EasyLoadingToastPosition.bottom);
            continue;
          }
        }
        if (tag == '图鉴') {
          sendImgLeft(msg);
          imageMap[msg] = true;
          EasyLoading.showToast('解锁新图鉴$msg',
              toastPosition: EasyLoadingToastPosition.bottom);
          continue;
        }
        if (tag == '图片') {
          imageMap[msg] = true;
          continue;
        }
        if (tag == '动态') {
          sendTrend(msg, name);
          imageMap[name] = true;
          EasyLoading.showToast('解锁新图鉴$name',
              toastPosition: EasyLoadingToastPosition.bottom);
          sendMiddle('对方发布了一条新动态');
          continue;
        }
      }
      //多标签
      if (tag_list != []) {
        if (tag_list[0] == '左') {
          if (tag_list.length == 2) {
            //左,分支XX
            String str = tag_list[1];
            try {
              if (str.substring(0, 2) == '分支') {
                be_jump = int.parse(str.substring(2, str.length));
                if (be_jump == jump) {
                  jump = 0;
                  sendTextLeft(msg, name);
                  continue;
                }
              }
            } catch (error) {
              //左,XX
              jump = int.parse(str);
              sendTextLeft(msg, name);

              continue;
            }
          }
          if (tag_list.length == 3) {
            //左,XX,分支XX
            jump = int.parse(tag_list[1]);
            String str = tag_list[2];
            be_jump = int.parse(str.substring(2, str.length));
            if (be_jump == jump) {
              jump = 0;
              sendTextLeft(msg, name);

              continue;
            }
          } else {
            //上下搜索跳转分支
            sendTextLeft(msg, name);
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
        if (tag_list[0] == '右') {
          //右,选项,XX
          if (tag_list[1] == '选项' && choose_one.isEmpty) {
            choose_one = msg;
            choose_one_jump = int.parse(tag_list[2]);
            continue;
          }
          if (tag_list[1] == '选项' && !choose_one.isEmpty) {
            choose_two = msg;
            choose_two_jump = int.parse(tag_list[2]);
            break;
          }
        }
        if (tag_list[0] == '中') {
          if (tag_list.length == 4) {
            //中,XX,等待,XX
            if (tag_list[1] != 0) {
              jump = int.parse(tag_list[1]);
            }
            startTime = DateTime.now().millisecondsSinceEpoch +
                int.parse(tag_list[3]) * 60000;
            Future.delayed(
                Duration(milliseconds: int.parse(tag_list[3]) * 60000),
                () async {
              await storyPlayer();
            });
            sendMiddle(msg);
            break;
          }
          if (tag_list.length == 2) {
            //中,分支XX
            String str = tag_list[1];
            be_jump = int.parse(str.substring(2, str.length));
            if (be_jump == jump) {
              jump = 0;
              sendMiddle(msg);
              continue;
            }
          }
        }
      }
    } while (line < story.length);
  }
}
