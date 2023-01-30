import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:animated_floating_buttons/animated_floating_buttons.dart';

import 'chat.dart';
import 'dictionary.dart';
import 'image.dart';
import 'chapter.dart';

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
            width: 1.sw,
            height: 60,
          ),
          Padding(
              padding: EdgeInsets.only(top: 15),
              child: GestureDetector(
                onTap: () {
                  Get.to(ImagePage());
                },
                child: Container(
                  width: (1 / 3).sw,
                  height: 40,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('图鉴',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: imageBottonColor, fontSize: 20))),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 15, left: (1 / 3).sw),
              child: GestureDetector(
                onTap: () {
                  Get.to(DictionaryPage());
                },
                child: Container(
                  width: (1 / 3).sw,
                  height: 40,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('词典',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: dictionaryBottonColor, fontSize: 20))),
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 15, left: 2 * (1 / 3).sw),
              child: GestureDetector(
                onTap: () {
                  Get.to(ChapterPage());
                },
                child: Container(
                  width: (1 / 3).sw,
                  height: 40,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('章节',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: chapterButtonColor, fontSize: 20))),
                ),
              ))
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

float2() {
  return Container(
    child: FloatingActionButton(
      onPressed: () {
        // Get.to();
      },
      heroTag: "btn2",
      tooltip: '设置',
      child: Icon(Icons.settings),
    ),
  );
}

floatButton() {
  return AnimatedFloatingActionButton(
      fabButtons: [float1(), float2()],
      colorStartAnimation: Colors.blue,
      colorEndAnimation: Colors.red,
      animatedIconData: AnimatedIcons.menu_close);
}
