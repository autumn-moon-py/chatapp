import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/setting_config.dart';
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
    return ProgressHUD(
        child: Builder(
            builder: (context) => Padding(
                padding: EdgeInsets.only(top: topHeight),
                child: Stack(children: [
                  Container(
                    width: 540.w,
                    height: 960.h,
                    color: Color.fromRGBO(13, 13, 13, 1),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 80.h),
                      width: 540.w,
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/icon/icon.png',
                                width: 100.w,
                                height: 100.h,
                              )),
                          GestureDetector(
                              onDoubleTap: () {
                                easterEgg();
                              },
                              child: Container(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: Text('异次元通讯 - 次元复苏',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25.sp)))),
                          Container(
                              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              child: Text('V $version',
                                  style: TextStyle(color: Colors.grey))),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  width: 500.w,
                                  color: Color.fromRGBO(38, 38, 38, 1),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              checkUpgrade(context);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.w, right: 10.w),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                      color: Color.fromRGBO(
                                                          38, 38, 38, 1),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10.h,
                                                                      left:
                                                                          20.w,
                                                                      bottom:
                                                                          10.h),
                                                              child: Row(
                                                                  children: [
                                                                    Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              '检查更新',
                                                                              style: TextStyle(fontSize: 25.sp, color: Colors.white))
                                                                        ]),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 300
                                                                                .w),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Container(child: Icon(Icons.chevron_right, color: Colors.white, size: 50.r)))),
                                                                  ]))
                                                        ],
                                                      ))),
                                            )),
                                        greyLine(),
                                        UrlButton('官网',
                                            'https://www.subrecovery.top'),
                                        greyLine(),
                                        UrlButton('帮助',
                                            'https://www.yuque.com/docs/share/61b42397-f1f4-4457-9fdd-d50e45d214df'),
                                        greyLine(),
                                        UrlButton('Q群',
                                            'https://jq.qq.com/?_wv=1027&k=YTPhqrNW'),
                                        greyLine(),
                                        UrlButton('投喂',
                                            'https://afdian.net/a/subrecovery'),
                                        greyLine(),
                                        UrlButton('感谢名单',
                                            'https://afdian.net/dashboard/sponsors'),
                                      ])))
                        ],
                      )),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Stack(children: [
                        Container(
                          color: Colors.black,
                          width: 1.sw,
                          height: 50.h,
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Text('关于异次元通讯',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp)))),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.chevron_left,
                                color: Colors.white, size: 50.r)),
                      ])),
                ]))));
  }
}
