import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? local; //本地存储数据

///检查权限
checkPermission(Permission permission) async {
  PermissionStatus status = await permission.status;
  if (status.isGranted) {
    //权限通过
  } else if (status.isDenied) {
    //权限拒绝
    requestPermission(permission);
  } else if (status.isPermanentlyDenied) {
    //权限永久拒绝，且不在提示，需要进入设置界面
    openAppSettings();
  } else if (status.isRestricted) {
    //活动限制
    openAppSettings();
  } else {
    //第一次申请
    requestPermission(permission);
  }
}

///申请权限
requestPermission(Permission permission) async {
  //发起权限申请
  PermissionStatus status = await permission.request();
  // 返回权限申请的状态 status
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
}

fromJsonString(String jsonString) {
  final Info = jsonDecode(jsonString);
  return Info;
}
