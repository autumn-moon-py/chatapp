import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:photo_view/photo_view.dart';
import 'package:entry/entry.dart';
import 'dart:convert';

import 'config.dart';
import 'trend.dart';
import 'dart:io';

//左消息文本气泡
class LeftTextMsg extends StatelessWidget {
  LeftTextMsg({required this.text, required this.who});
  final String text; //消息气泡内文本
  final String who; //头像

  toJsonString() {
    final jsonString = jsonEncode({'位置': '左', 'text': text, 'who': who});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h), //消息间隔
            child: Entry.offset(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, //垂直顶部对齐
                    mainAxisAlignment: MainAxisAlignment.start, //水平左对齐
                    children: <Widget>[
                  GestureDetector(
                      onTap: () => Get.to(TrendPage()),
                      child: Container(
                          //头像容器
                          margin: EdgeInsets.only(
                              left: 10.w, right: 4.5.w), //头像和气泡间距
                          child: CircleAvatar(
                              //头像图标
                              radius: 30.r, //头像尺寸
                              backgroundImage:
                                  AssetImage(whoAvater(who)) //加载左边头像
                              ))),
                  // 消息气泡容器
                  Container(
                      margin: EdgeInsets.only(top: 5.h),
                      constraints: BoxConstraints(maxWidth: 420.w), //限制容器最大宽度
                      padding: EdgeInsets.all(10.r), //容器内边距
                      //圆角
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1), //容器背景颜色
                          borderRadius:
                              BorderRadius.all(Radius.circular(7))), //圆角角度
                      //消息文本
                      child: Text(
                        text,
                        softWrap: true, //自动换行
                        textAlign: TextAlign.left, //文本左对齐
                        style: TextStyle(
                            fontSize: 25.sp, color: Colors.white), //文本样式
                      ))
                ]))));
  }
}

//左消息图片气泡
class LeftImgMsg extends StatelessWidget {
  LeftImgMsg({required this.img, required this.who});
  final String img; //图片名称
  final String who; //头像

  toJsonString() {
    final jsonString = jsonEncode({'位置': '左', 'img': img, 'who': who});
    return jsonString;
  }

  //图片查看
  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(imageProvider: AssetImage('assets/images/$imageName.png')),
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
                  width: 430.w,
                  height: 50.h,
                ),
                //返回图标
                Icon(Icons.chevron_left, color: Colors.white, size: 50.r),
              ])))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h), //消息间隔
            child: Entry.offset(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, //垂直顶部对齐
                    mainAxisAlignment: MainAxisAlignment.start, //水平左对齐
                    children: <Widget>[
                  //头像容器
                  GestureDetector(
                      onTap: () => Get.to(TrendPage()),
                      child: Container(
                          margin:
                              EdgeInsets.only(left: 10.w, right: 5.w), //头像和气泡间距
                          child: CircleAvatar(
                              //头像图标
                              radius: 30.r, //头像尺寸
                              backgroundImage:
                                  AssetImage(whoAvater(who)) //加载左边头像
                              ))),
                  //消息图片
                  GestureDetector(
                      onTap: () {
                        Get.to(buildImageView(img));
                      },
                      child: Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/' + img + '.png',
                          width: 195.w, //图片宽
                          height: 260.h, //图片高
                        ),
                      ))
                ]))));
  }
}

//右消息气泡
class RightMsg extends StatelessWidget {
  final String text; //消息气泡内文本
  RightMsg({required this.text});

  toJsonString() {
    final jsonString = jsonEncode({'位置': '右', 'text': text});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h), //消息间隔
            child: Entry.offset(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, //垂直顶部对齐
                    mainAxisAlignment: MainAxisAlignment.end, //水平右对齐
                    children: <Widget>[
                  // 消息气泡容器
                  Container(
                      margin: EdgeInsets.only(top: 10.h),
                      constraints: BoxConstraints(maxWidth: 420.w), //限制容器最大宽度
                      padding: EdgeInsets.all(10.r), //容器内边距
                      //圆角
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1), //容器背景颜色
                          borderRadius:
                              BorderRadius.all(Radius.circular(7))), //圆角角度
                      //消息文本
                      child: Text(
                        text,
                        softWrap: true, //自动换行
                        textAlign: TextAlign.left, //文本左对齐
                        style: TextStyle(
                            fontSize: 25.sp, color: Colors.white), //文本样式
                      )),
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                          //头像容器
                          margin: EdgeInsets.only(
                              right: 10.w, left: 10.h), //头像和气泡间距
                          child: CircleAvatar(
                              //头像图标
                              radius: 30.r, //头像尺寸
                              backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                              child: playerAvater() //加载右边头像
                              ))),
                ]))));
  }
}

//系统消息
class MiddleMsg extends StatelessWidget {
  MiddleMsg({required this.text});
  final String text; //消息气泡内文本

  toJsonString() {
    final jsonString = jsonEncode({'位置': '中', 'text': text});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h), //消息间隔
            child: Entry.offset(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, //水平居中对齐
                    children: <Widget>[
                  // 消息气泡容器
                  Container(
                      padding: EdgeInsets.all(10.r), //容器内边距
                      //圆角
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1), //容器背景颜色
                          borderRadius:
                              BorderRadius.all(Radius.circular(7))), //圆角角度
                      //消息文本
                      child: Text(
                        text,
                        textAlign: TextAlign.center, //文本居中对齐
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Color.fromRGBO(119, 119, 119, 1)), //文本样式
                      )),
                ]))));
  }
}

//头像验证
whoAvater(String name) {
  if (name == 'Miko') {
    return "assets/icon/头像$nowMikoAvater.png";
  }
  if (name == '未知用户') {
    return "assets/icon/未知用户.png";
  }
  if (name == 'Lily') {
    return "assets/icon/Lily.png";
  }
}

Widget playerAvater() {
  if (playerAvatarSet != "默认") {
    try {
      return Image.file(File(playerAvatarSet));
    } catch (error) {
      playerAvatarSet = '默认';
      return Image.asset('assets/icon/未知用户.png');
    }
  }
  return Image.asset('assets/icon/未知用户.png');
}
