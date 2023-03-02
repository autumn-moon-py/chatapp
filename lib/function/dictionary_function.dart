//词典展示
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

buildDictionaryView(dictionaryName, dictionaryMean) {
  return Stack(alignment: Alignment.center, children: [
    GestureDetector(
        onTap: () => Get.back(),
        child: Container(width: 1.sw, height: 1.sh, color: Colors.black)),
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
                padding: EdgeInsets.only(top: 10.h),
                child: Divider(
                  color: Colors.white,
                  height: 0,
                  indent: 100.w,
                  endIndent: 100.w,
                  thickness: 1,
                )),
            Padding(
                padding: EdgeInsets.only(top: 10.h, left: 10.w),
                child: Container(
                    width: 370.w,
                    child: Text(dictionaryMean,
                        style:
                            TextStyle(fontSize: 25.sp, color: Colors.white))))
          ]))
    ])
  ]);
}
