import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keframe/keframe.dart';

import 'menu.dart';
import 'config.dart';

class DictionaryPage extends StatefulWidget {
  @override
  DictionaryPageState createState() => DictionaryPageState();
}

class DictionaryPageState extends State<DictionaryPage> {
  @override
  Widget build(BuildContext context) {
    return buildDictionaryScreen();
  }

  Widget buildDictionaryScreen() {
    return Scaffold(
        floatingActionButton: floatButton('词典'),
        body: Stack(children: [
          //页面背景
          Container(
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
          //图鉴布局列表
          Padding(
              padding: EdgeInsets.only(top: 10.h), child: buildDictionaryList())
        ]));
  }

  //词典列表布局
  Widget buildDictionaryList() {
    return SizeCacheWidget(
        estimateCount: 60,
        child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                loadMap();
              });
            },
            child: GridView.count(
                crossAxisCount: 2, // 一行最多显示
                // mainAxisSpacing: 10.h,
                // childAspectRatio: (1.sw / 8) / (1.sh / 60), //比例
                childAspectRatio: 1 / 0.28,
                padding: EdgeInsets.only(top: 38.h, right: 10.w),
                //     //遍历图鉴列表生成布局
                children: dictionaryList.map((dictionaryName) {
                  return buildDictionary(dictionaryName);
                }).toList())));
  }

  //单个词典
  Widget buildDictionary(dictionaryName) {
    List _dtlist = dictionaryMap[dictionaryName];
    String chapter = _dtlist[0]; //词典章节
    String unlock = _dtlist[1]; //词典解锁状态
    String dictionaryMean = _dtlist[2]; //词典解释
    if (unlock == 'false') {
      //未解锁
      return FrameSeparateWidget(
          placeHolder: Text(
            "加载中...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
          ),
          child: Container(
              child: Stack(children: [
            GestureDetector(
                onTap: () {
                  //提示词典章节
                  EasyLoading.showToast(chapter,
                      toastPosition: EasyLoadingToastPosition.bottom);
                },
                child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Image.asset('assets/词典/未解锁词典.png')))
          ])));
    }

    //单个列表词典构造
    return FrameSeparateWidget(
        placeHolder: Text(
          "加载中...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        child: Container(
          padding: EdgeInsets.only(bottom: 20.h),
          child: GestureDetector(
              onTap: () {
                Get.to(buildDictionaryView(dictionaryName, dictionaryMean));
              },
              child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0),
                      child: Row(children: [
                        Container(
                            padding: EdgeInsets.only(right: 5.w),
                            child: Image.asset(
                              'assets/词典/词典.png',
                              width: 42.5.r,
                              height: 42.5.r,
                            )),
                        Text(
                          dictionaryName,
                          style:
                              TextStyle(color: Colors.white, fontSize: 25.sp),
                        )
                      ])))),
        ));
  }

  //词典展示
  buildDictionaryView(dictionaryName, dictionaryMean) {
    return Stack(alignment: Alignment.center, children: [
      GestureDetector(
          onTap: () => Get.back(),
          child: Container(width: 540.w, height: 960.h, color: Colors.black)),
      Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/词典/词典展示.png',
                width: 386.w,
                height: 624.h,
              ))),
      Column(children: [
        Padding(
            padding: EdgeInsets.only(top: 291.h),
            child: Column(children: [
              Text(dictionaryName,
                  style: TextStyle(fontSize: 30.sp, color: Colors.white)),
              Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 10.w),
                  child: Container(
                      width: 370.w,
                      child: Text(dictionaryMean,
                          style:
                              TextStyle(fontSize: 25.sp, color: Colors.white))))
            ]))
      ])
    ]);
  }
}
