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
        floatingActionButton: floatButton(),
        body: Stack(children: [
          //页面背景
          Container(
            width: 1.sw,
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png'),
          ),
          //图鉴布局列表
          Padding(
              padding: EdgeInsets.only(top: 10), child: buildDictionaryList()),
          buildMenu("词典") //菜单栏
        ]));
  }

  //词典列表布局
  Widget buildDictionaryList() {
    return SizeCacheWidget(
        estimateCount: 40,
        child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                loadMap();
              });
            },
            child: GridView.count(
                crossAxisCount: 2, // 一行最多显示
                childAspectRatio: (1.sw / 10) / (1.sh / 60), //比例
                padding:
                    EdgeInsets.only(top: (1 / 19.2).sh, right: (1 / 54).sw),
                //     //遍历图鉴列表生成布局
                children: dictionaryList.map((dictionaryName) {
                  return buildDictionary(dictionaryName);
                }).toList())));
  }

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
                    padding: EdgeInsets.only(left: (1 / 54).sw),
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
          child: GestureDetector(
              onTap: () {
                Get.to(buildDictionaryView(dictionaryName, dictionaryMean));
              },
              child: Stack(children: [
                Padding(
                    //未解锁词典
                    padding: EdgeInsets.only(left: (1 / 54).sw),
                    child: Image.asset('assets/词典/未解锁词典.png')),
                Padding(
                    //词典名字
                    padding:
                        EdgeInsets.only(top: (1 / 60).sh, left: (1 / 9).sw),
                    child: Text(
                      dictionaryName,
                      style: TextStyle(color: Colors.white, fontSize: 25.sp),
                    )),
                Padding(
                  //词典图标
                  padding:
                      EdgeInsets.only(top: (1 / 140).sh, left: (1 / 42).sw),
                  child: Image.asset(
                    'assets/词典/词典.png',
                    width: (1 / 12.7).sw,
                    height: (1 / 12.7).sw,
                  ),
                )
              ])),
        ));
  }

  buildDictionaryView(dictionaryName, dictionaryMean) {
    return Stack(children: [
      GestureDetector(
          onTap: () => Get.back(),
          child: Container(width: 1.sw, height: 1.sh, color: Colors.black)),
      Stack(children: [
        Center(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(9)),
                child: Image.asset(
                  'assets/词典/词典展示.png',
                  width: 0.716.sw, //图片宽
                  height: 0.65.sh, //图片高
                ))),
        Padding(
            padding: EdgeInsets.only(top: (1 / 3.3).sh, left: 0.44.sw),
            child: Text(dictionaryName,
                style: TextStyle(fontSize: 30.sp, color: Colors.white))),
        Padding(
            padding: EdgeInsets.only(top: (1 / 2.75).sh, left: 0.175.sw),
            child: Container(
                width: 0.65.sw,
                child: Text(dictionaryMean,
                    style: TextStyle(fontSize: 25.sp, color: Colors.white))))
      ]),
    ]);
  }
}
