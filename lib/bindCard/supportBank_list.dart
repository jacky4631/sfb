/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
import 'package:flutter/material.dart';

import '../service.dart';

class SupportBankList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('支持银行'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ChildWidget(),
    );
  }
}

class ChildWidget extends StatefulWidget {
  @override
  _ChildWidget createState() => _ChildWidget();
}

class _ChildWidget extends State<ChildWidget> {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map> _bankList = [];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      );
    }
    
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败'),
            ElevatedButton(
              onPressed: () => getListData(),
              child: Text('重试'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _bankList.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        var data = _bankList[index];
        var bankName = data['bankName'];
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 30),
                  Expanded(
                    child: Text(
                      bankName,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.75),
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    await getListData();
  }

  Future<void> getListData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
      
      List res = await BService.supportBank();
      res = res.where((element) => element['supportDebitCard'] == 'Y').toList();
      
      setState(() {
        _bankList = res.cast<Map>();
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }
}
