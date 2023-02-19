import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/setting_config.dart';

import '../config/config.dart';

List trends = []; //动态容器列表
List<String> trendsInfo = []; //动态信息列表

trend_save() async {
  local = await SharedPreferences.getInstance();
  local?.setStringList('trendsInfo', trendsInfo);
}

///读取动态
trend_load() async {
  local = await SharedPreferences.getInstance();
  trendsInfo = await local?.getStringList('trendsInfo') ?? [];
  Map _trendsInfo = {};
  if (trendsInfo != []) {
    for (int i = 0; i < trendsInfo.length; i++) {
      _trendsInfo[i] = fromJsonString(trendsInfo[i]);
    }
    if (trends.length < _trendsInfo.length) {
      for (int i = 0; i < _trendsInfo.length;) {
        Trend trend = Trend(
            trendText: _trendsInfo[i]['trendText'],
            trendImg: _trendsInfo[i]['trendImg']);
        trends.add(trend);
      }
    }
  }
}

class TrendPage extends StatefulWidget {
  @override
  TrendPageState createState() => TrendPageState();
}

class TrendPageState extends State<TrendPage> {
  ScrollController _scrollController = ScrollController(); //动态列表控件

  @override
  void initState() {
    trend_load();
    super.initState();
  }

  sendTrend(String trendText, String trendImg) {
    Trend trend = Trend(trendText: trendText, trendImg: trendImg);
    setState(() {
      trends.add(trend);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
            color: Color.fromRGBO(25, 25, 25, 1), width: 1.sw, height: 1.sh),
        Column(children: [
          Flexible(
              child: ListView(children: [
            Column(children: [
              Stack(children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Image.asset('assets/images/聊天背景.png',
                        width: 1.sw, height: 0.8.sw, fit: BoxFit.cover)),
                Positioned(
                    right: 15.w,
                    bottom: 0,
                    child: Image.asset('assets/icon/头像$nowMikoAvater.png',
                        width: 60.r, height: 60.r))
              ]),
              Padding(
                padding: EdgeInsets.only(left: 10.w, bottom: 20.h),
                child: ListView.builder(
                  controller: _scrollController, //绑定控件
                  scrollDirection: Axis.vertical, //垂直滑动
                  reverse: true, //正序显示
                  shrinkWrap: true, //内容适配
                  physics: BouncingScrollPhysics(), //内容超过一屏 上拉有回弹效果
                  itemBuilder: (_, int index) => trends[index],
                  itemCount: trends.length, //item数量
                ),
              )
            ]),
          ]))
        ]),
        // Center(
        //     child: TextButton(
        //   child: Text('发送', style: TextStyle(color: Colors.white)),
        //   onPressed: () {
        //     sendTrend('你好', 'S1-01');
        //   },
        // )),
        GestureDetector(
            //返回按钮
            onTap: () {
              Get.back();
            },
            child: Container(
                alignment: Alignment.topLeft,
                child: Stack(children: [
                  Container(
                    //标题栏
                    color: Colors.black,
                    width: 540.w,
                    height: 50.h,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: Align(
                        alignment: FractionalOffset(0.5, 0),
                        child: Text('动态',
                            style: TextStyle(
                                color: Colors.white, fontSize: 25.sp)),
                      )),
                  //返回图标
                  Icon(Icons.chevron_left, color: Colors.white, size: 50.r),
                ]))),
      ],
    ));
  }
}

class Trend extends StatelessWidget {
  final String trendText; //动态文本
  final String trendImg; //动态图鉴
  const Trend({required this.trendText, required this.trendImg});

  toJsonString() {
    final jsonString =
        jsonEncode({'trendText': trendText, 'trendImg': trendImg});
    return jsonString;
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 20.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Image.asset('assets/icon/头像$nowMikoAvater.png',
                    width: 55.r, height: 55.r),
                Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Miko',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.sp)),
                          Container(
                              width: 440.w,
                              child: Text(trendText,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.sp)))
                        ]))
              ]),
              Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 50.w, right: 50.w),
                  child: GestureDetector(
                      onTap: () => Get.to(buildImageView(trendImg)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRect(
                              child: Container(
                                  width: 440.w,
                                  height: 440.w,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$trendImg.png',
                                    errorWidget: (context, url, error) => Text(
                                      '加载失败,请检查网络',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30.sp),
                                    ),
                                  ))))))
            ])),
      ],
    );
  }

  //图片查看
  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(
          loadingBuilder: (context, event) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '第一次加载可能缓慢,请耐心等待',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 30.sp),
                            )))
                  ]),
          errorBuilder: (context, error, stackTrace) => Text(
                '加载失败,请检查网络',
                style: TextStyle(color: Colors.black, fontSize: 30.sp),
              ),
          imageProvider: NetworkImage(
              'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png')),
      Container(
          alignment: Alignment.topLeft,
          child: Stack(children: [
            Container(
              //标题栏
              color: Colors.black,
              width: 540.w,
              height: 50.h,
            ),
            //返回图标
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child:
                    Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
          ]))
    ]));
  }
}
