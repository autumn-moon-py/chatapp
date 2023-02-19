import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/chat_config.dart';
import '../config/config.dart';
import '../page/myAppInfo.dart';
import '../page/search.dart';

//读取剧本
loadCVS(String chapter) async {
  //报错检查csv编码是否为utf-8
  final rawData = await rootBundle.loadString(
    "assets/story/$chapter.csv",
  );
  List<List> listData = CsvToListConverter().convert(rawData, eol: '\r\n');
  story = listData;
  if (story.length > 0) {
    print('剧本加载完成');
  }
  story_copy = listData;
}

///清理聊天记录和播放器
clean_message() async {
  List key_list = [
    'messagesInfo',
    'nowChapter',
    'chatName',
    'line',
    'startTime',
    'jump',
    'be_jump',
    'reast_line',
    'choose_one',
    'choose_two',
    'choose_one_jump',
    'choose_two_jump'
  ];
  local = await SharedPreferences.getInstance();
  List<String> keys = local?.getKeys().toList() ?? [];
  messages = [];
  messagesInfo = [];
  story = [];
  choose_one = '';
  choose_two = '';
  keys.forEach((key) {
    key_list.forEach((element) {
      if (key == element) {
        local?.remove(element);
        message_save();
      }
    });
  });
}

//自动检查更新
autoUpgrade() async {
  Map result = {'info': ''};
  try {
    var response =
        await Dio().get("https://www.subrecovery.top/app/upgrade.json");
    if (response.statusCode == HttpStatus.ok) {
      result = jsonDecode(response.toString());
    }
    if (result.length > 1) {
      if (result['version'] != version) {
        EasyLoading.showToast('有新版本,开始自动更新',
            toastPosition: EasyLoadingToastPosition.bottom);
        UpdateModel model = UpdateModel(
            'https://www.subrecovery.top/app/app-release.apk',
            "app-release.apk",
            "ic_launcher",
            result['info']);
        AzhonAppUpdate.update(model);
      }
    }
  } catch (_) {
    EasyLoading.showToast('自动更新失败',
        toastPosition: EasyLoadingToastPosition.bottom);
  }
}

///带输入框的浮窗
class RenameDialog extends AlertDialog {
  RenameDialog({required Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
}

// ignore: must_be_immutable
class RenameDialogContent extends StatefulWidget {
  String title;
  String cancelBtnTitle;
  String okBtnTitle;
  VoidCallback cancelBtnTap;
  VoidCallback okBtnTap;
  TextEditingController vc;
  RenameDialogContent(
      {required this.title,
      this.cancelBtnTitle = "Cancel",
      this.okBtnTitle = "Ok",
      required this.cancelBtnTap,
      required this.okBtnTap,
      required this.vc});

  @override
  _RenameDialogContentState createState() => _RenameDialogContentState();
}

class _RenameDialogContentState extends State<RenameDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20.h),
        height: 170.h,
        width: 1.sw,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(color: Colors.black, fontSize: 25.sp),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
              child: TextField(
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: Colors.black, fontSize: 25.sp),
                controller: widget.vc,
                decoration:
                    InputDecoration(contentPadding: EdgeInsets.only(top: 25.h)),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.okBtnTap();
                            if (widget.vc.text.isNotEmpty) {
                              int num = int.parse(widget.vc.text);
                              if (num <= story.length && choose_one.isEmpty) {
                                line = num;
                                setState(() {});
                              }
                            }
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
