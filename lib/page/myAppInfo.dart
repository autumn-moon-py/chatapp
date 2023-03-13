import 'package:chatapp/page/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/setting_config.dart';
import '../function/chat_function.dart';
import '../function/myAppInfo_function.dart';

late String version; //应用发布版本号

///查询应用信息
packageInfoList() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
}

class MyAppInfo extends StatefulWidget {
  @override
  State<MyAppInfo> createState() => _MyAppInfoState();
}

class _MyAppInfoState extends State<MyAppInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: topHeight),
        child: Stack(children: [
          Container(
            color: Color.fromRGBO(13, 13, 13, 1),
          ),
          Container(
              padding: EdgeInsets.only(top: 60.h),
              width: 1.sw,
              child: Column(
                children: [
                  GestureDetector(
                      onDoubleTap: () {
                        easterEgg();
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/icon/icon.png',
                            width: 100,
                            height: 100,
                          ))),
                  GestureDetector(
                      // onDoubleTap: () {
                      //   easterEgg();
                      // },
                      child: Container(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text('异次元通讯 - 次元复苏',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 30.sp)))),
                  GestureDetector(
                      // onDoubleTap: () {
                      //   easterEgg();
                      // },
                      child: Container(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: Text('V $version',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 20.sp)))),
                  Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              color: Color.fromRGBO(38, 38, 38, 1),
                              child: Column(children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.w, 20.h, 20.w, 10.h),
                                    child: Row(children: [
                                      Expanded(
                                          child: Text('检查更新',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.white))),
                                      isNew
                                          ? Text('无更新',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.grey))
                                          : GestureDetector(
                                              onTap: () {
                                                Get.to(ChatPage());
                                                Upgrade();
                                              },
                                              child: Text('有新版本',
                                                  style: TextStyle(
                                                      fontSize: 25.sp,
                                                      color: Color.fromARGB(
                                                          255, 0, 255, 8)))),
                                    ])),
                                greyLine(),
                                UrlButton('官网', 'https://www.subrecovery.top'),
                                greyLine(),
                                UrlButton('反馈',
                                    'https://docs.qq.com/form/page/DVVBqVEZPR3JBY2N0?u=ece22a27b3b545d0a698e09090ad11e0#/result'),
                                greyLine(),
                                UrlButton('Q群',
                                    'https://jq.qq.com/?_wv=1027&k=YTPhqrNW'),
                                greyLine(),
                                UrlButton(
                                    '投喂', 'https://afdian.net/a/subrecovery')
                              ]))))
                ],
              )),
          Container(
              alignment: Alignment.topLeft,
              child: Stack(children: [
                Container(
                  color: Colors.black,
                  width: 1.sw,
                  height: 50.h,
                  alignment: Alignment.center,
                  child: Text('关于异次元通讯',
                      style: TextStyle(color: Colors.white, fontSize: 30.sp)),
                ),
                GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.chevron_left,
                        color: Colors.white, size: 60.r)),
              ])),
        ]));
  }
}
