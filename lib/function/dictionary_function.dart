import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///词典展示
buildDictionaryView(dictionaryName, dictionaryMean) {
  return Stack(children: [
    GestureDetector(
        onTap: () => Get.back(), child: Container(color: Colors.black)),
    Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/词典/词典展示.png',
              width: 386.w,
              fit: BoxFit.cover,
            ))),
    Container(
      padding: EdgeInsets.only(bottom: 200.h),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: REdgeInsets.only(bottom: 5.h),
          child: Image.asset(
            'assets/词典/词典.png',
            width: 100.r,
            height: 100.r,
          ),
        ),
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
        Container(
            padding: EdgeInsets.only(top: 10.h, left: 10.w),
            width: 370.w,
            child: Text(dictionaryMean,
                style: TextStyle(fontSize: 25.sp, color: Colors.white)))
      ]),
    )
  ]);
}
