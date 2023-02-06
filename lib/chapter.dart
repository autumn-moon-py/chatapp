import 'package:chatapp/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'menu.dart';
import 'config.dart';

class ChapterPage extends StatefulWidget {
  @override
  ChapterPageState createState() => ChapterPageState();
}

class ChapterPageState extends State<ChapterPage> {
  @override
  Widget build(BuildContext context) {
    return buildChapterScreen();
  }

  Widget buildChapterScreen() {
    return Scaffold(
        floatingActionButton: floatButton('章节'),
        body: Stack(children: [
          //页面背景
          Container(
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
          //章节布局列表
          Padding(
              padding: EdgeInsets.only(top: 15.h, bottom: 5.h),
              child: buildChapterList()),
          buildMenu("章节") //菜单栏
        ]));
  }

  buildChapterList() {
    return GridView.count(
        crossAxisCount: 1,
        padding: EdgeInsets.only(top: 27.4.h),
        childAspectRatio: 1 / 0.43,
        //遍历章节列表生成布局
        children: chapterList.map((chapterName) {
          return buildChapter(chapterName);
        }).toList());
  }

  Widget buildChapter(chapterName) {
    return GestureDetector(
        onTap: () {
          nowChapter = chapterName;
          loadCVS();
          Get.to(ChatPage());
          EasyLoading.showToast(chapterName,
              toastPosition: EasyLoadingToastPosition.bottom);
        },
        child: Image.asset('assets/chapter/$chapterName.png', width: 540.w));
  }
}
