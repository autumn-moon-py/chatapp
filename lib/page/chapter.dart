import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../function/chat_function.dart';
import '../config/chat_config.dart';
import 'menu.dart';

///章节列表
const List chapterList = [
  '第一章',
  '番外一',
  '第二章',
  '番外二',
  '第三章',
  '番外三',
  '第四章',
  '第五章',
  '第六章'
];

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
          Container(
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
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
        children: chapterList.map((chapterName) {
          return buildChapter(chapterName);
        }).toList());
  }

  Widget buildChapter(chapterName) {
    return GestureDetector(
        onTap: () {
          if (chapterName == nowChapter) {
            Get.back();
          } else if (chapterName == '番外一' || chapterName == '第一章') {
            // EasyLoading.showToast('不可游玩,待更新',
            //     toastPosition: EasyLoadingToastPosition.bottom);
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
                            clean_message();
                            Navigator.pop(context, 'Ok');
                            isStop = true;
                            Get.back();
                            line = 0;
                            loadCVS(chapterName);
                            setState(() {});
                          })
                    ],
                  );
                });
          }
        },
        child: Image.asset('assets/chapter/$chapterName.png', width: 1.sw));
  }
}
