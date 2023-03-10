import 'package:chatapp/config/chat_config.dart';
import 'package:chatapp/function/setting_funvtion.dart';
import 'package:chatapp/page/chat.dart';
import 'package:chatapp/page/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:image_picker/image_picker.dart';

import '../config/setting_config.dart';
import '../function/bubble.dart';
import 'menu.dart';
import 'myAppInfo.dart';

class SettingPage extends StatefulWidget {
  final String where;
  SettingPage(this.where);
  @override
  SettingPageState createState() => SettingPageState(where);
}

class SettingPageState extends State<SettingPage> {
  late final String where;

  SettingPageState(this.where);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: topHeight),
        child: Stack(children: [
          Container(
              color: Color.fromRGBO(13, 13, 13, 1), width: 1.sw, height: 1.sh),
          Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
              child: ListView(children: [
                Stack(children: [
                  Column(children: [
                    roundCard(Column(children: [
                      SwitchButton(
                          title: '背景音乐',
                          value: backgroundMusicSwitch,
                          onChanged: (value) {
                            setting_config_save();
                            backgroundMusicSwitch = !backgroundMusicSwitch;
                            backgroundMusic();
                            setState(() {});
                          }),
                      whiteLine(),
                      SwitchButtonWithSubtitle(
                          title: '背景音乐替换',
                          subtitle: '开启为初章恐怖氛围的背景音乐',
                          value: isOldBgm,
                          onChanged: (value) {
                            setting_config_save();
                            isOldBgm = !isOldBgm;
                            backgroundMusic();
                            setState(() {});
                          }),
                      whiteLine(),
                      SwitchButton(
                          title: '选项音效',
                          value: buttonMusicSwitch,
                          onChanged: (value) {
                            setting_config_save();
                            buttonMusicSwitch = value;
                            setState(() {});
                          }),
                    ])),
                    roundCard(
                      Column(children: [
                        SwitchButton(
                            title: '调试信息',
                            value: isDebug,
                            onChanged: (value) {
                              setting_config_save();
                              isDebug = value;
                              setState(() {});
                            }),
                        whiteLine(),
                        isDebug
                            ? GestureDetector(
                                onTap: () async {
                                  Get.to(SearchPage());
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        color: Color.fromRGBO(38, 38, 38, 1),
                                        margin: EdgeInsets.only(
                                            left: 10.w, right: 10.w),
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            left: 10.w,
                                            bottom: 10.h),
                                        child: Row(children: [
                                          Expanded(
                                              child: Text('搜索剧本',
                                                  style: TextStyle(
                                                      fontSize: 25.sp,
                                                      color: Colors.white))),
                                          Icon(Icons.chevron_right,
                                              color: Colors.white, size: 50.r),
                                        ]))),
                              )
                            : Container(),
                        whiteLine(),
                        SwitchButtonWithSubtitle(
                            title: 'AI图鉴',
                            subtitle:
                                '用AI绘画(stable-diffusion)重新绘制部分图鉴\r\n只修改在菜单的图鉴,聊天和动态仍为原图鉴',
                            value: isNewImage,
                            onChanged: (value) {
                              setting_config_save();
                              isChange = true;
                              isNewImage = value;
                              setState(() {});
                            }),
                        Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: whiteLine()),
                        SwitchButtonWithSubtitle(
                            title: '打字时间',
                            subtitle: '关闭则对方直接发送消息',
                            value: waitTyping,
                            onChanged: (value) {
                              setting_config_save();
                              waitTyping = value;
                              setState(() {});
                            }),
                        whiteLine(),
                        SwitchButtonWithSubtitle(
                            title: '等待上线',
                            subtitle: '关闭则对方下线直接上线',
                            value: waitOffline,
                            onChanged: (value) {
                              setting_config_save();
                              waitOffline = value;
                              if (!value) {
                                startTime = -1;
                              }
                              setState(() {});
                            }),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                              color: Color.fromRGBO(38, 38, 38, 1),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text('Miko头像更换',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.white)),
                                        ),
                                        Row(children: [
                                          Image.asset(
                                              'assets/icon/头像$nowMikoAvater.png',
                                              width: 50.r,
                                              height: 50.r),
                                          CoolDropdown(
                                            dropdownList: mikoDropdownList,
                                            onChange: (dropdownItem) {
                                              setState(() {
                                                setting_config_save();
                                                isChange = true;
                                                nowMikoAvater =
                                                    dropdownItem['value'];
                                              });
                                            },
                                            defaultValue: mikoDropdownList[
                                                nowMikoAvater - 1],
                                          ),
                                        ]),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 10.h, bottom: 5.h),
                                      child: Divider(
                                        color: Colors.white,
                                        height: 0,
                                        thickness: 1,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(children: [
                                          Text('玩家头像更换',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.white)),
                                          Container(
                                              padding:
                                                  EdgeInsets.only(top: 5.h),
                                              child: Text('不要删除图片或移动位置',
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      color: Colors.grey))),
                                        ])),
                                        Row(children: [
                                          Container(
                                              child: CircleAvatar(
                                                  radius: 30.r,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          0, 0, 0, 1),
                                                  child: playerAvater()),
                                              width: 50.r,
                                              height: 50.r),
                                          CoolDropdown(
                                            dropdownList: playerDropdownList,
                                            onChange: (dropdownItem) async {
                                              if (dropdownItem['value'] == 0) {
                                                playerAvatarSet = '默认';
                                                playerNowAvater = 0;
                                                isChange = true;
                                                setState(() {
                                                  setting_config_save();
                                                  playerAvater();
                                                });
                                              }
                                              if (dropdownItem['value'] == 1) {
                                                final ImagePicker picker =
                                                    ImagePicker();
                                                final XFile? image =
                                                    await picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                try {
                                                  playerAvatarSet = image!.path;
                                                  playerNowAvater = 1;
                                                  isChange = true;
                                                } catch (error) {}
                                                setState(() {
                                                  isChange = true;
                                                  setting_config_save();
                                                  playerAvater();
                                                });
                                              }
                                            },
                                            defaultValue: playerDropdownList[
                                                playerNowAvater],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ]))),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.to(MyAppInfo());
                      },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 20.h),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                  color: Color.fromRGBO(38, 38, 38, 1),
                                  padding:
                                      EdgeInsets.fromLTRB(20.w, 5.h, 10.w, 5.h),
                                  child: Row(children: [
                                    Expanded(
                                        child: Text('关于异次元通讯',
                                            style: TextStyle(
                                                fontSize: 25.sp,
                                                color: Colors.white))),
                                    Icon(Icons.chevron_right,
                                        color: Colors.white, size: 50.r),
                                  ])))),
                    )
                  ]),
                ])
              ])),
          Container(
              alignment: Alignment.topLeft,
              child: Stack(children: [
                Container(
                  color: Colors.black,
                  width: 540.h,
                  height: 50.h,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text('设置',
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp)))),
                GestureDetector(
                    onTap: () {
                      if (isChange == true && where == 'chat') {
                        isChange = false;
                        IsOnChatPage = true;
                        Get.offAll(ChatPage());
                      } else if (where == 'chat') {
                        IsOnChatPage = true;
                        Get.back();
                      } else if (isChange && where == 'image') {
                        isChange = false;
                        Get.offAll(MenuPage());
                      } else if (isChange && where == '词典') {
                        isChange = false;
                        Get.offAll(MenuPage());
                      } else {
                        Get.back();
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.only(left: 5.w, top: 3.h),
                        child: Icon(Icons.chevron_left,
                            color: Colors.white, size: 60.r))),
              ])),
        ]));
  }
}
