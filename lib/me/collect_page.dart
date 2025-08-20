/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../util/colors.dart';
import '../service.dart';

//我的收藏
class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: true);
  }

  ///列表数据
  List<Map> collectList = [];
  bool isLoading = true;
  bool hasError = false;
  bool hasMore = true;
  int currentPage = 1;
  
  Future<void> getListData({int page = 1, bool isRef = false}) async {
    if (isRef) {
      setState(() {
        isLoading = true;
        hasError = false;
        currentPage = 1;
      });
    }
    
    try {
      var res = await BService.collectList(page);
      if (res.isNotEmpty) {
        setState(() {
          if (isRef) {
            collectList = List<Map>.from(res['data'] ?? []);
          } else {
            collectList.addAll(List<Map>.from(res['data'] ?? []));
          }
          hasMore = collectList.length < (res['total'] ?? 0);
          isLoading = false;
          hasError = false;
          currentPage = page;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '我的收藏',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    if (isLoading && collectList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (hasError && collectList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('网络异常'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: ListView.separated(
        itemCount: collectList.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 0),
        itemBuilder: (context, index) {
          if (index >= collectList.length) {
            // 加载更多指示器
            if (hasMore && !isLoading) {
              // 触发加载更多
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getListData(page: currentPage + 1);
              });
            }
            return hasMore
                ? Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : SizedBox();
          }
          
          var data = collectList[index];
          String createTime = data['createTime'];
          return Semantics(
            explicitChildNodes: true,
            child: StickyHeader(
              header: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF242526)
                    : Color(0xFFFAFAFA),
                padding: const EdgeInsets.only(left: 16.0),
                height: 34.0,
                child: Text(createTime.split(' ').first),
              ),
              content: createItem(index, data),
            ),
          );
        },
      ),
    );
  }





  Widget createItem(int i, Map data) {
    String startPrice = data['startPrice'];
    if (startPrice == '0' || startPrice == '') {
      startPrice = '';
    } else {
      startPrice = '￥$startPrice';
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(12),
      child: InkWell(
        onTap: () {
          jumpDetail(data);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  data['img'] ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ]),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/mall/${data['category']}.png',
                          width: 14,
                          height: 14,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(width: 14, height: 14);
                          },
                        ),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data['title'] ?? '',
                          style: TextStyle(
                            color: Colors.black.withValues(alpha: 0.75),
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '¥',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '${data['endPrice']}',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ',
                          style: TextStyle(
                            color: Colours.app_main,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: startPrice,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  jumpDetail(data) {
    String category = data['category'];
    String link = '/detail';
    if(category == 'tb') {
      link = '/detail';
    }else if(category == 'jd') {
      link = '/detailJD';
    }else if(category == 'pdd') {
      link = '/detailPDD';
    }else if(category == 'dy') {
      link = '/detailDY';
    }else if(category == 'vip') {
      link = '/detailVIP';
    }
    Navigator.pushNamed(context, link, arguments: data);
  }
}
