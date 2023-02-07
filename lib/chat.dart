import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import 'send.dart';
import "package:get/get.dart";
import 'package:spring_button/spring_button.dart';

import 'dart:async';
import 'image.dart';
import 'config.dart';
import 'setting.dart';
import 'trend.dart';

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
  final ValueNotifier<bool> isChoose = ValueNotifier<bool>(false); //是否有选项,局部刷新
  String _chatName = "Miko";
  bool switchValue = false;
  int jump = 0;
  int choose_one_jump = 0; // 选项一跳转
  int choose_two_jump = 0; // 选项二跳转
  int last_line = 0; //最后一条

  @override
  void initState() {
    // loadMessage();
    // backgroundMusic();
    // packageInfoList();
    // loadCVS();
    // storyPlayer();
    loadMessage().then((_) {
      backgroundMusic();
      packageInfoList();
      loadCVS().then((_) async {
        await storyPlayer();
      });
    });
    WidgetsBinding.instance.addObserver(this); //增加监听者
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //页面销毁时，移出监听者
    WidgetsBinding.instance.removeObserver(this);
  }

//监听程序进入前后台的状态改变的方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //前台
      case AppLifecycleState.resumed:
        if (backgroundMusicSwitch) {
          bgmplayer.play();
        }
        break;
      //应用状态处于闲置状态
      // 这个状态切换到前后台会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        if (backgroundMusicSwitch) {
          bgmplayer.pause();
        }
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        break;
      // 后台
      case AppLifecycleState.paused:
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
        child: Image.asset('assets/images/聊天背景.png',
            width: 1.sw, height: 1.sh, fit: BoxFit.fitWidth),
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
                        padding: EdgeInsets.only(top: 40.h),
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
      Align(
          alignment: FractionalOffset(0.5, 1),
          child: ValueListenableBuilder(
            valueListenable: isChoose,
            builder: (context, value, child) {
              return chooseButton();
            },
          )),
      //输入框
      // Align(alignment: Alignment.bottomCenter, child: _buildTextComposer()),
      //菜单按钮
      GestureDetector(
          onTap: () {
            loadMap();
            Get.to(ImagePage());
          },
          child: Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w),
            alignment: Alignment.topLeft,
            child: Icon(Icons.menu, color: Colors.white, size: 40.r),
          )),
      //设置按钮
      GestureDetector(
          onTap: () async {
            load();
            Get.to(SettingPage('chat'));
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
    if (choose_one.isEmpty && choose_two.isEmpty) {
      return Container();
    }
    return Container(
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
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
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
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
                )),
          ),
          onTap: () {
            buttonMusic();
            sendRight(choose_two);
            jump = choose_two_jump;
          },
        ),
      ]),
    );
  }

  //发送右消息
  sendRight(String choose_text) {
    RightMsg message = RightMsg(text: choose_text);
    setState(() {
      messages.add(message);
      messagesInfo.add(message.toJsonString());
      saveChat();
    });
    if (scrolling) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        isChoose.value = false;
        choose_one = "";
        choose_two = "";
      });
    }
  }

  //发送中消息
  sendMiddle(String text, String color) {
    MiddleMsg message = MiddleMsg(
      text: text,
      color: color,
    );
    setState(() {
      messages.add(message);
      messagesInfo.add(message.toJsonString());
      saveChat();
    });
    if (scrolling) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  //发送左文本消息
  sendTextLeft(String text, String who) {
    LeftTextMsg message = LeftTextMsg(text: text, who: who);
    if (waitTyping) {
      chatName = who;
      _chatName = '对方输入中...';
      Future.delayed(Duration(seconds: (text.length / 4).ceil()), () {
        setState(() {
          messages.add(message);
          messagesInfo.add(message.toJsonString());
          saveChat();
        });
      });
    } else {
      setState(() {
        messages.add(message);
        messagesInfo.add(message.toJsonString());
        saveChat();
      });
    }
    if (scrolling) {
      Future.delayed(Duration(milliseconds: 100), () {
        _chatName = chatName;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  //发送左图片消息
  sendImgLeft(String img) {
    LeftImgMsg message = LeftImgMsg(img: img);
    setState(() {
      messages.add(message);
      messagesInfo.add(message.toJsonString());
      saveChat();
    });
    if (scrolling) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  //发送动态
  sendTrend(String trendText, String trendImg) {
    Trend trend = Trend(trendText: trendText, trendImg: trendImg);
    trends.add(trend);
    trendsInfo.add(trend.toJsonString());
    saveChat();
  }

  //输入框和发送按钮布局
  // ignore: unused_element
  Widget _buildTextComposer() {
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

  //发送消息
  Future<void> handleSubmitted(String text) async {
    // if (await Permission.notification.request().isGranted) {
    //   debugPrint("isGranted true");
    //   //点击发送通知
    //   Map params = {};
    //   params['type'] = 200;
    //   params['id'] = "10086";
    //   params['content'] = "content";
    //   notification.send("Miko", text, params: json.encode(params));
    // } else {
    //   requestPermission(Permission.notification);
    // }
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
      if (waitTyping) {
        _chatName = '对方输入中...';
        Future.delayed(Duration(seconds: (text.length / 4).ceil()), () {
          //刷新消息列表然后重建UI
          setState(() {
            messages.add(message);
            messagesInfo.add(message.toJsonString());
          });
        });
      } else {
        setState(() {
          messages.add(message);
          messagesInfo.add(message.toJsonString());
          saveChat();
        });
      }
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
    int line = 0; //当前下标
    String msg = ''; //消息
    List tag_list = []; //多标签
    String tag = ''; //单标签
    int be_jump = 0; //分支,被跳转
    int reast_line = 0; //BE时回到这行
    bool isStop = true; //控制播放器
    int startTime = 0; //当前时间戳大于这个的时间戳时继续播放

    while (isStop) {
      do {
        List line_info = await story[line];
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
            continue;
          }
          if (tag == '无') {
            last_line = line;
            reast_line = line;
            continue;
          }
          if (tag == '中') {
            last_line = line;
            sendMiddle(msg, name);
            continue;
          }
          if (tag == '左') {
            last_line = line;
            sendTextLeft(msg, name);
            continue;
          }
          if (tag == '右') {
            last_line = line;
            sendRight(msg);
            continue;
          }
          if (tag == '词典') {
            try {
              last_line = line;
              List _dt = dictionaryMap[msg];
              _dt[1] = 'true';
              dictionaryMap[msg] = _dt;
              EasyLoading.showToast('解锁新词典$msg',
                  toastPosition: EasyLoadingToastPosition.bottom);
              continue;
            } catch (error) {
              last_line = line;
              EasyLoading.showToast('词典解锁失败,请截图反馈',
                  toastPosition: EasyLoadingToastPosition.bottom);
              continue;
            }
          }
          if (tag == '图鉴') {
            last_line = line;
            sendImgLeft(msg);
            EasyLoading.showToast('解锁新图鉴$msg',
                toastPosition: EasyLoadingToastPosition.bottom);
            continue;
          }
          if (tag == '动态') {
            last_line = line;
            sendTrend(msg, name);
            sendMiddle('对方发布了一条新动态', '');
            continue;
          }
        }
        //多标签
        if (tag_list != []) {
          if (tag_list[0] == '左') {
            last_line = line;
            tag_list.forEach((key) {
              String str = key;
              if (str.substring(0, 2) == '分支') {
                be_jump = int.parse(str.substring(2, str.length));
                if (be_jump == jump) {
                  sendTextLeft(msg, name);
                }
              }
              try {
                jump = int.parse(tag_list[1]);
                if (tag_list.length == 2) {
                  sendTextLeft(msg, name);
                }
              } catch (error) {}
            });
            continue;
          }
          if (tag_list[0] == '右') {
            if (tag_list[1] == '选项' && choose_one.isEmpty) {
              choose_one = msg;
              choose_one_jump = int.parse(tag_list[2]);
            }
            if (tag_list[1] == '选项' && !choose_one.isEmpty) {
              choose_two = msg;
              choose_two_jump = int.parse(tag_list[2]);
            }
          }
          if (!choose_one.isEmpty && !choose_two.isEmpty) {
            isChoose.value = true;
          }
          if (tag_list[0] == '中') {
            last_line = line;
            if (tag_list.length == 4) {
              if (tag_list[1] != 0) {
                jump = int.parse(tag_list[1]);
              }
              startTime = DateTime.now().millisecondsSinceEpoch +
                  int.parse(tag_list[3]) * 100;
            }
          }
        }
        if (isChoose.value == false) {
          continue;
        }
        if (startTime != 0) {
          if (DateTime.now().millisecondsSinceEpoch > startTime) {
            startTime = 0;
            continue;
          }
        }
      } while (line < story.length);
    }
  }
}
