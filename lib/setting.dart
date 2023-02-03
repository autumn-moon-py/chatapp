import 'package:chatapp/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:package_info_plus/package_info_plus.dart';

import 'config.dart';
import 'send.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

//设置页面布局
class SettingPageState extends State<SettingPage> {
  @override
  Widget build(Object context) {
    return Flexible(
        child: ListView(children: [
      Stack(children: [
        Container(
            color: Color.fromRGBO(13, 13, 13, 1), width: 1.sw, height: 1.sh),
        Column(children: [
          Container(
              alignment: Alignment.topLeft,
              child: Stack(children: [
                Container(
                  //标题栏
                  color: Colors.black,
                  width: 1.sw,
                  height: (1 / 24).sh + 5,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('设置',
                            style: TextStyle(
                                color: Colors.white, fontSize: 25.sp)))),

                //返回图标
                GestureDetector(
                    onTap: () => Get.to(ChatPage()),
                    child: Icon(Icons.chevron_left,
                        color: Colors.white, size: 40)),
              ])),
          Padding(
            padding:
                EdgeInsets.only(left: (1 / 54).sw, top: 5, right: (1 / 54).sw),
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
                          subtitle: Text('用AI绘画(stable-diffusion)重新绘制部分图鉴',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.grey)),
                          value: isNewImage,
                          activeColor: Colors.white,
                          activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                          inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                          onChanged: (value) {
                            save();
                            isNewImage = value;
                            setState(() {});
                          }),
                      Divider(
                        color: Colors.white,
                        height: 0,
                        indent: (1 / 28).sw,
                        endIndent: (1 / 18).sw,
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
                          activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                          inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                          onChanged: (value) {
                            save();
                            scrolling = value;
                            setState(() {});
                          }),
                      Divider(
                        color: Colors.white,
                        height: 0,
                        indent: (1 / 28).sw,
                        endIndent: (1 / 18).sw,
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
                          activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                          inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                          onChanged: (value) {
                            save();
                            waitTyping = value;
                            setState(() {});
                          }),
                      Divider(
                        color: Colors.white,
                        height: 0,
                        indent: (1 / 28).sw,
                        endIndent: (1 / 18).sw,
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
                          activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                          inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
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
              padding: EdgeInsets.all((1 / 54).sw),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    color: Color.fromRGBO(38, 38, 38, 1),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: (1 / 27).sw),
                                      child: Text('Miko头像更换',
                                          style: TextStyle(
                                              fontSize: 25.sp,
                                              color: Colors.white))),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: (1 / 37).sw,
                                          right: (1 / 180).sw),
                                      child: Image.asset(
                                          'assets/icon/头像$nowMikoAvater.png',
                                          width: (1 / 10.8).sw,
                                          height: (1 / 10.8).sw)),
                                  CoolDropdown(
                                    resultWidth: (1 / 2.2).sw,
                                    dropdownList: mikoDropdownList,
                                    onChange: (dropdownItem) {
                                      setState(() {
                                        save();
                                        nowMikoAvater = dropdownItem['value'];
                                      });
                                    },
                                    defaultValue:
                                        mikoDropdownList[nowMikoAvater - 1],
                                  ),
                                ],
                              )),
                          Divider(
                            color: Colors.white,
                            height: 20,
                            indent: (1 / 28).sw,
                            endIndent: (1 / 18).sw,
                            thickness: 1,
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 10),
                              child: Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: (1 / 27).sw),
                                            child: Text('玩家头像更换',
                                                style: TextStyle(
                                                    fontSize: 25.sp,
                                                    color: Colors.white))),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: (1 / 27).sw, top: 10),
                                            child: Container(
                                                width: (1 / 2.44).sw,
                                                child: Text(
                                                    '自行裁剪图片为正方形,不要删除图片或移动位置',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: Colors.grey)))),
                                      ]),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: (1 / 180).sw),
                                    child: Container(
                                        child: CircleAvatar(
                                            radius: (1 / 20).sw,
                                            backgroundColor:
                                                Color.fromRGBO(0, 0, 0, 1),
                                            child: playerAvater()),
                                        width: (1 / 10.8).sw,
                                        height: (1 / 10.8).sw),
                                  ),
                                  CoolDropdown(
                                    resultWidth: 140,
                                    dropdownList: playerDropdownList,
                                    onChange: (dropdownItem) async {
                                      if (dropdownItem['value'] == 0) {
                                        playerAvatarSet = '默认';
                                        playerNowAvater = 0;
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
                                                source: ImageSource.gallery);
                                        try {
                                          playerAvatarSet = image!.path;
                                          playerNowAvater = 1;
                                        } catch (error) {}
                                        setState(() {
                                          save();
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
              )),
        ]),
      ])
    ]));
  }
}

// packageInfoList() async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String appName = packageInfo.appName;
//   String packageName = packageInfo.packageName;
//   String version = packageInfo.version;
//   String buildNumber = packageInfo.buildNumber;
// }
