import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:keframe/keframe.dart';

import '../config/dictionary_config.dart';
import '../function/dictionary_function.dart';
import 'menu.dart';

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
          Container(
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
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
                dictionary_map_load();
              });
            },
            child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.28,
                padding: EdgeInsets.only(top: 38.h, right: 10.w),
                children: dictionaryList.map((dictionaryName) {
                  return buildDictionary(dictionaryName);
                }).toList())));
  }

  //单个词典
  Widget buildDictionary(dictionaryName) {
    List _dtlist = dictionaryMap[dictionaryName];
    String chapter = _dtlist[0];
    String unlock = _dtlist[1];
    String dictionaryMean = _dtlist[2];
    if (unlock == 'false') {
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
}
