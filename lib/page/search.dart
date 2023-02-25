import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/chat_config.dart';
import '../config/setting_config.dart';
import '../function/chat_function.dart';

List<List<dynamic>> story_copy = []; //搜索剧本列表

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List searchResultList = [];
  final searchController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  void _search() {
    String searchText = searchController.text;
    if (searchText.isEmpty) {
      setState(() {
        searchResultList = [];
      });
      return;
    }
    RegExp regExp = RegExp(searchText);
    List searchResult = [];
    for (int i = 0; i < story_copy.length; i++) {
      if (regExp.hasMatch(story_copy[i][1].toString())) {
        searchResult.add([i, story_copy[i][1]]);
      }
    }
    setState(() {
      searchResultList = searchResult;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: topHeight),
        child: Column(
          children: [
            Stack(children: [
              Container(
                color: Colors.blue,
                width: 1.sw,
                height: 50.h,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text('剧本搜索',
                          style: TextStyle(
                              color: Colors.white, fontSize: 25.sp)))),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.chevron_left,
                      color: Colors.white, size: 50.r)),
            ]),
            Row(
              children: [
                CoolDropdown(
                  resultWidth: 160.w,
                  dropdownList: [
                    {'label': '第一章', 'value': '第一章'},
                    {'label': '番外一', 'value': '番外一'},
                    {'label': '第二章', 'value': '第二章'},
                    {'label': '番外二', 'value': '番外二'},
                    {'label': '第三章', 'value': '第三章'},
                    {'label': '番外三', 'value': '番外三'},
                    {'label': '第四章', 'value': '第四章'},
                    {'label': '第五章', 'value': '第五章'},
                    {'label': '第六章', 'value': '第六章'}
                  ],
                  onChange: (dropdownItem) {
                    story = [];
                    loadCVS(dropdownItem['value']);
                  },
                  defaultValue: {'label': '第一章', 'value': '第一章'},
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value == '') {
                        setState(() {
                          searchResultList = [];
                        });
                      }
                      if (value.length >= 70) {
                        searchController.text = '搜索字符不能大于70个';
                        Future.delayed(Duration(seconds: 1), () {
                          searchController.text = '';
                        });
                      }
                    },
                    onSubmitted: (value) {
                      if (value != '') {
                        setState(() {
                          _search();
                        });
                      }
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: '输入要搜索的对话',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ],
            ),
            Expanded(
              child: searchResultList.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: searchResultList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                                '行号: ${searchResultList[index][0]} 内容: ${searchResultList[index][1]}'));
                      },
                    ),
            ),
          ],
        ));
  }
}
