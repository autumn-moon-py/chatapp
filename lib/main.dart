import 'package:chatapp/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'chat.dart';
import 'config.dart';
import 'trend.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(540, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
            home: ChatScreen(),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init());
      },
    );
  }
}

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    loadMessage();
    load();
    loadMap();
    loadtrend();
    Future.delayed(Duration(milliseconds: 100), () {
      Get.to(ChatPage());
    });
    return Container();
  }
}
