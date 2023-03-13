import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';

Widget roundCard(Widget child) {
  return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h, top: 5.h),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              // margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              color: Color.fromRGBO(38, 38, 38, 1),
              child: child)));
}

class SwitchButton extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  SwitchButton(
      {required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        contentPadding: EdgeInsets.only(left: 20.w, right: 10.w),
        title:
            Text(title, style: TextStyle(fontSize: 25.sp, color: Colors.white)),
        value: value,
        activeColor: Colors.white,
        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
        onChanged: onChanged);
  }
}

class SwitchButtonWithSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  SwitchButtonWithSubtitle(
      {required this.title,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        contentPadding: EdgeInsets.only(left: 20.w, right: 10.w),
        title:
            Text(title, style: TextStyle(fontSize: 25.sp, color: Colors.white)),
        subtitle: Text(subtitle,
            style: TextStyle(color: Colors.grey, fontSize: 15.sp)),
        value: value,
        activeColor: Colors.white,
        activeTrackColor: Color.fromRGBO(0, 102, 203, 1),
        inactiveTrackColor: Color.fromRGBO(60, 60, 60, 1),
        onChanged: onChanged);
  }
}

whiteLine() {
  return Divider(
    color: Colors.white,
    height: 0,
    indent: 20.w,
    endIndent: 20.w,
    thickness: 1,
  );
}

pushSetup() {
  //设置隐私协议授权状态
  MobpushPlugin.updatePrivacyPermissionStatus(true);
//设置别名，注意，每个别名只能存在一台设备，后者会覆盖前者。厂商通道，会根据后者来进行推送
  MobpushPlugin.setAlias("别名").then((Map<String, dynamic> aliasMap) {
    String res = aliasMap['res'];
    String error = aliasMap['error'];
    String errorCode = aliasMap['errorCode'];
    print("setAlias -> res: $res error: $error errcode $errorCode");
  });
}
