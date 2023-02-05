import 'package:chatapp/chat.dart';
import 'package:chatapp/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';
import 'send.dart';

class SettingPage extends StatefulWidget {
  final String where;
  SettingPage(this.where);
  @override
  SettingPageState createState() => SettingPageState(where);
}

//设置页面布局
class SettingPageState extends State<SettingPage> {
  late final String where;
  bool isChange = false;
  SettingPageState(this.where);

  @override
  Widget build(Object context) {
    return Stack(children: [
      Container(
          color: Color.fromRGBO(13, 13, 13, 1), width: 540.w, height: 960.h),
      Padding(
          padding: EdgeInsets.only(top: 50.h, bottom: 10.h),
          child: ListView(children: [
            Stack(children: [
              Column(children: [
                Padding(
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Color.fromRGBO(38, 38, 38, 1),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile(
                                    title: Text('背景音乐',
                                        style: TextStyle(
                                            fontSize: 25.sp,
                                            color: Colors.white)),
                                    value: backgroundMusicSwitch,
                                    activeColor: Colors.white,
                                    activeTrackColor:
                                        Color.fromRGBO(0, 102, 203, 1),
                                    inactiveTrackColor:
                                        Color.fromRGBO(60, 60, 60, 1),
                                    onChanged: (value) {
                                      save();
                                      backgroundMusicSwitch =
                                          !backgroundMusicSwitch;
                                      backgroundMusic();
                                      setState(() {});
                                    }),
                                Divider(
                                  color: Colors.white,
                                  height: 0,
                                  indent: 20.w,
                                  endIndent: 30.w,
                                  thickness: 1,
                                ),
                                SwitchListTile(
                                    title: Text('背景音乐替换',
                                        style: TextStyle(
                                            fontSize: 25.sp,
                                            color: Colors.white)),
                                    subtitle: Text('开启为初章恐怖氛围的背景音乐',
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.grey)),
                                    value: isOldBgm,
                                    activeColor: Colors.white,
                                    activeTrackColor:
                                        Color.fromRGBO(0, 102, 203, 1),
                                    inactiveTrackColor:
                                        Color.fromRGBO(60, 60, 60, 1),
                                    onChanged: (value) {
                                      save();
                                      isOldBgm = !isOldBgm;
                                      backgroundMusic();
                                      setState(() {});
                                    }),
                                Divider(
                                  color: Colors.white,
                                  height: 0,
                                  indent: 20.w,
                                  endIndent: 30.w,
                                  thickness: 1,
                                ),
                                SwitchListTile(
                                    title: Text('选项音效',
                                        style: TextStyle(
                                            fontSize: 25.sp,
                                            color: Colors.white)),
                                    value: buttonMusicSwitch,
                                    activeColor: Colors.white,
                                    activeTrackColor:
                                        Color.fromRGBO(0, 102, 203, 1),
                                    inactiveTrackColor:
                                        Color.fromRGBO(60, 60, 60, 1),
                                    onChanged: (value) {
                                      save();
                                      buttonMusicSwitch = value;
                                      setState(() {});
                                    }),
                                Divider(
                                  color: Colors.white,
                                  height: 0,
                                  indent: 20.w,
                                  endIndent: 30.w,
                                  thickness: 1,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 22.w),
                                    child: Row(
                                      children: <Widget>[
                                        Text('语音音量',
                                            style: TextStyle(
                                                fontSize: 25.sp,
                                                color: Colors.white)),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 130.w),
                                            child: Slider(
                                              value: sliderValue,
                                              onChanged: (data) {
                                                // print('change:$data');
                                                voice(data);
                                                setState(() {
                                                  sliderValue = data;
                                                });
                                              },
                                              onChangeStart: (data) {
                                                // print('start:$data');
                                              },
                                              onChangeEnd: (data) {
                                                // print('end:$data');
                                              },
                                              min: 0.0,
                                              max: 10.0,
                                              divisions: 10,
                                              label: '$sliderValue',
                                              activeColor: Color.fromRGBO(
                                                  0, 102, 203, 1),
                                              inactiveColor: Colors.grey,
                                              semanticFormatterCallback:
                                                  (double newValue) {
                                                return '${newValue.round()} dollars}';
                                              },
                                            ))
                                      ],
                                    ))
                              ]),
                        ))),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 5.h, right: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      color: Color.fromRGBO(38, 38, 38, 1),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SwitchListTile(
                                title: Text('AI图鉴',
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white)),
                                subtitle: Text(
                                    '用AI绘画(stable-diffusion)重新绘制部分图鉴',
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.grey)),
                                value: isNewImage,
                                activeColor: Colors.white,
                                activeTrackColor:
                                    Color.fromRGBO(0, 102, 203, 1),
                                inactiveTrackColor:
                                    Color.fromRGBO(60, 60, 60, 1),
                                onChanged: (value) {
                                  save();
                                  //判断新旧图鉴
                                  if (value) {
                                    imageList = imageList2;
                                  } else {
                                    imageList = imageList1;
                                  }
                                  isChange = true;
                                  isNewImage = value;
                                  setState(() {});
                                }),
                            Divider(
                              color: Colors.white,
                              height: 0,
                              indent: 20.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            SwitchListTile(
                                title: Text('自动滚屏',
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white)),
                                subtitle: Text('当聊天内容超出一屏,发送消息自动滚动到最新一条',
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.grey)),
                                value: scrolling,
                                activeColor: Colors.white,
                                activeTrackColor:
                                    Color.fromRGBO(0, 102, 203, 1),
                                inactiveTrackColor:
                                    Color.fromRGBO(60, 60, 60, 1),
                                onChanged: (value) {
                                  save();
                                  scrolling = value;
                                  setState(() {});
                                }),
                            Divider(
                              color: Colors.white,
                              height: 0,
                              indent: 20.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            SwitchListTile(
                                title: Text('打字时间',
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white)),
                                subtitle: Text('关闭则对方直接发送消息',
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.grey)),
                                value: waitTyping,
                                activeColor: Colors.white,
                                activeTrackColor:
                                    Color.fromRGBO(0, 102, 203, 1),
                                inactiveTrackColor:
                                    Color.fromRGBO(60, 60, 60, 1),
                                onChanged: (value) {
                                  save();
                                  waitTyping = value;
                                  setState(() {});
                                }),
                            Divider(
                              color: Colors.white,
                              height: 0,
                              indent: 20.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            SwitchListTile(
                                title: Text('等待上线',
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white)),
                                subtitle: Text('关闭则对方下线直接上线',
                                    style: TextStyle(
                                        fontSize: 15.sp, color: Colors.grey)),
                                value: waitOffline,
                                activeColor: Colors.white,
                                activeTrackColor:
                                    Color.fromRGBO(0, 102, 203, 1),
                                inactiveTrackColor:
                                    Color.fromRGBO(60, 60, 60, 1),
                                onChanged: (value) {
                                  save();
                                  waitOffline = value;
                                  setState(() {});
                                }),
                          ]),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.w, right: 10.w, top: 10.h, bottom: 5.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          color: Color.fromRGBO(38, 38, 38, 1),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: Text('Miko头像更换',
                                                style: TextStyle(
                                                    fontSize: 25.sp,
                                                    color: Colors.white))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.w, right: 3.w),
                                            child: Image.asset(
                                                'assets/icon/头像$nowMikoAvater.png',
                                                width: 50.r,
                                                height: 50.r)),
                                        CoolDropdown(
                                          resultWidth: 245.w,
                                          dropdownList: mikoDropdownList,
                                          onChange: (dropdownItem) {
                                            setState(() {
                                              save();
                                              isChange = true;
                                              nowMikoAvater =
                                                  dropdownItem['value'];
                                            });
                                          },
                                          defaultValue: mikoDropdownList[
                                              nowMikoAvater - 1],
                                        ),
                                      ],
                                    )),
                                Divider(
                                  color: Colors.white,
                                  height: 20.h,
                                  indent: 20.w,
                                  endIndent: 30.w,
                                  thickness: 1,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 5.h, bottom: 10.h),
                                    child: Row(
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w),
                                                  child: Text('玩家头像更换',
                                                      style: TextStyle(
                                                          fontSize: 25.sp,
                                                          color:
                                                              Colors.white))),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.w, top: 10.h),
                                                  child: Container(
                                                      width: 220.w,
                                                      child: Text(
                                                          '自行裁剪图片为正方形,不要删除图片或移动位置',
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              color: Colors
                                                                  .grey)))),
                                            ]),
                                        Padding(
                                          padding: EdgeInsets.only(right: 3.w),
                                          child: Container(
                                              child: CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                  child: playerAvater()),
                                              width: 60.r,
                                              height: 60.r),
                                        ),
                                        CoolDropdown(
                                          resultWidth: 183.w,
                                          dropdownList: playerDropdownList,
                                          onChange: (dropdownItem) async {
                                            if (dropdownItem['value'] == 0) {
                                              playerAvatarSet = '默认';
                                              playerNowAvater = 0;
                                              isChange = true;
                                              setState(() {
                                                save();
                                                playerAvater();
                                              });
                                            }
                                            if (dropdownItem['value'] == 1) {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              try {
                                                playerAvatarSet = image!.path;
                                                playerNowAvater = 1;
                                                isChange = true;
                                              } catch (error) {}
                                              setState(() {
                                                isChange = true;
                                                save();
                                                playerAvater();
                                              });
                                            }
                                          },
                                          defaultValue: playerDropdownList[
                                              playerNowAvater],
                                        ),
                                      ],
                                    )),
                              ])),
                    )),
                GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                        title: '警告',
                        titleStyle: TextStyle(color: Colors.red),
                        content: Text(
                          '此功能会清除图鉴,词典,动态,游玩进度等记录',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        textConfirm: '确定',
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.defaultDialog(
                              title: '提示',
                              titleStyle: TextStyle(color: Colors.blue),
                              middleText: '缓存已清除');
                          delAll();
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5.h, left: 10.w, right: 10.w, bottom: 5.w),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              color: Color.fromRGBO(38, 38, 38, 1),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.h, left: 20.w, bottom: 10.h),
                                      child: Row(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('清除缓存',
                                                  style: TextStyle(
                                                      fontSize: 25.sp,
                                                      color: Colors.white))
                                            ]),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 325.w),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    child: Icon(
                                                        Icons.chevron_right,
                                                        color: Colors.white,
                                                        size: 50.r)))),
                                      ]))
                                ],
                              ))),
                    )),
                GestureDetector(
                    onTap: () {
                      Get.to(MyAppInfo());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5.h, left: 10.w, right: 10.w, bottom: 5.w),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              color: Color.fromRGBO(38, 38, 38, 1),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.h, left: 20.w, bottom: 10.h),
                                      child: Row(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('关于异次元通讯',
                                                  style: TextStyle(
                                                      fontSize: 25.sp,
                                                      color: Colors.white))
                                            ]),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(left: 250.w),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    child: Icon(
                                                        Icons.chevron_right,
                                                        color: Colors.white,
                                                        size: 50.r)))),
                                      ]))
                                ],
                              ))),
                    )),
              ]),
            ])
          ])),
      Container(
          alignment: Alignment.topLeft,
          child: Stack(children: [
            Container(
              //标题栏
              color: Colors.black,
              width: 540.h,
              height: 50.h,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text('设置',
                        style:
                            TextStyle(color: Colors.white, fontSize: 25.sp)))),

            //返回图标
            GestureDetector(
                onTap: () {
                  // Get.back();
                  if (isChange == true && where == 'chat') {
                    isChange = false;
                    // where = '';
                    Get.offAll(ChatPage());
                  } else if (where == 'chat') {
                    // where = '';
                    Get.back();
                  } else if (isChange && where == 'image') {
                    // where = '';
                    Get.offAll(ImagePage());
                  } else {
                    Get.back();
                  }
                },
                child:
                    Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
          ])),
    ]);
  }
}

