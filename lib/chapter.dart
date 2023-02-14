import 'package:chatapp/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              child: buildChapterList())
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
          if (chapterName == nowChapter) {
            Get.back();
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Container(
                        height: 120.h,
                        child: Column(children: [
                          Text('提示',
                              style: TextStyle(
                                  fontSize: 40.sp, color: Colors.red)),
                          Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Text(
                                '此操作会清除当前游玩进度',
                                style: TextStyle(fontSize: 25.sp),
                              ))
                        ])),
                    actions: [
                      TextButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.pop(context, 'Cancle');
                        },
                      ),
                      TextButton(
                          child: Text("确定"),
                          onPressed: () {
                            line = 0;
                            startTime = 0;
                            jump = 0;
                            be_jump = 0;
                            reast_line = 0;
                            choose_one = '';
                            choose_two = '';
                            choose_one_jump = 0;
                            choose_two_jump = 0;
                            nowChapter = chapterName;
                            loadCVS();
                            Get.to(ChatPage());
                            Navigator.pop(context, 'Ok');
                          })
                    ],
                  );
                });
          }

          // EasyLoading.showToast(chapterName,
          //     toastPosition: EasyLoadingToastPosition.bottom);
        },
        child: Image.asset('assets/chapter/$chapterName.png', width: 540.w));
  }
}
