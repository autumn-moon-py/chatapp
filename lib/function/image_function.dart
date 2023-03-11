import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

import '../config/config.dart';

//图片查看
buildImageView(String imageName, BuildContext context) {
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 30.sp),
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
            alignment: Alignment.center,
            child: Text(imageName,
                style: TextStyle(color: Colors.white, fontSize: 25.sp)),
          ),
          //返回图标
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.chevron_left, color: Colors.white, size: 50.r)),
        ]))
  ]));
}

//下载网络图片
downloadImage(imageName) async {
  Get.snackbar('系统提示', '图片下载中',
      colorText: Colors.white,
      shouldIconPulse: true,
      duration: Duration(seconds: 2));
  String imgUrl =
      "https://cdn.486486486.xyz/miko-storage/Dimension/ver0.1/$imageName.png";
  checkPermission(Permission.storage);
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
}
