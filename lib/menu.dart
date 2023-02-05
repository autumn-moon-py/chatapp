import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

import 'chat.dart';
import 'config.dart';
import 'dictionary.dart';
import 'image.dart';
import 'chapter.dart';
import 'setting.dart';

buildMenu(String nowPage) {
  Color imageBottonColor = Colors.grey;
  Color dictionaryBottonColor = Colors.grey;
  Color chapterButtonColor = Colors.grey;
  if (nowPage == "图鉴") {
    imageBottonColor = Colors.white;
  }
  if (nowPage == "词典") {
    dictionaryBottonColor = Colors.white;
  }
  if (nowPage == "章节") {
    chapterButtonColor = Colors.white;
  }
  return Align(
      alignment: Alignment(0.5, -1),
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            width: 540.w,
            height: 40.h,
          ),
          Row(children: [
            GestureDetector(
              onTap: () {
                loadMap();
                Get.to(ImagePage());
              },
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0),
                width: 180.w,
                height: 40.h,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('图鉴',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: imageBottonColor, fontSize: 25.sp))),
              ),
            ),
            GestureDetector(
              onTap: () {
                loadMap();
                Get.to(DictionaryPage());
              },
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0),
                width: 180.w,
                height: 40.h,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('词典',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: dictionaryBottonColor, fontSize: 25.sp))),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(ChapterPage());
              },
              child: Container(
                color: Color.fromRGBO(255, 255, 255, 0),
                width: 180.w,
                height: 40.h,
                child: Align(
                    alignment: Alignment.center,
                    child: Text('章节',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: chapterButtonColor, fontSize: 25.sp))),
              ),
            )
          ])
        ],
      ));
}

float1() {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
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
        load();
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
