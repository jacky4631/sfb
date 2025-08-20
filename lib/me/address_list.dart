/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../util/colors.dart';
import '../service.dart';

class AddressList extends StatefulWidget {
  final Map data;

  const AddressList({Key? key, required this.data}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  late List addressList = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await getListData(isRef: false);
  }

  Future<int> getListData({int page = 1, bool isRef = true}) async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });
      
      addressList = await BService.addressList();
      
      setState(() {
        isLoading = false;
      });
      return 1;
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('地址管理'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          createHomeChild(context),
          btmBarView(context),
        ],
      ),
    );
  }

  ///底部操作栏
  Widget btmBarView(BuildContext context) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, MediaQuery.of(context).padding.bottom + 8),
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/createAddress').then((value) {
              getListData(isRef: true);
            });
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colours.app_main,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '新建收获地址',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget createHomeChild(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败'),
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
        padding: const EdgeInsets.all(12),
        itemCount: addressList.length,
        separatorBuilder: (context, index) => const Divider(height: 12, color: Colors.transparent),
        itemBuilder: (context, i) {
          Map data = addressList[i] as Map;
          return Slidable(
            key: ValueKey(data['id']),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    BService.addressDefaultSet(data['id']).then((value) => getListData(isRef: true));
                  },
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  label: '设为默认',
                ),
                SlidableAction(
                  onPressed: (context) {
                    BService.addressDel(data['id']).then((value) => getListData(isRef: true));
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: '删除',
                ),
              ],
            ),
            child: createItem(data),
          );
        },
      ),
    );
  }

  Widget createItem(data) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context, data),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        data['province'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),
                      if (data['province'] != data['city']) ...[
                        SizedBox(width: 2),
                        Text(
                          data['city'],
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontSize: 14,
                          ),
                        ),
                      ],
                      SizedBox(width: 2),
                      Text(
                        data['district'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    data['detail'],
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.75),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        data['realName'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        data['phone'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                      SizedBox(width: 8),
                      if (data['isDefault'] == 1)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colours.app_main,
                            border: Border.all(color: Colours.app_main, width: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '默认',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/createAddress', arguments: data)
                .then((value) => getListData(isRef: true));
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }
}

