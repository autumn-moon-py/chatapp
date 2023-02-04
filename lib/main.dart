import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'chat.dart';
import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notification.init();
  runApp(MyApp()
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp()
      // )
      );
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
            // useInheritedMediaQuery: true,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatPage(),
    );
  }
}
