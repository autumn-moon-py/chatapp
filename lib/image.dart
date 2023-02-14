import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'menu.dart';
import 'config.dart';

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
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png', fit: BoxFit.cover),
          ),
          //图鉴布局列表
          Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: SizeCacheWidget(
                  estimateCount: 20,
                  child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          loadMap();
                        });
                      },
                      child: buildImageList())))
        ]));
  }

  //图鉴列表
  Widget buildImageList() {
    return GridView.count(
        crossAxisCount: 3, // 一行最多显示3张图片
        crossAxisSpacing: 10,
        childAspectRatio: 1 / 1.6,
        padding: EdgeInsets.only(top: 38.h, left: 10.w, right: 10.w),
        //遍历图鉴列表生成布局
        children: imageList.map((imageName) {
          return buildImage(imageName);
        }).toList());
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
                  Get.to(buildImageView(_imageName));
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

  //图片查看
  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(
          loadingBuilder: (context, event) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '第一次加载可能缓慢,请耐心等待',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 30.sp),
                            )))
                  ]),
          errorBuilder: (context, error, stackTrace) => Text(
                '加载失败,请检查网络',
                style: TextStyle(color: Colors.black, fontSize: 30.sp),
              ),
          imageProvider: NetworkImage(
              'https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png')),
      GestureDetector(
          //下载按钮
          onTap: () {
            downloadImage(imageName);
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.download, color: Colors.white, size: 50.r),
          )),
      Container(
          alignment: Alignment.topLeft,
          child: Stack(children: [
            Container(
              //标题栏
              color: Colors.black,
              width: 540.w,
              height: 50.h,
            ),
            //返回图标
            GestureDetector(
                onTap: () {
                  Get.back();
                },
                child:
                    Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
          ]))
    ]));
  }

  //保存资源图片到本地
  // saveImage(imageName) async {
  //   if (await checkPermission(Permission.storage)) {
  //     Uint8List imageBytes;
  //     ByteData bytes = await rootBundle.load('assets/images/$imageName.png');
  //     imageBytes = bytes.buffer.asUint8List();
  //     ImageGallerySaver.saveImage(imageBytes);
  //     Get.snackbar('系统提示', '图片保存成功',
  //         colorText: Colors.white,
  //         shouldIconPulse: true,
  //         duration: Duration(seconds: 2));
  //   }
  // }

  //下载网络图片
  downloadImage(imageName) async {
    Get.snackbar('系统提示', '图片下载中',
        colorText: Colors.white,
        shouldIconPulse: true,
        duration: Duration(seconds: 2));
    String imgUrl =
        "https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png";
    bool check = false;
    if (Platform.isAndroid) {
      check = checkPermission(Permission.storage);
    } else {
      check = checkPermission(Permission.photos);
    }

    if (check) {
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100);
      if (result['isSuccess']) {
        Get.snackbar('系统提示', '图片已下载',
            colorText: Colors.white,
            shouldIconPulse: true,
            duration: Duration(seconds: 2));
      } else {
        Get.snackbar('系统提示', '图片下载失败,请检查网络',
            colorText: Colors.white,
            shouldIconPulse: true,
            duration: Duration(seconds: 2));
      }
    } else {
      Get.snackbar('系统提示', '获取权限失败,无法下载',
          colorText: Colors.white,
          shouldIconPulse: true,
          duration: Duration(seconds: 2));
    }
  }
}
