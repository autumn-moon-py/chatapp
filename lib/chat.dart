import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import 'send.dart';
import "package:get/get.dart";
import 'package:spring_button/spring_button.dart';

import 'dart:async';
import 'image.dart';
import 'config.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatPageState createState() => ChatPageState();
}

//聊天页面布局
class ChatPageState extends State<ChatPage> {
  final TextEditingController _textController =
      TextEditingController(); //输入框状态控件
  ScrollController _scrollController = ScrollController(); //动态列表控件
  FocusNode userFocusNode = FocusNode(); //输入框焦点控件
  bool isComposing = false; //输入状态
  final ValueNotifier<bool> isChoose = ValueNotifier<bool>(false); //是否有选项,局部刷新
  String _chatName = "Miko";

  //聊天窗口布局
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //聊天窗口容器
        body: Stack(children: [
      //点击监控
      GestureDetector(
        onTap: () {
          userFocusNode.unfocus(); //点击聊天窗口丢失焦点
        },
        //背景
        child: Image.asset('assets/images/聊天背景.png', width: 1.sw, height: 1.sh),
      ),
      Padding(
        //聊天窗口内边距
        padding: EdgeInsets.only(top: (1 / 24).sh, bottom: 0.083.sh),
        child: Flexible(
            child: SizeCacheWidget(
                estimateCount: 15,
                child: ListView.builder(
                  controller: _scrollController, //绑定控件
                  scrollDirection: Axis.vertical, //垂直滑动
                  reverse: false, //正序显示
                  shrinkWrap: true, //内容适配
                  physics: BouncingScrollPhysics(), //内容超过一屏 上拉有回弹效果
                  itemBuilder: (_, int index) => messages[index],
                  itemCount: messages.length,
                ))),
      ),
      //顶部状态栏
      Align(
        alignment: FractionalOffset(0.5, 0.0),
        child: Container(
          padding: EdgeInsets.only(top: 0.02.sh),
          color: Colors.black,
          width: 1.sw,
          height: 0.0625.sh,
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
              return chooseButton(choose_one, choose_two);
            },
          )),
      //输入框
      Align(alignment: FractionalOffset(0.5, 1.0), child: _buildTextComposer()),
      //菜单按钮
      GestureDetector(
          onTap: () {
            loadMap();
            Get.to(ImagePage());
          },
          child: Container(
            padding: EdgeInsets.only(top: (1 / 64).sh, left: (1 / 54).sw),
            alignment: Alignment.topLeft,
            child: Icon(Icons.menu, color: Colors.white, size: (1 / 13.5).sw),
          )),
    ]));
  }

  //选项按钮布局
  chooseButton(String choose_one, String choose_two) {
    if (choose_one.isEmpty && choose_two.isEmpty) {
      return Container();
    }
    isChoose.value = true;
    return Container(
      width: 1.sw,
      height: 0.083.sh,
      color: Colors.black,
      child: Row(children: [
        //选项一按钮
        SpringButton(
          SpringButtonType.OnlyScale,
          Container(
            width: 0.45.sw,
            height: 0.0625.sh,
            margin: EdgeInsets.only(left: (0.1 / 3).sw, right: (0.1 / 3).sw),
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  choose_one,
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                )),
          ),
          onTap: () => choose(choose_one),
        ),
        //选项二按钮
        SpringButton(
          SpringButtonType.OnlyScale,
          Container(
            width: 0.45.sw,
            height: 0.0625.sh,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  choose_two,
                  softWrap: true,
                  style: TextStyle(color: Colors.white, fontSize: 25.sp),
                )),
          ),
          onTap: () => choose(choose_two),
        ),
      ]),
    );
  }

  //发送选项
  choose(String choose_text) {
    RightMsg message = RightMsg(
      text: choose_text,
    ); //发送消息
    setState(() {
      messages.add(message);
    }); //刷新消息列表然后重建UI
    //延迟500毫秒自动滚屏
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      isChoose.value = false;
      choose_one = "";
      choose_two = "";
    });
  }

  //输入框和发送按钮布局
  // ignore: unused_element
  Widget _buildTextComposer() {
    return Container(
        width: 1.sw, //底部宽
        height: 0.083.sh, //底部高
        color: Colors.black, //底部背景颜色
        child: Row(
          children: [
            //输入框容器
            Container(
              width: (1 / 1.21).sw, //输入框宽
              height: 0.05.sh, //输入框高
              margin:
                  EdgeInsets.only(left: (1 / 54).sw, right: (1 / 54).sw), //外边距
              decoration: BoxDecoration(
                  color: Color.fromRGBO(26, 26, 26, 1), //输入框背景色
                  borderRadius: BorderRadius.all(Radius.circular(10.0)) //圆角角度
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
                    height: 1,
                    fontSize: 25.sp,
                    color: Colors.white), //输入框内光标大小,文本字体大小
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)), //输入框下划线颜色
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10) //使输入框文本垂直居中
                    ),
              ),
            ),
            //发送按钮容器
            Container(
              width: (1 / 8).sw,
              height: (1 / 27.4).sh,
              //发送按钮控件
              child: TextButton(
                  child: Text(
                    "发送",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(125, 154, 220, 1),
                  ),
                  //调用发送消息
                  onPressed: isComposing
                      ? () => handleSubmitted(_textController.text)
                      : null),
            )
          ],
        ));
  }

  //发送消息
  void handleSubmitted(String text) {
    if (text.isEmpty) {
      userFocusNode.unfocus(); //丢失输入框焦点,收起软键盘
      return null; //不发送空消息
    }
    _textController.clear(); //清除输入框
    setState(() {
      isComposing = false;
    }); //没有在输入
    userFocusNode.unfocus(); //丢失输入框焦点
    //新建消息
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
        });
      });
    } else {
      setState(() {
        messages.add(message);
      });
    }
    //延迟500毫秒自动滚屏
    if (scrolling) {
      Future.delayed(Duration(milliseconds: 100), () {
        _chatName = chatName;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }
}
