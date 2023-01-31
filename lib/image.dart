import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keframe/keframe.dart';
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
        floatingActionButton: floatButton(),
        body: Stack(children: [
          //页面背景
          Container(
            width: 1.sw,
            height: 1.sh,
            child: Image.asset('assets/images/菜单背景.png'),
          ),
          //图鉴布局列表
          Padding(
              padding: EdgeInsets.only(top: (1 / 48).sh),
              child: SizeCacheWidget(
                  estimateCount: 15,
                  child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          loadMap();
                        });
                      },
                      child: GridView.count(
                          crossAxisCount: 3, // 一行最多显示3张图片
                          childAspectRatio: (1.sw / 4) / (1.sh / 5.3), //图片比例
                          padding: EdgeInsets.only(top: (1 / 19.2).sh),
                          //遍历图鉴列表生成布局
                          children: imageList.map((imageName) {
                            return buildImage(imageName);
                          }).toList())))),
          buildMenu("图鉴") //菜单栏
        ]));
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
            padding: EdgeInsets.only(left: (1 / 36).sw, right: (1 / 54).sw),
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
                  child: Image.asset('assets/images/$_imageName.png')),
              Padding(
                  //图鉴名字
                  padding: EdgeInsets.only(top: (1 / 192).sh),
                  child: Text(
                    imageName,
                    style:
                        TextStyle(fontSize: (1 / 27).sw, color: Colors.white),
                  )),
            ])));
  }

  //图片查看
  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(imageProvider: AssetImage('assets/images/$imageName.png')),
      GestureDetector(
          //下载按钮
          onTap: () {
            downloadImage(imageName);
          },
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.download, color: Colors.white, size: (1 / 13).sw),
          )),
      GestureDetector(
          //返回按钮
          onTap: () {
            Get.back();
          },
          child: Container(
              alignment: Alignment.topLeft,
              child: Stack(children: [
                Container(
                  //标题栏
                  color: Colors.black,
                  width: 1.sw,
                  height: (1 / 24).sh,
                ),
                //返回图标
                Icon(Icons.chevron_left,
                    color: Colors.white, size: (1 / 13).sw),
                //图鉴名字
                Container(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: (1 / 96).sh),
                        child: Text(
                          imageName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              decoration: TextDecoration.none),
                        )))
              ])))
    ]));
  }

  //保存图片到本地
  downloadImage(imageName) async {
    if (await checkPermission()) {
      Uint8List imageBytes;
      ByteData bytes = await rootBundle.load('assets/images/$imageName.png');
      imageBytes = bytes.buffer.asUint8List();

      ImageGallerySaver.saveImage(imageBytes);
      Get.snackbar('系统提示', '图片保存成功',
          colorText: Colors.white,
          shouldIconPulse: true,
          duration: Duration(seconds: 2));
    }
  }
}
