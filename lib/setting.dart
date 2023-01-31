import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:package_info_plus/package_info_plus.dart';

import 'config.dart';

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

//设置页面布局
class SettingPageState extends State<SettingPage> {
  @override
  Widget build(Object context) {
    //加载数据
    load() async {
      local = await SharedPreferences.getInstance();
      setState(() {
        isNewImage = local?.getBool('isNewImage') ?? false;
        scrolling = local?.getBool('scrolling') ?? true;
        nowMikoAvater = local?.getInt('nowMikoAvater') ?? 1;
        waitTyping = local?.getBool('waitTyping') ?? true;
        waitOffline = local?.getBool('waitOffline') ?? true;
      });
    }

    load();
    return Stack(children: [
      Container(
          color: Color.fromRGBO(13, 13, 13, 1), width: 1.sw, height: 1.sh),
      Column(children: [
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
                    width: 1.sw,
                    height: (1 / 24).sh,
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: EdgeInsets.only(top: (1 / 192).sh),
                          child: Text('设置',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.sp)))),

                  //返回图标
                  Icon(Icons.chevron_left,
                      color: Colors.white, size: (1 / 13).sw),
                ]))),
        Padding(
          padding: EdgeInsets.only(
              left: (1 / 54).sw, top: (1 / 54).sw, right: (1 / 54).sw),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: (1 / 2.1).sh,
              color: Color.fromRGBO(38, 38, 38, 1),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SwitchListTile(
                        title: Text('AI图鉴',
                            style: TextStyle(
                                fontSize: 25.sp, color: Colors.white)),
                        subtitle: Text('用AI绘画(stable-diffusion)重新绘制部分图鉴',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey)),
                        value: isNewImage,
                        activeColor: Colors.white,
                        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                        onChanged: (value) {
                          save();
                          isNewImage = value;
                        }),
                    Divider(
                      color: Colors.white,
                      height: (1 / 96).sh,
                      indent: (1 / 28).sw,
                      endIndent: (1 / 18).sw,
                      thickness: 1,
                    ),
                    SwitchListTile(
                        title: Text('自动滚屏',
                            style: TextStyle(
                                fontSize: 25.sp, color: Colors.white)),
                        subtitle: Text('当聊天内容超出一屏,发送消息自动滚动到最新一条',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey)),
                        value: scrolling,
                        activeColor: Colors.white,
                        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                        onChanged: (value) {
                          save();
                          scrolling = value;
                        }),
                    Divider(
                      color: Colors.white,
                      height: (1 / 96).sh,
                      indent: (1 / 28).sw,
                      endIndent: (1 / 18).sw,
                      thickness: 1,
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: (1 / 96).sh),
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: (1 / 27).sw),
                                child: Text('Miko头像更换',
                                    style: TextStyle(
                                        fontSize: 25.sp, color: Colors.white))),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: (1 / 37).sw, right: (1 / 180).sw),
                                child: Image.asset(
                                    'assets/icon/头像$nowMikoAvater.png',
                                    width: (1 / 10.8).sw,
                                    height: (1 / 10.8).sw)),
                            CoolDropdown(
                              dropdownList: dropdownList,
                              onChange: (dropdownItem) {
                                nowMikoAvater = dropdownItem['value'];
                              },
                              defaultValue: dropdownList[nowMikoAvater - 1],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: (1 / 96).sh),
                        child: Divider(
                          color: Colors.white,
                          height: (1 / 96).sh,
                          indent: (1 / 28).sw,
                          endIndent: (1 / 18).sw,
                          thickness: 1,
                        )),
                    SwitchListTile(
                        title: Text('打字时间',
                            style: TextStyle(
                                fontSize: 25.sp, color: Colors.white)),
                        subtitle: Text('关闭则对方直接发送消息',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey)),
                        value: waitTyping,
                        activeColor: Colors.white,
                        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                        onChanged: (value) {
                          save();
                          waitTyping = value;
                        }),
                    Divider(
                      color: Colors.white,
                      height: (1 / 96).sh,
                      indent: (1 / 28).sw,
                      endIndent: (1 / 18).sw,
                      thickness: 1,
                    ),
                    SwitchListTile(
                        title: Text('等待上线',
                            style: TextStyle(
                                fontSize: 25.sp, color: Colors.white)),
                        subtitle: Text('关闭则对方下线直接上线',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey)),
                        value: waitOffline,
                        activeColor: Colors.white,
                        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
                        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
                        onChanged: (value) {
                          save();
                          waitOffline = value;
                        }),
                  ]),
            ),
          ),
        )
      ]),
    ]);
  }
}

// packageInfoList() async {
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   String appName = packageInfo.appName;
//   String packageName = packageInfo.packageName;
//   String version = packageInfo.version;
//   String buildNumber = packageInfo.buildNumber;
// }
