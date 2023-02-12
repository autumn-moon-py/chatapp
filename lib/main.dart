import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'chat.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(540, 960),
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
            home: GetMaterialApp(
                home: ChatScreen(),
                debugShowCheckedModeBanner: false,
                builder: EasyLoading.init()),
            debugShowCheckedModeBanner: false);
      },
    );
  }
}

class ChatScreen extends StatelessWidget {
  // GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChatPage());
  }
}
