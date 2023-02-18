import 'dart:convert';
import 'dart:io';
import 'package:chatapp/dictionary.dart';
import 'package:dio/dio.dart';
import 'package:chatapp/chat.dart';
import 'package:chatapp/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
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

  SettingPageState(this.where);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: [
      Container(
          color: Color.fromRGBO(13, 13, 13, 1), width: 1.sw, height: 1.sh),
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
                                                EdgeInsets.only(left: 100.w),
                                            child: Slider(
                                              value: sliderValue,
                                              onChanged: (data) {
                                                // print('change:$data');
                                                voice(data);
                                                setState(() {
                                                  sliderValue = data;
                                                });
                                              },
                                              onChangeStart: (data) {},
                                              onChangeEnd: (data) {},
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
                                    '用AI绘画(stable-diffusion)重新绘制部分图鉴,只修改在菜单的图鉴,聊天和动态仍为原图鉴',
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
                            // SwitchListTile(
                            //     title: Text('自娱自乐',
                            //         style: TextStyle(
                            //             fontSize: 25.sp, color: Colors.white)),
                            //     subtitle: Text('自己跟Miko(也是你)聊天',
                            //         style: TextStyle(
                            //             fontSize: 15.sp, color: Colors.grey)),
                            //     value: scrolling,
                            //     activeColor: Colors.white,
                            //     activeTrackColor:
                            //         Color.fromRGBO(0, 102, 203, 1),
                            //     inactiveTrackColor:
                            //         Color.fromRGBO(60, 60, 60, 1),
                            //     onChanged: (value) {
                            //       messages = [];
                            //       messagesInfo = [];
                            //       line = 0; //当前下标
                            //       startTime = 0;
                            //       jump = 0;
                            //       be_jump = 0;
                            //       reast_line = 0;
                            //       choose_one = '';
                            //       choose_two = '';
                            //       choose_one_jump = 0;
                            //       choose_two_jump = 0;
                            //       story = [];
                            //       saveChat();
                            //       save();
                            //       isChange = true;
                            //       scrolling = value;
                            //       setState(() {});
                            //     }),
                            // Divider(
                            //   color: Colors.white,
                            //   height: 0,
                            //   indent: 20.w,
                            //   endIndent: 30.w,
                            //   thickness: 1,
                            // ),
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
                // GestureDetector(
                //     onTap: () {
                //       showDialog(
                //           context: context,
                //           builder: (context) {
                //             return AlertDialog(
                //               content: Container(
                //                   height: 120.h,
                //                   child: Column(children: [
                //                     Text('提示',
                //                         style: TextStyle(
                //                             fontSize: 40.sp,
                //                             color: Colors.red)),
                //                     Padding(
                //                         padding: EdgeInsets.only(top: 10.h),
                //                         child: Text(
                //                           '此操作会清除聊天记录',
                //                           style: TextStyle(fontSize: 25.sp),
                //                         ))
                //                   ])),
                //               actions: [
                //                 TextButton(
                //                   child: Text("取消"),
                //                   onPressed: () {
                //                     Navigator.pop(context, 'Cancle');
                //                   },
                //                 ),
                //                 TextButton(
                //                     child: Text("确定"),
                //                     onPressed: () {
                //                       Navigator.pop(context, 'Ok');
                //                       delAll();
                //                       isChange = true;
                //                       Get.defaultDialog(
                //                           title: '提示',
                //                           titleStyle:
                //                               TextStyle(color: Colors.blue),
                //                           middleText: '缓存已清除');
                //                     })
                //               ],
                //             );
                //           });
                //     },
                //     child: Padding(
                //       padding: EdgeInsets.only(
                //           top: 5.h, left: 10.w, right: 10.w, bottom: 5.w),
                //       child: ClipRRect(
                //           borderRadius: BorderRadius.circular(20),
                //           child: Container(
                //               color: Color.fromRGBO(38, 38, 38, 1),
                //               child: Column(
                //                 children: [
                //                   Padding(
                //                       padding: EdgeInsets.only(
                //                           top: 10.h, left: 20.w, bottom: 10.h),
                //                       child: Row(children: [
                //                         Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             children: [
                //                               Text('清除缓存',
                //                                   style: TextStyle(
                //                                       fontSize: 25.sp,
                //                                       color: Colors.white))
                //                             ]),
                //                         Padding(
                //                             padding:
                //                                 EdgeInsets.only(left: 325.w),
                //                             child: ClipRRect(
                //                                 borderRadius:
                //                                     BorderRadius.circular(5),
                //                                 child: Container(
                //                                     child: Icon(
                //                                         Icons.chevron_right,
                //                                         color: Colors.white,
                //                                         size: 50.r)))),
                //                       ]))
                //                 ],
                //               ))),
                //     )),
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
                  if (isChange == true && where == 'chat') {
                    isChange = false;
                    Get.offAll(ChatPage());
                  } else if (where == 'chat') {
                    Get.back();
                  } else if (isChange && where == 'image') {
                    isChange = false;
                    Get.offAll(ImagePage());
                  } else if (isChange && where == '词典') {
                    isChange = false;
                    Get.offAll(DictionaryPage());
                  } else {
                    Get.back();
                  }
                },
                child:
                    Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
          ])),
    ]));
  }
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
            builder: (context) => Stack(children: [
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
                                isChange = true;
                                imageMap.forEach((key, value) {
                                  imageMap.update(key, (value) => true);
                                });
                                dictionaryMap.forEach((key, value) {
                                  List dt = dictionaryMap[key];
                                  dt[1] = 'true';
                                  dictionaryMap[key] = dt;
                                });
                                EasyLoading.showToast(
                                    '恭喜你触发彩蛋,本次启动解锁全图鉴和词典,下次启动恢复原本解锁状态',
                                    toastPosition:
                                        EasyLoadingToastPosition.bottom);
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
                                              Map result = {'info': ''};
                                              final progress =
                                                  ProgressHUD.of(context);
                                              try {
                                                progress!
                                                    .showWithText('检查中...');
                                                var response = await Dio().get(
                                                    "https://www.subrecovery.top/app/upgrade.json");
                                                if (response.statusCode ==
                                                    HttpStatus.ok) {
                                                  progress.dismiss();
                                                  result = jsonDecode(
                                                      response.toString());
                                                } else {
                                                  result.update(
                                                      'info', (value) => '无网络');
                                                  progress.dismiss();
                                                  EasyLoading.showToast('无网络',
                                                      toastPosition:
                                                          EasyLoadingToastPosition
                                                              .bottom);
                                                }
                                              } catch (error) {
                                                progress!.dismiss();
                                                result.update(
                                                    'info',
                                                    (value) =>
                                                        '请求失败,请重试,如果多次失败请反馈');
                                              }
                                              if (result.length > 1) {
                                                if (result['version'] !=
                                                    version) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                              height: 120.h,
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                        '当前: $version  最新: ${result['version']}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                35.sp,
                                                                            color: Colors.blue)),
                                                                    Text(
                                                                      result[
                                                                          'info'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20.sp),
                                                                    )
                                                                  ])),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("取消"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Cancle');
                                                              },
                                                            ),
                                                            TextButton(
                                                                child:
                                                                    Text("更新"),
                                                                onPressed:
                                                                    () async {
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          'https://www.subrecovery.top/app'),
                                                                      mode: LaunchMode
                                                                          .externalApplication);
                                                                })
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  EasyLoading.showToast('无更新',
                                                      toastPosition:
                                                          EasyLoadingToastPosition
                                                              .bottom);
                                                }
                                              } else {
                                                Get.defaultDialog(
                                                    title: '错误',
                                                    titleStyle: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: Colors.red),
                                                    middleText: '请求失败');
                                              }
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
                                                  'https://www.subrecovery.top');
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
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
                                                                              '官网',
                                                                              style: TextStyle(fontSize: 25.sp, color: Colors.white))
                                                                        ]),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 350
                                                                                .w),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Container(child: Icon(Icons.chevron_right, color: Colors.white, size: 50.r)))),
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
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
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
                                                                              '帮助',
                                                                              style: TextStyle(fontSize: 25.sp, color: Colors.white))
                                                                        ]),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 350
                                                                                .w),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Container(child: Icon(Icons.chevron_right, color: Colors.white, size: 50.r)))),
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
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
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
                                                                              'Q群',
                                                                              style: TextStyle(fontSize: 25.sp, color: Colors.white))
                                                                        ]),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 358
                                                                                .w),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Container(child: Icon(Icons.chevron_right, color: Colors.white, size: 50.r)))),
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
                                              await launchUrl(url,
                                                  mode: LaunchMode
                                                      .externalApplication);
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
                                                                              '投喂',
                                                                              style: TextStyle(fontSize: 25.sp, color: Colors.white))
                                                                        ]),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left: 350
                                                                                .w),
                                                                        child: ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child: Container(child: Icon(Icons.chevron_right, color: Colors.white, size: 50.r)))),
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
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.sp)))),

                        //返回图标
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(Icons.chevron_left,
                                color: Colors.white, size: 50.r)),
                      ])),
                ])));
  }
}
