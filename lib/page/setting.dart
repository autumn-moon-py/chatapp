import 'package:chatapp/function/setting_funvtion.dart';
import 'package:chatapp/page/dictionary.dart';
import 'package:chatapp/page/chat.dart';
import 'package:chatapp/page/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:image_picker/image_picker.dart';

import '../config/image_config.dart';
import '../config/setting_config.dart';
import '../function/send.dart';
import 'myAppInfo.dart';

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
                roundCard(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      whiteLine(),
                      Padding(
                          padding: EdgeInsets.only(left: 22.w),
                          child: Row(
                            children: <Widget>[
                              Text('语音音量',
                                  style: TextStyle(
                                      fontSize: 25.sp, color: Colors.white)),
                              Padding(
                                  padding: EdgeInsets.only(left: 100.w),
                                  child: Slider(
                                    value: sliderValue,
                                    onChanged: (data) {
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
                                    activeColor: Color.fromRGBO(0, 102, 203, 1),
                                    inactiveColor: Colors.grey,
                                    semanticFormatterCallback:
                                        (double newValue) {
                                      return '${newValue.round()} dollars}';
                                    },
                                  ))
                            ],
                          ))
                    ])),
                roundCard(
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SwitchButtonWithSubtitle(
                            title: 'AI图鉴',
                            subtitle:
                                '用AI绘画(stable-diffusion)重新绘制部分图鉴,只修改在菜单的图鉴,聊天和动态仍为原图鉴',
                            value: isNewImage,
                            onChanged: (value) {
                              setting_config_save();
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
                        Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: whiteLine()),
                        // SwitchButtonWithSubtitle(
                        //     title: '自娱自乐',
                        //     subtitle: '自己跟Miko(也是你)聊天,会清理聊天记录',
                        //     value: scrolling,
                        //     onChanged: (value) {
                        //       scrolling = value;
                        //       if (value) {
                        //         line = -1;
                        //         clean_message();
                        //         setState(() {});
                        //       } else {
                        //         line = 0;
                        //         setState(() {});
                        //       }
                        //     }),
                        // whiteLine(),
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
                              setState(() {});
                            }),
                        whiteLine(),
                        SwitchButton(
                            title: '自动更新',
                            value: isAutoUpgrade,
                            onChanged: (value) {
                              isAutoUpgrade = value;
                              setting_config_save();
                              setState(() {});
                            })
                      ]),
                ),
                roundCard(Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Text('Miko头像更换',
                                      style: TextStyle(
                                          fontSize: 25.sp,
                                          color: Colors.white))),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.w, right: 3.w),
                                  child: Image.asset(
                                      'assets/icon/头像$nowMikoAvater.png',
                                      width: 50.r,
                                      height: 50.r)),
                              CoolDropdown(
                                resultWidth: 245.w,
                                dropdownList: mikoDropdownList,
                                onChange: (dropdownItem) {
                                  setState(() {
                                    setting_config_save();
                                    isChange = true;
                                    nowMikoAvater = dropdownItem['value'];
                                  });
                                },
                                defaultValue:
                                    mikoDropdownList[nowMikoAvater - 1],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: whiteLine()),
                      Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                          child: Row(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 20.w),
                                        child: Text('玩家头像更换',
                                            style: TextStyle(
                                                fontSize: 25.sp,
                                                color: Colors.white))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.w, top: 10.h),
                                        child: Container(
                                            width: 220.w,
                                            child: Text('不要删除图片或移动位置',
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.grey)))),
                                  ]),
                              Padding(
                                padding: EdgeInsets.only(right: 3.w),
                                child: Container(
                                    child: CircleAvatar(
                                        radius: 30.r,
                                        backgroundColor:
                                            Color.fromRGBO(0, 0, 0, 1),
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
                                      setting_config_save();
                                      playerAvater();
                                    });
                                  }
                                  if (dropdownItem['value'] == 1) {
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
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
                                defaultValue:
                                    playerDropdownList[playerNowAvater],
                              ),
                            ],
                          )),
                    ])),
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
