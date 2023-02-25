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

  //图鉴窗口布局
  buildImageScreen() {
    return Scaffold(
        floatingActionButton: floatButton("image"),
        body: Stack(children: [
          //页面背景
          Container(
            width: 1.sw,
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
          //图鉴布局列表
          Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: SizeCacheWidget(
                  estimateCount: 25,
                  child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          image_map_load();
                        });
                      },
                      child: buildImageList())))
        ]));
  }

  //图鉴列表
  Widget buildImageList() {
    return Scrollbar(
        radius: Radius.circular(20),
        thickness: 8,
        interactive: true,
        child: GridView.count(
            crossAxisCount: 3, // 一行最多显示3张图片
            crossAxisSpacing: 10,
            childAspectRatio: 1 / 1.6,
            padding: EdgeInsets.only(top: 38.h, left: 10.w, right: 10.w),
            //遍历图鉴列表生成布局
            children: imageList.map((imageName) {
              return buildImage(imageName);
            }).toList()));
  }

  //单个图片构成
  Widget buildImage(imageName) {
    String _imageName;
    if (imageMap[imageName]) {
      //是否解锁
      _imageName = imageName;
    } else {
      _imageName = '0';
    }
    return FrameSeparateWidget(
        placeHolder: Text(
          "加载中...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
        child: Container(
            // padding: EdgeInsets.only(bottom: 10.w),
            child: Column(children: [
          GestureDetector(
              //解锁进入查看大图,反之提示未解锁
              onTap: () {
                if (_imageName != '0') {
                  Get.to(buildImageView(_imageName, context));
                } else {
                  EasyLoading.showToast('未解锁',
                      toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
              // child: Image.asset('assets/images/$_imageName.png')),
              child: loadImg(_imageName)),
          Padding(
              //图鉴名字
              padding: EdgeInsets.only(top: 5.h),
              child: Text(
                imageName,
                style: TextStyle(fontSize: 25.sp, color: Colors.white),
              )),
        ])));
  }

  //缓存图片
  Widget loadImg(imageName) {
    if (imageName == '0') {
      return Image.asset('assets/images/0.png');
    } else {
      return CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        imageUrl:
            'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png',
        errorWidget: (context, url, error) => Text(
          '加载失败,请检查网络',
          style: TextStyle(color: Colors.white, fontSize: 30.sp),
        ),
      );
    }
  }
}
