/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */

import 'package:flutter/material.dart';
import 'package:sufenbao/me/fans/fans_util.dart';
import 'package:sufenbao/service.dart';

import '../../util/global.dart';
//我的粉丝的粉丝
class FansDetailPage extends StatelessWidget {
  final Map data;
  const FansDetailPage(this.data, {Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${data['showName']}的用户'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: TopChild(data),
    );
  }
}

class TopChild extends StatefulWidget {
  final Map data;
  const TopChild(this.data, {Key? key,}) : super(key: key);

  @override
  _TopChildState createState() => _TopChildState();
}

class _TopChildState extends State<TopChild> {
  List<Map> fansList = [];
  bool loading = true;
  bool hasNext = true;
  int currentPage = 1;
  
  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        loading = true;
        currentPage = 1;
      });
    }
    
    var res = await BService.fans(page, uid: widget.data['uid']);
    if (res != null) {
      List<Map> newList = List<Map>.from(res['data']['list'] ?? []);
      if (isRef) {
        fansList = newList;
      } else {
        fansList.addAll(newList);
      }
      hasNext = newList.isNotEmpty && fansList.length < (res['data']['total'] ?? 0);
      currentPage = page;
    }
    
    setState(() {
      loading = false;
    });
    return hasNext ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    if (loading && fansList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    
    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 72),
        itemCount: fansList.length + (hasNext ? 1 : 0),
        separatorBuilder: (context, index) => Divider(height: 1),
        itemBuilder: (context, i) {
          if (i >= fansList.length) {
            // 加载更多指示器
            if (hasNext && !loading) {
              getListData(page: currentPage + 1);
            }
            return Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: loading ? CircularProgressIndicator() : SizedBox.shrink(),
            );
          }
          
          Map data = fansList[i];
          String phone = data['phone']??'';
          if(!Global.isEmpty(phone)) {
            phone = phone.replaceAll(phone.substring(3,7),"****");
          }
          String nickname = data['nickname'];
          if(nickname.isNotEmpty && Global.isPhone(nickname)) {
            nickname = nickname.replaceAll(nickname.substring(3,7), '****');
          }
          String showName = nickname.isEmpty ? phone : nickname;
          data['showName'] = showName;
          String feeStr = getFansFee(data['fee']??'0');

          String updateTime = data['updateTime'];
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${data['avatar']}',
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 88,
                        height: 88,
                        color: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey),
                      );
                    },
                  ),
                ),
                SizedBox(width: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         showName,
                         style: TextStyle(
                           color: Colors.black.withValues(alpha: 0.75),
                           fontSize: 16,
                         ),
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                       ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/feeTabPage', arguments: data);
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '近30天预估  ',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                              TextSpan(
                                text: feeStr,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '最近登录  ',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            TextSpan(
                              text: updateTime,
                              style: TextStyle(color: Colors.black45, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
