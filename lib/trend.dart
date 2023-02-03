import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:get/get.dart";
import 'package:photo_view/photo_view.dart';
import 'package:boxy/boxy.dart';

import 'config.dart';

class MyBoxy extends BoxyDelegate {
  @override
  Size layout() {
    final header = getChild(#header);
    final content = getChild(#content);
    final avater = getChild(#avater);
    header.layout(constraints);
    content.layout(constraints);
    content.position(header.rect.bottomLeft);
    avater.layout(constraints);
    final middle = header.size.height - avater.size.height / 2;
    final right = header.size.width - avater.size.width / 1.7;
    avater.position(Offset(right, middle));
    return header.size + Offset(0, content.size.height);
  }
}

class TrendPage extends StatefulWidget {
  @override
  TrendPageState createState() => TrendPageState();
}

class TrendPageState extends State<TrendPage> {
  ScrollController _scrollController = ScrollController(); //动态列表控件

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ListView(
          children: [
            CustomBoxy(
              delegate: MyBoxy(),
              children: [
                BoxyId(
                  id: #header,
                  child: ClipRect(
                      child: Container(
                          width: 1.sw,
                          height: 0.5.sh,
                          child: Image.asset(
                            'assets/images/聊天背景.png',
                            fit: BoxFit.cover,
                          ))),
                ),
                BoxyId(
                  id: #content,
                  child: Stack(children: [
                    Container(
                        color: Color.fromRGBO(25, 25, 25, 1),
                        width: 1.sw,
                        height: 1.sh),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Flexible(
                          child: ListView.builder(
                            controller: _scrollController, //绑定控件
                            scrollDirection: Axis.vertical, //垂直滑动
                            reverse: true, //正序显示
                            shrinkWrap: true, //内容适配
                            physics: BouncingScrollPhysics(), //内容超过一屏 上拉有回弹效果
                            itemBuilder: (_, int index) => trends[index],
                            itemCount: trends.length, //item数量
                          ),
                        )),
                  ]),
                ),
                BoxyId(
                  id: #avater,
                  child: Image.asset('assets/icon/头像$nowMikoAvater.png',
                      width: (1 / 9).sw, height: (1 / 9).sw),
                )
              ],
            ),
          ],
        ),
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
                    height: 35,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: FractionalOffset(0.5, 0),
                        child: Text('动态',
                            style: TextStyle(
                                color: Colors.white, fontSize: 25.sp)),
                      )),
                  //返回图标
                  Icon(Icons.chevron_left, color: Colors.white, size: 40),
                ]))),
        Align(
          alignment: FractionalOffset(0.5, 1),
          child: TextButton(
            child: Text('发送', style: TextStyle(color: Colors.white)),
            onPressed: () => newTrend("你好", "S1-01"),
          ),
        )
      ],
    ));
  }

  newTrend(String trendText, String trendImg) {
    Trend trend = Trend(trendText: trendText, trendImg: trendImg);
    setState(() {
      trends.add(trend);
      Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }
}

class Trend extends StatelessWidget {
  final String trendText; //动态文本
  final String trendImg; //动态图鉴
  const Trend({required this.trendText, required this.trendImg});

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: (1 / 48).sh),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Image.asset('assets/icon/头像$nowMikoAvater.png',
                    width: (1 / 13.5).sw, height: (1 / 13.5).sw),
                Padding(
                    padding: EdgeInsets.only(left: (1 / 54).sw),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Miko',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.sp)),
                          Container(
                              width: 1.sw - (1 / 5.4).sw,
                              child: Text(trendText,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.sp)))
                        ]))
              ]),
              Padding(
                  padding: EdgeInsets.only(
                      top: (1 / 96).sh,
                      left: (1 / 10.8).sw,
                      right: (1 / 10.8).sw),
                  child: GestureDetector(
                      onTap: () => Get.to(buildImageView(trendImg)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ClipRect(
                              child: Container(
                                  width: 1.sw - (1 / 5.4).sw,
                                  height: 1.sw - (1 / 5.4).sw,
                                  child: Image.asset(
                                    'assets/images/$trendImg.png',
                                    fit: BoxFit.cover,
                                  ))))))
            ])),
      ],
    );
  }

  buildImageView(imageName) {
    return Container(
        child: Stack(children: [
      PhotoView(imageProvider: AssetImage('assets/images/$imageName.png')),
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
                    color: Colors.white, size: (1 / 13.5).sw),
              ])))
    ]));
  }
}
