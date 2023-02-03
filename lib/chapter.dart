import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        floatingActionButton: floatButton(),
        body: Stack(children: [
          //页面背景
          Container(
            width: 1.sw,
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png'),
          ),
          //章节布局列表
          Padding(
              padding: EdgeInsets.only(top: 15, bottom: 5),
              child: buildChapterList()),
          buildMenu("章节") //菜单栏
        ]));
  }

  buildChapterList() {
    return GridView.count(
        crossAxisCount: 1,
        padding: EdgeInsets.only(top: (1 / 26).sh),
        childAspectRatio: 1 / 0.43,
        //遍历章节列表生成布局
        children: chapterList.map((chapterName) {
          return buildChapter(chapterName);
        }).toList());
  }

  Widget buildChapter(chapterName) {
    return GestureDetector(
        onTap: () {
          EasyLoading.showToast(chapterName,
              toastPosition: EasyLoadingToastPosition.bottom);
        },
        child: Image.asset('assets/chapter/$chapterName.png', width: 1.sw));
  }
}
