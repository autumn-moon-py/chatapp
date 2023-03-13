import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../config/image_config.dart';
import '../config/setting_config.dart';
import '../function/image_function.dart';
import 'menu.dart';

class ImagePage extends StatefulWidget {
  @override
  ImagePageState createState() => ImagePageState();
}

class ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return buildImageScreen();
  }

  buildImageScreen() {
    return Scaffold(
        floatingActionButton: floatButton("image"),
        body: Stack(children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SizeCacheWidget(
                  estimateCount: 25,
                  child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          image_map_load();
                        });
                      },
                      child: buildImageList()))),
          //调试信息
          Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Center(
                  child: Wrap(children: [
                Text(isDebug ? '$imageMap' : '',
                    style: TextStyle(color: Colors.red, fontSize: 25.r))
              ]))),
        ]));
  }

  ///图鉴列表
  Widget buildImageList() {
    return Scrollbar(
        interactive: true,
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 1 / 1.6,
            padding: EdgeInsets.only(top: 38.h, left: 10.w, right: 10.w),
            children: isNewImage
                ? imageList2.map((imageName) {
                    return buildImage(imageName);
                  }).toList()
                : imageList1.map((imageName) {
                    return buildImage(imageName);
                  }).toList()));
  }

  ///单个图片构成
  Widget buildImage(imageName) {
    String _imageName;
    if (imageMap[imageName]) {
      _imageName = imageName;
    } else {
      _imageName = '0';
    }
    return FrameSeparateWidget(
        placeHolder: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: Colors.white)),
        child: Column(children: [
          GestureDetector(
              onTap: () {
                if (_imageName != '0') {
                  Get.to(buildImageView(_imageName));
                } else {
                  EasyLoading.showToast('未解锁',
                      toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
              child: loadImg(_imageName)),
          Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                imageName,
                style: TextStyle(fontSize: 25.sp, color: Colors.white),
              )),
        ]));
  }

  ///缓存图片
  Widget loadImg(imageName) {
    if (imageName == '0') {
      return Image.asset('assets/images/0.png');
    } else {
      return CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        width: 160.w,
        height: 220.w,
        imageUrl:
            'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png',
        errorWidget: (_, url, error) => Text(
          '加载失败, $error',
          style: TextStyle(color: Colors.white, fontSize: 30.sp),
        ),
      );
    }
  }
}
