import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:keframe/keframe.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:convert';

import '../config/setting_config.dart';
import '../page/trend.dart';
import 'dart:io';

///左消息文本气泡
class LeftTextMsg extends StatelessWidget {
  LeftTextMsg({required this.text, required this.who});
  final String text;
  final String who;

  toJsonString() {
    final jsonString = jsonEncode({'位置': '左', 'text': text, 'who': who});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h),
            child: FadeInLeft(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        if (who == 'Miko') {
                          Get.to(TrendPage());
                        } else {
                          EasyLoading.showToast('未解锁',
                              toastPosition: EasyLoadingToastPosition.bottom);
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10.w, right: 4.5.w),
                          child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 30.r,
                              child: Image.asset(whoAvater(who))))),
                  Container(
                      margin: EdgeInsets.only(top: 5.h),
                      constraints: BoxConstraints(maxWidth: 420.w),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Text(
                        text,
                        softWrap: true,
                        style: TextStyle(fontSize: 25.sp, color: Colors.white),
                      ))
                ]))));
  }
}

///左消息图片气泡
class LeftImgMsg extends StatelessWidget {
  LeftImgMsg({required this.img});
  final String img;

  toJsonString() {
    final jsonString = jsonEncode({'位置': '左', 'img': img});
    return jsonString;
  }

  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(
          imageProvider: NetworkImage(
              'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png')),
      GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
              alignment: Alignment.topLeft,
              child: Stack(children: [
                Container(
                  color: Colors.black,
                  width: 430.w,
                  height: 50.h,
                ),
                Icon(Icons.chevron_left, color: Colors.white, size: 50.r),
              ])))
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        child: FadeInLeft(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Get.to(TrendPage());
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10.w, right: 5.w),
                      child: CircleAvatar(
                          radius: 30.r,
                          child: Image.asset(whoAvater('Miko'))))),
              GestureDetector(
                  onTap: () {
                    Get.to(buildImageView(img));
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.circular(20),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        width: 195.w,
                        height: 260.h,
                        imageUrl:
                            'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$img.png',
                        errorWidget: (context, url, error) => Text(
                          '加载失败,请检查网络',
                          style:
                              TextStyle(color: Colors.white, fontSize: 30.sp),
                        ),
                      )))
            ])));
  }
}

///右消息气泡
class RightMsg extends StatelessWidget {
  final String text;
  RightMsg({required this.text});

  toJsonString() {
    final jsonString = jsonEncode({'位置': '右', 'text': text});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return FrameSeparateWidget(
        child: Container(
            margin: EdgeInsets.only(top: 10.h),
            child: FadeInRight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 10.h),
                      constraints: BoxConstraints(maxWidth: 420.w),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Text(
                        text,
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 25.sp, color: Colors.white),
                      )),
                  Container(
                      margin: EdgeInsets.only(right: 10.w, left: 10.h),
                      child: ClipOval(child: playerAvater())),
                ]))));
  }
}

///系统消息
class MiddleMsg extends StatelessWidget {
  MiddleMsg({required this.text});
  final String text;

  textColor() {
    if (text == '对方已上线' || text == '切换对象中') {
      return Color.fromARGB(255, 0, 255, 8);
    }
    if (text == '对方已下线' || text == '信息未送达' || text == '对方账号不存在或已注销') {
      return Colors.red;
    } else {
      return Colors.white;
    }
  }

  toJsonString() {
    final jsonString = jsonEncode({'位置': '中', 'text': text});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(38, 38, 38, 1),
                  borderRadius: BorderRadius.all(Radius.circular(7))),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, color: textColor()),
              )),
        ]));
  }
}

///语音消息
class VoiceMsg extends StatelessWidget {
  final String voice;
  final voiceplayer = AudioPlayer();

  VoiceMsg({required this.voice});
  toJsonString() {
    final jsonString = jsonEncode({'位置': '语音', 'voice': voice});
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        child: FadeInLeft(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, //垂直顶部对齐
                mainAxisAlignment: MainAxisAlignment.start, //水平左对齐
                children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Get.to(TrendPage());
                  },
                  child: Container(
                      //头像容器
                      margin:
                          EdgeInsets.only(left: 10.w, right: 4.5.w), //头像和气泡间距
                      child: CircleAvatar(
                          backgroundColor: Colors.black,
                          //头像图标
                          radius: 30.r, //头像尺寸
                          child: Image.asset(whoAvater('Miko')) //加载左边头像
                          ))),
              // 消息气泡容器
              GestureDetector(
                  onTap: () {
                    voiceplayer.setAsset('assets/music/$voice.mp3');
                    voiceplayer.setLoopMode(LoopMode.off);
                    voiceplayer.setVolume(0.1);
                    if (voiceIsStop) {
                      voiceIsStop = true;
                      voiceplayer.play();
                    } else if (!voiceIsStop || !IsOnChatPage) {
                      voiceIsStop = false;
                      voiceplayer.pause();
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 5.h),
                      width: voice.length == 4 ? 60 : voice.length * 8,
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, left: 10.w), //容器内边距
                      //圆角
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(38, 38, 38, 1), //容器背景颜色
                          borderRadius:
                              BorderRadius.all(Radius.circular(7))), //圆角角度
                      //语音
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: Text('${(voice.length / 4).ceil()}\'\'',
                                  style: TextStyle(
                                      fontSize: 25.sp, color: Colors.white))),
                          RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.wifi,
                                size: 30.r,
                                color: Colors.grey,
                              )),
                        ],
                      )))
            ])));
  }
}

//左头像验证
whoAvater(String name) {
  if (name == 'Miko') {
    return "assets/icon/头像$nowMikoAvater.png";
  }
  if (name == '未知用户') {
    return "assets/icon/未知用户.png";
  }
  if (name == 'Lily') {
    return "assets/icon/Lily.png";
  } else {
    return "assets/icon/头像$nowMikoAvater.png";
  }
}

///玩家头像
Widget playerAvater() {
  if (playerAvatarSet != "默认") {
    try {
      return Image.file(File(playerAvatarSet),
          fit: BoxFit.cover, width: 60.r, height: 60.r);
    } catch (error) {
      playerAvatarSet = '默认';
      return Image.asset('assets/icon/未知用户.png',
          fit: BoxFit.cover, width: 60.r, height: 60.r);
    }
  }
  return Image.asset('assets/icon/未知用户.png',
      fit: BoxFit.cover, width: 60.r, height: 60.r);
}
