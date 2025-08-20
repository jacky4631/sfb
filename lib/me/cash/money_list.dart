/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:sufenbao/service.dart';

import '../../util/colors.dart';

///余额明细
class MoneyList extends StatelessWidget {
  final Map data;
  const MoneyList(this.data, {Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((data['title'] == null) ? '资金明细' : data['title']),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TopChild(data),
      ),
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
  List<Map> listData = [];
  bool isLoading = false;
  bool hasError = false;
  bool hasMore = true;
  int totalElements = 0;
  int currentPage = 1;

  Future<int> getListData({int page = 1, bool isRef = false}) async {
    if (isLoading) return 0;
    
    setState(() {
      isLoading = true;
      hasError = false;
    });
    
    try {
      String type = widget.data['type']??'';
      String platform = widget.data['platform']??'';
      var unlockStatus = widget.data['unlockStatus'];
      var res = await BService.moneyList(page, category: 'now_money', type: type, platform: platform, unlockStatus: unlockStatus);
      
      if (res != null && res['data'] != null) {
        List<Map> newData = List<Map>.from(res['data']);
        
        if (isRef) {
          listData = newData;
          currentPage = 1;
        } else {
          listData.addAll(newData);
        }
        
        totalElements = res['total'] ?? 0;
        hasMore = listData.length < totalElements;
        currentPage = page;
      }
      
      setState(() {
        isLoading = false;
      });
      
      return hasMore ? 1 : 0;
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    if (isLoading && listData.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colours.app_main),
      );
    }

    if (hasError && listData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('加载失败，请重试'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => getListData(isRef: true),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => getListData(isRef: true),
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: listData.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        itemBuilder: (context, index) {
          if (index >= listData.length) {
            if (isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (hasMore) {
              // 自动加载更多
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getListData(page: currentPage + 1);
              });
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          int i = index;
            var data = listData[i];
            String type = data['type'];
            String isPlus = (type == 'gain' || type== 'retail' || type == 'upgrade' || type=='system_add') ? '+' : '-';
            num changeIntegral = data['number'];
            num unlockStatus = data['unlockStatus']??0;
            String unlockStatusStr = '';
            Color statusColor = Colors.black38;
            //如果是提现不显示状态
            if(type != 'extract') {
              if(unlockStatus == 1) {
                unlockStatusStr = '待解锁';
                statusColor = Colors.red;
              } else if (unlockStatus == 0) {
                unlockStatusStr = '已结算';
                statusColor = Colors.green;
              } else {
                unlockStatusStr = '已失效';
              }
            }
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['title'],
                                style: TextStyle(
                                   color: Colors.black.withValues(alpha: 0.75),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '$isPlus${changeIntegral}元',
                              style: TextStyle(
                                 color: Colors.red.withValues(alpha: 0.75),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              data['createTime'],
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              unlockStatusStr,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if(unlockStatus == 1)
                          Text(
                            '解锁时间：${data['unlockTime']}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${data['mark']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          strutStyle: const StrutStyle(
                            forceStrutHeight: true,
                            height: 1,
                            leading: 0.9,
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[200],
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
