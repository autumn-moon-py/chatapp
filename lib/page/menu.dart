import 'package:chatapp/page/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

import '../config/setting_config.dart';
import 'dictionary.dart';
import 'image.dart';
import 'chapter.dart';
import 'setting.dart';

float1() {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        IsOnChatPage = true;
        // Get.back();
        Get.to(ChatPage());
      },
      heroTag: "btn1",
      tooltip: '聊天',
      child: Icon(Icons.chat),
    ),
  );
}

float2(String where) {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        setting_config_load();
        Get.to(SettingPage(where));
      },
      heroTag: "btn2",
      tooltip: '设置',
      child: Icon(Icons.settings),
    ),
  );
}

floatButton(String where) {
  return AnimatedFloatingActionButton(
      fabButtons: [float1(), float2(where)],
      colorStartAnimation: Colors.blue,
      colorEndAnimation: Colors.red,
      animatedIconData: AnimatedIcons.menu_close);
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int nowPage = 0;
  final PageController menuController = PageController();

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: topHeight),
            child: Stack(children: [
              PageView(
                controller: menuController,
                onPageChanged: (value) {
                  nowPage = value;
                  setState(() {});
                },
                children: <Widget>[
                  ImagePage(),
                  DictionaryPage(),
                  ChapterPage(),
                ],
              ),
              buildMenu()
            ])));
  }

  Widget menuButton(int num, String name, BottonColor) {
    return MaterialButton(
        splashColor: Color.fromRGBO(255, 255, 255, 0),
        highlightColor: Color.fromRGBO(255, 255, 255, 0),
        padding: EdgeInsets.only(bottom: 20.h),
        minWidth: (1 / 3).sw,
        onPressed: () {
          menuController.animateToPage(num,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
        child:
            Text(name, style: TextStyle(color: BottonColor, fontSize: 25.sp)));
  }

  buildMenu() {
    Color imageBottonColor = Colors.grey;
    Color dictionaryBottonColor = Colors.grey;
    Color chapterButtonColor = Colors.grey;
    if (nowPage == 0) {
      imageBottonColor = Colors.white;
    }
    if (nowPage == 1) {
      dictionaryBottonColor = Colors.white;
    }
    if (nowPage == 2) {
      chapterButtonColor = Colors.white;
    }
    return Stack(
      children: [
        Align(
            alignment: Alignment(0.5, -1),
            child: Container(
              color: Colors.black,
              width: 540.w,
              height: 40.h,
            )),
        Row(children: [
          menuButton(0, '图鉴', imageBottonColor),
          menuButton(1, '词典', dictionaryBottonColor),
          menuButton(2, '章节', chapterButtonColor)
        ])
      ],
    );
  }
}
