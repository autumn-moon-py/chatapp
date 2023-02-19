import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget roundCard(Widget child) {
  return Column(children: [
    Padding(
        padding:
            EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h, top: 5.h),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:
                Container(color: Color.fromRGBO(38, 38, 38, 1), child: child)))
  ]);
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
    endIndent: 30.w,
    thickness: 1,
  );
}
