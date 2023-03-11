import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/dictionary_config.dart';
import '../config/image_config.dart';
import '../config/setting_config.dart';

easterEgg() {
  isChange = true;
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
}

greyLine() {
  return Divider(
    color: Colors.white,
    height: 0,
    indent: 20.w,
    endIndent: 20.w,
    thickness: 1,
  );
}

UrlButton(String title, String website) {
  return GestureDetector(
    onTap: () async {
      final Uri url = Uri.parse(website);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    },
    child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 10.w, 10.h),
        child: Row(children: [
          Expanded(
              child: Text(title,
                  style: TextStyle(fontSize: 25.sp, color: Colors.white))),
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                  child: Icon(Icons.chevron_right,
                      color: Colors.white, size: 50.r))),
        ])),
  );
}