class MyAppInfo extends StatefulWidget {
  @override
  State<MyAppInfo> createState() => _MyAppInfoState();
}

class _MyAppInfoState extends State<MyAppInfo> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
                    imageMap.forEach((key, value) {
                      imageMap.update(key, (value) => true);
                    });
                    dictionaryMap.forEach((key, value) {
                      List dt = dictionaryMap[key];
                      dt[1] = 'true';
                      dictionaryMap[key] = dt;
                    });
                    EasyLoading.showToast('恭喜你触发彩蛋,本次启动解锁全图鉴和词典,下次启动恢复原本解锁状态',
                        toastPosition: EasyLoadingToastPosition.bottom);
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text('异次元通讯 - 次元复苏',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 25.sp)))),
              Container(
                  padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child:
                      Text('V $version', style: TextStyle(color: Colors.grey))),
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                      width: 500.w,
                      color: Color.fromRGBO(38, 38, 38, 1),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  final Uri url =
                                      Uri.parse('https://www.subrecovery.top');
                                  await launchUrl(url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                          color: Color.fromRGBO(38, 38, 38, 1),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h,
                                                      left: 20.w,
                                                      bottom: 10.h),
                                                  child: Row(children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('官网',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white))
                                                        ]),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 350.w),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50
                                                                        .r)))),
                                                  ]))
                                            ],
                                          ))),
                                )),
                            Divider(
                              color: Colors.grey,
                              height: 0,
                              indent: 30.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://www.yuque.com/docs/share/61b42397-f1f4-4457-9fdd-d50e45d214df');
                                  await launchUrl(url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                          color: Color.fromRGBO(38, 38, 38, 1),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h,
                                                      left: 20.w,
                                                      bottom: 10.h),
                                                  child: Row(children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('帮助',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white))
                                                        ]),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 350.w),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50
                                                                        .r)))),
                                                  ]))
                                            ],
                                          ))),
                                )),
                            Divider(
                              color: Colors.grey,
                              height: 0,
                              indent: 30.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://jq.qq.com/?_wv=1027&k=YTPhqrNW');
                                  await launchUrl(url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                          color: Color.fromRGBO(38, 38, 38, 1),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h,
                                                      left: 20.w,
                                                      bottom: 10.h),
                                                  child: Row(children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Q群',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white))
                                                        ]),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 358.w),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50
                                                                        .r)))),
                                                  ]))
                                            ],
                                          ))),
                                )),
                            Divider(
                              color: Colors.grey,
                              height: 0,
                              indent: 30.w,
                              endIndent: 30.w,
                              thickness: 1,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(
                                      'https://afdian.net/a/subrecovery');
                                  await launchUrl(url);
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.w, right: 10.w),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                          color: Color.fromRGBO(38, 38, 38, 1),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.h,
                                                      left: 20.w,
                                                      bottom: 10.h),
                                                  child: Row(children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('投喂',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25.sp,
                                                                  color: Colors
                                                                      .white))
                                                        ]),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 350.w),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child: Container(
                                                                child: Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 50
                                                                        .r)))),
                                                  ]))
                                            ],
                                          ))),
                                )),
                          ])))
            ],
          )),
      Container(
          alignment: Alignment.topLeft,
          child: Stack(children: [
            Container(
              //标题栏
              color: Colors.black,
              width: 540.h,
              height: 50.h,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Text('关于异次元通讯',
                        style:
                            TextStyle(color: Colors.white, fontSize: 25.sp)))),

            //返回图标
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child:
                    Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
          ])),
    ]);
  }
}
