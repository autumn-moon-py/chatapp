import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/dictionary_config.dart';
import '../config/image_config.dart';
import '../config/setting_config.dart';
import '../page/myAppInfo.dart';

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

checkUpgrade(BuildContext context) async {
  Map result = {'info': ''};
  final progress = ProgressHUD.of(context);
  try {
    progress!.showWithText('检查中...');
    var response =
        await Dio().get("https://www.subrecovery.top/app/upgrade.json");
    if (response.statusCode == HttpStatus.ok) {
      progress.dismiss();
      result = jsonDecode(response.toString());
    } else {
      result.update('info', (value) => '无网络');
      progress.dismiss();
      EasyLoading.showToast('无网络',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  } catch (error) {
    progress!.dismiss();
    EasyLoading.showToast('请求失败,请重试,如果多次失败请反馈',
        toastPosition: EasyLoadingToastPosition.bottom);
  }
  if (result.length > 1) {
    if (result['version'] != version) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                  height: 120.h,
                  child: Column(children: [
                    Text('当前: $version  最新: ${result['version']}',
                        style: TextStyle(fontSize: 35.sp, color: Colors.blue)),
                    Text(
                      result['info'],
                      style: TextStyle(fontSize: 20.sp),
                    )
                  ])),
              actions: [
                TextButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.pop(context, 'Cancle');
                  },
                ),
                TextButton(
                    child: Text("更新"),
                    onPressed: () async {
                      await launchUrl(
                          Uri.parse('https://www.subrecovery.top/app'),
                          mode: LaunchMode.externalApplication);
                    })
              ],
            );
          });
    } else {
      EasyLoading.showToast('无更新',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  } else {
    Get.defaultDialog(
        title: '错误',
        titleStyle:
            TextStyle(overflow: TextOverflow.ellipsis, color: Colors.red),
        middleText: '请求失败');
  }
}

greyLine() {
  return Divider(
    color: Colors.grey,
    height: 0,
    indent: 30.w,
    endIndent: 30.w,
    thickness: 1,
  );
}

class UrlButton extends StatelessWidget {
  final String title;
  final String website;

  UrlButton(this.title, this.website);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(website);
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: TextStyle(
                                          fontSize: 25.sp, color: Colors.white))
                                ]),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: (title.length == 2) ? 350.w : 300.w),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                        child: Icon(Icons.chevron_right,
                                            color: Colors.white, size: 50.r)))),
                          ]))
                    ],
                  ))),
        ));
  }
}
